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

import udev.device : Device;
import udev.exc;
import std.exception : enforce;

/**
 * Sanely enumerate devices on the udev subsystems
 */
public struct Enumerator
{

    @disable this();

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
    auto opSlice() @trusted => Iterator!Device(udev.binding.udev_enumerate_get_list_entry(handle));

package:

    /**
     * Construct a new Enumerator from the given handle
     *
     * Params:
     *   handle = Underlying udev resource
     */
    pure this(udev.binding.udev_enumerate* handle) @safe
    {
        this.handle = handle;
    }

    /**
     * Copy from another enumerator
     *
     * Params:
     *   other = Instantiated enumerator
     */
    this(ref Enumerator other) @trusted
    {
        this.handle = udev.binding.udev_enumerate_ref(other.handle).enforce!UdevException;
    }

    udev.binding.udev_enumerate* handle;
}

@("Test enumeration")
@safe unittest
{
    import udev.context;
    import std.stdio : writeln;

    foreach (device; context.enumerator[])
    {
        device.writeln;
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
        auto frontNode = udev.binding.udev_list_entry_get_value(list);
        static if (is(T : Device))
        {
            auto handle = udev.binding.udev_device_new_from_syspath(context,
                    frontNode).enforce!UdevException;
            return T(handle);
        }
        else
            static assert(0, "wtf");
    }

private:

    udev.binding.udev_list_entry* list;
    udev.binding.udev* context;
}
