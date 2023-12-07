Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC65224D4
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815797; cv=none; b=sZKjztrSygY1KKLJPoltH6b+HoMLjTf0s8RikVxNnp1dor0AeSJ8asOJYs+73BfPE4ezOYBefrVygoiIb/N8ZQJCYGwFreuoDKDbAYM4CmWG7lVLBv4UUYk9jlmJfQbQBXtUWmAaVStIeXjJ2Y6zfAULNX+jWblihtmfwPApfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815797; c=relaxed/simple;
	bh=uxRJorngY1aIn9vmvIIrT7uKl1hDXYYuUeYI9p/XXiA=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=Ax8HXYhcU68BpTPKZa3M9cZUp1JBThZ+Uo5NglJmrlT5C5owqiLoA4twR/QPOKESq6b9FyQbPIA5L/HFs2R15P6NZpLmiyj1IGsVeO9QY3Z0lnSzBP2Z9P7M99kei67IZ/X74QYCckczuoMsap48Xn3+iI4i+xqaX7CVxJmoORw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZoty-00D1pd-A6; Tue, 13 Feb 2024 17:16:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:44 +0800
Message-Id: <0d402ea82463e6d7dec2cf9b85d0ed92e0f2103f.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 7 Dec 2023 18:03:31 +0800
Subject: [PATCH 03/15] crypto: skcipher - Remove ivsize check for lskcipher
 simple templates
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the ivsize check for lskcipher simple templates so that it
can be used for cts.  Check for the ivsize in users such as cbc
instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/cbc.c       | 5 +++++
 crypto/lskcipher.c | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index eedddef9ce40..173e47aecb1f 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -148,6 +148,11 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!is_power_of_2(inst->alg.co.base.cra_blocksize))
 		goto out_free_inst;
 
+	if (inst->alg.co.ivsize)
+		goto out_free_inst;
+
+	inst->alg.co.ivsize = inst->alg.co.base.cra_blocksize;
+
 	inst->alg.encrypt = crypto_cbc_encrypt;
 	inst->alg.decrypt = crypto_cbc_decrypt;
 
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 2a602911f4fc..260666f34500 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -630,10 +630,6 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 			goto err_free_inst;
 	}
 
-	err = -EINVAL;
-	if (cipher_alg->co.ivsize)
-		goto err_free_inst;
-
 	inst->free = lskcipher_free_instance_simple;
 
 	/* Default algorithm properties, can be overridden */
@@ -642,7 +638,7 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 	inst->alg.co.base.cra_priority = cipher_alg->co.base.cra_priority;
 	inst->alg.co.min_keysize = cipher_alg->co.min_keysize;
 	inst->alg.co.max_keysize = cipher_alg->co.max_keysize;
-	inst->alg.co.ivsize = cipher_alg->co.base.cra_blocksize;
+	inst->alg.co.ivsize = cipher_alg->co.ivsize;
 	inst->alg.co.statesize = cipher_alg->co.statesize;
 
 	/* Use struct crypto_lskcipher * by default, can be overridden */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

