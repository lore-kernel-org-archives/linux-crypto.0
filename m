Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E37184D;
	Sun, 29 Sep 2024 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727609201; cv=none; b=U70zlhdONSilaxVjPUKTfNBLBklRj7fYzxYxSRhB1bp/ZBXdAIzc75f4LTcfzFeUEN+6vtY1jDLPq9Z87kTDsc7BzOCcDinc0W1cH9frkzwG+kLO2oYDjpubUc3pfkH84+p9lpqVtxePc8w2pBVNlSfhNBHMWGZEbvQaQymlAuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727609201; c=relaxed/simple;
	bh=aIg74aAzYGS0idcHOsR67BPcNviKtHfa339aiuBqonM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pU5Lv5TmJ6bjWjubcHp6UxkJYqruoLm5WIvxw2kina2SzeBuD+vXfVe2QM+Ebdy2i8ODCBlUxqgluKXoeU0fJW5ZgksvWITyldekQps0WhVsn7IMVK8vuTRl2/QPv+CX8nOeCwtqPlK5+8ZxG6dkFq45d/53PdxPPlfl+eizeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XGhjB2dgxzFr1s;
	Sun, 29 Sep 2024 19:26:06 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 456481400D4;
	Sun, 29 Sep 2024 19:26:32 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 29 Sep 2024 19:26:31 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Date: Sun, 29 Sep 2024 19:26:29 +0800
Message-ID: <20240929112630.863282-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240929112630.863282-1-huangchenghai2@huawei.com>
References: <20240929112630.863282-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200024.china.huawei.com (7.221.188.85)

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
 drivers/crypto/hisilicon/sec2/sec.h        |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 114 ++++++++-------------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 42 insertions(+), 85 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 410c83712e28..bd75e5b4c777 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -36,6 +36,7 @@ struct sec_aead_req {
 	dma_addr_t out_mac_dma;
 	u8 *a_ivin;
 	dma_addr_t a_ivin_dma;
+	size_t authsize;
 	struct aead_request *aead_req;
 };
 
@@ -90,7 +91,6 @@ struct sec_auth_ctx {
 	dma_addr_t a_key_dma;
 	u8 *a_key;
 	u8 a_key_len;
-	u8 mac_len;
 	u8 a_alg;
 	bool fallback;
 	struct crypto_shash *hash_tfm;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 0558f98e221f..470c2b422fa9 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -895,8 +895,6 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
-	struct crypto_aead *tfm;
-	size_t authsize;
 	u8 *mac_offset;
 
 	if (ctx->alg_type == SEC_AEAD)
@@ -911,10 +909,8 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 		return -EINVAL;
 	}
 	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
-		tfm = crypto_aead_reqtfm(aead_req);
-		authsize = crypto_aead_authsize(tfm);
-		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - authsize;
-		memcpy(a_req->out_mac, mac_offset, authsize);
+		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - a_req->authsize;
+		memcpy(a_req->out_mac, mac_offset, a_req->authsize);
 	}
 
 	req->in_dma = qp_ctx->res[req_id].pbuf_dma;
@@ -946,18 +942,16 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 static int sec_aead_mac_init(struct sec_aead_req *req)
 {
 	struct aead_request *aead_req = req->aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
-	size_t authsize = crypto_aead_authsize(tfm);
-	u8 *mac_out = req->out_mac;
 	struct scatterlist *sgl = aead_req->src;
+	u8 *mac_out = req->out_mac;
 	size_t copy_size;
 	off_t skip_size;
 
 	/* Copy input mac */
-	skip_size = aead_req->assoclen + aead_req->cryptlen - authsize;
+	skip_size = aead_req->assoclen + aead_req->cryptlen - req->authsize;
 	copy_size = sg_pcopy_to_buffer(sgl, sg_nents(sgl), mac_out,
-				       authsize, skip_size);
-	if (unlikely(copy_size != authsize))
+				       req->authsize, skip_size);
+	if (unlikely(copy_size != req->authsize))
 		return -EINVAL;
 
 	return 0;
@@ -1139,7 +1133,6 @@ static int sec_aead_fallback_setkey(struct sec_auth_ctx *a_ctx,
 static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			   const u32 keylen, const enum sec_hash_alg a_alg,
 			   const enum sec_calg c_alg,
-			   const enum sec_mac_len mac_len,
 			   const enum sec_cmode c_mode)
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1151,7 +1144,6 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	ctx->a_ctx.a_alg = a_alg;
 	ctx->c_ctx.c_alg = c_alg;
