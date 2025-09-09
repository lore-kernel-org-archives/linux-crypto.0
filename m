Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6723002B4
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 05:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757396499; cv=none; b=eUul5ZkqtnMydVR+JUfC23xXTXpI54/kXJTFEWFwji90PHS0vgLQzbG8+gRBqt2UiKSi74FBYfMSna4hKvlyjWZhMYz4/hPaQJhfjtlmtj8zkTtEgqT7V2/spPpkey3xUHzk4lE1texKxacvaVCMZFg9LJxK7u/uokCR37BJiN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757396499; c=relaxed/simple;
	bh=11rhQ21v25YcSMrMLPGPZPvFpP/gz92iU0ETiw38GCQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=uLMtm8R+3O/K/D+Xo+BCZfSNVudaRmZwC/A2+3UDCP9XCjrDCcoX9kgH0k3wVOAWK5e+KMreb/vTvRCZT31mesrXTcb74k+cEDWiIXlItxSzmSRqUwqyOAT1SCo6jZ4M+wK/ytmKxy2ObeZ7hR9BL6Sj2hFvPQMtV4z2+xFoaK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bjA8Dn3Q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bjA8Dn3Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YsC7FJS9aSojp1vve+F03nKLz99HpGeDwHbcvUPsRzo=; b=bjA8Dn3QZCVE1NASvBEcJtSuxv
	h9h+2RRhkBPvpnEy1g1Nx3IF77pRITy0BoD5ddsO/10XHQsJOcfgGDESMsa+BdoReJXOy4JIS1KtW
	l5mdNTbPogVYMKrgyrR6ai/5Y/2SyRmeNBjrhLC2Yyxer5dZ+1C+xILDauM5pOOyMlXIfhpBq2580
	JFwJi+DkF/Ut7eSk2Iz7Y/5OZ8m3aONQ295FdF4t7YxY7LUq2APFlzY87OcGZ6eaz8iWvTMGbyzNm
	wb1lRdpOjavRUMxF0YWXiz6xwmbv+rjsC/AsqJHWoBW+vuVX8WzUM3ftuJhYhjuRTh3qXN1XgBoXY
	dQBvJavA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvqrJ-003qIm-1J;
	Tue, 09 Sep 2025 13:41:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 13:41:33 +0800
Date: Tue, 09 Sep 2025 13:41:33 +0800
Message-Id: <9d6b10c1405137ab1d09471897536f830649364f.1757396389.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1757396389.git.herbert@gondor.apana.org.au>
References: <cover.1757396389.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/2] crypto: ahash - Allow async stack requests when
 specified
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As it stands stack requests are forbidden for async algorithms
because of the inability to perform DMA on stack memory.

However, some async algorithms do not perform DMA and are able
to handle stack requests.  Allow such uses by addnig a new type
bit CRYPTO_AHASH_ALG_STACK_REQ.  When it is set on the algorithm
stack requests will be allowed even if the algorithm is asynchronous.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 22 ++++++++++++++++++----
 include/crypto/internal/hash.h |  3 +++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a227793d2c5b..33b2a19169f1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -49,6 +49,20 @@ static inline bool crypto_ahash_need_fallback(struct crypto_ahash *tfm)
 	       CRYPTO_ALG_NEED_FALLBACK;
 }
 
+static inline bool crypto_ahash_stack_req_ok(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (!ahash_req_on_stack(req))
+		return true;
+
+	if (!ahash_is_async(tfm))
+		return true;
+
+	return crypto_ahash_alg(tfm)->halg.base.cra_flags &
+	       CRYPTO_AHASH_ALG_STACK_REQ;
+}
+
 static inline void ahash_op_done(void *data, int err,
 				 int (*finish)(struct ahash_request *, int))
 {
@@ -376,7 +390,7 @@ int crypto_ahash_init(struct ahash_request *req)
 		return crypto_shash_init(prepare_shash_desc(req, tfm));
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+	if (!crypto_ahash_stack_req_ok(req))
 		return -EAGAIN;
 	if (crypto_ahash_block_only(tfm)) {
 		u8 *buf = ahash_request_ctx(req);
@@ -451,7 +465,7 @@ int crypto_ahash_update(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_update(req, ahash_request_ctx(req));
-	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+	if (!crypto_ahash_stack_req_ok(req))
 		return -EAGAIN;
 	if (!crypto_ahash_block_only(tfm))
 		return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
@@ -531,7 +545,7 @@ int crypto_ahash_finup(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_finup(req, ahash_request_ctx(req));
-	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+	if (!crypto_ahash_stack_req_ok(req))
 		return -EAGAIN;
 	if (!crypto_ahash_alg(tfm)->finup)
 		return ahash_def_finup(req);
@@ -569,7 +583,7 @@ int crypto_ahash_digest(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
-	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+	if (!crypto_ahash_stack_req_ok(req))
 		return -EAGAIN;
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 6ec5f2f37ccb..79899d36032b 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -23,6 +23,9 @@
 /* This bit is set by the Crypto API if export_core is not supported. */
 #define CRYPTO_AHASH_ALG_NO_EXPORT_CORE	0x08000000
 
+/* This bit is set by the Crypto API if stack requests are supported. */
+#define CRYPTO_AHASH_ALG_STACK_REQ	0x10000000
+
 #define HASH_FBREQ_ON_STACK(name, req) \
         char __##name##_req[sizeof(struct ahash_request) + \
                             MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
-- 
2.39.5

