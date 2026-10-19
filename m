Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA5D2D3225
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 01:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792374451; cv=pass; b=T4lzkUOwLuGKV2G+z9V1nvS38IGFJuMDGbtB1D3Ki5NkpSF88l9a7IfAQemP5NhccN39iyO0MCiSdpgGjcTM4oiMhcJMq6kDt8FQyNHz53oJeUFJ/3hgIoE4VNd9Q+1qZpcHeTf60G/+dBcjEIxGDun6dNTUw4P7aP/tZYtNMBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792374451; c=relaxed/simple;
	bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pZ7Amq+Sh1ezURPPfjSaxRnbQCaMUYVabp+cP9DTwbjCSQnsLS3LaTJ32vJvHeYzgMqLCBKIstoggaNAv5p+OQiANTiV9aZcxSC3PE8YpIATJ0W9ZHXQIeiEZ2mqk5yCT+mwH8VbLQmf3uXTiQCT5E9NAsHjxVaP5LpDJos8WrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rVg5KI+o; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVg5KI+o"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b8f5e2ce5eso1693320e87.0
        for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 18:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792374448; cv=none;
        d=google.com; s=arc-20260327;
        b=jyEqYJE9nVuxmAhdboV8l+Xqc+AuD3YSLD+Vj66iQb7f2yiQaRXx9cew7PSQcbT4n3
         Zh1WE7IwrFpQBsHw4j/+PkumhvVg+D3Ert3OYWDk/zt9eAD/iormzGtGdAX/KjOy2u0G
         MtM3IX4vDY8yUYsHjNVpyoj85ExQ2+yGdqpgbbtWBcKzBtl1cS38LmfOEKQQqH6WGES7
         CvdNO1iUi2kdeSnchwFAssZLKjioqMflos4+aYRFR1DYLWsXHv4f9Cp6Ao8GT91GdcEO
         BY/pyTLbcJtb2EiTtlHYP68oN57s9+L3sVUsLqn8nkm/8OZwKsAZElbQgOMD69o/NjI1
         d9vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        fh=q1wRXCdECLROk+EuflJrB9YJOLvXeXE9HKRNsgR+96w=;
        b=dANx54CUKzwjLjYoTa+5a77D+keAoNeUMwVTUbB8LHUOynljfVFDvZlQePEuVw3kBD
         G4VQ9Jr65EeQIkqI2cbX+c0xxpzDyAtt1PrDeggr77HGjUYPK4cjrAfw5AFw37ubZ+kG
         WX/VddtZagNPROjpNwjcDTTYH2QVDtZUXvzBSwYBWKhBWBiwFEHrnuYH9E1+XxBxCEMc
         +BXI8v0UwETcwh4pxukB8HHKmgQU0GpHoJrpDkr0vsu6wrkwPqy4olfmlt6l5inSOy6n
         mTLSruYeOmu/WBH+2m981lkFphthJLKen1YvI4h+CEwdoK9TNAR3KeQJffFYdgK0m//s
         xzFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792374448; x=1792979248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        b=rVg5KI+oYlekH9HzklRiKj3nrHZjgUZT6H3p3y2HXEDCBZGb/dBF5RJPZjnJRuxRWh
         TZmgab5BQp/DtLXsBtfX6S/UOERd+LVSw/HitJU++RB8XIseYNMM5O7Wv5Edopl6cn3N
         SQQpXz81nsYxLULgSRlKX2kodWeoyPRSEobXACrUdAzwzyTaLjHtKIzpNOLXwJFRJFNk
         FbupoVh3CwLaL+tb4QsPnug/I1eh+oqkto4omR4/TFCx+6p2qGpuc3BccOI5bnm/P+z/
         XVJyMbQQiAafyGobCMX+LNEhMB9l0DXQeAYFkwCLb27fVvnzvCYxNJfNlApGmuNNfMaU
         1yeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792374448; x=1792979248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2U3A+oKRxg8msKayVA1cpT2G7nqJxD+NG7rSiparHoY=;
        b=NbO4q5ef7s7AXZ0vQdc9jNI0qODsEydMKodnMlMPZVBtRcGg0l0ceGJVxcW7YCTHOh
         pu11EFXyX1R9Rj5Tl1gQORZEd4UHW966FPAYOJz6E4AQxpaw5pZILRV9o/C7w8ffGVkN
         Ti+FrAVlw6jQj5EQHm+oPjPNhHhjF9ZRTSilIShO5hwUxGAI9o36DqPEFYfnydfY7NGl
         ISG8JBb7rspSZwlJIruUttxL1LaHnu3yrmzuXYhl8wiqIOH+bPp0Pb9m3Ze2hfcOoqti
         BNaR/HUYKNptzKwcMoyrEGcvHrF18zxOU1HK05eEv+Dy1hnJTzhSE2FtkStAAH4QYhqa
         zkAg==