-	ctx->a_ctx.mac_len = mac_len;
 	c_ctx->c_mode = c_mode;
 
 	if (c_mode == SEC_CMODE_CCM || c_mode == SEC_CMODE_GCM) {
@@ -1187,10 +1179,9 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
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
 
@@ -1202,27 +1193,19 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
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
@@ -1470,9 +1453,8 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
-	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_aead_req *a_req = &req->aead_req;
-	size_t authsize = ctx->a_ctx.mac_len;
+	struct sec_cipher_req *c_req = &req->c_req;
 	u32 data_size = aead_req->cryptlen;
 	u8 flage = 0;
 	u8 cm, cl;
@@ -1487,7 +1469,7 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	flage |= c_req->c_ivin[0] & IV_CL_MASK;
 
 	/* the M' is bit3~bit5, the Flags is bit6 */
-	cm = (authsize - IV_CM_CAL_NUM) / IV_CM_CAL_NUM;
+	cm = (a_req->authsize - IV_CM_CAL_NUM) / IV_CM_CAL_NUM;
 	flage |= cm << IV_CM_OFFSET;
 	if (aead_req->assoclen)
 		flage |= 0x01 << IV_FLAGS_OFFSET;
@@ -1501,7 +1483,7 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	 * the tail 16bit fill with the cipher length
 	 */
 	if (!c_req->encrypt)
-		data_size = aead_req->cryptlen - authsize;
+		data_size = aead_req->cryptlen - a_req->authsize;
 
 	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE1] =
 			data_size & IV_LAST_BYTE_MASK;
@@ -1513,10 +1495,8 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
-	size_t authsize = crypto_aead_authsize(tfm);
-	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_aead_req *a_req = &req->aead_req;
+	struct sec_cipher_req *c_req = &req->c_req;
 
 	memcpy(c_req->c_ivin, aead_req->iv, ctx->c_ctx.ivsize);
 
@@ -1524,15 +1504,11 @@ static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
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
@@ -1544,7 +1520,7 @@ static void sec_auth_bd_fill_xcm(struct sec_auth_ctx *ctx, int dir,
 	struct aead_request *aq = a_req->aead_req;
 
 	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
-	sec_sqe->type2.icvw_kmode |= cpu_to_le16((u16)ctx->mac_len);
+	sec_sqe->type2.icvw_kmode |= cpu_to_le16((u16)a_req->authsize);
 
 	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
 	sec_sqe->type2.a_key_addr = sec_sqe->type2.c_key_addr;
@@ -1570,7 +1546,7 @@ static void sec_auth_bd_fill_xcm_v3(struct sec_auth_ctx *ctx, int dir,
 	struct aead_request *aq = a_req->aead_req;
 
 	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
-	sqe3->c_icv_key |= cpu_to_le16((u16)ctx->mac_len << SEC_MAC_OFFSET_V3);
+	sqe3->c_icv_key |= cpu_to_le16((u16)a_req->authsize << SEC_MAC_OFFSET_V3);
 
 	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
 	sqe3->a_key_addr = sqe3->c_key_addr;
@@ -1597,8 +1573,7 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 
 	sec_sqe->type2.a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
-	sec_sqe->type2.mac_key_alg =
-			cpu_to_le32(ctx->mac_len / SEC_SQE_LEN_RATE);
+	sec_sqe->type2.mac_key_alg = cpu_to_le32(a_req->authsize / SEC_SQE_LEN_RATE);
 
 	sec_sqe->type2.mac_key_alg |=
 			cpu_to_le32((u32)((ctx->a_key_len) /
@@ -1652,7 +1627,7 @@ static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
 	sqe3->a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(ctx->mac_len /
+			cpu_to_le32((u32)(a_req->authsize /
 			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
@@ -1702,10 +1677,8 @@ static int sec_aead_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 {
 	struct aead_request *a_req = req->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
 	struct sec_aead_req *aead_req = &req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
-	size_t authsize = crypto_aead_authsize(tfm);
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	struct aead_request *backlog_aead_req;
 	struct sec_req *backlog_req;
@@ -1718,11 +1691,9 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 	if (!err && c_req->encrypt) {
 		struct scatterlist *sgl = a_req->dst;
 
-		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl),
-					  aead_req->out_mac,
-					  authsize, a_req->cryptlen +
-					  a_req->assoclen);
-		if (unlikely(sz != authsize)) {
+		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl), aead_req->out_mac,
+					  aead_req->authsize, a_req->cryptlen + a_req->assoclen);
+		if (unlikely(sz != aead_req->authsize)) {
 			dev_err(c->dev, "copy out mac err!\n");
 			err = -EINVAL;
 		}
@@ -2232,8 +2203,7 @@ static int aead_iv_demension_check(struct aead_request *aead_req)
 static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	size_t authsize = crypto_aead_authsize(tfm);
+	size_t sz = sreq->aead_req.authsize;
 	u8 c_mode = ctx->c_ctx.c_mode;
 	struct device *dev = ctx->dev;
 	int ret;
@@ -2244,9 +2214,8 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
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
@@ -2266,7 +2235,7 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	if (sreq->c_req.encrypt)
 		sreq->c_req.c_len = req->cryptlen;
 	else
-		sreq->c_req.c_len = req->cryptlen - authsize;
+		sreq->c_req.c_len = req->cryptlen - sz;
 	if (c_mode == SEC_CMODE_CBC) {
 		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
 			dev_err(dev, "aead crypto length error!\n");
@@ -2280,8 +2249,6 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	size_t authsize = crypto_aead_authsize(tfm);
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
@@ -2292,7 +2259,7 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 
 	if (ctx->sec->qm.ver == QM_HW_V2) {
 		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
-		    req->cryptlen <= authsize))) {
+			     req->cryptlen <= sreq->aead_req.authsize))) {
 			ctx->a_ctx.fallback = true;
 			return -EINVAL;
 		}
@@ -2360,6 +2327,7 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
+	req->aead_req.authsize = crypto_aead_authsize(tfm);
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
 
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

