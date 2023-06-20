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

/**
 * Provides safe encapsulation of `udev_device*`
 */
public struct Device
{

    @disable this();

    /**
     * Copy this device from another
     *
     * Params:
     *   other = The other device
     */
    this(ref Device other) @trusted
    {
        this.handle = udev.binding.udev_device_ref(other.handle);
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

private:

    udev.binding.udev_device* handle;
}
