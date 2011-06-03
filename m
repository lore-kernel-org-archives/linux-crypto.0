From: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Fri, 3 Jun 2011 14:34:22 -0700
Message-ID: <BANLkTinkcphRNuRffwu4T1d+Kr1T2Vd=Lw@mail.gmail.com>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
	<4DE4E624.CCA18200@users.sourceforge.net>
	<BANLkTimeDeisn6h9VRn9CLfZyLe=biVTEw@mail.gmail.com>
	<4DE91C0D.3D9BB471@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33428 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab1FCVeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jun 2011 17:34:24 -0400
Received: by vxi39 with SMTP id 39so1679626vxi.19
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jun 2011 14:34:23 -0700 (PDT)
In-Reply-To: <4DE91C0D.3D9BB471@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 3, 2011 at 10:38 AM, Jari Ruusu
<jariruusu@users.sourceforge.net> wrote:
> Frederick Gazerblezeebe wrote:
>> /dev/loop2: [0001]:5099 (/dev/sda2) encryption=3DAES128 multi-key-v3
>> /dev/loop3: [0702]:2104244 (/dev/sda3) encryption=3DAES128 multi-key=
-v3
>>
>> but systemd is unable to mount it to /home as defined in fstab,
>>
>> /dev/loop3 =A0 =A0 =A0/home =A0 =A0 =A0ext4 =A0 =A0defaults =A0 =A0 =
=A0 =A00 2 =A0 =A0#/dev/sda3
>
> Does it work if you remove #/dev/sda3 text at the end of the line? St=
rict
> reading of fstab(5) man page says that lines that begin with # are co=
mments.
> Mount program fstab parser code seems to be happy with extra stuff at=
 end of
> line, but other fstab parser implementations are not necessarily ok w=
ith
> that.
>
Removing the comment at the end of the fstab entry had no effect;
booting is aborted leaving the system in rescue mode.  Looking at the
console output I found the following:

Starting /home aborted because a dependency failed.
systemd: job dev-loop3.device/start failed with result 'timeout'

I am investigating this right now...


>> One additional peculiarity is that although the swap is activated at
>> boot time, it is not =A0encrypted until I remove/add it again. =A0Th=
e
>> fstab entry is
>>
>> /dev/sda5 =A0 =A0 =A0 swap =A0 =A0 =A0 swap =A0 =A0sw,loop=3D/dev/lo=
op5,encryption=3DAES128 =A0 0 0
>
> That sounds like systemd is not using swapon program to enable swap. =
Does it
> work if you set it up with non-changing encryption keys? As in,
> build-initrd.sh sets it up, and /etc/fstab line is:
>
> /dev/loop5 =A0swap =A0swap =A0sw =A00 =A00
>
Changing the fstab entry per your suggestion fails to add any swap:

XXX[101]% swapon -s
=46ilename                                Type            Size    Used =
   Priority
XXX[102]% swapoff -a
XXX[103]% swapon -a
swapon: /dev/loop5: read swap header failed: Invalid argument

I then tried creating a static device node /dev/loop5 (I had to create
a static device node for /dev/loop3 (/home) before the
EXTRACOMMANDSTR1 for losetup would run), but the behavior was the
same.

I did find some error messages the syslog that are relevant:

Jun  3 13:17:49 mars systemd[1]: Unit systemd-tmpfiles-setup.service
entered failed state.
Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.device/start timed out.
Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.swap/start failed with
result 'dependency'.
Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.device/start failed
with result 'timeout'.

I'm looking in the systemd scripts right now to see if I can track
down the source of this error.  Unfortunately, a number of these
'scripts' are actually binaries and therefore essentially blackboxes
to me.  I'm hoping that the problem resides in one of the actual
scripts...

=46G
