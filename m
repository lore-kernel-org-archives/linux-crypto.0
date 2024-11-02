Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FA61448E0;
	Sat,  2 Nov 2024 02:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730516174; cv=none; b=A+TBjWVdBE/ChJcZ+4IpCbZaqqRlpglQZ8ELACx2Ex+/UiTglEJ8WKjC0TwIYDBPaS4VO2XvWFJZdtYc2kySPQhs7O0B7FHr0hNekHXhgksv54W1BU/Ik+qx+ZeBE/XSMqUSKIdyshmmSKiOd19Rp7WRb2gVtm6dw7sf/7BJiWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730516174; c=relaxed/simple;
	bh=GEwtf78cD4y+rCJ1s3uaU/k4waiB1eqwemrGCaeuoyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MW8/gqilm7k9AlpanNgYRTffQgeuJVMAW5qE9Wa9kmmrTtSf/Ws/8+0y0tINBhsmeX910g/7s+5o6Gh6897Ry4pSv7N2Hbh2v53XWkPY8zVlF3u0Cwtz5wP6izMmfg29J7CXlMHCjfAcH08XLZcnjkhXeO0KfyqZd++kRCnQM2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XgMll0fYNzQsXx;
	Sat,  2 Nov 2024 10:54:59 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 894D9140337;
	Sat,  2 Nov 2024 10:56:01 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Nov 2024 10:56:00 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH v3 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Date: Sat, 2 Nov 2024 10:55:58 +0800
Message-ID: <20241102025559.2256734-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241102025559.2256734-1-huangchenghai2@huawei.com>
References: <20241102025559.2256734-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

