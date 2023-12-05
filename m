Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFD1224CF
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815802; cv=none; b=Vbh1+36o9qnGWWaklPxvgRhR7dj4o+N4pMjzXFUBEpOAV7EZc1ACkn5pCKTY5T+zS9aoT2C1k1hGtYQkMI+j73U6ZVUriXbJeYJcLfcjimzwQ2cs/PEsvrqfQhV0MfrqSGacXXUFshxbAwKsDizuPa1r1KSv5AB+VvPTAqgG95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815802; c=relaxed/simple;
	bh=x2TQ/OnAeeJ2EnrgU6SWfTsw7gcS9oCpecdoqEFoFZc=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=DCyGDpT7prJnHB3HbxGRuloMTNXEqZysSxh/VY3rPeD+fSHhEbU0nd1lJhaQ/LY6LuYJJUYpDpyjBY2hMTSDB1oS6KNhVQujXrhiK/YGxUvVpmX37Ro8Of6TkC9v3TUiftzMczW4NIFZ3lgDti6khTMklM9q2+xCzhlsnBaI2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZou4-00D1qC-Ic; Tue, 13 Feb 2024 17:16:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:50 +0800
Message-Id: <a22dc748fdd6b67efb5356fd7855610170da30d9.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 5 Dec 2023 14:13:26 +0800
Subject: [PATCH 06/15] crypto: algif_skcipher - Disallow nonincremental
 algorithms
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As algif_skcipher does not support nonincremental algorithms, check
for them and return ENOSYS.  If necessary support for them could
be added in the same way as AEAD.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algif_skcipher.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e22516c3d285..ac59fd9ea4e4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -131,6 +131,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
+		err = -ENOSYS;
+		if (!crypto_skcipher_isincremental(tfm))
+			goto free;
+
 		if (ctx->more && ctx->used - ts < len)
 			len = ctx->used - ts;
 		len -= len % bs;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

