Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C8F21B9C9
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712070; cv=none; b=DVeM+V5DpxMjQHt0tqMo/QisXB5FT245kLXePDF5pig3XKXRy++3MZJUMVI+w137iRDBnAJfck6YLW8Zm8QOkeMj3XB6wQ14wit/xosBHxcczSwO/ShUYOFrMPt9hnNG6bCVClDEdrFQD6mxrfvDdlVwcuPvJI20n/k/3OoY+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712070; c=relaxed/simple;
	bh=p7uVlvE3Qm03vihPsE08vYaawKMxPv/DQrOZ33uA8iU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DA/hsUtIRjOwi9xiZgZmfrFTPNhIR1tcIlszuL/9zYDyQEv/HDrPhrmMld8wR3ndDQD1TvJtF2ygIlv99CECBcZX9/4k9000ljMUfVtevj6vgkgDZ4Jnc+QlaKIIza2TibXbvN9GFTEmwlZo3FyB2BOivLRAU9Ag3ursZh/xyiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=CDFQbRxh; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="CDFQbRxh"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63fca769163so1825757d50.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 00:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1763712068; x=1764316868; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1tvndMjP9HAoDprqdYPBtu6xsScYiQegulJGgBItgE=;
        b=CDFQbRxhpK3BEgEhyY8klRbYdf0Bo9A0y2m2pgDH+qfdVc9ogFEpVpumfHSxD+1069
         /cvZgw9+SqH1h0bCfXtPQeu3lwe1GrJ+KC69HBV7xH7EwSy84C3WJPs78Cdw730uuGT+
         S4y/e1TavZ7fLR4DAYquPWYFoKmApW47WyioA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763712068; x=1764316868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L1tvndMjP9HAoDprqdYPBtu6xsScYiQegulJGgBItgE=;
        b=exOOus8n+Z8Ebz1rCZsSC1ubANTWCQ/bGAZEAQslP7VOu2OLAT6QNL4jOQGbBkqS+W
         6fu3l6YVAbJVO9r+vOrmNNPyoc7LAi3S0NUHq6tcCFP/2qmDU78kC19vomX9vS2rwlLK
         v3ZD0mpG1Gu8G4SNMv0vTYMhIwpYm5yW04kUzpsqXFaheN9agv3Ruan9a35xJJn9/6lc
         01aJZTbUXbx6HuumUrlb2oyqjqtnyADRBU2U8rfIoaSduaeX+xE4WcDswmzv8bfdmdM5
         NbME/SAgxEDo4Vk4ZIDBn1PUrXtq2JdqC+YKQjQSo8cqeD4J5GPVQ9ayLEhf2tZ2I7cS
         lsFg==
X-Gm-Message-State: AOJu0YyrHTA3aoe10yWcqSxVeYw92vBXC6nC0FaxSfapVmIqbA1Hj6rg
	SBgXzdigGyahuCp1/7Bg8Xk49z5lOBOGSSs4pGSTac8wWW2v6XoIIVCsQbZW3VkLusVRk7apAaN
	EUBkLuTEg7XHVmjvxnCehOWU5z4FsT2hhPDtIncq4FA==
X-Gm-Gg: ASbGncvou1f9FD22nPEMRMvHzHgMEFacyeigOquRWvr8OKet2hS/SsDYt91O6PAVZ4v
	Uok5PteYWS4lpJkjXQIhOhEM9osJ6aggoBhdZdtkYsskUU8Fk9FA41RtB+oQ8ePFQ260w0aBQmM
	7rq3P3SmZIvKIQbBJDWeQ1OlOsKc9ZXra+fku3afVXLGD58BbGD1SGlVwjr260/fl0ZSuKe1fUM
	H62v8s+jDkyfdZiVXl1DOInHcZqXo79mpMdwATYNH1a+ZcynClAbhmjjjtZZl9ILbQRr2lbMpSx
	lCD1lilrYCowYJRoNdrwaD882SRq
