From: Martin Hicks <mort@bork.org>
Subject: [PATCH 2/2] crypto: talitos: Add AES-XTS Support
Date: Fri, 20 Feb 2015 12:00:10 -0500
Message-ID: <1424451610-5786-3-git-send-email-mort@bork.org>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45779 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbbBTRAT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 12:00:19 -0500
Received: by iecat20 with SMTP id at20so9192713iec.12
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 09:00:18 -0800 (PST)
In-Reply-To: <1424451610-5786-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The newer talitos hardware has support for AES in XTS mode.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |   33 +++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h |    1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6b2a19a..38cbde1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -40,9 +40,11 @@
 #include <linux/spinlock.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <linux/device-mapper.h>
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/xts.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
@@ -1464,9 +1466,22 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 						    areq, bool encrypt)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct crypto_tfm *tfm = (struct crypto_tfm *)cipher;
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
 
+	/*
+	 * AES-XTS uses the first two AES Context registers for:
+	 *
+	 *     Register 1:   Sector Number (Little Endian)
+	 *     Register 2:   Sector Size   (Big Endian)
+	 *
+	 * Whereas AES-CBC uses registers 1/2 as a 16-byte IV.
+	 */
+	if (!strcmp(crypto_tfm_alg_name(tfm),"xts(aes)"))
+		/* Fixed sized sector */
+		*((u64 *)areq->info + 1) = cpu_to_be64((1<<SECTOR_SHIFT));
+
 	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
 				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
 				   areq->base.flags, &areq->base, encrypt);
@@ -2192,6 +2207,24 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE0_DEU_CBC |
 		                     DESC_HDR_MODE0_DEU_3DES,
 	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "xts(aes)",
+			.cra_driver_name = "xts-aes-talitos",
+			.cra_blocksize = XTS_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+                                     CRYPTO_ALG_ASYNC,
+			.cra_ablkcipher = {
+				.min_keysize = AES_MIN_KEY_SIZE * 2,
+				.max_keysize = AES_MAX_KEY_SIZE * 2,
+				.ivsize = XTS_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_XTS,
+	},
+
 	/* AHASH algorithms. */
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index a6f73e2..735da82 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -316,6 +316,7 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edes
 /* primary execution unit mode (MODE0) and derivatives */
 #define	DESC_HDR_MODE0_ENCRYPT		cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_AESU_XTS		cpu_to_be32(0x04200000)
 #define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
 #define	DESC_HDR_MODE0_DEU_3DES		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_CONT	cpu_to_be32(0x08000000)
-- 
1.7.10.4
