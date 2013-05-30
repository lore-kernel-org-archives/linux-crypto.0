From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] crypto: caam - Fixed the memory out of bound overwrite issue
Date: Thu, 30 May 2013 15:45:47 +0530
Message-ID: <1369908947-18436-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:44156
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968161Ab3E3KUm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 06:20:42 -0400
Received: from mail144-co9 (localhost [127.0.0.1])	by
 mail144-co9-R.bigfish.com (Postfix) with ESMTP id 9BA2C3A0094	for
 <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 10:20:41 +0000 (UTC)
Received: from CO9EHSMHS006.bigfish.com (unknown [10.236.132.228])	by
 mail144-co9.bigfish.com (Postfix) with ESMTP id BEB908005B	for
 <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 10:20:38 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r4UAKVtQ007576	for
 <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 03:20:32 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When kernel is compiled with CONFIG_SLUB_DEBUG=y and
CRYPTO_MANAGER_DISABLE_TESTS=n, during kernel bootup, the kernel
reports error given below. The root cause is that in function
hash_digest_key(), for allocating descriptor, insufficient memory was
being allocated. The required number of descriptor words apart from
input and output pointers are 8 (instead of 6).

=============================================================================
BUG dma-kmalloc-32 (Not tainted): Redzone overwritten
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: 0xdec5dec0-0xdec5dec3. First byte 0x0 instead of 0xcc
INFO: Allocated in ahash_setkey+0x60/0x594 age=7 cpu=1 pid=1257
        __kmalloc+0x154/0x1b4
        ahash_setkey+0x60/0x594
        test_hash+0x260/0x5a0
        alg_test_hash+0x48/0xb0
        alg_test+0x84/0x228
        cryptomgr_test+0x4c/0x54
        kthread+0x98/0x9c
        ret_from_kernel_thread+0x64/0x6c
INFO: Slab 0xc0bd0ba0 objects=19 used=2 fp=0xdec5d0d0 flags=0x0081
INFO: Object 0xdec5dea0 @offset=3744 fp=0x5c200014

Bytes b4 dec5de90: 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a
........ZZZZZZZZ
Object dec5dea0: b0 80 00 0a 84 41 00 0d f0 40 00 00 00 67 3f c0
.....A...@...g?.
Object dec5deb0: 00 00 00 50 2c 14 00 50 f8 40 00 00 1e c5 d0 00
...P,..P.@......
Redzone dec5dec0: 00 00 00 14                                      ....
Padding dec5df68: 5a 5a 5a 5a 5a 5a 5a 5a
ZZZZZZZZ
Call Trace:
[dec65b60] [c00071b4] show_stack+0x4c/0x168 (unreliable)
[dec65ba0] [c00d4ec8] check_bytes_and_report+0xe4/0x11c
[dec65bd0] [c00d507c] check_object+0x17c/0x23c
[dec65bf0] [c0550a00] free_debug_processing+0xf4/0x294
[dec65c20] [c0550bdc] __slab_free+0x3c/0x294
[dec65c80] [c03f0744] ahash_setkey+0x4e0/0x594
[dec65cd0] [c01ef138] test_hash+0x260/0x5a0
[dec65e50] [c01ef4c0] alg_test_hash+0x48/0xb0
[dec65e70] [c01eecc4] alg_test+0x84/0x228
[dec65ee0] [c01ec640] cryptomgr_test+0x4c/0x54
[dec65ef0] [c005adc0] kthread+0x98/0x9c
[dec65f40] [c000e1ac] ret_from_kernel_thread+0x64/0x6c
FIX dma-kmalloc-32: Restoring 0xdec5dec0-0xdec5dec3=0xcc

Change-Id: I0c7a1048053e811025d1c3b487940f87345c8f5d
Signed-off-by: Vakul Garg <vakul@freescale.com>
CC: <stable@vger.kernel.org> #3.9
Reviewed-by: Geanta Neag Horia Ioan-B05471 <horia.geanta@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
Tested-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/caamhash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index ae765ac..bf8c77c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -427,7 +427,7 @@ static u32 hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	dma_addr_t src_dma, dst_dma;
 	int ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
+	desc = kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
 		dev_err(jrdev, "unable to allocate key input memory\n");
 		return -ENOMEM;
-- 
1.7.7.6
