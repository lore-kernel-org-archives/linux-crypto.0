Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A04175A61
	for <linux-crypto@vger.kernel.org>; Sun,  1 Mar 2026 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772365598; cv=pass; b=BBr5ruQVu0igZkk8qMb0A0vdIpY1A5lyCLktlXQhNIHbCgxip4SAn2bwtfCuIeVNR5Sg7H/2Lhxc3DFO/LOioTyBt2GZaaHOrnwyu2HnAn50s/+wVmKFgGt8lbVlRGvKMtp8SIXoqNrwL/nhQV83I4HrlsL6rG3npziufNlanqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772365598; c=relaxed/simple;
	bh=rgIKfR3cZgTresFp6jqDLt+yUFjnsoftF8bwEcypVwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o9jVdXctdosfu6qLyPXgQ2BeQYDXj5VMpzcNM4XRDlqNY6h1mhidhTwW3zb0v1P0eFYk41+0QlcHXXgEotYisFuSp+7uE8rqMgS0V1dkvgQLIK5COl3JQK1S2tlyOnN9jqwN5hKGeSneyKD2HHJRHcqpA3tVb7cum2XAoqjyVS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGOs3jK7; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGOs3jK7"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65bf302471dso3859933a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Mar 2026 03:46:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772365596; cv=none;
        d=google.com; s=arc-20240605;
        b=SHFD2YnH2cV8tx5nFi17Qvil45GcgSVXWHh4UuHVyMdGZ5lxCm3cyGq5UmI6iwMzH2
         +KZUb3AaE6PQQFJwM3NOLs2zTGKKfRiRjYQFySUzK9WPYYlIcmaG6ID+Bg+9XzTvUC0x
         s0/4VaXizPYzRe8+uwWyttGViKl5EevLLZXc0vUKMlMVZ2VgZZoBnm7qYcE2IH8am7qD
         CbWeWNGHUXWX7nDs73EM1yMniIY6u5lHhcVOAtHZvvU1IqQaX2LpOwtqvErdOPqiJQh1
         NWElRq63g/LlkZJdWgiQrJfyqITO5CU+chbV0jzyRHIm6fly7AEUTpA9dTWvkI8wf4Us
         unVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9amC1gTLDXbA9BKGANgf+ZcE1nmrzEtlxAxVVaPIErw=;
        fh=mrDm6wv14jHiW26hY7cM0dtFJ/mn/2brXnC3Xnk9X14=;
        b=UO85oaYAayDCtCIbzp+YmlWe+oOEm9TDo4u1/K5DRayAhqo5BpPuZKxWTmeAfMeu04
         USNQ+bDNGBiZSZx89sMRpkv3VO4ZGbRf1uDQFKy5Ywdub1sG65GbN4mrPHFP0jiYdE2x
         I1fItnKuLeGTIudDc5ypowGQNkLmGJHXBn8+S3tUZyG6pxWU4TlhxtdFb162zQCzGLyp
         /wf8ySE5F/1hhAwouLO6w9MUU54isS7GadlIKsqiNSFVNZ5G/wLdNrPRYHETKH+jLnJ7
         NeaeyLzn8PkOgWhZA4AWF89+CnzdOJgDFZimYtQ50j2qA34HVS1NNpRtMzk5TRu/s6El
         76Qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772365596; x=1772970396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9amC1gTLDXbA9BKGANgf+ZcE1nmrzEtlxAxVVaPIErw=;
        b=WGOs3jK7A8Hwjzhfkbf6UnFhdYTrRP2CZpSvRyPnZAQgPpR+7U9CVS9jvEeBaN2g9g
         kHcgbzPzpuPfoTl20I96TORrqtS3XQGaATtVv/hMGsWHXW445jmBP5fyueHfWu/vhoyt
         bDk3mCxKxKxMVY/Qk1vXLkABseJGf6up92Q4VQBnDZjvJYfLEa7FJQ0AlmtLuN2jIPjX
         EMopTXBsK6YiMBcjc9SjDbsSOjN/NRW5VVm8ZZqPxUGnNRmBjw4ReGBayjJCP8Vu37yQ
         M6DcGMSs91R3iMKfGbixdz3oNxTznH9cQwVZG6h3/Wjn8L0yLSXA7eZtze/TU+zsvn6l
         CkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772365596; x=1772970396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9amC1gTLDXbA9BKGANgf+ZcE1nmrzEtlxAxVVaPIErw=;
        b=Rb1ChLY4gviz2VyhggDbRFzVWp0c/s54rzYeqx4wNrBQzKm9/RNqHXSsTE+wCjtUgi
         7JP6eO5NpaZTcv1qUcS36WaBy75365Ub4EzEmOQixsVDNNB4wrmOqnQjFsDVOmvQTSGl
         tiXLk6pdJH4THbUKwYuAqleueg+7+HI9ri89s5/GHcm+HWNxE5igz/gFdVRqwuVbI+z+
         az7xbAGPM/Oq5Brcxs59mp3ebFJqnYXUBbPArCi8yUgB/XSM0clo00Q04NxBZe21tIjZ
         3fR1wOVpheg5tb5gFp75Su/VSsUfPkV2ibCaPNAe28a4yI+YVejL8SSGEBfZLIasUfYD
         sILw==
