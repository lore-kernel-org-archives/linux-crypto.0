Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022273D523B
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162516; cv=pass; b=sHGX5msu/vMmaoiIcCtP9dCDoKccnCDYqZ3WlMGjkjrSrh+7x4Ci8VU9SARBmvHrm3dRDeKcBZ4WVft9zNVOz/KUh6AsBX81oZo0/5Sug29FNV9gqEppJ75H+1lkTL/MZumSb8irc52120Hxg/1539vlhC7Y9pNXi7jEUe/vtuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162516; c=relaxed/simple;
	bh=lrmJycYsABuOjKqSc9d0hOXzD3f0R5HKmLZc5qFfWUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BpzEftM8p7QwEIAWaIQLTJlNaTbhWBT+WTryzorKT2nPU2ivnwXuR3eTM/QjlTKgpoo6m9iq0D0zkkLInzY35RwqbW0cZNi2y2NF52siimz2lcs4o2tGeD0rQ2inMk1qvzCNVesjEtyfw5dYXbksTexJLpoDPl2c+n2HhnYg/Ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=UGKyHmtW; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="UGKyHmtW"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d9436f2adso64057131cf.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 03:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776162508; cv=none;
        d=google.com; s=arc-20240605;
        b=CXEXZ6tclbO7RCS5FiFTvhmIW3ZOEAaLe3gOKQHIypmfo7SddeNrMtqqTeji+mjk0x
         oAg+as5dgars+9ssWbeP4FDVmDKOPDurGJov9IYDVZMEJ5dvamD1vnB7kl1n1smvIcEz
         KPkyzmVoAhW3frDXVwhCzhb1VoH46Y8/oxSqStnKLy+z+WvEU6CFzNcJUJdHyTNs2vJS
         PpReFQ8MqSrkA4othl2IhPravWunSH71XCk1LgSegDigadZmC1ErezwjQ7Bj9gZdj/So
         wIcLhqj51h0uAQPh5mT2rcU8hGtTE1OJv6zyf2N93TrHijOu/72UZPD0jHV1jcctgc+a
         y0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EbKz3DQzt83f/P1RrZXts9tDEfXZSdSj2yob2J1dqQE=;
        fh=RIaseGxQFyc4BaNbPfLN0YMYNmMpnfffvXGYEP5tTL0=;
        b=AQKwu6TvmFvDOcVE4TS0Tmhq5x3LrrBEjgy1gsOCivWyR1x2pGcaSHK77sHdWHo9BM
         MRDEcw7ldNmPxB4Wn/UvYv1k4pjl9YVNZIrC0lyV1emwl48ztHTu0em5b8QxJ4mNgsaT
         l2zQjmAe02ehiqTfYU9LfPwQ9guf6yVLfAZwIsPdWxD82mkpMLL+77J9/dv/DjhgvIyo
         OLEN35e280TWJPJTDGqZ7ExwVC7MYEXwL8JZ6+Byf9PFJGEbWh+a/I/jdqk3uaGE7vD+
         XRtL9LYCEeMA1WYpOLlMMChHeEQiYEng3DfOT2i3P3kj2Arh8AUOkXY08ilsg9hn1uwz
         rZwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1776162508; x=1776767308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbKz3DQzt83f/P1RrZXts9tDEfXZSdSj2yob2J1dqQE=;
        b=UGKyHmtWQpxhpS5AwJhZWSVst41dokHijuUCKK5Actemb697xQVH+jAeGzgIu4OEhH
         XRCRnuhtXdqt5NbnCFiRo7+uJuBcQ9l7GCE2V4Vi1NSWCmtOUeADL4XUYtdk3hDpef2Z
         5xWaACAm3PbLJj0AqmOtUYT+paqM0KPih14BI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776162508; x=1776767308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EbKz3DQzt83f/P1RrZXts9tDEfXZSdSj2yob2J1dqQE=;
        b=Igyunt50hexoFgyR9JPjE3PnUYqdFje7CiYxZgZxsU16P8ccQijMs5ED3mQVRk0muE
         ztva9imkOKJSwZI0Omx6PFn3w20gD5Yxri6q70hbbgCuDnw5vCxUZwGYidDXGWHyLvyc
         6z0pizG/Lc2XyQRGYQpKPo+0cDFueilIt02SuRlc5+4CVc3v33ByI8QnsuNkyU167XzE
         oOW/dQRQ9upc6wp4XDI1tZ8X2Yduhl2pT/py0D6THphZH+vJMSnQ+dtQPkMDEXBSUNe4
         nE9eMZdZS6CM9AkOgjkSf/+l1DiyBneTLfZUDSSOGQE+tusNA+hO4drhKUEO0cQavnHD
         sWIw==
X-Gm-Message-State: AOJu0YxlEPOiAGKQjkIayoWMAh+Ryfsl6Ziaqxom1EviTKYSmyVtTNB0
	VSNSxfuN8KtLvnv7prJCcwJwE8B/CdJn4ZZCk4ZdchS52i1oEonJtwDnmmVImy9zN74069blHE1
	FG/fUC2YskNbp4fo1FVv4SsK/8XcMwDihC4AM7dk13A==
