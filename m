From: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Fri, 3 Jun 2011 09:42:45 -0700
Message-ID: <BANLkTimeDeisn6h9VRn9CLfZyLe=biVTEw@mail.gmail.com>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
	<4DE4E624.CCA18200@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40516 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1FCQmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jun 2011 12:42:46 -0400
Received: by vxi39 with SMTP id 39so1507476vxi.19
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jun 2011 09:42:45 -0700 (PDT)
In-Reply-To: <4DE4E624.CCA18200@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2011 at 5:59 AM, Jari Ruusu
<jariruusu@users.sourceforge.net> wrote:
> Frederick Gazerblezeebe wrote:
>> I am trying to set up a Fedora 15 system (kernel 2.6.39) on which th=
e
>> root filesystem is encrypted with loop-aes (v3.6c).
>>
>> Can someone suggest the best location to place the initial losetup
>> commands? This new version uses the systemd boot stuff and
>> /etc/rc.d/rc.sysinit (where I placed the losetup commands before) no
>> longer exists. I was partially successful placing them in
>> /lib/systemd/fedora-readonly, meaning losetup successfully sets up t=
he
>> loop device, but attempts to actually mount a file system on this lo=
op
>> fail and the boot process terminates. I think I may be placing the
>> losetup too late in the sequence and the system is attempting to mou=
nt
>> on the loop before it is actually set up, but that's just a guess at
>> this point.
>
> I am assuming you used loop-AES' build-initrd.sh script. I changed th=
e
> script so that it can be configured to set up more loop devices than =
the one
> used by encrypted root partition. For example, if you want to set up
> "no password entering required" /dev/loop6 and /dev/loop4, you can ad=
d these
> lines to build-initrd.sh config:
>
> EXTRACOMMANDRUN1=3D1
> EXTRACOMMANDSTR1=3D"/sbin/losetup -e AES128 -P /etc/cleartextkey-loop=
6.txt /dev/loop6 /dev/sda3"
> EXTRACOMMANDRUN2=3D1
> EXTRACOMMANDSTR2=3D"/sbin/losetup -e AES128 -P /etc/cleartextkey-loop=
4.txt /dev/loop4 /dev/sdd12"
>
> Limitations/rules:
> 1) Commands are run after switching to encrypted root but before star=
ting
> =A0 /sbin/init
> 2) Encrypted root partition is mounted read-only. Other file systems =
are not
> =A0 mounted.
> 3) udev is not running yet, so dynamic device nodes on tmpfs (created=
 and
> =A0 mounted by udev on top of /dev directory) are not available.
> 4) If commands need /dev/* device nodes, you must make sure that stat=
ic
> =A0 device nodes exist on encrypted root partition on /dev directory.=
 Use
> =A0 mknod program to create those device nodes. Above example would n=
eed 4
> =A0 nodes: /dev/loop6, /dev/sda3, /dev/loop4 and /dev/sdd12. The tric=
ky part
> =A0 is putting them on the directory that is under udev mounted tmpfs=
 file
> =A0 system.
> 5) /etc/cleartextkey-loop*.txt files (or whatever) on encrypted root
> =A0 partition are protected by root partition encryption. Each of the=
se files
> =A0 contain 65 lines of key material that would normally be wrapped b=
y and
> =A0 protected by gpg encryption.
> 6) Up to 8 extra commands can be configured. If you need more, make i=
t run a
> =A0 shell script somewhere on encrypted root partition.
>
> New version of the build-initrd.sh script is here:
> http://loop-aes.sourceforge.net/updates/build-initrd.sh-20110531.bz2
> http://loop-aes.sourceforge.net/updates/build-initrd.sh-20110531.bz2.=
sign
>
> --
> Jari Ruusu =A01024R/3A220F51 5B 4B F9 BB D3 3F 52 E9 =A0DB 1D EB E3 2=
4 0E A9 DD
>

I am currently up on the encrypted root with a couple of issues, which
may not be problems with loop-aes.

Using the EXTRACOMMANDRUN# options in your new script I am able to get
the loop device for /home initialized, as shown by the output of
losetup -a (loop2=3D/, loop3=3Dhome),

/dev/loop2: [0001]:5099 (/dev/sda2) encryption=3DAES128 multi-key-v3
/dev/loop3: [0702]:2104244 (/dev/sda3) encryption=3DAES128 multi-key-v3

but systemd is unable to mount it to /home as defined in fstab,

/dev/loop3      /home      ext4    defaults        0 2    #/dev/sda3

resulting in a failure to boot. At first I thought this was a selinux
problem, but further testing shows that this is not likely the case.
Next I need to go through the systemd scripts and find exactly where
it is failing and see what I can do about it.

One additional peculiarity is that although the swap is activated at
boot time, it is not  encrypted until I remove/add it again.  The
fstab entry is

/dev/sda5       swap       swap    sw,loop=3D/dev/loop5,encryption=3DAE=
S128   0 0

Immediately after boot:

###[102]% losetup -a
/dev/loop2: [0001]:5099 (/dev/sda2) encryption=3DAES128 multi-key-v3
/dev/loop3: [0702]:2104244 (/dev/sda3) encryption=3DAES128 multi-key-v3
###[103]% swapon -s
=46ilename                                Type            Size    Used =
   Priority
/dev/sda5                               partition       6136824 0      =
 0
###[104]% swapoff -a
###[105]% swapon -a
Setting up swapspace version 1, size =3D 6136820 KiB
no label, UUID=3D4f1b6b95-bd99-4ac5-aee6-b87d599b1f5c
###[107]% losetup -a
/dev/loop2: [0001]:5099 (/dev/sda2) encryption=3DAES128 multi-key-v3
/dev/loop3: [0702]:2104244 (/dev/sda3) encryption=3DAES128 multi-key-v3
/dev/loop5: [0005]:5244 (/dev/sda5) offset=3D4096 encryption=3DAES128 m=
ulti-key-v3
###[109]% swapon -s
=46ilename                                Type            Size    Used =
   Priority
/dev/loop5                              partition       6136820 0      =
 -1

Once again I think this is a systemd issue as opposed to a loop-aes
problem and I am currently looking into it as well.

So thanks again for the quick script update, it really helped, and
I'll post back again when I've made some more progress.

=46G
