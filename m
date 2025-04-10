Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6BF20126A;
	Thu, 10 Apr 2025 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744267333; cv=none; b=lGCi0DmIWPFVJaEzREF+IUyiiBv5rIBY/1ng5W8G/W64gBXgvM3IgPI4zvDvz/tg5QpnIxQAuhGOJi5JZGhmHZpU6m4oYGRjaKGjmyMTGqIDq8at5xbtNf/RWGJ4NOm2ncSFfMQJaPgAFBNpu5Ixc8+rvH62cfrRPF1psUftr/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744267333; c=relaxed/simple;
	bh=4P2dDT+RK6eI5rXKKYraRs23FNMILL3o1cfAX/g96lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIgvjEu4pyQMpcptuRyIla6LlQjNtjwCUr8+vEUqLhpERo770wW80ZpskxUPlM8X1+y9yn5dihnZkg6icmbjw4ST3MrDSe6aouNYcCKu3pd2fb2M54nrqYxdoliGXZpW4ECIsj/3cUJsQiZ07Ubd09IepvRNF7/Kh7I0EmLxjFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iuOVxYki; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuOVxYki"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4394a823036so4508495e9.0;
        Wed, 09 Apr 2025 23:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744267329; x=1744872129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgi++iF3Fg7nMYQ18+rntnQ648+qoZ6drbTj0Fi+Lc0=;
        b=iuOVxYkiwRQGcF3XTBoddIwP4rQUkVs4VX3cR2MyDebr9tHebVYjRkA4HQxdUIpbTV
         nWJnm08HZMJ5FMGYzKRa9T3bbV6r1XeFZIMRDMmrAgVQ/dUTU2YBgHq4DCAX8Z2GnIs+
         6IGEqs4hMRv/BSvSPGuyWEO2tzppPDniuLzaMqGJxpoOon+hQerRvOEW9FTaYH6tRY+O
         3fVLLY9sfK+/Fiahm6lIZpiEXwwVuAFAlIQKAuLgQOccUywsbJ9HNJE2NdYK3nCT7d0J
         Q+4CzbOrBVgTXPn/GVHsI6UcW69NsUMU+GLY8vuZcZXDdxX+ka/4j+LeuWnE5FIGJmzi
         9gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744267329; x=1744872129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgi++iF3Fg7nMYQ18+rntnQ648+qoZ6drbTj0Fi+Lc0=;
        b=rHDXHxvhm4mwjD+QR0J2Dfiek8KqVXtRZNKUVXuAPhVi5yDWzgPOQNLEPB5FqxMVp5
         m9CIHw8AYEN7+Fuwy1Vjm+nod9G45hmsnZb0XCcdbxluVb8nPfgWekelCsvQR6fJBRy4
         tSJNI+HgyAyvS6c4mmL4ZQMEcoWdSD8tIl7HH1y1+cGJuVxGRbVUuue2Iqj5oZHVXGvm
         RNXC84AIke3KktMPrDDGciJY4TfCYo8zsY9msm7SL591NY40kjhNtH7ravnMq/EeTZC5
         VQC/utHhx6Qjkj/zzo1qEQf1ugAW6jhWTbpn4aMQN8lP3Y2OjvEM2vi1ttARAEflMN+q
         1iaw==
X-Forwarded-Encrypted: i=1; AJvYcCUMPTV8q4Du6e3wEnGHPuAo8Lp96RQt90I918j8Q4A6o1KDys0q2+t9poRvh+ZX0sVc41oMgsk/J4D3mG8=@vger.kernel.org, AJvYcCUyafsp+38a4UdgPDPmGsI+ikr+7lkedwkZIMAVEg1XlqPioUXhPTxEaRZDc0VijstbUZqyswqqHmUiFTny@vger.kernel.org
X-Gm-Message-State: AOJu0YyR+Z6yyUiYA3uO89HH/9paCyJ69FTJQlZtuwZENbyYCOprx/O3
	ITmcPdv/2chMOl9bJsPb0SiS0nDp19s9UyqBq+PgTnSZ2uBqYn+3
X-Gm-Gg: ASbGncsSRYj+ZQ6CbUfSGSavrYNQN+wI0vYvh0tYiQplhcbmNTg4jjNlntdkrPJqfAJ
	T6VrloRggly0dpXBNR+lUcPdxdZGGq+KJOHXn4e+YYvG613djNkl4Q3IQHSatN5NWriBD8arH2o
	4tO+yBKG1PEW4OwOSshHzNKmEE2DSOPYcFiUdQ+hdnJyKbCeV5ZPcwvniwJXYMqDnPM8rxUeJsY
	Bdl2naQS0y2z+wi07ebkJmWAUcGn4x/cctUFvIY34QdHkF5vO3325Q3EH2aBz9oPGgopabZjf2L
	joWXl8vyx4qzW+0p5Z0psisRMbGa3JA+AIzX8ySmdtuummIGl4ZtA1wZBRpvsnU9XynydhgtTZH
	dLTOksabgocWisSIE