X-Forwarded-Encrypted: i=1; AKwUvBxmUms4+lUsP1arcVij9jCWxNl5WyFD+k0cw6nEkRp9ApaCU9PjiiA3iV/I3c6m/qV5NjMvt0ZMSzzTsA0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJpyBc70SWXDg8a9MMXK+HMsZcPWmDO+wCazBocJbS8mxrvIX8s
	SZxvGoL31tNr/9dHAzNqdky5mzYko75S7m06rRRl0OhX622CHB0CBhiweFKkErFk05LtOsFcORN
	9DqFXNlPsvKw+MZF8Xi0m3mMl2FLp3Lk=
X-Gm-Gg: AYBFou1HwQg8teh4rt+iiOkRnetfIDZGoxjvFeEMn4dYBCTeGQKxi46j1BwFOp3EyC9
	bvNjx3APNmZVJkF0fUE7DJ8uVt1Vay/u1qdUy0Uig9jmMcjTECaRYK5Afjwjw1h9FHA8ujUkh8J
	Py8fBP6AJCSTYMN//hhl+KklFYXCxHm3GYJfM8/I/ojE/uyGVGODp4AEn0SHGTZsJa8zbpLGZBF
	XXMSGaRawrBt5an1nq5P8XF9v9dd2IlEvqKebad9fYXAf4Ov5jwz1eGN0dFZpAl9XlYiJnYke+1
	W5lP7aGjVh1g0fx5shJ4HFH84t7nu0zMEzoV6ZglHh4U05d3lcWzZSg=
X-Received: by 2002:a05:6512:2248:b0:5b7:f75a:ea68 with SMTP id
 2adb3069b0e04-5be50a4c8cdmr2008174e87.35.1792374448102; Sun, 18 Oct 2026
 18:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au> <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
 <atV0l54Q43b1KSHF@gondor.apana.org.au>
In-Reply-To: <atV0l54Q43b1KSHF@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sun, 18 Oct 2026 18:47:14 -0700
X-Gm-Features: AclHuK9zofrLvrOfaweJmPnIqy3kdR5flhLh-TJweVyGHE59eBCRksy4vGcxn2c
Message-ID: <CACpmpoemfbQHjXJ5DeP44WESSJA_A6mQYUEtZMNAHW4qtiT0vg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 6:39=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> >
> > Please let me know if [2] looks good and I can include this in v2, than=
ks!
> >
> > [2]:
> >
> > int crypto_acomp_compress(struct acomp_req *req)
> > {
> > struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> > return -EAGAIN;
> >
> > if (likely(req->unit_size && acomp_request_issg(req))) {
> > if (likely(!crypto_acomp_req_seg(tfm))) {
> > if (likely(req->unit_size =3D=3D req->slen)) {
> > int err =3D tfm->compress(req);
> >
> > req->dst->length =3D unlikely(err) ? err : req->dlen;
> > return err;
> > } else {
> > return acomp_do_req_chain(req, true);
> > }
> > }
> >
> > return tfm->compress(req);
> > }
> >
> > if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> > return tfm->compress(req);
> >
> > return acomp_do_req_chain(req, true);
> > }
>
> This looks good to me.
>

Amazing! Many thanks, Herbert.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
