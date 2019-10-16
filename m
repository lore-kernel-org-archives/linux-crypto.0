Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A345FA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 12:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59334218DE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 12:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbfJPM0y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 08:26:54 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:51121 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390650AbfJPM0y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 08:26:54 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKiNu-0007GA-ME; Wed, 16 Oct 2019 13:26:34 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKiNu-0000aZ-6f; Wed, 16 Oct 2019 13:26:34 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel - fix data types for __be{32,64}
Date:   Wed, 16 Oct 2019 13:26:33 +0100
Message-Id: <20191016122633.2220-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver uses a couple of buffers that seem to
be __be32 or __be64 fields, but declares them as
u32. This means there are a number of warnings
from sparse due to casting to/from __beXXX.

Fix these by changing the types of the buffer
and the associated variables.

drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1023:15: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1059:28: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1059:28:    expected unsigned int
drivers/crypto/atmel-aes.c:1059:28:    got restricted __be32 [usertype]
drivers/crypto/atmel-aes.c:1550:28: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1550:28:    expected unsigned int
drivers/crypto/atmel-aes.c:1550:28:    got restricted __be32 [usertype]
drivers/crypto/atmel-aes.c:1561:39: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1561:39:    expected unsigned long long [usertype]
drivers/crypto/atmel-aes.c:1561:39:    got restricted __be64 [usertype]
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:17: warning: cast to restricted __be32
drivers/crypto/atmel-aes.c:1599:15: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1599:15:    expected unsigned int [usertype]
drivers/crypto/atmel-aes.c:1599:15:    got restricted __be32 [usertype]
drivers/crypto/atmel-aes.c:1692:17: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1692:17:    expected unsigned long long [usertype]
drivers/crypto/atmel-aes.c:1692:17:    got restricted __be64 [usertype]
drivers/crypto/atmel-aes.c:1693:17: warning: incorrect type in assignment (different base types)
drivers/crypto/atmel-aes.c:1693:17:    expected unsigned long long [usertype]
drivers/crypto/atmel-aes.c:1693:17:    got restricted __be64 [usertype]
drivers/crypto/atmel-aes.c:1888:63: warning: incorrect type in initializer (different base types)
drivers/crypto/atmel-aes.c:1888:63:    expected unsigned int
drivers/crypto/atmel-aes.c:1888:63:    got restricted __le32 [usertype]

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
.. (open list)
---
 drivers/crypto/atmel-aes.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 026f193556f9..6e658be32c2c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -117,7 +117,7 @@ struct atmel_aes_ctx {
 struct atmel_aes_ctr_ctx {
 	struct atmel_aes_base_ctx	base;
 
-	u32			iv[AES_BLOCK_SIZE / sizeof(u32)];
+	__be32			iv[AES_BLOCK_SIZE / sizeof(u32)];
 	size_t			offset;
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
@@ -129,13 +129,13 @@ struct atmel_aes_gcm_ctx {
 	struct scatterlist	src[2];
 	struct scatterlist	dst[2];
 
-	u32			j0[AES_BLOCK_SIZE / sizeof(u32)];
+	__be32			j0[AES_BLOCK_SIZE / sizeof(u32)];
 	u32			tag[AES_BLOCK_SIZE / sizeof(u32)];
-	u32			ghash[AES_BLOCK_SIZE / sizeof(u32)];
+	__be32			ghash[AES_BLOCK_SIZE / sizeof(u32)];
 	size_t			textlen;
 
-	const u32		*ghash_in;
-	u32			*ghash_out;
+	const __be32		*ghash_in;
+	__be32			*ghash_out;
 	atmel_aes_fn_t		ghash_resume;
 };
 
@@ -388,13 +388,13 @@ static void atmel_aes_write_n(struct atmel_aes_dev *dd, u32 offset,
 }
 
 static inline void atmel_aes_read_block(struct atmel_aes_dev *dd, u32 offset,
-					u32 *value)
+					void *value)
 {
 	atmel_aes_read_n(dd, offset, value, SIZE_IN_WORDS(AES_BLOCK_SIZE));
 }
 
 static inline void atmel_aes_write_block(struct atmel_aes_dev *dd, u32 offset,
-					 const u32 *value)
+					 const void *value)
 {
 	atmel_aes_write_n(dd, offset, value, SIZE_IN_WORDS(AES_BLOCK_SIZE));
 }
