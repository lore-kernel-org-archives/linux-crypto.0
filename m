From: Yashpal Dutta <yashpal.dutta@freescale.com>
Subject: [RESEND][PATCH] drivers/crypto:caam:get_user_pages requires kmap before access
Date: Mon, 10 Dec 2012 01:55:13 +0545
Message-ID: <1355083813-21213-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37333 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933858Ab2LIPFR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Dec 2012 10:05:17 -0500
Received: from mail10-tx2 (localhost [127.0.0.1])	by mail10-tx2-R.bigfish.com
 (Postfix) with ESMTP id E1DA43E038C	for <linux-crypto@vger.kernel.org>; Sun,
  9 Dec 2012 15:05:15 +0000 (UTC)
Received: from TX2EHSMHS035.bigfish.com (unknown [10.9.14.241])	by
 mail10-tx2.bigfish.com (Postfix) with ESMTP id 82898C0235	for
 <linux-crypto@vger.kernel.org>; Sun,  9 Dec 2012 15:04:42 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Following crash occur if user pinned pages are send to SEC driver for digest
creation:

Unable to handle kernel paging request for data at address 0x00000f48
Faulting instruction address: 0xc0017f1c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=8 P4080 DS
Modules linked in: qoriq_dbg
NIP: c0017f1c LR: c04053a8 CTR: c000c9e4
REGS: e29bbb10 TRAP: 0300 Not tainted (3.0.34-rt55)
MSR: 00029002 <EE,ME,CE> CR: 28248422 XER: 00000000
DEAR: 00000f48, ESR: 00000000
TASK = e917caf0[2249] 'openssl' THREAD: e29ba000 CPU: 2
GPR00: 00000040 e29bbbc0 e917caf0 e2805c68 00000f44 00000004 e2805c64 00000000
GPR08: 00000000 c0772400 00000000 c07723f8 48244422 100867b4 00000005 00000044
GPR16: f0400000 00000004 00000000 f67f0f08 00000044 c0760000 e28b9c00 00000000
GPR24: e2805c68 00000040 00000000 29a7f100 e9a7f028 e9665ec8 e2805c00 e6c07840
NIP [c0017f1c] memcpy+0x3c/0x9c
LR [c04053a8] ahash_update_first+0x2a8/0x814
Call Trace:
[e29bbbc0] [c0405388] ahash_update_first+0x288/0x814 (unreliable)
[e29bbc20] [c0402bf8] ahash_update+0x18/0x28
[e29bbc30] [c01e06c0] cryptodev_hash_update+0x44/0xcc
[e29bbc40] [c01df5ec] hash_n_crypt.isra.0+0xdc/0x160
[e29bbc60] [c01dfaa4] crypto_run+0x194/0x360
[e29bbc90] [c01df1dc] cryptodev_ioctl+0x510/0x844
[e29bbea0] [c00d0870] do_vfs_ioctl+0xa4/0x764
[e29bbf10] [c00d0f70] sys_ioctl+0x40/0x70

Issue is pages are direct IO mapped using get_user_pages in kernel and thus
require kmap before reading/writing and subsequently kunmap.

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
Seems the patch is not applied yet over linux so resending. Originally sent 
on 29th September.

Patch is tested with following:

1) openssl speed test with cryptodev:
	openssl speed md5 -engine cryptodev
2) tcrypt
	modprobe tcrypt sec=2 mode=402
	modprobe tcrypt sec=2 mode=403
 drivers/crypto/caam/sg_sw_sec4.h |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index e0037c8..12ebae1 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -117,6 +117,21 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 	return nents;
 }
 
+/* Map SG page in kernel virtual address space and copy */
+static inline void sg_map_copy(u8 *dest, struct scatterlist *sg,
+					int len, int offset)
+{
+	u8 *mapped_addr;
+
+	/*
+	 * Page here can be user-space pinned using get_user_pages
+	 * Same must be kmapped before use and kunmapped subsequently
+	 */
+	mapped_addr = kmap(sg_page(sg));
+	memcpy(dest, mapped_addr + offset, len);
+	kunmap(sg_page(sg));
+}
+
 /* Copy from len bytes of sg to dest, starting from beginning */
 static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
 {
@@ -124,15 +139,15 @@ static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
 	int cpy_index = 0, next_cpy_index = current_sg->length;
 
 	while (next_cpy_index < len) {
-		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
-		       current_sg->length);
+		sg_map_copy(dest + cpy_index, current_sg, current_sg->length,
+				current_sg->offset);
 		current_sg = scatterwalk_sg_next(current_sg);
 		cpy_index = next_cpy_index;
 		next_cpy_index += current_sg->length;
 	}
 	if (cpy_index < len)
-		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
-		       len - cpy_index);
+		sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
+				current_sg->offset);
 }
 
 /* Copy sg data, from to_skip to end, to dest */
@@ -140,7 +155,7 @@ static inline void sg_copy_part(u8 *dest, struct scatterlist *sg,
 				      int to_skip, unsigned int end)
 {
 	struct scatterlist *current_sg = sg;
-	int sg_index, cpy_index;
+	int sg_index, cpy_index, offset;
 
 	sg_index = current_sg->length;
 	while (sg_index <= to_skip) {
@@ -148,9 +163,10 @@ static inline void sg_copy_part(u8 *dest, struct scatterlist *sg,
 		sg_index += current_sg->length;
 	}
 	cpy_index = sg_index - to_skip;
-	memcpy(dest, (u8 *) sg_virt(current_sg) +
-	       current_sg->length - cpy_index, cpy_index);
-	current_sg = scatterwalk_sg_next(current_sg);
-	if (end - sg_index)
+	offset = current_sg->offset + current_sg->length - cpy_index;
+	sg_map_copy(dest, current_sg, cpy_index, offset);
+	if (end - sg_index) {
+		current_sg = scatterwalk_sg_next(current_sg);
 		sg_copy(dest + cpy_index, current_sg, end - sg_index);
+	}
 }
-- 
1.7.0.4
