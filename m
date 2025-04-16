Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F384B1A08DB
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816604; cv=none; b=gdS5+s0jX5JC5gimiJi42aVo9cc2bhMRiMfV/RU086nrMPkp/+xSwSMufca7V+Y9DhA6SvIVVYDEQor9TnbBgLdTEnZM2mG8L0Wr14e8J136cw2nDTrRNNxkkRdVEn4o23/+IvO9nizGdIOZw+NAVRrue9S150C+hffsokJQIUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816604; c=relaxed/simple;
	bh=M1x4RC5EOfQHcSo8roVtiUUlf0cHzDGTolgxIV9gtKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SU7JdJWPp+nUYdIii6FFDKyjO3TKn3no9UGDkQJkFvLaCjEO/8QxGP1s+V8SeHyJBM36QlqocwvnY6ET57ohLbNlDC6+vZRwRnABHE9ro55u13fvEBFUFERCJjiMT+zUmi7eiCXHvyFi2Fe3FZmYjgpdHp6KBEQ61trZFL6iNL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UJBMdVwQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UJBMdVwQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744816601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAiRJ+rVIwdO2WdbVlHtwPy5PkHyBBI5D1qW/1GoN3k=;
	b=UJBMdVwQ6rvJHj15JWVpoETD09AUaKDpKwtfNT2IvFEwDKmHF/vSixCdeYLpSQeM2cshjj
	0k4NWAu8dNF53uqgGQRlA3vKqLLeu26REMYrQAvqthDJuNyLj2libx60DkFFbvGN0uOuKa
	7/oiIUxSqRdKiDCweh+/bfu/kR1zZTc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-jsF6xFWLP_uH75MIoF2KtQ-1; Wed, 16 Apr 2025 11:16:40 -0400
X-MC-Unique: jsF6xFWLP_uH75MIoF2KtQ-1
X-Mimecast-MFC-AGG-ID: jsF6xFWLP_uH75MIoF2KtQ_1744816598
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-549979903c8so2968170e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 08:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816598; x=1745421398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAiRJ+rVIwdO2WdbVlHtwPy5PkHyBBI5D1qW/1GoN3k=;
        b=i3zkIeW2N4TaAFc5eb9MqMvyQiiaCUIASI0xOzgEHMAnaUU5ZnjBAvkpW494lJFwBr
         u1/FcK6MjICud40vLSo6IrbFcYVX8C+5xP5Eb1PTtj0DQ3auHF9fmo22z1lo0ed2lQnl
         AyI3q+65Vre0+9gXLSLRRW+UCYNhH/HzVFqNQ09X0G/n52KZaGw4UO6hDs7FEK1CPpDD
         6qCRAf4eQ6lmkZxTyg7h7qqvGUU4OhMiFwY27IzJev3SwE5zdeCdGCnpVJHprV2RZdTF
         52MgeCfQ3o2f+brHz2SDOsNuzHusrWh35jmKYNUAtrIiCXMf3Fc+hpgACSMgZcaE8WMq
         LxEg==
X-Forwarded-Encrypted: i=1; AJvYcCU/uu5Y0wRLae6qCDsSBAvun8lJWttYEsF+5yhK51N4lDmtGLFKNrIKjy3Jrnv5Odz1vD7AgIO6f7SA3GE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaF2QWR6au7s8vMQ6r+27y7j7/mrOMYKdBBVK6wt+m2tO1+Gzv
	Ufih8Wgh1IiALcePsK3v/0SVXCry8ardnaOOTLmRd/Iwlu0wTESx1vxZxdbYPIzpdtFKNdSIWA6
	z/j91eXOn6eo6QKHtYunxO0WYsXfMyWB1qKdjg2Vh2H1qX57D80uILOQ5RUtKwAguBl2UdXq05N
	jglD58H3tJDIcUwGiWxqy4flKYRskbg4cuKE7e
