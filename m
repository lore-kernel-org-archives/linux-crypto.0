From: Simon Baatz <gmbnomis@gmail.com>
Subject: mv_cesa dcache problem since 2.6.37 was: Re: mv_cesa hash functions
Date: Sun, 06 May 2012 00:49:30 +0200
Message-ID: <4FA5AE7A.3000201@gmail.com>
References: <20120223183439.GA18545@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Frank <frank@debian-nas.org>,
	'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	uri@jdland.co.il, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38633 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2EEWtw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 May 2012 18:49:52 -0400
Received: by eekc41 with SMTP id c41so1118980eek.19
        for <linux-crypto@vger.kernel.org>; Sat, 05 May 2012 15:49:51 -0700 (PDT)
In-Reply-To: <20120223183439.GA18545@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Am 23.02.2012 19:34, schrieb Phil Sutter:
> But you might suffer from another problem, which is only present on
> ARM machines with VIVT cache and linux >= 2.6.37: due to commit
> f8b63c1, "ARM: 6382/1: Remove superfluous flush_kernel_dcache_page()"
> which prevents pages being flushed from inside the scatterlist
> iterator API. This patch seems to introduce problems in other places
> (namely NFS), too but I sadly did not have time to investigate this
> further. I will post a possible (cryptodev-internal) solution to
> cryptodev-linux-devel@gna.org, maybe this fixes the problem with
> openssl. Greetings, Phil 

since there has been no reaction on this, I would like to bring this
issue up again (I sadly don't have the expertise to investigate this
further...). The issue is not limited to cryptodev, but seems to be
either a problem with commit f8b63c1 or a problem in mv_cesa that was
uncovered by this commit. In the past, I also had massive problems
compiling on an NFS mounted file system when not reverting f8b63c1. I
currently can't reproduce this anymore under 3.4-rc5.

However, the following still happens on a 3.4-rc5 preempt kernel on arm
kirkwood (VIVT cache):

root@ww1:~# cryptsetup luksOpen /dev/sda2 c_sda2
Enter passphrase for /dev/sda2:
root@ww1:~# vgchange -a y ww1_1
  Volume group "ww1_1" not found
root@ww1:~# vgchange -a y ww1_1
Segmentation fault


Thus, the behavior of vgchange is unpredictable on a dm-crypt device
when using mv_cesa (btw. the machine needs to have no load to show this
behavior. I assume that the cache flushes caused by task switches make
it work under load).

Using the generic crypto modules, it works as expected:

root@ww1:~# cryptsetup luksClose c_sda2
root@ww1:~# rmmod mv_cesa
root@ww1:~# cryptsetup luksOpen /dev/sda2 c_sda2
Enter passphrase for /dev/sda2:
root@ww1:~# vgchange -a y ww1_1
  1 logical volume(s) in volume group "ww1_1" now active


After reverting f8b63c1, it works as expected using mv_cesa as well.


- Simon
