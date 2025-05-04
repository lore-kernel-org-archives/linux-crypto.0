Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173CFA32
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365605; cv=none; b=TscSv4P7CS5la0Insq3qTOOLrwyByxexe+GHaaAZh0fcxxb3WDLLeK9eDeYgXBBzix+p+goGzxmXchenOVRe682x/fUYxPes1sDn+9CS2Zge1ZTJZKqqMQM56WTyTsk0C5CF+uQPydb9NSz6nHl5ZI37T/5NMOi56ZJ1/lWGhI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365605; c=relaxed/simple;
	bh=AjpigdMvStGq/8+RKIzEswz6oKGx4FGsI1CQ24KhTc4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=E7E3oCjSsQ7YLRLeg9SbGLJJUhuGCyJsEf1EBP3Scd/XzRxCyCDV9YKdq9B39WacBgZ+WoUL8eerN8bfcXouzk5KGIP5t/qqMwJWzNx3wWj/KKwrT8zyIbfheydBxwqZO6KA/FU+UJ7lGYE8fiTII5fOJBts9q+GZ1PeyrVc/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JVt8DQqp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JVt8DQqp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h6FUmZ1l0s1pz4j/U4DfDUiGPOyYIVKzlJHtsRce9JU=; b=JVt8DQqpvgVdgaMCkqP4zpCgxM
	POLSYmXy9uzMnscFB0/Fq7Hcpk5rR3gtvlFBJjpn11ypt5hLWE02Ee8HzmbjEJfh+RR+Ye+GaECaC
	AQMWpvI5RKrt1UPsHCGLIENhLXPzhcXO6H9Is7iRQ6uV8VmC3d37JvZuYiYzwBeYEwgUBivhq72rY
	L06epQvCsI/h6g6iq+4N1QrNjlmDbAljQ6VW/OfEpZHrxZ1FqfIgRLqrQ5+ixU9PniRgmRx8FX/+b
	TCjg+UxxDp2xo6xvloEZWhyAXSXjuBTwlkbbrh1HYzIUd5/3w4R1ViT0K9w0TDN/H+ZfgPDghbqxG
	OH237z7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZT4-003EvW-2a;
	Sun, 04 May 2025 21:33:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:18 +0800
Date: Sun, 04 May 2025 21:33:18 +0800
Message-Id: <d3b9bc6074465ecaeb50ae962ba6d4498edd8a94.1746365585.git.herbert@gondor.apana.org.au>
In-Reply-To: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
References: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/6] crypto: ahash - Enforce MAX_SYNC_HASH_REQSIZE for sync
 ahash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As sync ahash algorithms (currently there are none) are used without
a fallback, ensure that they obey the MAX_SYNC_HASH_REQSIZE rule
just like shash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 57c131a13067..736e9fb5d0a4 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -760,23 +760,28 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 	tfm->exit = crypto_ahash_exit_tfm;
 
-	if (!alg->init_tfm) {
-		if (!tfm->__crt_alg->cra_init)
-			return 0;
-
+	if (alg->init_tfm)
+		err = alg->init_tfm(hash);
+	else if (tfm->__crt_alg->cra_init)
 		err = tfm->__crt_alg->cra_init(tfm);
-		if (err)
-			goto out_free_sync_hash;
-
+	else
 		return 0;
-	}
 
-	err = alg->init_tfm(hash);
 	if (err)
 		goto out_free_sync_hash;
 
+	if (!ahash_is_async(hash) && crypto_ahash_reqsize(hash) >
+				     MAX_SYNC_HASH_REQSIZE)
+		goto out_exit_tfm;
+
 	return 0;
 
+out_exit_tfm:
+	if (alg->exit_tfm)
+		alg->exit_tfm(hash);
+	else if (tfm->__crt_alg->cra_exit)
+		tfm->__crt_alg->cra_exit(tfm);
+	err = -EINVAL;
 out_free_sync_hash:
 	crypto_free_ahash(fb);
 	return err;
@@ -954,6 +959,10 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (base->cra_reqsize && base->cra_reqsize < alg->halg.statesize)
 		return -EINVAL;
 
+	if (!(base->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    base->cra_reqsize > MAX_SYNC_HASH_REQSIZE)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
-- 
2.39.5

