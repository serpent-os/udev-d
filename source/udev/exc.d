/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * udev.exc
 *
 * Exceptions for udev
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module udev.exc;

public import std.exception : enforce;
import std.exception : basicExceptionCtors;

public class UdevException : Exception
{
    mixin basicExceptionCtors;
}
