/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * udev.enumerator
 *
 * Enumeration of devices
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module udev.enumerator;

static import udev.binding;

import udev.context : Context;
import udev.device : Device;
import udev.exc;
import std.exception : enforce;

/**
 * Sanely enumerate devices on the udev subsystems
 */
public struct Enumerator
{

    @disable this();

    invariant ()
    {
        //assert(handle !is null, "udev.Enumerator: Missing handle");
    }

    /**
     * Cleanup the enumerator
     */
    ~this() @trusted
    {
        if (handle !is null)
        {
            handle = udev.binding.udev_enumerate_unref(handle);
        }
    }

    /**
     * Return an iterator for the discovered devices
     */
    auto opSlice() @trusted => Iterator!Device(
            udev.binding.udev_enumerate_get_list_entry(handle), this);

    auto ref scanDevices() @trusted
    {
        immutable ret = udev.binding.udev_enumerate_scan_devices(handle);
        enforce!UdevException(ret >= 0);
        return this;
    }

package:

    /**
     * Construct a new Enumerator from the given handle
     *
     * Params:
     *   handle = Underlying udev resource
     */
    this()(auto ref Context parentContext, udev.binding.udev_enumerate* handle) @trusted
    {
        this.parentContext = Context(parentContext);
        this.handle = udev.binding.udev_enumerate_ref(handle).enforce!UdevException;
    }

    /**
     * Copy from another enumerator
     *
     * Params:
     *   other = Instantiated enumerator
     */
    this()(auto ref Enumerator other) @trusted
    {
        this.handle = udev.binding.udev_enumerate_ref(other.handle).enforce!UdevException;
    }

private:

    Context parentContext;
    udev.binding.udev_enumerate* handle;
}

auto enumerator()(auto ref Context context) @trusted => Enumerator(context,
        udev.binding.udev_enumerate_new(context.handle).enforce!UdevException);

@("Test enumeration")
@safe unittest
{
    import udev.context;
    import std.stdio : writeln;

    foreach (d; context.enumerator.scanDevices)
    {
        d.path.writeln;
        d.name.writeln;
    }
}

/**
 * A specialist iterator for udev lists
 * Note: Currently locked to devices
 */
package struct Iterator(T) if (is(T : Device))
{

    auto empty() => list is null;
    auto popFront() @trusted => list = udev.binding.udev_list_entry_get_next(list);

    /**
     * Returns the front node of the list
     */
    T front() @trusted
    {
        auto frontNode = udev.binding.udev_list_entry_get_name(list);
        static if (is(T : Device))
        {
            auto handle = udev.binding.udev_device_new_from_syspath(parentEnum.parentContext.handle,
                    frontNode).enforce!UdevException;
            return T(handle);
        }
        else
            static assert(0, "wtf");
    }

private:

    udev.binding.udev_list_entry* list;
    Enumerator parentEnum;
}
