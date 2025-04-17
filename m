Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D81AA7BA;
	Thu, 17 Apr 2025 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900806; cv=none; b=g/8xy+YehB7tL78fxmF1OUraZ8wsgSRHBKjdRp6y14X3zI1WvhnTVef9HLKDzwDcGHEr+5EU6XBHViynCrl5tGZgLgMm62d3Os4chbgj7B91NCMp86vk8TYACQR0LGnbIXjuHvMlrid7hzW0bAgFzSzn345p40nb2MfQxP7YkXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900806; c=relaxed/simple;
	bh=YjSuIg9V8KFXqeOeQX0npWOfivCLZnrB/LzyjhcAUug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JcaOpS///DhciBLL0A7o/xTyVhkKB/sz4CU1TOKmwIYRQScBRno/lIL6chGG+trqc9EfPrFbUxAUla2DE8HLDT5JcXEk8Llkr6jZPX2Purw0Msi5HP+cGrI5YNbo+LaULc6TafUO4l8N6+L1wsbCFc5XfMyGVcdj6lpthFopdyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWUkh7mz; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWUkh7mz"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e726895a6cdso906672276.3;
        Thu, 17 Apr 2025 07:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744900804; x=1745505604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjSuIg9V8KFXqeOeQX0npWOfivCLZnrB/LzyjhcAUug=;
        b=MWUkh7mzaw0oObrOBqNz4tmIA1HqCqC57xkaltURY8HueKNkLdcQN74W8lbIq4g1Gq
         MZGTp9vWmnjQHxiNZkReNi+89EzsBozhEJAUdg65WYLY872fvHqAVRUjOVlFiKrKVSnz
         I/1ju92nppdapqgg4aIM2HOx4OJ+/U9gPsWQdcIp54i8sDHkdGrXLfz4AsvM3dClBhIz
         /BXCKr3b8M2LkAXMbb58jdIhDsgqEQiyJlnff/qmtv3fWgnfreHjBQl2Tj+GtpI9EDE8
         ZGTn03dYos8XQIL0ZYGUz6KO66/iJBtMIggFzo6WPs1RsBf+QU6Y/6/faJ/HMmRDDZlF
         V75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744900804; x=1745505604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjSuIg9V8KFXqeOeQX0npWOfivCLZnrB/LzyjhcAUug=;
        b=NG7+Gp6LKunXzH/ZkQbjBsd6RWRMeEkIEB0w3eog44PTWb2SgwJ9nYHM+HWFafr4wz
         YhCBTXn5tdDxve9T5OCeUvKzwDhgJiR1PdxiAB2m1kn3iyJadsh1OnWssUBjml4sbuOu
         RNfTTfOfYMRhxSz820zf64bWIz1mTIEjhAPDKgGVelGmywtULvgsHzQA/9iU673FIkLc
         bcPQPBM2lZDHbnsxaNpDTTASDINU8rurVW8T/6YjyUgPoyR6NGjPrb3DqHQhXt/9DzB7
         ZQwwNq0HXug3f+vHQOFt2BdYiXCPQchBaeKgjRnGWx3XZS50ekKgCiV2aXlaFFR9J+C5
         0+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCUztrYYVwMGYcWyJPJq0qrNdI2B+OxoLiYjEdnYZBJ/aqw3QlsNenZSW07MLwvRJKqCLJWXZFEmqR3/4gq2@vger.kernel.org, AJvYcCWhLpjx2KRkHHUlWTYXXkF1FfR7RrRFEnfJZ6517cxYaYnqE/WYdmNq55wKWXWcekouHMHB19iOont45F4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzniLECuG+Y/GXDAbPNMpiporNxpLaKSo3e4TvbNdRcB9AUHFZ
	cO3e7vDxn2W3SNNgtbyBiEZRIcRWYLS3XEWUK3pNM4vGNn38SXVFqbtcMKfigEqmSGvfPop3xVI
	hxTX+jvdjuDh1f4bki0UMC4HGYNU=
X-Gm-Gg: ASbGnctXaoWq9lkEKFmVuPl73UB1flZIHi2dF/dULLEWGTH8Zmms6ECFR7InVIirdy9
	VvFoU1U9VK4ulfNfdDDDZ5K4G1mJg141mpNl4qR7S3iaSeP9P5Rvt47WNERpuxY/STrB1vdhXnC
	TzOcHaXi6e2c0lCKXgEp8ZwaL6upyyXGB+71YMUw==
X-Google-Smtp-Source: AGHT+IHfNa7JtP3MTMQBKRDR/0sqBeIlvephhMVZkLn4rPfWcPEYlwEn3wnt7sI5W+yM2CFASAh9zr9eeDt7mosJ8ik=
X-Received: by 2002:a05:6902:270a:b0:e6d:f27a:57e1 with SMTP id
 3f1490d57ef6-e7275986ac1mr7725772276.26.1744900804329; Thu, 17 Apr 2025
 07:40:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
 <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
 <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com> <CAMj1kXE8nY0rasb04qbZGtkuL5_b8so7L7NH61zLv9G3nm5vcg@mail.gmail.com>
In-Reply-To: <CAMj1kXE8nY0rasb04qbZGtkuL5_b8so7L7NH61zLv9G3nm5vcg@mail.gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Thu, 17 Apr 2025 22:39:53 +0800
X-Gm-Features: ATxdqUFgfiipK7rybD5hunEoiNe7HpXF2zLIpKw9TAdMUyxIHZOTT-pMNkCnDhs
Message-ID: <CALW65jbg7BAo4kxes5f_feBPjj2CxhmkJyed0G37U0C8yd9UXg@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 10:15=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> w=
rote:
> > - There=E2=80=99s no clean way to force the optimized path - GCC only e=
mits
> > fast unaligned loads if tuned for a specific CPU (e.g., -mtune=3Dsize o=
r
> > -mtune=3Dthead-c906), which the kernel doesn't typically do, even with
> > HAVE_EFFICIENT_UNALIGNED_ACCESS.
> >
> > Maybe we should raise this with the GCC maintainers. An explicit
> > option to enable optimized unaligned access could help.
> >
>
> HAVE_EFFICIENT_UNALIGNED_ACCESS is a build time setting, so the
> resulting kernel only runs correctly on hardware that implements
> unaligned accesses in hardware.
>
> So that means you could pass this -mtune=3D option too in that case, no?

GCC docs say -mtune=3Dsize is internal to -Os and not meant for direct
use. So while it enables optimized unaligned access, relying on it
feels a bit hacky.
Clang is more explicit here: -mno-strict-align cleanly enables
optimized unaligned accesses. It'd be great if GCC had something
similar..

[1] https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/RISC-V-Options.html#index=
-mtune-12

> Then, you can just use a packed struct or an __aligned(1) annotation
> and the compiler will emit the correct code for you, depending on
> whether unaligned accesses are permitted.
