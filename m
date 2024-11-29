Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABC1598EE
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2024 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732871500; cv=none; b=copwqZ6+rdFhA6I11nTui5/SfQevNpB5LDBqYDRlFs2PMZ6qJ4lzC9iDO7uxjYFwk8tGtUl2bxOHTk1+zw/HK7LTkwQ5IlE40QUsB2iHluQvcO1eso10jnOc+YpT411c3M32eRNuFjnG3ySYdnrxt0JwvDLtfGUZL25OcZF0dB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732871500; c=relaxed/simple;
	bh=5TupBwc0KrPgHFEPcYxK6HempSLu7zgHhlYAhk1M02k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DA6Xzd/zPU90nQJ7K9cXnnNHnpPZs3EOTnNKTwg8YXrZigd9/mBbCaogO5d44UrOJ2CCGs2HOITO86zV+8I9y70khEbicJqeLqk0AP3cXPz3dueHRW++P+DcIRODgu+s9wP6rsBEDJmqq0vo0JWbxiqzdbL5RSR9EoL5L/w4JQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mm30Lx40; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mm30Lx40"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Wzh3FPL1Enqe7ci06Ju+4uei0zfN1sdgF2VSuGFZ3ak=; b=mm30Lx40ZPFYEXs2S0y+Lzf6Q7
	zKFMU00TRw8FdJGhwHJzwsK9fvex2rYsLu9ygMCXKbqT73elsjX/83zfDH6zGZc1HeiLUZxrOigim
	qI3cP6JLwn3SaAtieQvHzBBPuD4ytYG/vpYZ7ZC7cXx2so158U5hOnFyrPz28eKY87ijlSLwf2Jcr
	/SOgsK0bWdZ7bG8RW6huNAJoXesAUD8wDscoIzGU3jiLLPgDj70Ko7+niwXgTSF9g1UgnHzD+/O7p
	LEfgawwr8IH7Xth5Yx9I/Yt4ANAh/07Q1Rh/8jPx7Qixi3BXlJ8wUs42nsyDUX9egSEpibJqW7/fT
	xMb6F1UA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGx2D-002MLl-2z;
	Fri, 29 Nov 2024 17:11:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 17:11:33 +0800
Date: Fri, 29 Nov 2024 17:11:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: sig - Set maskset to CRYPTO_ALG_TYPE_MASK
Message-ID: <Z0mFRROEHOpnOvCZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As sig is now a standalone type, it no longer needs to have a wide
mask that includes akcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/sig.c b/crypto/sig.c
index 5e1f1f739da2..dfc7cae90802 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -15,8 +15,6 @@
 
 #include "internal.h"
 
-#define CRYPTO_ALG_TYPE_SIG_MASK	0x0000000e
-
 static void crypto_sig_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_sig *sig = __crypto_sig_tfm(tfm);
@@ -73,7 +71,7 @@ static const struct crypto_type crypto_sig_type = {
 	.report = crypto_sig_report,
 #endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
-	.maskset = CRYPTO_ALG_TYPE_SIG_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
 	.type = CRYPTO_ALG_TYPE_SIG,
 	.tfmsize = offsetof(struct crypto_sig, base),
 };
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
