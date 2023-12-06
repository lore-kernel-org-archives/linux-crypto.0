Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC500224CF
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815813; cv=none; b=owbSKVCszwNZEBa+TNca2B60FRp2G1JVrOnGzKEIKYBwqtsKHw2WHchXcYEXXgetE1ZzWq8SWrH5MSEfD869Q00vAdgJv0DUDA53CHo8ozugfMHk/yBzwLqJZuEYxCztvrjQA9aa1IeWhC/AO2+wMj4qu5ILzyGTgbvzel85kKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815813; c=relaxed/simple;
	bh=gWFzrtOaKQWYEO1jMXfxCKsEOPF9us+nOzFX2DI1FWw=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=paTRkcTAxTjCIzzvsI2wbHHaE7txxFiOCxvUmJosUEdawIKfu624RvGyoxqx7VdGZx01kooHTU+TspXZaVSt/63aEmmVgJjBaHUOqWbRiMpnqgx3A2GR4kDHD2bASzKHMtwQqyIz/3k49C1qbJVHhvQdnq6srY33gyyu2b83nOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouF-00D1s2-0b; Tue, 13 Feb 2024 17:16:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:17:01 +0800
Message-Id: <88c723ec1903971bc726828a8aa2eb3622aa6df8.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 6 Dec 2023 16:55:32 +0800
Subject: [PATCH 11/15] crypto: skcipher - Propagate zero-length requests to
 lskcipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Propagate zero-length requests down to the lskcipher algorithm as
otherwise the return value could be different, e.g., zero vs. -EINVAL
for xts.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 8660d6e3ccce..00ea963a2d2d 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -227,6 +227,11 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 	if (!(req->base.flags & CRYPTO_SKCIPHER_REQ_NOTFINAL))
 		flags |= CRYPTO_LSKCIPHER_FLAG_FINAL;
 
+	if (unlikely(!req->cryptlen)) {
+		err = crypt(tfm, NULL, NULL, 0, ivs, flags);
+		goto out;
+	}
+
 	do {
 		err = skcipher_walk_virt(&walk, req, false);
 		morethanone = walk.nbytes != walk.total;
@@ -245,6 +250,7 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 			return err;
 	} while (!secondpass++ && !isincremental && morethanone);
 
+out:
 	if (flags & CRYPTO_LSKCIPHER_FLAG_FINAL)
 		memcpy(req->iv, ivs, ivsize);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

