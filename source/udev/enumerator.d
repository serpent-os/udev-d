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
        this.handle = udev.binding.udev_enumerate_ref(other.handle);
    }

    udev.binding.udev_enumerate* handle;
}

@("Test enumeration")
@safe unittest
{
    import udev.context;

    auto devices = context.enumerator;
}
