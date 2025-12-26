Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EF410E3
	for <linux-crypto@vger.kernel.org>; Fri, 26 Dec 2025 00:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766709520; cv=none; b=dRrL8LMBY8DrTb2qW7EA3jQI6HVjyNN1D0NOGJ3nbjKw4E3v2SWYpjxD2Lsw86JtzvA6Jp7Q9XsYXznDgSRIQIx1gnZ8niZTGpMrzz7kLQtvTNLhGAXqfaeDOorD7VNcaB/UoRA6+WyHtdArfoNSDPkvxWkMhFcyOOzjeFvHBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766709520; c=relaxed/simple;
	bh=A2aqbJ/gxOHq+PdOw00dvo2hkkqQhOJr86ESqRDO0AQ=;
	h=Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc; b=mnIULsIT3IobqUuMRz7SEhVW/iuM8vVIBOKC1n5zzfycEsT37TLE1gjXVVzttVEXGeBYWay57S3m9sIFJg47mHSo6DmaY3rAF5tRocINl7pvHiKJxAgLvYxiW9tX280+iCTdYHfyHi1sIZj9gCf7PiWJgPKUVV0w7eWrd5Y+TwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NplpmI47; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NplpmI47"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Cc:To:Subject:From:References:In-Reply-To:
	Message-ID:Date:cc:to:subject:message-id:date:from:content-type:mime-version:
	reply-to; bh=ojir2qU/0QMQ1JvI7qWaceIfsgwkcbc/6wy+wIgu9Uc=; b=NplpmI47ANRFrTYt
	CwMuTxBXZIQ/+HUKtuF3JoY1MoICD2vc5dBi3cF5YUgl4KVvLcCiUVruKHjJ6Kk3IP2t6VVrohJ/A
	py9VrnyV9EKDG59Y1u9JY/hh9CgcMWuTQEsySGss8iR8fh16KDysXKUVJRRa8JfpiE+C7ZBlib9pp
	kZUYdDdCUTH4L2CR8lC6XRM8Vy+IYBlcPgjhPp3tpAzTElpb5aosXOsNpeIPNycXCQE5jeny0P4M8
	YF4rxbK8Xat4DlL5iR0hbKAS3d0Y3nPPCv1+aZN4aRYuQ2folSdzo1RhenLCOSkxWAPlEmJnJ0tNy
	aKRxzaxBac19XhkFXw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYvqd-00CY7q-27;
	Fri, 26 Dec 2025 08:38:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Dec 2025 08:38:27 +0800
Date: Fri, 26 Dec 2025 08:38:27 +0800
Message-ID: <0533ee1ec37d82fd22a74921cf6a1f3dc9d022b0.1766709379.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1766709379.git.herbert@gondor.apana.org.au>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: acomp - Add bit to indicate segmentation support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..366dbdb987e8 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -188,6 +188,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a2137e19be7d..89b9c3f87f4d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.47.3

