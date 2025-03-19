Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3A211486
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742376410; cv=none; b=XelyU0MfecKVsmUsKqpl415r5d6Ty1sTIWCD2++CxWjrzSRihrYIOF79Bkz28LEo7q8rtmgcyS2v6h7VA0VJWmAsyB1lcvBJVmyP7R7FHxK8oDaVmI+cmccZUVUUdReEg3YL243qy3zqVTIFHZc71GlD83/gJTlSRulBF1vfO6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742376410; c=relaxed/simple;
	bh=1bt1b4g8xalmkzFXWnnIrwLZxbpXfYqg1gFe5i2qRTk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ibusc180/bD8A1oZoJK6bMLs1SHSiwXgchBfxTy29ExMfWOGCA0ETYvEYZm1s4V4ExZwbp4IWYVrEUmQWiO+aEczRNeI5HGsYEurxetCxwl8HPoJkvVAyY9cRAo6qLtAZIJQQgqsoPiCjcAh5be6tEguLbLwnYzpmKRO5zYc6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dcygCB2r; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dcygCB2r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i5+NbJvZo3E4FbIqmU24z+YhtOUYOUhTDE49eFvixLo=; b=dcygCB2rkcI6wCogJwoDxq/kWJ
	L3NKHTlnlHS6oRMV6HluDPs+Sa/LOF1clk15/KLfkrPXzFvEBAD3ljYIN/4FQwRHgtgl030+Rwneg
	WC9IKwZL9dlj+J9BRwa318soTe181P6KE/gT52eb/4M8XsvwF9N/fMcEDFNQTuikMGEb6L+FiRVnz
	GImWKGv6FvSZsHDk+O237NwFf99YV3ozmh504caBKfGesyXnySiOvVoTL0J0itIVSLbiK3pQqDksU
	mtB1InYS5VHXz9hckbSoGW/HfoOmuJIMWQfRbHpbBx6d0TUpLezCJd7jVJqzAgBDCQRtxUxYf3Pnw
	CNaobUzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tuphD-008M3h-1x;
	Wed, 19 Mar 2025 17:26:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 17:26:43 +0800
Date: Wed, 19 Mar 2025 17:26:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: crypto4xx - Fix gcc12 uninitialized warning in
 crypto4xx_crypt
Message-ID: <Z9qN05tYIrnh_L8I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The compiler gcc 12 warns about the IV buffer being uninitialized
in crypto4xx_crypt.  Silence the warning by using the new gcc 12
access attribute to mark crypto4xx_build_pd.

Also fix the IV buffer length as it has been quadrupled (64 instead
of 16).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index e0af611a95d8..289750f34ccf 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -72,7 +72,7 @@ static inline int crypto4xx_crypt(struct skcipher_request *req,
 {
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
 	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
-	__le32 iv[AES_IV_SIZE];
+	__le32 iv[AES_IV_SIZE / 4];
 
 	if (check_blocksize && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE))
 		return -EINVAL;
@@ -429,7 +429,7 @@ static int crypto4xx_crypt_aes_ccm(struct aead_request *req, bool decrypt)
 	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
 	struct crypto4xx_aead_reqctx *rctx = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	__le32 iv[16];
+	__le32 iv[4];
 	u32 tmp_sa[SA_AES128_CCM_LEN + 4];
 	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *)tmp_sa;
 	unsigned int len = req->cryptlen;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index d6b8d962d20a..f67c8f987e8b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -677,7 +677,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct scatterlist *src,
 		       struct scatterlist *dst,
 		       const unsigned int datalen,
-		       const __le32 *iv, const u32 iv_len,
+		       const void *iv, const u32 iv_len,
 		       const struct dynamic_sa_ctl *req_sa,
 		       const unsigned int sa_len,
 		       const unsigned int assoclen,
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 3adcc5e65694..11a69ec60ab2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -147,6 +147,12 @@ struct crypto4xx_alg {
 	struct crypto4xx_device *dev;
 };
 
+#if IS_ENABLED(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION >= 120000
+#define BUILD_PD_ACCESS __attribute__((access(read_only, 6, 7)))
+#else
+#define BUILD_PD_ACCESS
+#endif
+
 int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
 void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
 int crypto4xx_build_pd(struct crypto_async_request *req,
@@ -154,11 +160,11 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct scatterlist *src,
 		       struct scatterlist *dst,
 		       const unsigned int datalen,
-		       const __le32 *iv, const u32 iv_len,
+		       const void *iv, const u32 iv_len,
 		       const struct dynamic_sa_ctl *sa,
 		       const unsigned int sa_len,
 		       const unsigned int assoclen,
-		       struct scatterlist *dst_tmp);
+		       struct scatterlist *dst_tmp) BUILD_PD_ACCESS;
 int crypto4xx_setkey_aes_cbc(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_setkey_aes_ctr(struct crypto_skcipher *cipher,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
