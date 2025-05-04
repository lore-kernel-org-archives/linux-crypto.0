Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE76217996
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365612; cv=none; b=ZytXMWpKtfXRxXLWkdGEJGdWy2XKqnpG5jLe1XrdWxkYELZ9k3ATto9mlJK3AvmRGiqCNWHoE0di6EixGEfCLZ3TzNXJdBsXurxIjFpeJDyMkpeSaNFKY08uU8tvmlF/E9cvgHUmFZemyOl6HmovWuYupFt3bc2xjGzgBV4I0M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365612; c=relaxed/simple;
	bh=AhBkyBGCZSS1tbHAqF8aatgaPdimMv7f1DcGybq1tDs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=GjaDuVT1hDHTatkU0+r43p0GzSDzDPUPjzYWEf1BpqyO1Xzprbo+pscUNLTnIcsSWsiwUNfbb5vuuGgw3SvKFXp1aO+rN4cX4YtmyMrI1xJ0YNwOqV/07UU7kqHtauPchwXy2cdPa5+Jr6aPguUyy3Ux75t+nRJsPI8yewsjY8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NzEvPtZ4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NzEvPtZ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VQKiF4E97hrhPRFDvAOT3k2r6H930Y06mq1s/XY5LYQ=; b=NzEvPtZ4KvcSBRJdfddWhEwtgL
	Sc2pQyHnmJ8KZZuma/ccTua7YYT8KcJ0cqwkHAndrlMbreyBhsZjrKykS1RGFseHRVqhLu/uTqija
	qLCQlqzy2M//16Y8K/lBZ6k40fc2HwPwKJblJ69FDsnNpYNKl8/84tFAntgC97FFSEmduWt1iF4Dl
	xH0m6TlB5oI5D6fyWMno7IAFliEcqK29J83piUOwy1PwfV1t++LmzYoUL9Ibh9+Ybm6406BXEevHx
	pY5eFW6r9gPzlEdfn6e4mWMAzPGPo73w9wLxNK4zmbRppYbdR4r7ol5hug3uz6UzXwOYyZgfBmN9O
	TKBJCgXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZTB-003Ew3-2D;
	Sun, 04 May 2025 21:33:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:25 +0800
Date: Sun, 04 May 2025 21:33:25 +0800
Message-Id: <925947988bb2e72610c9e7fc1e889dd0c689222d.1746365585.git.herbert@gondor.apana.org.au>
In-Reply-To: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
References: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/6] crypto: padlock-sha - Use core import and export for
 fallback
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As padlock-sha is block-only, it needs to use core import and
export on the fallback.

Also call sha256_block_init instead of sha256_init although this
is harmless as sha256_init doesn't write into the partial block
area.

Fixes: 63dc06cd12f9 ("crypto: padlock-sha - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/padlock-sha.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index c89b9c6b5f4c..329f60ad422e 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -42,27 +42,33 @@ static int padlock_sha1_init(struct shash_desc *desc)
 
 static int padlock_sha256_init(struct shash_desc *desc)
 {
-	struct sha256_state *sctx = padlock_shash_desc_ctx(desc);
+	struct crypto_sha256_state *sctx = padlock_shash_desc_ctx(desc);
 
-	sha256_init(sctx);
+	sha256_block_init(sctx);
 	return 0;
 }
 
 static int padlock_sha_update(struct shash_desc *desc,
 			      const u8 *data, unsigned int length)
 {
-	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *state = padlock_shash_desc_ctx(desc);
-	HASH_REQUEST_ON_STACK(req, ctx->fallback);
-	int remain;
+	struct crypto_shash *tfm = desc->tfm;
+	int err, remain;
 
-	ahash_request_set_callback(req, 0, NULL, NULL);
-	ahash_request_set_virt(req, data, NULL, length);
-	remain = crypto_ahash_import(req, state) ?:
-		 crypto_ahash_update(req);
-	if (remain < 0)
-		return remain;
-	return crypto_ahash_export(req, state) ?: remain;
+	remain = length - round_down(length, crypto_shash_blocksize(tfm));
+	{
+		struct padlock_sha_ctx *ctx = crypto_shash_ctx(tfm);
+		HASH_REQUEST_ON_STACK(req, ctx->fallback);
+
+		ahash_request_set_callback(req, 0, NULL, NULL);
+		ahash_request_set_virt(req, data, NULL, length - remain);
+		err = crypto_ahash_import_core(req, state) ?:
+		      crypto_ahash_update(req) ?:
+		      crypto_ahash_export_core(req, state);
+		HASH_REQUEST_ZERO(req);
+	}
+
+	return err ?: remain;
 }
 
 static int padlock_sha_export(struct shash_desc *desc, void *out)
@@ -101,7 +107,7 @@ static int padlock_sha_finup(struct shash_desc *desc, const u8 *in,
 
 	ahash_request_set_callback(req, 0, NULL, NULL);
 	ahash_request_set_virt(req, in, out, count);
-	return crypto_ahash_import(req, padlock_shash_desc_ctx(desc)) ?:
+	return crypto_ahash_import_core(req, padlock_shash_desc_ctx(desc)) ?:
 	       crypto_ahash_finup(req);
 }
 
@@ -165,7 +171,7 @@ static int padlock_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 	}
 
-	if (crypto_shash_statesize(hash) <
+	if (crypto_shash_statesize(hash) !=
 	    crypto_ahash_statesize(fallback_tfm)) {
 		crypto_free_ahash(fallback_tfm);
 		return -EINVAL;
-- 
2.39.5

