Received: from mail-yb1-f193.google.com (mail-yb1-f193.google.com [209.85.219.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F578F51
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758619826; cv=none; b=sWy5HXF862fUXuJ2p4yjJ6kRyiJkxfuP3TdLmzAKSoEUWZi0o/GT3Z5huxEVf35oNOF7O4ussHaggDsIknPLjyYA3BvwJFxVbXF08R9OMNvz8b+pAiX9Q/pbIXOhEWpRnKuuuhTFWlqeeCHWtODh9osRQIMLc+RYKJJ6gSeVgrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758619826; c=relaxed/simple;
	bh=LKMkqYRs5oKuE6YZh/sJ95NDmetgm/PvSx2UxGirKIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwGOJm9Qc/MKh0xKKhmUVnaLocMEGl3D0NF79lJqTcPEnCy7s+/n8L2ayD3WsekDzeOBuvzeM6iaryvzJM3c319NEf3nkSCPTaVDF1Ta14tZleUYwKpE7OeEZEZ0yScAHvLZEGXGt22NMUfjfzSN4yXtoAcJen0PM87rJ7vn96A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cRBV2JyJ; arc=none smtp.client-ip=209.85.219.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRBV2JyJ"
Received: by mail-yb1-f193.google.com with SMTP id 3f1490d57ef6-eb368d14a43so250345276.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 02:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758619824; x=1759224624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NcHqzSr7+1u/Qh2ljI8pw/83Ihm75UvV5W9PNWXiB6M=;
        b=cRBV2JyJ24kBX5fcn08mtDhUcoFQJ0dfJNd/uuFDYv91gPyVGVTUbdg9+eUukLGJWZ
         CtW9d1UXisEU3XqpQJzgjPcdEgjgPwVLMKlS6vphI5S7yZpPj3jKnT6JM8NvH+8Zymf9
         6ZoX6xABoGK41mZCoGaQgU0FJNDxh9h0g5OZpxykVHEsHuaZ92ekCGpbgJkDXNkIKDad
         2nDVrhQPnoIFO2FruQv+LdtIi27uU+egAOiGKiswt1O7eJmuOG1H8manVbVsw0W4byy+
         1AzCxXaCnScy+++L0DBp+oj99E+TtL6FybuBxKmgVp807s+OOTcCaj58bWqx81CFX5bj
         hEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619824; x=1759224624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcHqzSr7+1u/Qh2ljI8pw/83Ihm75UvV5W9PNWXiB6M=;
        b=OPEnePtCkh0JCT8o77Ny45O5I+PdpqiMBP/k6L52uo+KRvmAGYjc+5FxBFp06Rz4DV
         H1392bL1+1on01Z4X+LJP0VdxXxUnIy0ooCW/8toF7woXUHn6EvyhAMFrUi0i6yy2PgW
         g+2zGz5IaoIR9p9s5TfrOBU4/uSFJ99cTLOtu4OkG2dWv5clV0BzzBEzAM74f0wErpCM
         EhfhXIMF/CSlX7khuAn3lCvdRzGYrXmKFn48qPH+Ng9xYKWkVOExHw0OXRMdqKGO7yzc
         OnzV9VxqeEodDSl375Qi2aQZNiv7ETQeJH8XwSiKv9v7dCzy60Im2/6ajv+KKZM0/1eA
         VntQ==
X-Forwarded-Encrypted: i=1; AJvYcCULG53N4WGwUgnfzj+Y1D0AuJukC1ZXnet/1D91K3YZkbcP4yBr0azA6tGhmH5KMxCR3rRJLQqus8vRcZA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw54yIWi3q2lmkpm7xvoitNe1p5VKkcaNjLV5yEF42K+MlyD4QI
	Rrzim6HBekxNc/7HOJLmu9RxaHqeJ4BA/XhPblmGATOFr6OQ/rEq4w8keoA3/xyWlAWc7QJtOEV
	UpXmNgYMitbrTGwg5aU8KjphXKpD64kE=
X-Gm-Gg: ASbGnctl0scAEGlVlKTP7iULY5+OOd5f+E0YTmCCa7huNoAUjIFwRPW+AQx+K+BgArb
	JcNKKNJbAAXIGNeT+kZcRTT+kd9+c/nPCTuGOS9JWSAFOFwfTe8i88RNlDZNog3u5gON20u3cWt
	hUngQT015Vmp98afM7/rnc6FNaxa1RosWYVQMn45zT3P9H08ZWuz1fF9oLA5bQPfvllGbkt59eL
	Hzuedk=
X-Google-Smtp-Source: AGHT+IEpeDeuEqQGLXjrM0BwMCnbNEzmEaZuDZ3jW+GAeAMxDzM45uFfdnNHqqnY09+sCgEmTN26dMoqQO7lXxlt+8o=
X-Received: by 2002:a05:6902:846:b0:ea3:bfe8:d03e with SMTP id
 3f1490d57ef6-eb33a6c602cmr1233861276.20.1758619824172; Tue, 23 Sep 2025
 02:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923060614.539789-1-dongml2@chinatelecom.cn> <aNI_-QHAzwrED-iX@gondor.apana.org.au>
In-Reply-To: <aNI_-QHAzwrED-iX@gondor.apana.org.au>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Tue, 23 Sep 2025 17:30:13 +0800
X-Gm-Features: AS18NWAyWAy_AE2pAiCc7Hz3of5UzftwpXm2I6gPoVUtddSIY5tEuOVAaliaOpU
Message-ID: <CADxym3YMX063-9S7ZgdMH9PPjmRXj9WG0sesn_och5G+js-P9A@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: add likely() to __rht_ptr()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: tgraf@suug.ch, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Neil Brown <neil@brown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 2:36=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Menglong Dong <menglong8.dong@gmail.com> wrote:
> > In the fast path, the value of "p" in __rht_ptr() should be valid.
> > Therefore, wrap it with a "likely". The performance increasing is tiny,
> > but it's still worth to do it.
> >
> > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > ---
> > include/linux/rhashtable.h | 5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
>
> It's not obvious that rht_ptr would be non-NULL.  It depends on the
> work load.  For example, if you're doing a lookup where most keys
> are non-existent then it would most likely be NULL.

Yeah, I see. In my case, the usage of the rhashtable will be:
add -> lookup, and rht_ptr is alway non-NULL. You are right,
it can be NULL in other situations, and it's not a good idea to
use likely() here ;)

Thanks!
Menglong Dong

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
