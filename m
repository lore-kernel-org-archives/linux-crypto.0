From: Milan Broz <mbroz@redhat.com>
Subject: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Tue, 20 Nov 2012 15:03:31 +0100
Message-ID: <50AB8DB3.6040008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Sonic.Zhang@analog.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2KTOEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2012 09:04:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

commit a482b081a2d4d74d16bc9ea8779f9f6055f95852
Author: Sonic Zhang <sonic.zhang@analog.com>
Date:   Fri May 25 17:54:13 2012 +0800
    crypto: testmgr - Add new test cases for Blackfin CRC crypto driver

added tcrypt mode=110 test for hmac(crc32)

It seems, that this mode is only directly implemented by Blackfin
driver and must fail on all other architectures because:

- nobody implements "crc32" but "crc32c"

- the block size is 1 and digest size is 4 for crc32[c], so
hmac(crc32c) must fail because ds > block_size (test in hmac_create)

And it doesn't fail here because you implement it directly and
not using hmac.c...

Just try modprobe tcrypt mode=110 on so other arch
  alg: hash: Failed to load transform for hmac(crc32): -2

Why was such one-device dependent test vector added?

IMHO either it should provide crc32c (as do generic, sparc or x86 hw drivers)
or the block size for crc32c should be 4... (and test vector is wrong then)

But now we have test vector which must fail for most of systems.

Milan
