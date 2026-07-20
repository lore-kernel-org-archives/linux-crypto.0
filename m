Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21657C9F;
	Mon, 20 Jul 2026 01:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784511268; cv=none; b=rObLnBV3w+rWp00A39GaqesbX/pU41ypAwLrc1dFA9yJbrxPDmFDJwfsdKnaJOKgdlIutxtOX1ZhOMK4Mu8hzU114RKRYAnTg8y41EZxeQZ5DUWGp+0AVTky3oa2rS6aKcrZ6+2euJAXX1ri5j+jL0mbfYZzy/3+8sLloF7BdSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784511268; c=relaxed/simple;
	bh=fWpwIuutCJNlCfpgY/ox2afO+VZ2j0HI8gTTU87pii4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrykw4ybX2eaY5AZzQnXlAkEWIFIxDhL9NsJglXl6ayAubi4IkgzZkaDblWP4Ja5Y3Lylqv+Y3skxEMzMdF7VodG/pl/NuMtRjzoQPWZ8LemB6v8p9DBDWR/eyHVXtAXhao4QZDQUI2SHRTDTf8R57H3/fRHzMT/CBtQHQaaeY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AWpmHdmj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AWpmHdmj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KM5jQZEYZF6Eaq4lAPyXwZvXfG8a6EsvVKFxpvP6xhY=; 
	b=AWpmHdmj0owphm84F7YkN3KI/12T1AJ2gnl/XaQc6GRJhhTluZMDMEfrWjRhwoMTo9Qogp+c1n2
	HyTWvx7uQWKdBX3sqVs0ULiZvkvjQe8t90OvbpNPJjr5yYyGp7MqQia8MMfyr4YCV8Dh/Kw7PZWvz
	me5MSavYi/hzltxY/j/3BtLVT9xAOfXvFZrq9Lkd/MPklRgM8VPnMsRETY7A/nCzozcX/zdFKNVQL
	pG3hxQCtqUqsX6R7JWy9sTps5yLgXev5BUQG0U6B+zABtwI134zZnxlpv9SOHUHbqS/bHAau6OIjD
	Qj2CDMNRxa8+a+NYOTP22eoDEGUeaNNfmwQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wlcth-0000000EyMB-3Cj0;
	Mon, 20 Jul 2026 09:34:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Jul 2026 11:34:21 +1000
Date: Mon, 20 Jul 2026 11:34:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Seohyeon Maeng <bioloidgp@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccm - Set rfc4309 maxauthsize from child
Message-ID: <al17HaL8wNd_fuDc@gondor.apana.org.au>
References: <alu_daaywAIZXKZm@DESKTOP-SF55S0Q.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alu_daaywAIZXKZm@DESKTOP-SF55S0Q.localdomain>

On Sun, Jul 19, 2026 at 03:01:25AM +0900, Seohyeon Maeng wrote:
>
> Summary
> -------
> 
> crypto_rfc4309_init_tfm() spawns its child AEAD but does not synchronize the
> child's initial authsize with the RFC4309 parent's initial authsize.

Thanks for the report.  It should do the same thing as GCM and use
the child's maxauthsize.

---8<---
Set the maxauthsize of rfc4309 using that of the child algorithm.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Reported-by: Seohyeon Maeng <bioloidgp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 2ae929ffdef8..916441e4f2b8 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -747,7 +747,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