When the AEAD algorithm is used for encryption or decryption,
the input authentication length varies, the hardware needs to
obtain the input length to pass the integrity check verification.
Currently, the driver uses a fixed authentication length,which
causes decryption failure, so the length configuration is modified.
In addition, the step of setting the auth length is unnecessary,
so it was deleted from the setkey function.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 101 +++++++++------------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 ---
 3 files changed, 44 insertions(+), 69 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 356188bee6fb..70c3bdedb6ba 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -90,7 +90,6 @@ struct sec_auth_ctx {
 	dma_addr_t a_key_dma;
 	u8 *a_key;
 	u8 a_key_len;
-	u8 mac_len;
 	u8 a_alg;
 	bool fallback;
 	struct crypto_shash *hash_tfm;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index ae9ebbb4103d..8db995279545 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -948,15 +948,14 @@ static int sec_aead_mac_init(struct sec_aead_req *req)
 	struct aead_request *aead_req = req->aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
 	size_t authsize = crypto_aead_authsize(tfm);
-	u8 *mac_out = req->out_mac;
 	struct scatterlist *sgl = aead_req->src;
+	u8 *mac_out = req->out_mac;
 	size_t copy_size;
 	off_t skip_size;
 
 	/* Copy input mac */
 	skip_size = aead_req->assoclen + aead_req->cryptlen - authsize;
-	copy_size = sg_pcopy_to_buffer(sgl, sg_nents(sgl), mac_out,
-				       authsize, skip_size);
+	copy_size = sg_pcopy_to_buffer(sgl, sg_nents(sgl), mac_out, authsize, skip_size);
 	if (unlikely(copy_size != authsize))
 		return -EINVAL;
 
@@ -1139,7 +1138,6 @@ static int sec_aead_fallback_setkey(struct sec_auth_ctx *a_ctx,
 static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			   const u32 keylen, const enum sec_hash_alg a_alg,
 			   const enum sec_calg c_alg,
-			   const enum sec_mac_len mac_len,
 			   const enum sec_cmode c_mode)
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1151,7 +1149,6 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	ctx->a_ctx.a_alg = a_alg;
 	ctx->c_ctx.c_alg = c_alg;
-	ctx->a_ctx.mac_len = mac_len;
 	c_ctx->c_mode = c_mode;
 
 	if (c_mode == SEC_CMODE_CCM || c_mode == SEC_CMODE_GCM) {
@@ -1187,10 +1184,9 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
-	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
-	    (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
+	if (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK) {
 		ret = -EINVAL;
-		dev_err(dev, "MAC or AUTH key length error!\n");
+		dev_err(dev, "AUTH key length error!\n");
 		goto bad_key;
 	}
 
@@ -1202,27 +1198,19 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 }
 
 
-#define GEN_SEC_AEAD_SETKEY_FUNC(name, aalg, calg, maclen, cmode)	\
-static int sec_setkey_##name(struct crypto_aead *tfm, const u8 *key,	\
-	u32 keylen)							\
-{									\
-	return sec_aead_setkey(tfm, key, keylen, aalg, calg, maclen, cmode);\
-}
-
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha1, SEC_A_HMAC_SHA1,
-			 SEC_CALG_AES, SEC_HMAC_SHA1_MAC, SEC_CMODE_CBC)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha256, SEC_A_HMAC_SHA256,
-			 SEC_CALG_AES, SEC_HMAC_SHA256_MAC, SEC_CMODE_CBC)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha512, SEC_A_HMAC_SHA512,
-			 SEC_CALG_AES, SEC_HMAC_SHA512_MAC, SEC_CMODE_CBC)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_ccm, 0, SEC_CALG_AES,
-			 SEC_HMAC_CCM_MAC, SEC_CMODE_CCM)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_gcm, 0, SEC_CALG_AES,
-			 SEC_HMAC_GCM_MAC, SEC_CMODE_GCM)
-GEN_SEC_AEAD_SETKEY_FUNC(sm4_ccm, 0, SEC_CALG_SM4,
-			 SEC_HMAC_CCM_MAC, SEC_CMODE_CCM)
-GEN_SEC_AEAD_SETKEY_FUNC(sm4_gcm, 0, SEC_CALG_SM4,
-			 SEC_HMAC_GCM_MAC, SEC_CMODE_GCM)
+#define GEN_SEC_AEAD_SETKEY_FUNC(name, aalg, calg, cmode)				\
+static int sec_setkey_##name(struct crypto_aead *tfm, const u8 *key, u32 keylen)	\
+{											\
+	return sec_aead_setkey(tfm, key, keylen, aalg, calg, cmode);			\
+}
+
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha1, SEC_A_HMAC_SHA1, SEC_CALG_AES, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha256, SEC_A_HMAC_SHA256, SEC_CALG_AES, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha512, SEC_A_HMAC_SHA512, SEC_CALG_AES, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_ccm, 0, SEC_CALG_AES, SEC_CMODE_CCM)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_gcm, 0, SEC_CALG_AES, SEC_CMODE_GCM)
+GEN_SEC_AEAD_SETKEY_FUNC(sm4_ccm, 0, SEC_CALG_SM4, SEC_CMODE_CCM)
+GEN_SEC_AEAD_SETKEY_FUNC(sm4_gcm, 0, SEC_CALG_SM4, SEC_CMODE_GCM)
 
 static int sec_aead_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
 {
@@ -1470,9 +1458,10 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
-	struct sec_cipher_req *c_req = &req->c_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
+	size_t authsize = crypto_aead_authsize(tfm);
 	struct sec_aead_req *a_req = &req->aead_req;
-	size_t authsize = ctx->a_ctx.mac_len;
+	struct sec_cipher_req *c_req = &req->c_req;
 	u32 data_size = aead_req->cryptlen;
 	u8 flage = 0;
 	u8 cm, cl;
@@ -1513,10 +1502,8 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
-	size_t authsize = crypto_aead_authsize(tfm);
-	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_aead_req *a_req = &req->aead_req;
+	struct sec_cipher_req *c_req = &req->c_req;
 
 	memcpy(c_req->c_ivin, aead_req->iv, ctx->c_ctx.ivsize);
 
@@ -1524,15 +1511,11 @@ static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
 		/*
 		 * CCM 16Byte Cipher_IV: {1B_Flage,13B_IV,2B_counter},
 		 * the  counter must set to 0x01
+		 * CCM 16Byte Auth_IV: {1B_AFlage,13B_IV,2B_Ptext_length}
 		 */
-		ctx->a_ctx.mac_len = authsize;
-		/* CCM 16Byte Auth_IV: {1B_AFlage,13B_IV,2B_Ptext_length} */
 		set_aead_auth_iv(ctx, req);
-	}
-
-	/* GCM 12Byte Cipher_IV == Auth_IV */
-	if (ctx->c_ctx.c_mode == SEC_CMODE_GCM) {
-		ctx->a_ctx.mac_len = authsize;
+	} else if (ctx->c_ctx.c_mode == SEC_CMODE_GCM) {
+		/* GCM 12Byte Cipher_IV == Auth_IV */
 		memcpy(a_req->a_ivin, c_req->c_ivin, SEC_AIV_SIZE);
 	}
 }
