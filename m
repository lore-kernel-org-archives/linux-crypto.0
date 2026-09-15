Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAE144E05B
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789503358; cv=pass; b=PLvmsqW4ZFehpXtgz5xaaOtR2mD0Fd52aOOAB2Omz0lFmk9YISSFi8shsoc9ywMJ7mR3J3K+jCZ4JhAim7Vq6o+zb7L/ILqPWtGkV8/Ww2JL9VpGPXbPEbGCxNgBFU5QN61vsNDU4Ce5xl4b/WBo95oS4LVCYMmJ1RDwqqOhexk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789503358; c=relaxed/simple;
	bh=tIo4II1d9ForEs6449DJ6tBTc4LuD50qTRo8+K+5e2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WuR/nnHQmcCljo3v7lhEVg36Kgr/q0imeNK0kDVKoAhUT9utxF6vWwoD/Al1D844IgtQHEEra6vUFI7P3OX0kGsYp6bD+abO4gGF2UPaGEFQsSCZje9bU9ougP6N5NeCviJb5RlPx+07rUNuhv7bLwil7jLb/DRbz5N/3wSoF5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMFK/xdh; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMFK/xdh"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25bf832368so3624166b.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 13:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789503350; cv=none;
        d=google.com; s=arc-20260327;
        b=ooVKOFGJskkWkNmRtXx9uYvRPmzv6JKORvtLwVDE9Ar0fNRiwWANhh0+axNl1YPsTf
         3NdRf6fZTcCweqRpDtXbjhapiaD2EsZ2IKRavJMpXS3zIXAEDasW/RiVUccqk/yNCI+f
         fy8jUc8H2d000i4YzmUS/FPCiIgpMrMcDP4G8T5nhW39YMWtBTyJu/3shAuzlB+xcBsv
         0H1kT7AmZ326YB9Js5dFh0ql8rbKX86TfMJKcvBecmJgj7j0hC+B3u834eNRoagXp112
         i9nl1byb9bRzYNHmbLbvV2dgSD/4o+J7e/IXjG/UPHqjy3aYr/IWdLnPQk9u4XkKM1XC
         0q8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EMk9jyFcs1z/vsVIU7tgrrT3h1+jFXhNZlrTV/0Lq28=;
        fh=GDjv41AQkDrC3SQWr3dbfi+96OAM1lezN9isdmCbTGw=;
        b=kbYQ+WGepfZcle0VHu0sH7hKzmXJl83wJniUfvCo7l3fNmbpoppjjeuH90eLCyRw7i
         D0ITt5T/fr7kV3mcTz6TPhv5iSvDCf6BsO9DUMhvW3xXmOvqt7oPFpz2NAjRnXe3hPq2
         ZprcYdO3pC7hF4HfyHWiHBJnAbex+MxrgdXoMqhBCpYQseH7Wy8SJ6rTWqfG2O9OBZXp
         ftmyND0U9DsYve9FBHzFJ+Z0qZEeWAaG2M3WJmQy1rHAOtjrI9JbF5viAJ/Ll5Y3QicV
         IJ8s8TXKEYMw6SxKKvGaVr67fVaUmCKtt+s6BrTQqm1Ge8rVdfbm/bJ0rU6T2kquZn/I
         wZMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789503350; x=1790108150; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EMk9jyFcs1z/vsVIU7tgrrT3h1+jFXhNZlrTV/0Lq28=;
        b=kMFK/xdhuVPYWFau0SVnAOI0dP1+C/ya4QEGqAnK+/WVuj4My0qAoQvVI+BKoY1ZwI
         NNABdWF+rnRpE/BFKhqhZ/72374Gy9eqKQpfsepDHKgixJYqiLHKeF7uqSuwRIr+AFw7
         8JTPpKKSxCJQVvxWu8uSG9skZAQ2M3M9ggXG2ixYT19P0Ks5ehXSvpBZtpa4O59JsnUE
         AEmjUlBrtixnd++kPKKOnZG0n0ogjzJEPniFUASQttiJrfpK73sW0IsgwVTbUlIwDL83
         B8pt1JK0UJ20OQjry6Fy4j7Drm8AoJ0UIWSLyNEBfmWDCEDeQ0whVitGHVB5nO2aKI8B
         vaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789503350; x=1790108150;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EMk9jyFcs1z/vsVIU7tgrrT3h1+jFXhNZlrTV/0Lq28=;
        b=EsEK7gArBLo8tDG9hTzll5h/Cx1X7QHY+OL/uGsmHO3zDwHFCufoSJwqhrT/HaMN9v
         5tylpFb2plWaA91efoQxo2val2/nez2WaHGLHE05a5waP7JEqnPu9lbqlX7yECtHJl7b
         fjl6AFwJC80b1yTUumfkXhiYez8d5BhFl4p72KTPFxo8+SdIiDPaBW0DiGpjTmYzwE7H
         lnaQYbz76oF893gRy9MRdVH+3tQlNdCquehNN7zKFyc/fSd7aqwsxYZrsyAAhez6BO+m
         F3XjBAJUZ4As8t5DoZ0cRsx6MeK0pnbgYbI0LqKRbIOvfEm4OPzifGuVXBcgRlCo5IoI
         0mmw==
