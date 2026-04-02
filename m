Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657AE396593
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 08:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775116852; cv=pass; b=ktaD/2kbod65Pit3Vy0Woo9m54RXUx1Rprcx7Fuk0UuWGuIlAe6K26yCBGzFYkXGR2ebgLAwcP5wi5OdkF+e3+j87fwM9H82XyupyS3ODyontpBJyQ2FHS8KlImKtU7fEMxUACRy75E2DB5JU2NJJz96ukZrnQAA+W5fo2Kr5iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775116852; c=relaxed/simple;
	bh=rr3SsXqnFSAqPX9BzB2mxQCJl5MZOQv2jjKjpfB46DY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cksPHls6QkHO6A73X5YJxftAT7egqC+tqawgZ2BN/6CXFJU6Q5O6LBlVdo3KHSV0x0qczajz2AGl3/zR1mpPlHcqEEXg2h8hOV7oogiwJECLz3uXds4Ldug+9jYefrd77Jpl+u1z67bwH1Fml/oBAPc00XKqYtmccdo0BfjoFrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ggFTvU6w; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ggFTvU6w"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a747448dso5115801cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 01:00:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775116848; cv=none;
        d=google.com; s=arc-20240605;
        b=XJo2vgo7SvYGMceggseiXyuZJ9Br/jIMe8fUS97i1mzoEj0Iago6vtzEKyJPur34Wg
         yYbwhYgyeewPHOaX1LcTdSNLRsC7udwv/b2kRucNn5jR+UKUzphwgfMX4RRhLkDy43Xo
         hHJrezUGyEkg4VVk2/IEOuz/RAvWgJ0VzB2q6FUW64923Wpi3wYh4VHstc4e2LY97bpD
         UV9Pr22egaOt6Uuiv7iDouVJjrwQtLPJ+Qy1m/7M1aAoWnrCA+JWbe6C6HcISrKIlo3L
         5Ix4IuvQNnV+MreTzvn3BMyJqzMHjIlM0QLXxUkWTX4x3mmd8peXsrsA0OvQn9LA7gud
         MDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4ZApBiaYJIfo0LmQu+lhhcdVUEe5rNYCCRSxXFzn05Q=;
        fh=RIaseGxQFyc4BaNbPfLN0YMYNmMpnfffvXGYEP5tTL0=;
        b=hdiWzchJySiN/eDvi1g47EKC0Ov9oyqknJVh/Oc4znNgymCZuLrbhp/NkRJ4UnKwVD
         cSmIRBFMpLmLiE0YVAf4T/Po/SD3449g3Mk0AuB7X+qtywMT3wfM9zqbrGOfBB/tQNc8
         1qLyteInUTjq0PfS2GfmcHZnjdzwg149VaIq3rLZgZeb9wNdoVWjPEoFhjZxNQZv+tnh
         RxaptWUZ6vofoi0gDiXbtIgCUsqeG/b4sV+0Q2uHaog2N3mvXr5L/NxNkmi1sKcmayrY
         qbD9iz5HLEKl38eeATmJD1L2GuW5Srmm2TaBwTA9CBHII88Hw7hP8+bu6WZwyx7ab/U2
         wfmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1775116848; x=1775721648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZApBiaYJIfo0LmQu+lhhcdVUEe5rNYCCRSxXFzn05Q=;
        b=ggFTvU6wmh+zgn/z4DCHrVO996bmTWBVZtRtKiR5GW5kS785eWXHfpPnXuA8wjyQxs
         81JHp8qwpSauL92YYUhHZHg/TLBScUlrBu9/cw42eX0RuUumCWQVsRUg/COVJtAL+lMj
         ZFQ81CkJf7PDnD5kP8+kt76/4C+BFZdOJLCu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775116848; x=1775721648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ZApBiaYJIfo0LmQu+lhhcdVUEe5rNYCCRSxXFzn05Q=;
        b=NTjlPNTkOPCzbzb//Gt3J86fhEKJMiuIYy87qF+3ytFk/p2p9PfGcyyXh8YBDmHm93
         Dyzj1uto4zb1cT0PgWMlcYx/iJvJywbL4bUDbcZwVpCaJZxvTjvpoG/mFE1VZao9U9T5
         fd20QIpYf2PEpiel8oj2aUFZJzBN2ZV8MjIiMxggZYfsKTTmdFju672qymaBRVdyvOW5
         o3tNu2W7SBsxbuQSLlNGlF7mzaQmxAbEIhrdfimQg7TsKmSBQTo2S0rGYpk+KQq8GNe5
         FUFHawQhbfsqNtCNc7ERPmb8pa/E3ZWFn/Sy5gW/7tscDArWZGFFFTEf0/0wmbYYc6kd
         dXMw==