X-Forwarded-Encrypted: i=1; AJvYcCVr5etiv3WHlAIoYFhsPgjWxORTauJCv0VAVDfwv30OgcMFTo7upw2UUW0tEgCo71waVENc36yawEPLsY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg3vokAzNZQEEViwcmgCYtUwzPcxDtCa1/o5jO0NERDGR/XhCu
	m5wN1plNDFlAmxV1QHK0ZGjn/IXqEnIcTo9usxA+NrGvNsXvVelw+jXa7jl+dmRLTtrBHdwk6MM
	yG9+Gow/QNniiwoNvqQXoKq32GahNp8qk2QfRQAI=
X-Gm-Gg: ATEYQzxWuoQP2aJGR6tgfIKYIW97SVEOMTCTA2K1J3fETGcI0SMN2wxHhxYuKcvfMgW
	rb1lbibC91qHkym3SPYRtNCHZVtBUKOl3SLkhkMMnOWFXxhK1qe5wzpUArsnYcKVTi0dcdE8FCw
	C/iNtmq+t1nBknMAtGwKdVy466s88eOhqQWJJ3Xaklap15KVKAx1TOSPTPNbYLK3fIZ5XIlKQdt
	oxspyRQ/MRoUse8Ohl3Cf8w1UhC72RLYwhT7VN+9M7H2CGAToBxcdDsCFFLX4XY8zB7A5YucGJp
	v1uxGPshnNKAC3t3CLY1j8KPU+Jn72n4i6UK+1mZ+m6idD6mLnG8HqKXaY733XZ+WpPEEXkrZIp
	ZH7NwhiTSkiaS90R20m3LuzFAu6WAslfp8/UG
X-Received: by 2002:a05:6402:3507:b0:65f:b7c4:d4ae with SMTP id
 4fb4d7f45d1cf-65fdd4cc1aamr5253303a12.2.1772365595518; Sun, 01 Mar 2026
 03:46:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207232925.80976-1-rajveer.chaudhari.linux@gmail.com> <aaJfDsCLKfy34dSP@gondor.apana.org.au>
In-Reply-To: <aaJfDsCLKfy34dSP@gondor.apana.org.au>
From: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
Date: Sun, 1 Mar 2026 17:16:24 +0530
X-Gm-Features: AaiRm53jcpot5vnKXI3DYkL__AHE3xCml89DvGrLupcAzaUPuO_HlRsvDLsXg0Q
Message-ID: <CANS1UbimhOWVzVORMpe-vbec7qcWi=d6VyPo-D-nBXdr0NouRQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: drbg - convert to guard(mutex)
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 28, 2026 at 8:51=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> Please keep the headers sorted alphabetically.
>
> >  free_everything:
> > -     mutex_unlock(&drbg->drbg_mutex);
> >       drbg_uninstantiate(drbg);
> >       return ret;
>
> This is a subtle change and now drbg_uninstantiate will be called
> within the critical section.  Are you sure this is safe?

Yes, this is safe. I traced through all functions called by
drbg_uninstantiate():

  - crypto_free_rng()
  - d_ops->crypto_fini()
  - drbg_dealloc_state()

None of them attempt to acquire drbg_mutex, so there is no risk of
deadlock. The mutex only coordinates thread access and does not
restrict memory access itself, so drbg_uninstantiate() can safely
access and free drbg fields while the lock is held.

In fact, holding the mutex during drbg_uninstantiate() is
more correct than the original, as it prevents another thread from
accessing the drbg state while it is being freed on the error path.

I will also fix the header ordering in v2.

Thanks for the review.

Regards,
Rajveer Chaudhari
