Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBC221A04
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815806; cv=none; b=tgwFD1SWLXjJhrhb8niCRTwY7K6Rd5C2utEdNBaWu/tAkW/qxyk69gJ0p+uCBmq3mHryB+rYIvjhk+FntqMLAF6C2NwB8GJKS/2zrf5U84EaSmgIVi2lY4+mjlhlbDpNfjb9F+9h77kj9XVvAv17a1cJTgQx71WF27ZMc99PrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815806; c=relaxed/simple;
	bh=HNby/qXx8gDNNLlpPVqDrnIG0UjPYHt7sz9U7K0xASE=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=X4lfQe8i2uO8HQvAQQ0aT25Hu/8eMakOsRoesziWsDDOq+twVZbfh0/Z6xxJYvnvQxPYa+ego/ifh6vGsRgQ1uioWfnBv9cgX4JrwuJ3d8g9YxUp0iQIcOvsk64/Pv7+kKH/RxAwTjb2wGUCtdPx4F5T2W8tpvFAa5YHmI1RnIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZou8-00D1qY-Oz; Tue, 13 Feb 2024 17:16:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:54 +0800
Message-Id: <dcd973a33a21bda3f8ce2aa7030fa7a3391b5ce0.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 6 Dec 2023 12:46:33 +0800
Subject: [PATCH 08/15] crypto: skcipher - Add incremental support to lskcipher
 wrapper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Execute a second pass for incremental lskcipher algorithms when the
skcipher request contains all the data and when the SG list itself
cannot be passed to the lskcipher in one go.

If the SG list can be processed in one go, there is no need for a
second pass.  If the skcipher request itself is incremental, then
the expectation is for the user to execute a second pass on the
skcipher request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index bc54cfc2734d..10e082f3cde6 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -206,11 +206,15 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 	u8 *ivs = skcipher_request_ctx(req);
 	struct crypto_lskcipher *tfm = *ctx;
 	struct skcipher_walk walk;
+	int secondpass = 0;
+	bool isincremental;
+	bool morethanone;
 	unsigned ivsize;
 	u32 flags;
 	int err;
 
 	ivsize = crypto_lskcipher_ivsize(tfm);
+	isincremental = crypto_lskcipher_isincremental(tfm);
 	ivs = PTR_ALIGN(ivs, crypto_skcipher_alignmask(skcipher) + 1);
 
 	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -223,16 +227,23 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 	if (!(req->base.flags & CRYPTO_SKCIPHER_REQ_NOTFINAL))
 		flags |= CRYPTO_LSKCIPHER_FLAG_FINAL;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	do {
+		err = skcipher_walk_virt(&walk, req, false);
+		morethanone = walk.nbytes != walk.total;
 
-	while (walk.nbytes) {
-		err = crypt(tfm, walk.src.virt.addr, walk.dst.virt.addr,
-			    walk.nbytes, ivs,
-			    flags & ~(walk.nbytes == walk.total ?
-			    0 : CRYPTO_LSKCIPHER_FLAG_FINAL));
-		err = skcipher_walk_done(&walk, err);
-		flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
-	}
+		while (walk.nbytes) {
+			err = crypt(tfm, walk.src.virt.addr,
+				    walk.dst.virt.addr,
+				    walk.nbytes, ivs,
+				    flags & ~(walk.nbytes == walk.total ?
+				    0 : CRYPTO_LSKCIPHER_FLAG_FINAL));
+			err = skcipher_walk_done(&walk, err);
+			flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
+		}
+
+		if (err)
+			return err;
+	} while (!secondpass++ && !isincremental && morethanone);
 
 	if (flags & CRYPTO_LSKCIPHER_FLAG_FINAL)
 		memcpy(req->iv, ivs, ivsize);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