X-Gm-Gg: ASbGncsYymbT4qwqSg1kbJtsOgdDGe8WeG3YLIGWTWxmTNvWVTkqEIMRAFMvqm1NLD2
	Qt+hY9nvN+AYVE9fHzOfQYegwbWBY/0Ow6EUwu8O0PHtvCf1nEg6CMN3DVMQFBEUlKlCrmA==
X-Received: by 2002:a05:6512:2c03:b0:54d:6624:7b42 with SMTP id 2adb3069b0e04-54d66247e48mr576345e87.57.1744816598425;
        Wed, 16 Apr 2025 08:16:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3ayFwaEzggSbeRHl9gpANOVjLepAYl8lkVhaugJiLlYMw8LXYokNbv5SoL6Uo9DDIWbwEIuBJv6ZyCN3swbs=
X-Received: by 2002:a05:6512:2c03:b0:54d:6624:7b42 with SMTP id
 2adb3069b0e04-54d66247e48mr576331e87.57.1744816597889; Wed, 16 Apr 2025
 08:16:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414131053.18499-1-vdronov@redhat.com> <CALrw=nHS9UnMMwXfYo_6goDi==DD5feeemxqAXXAWvA0yOi_cw@mail.gmail.com>
In-Reply-To: <CALrw=nHS9UnMMwXfYo_6goDi==DD5feeemxqAXXAWvA0yOi_cw@mail.gmail.com>
From: Vladis Dronov <vdronov@redhat.com>
Date: Wed, 16 Apr 2025 17:16:26 +0200
X-Gm-Features: ATxdqUGA6_I76BbKTO7kxmlu0Z96pk8FPseQLZOKSHJWvthQOiM4lc5IlSEWACA
Message-ID: <CAMusb+SHmr49Kv+3NwsKKC_di=uOM6svisTEVm7LomGTBFr5OA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecdsa - explicitly zeroize pub_key
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 5:53=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
>
> Hi,
>
> On Mon, Apr 14, 2025 at 3:11=E2=80=AFPM Vladis Dronov <vdronov@redhat.com=
> wrote:
> >
> > The FIPS standard, as a part of the Sensitive Security Parameter area,
> > requires the FIPS module to provide methods to zeroise all the unprotec=
ted
> > SSP (Security Sensitive Parameters), i.e. both the CSP (Critical Securi=
ty
> > Parameters), and the PSP (Public Security Parameters):
> >
> >     A module shall provide methods to zeroise all unprotected SSPs and =
key
> >     components within the module.
> >
> > This requirement is mentioned in the section AS09.28 "Sensitive securit=
y
> > parameter zeroisation =E2=80=93 Levels 1, 2, 3, and 4" of FIPS 140-3 / =
ISO 19790.
> > This is required for the FIPS certification. Thus, add a public key
> > zeroization to ecdsa_ecc_ctx_deinit().
> >
> > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> > ---
> >  crypto/ecdsa.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> > index 117526d15dde..e7f58ad5ac76 100644
> > --- a/crypto/ecdsa.c
> > +++ b/crypto/ecdsa.c
> > @@ -96,10 +96,12 @@ static int ecdsa_ecc_ctx_init(struct ecc_ctx *ctx, =
unsigned int curve_id)
> >         return 0;
> >  }
> >
> > -
> >  static void ecdsa_ecc_ctx_deinit(struct ecc_ctx *ctx)
> >  {
> >         ctx->pub_key_set =3D false;
> > +
> > +       memzero_explicit(ctx->x, sizeof(ctx->x));
> > +       memzero_explicit(ctx->y, sizeof(ctx->y));
>
> Isn't this already done with crypto_destroy_tfm()? Or am I missing someth=
ing?
>
> Ignat

Thank you for your input, Ignat, most appreciated.
Indeed, the memory for ecc_ctx is cleared with kfree_sensitive()
in crypto_destroy_tfm(), you are right. And people at FIPS LAB
seem to be okay with that (for now).

So, please disregard this patch, I'm sorry for the noise.

Best regards,
Vladis

>
> >  }
> >
> >  static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
> > --
> > 2.49.0
> >
>

