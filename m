Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AF1237193
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785828; cv=none; b=jGlUz0jZEOb0H81oj8fC6tpgV+YFqDGSEWreAcOJCEF2dTplJDxQayan0bqtm9Rv/FkX59XGQF6UAJklMEXRpD67Dvov6PRZmKiq/kagMrVVeQtk0mhpYWZyBur4V69ukppDZ49WCgpWOR1mbD8sN1le5IzTjVMnd7nTzCKscVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785828; c=relaxed/simple;
	bh=LJOfjFeRkKp52blstXNQ1dHwvt6qnDB2X/KFBTwkrig=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Mq3fkEjXFKRSfmlOxJ+ylg51SdTH7WJRdWFWoqrCA18Y4oEYEd3mJOe64aIlkVBGBDuzs5NuxIcQy5K1D7hDPXOC2vtO5odamh5KnR7dx5hUvIFOpxUPtmO9VIsenu6mDMxNvl2GOSytxcvWcG+YLHEqIEkrmN++k/LkDqBvBBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=e71YsZhX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="e71YsZhX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2yJu6M9xxUocmxNuKAzeh261+YrPvwTvdf6L3Ez4IX4=; b=e71YsZhXI+jxz/Z0G3S0TYzo5I
	oHkNTtWWh26q1rA5LczUVcQivMJLNGxeGgHxqSZ9+86uG2YvgmaNiJCkQ7ykMwnbY1b1InVz2m9Gl
	b1SmOVlgWzfcrXzcclzGnTJCIt3YtjYbEwzuf1b6qoFn52u9lRID82yOVK4gcFhH+pA9D0PveZdpv
	5RuZ22sol3RUhgm0RnAmffCx+JX1Fd/CuK0JQ7pS0lD3PaEjNhkKk4vfLZlSk+62E+OsYTyO8jOKG
	iWyUW4tkU/2rRRJ/0xdy37ckkEbivm+JwNbbSONGtA00Qk7ACwJKh+iu9z6Ek18KduIADMiwo5kjY
	wRS5yTpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUo-00G6Kx-2c;
	Wed, 16 Apr 2025 14:43:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:42 +0800
Date: Wed, 16 Apr 2025 14:43:42 +0800
Message-Id: <000b2683d3a561c526149540cda84ef0ed376942.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 26/67] crypto: sha1_base - Remove partial block helpers
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all sha1_base users have been converted to use the API
partial block handling, remove the partial block helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/sha1_base.h | 61 --------------------------------------
 1 file changed, 61 deletions(-)

diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
index b23cfad18ce2..62701d136c79 100644
--- a/include/crypto/sha1_base.h
+++ b/include/crypto/sha1_base.h
@@ -31,44 +31,6 @@ static inline int sha1_base_init(struct shash_desc *desc)
 	return 0;
 }
 
-static inline int sha1_base_do_update(struct shash_desc *desc,
-				      const u8 *data,
-				      unsigned int len,
-				      sha1_block_fn *block_fn)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if (unlikely((partial + len) >= SHA1_BLOCK_SIZE)) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA1_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buffer + partial, data, p);
-			data += p;
-			len -= p;
-
-			block_fn(sctx, sctx->buffer, 1);
-		}
-
-		blocks = len / SHA1_BLOCK_SIZE;
-		len %= SHA1_BLOCK_SIZE;
-
-		if (blocks) {
-			block_fn(sctx, data, blocks);
-			data += blocks * SHA1_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buffer + partial, data, len);
-
-	return 0;
-}
-
 static inline int sha1_base_do_update_blocks(struct shash_desc *desc,
 					     const u8 *data,
 					     unsigned int len,
@@ -82,29 +44,6 @@ static inline int sha1_base_do_update_blocks(struct shash_desc *desc,
 	return remain;
 }
 
-static inline int sha1_base_do_finalize(struct shash_desc *desc,
-					sha1_block_fn *block_fn)
-{
-	const int bit_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-
-	sctx->buffer[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(sctx->buffer + partial, 0x0, SHA1_BLOCK_SIZE - partial);
-		partial = 0;
-
-		block_fn(sctx, sctx->buffer, 1);
-	}
-
-	memset(sctx->buffer + partial, 0x0, bit_offset - partial);
-	*bits = cpu_to_be64(sctx->count << 3);
-	block_fn(sctx, sctx->buffer, 1);
-
-	return 0;
-}
-
 static inline int sha1_base_do_finup(struct shash_desc *desc,
 				     const u8 *src, unsigned int len,
 				     sha1_block_fn *block_fn)
-- 
2.39.5

