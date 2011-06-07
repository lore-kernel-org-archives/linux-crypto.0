From: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Tue, 7 Jun 2011 07:28:02 -0700
Message-ID: <BANLkTingxPqTOcgvfu81dKn7ix1Rnauqgw@mail.gmail.com>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
	<4DE4E624.CCA18200@users.sourceforge.net>
	<BANLkTimeDeisn6h9VRn9CLfZyLe=biVTEw@mail.gmail.com>
	<4DE91C0D.3D9BB471@users.sourceforge.net>
	<BANLkTinkcphRNuRffwu4T1d+Kr1T2Vd=Lw@mail.gmail.com>
	<4DE9DE4E.1343B64B@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63441 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1FGO2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2011 10:28:04 -0400
Received: by vxi39 with SMTP id 39so3580859vxi.19
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2011 07:28:04 -0700 (PDT)
In-Reply-To: <4DE9DE4E.1343B64B@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 4, 2011 at 12:27 AM, Jari Ruusu
<jariruusu@users.sourceforge.net> wrote:
> Frederick Gazerblezeebe wrote:
>> Starting /home aborted because a dependency failed.
>> systemd: job dev-loop3.device/start failed with result 'timeout'
> [snip]
>> Changing the fstab entry per your suggestion fails to add any swap:
>>
>> XXX[101]% swapon -s
>> Filename =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Type =A0 =A0 =A0 =A0 =A0 =A0Size =A0 =A0Used =A0 =A0Priority
>> XXX[102]% swapoff -a
>> XXX[103]% swapon -a
>> swapon: /dev/loop5: read swap header failed: Invalid argument
>
> If you use non-changing encryption keys for swap, you have to "format=
" the
> device as swap (this needs to be done only once):
>
> =A0 =A0swapoff -a
> =A0 =A0mkswap /dev/loop5
> =A0 =A0swapon -a
>
> If /dev/loop5 encryption keys are ever changed, then mkswap has to be=
 run
> again. (When swapon program sets up random swap encryption keys, it r=
uns
> mkswap automatically)
>

Doh, I knew this; must have been tired when I tried it..  So,
initializing the swap correctly, the behavior remains the same: The
boot process stalls (but does not abort, resuming after a minute or so
delay) with the same error as before (Unit
systemd-tmpfiles-setup.service entered failed state; Job
dev-loop5.swap/start failed with result 'dependency';
 Job dev-loop5.device/start failed with result 'timeout'.)

>> Jun =A03 13:17:49 mars systemd[1]: Unit systemd-tmpfiles-setup.servi=
ce
>>  .
>> Jun =A03 13:19:02 mars systemd[1]: Job dev-loop5.device/start timed =
out.
>> Jun =A03 13:19:02 mars systemd[1]: Job dev-loop5.swap/start failed w=
ith
>> result 'dependency'.
>> Jun =A03 13:19:02 mars systemd[1]: Job dev-loop5.device/start failed
>> with result 'timeout'.
>
> That sounds like systemd is waiting for devices to be created. Does i=
t help
> if you configure udev to copy loop device nodes to /dev directory on =
boot?
>
> =A0 =A0mknod -m 660 /lib/udev/devices/loop0 b 7 0
> =A0 =A0mknod -m 660 /lib/udev/devices/loop1 b 7 1
> =A0 =A0mknod -m 660 /lib/udev/devices/loop2 b 7 2
> =A0 =A0mknod -m 660 /lib/udev/devices/loop3 b 7 3
> =A0 =A0mknod -m 660 /lib/udev/devices/loop4 b 7 4
> =A0 =A0mknod -m 660 /lib/udev/devices/loop5 b 7 5
> =A0 =A0mknod -m 660 /lib/udev/devices/loop6 b 7 6
> =A0 =A0mknod -m 660 /lib/udev/devices/loop7 b 7 7
>
The loop nodes are already present /lib/udev, so that is not the
source of the (mis)behavior. I had to create static links in /dev for
loop2 and sda2, loop3 and sda3, and loop5 and sda5 (root, home and
swap, respectively), in order to get them initialized and show up (via
losetup -a) after booting. At the present time, root is the only
partition whose loop device is successfully mounted during boot.  The
others (swap, home) have to be mounted to after booting has completed.

Next I will post a summary of what I have done and where I am,
including the behaviors we are discussing here, in reply to the
original topic.

=2E..and again, thanks for all the help!

=46G