@@ -530,7 +530,7 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 }
 
 static void atmel_aes_write_ctrl_key(struct atmel_aes_dev *dd, bool use_dma,
-				     const u32 *iv, const u32 *key, int keylen)
+				     const __be32 *iv, const u32 *key, int keylen)
 {
 	u32 valmr = 0;
 
@@ -561,7 +561,7 @@ static void atmel_aes_write_ctrl_key(struct atmel_aes_dev *dd, bool use_dma,
 }
 
 static inline void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
-					const u32 *iv)
+					const __be32 *iv)
 
 {
 	atmel_aes_write_ctrl_key(dd, use_dma, iv,
@@ -1450,7 +1450,7 @@ static struct crypto_alg aes_cfb64_alg = {
 
 static int atmel_aes_gcm_ghash(struct atmel_aes_dev *dd,
 			       const u32 *data, size_t datalen,
-			       const u32 *ghash_in, u32 *ghash_out,
+			       const __be32 *ghash_in, __be32 *ghash_out,
 			       atmel_aes_fn_t resume);
 static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd);
 static int atmel_aes_gcm_ghash_finalize(struct atmel_aes_dev *dd);
@@ -1471,7 +1471,7 @@ atmel_aes_gcm_ctx_cast(struct atmel_aes_base_ctx *ctx)
 
 static int atmel_aes_gcm_ghash(struct atmel_aes_dev *dd,
 			       const u32 *data, size_t datalen,
-			       const u32 *ghash_in, u32 *ghash_out,
+			       const __be32 *ghash_in, __be32 *ghash_out,
 			       atmel_aes_fn_t resume)
 {
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
@@ -1558,7 +1558,7 @@ static int atmel_aes_gcm_start(struct atmel_aes_dev *dd)
 
 	memcpy(data, iv, ivsize);
 	memset(data + ivsize, 0, padlen + sizeof(u64));
-	((u64 *)(data + datalen))[-1] = cpu_to_be64(ivsize * 8);
+	((__be64 *)(data + datalen))[-1] = cpu_to_be64(ivsize * 8);
 
 	return atmel_aes_gcm_ghash(dd, (const u32 *)data, datalen,
 				   NULL, ctx->j0, atmel_aes_gcm_process);
@@ -1591,7 +1591,7 @@ static int atmel_aes_gcm_length(struct atmel_aes_dev *dd)
 {
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 	struct aead_request *req = aead_request_cast(dd->areq);
-	u32 j0_lsw, *j0 = ctx->j0;
+	__be32 j0_lsw, *j0 = ctx->j0;
 	size_t padlen;
 
 	/* Write incr32(J0) into IV. */
@@ -1674,7 +1674,7 @@ static int atmel_aes_gcm_tag_init(struct atmel_aes_dev *dd)
 {
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 	struct aead_request *req = aead_request_cast(dd->areq);
-	u64 *data = dd->buf;
+	__be64 *data = dd->buf;
 
 	if (likely(dd->flags & AES_FLAGS_GTAGEN)) {
 		if (!(atmel_aes_read(dd, AES_ISR) & AES_INT_TAGRDY)) {
@@ -1885,7 +1885,7 @@ static int atmel_aes_xts_process_data(struct atmel_aes_dev *dd)
 	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
 	bool use_dma = (req->nbytes >= ATMEL_AES_DMA_THRESHOLD);
 	u32 tweak[AES_BLOCK_SIZE / sizeof(u32)];
-	static const u32 one[AES_BLOCK_SIZE / sizeof(u32)] = {cpu_to_le32(1), };
+	static const __le32 one[AES_BLOCK_SIZE / sizeof(u32)] = {cpu_to_le32(1), };
 	u8 *tweak_bytes = (u8 *)tweak;
 	int i;
 
-- 
2.23.0

