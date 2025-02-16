Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EADC7E1
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675241; cv=none; b=UYcbx0PFWAmjDOKQq630qbto+J6B4r/im0JrVz1nbVcyUlHsluKNYfmzgbIEZGL4kLStsX+jV0+DBd4hZRVSNmdYwOaQ8X7If0hum25GuaJjFCBTRQo0ld0C76aOs/vm2Hufo73RHd4ZZRrNWLk9cBB8C0ON4WhM9bT1neDlZf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675241; c=relaxed/simple;
	bh=sQQYWA6pMLOLdbNHlQ2+coyzbhGk4oJjTtOCtgn0uNE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=dLk9XMEQzdRIah0mb1UV+XjuoWohUoN/GZoOgjId9MGEP72d4zoA55pDoYnS6F1HVXgfyjryflXI/beUfcLqXOU/n81zV/4f2B/jsNjq/ky+obWz6l7nDCQwXZNcErVObU0adTNqWb9Zx1TFolLzbdkniOOBjisB/5YhQ7n1KLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=S1lEQjBJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="S1lEQjBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dVrRxU7foExstX9hgCMbnUQLE4gwkVI3GUAFfq9oi5M=; b=S1lEQjBJiuIht80/JAx8UliTTh
	E3p5UZbok556snrecR30y01eZE1SB8knDAgIQgNBN/Gen1bamGgIrNriaS23hsTEK3cjvMDJAO2Nq
	u2UPRB60nuClto+rJFxJCsUqfFmgdBqLvxr5bNZ5TEoqVqRdqgVVwxsdmmWxpTFf8kwbW/R2W1bKA
	oU09QI0hVwxgRHc/Vwha+rYFdZjNV1UKFNihXVH0XTo6sL8eI4tMCwTMPiWCGapRTmJO69X3qSiJA
	s453B4zvOEP1kKziP2vAN5eEB4jolmgEqxchK6XYVTRLD8zJf8GNPqpz3WBoJbmfpS7jLgeAii1z7
	bruxobvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUn4-000gXh-1X;
	Sun, 16 Feb 2025 11:07:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:15 +0800
Date: Sun, 16 Feb 2025 11:07:15 +0800
Message-Id: <e8a0e14c9b573b8e68c07f6f48b013718036004b.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 02/11] crypto: x86/ghash - Use proper helpers to clone
 request
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than copying a request by hand with memcpy, use the correct
API helpers to setup the new request.  This will matter once the
API helpers start setting up chained requests as a simple memcpy
will break chaining.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 23 ++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 41bc02e48916..c759ec808bf1 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -189,6 +189,20 @@ static int ghash_async_init(struct ahash_request *req)
 	return crypto_shash_init(desc);
 }
 
+static void ghash_init_cryptd_req(struct ahash_request *req)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
+
+	ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+	ahash_request_set_callback(cryptd_req, req->base.flags,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(cryptd_req, req->src, req->result,
+				req->nbytes);
+}
+
 static int ghash_async_update(struct ahash_request *req)
 {
 	struct ahash_request *cryptd_req = ahash_request_ctx(req);
@@ -198,8 +212,7 @@ static int ghash_async_update(struct ahash_request *req)
 
 	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		ghash_init_cryptd_req(req);
 		return crypto_ahash_update(cryptd_req);
 	} else {
 		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
@@ -216,8 +229,7 @@ static int ghash_async_final(struct ahash_request *req)
 
 	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		ghash_init_cryptd_req(req);
 		return crypto_ahash_final(cryptd_req);
 	} else {
 		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
@@ -257,8 +269,7 @@ static int ghash_async_digest(struct ahash_request *req)
 
 	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		memcpy(cryptd_req, req, sizeof(*req));
-		ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
+		ghash_init_cryptd_req(req);
 		return crypto_ahash_digest(cryptd_req);
 	} else {
 		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-- 
2.39.5