@@ -1542,9 +1525,11 @@ static void sec_auth_bd_fill_xcm(struct sec_auth_ctx *ctx, int dir,
 {
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct aead_request *aq = a_req->aead_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aq);
+	size_t authsize = crypto_aead_authsize(tfm);
 
 	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
-	sec_sqe->type2.icvw_kmode |= cpu_to_le16((u16)ctx->mac_len);
+	sec_sqe->type2.icvw_kmode |= cpu_to_le16((u16)authsize);
 
 	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
 	sec_sqe->type2.a_key_addr = sec_sqe->type2.c_key_addr;
@@ -1568,9 +1553,11 @@ static void sec_auth_bd_fill_xcm_v3(struct sec_auth_ctx *ctx, int dir,
 {
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct aead_request *aq = a_req->aead_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aq);
+	size_t authsize = crypto_aead_authsize(tfm);
 
 	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
-	sqe3->c_icv_key |= cpu_to_le16((u16)ctx->mac_len << SEC_MAC_OFFSET_V3);
+	sqe3->c_icv_key |= cpu_to_le16((u16)authsize << SEC_MAC_OFFSET_V3);
 
 	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
 	sqe3->a_key_addr = sqe3->c_key_addr;
@@ -1594,11 +1581,12 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct aead_request *aq = a_req->aead_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aq);
+	size_t authsize = crypto_aead_authsize(tfm);
 
 	sec_sqe->type2.a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
-	sec_sqe->type2.mac_key_alg =
-			cpu_to_le32(ctx->mac_len / SEC_SQE_LEN_RATE);
+	sec_sqe->type2.mac_key_alg = cpu_to_le32(authsize / SEC_SQE_LEN_RATE);
 
 	sec_sqe->type2.mac_key_alg |=
 			cpu_to_le32((u32)((ctx->a_key_len) /
@@ -1648,11 +1636,13 @@ static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct aead_request *aq = a_req->aead_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aq);
+	size_t authsize = crypto_aead_authsize(tfm);
 
 	sqe3->a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(ctx->mac_len /
+			cpu_to_le32((u32)(authsize /
 			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
@@ -1703,9 +1693,9 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 {
 	struct aead_request *a_req = req->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
+	size_t authsize = crypto_aead_authsize(tfm);
 	struct sec_aead_req *aead_req = &req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
-	size_t authsize = crypto_aead_authsize(tfm);
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	struct aead_request *backlog_aead_req;
 	struct sec_req *backlog_req;
@@ -1718,10 +1708,8 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 	if (!err && c_req->encrypt) {
 		struct scatterlist *sgl = a_req->dst;
 
-		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl),
-					  aead_req->out_mac,
-					  authsize, a_req->cryptlen +
-					  a_req->assoclen);
+		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl), aead_req->out_mac,
+					  authsize, a_req->cryptlen + a_req->assoclen);
 		if (unlikely(sz != authsize)) {
 			dev_err(c->dev, "copy out mac err!\n");
 			err = -EINVAL;
@@ -2233,7 +2221,7 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	size_t authsize = crypto_aead_authsize(tfm);
+	size_t sz = crypto_aead_authsize(tfm);
 	u8 c_mode = ctx->c_ctx.c_mode;
 	struct device *dev = ctx->dev;
 	int ret;
@@ -2244,9 +2232,8 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		return -EINVAL;
 	}
 
-	if (unlikely((c_mode == SEC_CMODE_GCM && authsize < DES_BLOCK_SIZE) ||
-	   (c_mode == SEC_CMODE_CCM && (authsize < MIN_MAC_LEN ||
-		authsize & MAC_LEN_MASK)))) {
+	if (unlikely((c_mode == SEC_CMODE_GCM && sz < DES_BLOCK_SIZE) ||
+		     (c_mode == SEC_CMODE_CCM && (sz < MIN_MAC_LEN || sz & MAC_LEN_MASK)))) {
 		dev_err(dev, "aead input mac length error!\n");
 		return -EINVAL;
 	}
@@ -2266,7 +2253,7 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	if (sreq->c_req.encrypt)
 		sreq->c_req.c_len = req->cryptlen;
 	else
-		sreq->c_req.c_len = req->cryptlen - authsize;
+		sreq->c_req.c_len = req->cryptlen - sz;
 	if (c_mode == SEC_CMODE_CBC) {
 		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
 			dev_err(dev, "aead crypto length error!\n");
@@ -2292,7 +2279,7 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 
 	if (ctx->sec->qm.ver == QM_HW_V2) {
 		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
-		    req->cryptlen <= authsize))) {
+			     req->cryptlen <= authsize))) {
 			ctx->a_ctx.fallback = true;
 			return -EINVAL;
 		}
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 27a0ee5ad913..04725b514382 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -23,17 +23,6 @@ enum sec_hash_alg {
 	SEC_A_HMAC_SHA512 = 0x15,
 };
 
-enum sec_mac_len {
-	SEC_HMAC_CCM_MAC   = 16,
-	SEC_HMAC_GCM_MAC   = 16,
-	SEC_SM3_MAC        = 32,
-	SEC_HMAC_SM3_MAC   = 32,
-	SEC_HMAC_MD5_MAC   = 16,
-	SEC_HMAC_SHA1_MAC   = 20,
-	SEC_HMAC_SHA256_MAC = 32,
-	SEC_HMAC_SHA512_MAC = 64,
-};
-
 enum sec_cmode {
 	SEC_CMODE_ECB    = 0x0,
 	SEC_CMODE_CBC    = 0x1,
-- 
2.33.0

