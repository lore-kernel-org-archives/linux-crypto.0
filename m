From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Tue, 31 May 2011 15:59:16 +0300
Message-ID: <4DE4E624.CCA18200@users.sourceforge.net>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:42455 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab1EaM7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2011 08:59:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Frederick Gazerblezeebe wrote:
> I am trying to set up a Fedora 15 system (kernel 2.6.39) on which the
> root filesystem is encrypted with loop-aes (v3.6c).
> 
> Can someone suggest the best location to place the initial losetup
> commands? This new version uses the systemd boot stuff and
> /etc/rc.d/rc.sysinit (where I placed the losetup commands before) no
> longer exists. I was partially successful placing them in
> /lib/systemd/fedora-readonly, meaning losetup successfully sets up the
> loop device, but attempts to actually mount a file system on this loop
> fail and the boot process terminates. I think I may be placing the
> losetup too late in the sequence and the system is attempting to mount
> on the loop before it is actually set up, but that's just a guess at
> this point.

I am assuming you used loop-AES' build-initrd.sh script. I changed the
script so that it can be configured to set up more loop devices than the one
used by encrypted root partition. For example, if you want to set up
"no password entering required" /dev/loop6 and /dev/loop4, you can add these
lines to build-initrd.sh config:

EXTRACOMMANDRUN1=1
EXTRACOMMANDSTR1="/sbin/losetup -e AES128 -P /etc/cleartextkey-loop6.txt /dev/loop6 /dev/sda3"
EXTRACOMMANDRUN2=1
EXTRACOMMANDSTR2="/sbin/losetup -e AES128 -P /etc/cleartextkey-loop4.txt /dev/loop4 /dev/sdd12"

Limitations/rules:
1) Commands are run after switching to encrypted root but before starting
   /sbin/init
2) Encrypted root partition is mounted read-only. Other file systems are not
   mounted.
3) udev is not running yet, so dynamic device nodes on tmpfs (created and
   mounted by udev on top of /dev directory) are not available.
4) If commands need /dev/* device nodes, you must make sure that static
   device nodes exist on encrypted root partition on /dev directory. Use
   mknod program to create those device nodes. Above example would need 4
   nodes: /dev/loop6, /dev/sda3, /dev/loop4 and /dev/sdd12. The tricky part
   is putting them on the directory that is under udev mounted tmpfs file
   system.
5) /etc/cleartextkey-loop*.txt files (or whatever) on encrypted root
   partition are protected by root partition encryption. Each of these files
   contain 65 lines of key material that would normally be wrapped by and
   protected by gpg encryption.
6) Up to 8 extra commands can be configured. If you need more, make it run a
   shell script somewhere on encrypted root partition.

New version of the build-initrd.sh script is here:
http://loop-aes.sourceforge.net/updates/build-initrd.sh-20110531.bz2
http://loop-aes.sourceforge.net/updates/build-initrd.sh-20110531.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
