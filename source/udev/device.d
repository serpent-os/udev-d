/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * udev.device
 *
 * Access to udev devices
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module udev.device;

static import udev.binding;

import udev.exc;
import std.exception : enforce;

/**
 * Provides safe encapsulation of `udev_device*`
 */
public struct Device
{

    @disable this();

    invariant ()
    {
        assert(handle !is null, "udev.Device: Missing handle");
    }

    /**
     * Copy this device from another
     *
     * Params:
     *   other = The other device
     */
    this(ref Device other) @trusted
    {
        this.handle = udev.binding.udev_device_ref(other.handle).enforce!UdevException;
    }

    /**
     * Handle destruction gracefully
     */
    ~this() @trusted
    {
        if (handle !is null)
        {
            handle = udev.binding.udev_device_unref(handle);
        }
    }

package:

    pure this(udev.binding.udev_device* handle) @safe
    {
        this.handle = handle;
    }

    udev.binding.udev_device* handle;
}
