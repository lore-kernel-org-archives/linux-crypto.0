Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B72E8DEB
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 04:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780547466; cv=none; b=qDM8ww/rDfTiExIwq/5a2vmaogRmUQORiMG+MJzlhX+RjKj8kuF7UzYlGi6sU1kZlIhuQlSYFxO98GP8y5OoeSvP3D2pkUBQsr1gi38FmzzRFuizmzMnjVse1hWaoo0EZbn5cZ7amNYPomlX6OufDKj6YQJbipYYyi/39Wk2c2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780547466; c=relaxed/simple;
	bh=qmB/Nis2fdcRWTy9IMcMHJIC+lXNhwSsjbCcpGWgVY8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OZ+fVWYFGdHV/YbA8dxptdM2LW2RQ6LSYq5U2OJa7zIZx+FHUClUB0OjWlH2QODSchSQ/VglN0i+aoGI4UtKBl69E5kUTZpgvY6vNbNDOlcUTLMJwV/8XbKH1sfJGeZAFc+hp0MUlzXgAZNtCt4baU5txeoUjXXfW4EsomcgWqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f85p0O5Y; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f85p0O5Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=5s8jUcp/OxgHumDvouoJgKOGSnc8QQVAbeD6coPxDzQ=; b=f85p0
	O5YMNXCeaQ1IXLd1F1iao0fNHt0WztGAN7TqjiqGqvTthWvPPbl8b7tfAS8NdxQo2D8haopd1vdey
	4fObC4glKyTJBWLArgG5wHreA1vChZZniEbVvy2EQnoqOFgouV/Skxo33GJIhfYMYfNAOYrSOTK+U
	/mMNS2g5GYRUn3z/fvoa7K+Uu5mX1JF+CGGo6Jne7NXVib5cQ4ZydYkotbFQJ/tpRuq3VmzA4d/5l
	pfe4poKpqjKn72Lt6kBndqzsrbAsQ0WRMGHKrLlpgohGsY0bLGa3MOBbSgaEDpcl2Sj9mBjGUbp/K
	cYt4ZuUYdm5ZwDBcU8drqAopkcY5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wUzjK-002Eio-2s;
	Thu, 04 Jun 2026 12:30:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Jun 2026 12:30:54 +0800
Date: Thu, 4 Jun 2026 12:30:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: rng - Free default RNG on module exit
Message-ID: <aiD_flpAvcwS4XnO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When the rng module is removed the default RNG will be leaked.
Call crypto_del_default_rng to free it if possible.

Fixes: 7cecadb7cca8 ("crypto: rng - Do not free default RNG when it becomes unused")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rng.c b/crypto/rng.c
index eec786c45bdd..828b0d807473 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -230,5 +230,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
+static void __exit rng_exit(void)
+{
+	int err;
+
+	err = crypto_del_default_rng();
+	if (err)
+		pr_err("Failed delete default RNG: %d\n", err);
+}
+
+module_exit(rng_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
