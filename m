From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Subject: RE: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Wed, 21 Nov 2012 06:29:54 -0500
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
References: <50AB8DB3.6040008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
To: Milan Broz <mbroz@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.180.16] ([216.32.180.16]:52118 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab2KULde convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2012 06:33:34 -0500
In-Reply-To: <50AB8DB3.6040008@redhat.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



>-----Original Message-----
>From: Milan Broz [mailto:mbroz@redhat.com]
>Sent: Tuesday, November 20, 2012 10:04 PM
>To: linux-crypto@vger.kernel.org
>Cc: Herbert Xu; Zhang, Sonic
>Subject: Tcrypt hmac(crc32) test can work only on Blackfin
>
>Hi,
>
>commit a482b081a2d4d74d16bc9ea8779f9f6055f95852
>Author: Sonic Zhang <sonic.zhang@analog.com>
>Date:   Fri May 25 17:54:13 2012 +0800
>    crypto: testmgr - Add new test cases for Blackfin CRC crypto driver
>
>added tcrypt mode=110 test for hmac(crc32)
>
>It seems, that this mode is only directly implemented by Blackfin driver and must
>fail on all other architectures because:
>
>- nobody implements "crc32" but "crc32c"
>
>- the block size is 1 and digest size is 4 for crc32[c], so
>hmac(crc32c) must fail because ds > block_size (test in hmac_create)
>
>And it doesn't fail here because you implement it directly and not using hmac.c...
>
>Just try modprobe tcrypt mode=110 on so other arch
>  alg: hash: Failed to load transform for hmac(crc32): -2
>
>Why was such one-device dependent test vector added?
>

Blackfin CRC engine is flexible to support many CRC32 polynomials (include crc32c) and is able to append 0 to any block size which is not a multiple of 4. This Blackfin CRC engine specific test vector show these capabilities. Is there a policy that the CRC test vector in testmgr.h should support all CRC drivers? If so, I am fine to drop this test vector.


>IMHO either it should provide crc32c (as do generic, sparc or x86 hw drivers) or
>the block size for crc32c should be 4... (and test vector is wrong then)
>

I can set the default polynomials to that of crc32c for blackfin crc32 driver. But, it should not be limited to crc32c.

Regards,

Sonic

>But now we have test vector which must fail for most of systems.
>
>Milan
