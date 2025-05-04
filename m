Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E8A32
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365609; cv=none; b=aoKIq7M84T7IumZha880L+uxE+iuWqNViwmUc90kP3s89wJuE/48w9GB09+apveBmJL/VK7E5Ld7vaE2w9aiaevnHwqglbKLLYO1W6YJoMPVA5VdKnr/EEA8RSwFmLX9tf3Z25PukPj2csuaCpbQ2AcEmXeo5mEGdDZJi5a1cUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365609; c=relaxed/simple;
	bh=BgzhxGjnqY5LUUCLXZPGjq4nT49agr+tT+qaZ8+Twbo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=eJPGNTFn6Z71wTPK5bNFyMNi+zx5rquKNR6V3CWcVYqiufbmYc4j8Xyz0dVxYtajydgzCBfdd0ujOhKYggvMNgoFmT8+gdwGCkm20+Urx3rP8zGdqHpdDrqOKJ2RbNyxhS9OiPQFwAyarc6zu09zJjWKEkVNLiXzmqxdaHYALcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PK3a2NZF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PK3a2NZF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZC1Ny0UCdTSvINmdaaizREFFvCuRoZZ3/HLuZrgw40I=; b=PK3a2NZFBQLFWWDcqrPaohZiJr
	LE4lXvEjd8kx07gC+FP+8W06hqZjevPIVoaUycRE91zrCwSxVyJ3fQDPLNK9QVLbaOtX25SeAIp0r
	c19kWvxvcAiSBkfuOOnWRgsY0cMm1SJQMPZ7V2xNpEDAs/QwzckjKXjVLNbpQny9I2B1iG5SyRIx/
	+UcN8luvcHRPWBCXjf2/awNc45XkJOeXb7xhBc5ypo6h9FD0hGTgvaGcLPl0O+eS23xz/2fKdO0d9
	+wsNSTq9+xOIHvvJqy8gnx4K8+HHlXpCAV3k3tQd7Pa5J5YWaPTdq9KZU5pwnUKZ3v5kFGcIvLJcK
	IPNqYkgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZT9-003Evs-1E;
	Sun, 04 May 2025 21:33:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:23 +0800
Date: Sun, 04 May 2025 21:33:23 +0800
Message-Id: <5ace4b5c14b466dfe51b1b24cb6ed304dc2bf8e5.1746365585.git.herbert@gondor.apana.org.au>
In-Reply-To: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
References: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/6] crypto: ahash - Add HASH_REQUEST_ZERO
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a helper to zero hash stack requests that were never cloned
off the stack.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/hash.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e911f32f46dc..f2bbdb74e11a 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -301,5 +301,9 @@ static inline unsigned int crypto_shash_coresize(struct crypto_shash *tfm)
 	return crypto_shash_statesize(tfm) - crypto_shash_blocksize(tfm) - 1;
 }
 
+/* This can only be used if the request was never cloned. */
+#define HASH_REQUEST_ZERO(name) \
+	memzero_explicit(__##name##_req, sizeof(__##name##_req))
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.39.5

