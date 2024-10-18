Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7A20102B;
	Fri, 18 Oct 2024 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729249117; cv=none; b=lS2fQqgjl1tUhWn0rUC982VTK0H2j3u9coO4oJP+Y5c8gD4PSa4Hb/IRkj2kJCgQb0ipPjplAkitPJ4IUYF+ZIH3mg2+6IQKBjZxRsU4qJCW7JMJHT+kUoYrM5VriX0cFxw0W/bpEPnaxC0r+9vdkLCiA/tBAcLnDgtEJVdNVY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729249117; c=relaxed/simple;
	bh=tZliSsw4sEm5UTyCGYShgP/HgiuscIgRQJRTMiaW3uo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiEJI/AyXKhYRrnbL4lhlbWLDyudia5WXZUMY8dwCEHPHAN0Smd0mnD6msGrD6Gecxz/LxbwqyH5+nukuzqOq27CjvFjxqaRyKJwExRTBKlS8EHoviftIZM0O5MbijnK3psgcduSvAzUV+648Jo2QgKpJPtJNHftdNaywcDY7vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XVM7m3Kk5zfdM1;
	Fri, 18 Oct 2024 18:56:04 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 73AFC140384;
	Fri, 18 Oct 2024 18:58:32 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Oct 2024 18:58:31 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH v2 2/2] crypto: hisilicon/sec2 - fix for aead invalid authsize
Date: Fri, 18 Oct 2024 18:58:30 +0800
Message-ID: <20241018105830.169212-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241018105830.169212-1-huangchenghai2@huawei.com>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

When the digest alg is HMAC-SHAx or another, the authsize may be less
than 4 bytes and mac_len of the BD is set to zero, the hardware considers
it a BD configuration error and reports a ras error, so the sec driver
needs to switch to software calculation in this case, this patch add a
check for it and remove unnecessary check that has been done by crypto.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 59 ++++++++++++----------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index cf4de5eb39dc..3806d0546f19 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1118,10 +1118,7 @@ static int sec_aead_setauthsize(struct crypto_aead *aead, unsigned int authsize)
 	struct sec_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
-	if (unlikely(a_ctx->fallback_aead_tfm))
-		return crypto_aead_setauthsize(a_ctx->fallback_aead_tfm, authsize);
-
-	return 0;
+	return crypto_aead_setauthsize(a_ctx->fallback_aead_tfm, authsize);
 }
 
 static int sec_aead_fallback_setkey(struct sec_auth_ctx *a_ctx,
@@ -1158,13 +1155,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		}
 		memcpy(c_ctx->c_key, key, keylen);
 
-		if (unlikely(a_ctx->fallback_aead_tfm)) {
-			ret = sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
-			if (ret)
-				return ret;
-		}
-
-		return 0;
+		return sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
 	}
 
 	ret = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -1189,6 +1180,12 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
+	ret = sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
+	if (ret) {
+		dev_err(dev, "set sec fallback key err!\n");
+		goto bad_key;
+	}
+
 	return 0;
 
 bad_key:
@@ -1906,8 +1903,10 @@ static void sec_aead_exit(struct crypto_aead *tfm)
 
 static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 {
+	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
-	struct sec_auth_ctx *auth_ctx = &ctx->a_ctx;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	const char *aead_name = alg->base.cra_name;
 	int ret;
 
 	ret = sec_aead_init(tfm);
@@ -1916,12 +1915,22 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 		return ret;
 	}
 
-	auth_ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
-	if (IS_ERR(auth_ctx->hash_tfm)) {
+	a_ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
+	if (IS_ERR(a_ctx->hash_tfm)) {
 		dev_err(ctx->dev, "aead alloc shash error!\n");
 		sec_aead_exit(tfm);
-		return PTR_ERR(auth_ctx->hash_tfm);
+		return PTR_ERR(a_ctx->hash_tfm);
+	}
+
+	a_ctx->fallback_aead_tfm = crypto_alloc_aead(aead_name, 0,
+						     CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC);
+	if (IS_ERR(a_ctx->fallback_aead_tfm)) {
+		dev_err(ctx->dev, "aead driver alloc fallback tfm error!\n");
+		crypto_free_shash(ctx->a_ctx.hash_tfm);
+		sec_aead_exit(tfm);
+		return PTR_ERR(a_ctx->fallback_aead_tfm);
 	}
+	a_ctx->fallback = false;
 
 	return 0;
 }
@@ -1930,6 +1939,7 @@ static void sec_aead_ctx_exit(struct crypto_aead *tfm)
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 
+	crypto_free_aead(ctx->a_ctx.fallback_aead_tfm);
 	crypto_free_shash(ctx->a_ctx.hash_tfm);
 	sec_aead_exit(tfm);
 }
@@ -2215,15 +2225,15 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct device *dev = ctx->dev;
 	int ret;
 
-	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
-	    req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(dev, "aead input spec error!\n");
+	/* Hardware does not handle cases where authsize is less than 4 bytes */
+	if (unlikely(sz < MIN_MAC_LEN)) {
+		ctx->a_ctx.fallback = true;
 		return -EINVAL;
 	}
 
-	if (unlikely((c_mode == SEC_CMODE_GCM && sz < DES_BLOCK_SIZE) ||
-		     (c_mode == SEC_CMODE_CCM && (sz < MIN_MAC_LEN || sz & MAC_LEN_MASK)))) {
-		dev_err(dev, "aead input mac length error!\n");
+	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
+	    req->assoclen > SEC_MAX_AAD_LEN)) {
+		dev_err(dev, "aead input spec error!\n");
 		return -EINVAL;
 	}
 
@@ -2296,16 +2306,9 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 				bool encrypt)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
-	struct device *dev = ctx->dev;
 	struct aead_request *subreq;
 	int ret;
 
-	/* Kunpeng920 aead mode not support input 0 size */
-	if (!a_ctx->fallback_aead_tfm) {
-		dev_err(dev, "aead fallback tfm is NULL!\n");
-		return -EINVAL;
-	}
-
 	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_KERNEL);
 	if (!subreq)
 		return -ENOMEM;
-- 
2.33.0

