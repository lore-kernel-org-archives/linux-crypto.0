Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCF1E5710
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116247; cv=none; b=VQSzfCM7nPlwQqsTpqmtSyFLd4eT1OvgMYe/XJbsf9LO6HYqyH4YzzSVQObni8zDWycBf35i21MQDL85bLxkgletcDpcz0paKJZMko9zVK+60MKz17sGUr58ZFl1m3Mu+JdkGFsujN0F1AQr8iXUfDI+MJnBIUnFwpxf/y6Vi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116247; c=relaxed/simple;
	bh=TVN/0wCrPqbi2ha4Drb95In4rerlF2c06vafI9yquZE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=rPR5DAgV946aWB0in6K/zk+ke8YiXw+nseqTv2yUmXgM4vSrX0vx4ADQwI6wdl1qFQzj+pE5ysFzGxkj1VOC2XV54l2vXl9xqsV/I0UacfrKIv3WtilIFWguvpHnfEedDCNGgFfAhcn9kL6QCWo4XIQGepGTXCDad6ayrNOHEPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l6BB8w0S; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l6BB8w0S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+ru/O8aStcq/NQmOby3M3IUJaHQQYoWzI78Ee/BXevc=; b=l6BB8w0SXIScJvvtBJDupeualf
	y15f5EAYbX/YzEwXXeP5ZT1eqOrfyzKhK0ZGdopkw412Afs6nHtv/SCumlNTcgJC8OCFCwEQ/PFfd
	ja8LLosnDpsLvnMFKnY9UGpPc0M3IWJXG2vHNQLhYi3BCWSkzYHg8KJWKBcw0U9oDmtk9pLKvvG0r
	2rAozuI7XAiKdTvt0VyDhPGU9aDj53rBliC5Ed9PT+Sg3Wce56IR3R9CQfPRELcFgHG+HWN7LgSH7
	POKsKm2bt5th9c8REREEODVioDguG3oT/5v5DD1HqQ6CUzV/0c0b91jCKkeCKbNvTtxAcxoVkZdbK
	UZzrSt0A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikD-005g5W-2r;
	Tue, 13 May 2025 14:04:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:04:01 +0800
Date: Tue, 13 May 2025 14:04:01 +0800
Message-Id: <18fe5ff62fad08206de4c02f67746120aeb41fc0.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 07/11] crypto: aspeed/hash - Remove sha_iv
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Removed unused sha_iv field from request context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 5 -----
 drivers/crypto/aspeed/aspeed-hace.h      | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index ceea2e2f5658..d31d7e1c9af2 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -593,7 +593,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA1;
 		rctx->digsize = SHA1_DIGEST_SIZE;
 		rctx->block_size = SHA1_BLOCK_SIZE;
-		rctx->sha_iv = sha1_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha1_iv, rctx->ivsize);
 		break;
@@ -602,7 +601,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA224;
 		rctx->digsize = SHA224_DIGEST_SIZE;
 		rctx->block_size = SHA224_BLOCK_SIZE;
-		rctx->sha_iv = sha224_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha224_iv, rctx->ivsize);
 		break;
@@ -611,7 +609,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA256;
 		rctx->digsize = SHA256_DIGEST_SIZE;
 		rctx->block_size = SHA256_BLOCK_SIZE;
-		rctx->sha_iv = sha256_iv;
 		rctx->ivsize = 32;
 		memcpy(rctx->digest, sha256_iv, rctx->ivsize);
 		break;
@@ -621,7 +618,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA384;
 		rctx->digsize = SHA384_DIGEST_SIZE;
 		rctx->block_size = SHA384_BLOCK_SIZE;
-		rctx->sha_iv = (const __be32 *)sha384_iv;
 		rctx->ivsize = 64;
 		memcpy(rctx->digest, sha384_iv, rctx->ivsize);
 		break;
@@ -631,7 +627,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		rctx->flags |= SHA_FLAGS_SHA512;
 		rctx->digsize = SHA512_DIGEST_SIZE;
 		rctx->block_size = SHA512_BLOCK_SIZE;
-		rctx->sha_iv = (const __be32 *)sha512_iv;
 		rctx->ivsize = 64;
 		memcpy(rctx->digest, sha512_iv, rctx->ivsize);
 		break;
diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index a34677f10966..ad39954251dd 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -184,7 +184,6 @@ struct aspeed_sham_reqctx {
 	size_t			digsize;
 	size_t			block_size;
 	size_t			ivsize;
-	const __be32		*sha_iv;
 
 	/* remain data buffer */
 	dma_addr_t		buffer_dma_addr;
-- 
2.39.5

