From: vepd upstream <vepdupstream@gmail.com>
Subject: Some confiusion about ahash and shash
Date: Wed, 22 Aug 2012 17:32:03 +0800
Message-ID: <CALrx44q=2vDJ1KOaMdKp9Sr_kNKVXvMZkGzO8ermh1Kh3SBQog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52805 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2HVJcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Aug 2012 05:32:04 -0400
Received: by weyx8 with SMTP id x8so454161wey.19
        for <linux-crypto@vger.kernel.org>; Wed, 22 Aug 2012 02:32:03 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have a confusion about shash and ahash in Linux kernel.Wish you can
help me.Thank you!

The problem is that,
1.we have an asynchronous hardware.In its security driver, it has
achieved the synchronous mode using schedule().
2.we want to add this hardware security feature into Linux kernel,so
we register a synchronous algorithm module.In this module,we via call
the crypto API of the Hardware driver to achieve shash algorithm.
3.After testing,if we enable the self-test for crypt algorithm in
Linux Kernel, the self-test will failed. and our algorithm can't be
used.as the self-test using Ashah
API(crypto_alloc_ashah,crypto_ahash_init,crypto_ahash_update,crypto_ahash_final)
to test our shash algorithm.

The error information is that:
BUG: scheduling while atomic: cryptomgr_test/5796/0x00000002
Modules linked in: imx53_security_asyn_hash(+) sahara scc2_driver
[<80038538>] (unwind_backtrace+0x0/0xf0) from [<8044112c>] (schedule+0x6c/0x334)
 [<8044112c>] (schedule+0x6c/0x334) from [<7f009848>]
(sah_blocking_mode+0x80/0x138 [sahara])
[<7f009848>] (sah_blocking_mode+0x80/0x138 [sahara]) from [<7f00eaa8>]
(adaptor_Exec_Descriptor_Chain+0x34/0x54 [sahara])
[<7f00eaa8>] (adaptor_Exec_Descriptor_Chain+0x34/0x54 [sahara]) from
[<7f00cbd8>] (fsl_shw_hash+0x1b8/0x1fc [sahara])
[<7f00cbd8>] (fsl_shw_hash+0x1b8/0x1fc [sahara]) from [<7f0203d4>]
(sahara_sha_final+0x88/0xd8 [imx53_security_asyn_hash])
[<7f0203d4>] (sahara_sha_final+0x88/0xd8 [imx53_security_asyn_hash])
from [<801fdd8c>] (crypto_shash_final+0x28/0x2c)
[<801fdd8c>] (crypto_shash_final+0x28/0x2c) from [<801fdf3c>]
(crypto_shash_finup+0x2c/0x30)
[<801fdf3c>] (crypto_shash_finup+0x2c/0x30) from [<801fe104>]
(shash_ahash_finup+0x60/0x90)
[<801fe104>] (shash_ahash_finup+0x60/0x90) from [<801fd2dc>]
(crypto_ahash_op+0xac/0xbc)
[<801fd2dc>] (crypto_ahash_op+0xac/0xbc) from [<801ff2b0>]
(test_hash+0x148/0x514)
[<801ff2b0>] (test_hash+0x148/0x514) from [<801ff6cc>] (alg_test_hash+0x50/0x88)
[<801ff6cc>] (alg_test_hash+0x50/0x88) from [<80200de8>] (alg_test+0x13c/0x1b0)
[<80200de8>] (alg_test+0x13c/0x1b0) from [<801fe774>] (cryptomgr_test+0x24/0x44)
[<801fe774>] (cryptomgr_test+0x24/0x44) from [<800788c4>] (kthread+0x78/0x80)
[<800788c4>] (kthread+0x78/0x80) from [<800349e0>] (kernel_thread_exit+0x0/0x8)

The real result is that kmap_atomic()(crypto_hash_walk in Linux kernel
) conflict with schedule()(in hardware driver).

But if we disable the self-test, and using Shash API or Hash API to
test, test will be successful.

Now our requirement is that,
     The hardware feature can't be changed,how can we solve those
problem that can use ashah API to test our shash algorithm in order to
pass self-test
