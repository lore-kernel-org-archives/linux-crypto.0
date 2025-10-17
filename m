Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4819E81F
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760688059; cv=none; b=O9CJEs6JL6rOZXbI0CHuW3Tqy4t3wGRaZYsemzkx1wRkpxd2IaM8/d+skxfAsvsRV5ReaRnWn2sWI7EVoYH5I2NMqGLDiIhsF9i17O4cNkQmTEY4CfIyKSrIINdD884MGYWbbMqBtDrQFPCfLyCeuox1lMeP7r0ZCAJqLbIBOvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760688059; c=relaxed/simple;
	bh=CmYry6crPlIzKmqBRZbTHEks84hlKoutmRpsgsQYoNg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IM0TA8L4RSic6zSB/mW/PIY+o/+FbgdSYMYzh7eYdWWCVSXK+OAgoa4Yj8dimU39h4x9MdqZ1ji8sVgsAz32uzMlNZgu8vVWh7MYDqer8ZvEznGgNhYsWcmqz/WRrnd1+paKC4a5P2AQs9q2NkSmM82elTOhCQ/xtB251SKFYlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oOXBQtbW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oOXBQtbW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=MMFAgcumgfAOmgll7weXn0oLsqDeVQTkVKaFRFdBTNQ=; b=oOXBQ
	tbWte+NKcWWXqC+j17UEnZuC3d1dJXPw0avb6GYzRw7H1QlKo1mHwlLaOADttbmf6KKZxB+8hs+TO
	JUPckSGCnh1l6SKWc4+QZzWV8bQxYkg05JPWOg5WPKZGCcBO+azAUPNZOFDuTASDgiA1hBdxraUpa
	3WTGKW8Wzy8BHaeCfGcn7uiE8Ofzun0PUBMQmEueTAlJf6pZHxVW7h+ZrxWa2Ne6z2XeDjEGfRbJE
	4gz0a33JMJHcKdm2Ca6Lk4The40O7iwFJyvEKpJLI5tlAbuUQBaZ5xXrPDGY1Hf7qfS5uajieezxO
	gqNIdV42yA8B2CRJOtddAhmMcS5+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fOM-00DMo0-3A;
	Fri, 17 Oct 2025 16:00:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:00:50 +0800
Date: Fri, 17 Oct 2025 16:00:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun8i-ss - Move j init earlier in sun8i_ss_hash_run
Message-ID: <aPH3sq2wJeIdkLzd@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

With gcc-14 I get

../drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c: In function ‘sun8i_ss_hash_run’:
../drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c:631:21: warning: ‘j’ may be used uninitialized [-Wmaybe-uninitialized]
  631 |                 j = hash_pad(bf, 4096, j, byte_count, true, bs);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c:493:13: note: ‘j’ was declared here
  493 |         int j, i, k, todo;
      |             ^

Fix this false positive by moving the initialisation of j earlier.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 8bc08089f044..36a1ebca2e70 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -502,6 +502,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 
 	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	ss = algt->ss;
+	j = 0;
 
 	digestsize = crypto_ahash_digestsize(tfm);
 	if (digestsize == SHA224_DIGEST_SIZE)
@@ -536,7 +537,6 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 		goto err_dma_result;
 	}
 
-	j = 0;
 	len = areq->nbytes;
 	sg = areq->src;
 	i = 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
