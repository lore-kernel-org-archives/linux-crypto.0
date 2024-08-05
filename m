Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764C631
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 05:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722835385; cv=none; b=Id/wXKAYvsfTPe/doakQZiUv52jpXhHF5rfaPE+GuWoxkUuSyLEM5eP6b76HIUwhQNwkU7k0z8reXU4QfdDAOzQcowMM4nXKmLpXALf6J8cXaYh5HFCdnDF80ihEjK4X+kJRQb8R95KhcRgtfCDsEanuN7gRT5FxQ1LvuWHWozE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722835385; c=relaxed/simple;
	bh=9toEjo193JFbOMCWCwzU1N59OdbCAjE+rsJfi30mHT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+MDPXjOqbq3+vAzpvvPTFtB/4H4/hEYiKcZhGN0L5Wj3OxQek00gkWX1H0GXxKJwWO92Az1RQUwgRZVCl836DQ7aC3hgNmXonqScPKlaVHVx9S1VIloDLmjCZqnKUCQeHWm5/Qzmyq3fzR+VBxJx+rdplZV3gsJXAjUTwwiNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=iyfdfE0h; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="iyfdfE0h"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dfef5980a69so9133498276.3
        for <linux-crypto@vger.kernel.org>; Sun, 04 Aug 2024 22:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1722835383; x=1723440183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KwH9KdTM9xhlL2i/Q24CvpyqTjnKXLFgl8v2KpQU8Bw=;
        b=iyfdfE0hnT2zQl02tiNngxfa4ZO2e919pbDWQ18jHqWm6IOFe7RAj0RwVnhlHml30U
         Y+cVArMFA9WxuCZ2bIN/B31HBb9Eg+jcFDfuKNguZ1j1H/qjoMxOHc6DA+JiGfK77nXh
         vFzxlcFoMEH7iVRm9LtUdR3X4djA6GQYxpsBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722835383; x=1723440183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwH9KdTM9xhlL2i/Q24CvpyqTjnKXLFgl8v2KpQU8Bw=;
        b=iuKakyspkwzOBcBMp+nBRmWZO/xbtSwv1rKG75y87bxaupF+jev9gHJTrTo3GkoV/J
         Ntb6taajwfcm9E9hQrDX4+4gvv/tJ8T0YqDZxRkTswpU3rd6PAhGf9QPnd0ZeHiYNgs6
         wWLbpBg0mxDw7+/qT9CebNgXnXvZRn564CdzoJWuxMrpx8npGW9FKCea+uiD6N7hxKsb
         H2j6BeRxJdeP32se0WPUukMPzZwoudJPQ7Au741TuWXd0Vb+SbykVeaGEWHUv/AoaGxB
         /1fI5UP2QM8pu9U74hcLNVfR2Q2qL5XlQb5L1SQHY6XwgBt2mA3MAWQdXT0S25ltLfjO
         CqWg==
X-Gm-Message-State: AOJu0Yxf1vVtKOeiLz7HNe4REuokod2X5pahf6vNauRCQGhZk1YMtJQn
	90qMCd5t9K0QHChzyGcfB9Ttsjq0fGKpVdpxNYbHuW9UX4eQHZU6GTOkS5umThSsfbnHXSbIDJb
	G1fT+/TJBEjMSHsiYyrgb64e3diTFUO+/bogU+Q==
X-Google-Smtp-Source: AGHT+IFY+zqRFCz5bQpWauHGmrbkuU9vo47k6EQzMwj8tPmpu3NNomYZ/ia1ANpQF940hzdoMd5KvcynTf9Sl0o66bQ=
X-Received: by 2002:a25:9342:0:b0:e08:6f3d:3a41 with SMTP id
 3f1490d57ef6-e0bde21a820mr11909069276.8.1722835382702; Sun, 04 Aug 2024
 22:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
 <20240705171255.2618994-4-pavitrakumarm@vayavyalabs.com> <ZpG+m8mnbsikdM+D@gondor.apana.org.au>
In-Reply-To: <ZpG+m8mnbsikdM+D@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 5 Aug 2024 10:52:51 +0530
Message-ID: <CALxtO0nn94NoB6yGxouogFFdWe3UyMiOALL7t-MPsmTtTHBebw@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com, 
	Shweta Raikar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   I have pushed the V7 patch with the fix. Do let me know if that
suffices for the software fallback.
   Requesting a review of the same.

Warm regards,
PK


On Sat, Jul 13, 2024 at 5:09=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Jul 05, 2024 at 10:42:52PM +0530, Pavitrakumar M wrote:
> >
> > +static int spacc_hash_cra_init(struct crypto_tfm *tfm)
> > +{
> > +     const struct spacc_alg *salg =3D spacc_tfm_ahash(tfm);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_tfm_ctx(tfm);
> > +     struct spacc_priv *priv =3D NULL;
> > +
> > +     tctx->handle    =3D -1;
> > +     tctx->ctx_valid =3D false;
> > +     tctx->dev       =3D get_device(salg->dev[0]);
> > +
> > +     if (salg->mode->sw_fb) {
> > +             tctx->fb.hash =3D crypto_alloc_ahash(salg->calg->cra_name=
, 0,
> > +                                                CRYPTO_ALG_NEED_FALLBA=
CK);
> > +
> > +             if (IS_ERR(tctx->fb.hash)) {
> > +                     if (tctx->handle >=3D 0)
> > +                             spacc_close(&priv->spacc, tctx->handle);
> > +                     put_device(tctx->dev);
> > +                     return PTR_ERR(tctx->fb.hash);
> > +             }
> > +
> > +             crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> > +                                      sizeof(struct spacc_crypto_reqct=
x) +
> > +                                      crypto_ahash_reqsize(tctx->fb.ha=
sh));
>
> I thought you added set_statesize based on the fallback state
> size, but it appears to be missing?
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