X-Gm-Message-State: AOJu0YzNC6ZMSI6XUjFBXyhnsOnX0j8DX2eX340XplsNZq3ojIhAcjW9
	7171oeK+WLRNa3TZC1uV34pBg1Il496Hs9QlxXtURKQrzJamwbE0AxLm5Sw9Tm6ANxJssJxb3nR
	IUxH8+lVmJc/+6CVt09KZfg+6ssLs4H6DcrZjR0f4uw==
X-Gm-Gg: ATEYQzzJkSY4bC8rHqa7WUqt2vBc8q+H8RErTqhsHykbvdFhLw3G415vNbZS8GoMaqH
	Z+9RqZ9pCUbavj0LGss4eWTRGiyikRdjvIRSAvwfeSiv6UP0dBzvdLI87Wb9EMIwnYnMs2RQhGL
	yN4AYQwZ0v5FQp2a7R7qlAAEK/7e+V5Q/xv4j3lBHMfZdP2Ape67L/msoHdO7xVOPDjtbzBYmwJ
	caHki8cnP+CNxhEYYHKWGWG7/vJ3yHeSl1WPlewxqi8JsREmpOYLRro0Z6l/Q+480H5qD/jyr8d
	329W4gv9bPqKzylNSXYxd2ciDYNttLkH1LQqwi0LeXw5Ci9ndDXrTvE7Sb4v3yCqBim7AFgF0pj
	bLo6M1kzBH+ibPlna4sK7zt1jKBc5w+Vz+EpsrtR/yu+UYXJ9npc2XjTLInoBQrMOkEzI
X-Received: by 2002:ac8:5e10:0:b0:50b:31ad:32a2 with SMTP id
 d75a77b69052e-50d3bd5dd9dmr89661801cf.65.1775116847867; Thu, 02 Apr 2026
 01:00:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <20260318071808.817074-3-pavitrakumarm@vayavyalabs.com> <acZL65nbtfMCPHhq@gondor.apana.org.au>
In-Reply-To: <acZL65nbtfMCPHhq@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 2 Apr 2026 13:30:36 +0530
X-Gm-Features: AQROBzD-MihXKut6IzaeXppNB01Tn268fd7Zvwld1MBl_X440XsNcpzfx7Ujg2Y
Message-ID: <CALxtO0nFEG2Lm18Fnb=YVQfy4-Qjb5+WtOxsHNOwYTy2Kzyb4g@mail.gmail.com>
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
   As per your inputs, I've replaced the do_shash switch to use
lib/crypto single-shot calls for SHA-1, SHA-224, SHA-256, SHA-384,
SHA-512, and MD5.

However, SM3 does not have a single-shot library API in lib/crypto yet
=E2=80=94 include/crypto/sm3.h exposes sm3_init() and sm3_block_generic(),
with no sm3()/sm3_update()/sm3_final() equivalents.

For now, I've retained do_shash only for the SM3 case. Would this be
acceptable, or would you prefer a different approach?


Code snippet below for your reference
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D snip start =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

 switch (salg->mode->id) {
 case CRYPTO_MODE_HMAC_SHA224:
         sha224(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_SHA256:
         sha256(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_SHA384:
         sha384(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_SHA512:
         sha512(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_MD5:
         md5(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_SHA1:
         sha1(key, keylen, tctx->ipad);
         break;

 case CRYPTO_MODE_HMAC_SM3:
         rc =3D do_shash(salg->dev, "sm3", tctx->ipad, key,
                 keylen);
         if (rc < 0) {
                 dev_err(salg->dev,
                         "ERR: %d computing shash for sm3\n", rc);
                 return -EIO;
         }
         break;

 default:
         return -EINVAL;
 }

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D snip end =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Warm Regards,
PK



On Fri, Mar 27, 2026 at 2:50=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Mar 18, 2026 at 12:48:06PM +0530, Pavitrakumar Managutte wrote:
> >
> > +             switch (salg->mode->id) {
> > +             case CRYPTO_MODE_HMAC_SHA224:
> > +                     rc =3D do_shash(salg->dev, "sha224", tctx->ipad, =
key,
> > +                                   keylen);
> > +                     break;
>
> Since you're doing a giant switch statement anyway, please convert
> this to use lib/crypto instead of shash.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
