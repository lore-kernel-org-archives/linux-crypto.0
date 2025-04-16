Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE0F23AE70
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785893; cv=none; b=Ht+qd18RuZgIFiHadVVdrKKUdmfbyGC6Xk2z7wUBYwrUOPYcAX2Fy0zRuRE7NW5jPWJNzeEpUUilf6rnHjnQEXQoHbwbcqPvmKKTrfcISrH6bZLaU+O84ylMphi6plF+AWW3/4ohP5bDHbhWE11pKWZAAQLP7TKHLMLQ9IAeQCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785893; c=relaxed/simple;
	bh=MbniKo4qDbSZiHPQhoSku+RYWmJsHOR03V1RBXttMjU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=hyvdBqX22pXvBb3HHi/4sDlXWMxQUjOK/UFUtjDg6ryo3dXaeZ9B7Ynxi/d40ohkiNraRnq8zHtHku0RGVguxSyNG0Kh7Kzy3UmDv85yL+c8AO6Fo5Wabf5dUiRYQo0DcmC0xh1lwNV7VwAXlpkcUw8OHjdhkgHT5m43hAkdPSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XQyucpg+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XQyucpg+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Jr0PdFGN3moQZRt/K8WjIWb1E7OqeV5e/K+iB/Tp00I=; b=XQyucpg+qAx1OcsLjSsew5YfV4
	uut7dQWe4FOXH7sy5OM41lZux2NpJcF2BRpGYf/ZQWR/cAWeKgUkzYY09+/5/mmS+o2ogp/Pl7rSo
	abbcdggHtygEO0tYBllQpp92r6YhPg2/ZoXhig1Xc63B5lgzNg9NoGJ1cw5Gq57wYD6m2QX92mo02
	dSDow6s8qKRm22G9fCvU00f2/Z9zl34HMYx8tyBT4WblNoMlmdFDD9x2Ui4+pIgGh0a1VkGbM4UIN
	zM69lq7KZwJC9YJ/QvdM6i1h1OPlGkEr0Slng6Eds7VAnSj7fAcGOqOPv1kYhFNEHlTCeRY4Iswxw
	34LK4Vzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVr-00G6R7-1s;
	Wed, 16 Apr 2025 14:44:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:47 +0800
Date: Wed, 16 Apr 2025 14:44:47 +0800
Message-Id: <fda1972b228d029b7609e5f5856e7230de070cbb.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 54/67] crypto: sha512_base - Remove partial block helpers
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that all sha256_base users have been converted to use the API
partial block handling, remove the partial block helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/sha512_base.h | 64 ------------------------------------
 1 file changed, 64 deletions(-)

diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
index e9f302ec3ede..aa814bab442d 100644
--- a/include/crypto/sha512_base.h
+++ b/include/crypto/sha512_base.h
@@ -53,46 +53,6 @@ static inline int sha512_base_init(struct shash_desc *desc)
 	return 0;
 }
 
-static inline int sha512_base_do_update(struct shash_desc *desc,
-					const u8 *data,
-					unsigned int len,
-					sha512_block_fn *block_fn)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
-
-	sctx->count[0] += len;
-	if (sctx->count[0] < len)
-		sctx->count[1]++;
-
-	if (unlikely((partial + len) >= SHA512_BLOCK_SIZE)) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA512_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buf + partial, data, p);
-			data += p;
-			len -= p;
-
-			block_fn(sctx, sctx->buf, 1);
-		}
-
-		blocks = len / SHA512_BLOCK_SIZE;
-		len %= SHA512_BLOCK_SIZE;
-
-		if (blocks) {
-			block_fn(sctx, data, blocks);
-			data += blocks * SHA512_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buf + partial, data, len);
-
-	return 0;
-}
-
 static inline int sha512_base_do_update_blocks(struct shash_desc *desc,
 					       const u8 *data,
 					       unsigned int len,
@@ -142,30 +102,6 @@ static inline int sha512_base_do_finup(struct shash_desc *desc, const u8 *src,
 	return 0;
 }
 
-static inline int sha512_base_do_finalize(struct shash_desc *desc,
-					  sha512_block_fn *block_fn)
-{
-	const int bit_offset = SHA512_BLOCK_SIZE - sizeof(__be64[2]);
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	__be64 *bits = (__be64 *)(sctx->buf + bit_offset);
-	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
-
-	sctx->buf[partial++] = 0x80;
-	if (partial > bit_offset) {
-		memset(sctx->buf + partial, 0x0, SHA512_BLOCK_SIZE - partial);
-		partial = 0;
-
-		block_fn(sctx, sctx->buf, 1);
-	}
-
-	memset(sctx->buf + partial, 0x0, bit_offset - partial);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
-	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	block_fn(sctx, sctx->buf, 1);
-
-	return 0;
-}
-
 static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
 {
 	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
-- 
2.39.5

