From: Frederick Gazerblezeebe <fgazerblezeebe@gmail.com>
Subject: loop-aes encrypted root on Fedora 15 using systemd
Date: Mon, 30 May 2011 14:31:03 -0700
Message-ID: <BANLkTimKp4VgiZwEzB7d5yO9msKLu92pSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53333 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1E3VbD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2011 17:31:03 -0400
Received: by vxi39 with SMTP id 39so2874012vxi.19
        for <linux-crypto@vger.kernel.org>; Mon, 30 May 2011 14:31:03 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I am trying to set up a Fedora 15 system (kernel 2.6.39) on which the
root filesystem is encrypted with loop-aes (v3.6c).

Can someone suggest the best location to place the initial losetup
commands? This new version uses the systemd boot stuff and
/etc/rc.d/rc.sysinit (where I placed the losetup commands before) no
longer exists. I was partially successful placing them in
/lib/systemd/fedora-readonly, meaning losetup successfully sets up the
loop device, but attempts to actually mount a file system on this loop
fail and the boot process terminates. I think I may be placing the
losetup too late in the sequence and the system is attempting to mount
on the loop before it is actually set up, but that's just a guess at
this point.

Any suggestions on how I might proceed would be greatly appreciated.

Thanks.

FG
