Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CC13D3CED
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 05:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213832; cv=pass; b=RSEBjNrkdnnQjuCzla9tG7uiK1eiVNe2ulJjQzKgzLpAUr6msLxQkoUp5pF9dgWC9WNTIsmLm3EzyV3Mt3H+ub80fDof+yKtx34iklk8aMR3nmT4PCbPQcEvLMcQ3csk/mFJNj+P110UEQ13/LdRbua76mXMHAubjxsODNY6a40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213832; c=relaxed/simple;
	bh=ormcqP6wNTji/uauoLMi+AMmpwoBF+bw/BFECz7E2gQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cj00CsBUs4S1EmbdQJZEJKLkO1ymgXOiDcFPv+SvWMyM0cYSj2n1XhCBFbuXFHwplG9zD8aYspdXRPxw/z2HMkSf53IOFcqTRJAdoVNFBb31+JgXgfT0AzSp8uDkw/R80at/mUuHc2bNR+vjo6ktJfLcVAzaB13CSHIw1XVxXOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/j/20OZ; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/j/20OZ"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so50522e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 22:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792213829; cv=none;
        d=google.com; s=arc-20260327;
        b=oERiK3hzvuQR3goamOO8LAUO4fTPzew0RgA9Isr7yE9FteaDBQN46p+EDUNRWU6swY
         5jwZc6EO1GnKTo/2oKEX/DyuCiaGUqIv7FlRf4AN5FW6GaoKW4qF78bTPupg7CB+hmdR
         J0ZT5NrillyzyYtCMMQVGhGxIwpPauitblrXeW7foz0dAsjUXo0eDIH3pW4fd4nBgcdp
         0HR92MhVyVw5DQkNcKRUc1MHa53hZF+ElW2XIsiqO5ILKYZOn+b5Mr+Br0KYrFvDucIa
         zpr2wWe6xkoNETXAZ60RpQJGA6Q7W/QR0qQ8R67w72NvF+Mo7ulkK9Pej0IpDTK/ICAK
         WbtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        fh=2oWuZXi+JRzV5+YdTFZcwFZSG4kqPVcmReuJYwykFRc=;
        b=pf929Otp0B73Y3gDfCVLyQ1yhokwel9LQHdTisj+J1QG5s6sxQ6t7iYVEe87WninEx
         drXpowPEedgsjjPtxilCYRWCuaP4WGziY1PyI9mGmQG3n3gwBErlSPcJvbQ2d4CuDzG7
         uACaeVRpxILCU0N1VFtPiB97n/ujwoocVlUk3I8WMJ3HgWfZ4XTaSZqvMoVCXP2lGVLW
         zCKnGJlP4DChwDcMb9ZW124RT0uudz3VLh23utw+FgdnkPpCw6ybyAM9AkZ9dZJ/c2MN
         ftQ3WwkATuu15GaLEMihFnY7Iy4YBM4zCqMb1VcQoLFjl+szeq9h6MdI+xxUBr4ooPS+
         Th2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213829; x=1792818629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        b=T/j/20OZHLo06xzZDhT+VdUAiLJd0Z8bR5Q9ab1EsAkPm2OvWCAETjQNGga0yTP7Ny
         4VgDflwc7PjIS8OoThGP8Fc8JYjxX8qAKSXtP/631/djGJlMZYsG3Qe3Akoq9IQwT5PB
         TH/E83009H8xOhbMGbnjmV5QMoa2O3CHrxy/P4UbYklrFtcLdUnmMioN08MSHlSPXBOn
         AXHGzmeA8Y9w9b4pXPW2VdUfdPDChBphrQ6eJYgOQvg8FBUIR7TNGswfh5xBtcZasH1k
         zJC1bY/Rz42ySC2F0bkpMyvKb0NXnbsQTtebO14WetpcGnTh2njFp/zWqrQGttQWNIMz
         7DPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213829; x=1792818629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vQlYW/4GolznyYu2RkLZZnREvlSq3a4QuJHVVDOo1oA=;
        b=Ir/aXnxVvr6ZzHGQ/3/Ouy+DKOhYONqWqowGEbpOBduMqkHNtDBIA4KDb1195UchIF
         7KkBExh+I1F4NN6ixvUoUksz8ZnfppXJVhZzPfDEwTXny0e5gYf67IOEaORs7OQHOmJo
         YiAesC4v9Gp+Te6OcZ6xJk98PaSnjt5w/OKVn+dSON2JahB1hmfjbF6ygZt/DcXzL1cr
         Fj9rMhRKUKND0Uiy/RHJ3eN4FfgaTW+ysX3XxUu9Q4vmau3QLbRPGi0A5h5/xicTU6cf
         xWhU0xFjLMiitgcnsKYl2PvD5wIEqDjA1w+JuNP4hLsBYHYsisl71FyemFx2rsaz64Lb
         FB+w==
X-Forwarded-Encrypted: i=1; AKwUvBw1377klVSVBcouevbqZG+eP9wgknEgPj/qq2eQlJEnwsfBpbw5UzULhg2QvxXjFEWPdrH6x6J+yNIJPH4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLj97LEFvq6womqx8mu1VBEw45jw4ffNsp9BXrHAkOF0k4YgP5u
	QGSJL8rIgmHApkgdvqIpGbPBbCx9gyeSxeq5g/J3hROdjVweQCz3Zg5ZJdOS6dLYQavxBNR2wi4
	gDWtIPgB2JEeDJnAAMfaRESijIDsG1JQ=
X-Gm-Gg: AYBFou0R0NLWSp/h+dLYD2amCXgLZ/V/HcI8kkG4WDrdj7mOfavZCLieXPtbcaHSTpy
	ni13RqCrconzN88omOmUXbOc1q/cZ+j9EQN7FnWbDI53SGPE9yCi//liE84wffl8VDhO4uqYIQl
	5vEDG6WuOB56aW2hQWMFtFHJqW5UON7KW0vIBXQtMbkyW4nupDOzxqaA7PdzHshqbZf2KwDbsgA
	OP6CC2vOeyllMSS4LN3zkTZFPkaVKVNsVFDJjXAhf8+nqaYsO0+EulA/k2LWx6vlnsd3vu3u5eh
	DPtAxWK0EARu5qU2p9iJa47NQQNYVyRJnxlbiz+O3psE2QgnIImJcqs=
X-Received: by 2002:a05:6512:3d86:b0:5b8:f3d5:f2f1 with SMTP id
 2adb3069b0e04-5be50a70ea5mr520864e87.44.1792213828898; Fri, 16 Oct 2026
 22:10:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
In-Reply-To: <atMCfhB63koot230@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 22:10:16 -0700
X-Gm-Features: AclHuK84HsIT1U2LdVEFrL_f9VcnNP3gGMKOf310qvYc_nXv3zBiGFi7dT1VC2w
Message-ID: <CACpmpod1mPeJFoP0teZ3jc3B5z8Xhz6SDQ2FiLY7VERExG5zKQ@mail.gmail.com>
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

On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> >
> > > What if you just do the conditional and short-circuit in
> > > crypto_acomp_compress?
> >
> > Yes, this is the first option I tried (20,946 KB/s).
> >
> > [1]:
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
> > int err =3D tfm->compress(req);
> >
> > req->dst->length =3D unlikely(err) ? err : req->dlen;
> > return err;
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
> That isn't quite right though.  We need to ensure that it really
> is a singleton before taking the short-cut.  So you need at
> least one conditional:
>
>         if (likely(req->unit_size =3D=3D req->slen))
>                 take short-cut
>

Got it. I will give this a try and let you know. Thanks!

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