X-Gm-Gg: AeBDieuZdDpDO02vuggI/Is7wIfs1y7CGoWVy7cHbMqRn+HdD+gr1L9UAqtKJTEAcbT
	e8841HXsSuKXgf6ZrjYCqJ1S7nY+ahLF/8CcuxGtEca5Rs4Cl91Na2XjRvfTl9D7sVgJvdIQB9p
	tEhSo47xS4ap3P43Ply2hjVD0ygG26dvNSqbPDKG6am1hsyvNVtkRR3E58Y4BI3gJdAmAtkzYP/
	K8GGU4rBWNsHI1ly0DviO4q3qAJJB6bLYhc881NT41k2EB6Dm/STUsSaRlvP+8ZSgAI02lNqSjc
	y8r+Q3huq1ysz5gAD5IsMGYF21upOpK5+LT5d+H9Bh+WYWP9a8x96k2E4om6Q2wo9bwiUDpgP5y
	SgpPFUe20U21XTUaGBLJEswE9VNFau3ai3aSpK9yegTvjW0irTVuqVhX6FA==
X-Received: by 2002:a05:622a:550d:b0:50b:2876:586 with SMTP id
 d75a77b69052e-50dd5ad112emr252830511cf.5.1776162507725; Tue, 14 Apr 2026
 03:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <20260318071808.817074-3-pavitrakumarm@vayavyalabs.com> <acZL65nbtfMCPHhq@gondor.apana.org.au>
 <CALxtO0nFEG2Lm18Fnb=YVQfy4-Qjb5+WtOxsHNOwYTy2Kzyb4g@mail.gmail.com>
In-Reply-To: <CALxtO0nFEG2Lm18Fnb=YVQfy4-Qjb5+WtOxsHNOwYTy2Kzyb4g@mail.gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 14 Apr 2026 15:58:16 +0530
X-Gm-Features: AQROBzAtNMeWlauuG2iBoAxxFsqw-tyFJ9-jcGZZ7ytu53NJX8wZj4aZKG2Fw2Q
Message-ID: <CALxtO0kj4JfL94qY-radGcLwMeTnq4NQF7vPqs6giuhBinvALw@mail.gmail.com>
Subject: Re: [PATCH v11 2/4] crypto: spacc - Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   If the above snip looks good, I can push that and some more code
clean-ups/improvements as part of V12 patchset. Do let me know.

Below are the code fixes and improvements
1. Multi-device safety handling - All packed up inside priv
2. Minor code polishes
3. memzero_explicit inside setkey, spacc_compute_xcbc_key etc.
4. Algo registration clean-ups

Warm regards,
PK



On Thu, Apr 2, 2026 at 1:30=E2=80=AFPM Pavitrakumar Managutte
<pavitrakumarm@vayavyalabs.com> wrote:
>
> Hi Herbert,
>    As per your inputs, I've replaced the do_shash switch to use
> lib/crypto single-shot calls for SHA-1, SHA-224, SHA-256, SHA-384,
> SHA-512, and MD5.
>
> However, SM3 does not have a single-shot library API in lib/crypto yet
> =E2=80=94 include/crypto/sm3.h exposes sm3_init() and sm3_block_generic()=
,
> with no sm3()/sm3_update()/sm3_final() equivalents.
>
> For now, I've retained do_shash only for the SM3 case. Would this be
> acceptable, or would you prefer a different approach?
>
>
> Code snippet below for your reference
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D snip start =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  switch (salg->mode->id) {
>  case CRYPTO_MODE_HMAC_SHA224:
>          sha224(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_SHA256:
>          sha256(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_SHA384:
>          sha384(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_SHA512:
>          sha512(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_MD5:
>          md5(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_SHA1:
>          sha1(key, keylen, tctx->ipad);
>          break;
>
>  case CRYPTO_MODE_HMAC_SM3:
>          rc =3D do_shash(salg->dev, "sm3", tctx->ipad, key,
>                  keylen);
>          if (rc < 0) {
>                  dev_err(salg->dev,
>                          "ERR: %d computing shash for sm3\n", rc);
>                  return -EIO;
>          }
>          break;
>
>  default:
>          return -EINVAL;
>  }
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D snip end =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Warm Regards,
> PK
>
>
>
> On Fri, Mar 27, 2026 at 2:50=E2=80=AFPM Herbert Xu <herbert@gondor.apana.=
org.au> wrote:
> >
> > On Wed, Mar 18, 2026 at 12:48:06PM +0530, Pavitrakumar Managutte wrote:
> > >
> > > +             switch (salg->mode->id) {
> > > +             case CRYPTO_MODE_HMAC_SHA224:
> > > +                     rc =3D do_shash(salg->dev, "sha224", tctx->ipad=
, key,
> > > +                                   keylen);
> > > +                     break;
> >
> > Since you're doing a giant switch statement anyway, please convert
> > this to use lib/crypto instead of shash.
> >
> > Thanks,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
