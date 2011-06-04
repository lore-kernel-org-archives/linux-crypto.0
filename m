From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Sat, 04 Jun 2011 10:27:10 +0300
Message-ID: <4DE9DE4E.1343B64B@users.sourceforge.net>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
			<4DE4E624.CCA18200@users.sourceforge.net>
			<BANLkTimeDeisn6h9VRn9CLfZyLe=biVTEw@mail.gmail.com>
			<4DE91C0D.3D9BB471@users.sourceforge.net> <BANLkTinkcphRNuRffwu4T1d+Kr1T2Vd=Lw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:47776 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1FDH1T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Jun 2011 03:27:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Frederick Gazerblezeebe wrote:
> Starting /home aborted because a dependency failed.
> systemd: job dev-loop3.device/start failed with result 'timeout'
[snip]
> Changing the fstab entry per your suggestion fails to add any swap:
> 
> XXX[101]% swapon -s
> Filename                                Type            Size    Used    Priority
> XXX[102]% swapoff -a
> XXX[103]% swapon -a
> swapon: /dev/loop5: read swap header failed: Invalid argument

If you use non-changing encryption keys for swap, you have to "format" the
device as swap (this needs to be done only once):

    swapoff -a
    mkswap /dev/loop5
    swapon -a

If /dev/loop5 encryption keys are ever changed, then mkswap has to be run
again. (When swapon program sets up random swap encryption keys, it runs
mkswap automatically)

> Jun  3 13:17:49 mars systemd[1]: Unit systemd-tmpfiles-setup.service
> entered failed state.
> Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.device/start timed out.
> Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.swap/start failed with
> result 'dependency'.
> Jun  3 13:19:02 mars systemd[1]: Job dev-loop5.device/start failed
> with result 'timeout'.

That sounds like systemd is waiting for devices to be created. Does it help
if you configure udev to copy loop device nodes to /dev directory on boot?

    mknod -m 660 /lib/udev/devices/loop0 b 7 0
    mknod -m 660 /lib/udev/devices/loop1 b 7 1
    mknod -m 660 /lib/udev/devices/loop2 b 7 2
    mknod -m 660 /lib/udev/devices/loop3 b 7 3
    mknod -m 660 /lib/udev/devices/loop4 b 7 4
    mknod -m 660 /lib/udev/devices/loop5 b 7 5
    mknod -m 660 /lib/udev/devices/loop6 b 7 6
    mknod -m 660 /lib/udev/devices/loop7 b 7 7

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
