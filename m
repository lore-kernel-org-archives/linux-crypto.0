Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044A326951
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 22:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021002; cv=pass; b=NBmPOO1KaUpKnfj1HZqvb3z0kzTm3cCu/pXC2uANrAi2fYekzARCBVShIFKJndIcwiMda/nsjxFLx3eZWXrMmyZtWz7EF3EYujCioamhr3V19/TiHb3gbtMMA1t8wz9GjKIA3slSXt1GowxoD1hZc2BTSv+j1OmnMCkqBR1EOxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021002; c=relaxed/simple;
	bh=iIkKJXiKA5O+0rk8H/q91t9S2KnW+ZRKSQpznvFiTeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aKjy5kFO0g55hlTICTAQJotcG1vztyj9YNAsC9StF7iP40yxaeOB7D3nCJxpCjcSsyD7YDY6pBOtJkb6IGWi+RfsEjQeeG6i16gFCdVvNU8yNq9nu0G/ivqi1bP1P+BLGZ/qGY1ucmXhvA5wfYTnvaWCH6+vSEGdwEDLtNFaun4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTtqZlZc; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTtqZlZc"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-393925cb1baso36621901fa.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 15:43:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778020999; cv=none;
        d=google.com; s=arc-20240605;
        b=PE8GnQImDIgk6vtzw0/9ScmbA3tSr24ly6lrZCK7+gx9sAn0dCh/rceRRZlrLsNqMi
         WVuFpAqEhGgMYXFNa/LxeAv/GSNTKxpiOL7tG6dr8bh3O6ldw5oRXINPJUuAbC3WxKAB
         nIevG0bkPR5ySw8XPoyMRH5AGRtUlM94MSDqJU6Jjtza7VH1kvujTnd3Op6r3IdlBuBF
         iXrZM/+4gJYfhUVeUhO8LuK3M5V4AxFumQIqPuWig1lYeZNtSnI9H/GXY3623rN+OO+q
         ImBLqPN2D7Y2D2Jx7U6g5C5+SXo8Kjs14FyHyGQRMGn1VlHOFkM+s0uxJ4S5yJWJmHaZ
         AUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NyngZeINrYkAsC1U6D4ztqT6mI0eVivk/jzOO+xk58w=;
        fh=G5ElsHv0BfZJ3U54vs4mVsTr9x2LTF8X7LxjOwmAnKo=;
        b=fzPxGgo6IOf2DGbxSkVsq1XTAQ966XvL0y/5YyKVNnfowRhTZNoNr18yE1aOHfJX3y
         2D7jOYWqmEJJWLr/0zxbNBu3Kp3bgTSo27GV1/8Xaz/aOjFOSLkgGDO2VMb+bUm3a29V
         rVvS1CuAKMsuD+mi33vzCbe90KEnGm+aHUaxN3aStDyu2qb18sp7I4LP+K86d3I1D8Qo
         ITPUViOraQx+kGzyGDJB4bGisNUu+lAdQHrUlI+OMQp4Z1t5bjpSTu6ik76ah8lFOASt
         EVgyJUfvUi0uztwpbVHAJg/0rlPSbmBia7Ikbte2JVtBEDNjImRhywmdjDxhjzXvgVk2
         77FA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778020999; x=1778625799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyngZeINrYkAsC1U6D4ztqT6mI0eVivk/jzOO+xk58w=;
        b=gTtqZlZcNQ9y2kuRw4WBAO1uuW3/YUYFvyNDeKV2CH8pue9EYajww+2suW9dnlIODg
         t+sB2GVx+4ysjvQe11Ldci0uJqW/C4MlIqCI9G3v5eFudUGr+Yaiul6F9Tu4OAPUKLTs
         auKhbw7n/QrO/7AeCyU54M/6LTea7XE1OG2GSHrsD7tZz8jn659Abv1CosLGDAt+FdHx
         e0z3YQ9oAjLU3nZECEOyWDu1HW7+cn+pnHmSIpodyZt4AnACLVOV5N4eLRaWgqHgxxrk
         2L7DUsfCkrDv6rCsmsLqxrybBE0t2pc0j8jrSZMrwRJ4/Ljjq3eRpCasndpjtao2rllL
         at/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778020999; x=1778625799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NyngZeINrYkAsC1U6D4ztqT6mI0eVivk/jzOO+xk58w=;
        b=U+dn/RlQNe0kiuyT3jT4UTn3+DtqZILO/2jmrexEBYUEJFLZfuq5VVeLmh/S87UPdc
         HIO81bTLsyj6O/JpmCPdRHZTLZ3FDBykGAyxSp3C4Mc5RgvZo5Zg42iMvvCrSedPmXTo
         nXPpTnjw1k5UkUVJUlrOJU8y4wa182YLvHZOd10YsoPM4IJjhXWOC26Z4wRF2dToFUMJ
         ZimGLyVKZRGXVtdfmPGDLi7okykT2dWTtfkJIKe1oSs9RI9hwxZZtAQapwcn/wQJKNk6
         r2/WF+WKAyvSkI1TUROYEHlT5AOott3MnzNXfxMKfnP3R6HSvXw+UXGLr4x5Dw/gzisx
         ppRQ==