X-Google-Smtp-Source: AGHT+IEl8KOODStMI8dm5m76lMMQQ5gRzTphkTRgniUf/5r0P9q1EzWrX2kDa3Fv9kZPz1574X5k0b+ryB9WLwLycEY=
X-Received: by 2002:a05:690e:190c:b0:640:d255:2d6f with SMTP id
 956f58d0204a3-64302a568f1mr802060d50.34.1763712068236; Fri, 21 Nov 2025
 00:01:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
 <20251031044803.400524-3-pavitrakumarm@vayavyalabs.com> <aQw-ugxNqclAqDkg@gondor.apana.org.au>
In-Reply-To: <aQw-ugxNqclAqDkg@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 21 Nov 2025 13:30:57 +0530
X-Gm-Features: AWmQ_bkOmSF2vdQ5-_vP3HC8nfm7o6gE93J9cVBanb22mvJUTU4-cuCIGuUYy3g
Message-ID: <CALxtO0=LxXg6Cw+PKnPQLhurkPRxvTOn63pyK9gFFH=y+F=hBQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] crypto: spacc - Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Thank you for your suggestion regarding removing dynamic statesize and
reqsize usage in the spacc_ahash driver. I reviewed the
aspeed_ahash_fallback implementation as you recommended and updated
our driver to follow the same approach, including using the
HASH_FBREQ_ON_STACK macro.

With these changes, the ahash self-tests and functional tests pass
successfully on kernel 6.17-rc1. However, the same implementation is
failing on 6.18-rc1. Since aspeed_ahash_fallback is currently the only
reference driver using this new fallback method, we wanted to request
a bit more insight into the expected usage patterns.

Specifically, it would be helpful to understand:

Whether there were any additional changes in the ahash API or fallback
handling between 6.17-rc1 and 6.18-rc1 that drivers should adapt to.

Any constraints or assumptions the new fallback mechanism requires,
beyond what aspeed_ahash_fallback demonstrates.

Whether the stack-based fallback request (HASH_FBREQ_ON_STACK) has any
new limitations or expected ordering requirements in 6.18-rc1.

We want to ensure our implementation aligns fully with the intended
direction of the API, so any guidance would be appreciated.

Warm regards,
PK


On Thu, Nov 6, 2025 at 11:53=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Oct 31, 2025 at 10:18:01AM +0530, Pavitrakumar Managutte wrote:
> >
> > +static int spacc_hash_init_tfm(struct crypto_ahash *tfm)
> > +{
> > +     const struct spacc_alg *salg =3D container_of(crypto_ahash_alg(tf=
m),
> > +                                                 struct spacc_alg,
> > +                                                 alg.hash.base);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(tfm);
> > +
> > +     tctx->handle    =3D -1;
> > +     tctx->ctx_valid =3D false;
> > +     tctx->dev       =3D get_device(salg->dev);
> > +
> > +     tctx->fb.hash =3D crypto_alloc_ahash(crypto_ahash_alg_name(tfm), =
0,
> > +                     CRYPTO_ALG_NEED_FALLBACK);
> > +     if (IS_ERR(tctx->fb.hash)) {
> > +             dev_err(tctx->dev, "SPAcc ahash fallback tfm is NULL!\n")=
;
> > +             put_device(tctx->dev);
> > +             return PTR_ERR(tctx->fb.hash);
> > +     }
> > +
> > +     crypto_ahash_set_statesize(tfm,
> > +                     crypto_ahash_statesize(tctx->fb.hash));
> > +
> > +     crypto_ahash_set_reqsize(tfm,
> > +                     sizeof(struct spacc_crypto_reqctx) +
> > +                     crypto_ahash_reqsize(tctx->fb.hash));
>
> Please stop using dynamic statesize/reqsize values as they are
> being phased out.
>
> The API now provides a fallback directly that can be used with
> a stack request.  Grep for aspeed_ahash_fallback to see an example
> of that being used.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
