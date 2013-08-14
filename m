From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 0/1] Check for osxsave as well as avx in crypto/xor
Date: Wed, 14 Aug 2013 16:23:17 +0100
Message-ID: <1376493798-9668-1-git-send-email-john.haxby@oracle.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	" \"David S. Miller\"" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from inet-emmc03-o.oracle.co.uk ([193.9.13.135]:49957 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014Ab3HNPf3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 11:35:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

The crypto/xor module omits a check for osxsave.  This is a problem on
sufficiently new hardware but with, for example, a PV guest on a
sufficiently old version of xeni (eg 3.4).  This shows up on Amazon EC2
under a slightly different guise (see
http://blog.picloud.com/2013/01/08/when-ec2-hardware-changes-underneath-you/
or http://tinyurl.com/bezgbhs).  In this case, however, "modprobe xor" will
give something like this:

[11902.030050] xor: automatically using best checksumming function:
[11902.030746] invalid opcode: 0000 [#1] SMP 
[11902.030752] Modules linked in: xor(+) [...]
[11902.030771] CPU: 0 PID: 1287 Comm: modprobe Not tainted 3.10.5 #1
[...]
[11902.031105] Call Trace:
[11902.031121]  [<ffffffffa0160071>] do_xor_speed+0x71/0xc2 [xor]
[11902.031213]  [<ffffffffa016012d>] calibrate_xor_blocks+0x6b/0xf3e [xor]
[11902.031217]  [<ffffffffa01600c2>] ? do_xor_speed+0xc2/0xc2 [xor]
[11902.031222]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[11902.031249]  [<ffffffff810bf00d>] load_module+0x1b9d/0x2640

Although this is an explicit modprobe, one more serious side effect of
xor failing like this is that btrfs depends on xor and without it I was
unable to mount a btrfs filesystem.

The fix is straightforward: add a check for cpu_has_oxsave.  This puts xor
in line with the other crypto modules that use avx.

jch
