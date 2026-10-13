Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E5F49B1EA;
	Tue, 13 Oct 2026 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884704; cv=none; b=E7psixMWRTOk/kyJQefcxTQchpoR92eO+9lGVIugg39UZcf/C9kdsNyoz/CNsiexsf+vY5JAMRFopf5oB95Wd+g0TMVsQYdy2CVKGatr/fK8pVkhGz+avrDiMYZ3O7F9lbn4yX8dunkI21abRKh7nsyecPOoTo2ZvTHvMle3eFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884704; c=relaxed/simple;
	bh=3dy4YqTorHjhpElLR6e8/eTWi+K/ZuD10wVCNJqhxIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inKm6Jh+xh2hnUSi0qEFHRoypVuJV6iYJ3ut8OqJQPsP0nv1vHzlT9RW249BEW1qzL3dUR5M8HbB4RdI6nwus8rWtdGvsZAW0PcsPSt9NIDJ9kKEsiZPKETI2Q/vU9JTIGTF/2wuPRFB/RKFoNiMYCGTaFUSWe/t5G1+kq++OM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cIkWQNLD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cIkWQNLD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/e6lP0zIfYuncX6FoWA0t18UOCeFYO98vjWiK3ReD/0=; 
	b=cIkWQNLD1S1pqISCFa/uvYrI2tDelPCvusuvXE1Wc+Eyfdpg0HLwXvd42R8g+tQ8DQ94se9hwXa
	XvNWEo7K9qRvhDIQEh2gm2A5fkVsoWjJUXgI8igrg7zyPdnjKOirnl5lSn+J/X/uixXfFSYaHmX6b
	Gvrcdv4kldAxOgLGiqmUrSXKpqaK4hCjirWY6fvM8n7gu1qFSiifqvrefXqbHy6fv05fOqboFm6yD
	an2M6KNtpP7NQEikFvPq8dsWSNB3KzGQc30ZRF6uMVG0G5drxOwxqnQ+ZyFqfeNB89yu7ZfxqKUEC
	zjayKt/tYiX2mO1STYenL3RCDKIal50a0LHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xGZ3n-00000003KGf-3HDy;
	Tue, 13 Oct 2026 17:44:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Oct 2026 20:44:39 +1100
Date: Tue, 13 Oct 2026 20:44:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
	dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com,
	yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
	alex@ghiti.fr, senozhatsky@chromium.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] crypto: acomp - Enforce MAX_SYNC_COMP_REQSIZE in init_tfm
Message-ID: <as39h_dFzL-Al1-r@gondor.apana.org.au>
References: <20261009163146.83112-1-usama.arif@linux.dev>
 <20261009163146.83112-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009163146.83112-3-usama.arif@linux.dev>

On Fri, Oct 09, 2026 at 09:30:31AM -0700, Usama Arif wrote:
>
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 5d5358dfab734..12c1ce1f6243b 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -203,6 +203,19 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
>  	       CRYPTO_ALG_ASYNC;
>  }
>  
> +/**
> + * acomp_can_use_stack_req() - check whether a transform can use stack requests
> + * @tfm: ACOMPRESS transform
> + *
> + * Return: true if @tfm completes synchronously and its request context fits
> + * in the storage reserved by ACOMP_REQUEST_ON_STACK(), false otherwise.
> + */
> +static inline bool acomp_can_use_stack_req(struct crypto_acomp *tfm)
> +{
> +	return !acomp_is_async(tfm) &&
> +	       crypto_acomp_reqsize(tfm) <= MAX_SYNC_COMP_REQSIZE;

I think we should enforce MAX_SYNC_COMP_REQSIZE in the Crypto API
and then you can simply test against acomp_is_async(tfm).

Feel free to include this patch in your series:

---8<---
Enforce the limit MAX_SYNC_COMP_REQSIZE when an acomp tfm is
initialised.  All existing algorithms obey this limit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f..c8b4b8589769 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -92,10 +92,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 
-		err = -EINVAL;
-		if (crypto_acomp_reqsize(fb) > MAX_SYNC_COMP_REQSIZE)
-			goto out_free_fb;
-
 		tfm->fb = crypto_acomp_tfm(fb);
 	}
 
@@ -105,15 +101,19 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
 
-	if (!alg->init)
-		return 0;
-
-	err = alg->init(acomp);
-	if (err)
+	if (alg->init && ((err = alg->init(acomp))))
 		goto out_free_fb;
 
+	err = -EINVAL;
+	if (!acomp_is_async(acomp) &&
+	    crypto_acomp_reqsize(acomp) > MAX_SYNC_COMP_REQSIZE)
+		goto out_exit_tfm;
+
 	return 0;
 
+out_exit_tfm:
+	if (alg->exit)
+		alg->exit(acomp);
 out_free_fb:
 	crypto_free_acomp(fb);
 	return err;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
