From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/1] Check for osxsave as well as avx in crypto/xor
Date: Wed, 21 Aug 2013 21:50:08 +1000
Message-ID: <20130821115008.GB23287@gondor.apana.org.au>
References: <1376493798-9668-1-git-send-email-john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: " \"David S. Miller\"" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: John Haxby <john.haxby@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37907 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486Ab3HULuN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 07:50:13 -0400
Content-Disposition: inline
In-Reply-To: <1376493798-9668-1-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 14, 2013 at 04:23:17PM +0100, John Haxby wrote:
> Hello,
> 
> The crypto/xor module omits a check for osxsave.  This is a problem on
> sufficiently new hardware but with, for example, a PV guest on a
> sufficiently old version of xeni (eg 3.4).  This shows up on Amazon EC2
> under a slightly different guise (see
> http://blog.picloud.com/2013/01/08/when-ec2-hardware-changes-underneath-you/
> or http://tinyurl.com/bezgbhs).  In this case, however, "modprobe xor" will
> give something like this:
> 
> [11902.030050] xor: automatically using best checksumming function:
> [11902.030746] invalid opcode: 0000 [#1] SMP 
> [11902.030752] Modules linked in: xor(+) [...]
> [11902.030771] CPU: 0 PID: 1287 Comm: modprobe Not tainted 3.10.5 #1
> [...]
> [11902.031105] Call Trace:
> [11902.031121]  [<ffffffffa0160071>] do_xor_speed+0x71/0xc2 [xor]
> [11902.031213]  [<ffffffffa016012d>] calibrate_xor_blocks+0x6b/0xf3e [xor]
> [11902.031217]  [<ffffffffa01600c2>] ? do_xor_speed+0xc2/0xc2 [xor]
> [11902.031222]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
> [11902.031249]  [<ffffffff810bf00d>] load_module+0x1b9d/0x2640
> 
> Although this is an explicit modprobe, one more serious side effect of
> xor failing like this is that btrfs depends on xor and without it I was
> unable to mount a btrfs filesystem.
> 
> The fix is straightforward: add a check for cpu_has_oxsave.  This puts xor
> in line with the other crypto modules that use avx.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
