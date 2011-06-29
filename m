From: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Wed, 29 Jun 2011 09:42:03 -0700
Message-ID: <BANLkTi=58YQa2Fn6jXg1zQhCMhdGVipNew@mail.gmail.com>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39397 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab1F2QmE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2011 12:42:04 -0400
Received: by vxb39 with SMTP id 39so1007556vxb.19
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2011 09:42:04 -0700 (PDT)
In-Reply-To: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I now have Fedora 15 (with selinux enabled) up and running from a
loop-aes-encrypted root partition. In case it can prove useful to
someone else running Fedora 15 (and/or some other systemd based linux)
I will describe what I have done and the status of my issues here.

The details (WARNING: LONG!!)...

Motherboard: Foxconn Mars (Intel p35 chipset)
Processor: Core2Duo E8400
OS: Fedora 15 with selinux enabled
kernel: linux-2.6.39 (kernel.org)
loop-aes-v3.6c
aespipe-v2.4c
util-linux-2.19.1 (kernel.org)
util-linux-2.19.1-20110510.diff
build-initrd.sh-20110531

After installing Fedora, the new kernel was downloaded and configured
per the loop-aes README. Installation of loop-aes and util-linux
proceeded without issue and I was able to mount and access my
(previously created) encrypted devices. The swap partition was also
encrypted at this point.

Moving on to encrypting the root partition...

Initially I was unable to boot into the encrypted root with the
build-initrd.sh found in the loop-aes-v3.6c archive, but this was
resolved very quickly with the modified script provided by Jari (thank
you Jari!). (In retrospect, I can't be certain that the original
script wouldn't have worked, because my hard disk was in the process
of failing and that may have been part, if not all, of the problem; I
have not gone back to check.)

The configuration options for build-initrd.sh-20110531 were:

USEDEVFS=0
USEPIVOT=2
BOOTDEV=/dev/sda1
BOOTTYPE=ext4
CRYPTROOT=/dev/sda2
ROOTTYPE=ext4
CIPHERTYPE=AES128
LOINIT="-I 0"
USEGPGKEY=1
GPGKEYFILE=key.gpg
EXTERNALGPGFILES=0
EXTERNALGPGDEV=/dev/fd0
EXTERNALGPGTYPE=ext2
USEMODULE=1
INITRDONLY=0
SOURCEROOT=
DESTINATIONROOT=
DESTINATIONPREFIX=/boot
INITRDGZNAME=initrd-loopaes.gz
ROOTLOOPINDEX=2
TEMPLOOPINDEX=7
LOOPMODPARAMS="max_loop=16"
UTF8KEYBMODE=0
LOADNATIONALKEYB=0
INITMD=1
INITMDDELAY=1
INITIALDELAY=0
MOUNTDELAY=0
TOOLSPROMPT=0
USEROOTSETUP=0
USEDIETLIBC=1
GCC=gcc
EXTRACOMMANDSTR1=1
EXTRACOMMANDSTR1="/sbin/losetup -e AES128 -P hkey.txt /dev/loop3 /dev/sda3"
EXTRACOMMANDRUN2=1
EXTRACOMMANDSTR2="/sbin/losetup -e AES128 -P skey.txt /dev/loop5 /dev/sda5"


The grub boot entry is:

title Fedora 15 encrypted (2.6.39)
        root (hd0,0)
        kernel /vmlinuz-2.6.39
        initrd /initrd-loopaes.gz

NOTE: The vmlinuz-2.6.39 had to be a file, not a symbolic link as set
up by the kernel 'make install' routine, or grub would fail.

The fstab entries are:

/dev/loop2      /          ext4    defaults        0 1
/dev/loop3      /home      ext4    defaults        0 2
/dev/sda5       swap       swap    sw,loop=/dev/loop5,encryption=AES128   0 0

In order to boot successfully I also had to create static nodes for a
number of devices in /dev:

mknod -m 660 /dev/tty c 5 0
mknod -m 660 /dev/console c 5 1
mknod -m 660 /dev/sda2 b 8 2       ## encrypted root
mknod -m 660 /dev/sda3 b 8 3       ## encrypted home
mknod -m 660 /dev/loop2 b 7 2
mknod -m 660 /dev/loop3 b 7 3


I also added these static nodes at some point, but can't recall when
or if they were actually required to boot successfully:

mknod -m 666 /mnt/dev/null c 1 3
mknod -m 666 /mnt/dev/zero c 1 5

I was able to boot successfully at this point, with the issue that the
swap partition was being added, but did not appear to be encrypted (as
shown by no entry for /dev/loop5 using losetup -a). This could be
corrected after boot by issuing the commands 'swapoff -a' and 'swapon
-a'.

In an attempt to address this I added static nodes to /dev

mknod -m 660 /dev/sda5 b 8 5       ## encrypted swap
mknod -m 660 /dev/loop5 b 7 5

...but this did not help. (My further attempts to troubleshoot this
with Jari's help are omitted here as they are covered in another part
of this discussion.)

I then attempted to encrypt and mount /home.  The following static
nodes were added to /dev:

mknod -m 660 /dev/sda3 b 8 3      ## encrypted /home
mknod -m 660 /dev/loop3 b 7 3

Like the swap partition, the loop device is properly losetup'd at
boot, but attempts to mount to it timeout during boot and are
unsuccessful.

So, the remaining issues I am attempting to resolve are:

1) Devices losetup'd at boot, even within the initrd built by Jari's
new script, do not get mounted by the Fedora init scripts. This
requires me to manually add swap and mount /home before logging in. I
would like to figure this out, but it is really only a minor annoyance
as I only reboot occassionally.

2) Once I have losetup'ed and mount'ed a loop device (defined in
/etc/fstab), umount'ing it fails to detach the loop device, and
attempts to 'losetup -d' it manually fail with the error 'ioctl:
LOOP_CLR_FD: Device or resource busy'.

3) Although selinux is otherwise running/behaving properly,
autorelabeling (of /home, /dev, /sys /run) fails at boot time; the
system does boot successfully though.

4) Rebooting my (external) router causes all mounted loop devices,
other than / and swap, to be umounted. I was able to fix this problem
in Fedora 13 (in which case the loop devices also became detached) by
disabling netfs, but that was kind of drastic and I'm hoping to avoid
it this time around.

So that is the current state of play and the issues I am currently
working to resolve. I am reasonably certain at this point that the
issues are related to Fedora 15 and the systemd init process, _not_
loop-aes. I will post back if/when I make some progress.

FG