X-Google-Smtp-Source: AGHT+IE3nWAVRE6ucb7+Uzjsl4IRZ7guyI39ocIlY0+wxgPZqYZO8ZgYVGT3E9SnVfCkjxK0FKGnEg==
X-Received: by 2002:a05:600c:1909:b0:43b:c0fa:f9cd with SMTP id 5b1f17b1804b1-43f2d798f09mr12514035e9.7.1744267328446;
        Wed, 09 Apr 2025 23:42:08 -0700 (PDT)
Received: from jernej-laptop.localnet (86-58-6-171.dynamic.telemach.net. [86.58.6.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f233a273fsm39895635e9.9.2025.04.09.23.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 23:42:08 -0700 (PDT)
From: Jernej =?UTF-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: Markus Elfring <Markus.Elfring@web.de>,
 Andre Przywara <andre.przywara@arm.com>
Cc: linux-sunxi@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Chen-Yu Tsai <wens@csie.org>,
 Corentin Labbe <clabbe.montjoie@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
 Samuel Holland <samuel@sholland.org>, LKML <linux-kernel@vger.kernel.org>,
 Julia Lawall <julia.lawall@inria.fr>
Subject:
 Re: [PATCH] crypto: sun8i-ce-hash - Refine exception handling in
 sun8i_ce_hash_run()
Date: Thu, 10 Apr 2025 08:42:05 +0200
Message-ID: <2774682.mvXUDI8C0e@jernej-laptop>
In-Reply-To: <20250409133610.59d42bec@donnerap.manchester.arm.com>
References:
 <3727de04-7993-4b81-80c0-adb40b847307@web.de>
 <20250409133610.59d42bec@donnerap.manchester.arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Dne sreda, 9. april 2025 ob 14:36:10 Srednjeevropski poletni =C4=8Das je An=
dre Przywara napisal(a):
> On Wed, 9 Apr 2025 13:43:39 +0200
> Markus Elfring <Markus.Elfring@web.de> wrote:
>=20
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Wed, 9 Apr 2025 13:26:55 +0200
> >=20
> > Two if branches contained duplicate source code.
> > Thus avoid the specification of repeated error code assignments by using
> > additional labels instead.
>=20
> Is that really useful? I think the current code reads easier, with the
> usual pattern of setting the error code and the goto'ing out.
> Now there is one rather opaque label it goes to, so a reader doesn't see
> the error code immediately. And it really just saves one line per case
> here. Plus the added danger that future changes might break this again.
>=20
> And then there is the oddity that it jumps *into* an "if" branch, which
> looks odd, I think typically we goto the end of the function, outside of
> any other statements.

I'm not a fan of this patch either. As Andre said, current code is easier to
read and such optimizations are more for compiler to make than us.

Best regards,
Jernej

>=20
> Cheers,
> Andre
>=20
> > This issue was transformed by using the Coccinelle software.
> >=20
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/driver=
s/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > index ba13fb75c05d..7d31e190bb6a 100644
> > --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > @@ -399,14 +399,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engin=
e, void *breq)
> >  	}
> >  	if (len > 0) {
> >  		dev_err(ce->dev, "remaining len %d\n", len);
> > -		err =3D -EINVAL;
> > -		goto err_unmap_src;
> > +		goto e_inval_src;
> >  	}
> >  	addr_res =3D dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEV=
ICE);
> >  	cet->t_dst[0].addr =3D desc_addr_val_le32(ce, addr_res);
> >  	cet->t_dst[0].len =3D cpu_to_le32(digestsize / 4);
> >  	if (dma_mapping_error(ce->dev, addr_res)) {
> >  		dev_err(ce->dev, "DMA map dest\n");
> > +e_inval_src:
> >  		err =3D -EINVAL;
> >  		goto err_unmap_src;
> >  	}
> > @@ -428,16 +428,15 @@ int sun8i_ce_hash_run(struct crypto_engine *engin=
e, void *breq)
> >  		j =3D hash_pad(bf, 2 * bs, j, byte_count, false, bs);
> >  		break;
> >  	}
> > -	if (!j) {
> > -		err =3D -EINVAL;
> > -		goto err_unmap_result;
> > -	}
> > +	if (!j)
> > +		goto e_inval_result;
> >=20
> >  	addr_pad =3D dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
> >  	cet->t_src[i].addr =3D desc_addr_val_le32(ce, addr_pad);
> >  	cet->t_src[i].len =3D cpu_to_le32(j);
> >  	if (dma_mapping_error(ce->dev, addr_pad)) {
> >  		dev_err(ce->dev, "DMA error on padding SG\n");
> > +e_inval_result:
> >  		err =3D -EINVAL;
> >  		goto err_unmap_result;
> >  	}
> > --
> > 2.49.0
> >=20
>=20
>=20




