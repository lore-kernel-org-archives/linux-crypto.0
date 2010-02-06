From: Milan Broz <mbroz@redhat.com>
Subject: Re: device-mapper: remove ioctl failed: device or resource busy
Date: Sat, 06 Feb 2010 21:13:12 +0100
Message-ID: <4B6DCD58.5010102@redhat.com>
References: <f3566d61002051932n4f2a30cx4e4f0e962af25a37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Bai Shuwei <baishuwei@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab0BFUNQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2010 15:13:16 -0500
In-Reply-To: <f3566d61002051932n4f2a30cx4e4f0e962af25a37@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/06/2010 04:32 AM, Bai Shuwei wrote:
>    I port the xts-aes algorithm to FPGA board and use it to
> encrypt/decrypt the disc.  i will get the bellow information
> 
>    But when excute the bellow commands
>    cryptsetup luksFormat -c aes-xts-plain -s 256 /dev/loop0
>   or
>    cryptsetup luksOpen /dev/loop0 test0
> 
>    I get the bellow information
>    ....
>    device-mapper: remove ioctl failed: device or resource busy


Probably some udev rule triggers scan on temporary keyslot device.
This is known problem with some badly written udev rules and old versions
of DevKit-disks (recent version should not touch these internal devices at all).

Use cryptsetup 1.1.0 and run it with --debug to get more info, also see syslog (there
will be exact information which device was busy, I expect temp-cryptsetup*...)
(It will retry after 1 sec anyway, so it usually works - see that debug log.)

This is not kernel problem at all, just userspace race between some asynchronous
device scan triggered from udev (usually blkid check) and cryptsetup.

Milan
