Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAC52620E5
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 09:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760691652; cv=none; b=fRfWdXDjnR4i35wMZzigIrkst4kZP/4aZXNsKuraGyQy1SlqR29edv5RCOAmYM1YmKJkJDANY/5nNNJUUvSrkI/E/Oskm6c2k2GqKAmO8hqS+fm/e7yM3eR0TRewyqQLmwGR/TWrJWMIUuQD50DPc4rofpjX70TQIUTRbMg4hG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760691652; c=relaxed/simple;
	bh=o2unYdbluW1Z+y1R5k5exjJD7xPDhjFMTxohbYaU7P8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OfEDJK+0RZB17ocptKbrvSMyFbmuqjq5eDsn5Jc+kOemDrhisZ1qyfO2/Wmcqvs+lJdud2Yvg6Z4qVO4Pkai6T5ASAIWEepUvurY+JvInV0JuzrswbBVUtHPp4VBKldRkpxiaNP/stO6T6xJStoImiQuexO/OKWEus2naAddkjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=CkdQjMkM; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="CkdQjMkM"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78356c816fdso17788027b3.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 02:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1760691650; x=1761296450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwqZleTIDiUaAY72cnewgW3ek2rn+IL2kLV7EXZgYnA=;
        b=CkdQjMkMBG99UCbfQ0O4MgJZ7ADpAaJzueVRDhxaxyG2gUt3LixzuMLTJnufr6jCck
         OsfNN/pcZgS60qsxoCQXh210uVcJ2+fgJ6xMfYgn/7QSQsPMDLfsAm25nyh0ld9RugKV
         g//aCZ3TE+e1ZoRcx9DfcP4AhrQfbXGtnhV+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760691650; x=1761296450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwqZleTIDiUaAY72cnewgW3ek2rn+IL2kLV7EXZgYnA=;
        b=WPUC048L63ffTgXdD2Az7OIteiNUUSVyRsmrvjHVGJcppxGmARnYG8kL7UWBBntExl
         zScR+i7R7kJwdlchr6kxgakjP7ISqGwpDpWTW2agqeiIhvGvHzx4McVjoqTKvUVJS2w2
         kmIehNLY2AVUS7nxEMJFcBjuA0pa0tsoSyL0RznCoiYehFhZJ4rE4JlRPXB8ICtY676F
         h5S8UJbJ7cak53x0oOnA8HjCnVbLNOG7Ul4ntlVgmnrZJTS6ZQPC2CqysQsc1BsBd+s6
         9MujjM1DTaDm3K3T3hduSct+LpI6xGmf6gH7xX6AkxM1EAz4NClTqJ3oS1qL43rW5OcC
         FfhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsoXBXAsTIl9AylImfIlDRAVHobp1SSwzA3ACyzo1AM4hQ9e/rk90pn38s1wJSiqGQ5mUM/kJTYBSIQTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTlfmvibqNAB20MgqcdxOI7xZZI8X8R+dNc9Hu3NB1sCHQN2P6
	h9uNxhgLVAChk7RVboXYCPN2wkVwMFpVzItzartB1UVx9y96Jn8WMYtZXZ7mVdcz4nIktz6llXJ
	EI95XC+MFA/K5A2kdnkoKhoO52dXInhir1XOkvaBLJw==
X-Gm-Gg: ASbGncv1oEbri9UYij5xg0xxOwAgoNGeFcO3vynu9VT5c6SE09NJzHMOfgX9rPRTWIK
	3bQZSkfxOhwA28Sfwvz8q8VhK9GGWTSvrWdZRSrg99Z6Chixfjlgbbcs+p/+cHB+u16Q0asIfKU
	LDR7/1PcjGXd85qLju0O2w+4XZBLTuloDXzNMyaXuoVY8RwotiyZHC6kdh9Pk1cNCsQAS4uYaqF
	ktfwGzfBl9mA+bku2Ow2L7pEZCiY9q/BhIjR+yjX8I7y2rAk8XT3GdFyV4MoIhKOHOVUO3hV4v7
	+8qdhuTVxmnMIehTrJc=
X-Google-Smtp-Source: AGHT+IE5Yi8fhsEehPxy5GJvNImSjw5otDpaKTAtoCLqiAZtdjIs8czq9CS+B6SwkI41+mx3O4jIWn9BUXmt32pT6+M=
X-Received: by 2002:a05:690e:1401:b0:63e:1e08:daa8 with SMTP id
 956f58d0204a3-63e1e08e659mr637758d50.62.1760691650124; Fri, 17 Oct 2025
 02:00:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com> <fe4d7cd9-0566-4d1b-97c0-91cc1f952077@web.de>
In-Reply-To: <fe4d7cd9-0566-4d1b-97c0-91cc1f952077@web.de>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 17 Oct 2025 14:30:39 +0530
X-Gm-Features: AS18NWCF7ilfnimqJ0juzX5edKoNldB4hCt5XQCmgPU4bAn0tksOTOoAPtkyp78
Message-ID: <CALxtO0m1R0kf5Am+oEPAgqommQph9zs6+xfTM0GzGHV+YEXT3Q@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>, 
	Manjunath Hadli <manjunath.hadli@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Aditya Kulkarni <adityak@vayavyalabs.com>, 
	Conor Dooley <conor+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, T Pratham <t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,
   My comments are embedded below.

Warm regards,
PK

On Fri, Oct 17, 2025 at 12:13=E2=80=AFAM Markus Elfring <Markus.Elfring@web=
.de> wrote:
>
> =E2=80=A6
> > +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> > @@ -0,0 +1,980 @@
> =E2=80=A6
> > +static int do_shash(struct device *dev, unsigned char *name,
> =E2=80=A6
> > +{
> =E2=80=A6
> > +     sdesc =3D kmalloc(size, GFP_KERNEL);
> > +     if (!sdesc) {
> > +             rc =3D -ENOMEM;
> > +             goto do_shash_err;
> > +     }
> =E2=80=A6
> > +do_shash_err:
> > +     crypto_free_shash(hash);
> > +     kfree(sdesc);
> > +
> > +     return rc;
> > +}
> =E2=80=A6
>
> * You may use an additional label for better exception handling.
PK: Ack, I will go with an additional label.

>
>   Or
>
> * Would you like to benefit more from the attribute =E2=80=9C__free(kfree=
)=E2=80=9D?
>   https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/slab.h#L4=
76
>
>
> =E2=80=A6
> > +/* Crypto engine hash operation */
> > +static int spacc_hash_do_one_request(struct crypto_engine *engine, voi=
d *areq)
> > +{
> =E2=80=A6
> > +     tctx->tmp_sgl =3D kmalloc(sizeof(*tctx->tmp_sgl) * 2, GFP_KERNEL)=
;
> > +
> > +     if (!tctx->tmp_sgl)
>
> * Please omit a blank line between such statements.
PK: Ack, will do the cleanup in code.
>
> * Can a kmalloc_array() call be helpful here?
PK: Ack, added
>
>
> =E2=80=A6
> > +                     kfree(tctx->tmp_sgl);
> > +                     tctx->tmp_sgl =3D NULL;
> > +                     local_bh_disable();
> > +                     crypto_finalize_hash_request(engine, req, rc);
> > +                     local_bh_enable();
> > +                     return 0;
> > +             }
> =E2=80=A6
>
> Please avoid duplicate source code in such a function implementation.
PK:Sure, will fix that

>
> Regards,
> Markus
