Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EA9C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EFC02395C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhANGks (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 01:40:48 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42136 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbhANGks (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 01:40:48 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwIY-00082D-UX; Thu, 14 Jan 2021 17:40:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:39:58 +1100
Date:   Thu, 14 Jan 2021 17:39:58 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
Subject: [PATCH] crypto: bcm - Fix sparse warnings
Message-ID: <20210114063958.GA498@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a number of sparse warnings in the bcm driver.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 0e5537838ef3..851b149f7170 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -471,10 +471,8 @@ static int handle_skcipher_req(struct iproc_reqctx_s *rctx)
 static void handle_skcipher_resp(struct iproc_reqctx_s *rctx)
 {
 	struct spu_hw *spu = &iproc_priv.spu;
-#ifdef DEBUG
 	struct crypto_async_request *areq = rctx->parent;
 	struct skcipher_request *req = skcipher_request_cast(areq);
-#endif
 	struct iproc_ctx_s *ctx = rctx->ctx;
 	u32 payload_len;
 
@@ -996,13 +994,11 @@ static int ahash_req_done(struct iproc_reqctx_s *rctx)
 static void handle_ahash_resp(struct iproc_reqctx_s *rctx)
 {
 	struct iproc_ctx_s *ctx = rctx->ctx;
-#ifdef DEBUG
 	struct crypto_async_request *areq = rctx->parent;
 	struct ahash_request *req = ahash_request_cast(areq);
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	unsigned int blocksize =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
-#endif
 	/*
 	 * Save hash to use as input to next op if incremental. Might be copying
 	 * too much, but that's easier than figuring out actual digest size here
diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index fe126f95c702..007abf92cc05 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -41,7 +41,7 @@ void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 	packet_log("SPU Message header %p len: %u\n", buf, buf_len);
 
 	/* ========== Decode MH ========== */
-	packet_log("  MH 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+	packet_log("  MH 0x%08x\n", be32_to_cpup((__be32 *)ptr));
 	if (spuh->mh.flags & MH_SCTX_PRES)
 		packet_log("    SCTX  present\n");
 	if (spuh->mh.flags & MH_BDESC_PRES)
@@ -273,22 +273,21 @@ void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 
 	/* ========== Decode BDESC ========== */
 	if (spuh->mh.flags & MH_BDESC_PRES) {
-#ifdef DEBUG
 		struct BDESC_HEADER *bdesc = (struct BDESC_HEADER *)ptr;
-#endif
-		packet_log("  BDESC[0] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+
+		packet_log("  BDESC[0] 0x%08x\n", be32_to_cpup((__be32 *)ptr));
 		packet_log("    OffsetMAC:%u LengthMAC:%u\n",
 			   be16_to_cpu(bdesc->offset_mac),
 			   be16_to_cpu(bdesc->length_mac));
 		ptr += sizeof(u32);
 
-		packet_log("  BDESC[1] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("  BDESC[1] 0x%08x\n", be32_to_cpup((__be32 *)ptr));
 		packet_log("    OffsetCrypto:%u LengthCrypto:%u\n",
 			   be16_to_cpu(bdesc->offset_crypto),
 			   be16_to_cpu(bdesc->length_crypto));
 		ptr += sizeof(u32);
 
-		packet_log("  BDESC[2] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("  BDESC[2] 0x%08x\n", be32_to_cpup((__be32 *)ptr));
 		packet_log("    OffsetICV:%u OffsetIV:%u\n",
 			   be16_to_cpu(bdesc->offset_icv),
 			   be16_to_cpu(bdesc->offset_iv));
@@ -297,10 +296,9 @@ void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 
 	/* ========== Decode BD ========== */
 	if (spuh->mh.flags & MH_BD_PRES) {
-#ifdef DEBUG
 		struct BD_HEADER *bd = (struct BD_HEADER *)ptr;
-#endif
-		packet_log("  BD[0] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+
+		packet_log("  BD[0] 0x%08x\n", be32_to_cpup((__be32 *)ptr));
 		packet_log("    Size:%ubytes PrevLength:%u\n",
 			   be16_to_cpu(bd->size), be16_to_cpu(bd->prev_length));
 		ptr += 4;
@@ -1056,9 +1054,9 @@ void spum_request_pad(u8 *pad_start,
 
 			/* add the size at the end as required per alg */
 			if (auth_alg == HASH_ALG_MD5)
-				*(u64 *)ptr = cpu_to_le64((u64)total_sent * 8);
+				*(__le64 *)ptr = cpu_to_le64(total_sent * 8ull);
 			else		/* SHA1, SHA2-224, SHA2-256 */
-				*(u64 *)ptr = cpu_to_be64((u64)total_sent * 8);
+				*(__be64 *)ptr = cpu_to_be64(total_sent * 8ull);
 			ptr += sizeof(u64);
 		}
 	}
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index c860ffb0b4c3..2db35b5ccaa2 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -964,7 +964,6 @@ u32 spu2_create_request(u8 *spu_hdr,
 	unsigned int cipher_offset = aead_parms->assoc_size +
 			aead_parms->aad_pad_len + aead_parms->iv_len;
 
-#ifdef DEBUG
 	/* total size of the data following OMD (without STAT word padding) */
 	unsigned int real_db_size = spu_real_db_size(aead_parms->assoc_size,
 						 aead_parms->iv_len,
@@ -973,7 +972,6 @@ u32 spu2_create_request(u8 *spu_hdr,
 						 aead_parms->aad_pad_len,
 						 aead_parms->data_pad_len,
 						 hash_parms->pad_len);
-#endif
 	unsigned int assoc_size = aead_parms->assoc_size;
 
 	if (req_opts->is_aead &&
@@ -1263,9 +1261,9 @@ void spu2_request_pad(u8 *pad_start, u32 gcm_padding, u32 hash_pad_len,
 
 		/* add the size at the end as required per alg */
 		if (auth_alg == HASH_ALG_MD5)
-			*(u64 *)ptr = cpu_to_le64((u64)total_sent * 8);
+			*(__le64 *)ptr = cpu_to_le64(total_sent * 8ull);
 		else		/* SHA1, SHA2-224, SHA2-256 */
-			*(u64 *)ptr = cpu_to_be64((u64)total_sent * 8);
+			*(__be64 *)ptr = cpu_to_be64(total_sent * 8ull);
 		ptr += sizeof(u64);
 	}
 
diff --git a/drivers/crypto/bcm/spu2.h b/drivers/crypto/bcm/spu2.h
index 6e666bfb3cfc..a76d4e054466 100644
--- a/drivers/crypto/bcm/spu2.h
+++ b/drivers/crypto/bcm/spu2.h
@@ -73,10 +73,10 @@ enum spu2_ret_md_opts {
 
 /* Fixed Metadata format */
 struct SPU2_FMD {
-	u64 ctrl0;
-	u64 ctrl1;
-	u64 ctrl2;
-	u64 ctrl3;
+	__le64 ctrl0;
+	__le64 ctrl1;
+	__le64 ctrl2;
+	__le64 ctrl3;
 };
 
 #define FMD_SIZE  sizeof(struct SPU2_FMD)
diff --git a/drivers/crypto/bcm/spum.h b/drivers/crypto/bcm/spum.h
index 6116ad1dd26e..f062f75808de 100644
--- a/drivers/crypto/bcm/spum.h
+++ b/drivers/crypto/bcm/spum.h
@@ -69,18 +69,18 @@
 
 /* Buffer Descriptor Header [BDESC]. SPU in big-endian mode. */
 struct BDESC_HEADER {
-	u16 offset_mac;		/* word 0 [31-16] */
-	u16 length_mac;		/* word 0 [15-0]  */
-	u16 offset_crypto;	/* word 1 [31-16] */
-	u16 length_crypto;	/* word 1 [15-0]  */
-	u16 offset_icv;		/* word 2 [31-16] */
-	u16 offset_iv;		/* word 2 [15-0]  */
+	__be16 offset_mac;		/* word 0 [31-16] */
+	__be16 length_mac;		/* word 0 [15-0]  */
+	__be16 offset_crypto;		/* word 1 [31-16] */
+	__be16 length_crypto;		/* word 1 [15-0]  */
+	__be16 offset_icv;		/* word 2 [31-16] */
+	__be16 offset_iv;		/* word 2 [15-0]  */
 };
 
 /* Buffer Data Header [BD]. SPU in big-endian mode. */
 struct BD_HEADER {
-	u16 size;
-	u16 prev_length;
+	__be16 size;
+	__be16 prev_length;
 };
 
 /* Command Context Header. SPU-M in big endian mode. */
@@ -144,13 +144,13 @@ struct MHEADER {
 /* Generic Mode Security Context Structure [SCTX] */
 struct SCTX {
 /* word 0: protocol flags */
-	u32 proto_flags;
+	__be32 proto_flags;
 
 /* word 1: cipher flags */
-	u32 cipher_flags;
+	__be32 cipher_flags;
 
 /* word 2: Extended cipher flags */
-	u32 ecf;
+	__be32 ecf;
 
 };
 
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 77aeedb84055..c4669a96eaec 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -268,6 +268,7 @@ int do_shash(unsigned char *name, unsigned char *result,
 	return rc;
 }
 
+#ifdef DEBUG
 /* Dump len bytes of a scatterlist starting at skip bytes into the sg */
 void __dump_sg(struct scatterlist *sg, unsigned int skip, unsigned int len)
 {
@@ -289,6 +290,7 @@ void __dump_sg(struct scatterlist *sg, unsigned int skip, unsigned int len)
 	if (debug_logging_sleep)
 		msleep(debug_logging_sleep);
 }
+#endif
 
 /* Returns the name for a given cipher alg/mode */
 char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
diff --git a/drivers/crypto/bcm/util.h b/drivers/crypto/bcm/util.h
index a89b2b9c1f52..61c256384816 100644
--- a/drivers/crypto/bcm/util.h
+++ b/drivers/crypto/bcm/util.h
@@ -58,12 +58,26 @@ void __dump_sg(struct scatterlist *sg, unsigned int skip, unsigned int len);
 
 #else /* !DEBUG_ON */
 
-#define flow_log(...) do {} while (0)
-#define flow_dump(msg, var, var_len) do {} while (0)
-#define packet_log(...) do {} while (0)
-#define packet_dump(msg, var, var_len) do {} while (0)
-
-#define dump_sg(sg, skip, len) do {} while (0)
+static inline void flow_log(const char *format, ...)
+{
+}
+
+static inline void flow_dump(const char *msg, const void *var, size_t var_len)
+{
+}
+
+static inline void packet_log(const char *format, ...)
+{
+}
+
+static inline void packet_dump(const char *msg, const void *var, size_t var_len)
+{
+}
+
+static inline void dump_sg(struct scatterlist *sg, unsigned int skip,
+			   unsigned int len)
+{
+}
 
 #endif /* DEBUG_ON */
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
