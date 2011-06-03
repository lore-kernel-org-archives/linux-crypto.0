From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: loop-aes encrypted root on Fedora 15 using systemd
Date: Fri, 03 Jun 2011 20:38:21 +0300
Message-ID: <4DE91C0D.3D9BB471@users.sourceforge.net>
References: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
			<4DE4E624.CCA18200@users.sourceforge.net> <BANLkTimeDeisn6h9VRn9CLfZyLe=biVTEw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:60830 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab1FCRiX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jun 2011 13:38:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Frederick Gazerblezeebe wrote:
> /dev/loop2: [0001]:5099 (/dev/sda2) encryption=AES128 multi-key-v3
> /dev/loop3: [0702]:2104244 (/dev/sda3) encryption=AES128 multi-key-v3
> 
> but systemd is unable to mount it to /home as defined in fstab,
> 
> /dev/loop3      /home      ext4    defaults        0 2    #/dev/sda3

Does it work if you remove #/dev/sda3 text at the end of the line? Strict
reading of fstab(5) man page says that lines that begin with # are comments.
Mount program fstab parser code seems to be happy with extra stuff at end of
line, but other fstab parser implementations are not necessarily ok with
that.

> One additional peculiarity is that although the swap is activated at
> boot time, it is not  encrypted until I remove/add it again.  The
> fstab entry is
> 
> /dev/sda5       swap       swap    sw,loop=/dev/loop5,encryption=AES128   0 0

That sounds like systemd is not using swapon program to enable swap. Does it
work if you set it up with non-changing encryption keys? As in,
build-initrd.sh sets it up, and /etc/fstab line is:

/dev/loop5  swap  swap  sw  0  0

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
