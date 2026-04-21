Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654F359A90
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776806825; cv=none; b=HsHPuQoYOQU+PnDO0kIVj06yXhOM2kLD0DL8tOKreP+lJN7ewaxSVS7vr/Mi00q955WCS5FYNe7Etuugcnsit1CfJqvJaP+VS1mtZGSv9q0PHzq2TyfXt3HtHOTy+jWG8YfjAWnP3xhiDmnu4o6N3/97VAgds5njs28xomdyb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776806825; c=relaxed/simple;
	bh=g9tLlWXToaYb9ToizB8ZRA3waTp4yCz8Brvd7xZBe/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoYrL0+15+qtWq5SlehtHK81o4qW+TZXBBpzbnavTRZ37IcqrKurwoqsmadk9zBkjAhsI72KZjrsAQfbk9qHI3ESS4Kae3bkhJl/XskQXnJRFubBG3JNxEcEGjZ0nwAL6Nprc5YjrnlCASAqi1Rji4U7rTNomh5zxTVMXicuuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWi9sPJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWi9sPJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6B3C2BCB0;
	Tue, 21 Apr 2026 21:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776806824;
	bh=g9tLlWXToaYb9ToizB8ZRA3waTp4yCz8Brvd7xZBe/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kWi9sPJim4LGY520wI2aKUYmGG5I938y1TNnZWSqXbKQSTj8uEFZboCdBsGkgyRJ9
	 r5ARqot0FnOUjS7FmKWGMFA87cyB5H5JnFxTzldDr5QlFEdOMJGS23FA9vhs5XKiTz
	 akqch9PN745HmdTOu9Brt/QCV32kOWZAIgN0xjL/zIefXKIyEm8Q4fnlib5e+3pzUl
	 HRKtEi65Wg30BBCV+jYwC9oFDIm1cjZg0+GQnrvU0veg6AEWlS09WQIn1dWUPvZwDH
	 iV91gDS6vdxbRI/sA/RnaaB/hIRLIlNGuaME+RQnhSyhnhPicwKaGsiy183TpYCGbF
	 3DXE4edb7IRrw==
Date: Tue, 21 Apr 2026 14:27:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ren Wei <n05ec@lzu.edu.cn>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, z1652074432@gmail.com, kanolyc@gmail.com
Subject: Re: [PATCH 1/1] crypto: authencesn: reject short ahash digests
 during instance creation
Message-ID: <20260421212701.GA37143@quark>
References: <cover.1775217403.git.kanolyc@gmail.com>
 <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>
 <fd3a1c5d-8ebf-48de-91a0-019b05f1dc41@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd3a1c5d-8ebf-48de-91a0-019b05f1dc41@app.fastmail.com>

On Mon, Apr 20, 2026 at 11:21:54AM +0200, Ard Biesheuvel wrote:
> > diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> > index 542a978663b9..bf44f035f7f8 100644
> > --- a/crypto/authencesn.c
> > +++ b/crypto/authencesn.c
> > @@ -384,6 +384,11 @@ static int crypto_authenc_esn_create(struct 
> > crypto_template *tmpl,
> >  		goto err_free_inst;
> >  	enc = crypto_spawn_skcipher_alg_common(&ctx->enc);
> > 
> > +	if (auth->digestsize > 0 && auth->digestsize < 4) {
> > +		err = -EINVAL;
> > +		goto err_free_inst;
> > +	}
> > +
> 
> Is this the best place for this check?

I probably would have put it a few lines earlier, right after the line
'auth_base = &auth->base;'.  But this works too.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

Of course, while this patch needs to be applied, this also doesn't go
nearly far enough.
https://lore.kernel.org/linux-crypto/20260420094120.5167-1-ardb@kernel.org/
removes the so-called "cipher_null", which has no reason to exist.

But "authencesn" itself should not be exposed to AF_ALG, let alone exist
in its current form at all.  The IPsec sequence numbers should just be
handled internally in the IPsec code itself.  That would be simpler and
more efficient, with much less UAPI surface as well.

- Eric
