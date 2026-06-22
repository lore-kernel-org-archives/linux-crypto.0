Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C0A28504D;
	Mon, 22 Jun 2026 04:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782101789; cv=none; b=mltqBlKdGlRhhezQnqQAzxm2fh67b6dbm8Q8GRoNmOT+9EupOrbQMHzqLJYQHbELyD7dsIMUKvPO6N+JZkX6LvRpJLEsJ49P43Dw5761CCKP9Xq2yZM9ktW6+cvWdQuWlqqpg20IizDV8dKI8BUKJcLPwEZUCh/mlPz99yh6fFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782101789; c=relaxed/simple;
	bh=Wc3nj1o1R4JX3m0fQLeVr4lnI/t8wNwAtg+ad8CSLmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7NhNDyo9+9o8zsmZ9y8OzprN29hP0mp7E9pdBagtCwVuBLMWilXYletIjxlTt0jjanMAuAwldLw+seJOi5O31Th91W/m55MD5BZG/f3BLHTwpOCW/GxdN7K+6HYjp4Fsm28QTLkPCA1nqnYxb2IE/nLtf0rZs88XJKkALr5C8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Vg1aPjhz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Vg1aPjhz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8jW7hVwajH1st81Raf8Po4Ho1/83pEkyfqSVqxkvxW4=; 
	b=Vg1aPjhzPtEhSjlTuroTmkyRS/iCUGwDW5sp5WnFMCtiM/9W9XVjl1LbnDgHnbpfGjkPaSpsER3
	L7U5M/pzKFzTbP0FOGRK1LyDgUq4knny64xYqL+2eWIU5Q1exJ9xxbwnFGgtqs8XNiOGtW+6rk8H2
	Qq4Y2WTMhToxcx1ePn3CDUZEXmschAb9PmjhlK7UEj3iOaxXe6d5CWKDUEfP8EV/INxgVs2LHQlxJ
	N1BsRMhUdB60ocBQrLMvoIvJE3c9n6EThjgf4mEWFZpsURhXL+E5fzoevSPlktb7vcZMogBSs9al5
	bYDhb1z8DVUYXojFmsXXUCIQfFnScS2qFW7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wbW4t-000000078pb-3Qzi;
	Mon, 22 Jun 2026 12:16:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Jun 2026 12:16:07 +0800
Date: Mon, 22 Jun 2026 12:16:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
Message-ID: <aji3B9a72VEAOu03@gondor.apana.org.au>
References: <20260502163328.696098-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502163328.696098-2-bestswngs@gmail.com>

On Sat, May 02, 2026 at 09:33:29AM -0700, Weiming Shi wrote:
>
> diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> index 16a7ae16593c..22f04656d529 100644
> --- a/crypto/asymmetric_keys/asymmetric_type.c
> +++ b/crypto/asymmetric_keys/asymmetric_type.c
> @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyring,
>  	if (id_0 && id_1) {
>  		const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
>  
> +		if (!kids)
> +			goto reject;

This check is actually unnecessary because we've already matched
the key against the kid so it must be present.

I'd get rid of this check or perhaps add a comment instead.

>  		if (!kids->id[1]) {
>  			pr_debug("First ID matches, but second is missing\n");
>  			goto reject;
> diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
> index 86292965f493..ccf1084f720e 100644
> --- a/crypto/asymmetric_keys/restrict.c
> +++ b/crypto/asymmetric_keys/restrict.c
> @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *dest_keyring,
>  			if (IS_ERR(key))
>  				key = NULL;
>  		} else if (trusted->type == &key_type_asymmetric) {
> +			const struct asymmetric_key_ids *kids;
>  			const struct asymmetric_key_id **signer_ids;
>  
> -			signer_ids = (const struct asymmetric_key_id **)
> -				asymmetric_key_ids(trusted)->id;
> +			kids = asymmetric_key_ids(trusted);
> +			if (!kids)
> +				goto skip_trusted;

Yes this is definitely buggy.

I think it was introduced by these two commits:

commit 3c58b2362ba828ee2970c66c6a6fd7b04fde4413
Author: David Howells <dhowells@redhat.com>
Date:   Tue Oct 9 17:47:46 2018 +0100

    KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]

and

commit 7e3c4d22083f6e7316c5229b6197ca2d5335aa35
Author: Mat Martineau <martineau@kernel.org>
Date:   Mon Jun 27 16:45:16 2016 -0700

    KEYS: Restrict asymmetric key linkage using a specific keychain

So the Fixes header should point to them.

> @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest_keyring,
>  		}
>  	}
>  
> +skip_trusted:
>  	if (check_dest && !key) {
>  		/* See if the destination has a key that signed this one. */
>  		key = find_asymmetric_key(dest_keyring, sig->auth_ids[0],

I'm not sure continuing here is a good idea.  Having a private key
here makes no sense whatsoever and we should just bail out right
away.

I would recommend returning an error of some sort if kids is NULL.

David/Lukas/Ignat, any opinions?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
