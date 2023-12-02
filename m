Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ECD224E7
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815800; cv=none; b=P358RHbkW877rY7q21BTBYjumNV6PQMulCL8Of3sRlSr2dmhIIhkPtWCbUd8GW7oFJZhnR6InNG3T3VMPyObqs+6Za1b3FEAQkEhRhhZojouvtUwnI/xgBSO8XzWD9bzIrl/RMMDDZDnm4dZc44ReSaJe8CSzLIN71jOkvErG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815800; c=relaxed/simple;
	bh=dA+sq1crdd5aqkQD/0+/b8QELvVNEjBMUVdSZ/vi4AA=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=BhIPz8Ht/HGN39KwAvYV/C45mCwCvkcqPcGt93Jk5PkUGI+jv/s0KM66+jhqeuuVIygq9VITrBiQH+WyBZbkpJSSdadVg2UO5M3iTri7gYP/9EINXPIXfNAFZg3n3p8qZl9fh4opJCrNi2tTvTGR6jdZOYBt+RQVxpUkG9VEUmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZotw-00D1pS-7a; Tue, 13 Feb 2024 17:16:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:42 +0800
Message-Id: <a145e0a11879baf407aa5595c71589c5f55a7bad.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 2 Dec 2023 13:42:19 +0800
Subject: [PATCH 02/15] crypto: algif_skcipher - Add support for tailsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch makes use of the new tailsize attribute so that algorithms
such as CTS can be supported properly when a request it too large to
be processed in one go.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algif_skcipher.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 02cea2149504..e22516c3d285 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -103,13 +103,14 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
+	unsigned int ts = crypto_skcipher_tailsize(tfm);
 	struct af_alg_async_req *areq;
 	unsigned cflags = 0;
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->init || (ctx->more && ctx->used < bs)) {
-		err = af_alg_wait_for_data(sk, flags, bs);
+	if (!ctx->init || (ctx->more && ctx->used < bs + ts)) {
+		err = af_alg_wait_for_data(sk, flags, bs + ts);
 		if (err)
 			return err;
 	}
@@ -130,6 +131,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
+		if (ctx->more && ctx->used - ts < len)
+			len = ctx->used - ts;
 		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