X-Forwarded-Encrypted: i=1; AKwUvBw3hzqpL/hR1X0ckazXcyt6NC+vvW5XZtjn1wu8Nhi0si8NV2edNn75+sjsbkkgDMJmH/GoFfw2gZR9jo0=@vger.kernel.org
X-Gm-Message-State: AFuF++kEubJLCPSsViDW7ty4amkcczJ2tQHCqvleCtCjp76orDohJxsk
	C4whbdCC+rytOgepnpxV43PGbr7tkLHdkvV9GYFfjOyCMaShDYi2jKBJZdfjVtmAwY4KPVrxRcQ
	iG8LZ2X4gjozQm+zhnAkSfp34CGgJIKQ=
X-Gm-Gg: AYBFou12MU5LItj3AjR8z/FNzGixzw3RUcc8qj8QtqtHqtvWWDVylVZ+UpQW0adBZIo
	E0+hGmwR3B4gm6uvFkwXaFqG25HTqsdWZp8BnjX94EJuJJp8Mzmf64pONCllZvZ5WORdY2VzuWb
	Cot7ejd6pd4+kTnrrj8aZBMMfDRwPTwk4M4V1taKtXvlGBaqGqgjaYVFZfQBfmMK4YsISMPLATG
	ZB8RjoPFsXKKfKdzkpc3a2iK0Nb1o6oyiEO2qLL52YO3qOsYTUeGMhbKIIZFeW8qSfYH9wxldzk
	gqv/xAb2jYZa660WEznIuuvPpfFraaMa0EEhN1DWu+xvsDy+3VfVPx8=
X-Received: by 2002:a17:907:94c1:b0:c21:7bf1:2c88 with SMTP id
 a640c23a62f3a-c29b86f6a30mr608631966b.2.1789503349926; Tue, 15 Sep 2026
 13:15:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
 <20260911-ti-dra7-omap-sham-fix-v1-2-c430f01b4e13@gmail.com> <20260911082406.05e2a212@kemnade.info>
In-Reply-To: <20260911082406.05e2a212@kemnade.info>
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Date: Wed, 16 Sep 2026 01:45:37 +0530
X-Gm-Features: AcwNN1WHlqVruIX69u_0BS3IFoNFccfPURE_yLQbZJm0y0g2wehRCyWKILewqPs
Message-ID: <CAOWyW_5s++Sz6EFEX+zGTca_-xZvK29B88UzoEzsaP+QavF6CA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: crypto: ti,omap-sham: Add OMAP3
 compatible and deprecate ti,hwmods
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 11:54=E2=80=AFAM Andreas Kemnade <andreas@kemnade.i=
nfo> wrote:
>
> On Fri, 11 Sep 2026 03:41:58 +0530
> Bhargav Joshi <j.bhargav.u@gmail.com> wrote:
>
> > The OMAP SHAM driver supports OMAP3 SoCs, and "ti,omap3-sham" is
> > actively used in existing dts. However, it was previously missing from
> > binding. Add "ti,omap3-sham" to the list of valid compatibles.
> >
> > The legacy "ti,hwmods" property is no longer needed as TI OMAP mirgrate=
d
> > to "ti-sysc". Mark it as deprecated and remove it from the required
> > properties.
> >
> > Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
>
> What about also removing ti,hwmods usage while you are deprecating it?

Omap 4, 5 and dra7 already use ti,sysc wrapper and don't actually use ti,hw=
mods.
but legacy omap 2 and 3 still use ti,hwmods but I don't have hardware
to test changes.

Since omap 4,5 etc don't use it,hwmods keeping it in required causes warnin=
gs,
Deprecating it and removing it from "required" fixes the warnings for
modern SoCs without
breaking the legacy ones.

Best Regards,
Bhargav

>
> Regards,
> Andreas
> > ---
> >  Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml=
 b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> > index d69b50228009..3ef05890e13a 100644
> > --- a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> > @@ -13,6 +13,7 @@ properties:
> >    compatible:
> >      enum:
> >        - ti,omap2-sham
> > +      - ti,omap3-sham
> >        - ti,omap4-sham
> >        - ti,omap5-sham
> >
> > @@ -32,6 +33,7 @@ properties:
> >      description: Name of the hwmod associated with the SHAM module
> >      $ref: /schemas/types.yaml#/definitions/string
> >      enum: [sham]
> > +    deprecated: true
> >
> >  dependencies:
> >    dmas: [dma-names]
> > @@ -40,7 +42,6 @@ additionalProperties: false
> >
> >  required:
> >    - compatible
> > -  - ti,hwmods
> >    - reg
> >    - interrupts
> >
> >
>