X-Gm-Message-State: AOJu0Ywcywj+XQGbhe8IVFS7C4vAjRUOIRHbi/kkTHTRkX1bp/PU5Njq
	i3HtxrhmJ92R7+C7UuHxZYc2TZ6+Yw4gvh9lNiF0Ytoi6nK6y9XE6SbMv6IGgr3e+d3Qg+Hsg0D
	c9+EFe2ztTkTBRxrVwdMbvkr8Kjlkw+DzOvFa
X-Gm-Gg: AeBDievB4Vrm03kuUnNpCNrFmQ2RpsmPum3Sa9aqtUZ15vhvtJzH5YJsDq+VKgB/zyt
	tYtpdSSqCXvVRJN28VDCQyFenZ/CeHDtbyUSE+6wnKiAsNCIqJrGAsuATl2WL+tsjF61p6oekfD
	suBe6t+bG452YfQiac3H8b1L/1Z3Pk3cR/sj8QnCGdqKeummXzOyawu405r/Kw85CBOZ8rxMx0l
	+hYDFxXx5hFYeY2AMu6qtbuRKwVmmBlHnImZtH63+Yf0A5CwwvTluwKsXTD6vLHrFlZ8RysUC6o
	5QqnMeufiPkY86XvIC9t/W3bpCCX12ZB1vWjgNETB7lNITuYEO5odrkYxakx6N3hAl195LwAYL9
	eErwYoTyjBS7A2M9CSEuBm/YNZAxDNSzhnf4u+tC2S2wewtBUQR1rXT7X3zc3TLJS0rk2SNNfQ6
	SF4Ys=
X-Received: by 2002:a05:6512:3a93:b0:5a4:e6:8fb4 with SMTP id
 2adb3069b0e04-5a887ae2861mr210106e87.14.1778020998499; Tue, 05 May 2026
 15:43:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260505073705.8810-1-rosenp@gmail.com> <afmo6sJlqbjCWd9A@gondor.apana.org.au>
In-Reply-To: <afmo6sJlqbjCWd9A@gondor.apana.org.au>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 5 May 2026 15:43:06 -0700
X-Gm-Features: AVHnY4Ju2pQzmdQ5_EYMwW3Rvst_VPzsAJVY8Rv5tf7BEwqrm-X72SNtp8pvaZY
Message-ID: <CAKxU2N-T0t0K9Bx6UYm6XUxBUMGys6_avcPH3aBjc2Vh2JFe7Q@mail.gmail.com>
Subject: Re: [PATCHv2] talitos: allocate channels with main struct
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 1:23=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Tue, May 05, 2026 at 12:37:05AM -0700, Rosen Penev wrote:
> > Use a flexible array member to combine allocations.
> >
> > Add __counted_by for extra runtime analysis.
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  v2: add check for of_property_read_u32
> >  drivers/crypto/talitos.c | 19 +++++++------------
> >  drivers/crypto/talitos.h |  5 +++--
> >  2 files changed, 10 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> > index bc61d0fe3514..e1f009684216 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -3409,14 +3409,20 @@ static int talitos_probe(struct platform_device=
 *ofdev)
> >       struct device *dev =3D &ofdev->dev;
> >       struct device_node *np =3D ofdev->dev.of_node;
> >       struct talitos_private *priv;
> > +     unsigned int num_channels;
> >       int i, err;
> >       int stride;
> >       struct resource *res;
> >
> > -     priv =3D devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KE=
RNEL);
> > +     if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
> > +             num_channels =3D 0;
>
> Does this driver still work with zero channels? It should just fail
> the probe.
I looked through the dts files. All of them have this property. I'll
have the change.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
