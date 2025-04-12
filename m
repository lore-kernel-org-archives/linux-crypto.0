Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA291C862C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455459; cv=none; b=g0eUZtfSTG5yy/ZEJc9z+J7jCnFdYsPTppzwSIj7bVwz4wLgbqXSdRF1fHpJ4nNcAl29lmjI4za3EIeQgA1ZTiNll36Ro05xkKxtIZCJfbM5a3nukdycL1WzQJph5WW2bqpoSsJxtsmHRmqBo1zRoUGQYRFSSzOswAGnXYNW3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455459; c=relaxed/simple;
	bh=zkEjWMz+NW4kv4G/+qtW+Hh+xyTZ21IwHiI0f45+3kw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=O4G94nbXvqjDH4ttk77Qzy0a84cCj0G7QWaqTLqI/2mG4gRnXbXVxpA+b44oFucE9YnqsLzBWsaWJtMAb5T1wdBjswqgr9W+npLjhKHydDBJeiQGYdNYxwS1TdoxNnmC6G1TyAq6gTLC8ryn26tDmOSt3+AIwffWl78mYU3tNEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ovzAdp7a; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ovzAdp7a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6gQDB8Yqfk3SDdiT6guiC6PkLO+DPr//1ficAUoElGc=; b=ovzAdp7aQSgQ2hTjkbl/4zw8Xg
	Zm/0p+MxuEH15pr+kbYfCIThNaT3nqEA/9Gd1LLzzUeKsJskhoiQriGLywToOPRuwmstnGxOd2Q2I
	MG2thYp+/ue0c91wodxHuwpaM6myb38t0p6ujDgmjqYM62PIP8MU7JpUj/TvYxcCmRdXVIUInE4vP
	Kj11R70A2pzJdZ/nX2N5z9d/Md+Ds42RTgp8SK0gUi8/hcF+upO35v8vllAGc6cMIAnXOp6U7HOe+
	Gvh2CQ1GehzpncuG8Fsxk2f9vH3658VE73lcxarEkviAV8aBNxifGvS2oMBMjOmKk+A8e6B0mimS4
	GdexY/6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YYH-00F5LM-2o;
	Sat, 12 Apr 2025 18:57:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:33 +0800
Date: Sat, 12 Apr 2025 18:57:33 +0800
Message-Id: <dfbd7a767b6a255b300fb6defaa9176c0e4f7070.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] crypto: sm3-base - Use sm3_init
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the duplicate init code and simply call sm3_init.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/sm3_base.h | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index b33ed39c2bce..835896228e8e 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -20,18 +20,7 @@ typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
 
 static inline int sm3_base_init(struct shash_desc *desc)
 {
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SM3_IVA;
-	sctx->state[1] = SM3_IVB;
-	sctx->state[2] = SM3_IVC;
-	sctx->state[3] = SM3_IVD;
-	sctx->state[4] = SM3_IVE;
-	sctx->state[5] = SM3_IVF;
-	sctx->state[6] = SM3_IVG;
-	sctx->state[7] = SM3_IVH;
-	sctx->count = 0;
-
+	sm3_init(shash_desc_ctx(desc));
 	return 0;
 }
 
-- 
2.39.5

