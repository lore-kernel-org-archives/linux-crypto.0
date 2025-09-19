Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025E6314A82
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294496; cv=none; b=V1eccIDwZwS1g0cVfXYrIzqbd8dlj4a2Z/RncDvgnM8cetSUHs50+0SmD8bbhW445quSYbtVcUVBrX5k05EXJdsFUkMMBMYUoBfS1ZE59WHv70dCX8ftlSQqAcCrSRxD7Cl+JkIYLfs5ZC6xMlZXE4sKLvh7/o6s+O1xtPWJF7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294496; c=relaxed/simple;
	bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HI0xEDHnWgWldSy8Eon1AykSxliGvJKp653asF1vUkBx/VMWdpUiphfrI5Zazu17Cu7QWNejc5q3nW0bx0CUrmRi+rYPro945MtK+QGoQysg/lw/KuE61umvVru81pkbp2QwshGaU7yQlpjBmr2X/i3URx8Lf9rF21RbKOFWsGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Z/K4B9X; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Z/K4B9X"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-78e9f48da30so18743476d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294494; x=1758899294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
        b=0Z/K4B9X5738MGfMqOKpD3WwNb4cORUHDzzxhKW2ALgC8FHrV92lpbWZysSIn3rAvU
         OOxG0s5hAKICwoSHQbBGyu+1rk8Jiz7C54Fz2cKjwOQxfrQmvCk80zTlwcrO7toIyAoV
         iamrutRis37nYKihP89VXeTlNZisi3Uv/c9SP+3WwQe1V1ObPBivW7CtXFID3BVMdKXK
         uCCAJEvD4yZot5OjUvWW1CGWaCDMYfVvDOys7+8jgEd1v2/BtuMQOLoKS9UO1w6ne3cH
         7q3zlEyQkVy4j8TM+VqyEErbsbayT75fJzv6lVZOAOfiIgGRz8t4dJB2BC00ZkGwcTWq
         qBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294494; x=1758899294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFmZTAQu6xp1H90eoajASSZ3CmnWB3SEwm5mOewzT+c=;
        b=p9KdKpT61Q2uzYdTxpea8vbILckqAwq09ZzWhlAfWHRWX7xQQYpZOwSJ6ucFNILD5P
         ppFOYunfpazVrOVPbmXZzX8KrWp9rng++uRVwIRHumjGYuR36DrFIm+63/wBUXM4ARk1
         VIThrm1YtV+vvsdkzIZzzR/7tNtRc9r+nJWDu68DQeQTL4894BR1Z2KYfdAPgFVGjMTY
         IJf3qrt3w5bx2Azltv5kL0ywytjHKQUYIVh8mUq4l3z5Zmmx/7sCWFIZCaKIEq0F5zoO
         aqplmNOXmFtmfsgtmHQ19Yyaycz5CPBGzvvD4YlwVmKfOe+u1z9edvivVP3OG1sE0Ivv
         664Q==
X-Forwarded-Encrypted: i=1; AJvYcCVg6vgs8PpJoBFiPWDmSltlpYk336ScTK6Tr5hmWAkz+RlWiMwG12iV1jlReVckTBEm37J2jRYETjotUzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK8eGOcat8wCvL8DrM5iLW6d/bxbILS8BktE0uN5yLNUMniT1S
	6ze4Nv6CcKGrFLVzf1P7bIJB74ZNIgAkAdiHIulvlBeNwWpWbtZkmKUzZmitxFpkDwoV0r4bcoH
	wcvBVtv6cPfmGRSOF5tjsXBgoonEAn7idpovl7Nk2
X-Gm-Gg: ASbGncuQ+F+QftSgbg6jif8JRR8VDcdOZmJUoUJq2zS76KMBiJufHtN8UQKgWXwXaeP
	uP28qub7ya6SfkwZblGVigxg1P/JEeIG1/I6x2O5ZZXAkYBdVGrpZFadq5fX3cna6hikSZWrmeh
	HGp1QCb7Yk3R9edorx7s0Gdw9X+vy2Y7BwaQVb8p5uxyhkn81gpwSOnCxJpqHyUTAWJeVSQxIpy
	mGHqd+iDsgz+qhj/nHfEl4zUhTKR/Bi6IgRlw==
X-Google-Smtp-Source: AGHT+IFR40Mffz39BAytKY3HCLacxnJ1WKp/TI2KMqqv5ab7iIIVbpHo/r7oLhpjnTyf+invw9UKbqtbStpZDWCH5zU=
X-Received: by 2002:ad4:5d66:0:b0:710:e1bc:ae42 with SMTP id
 6a1803df08f44-79910e91071mr49973476d6.10.1758294493230; Fri, 19 Sep 2025
 08:08:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:07:36 +0200
X-Gm-Features: AS18NWA8NT9J6yW558WFqJ9v7KlWvLUFu5ioEKltNkloZ03huDtjBzwZEdnYYKc
Message-ID: <CAG_fn=VVWKR0JLCTZ8HvB51UX3EYrFg1s_xD-ohOKDQwDHOxHQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for load_script
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest target for the load_script function to serve as a
> real-world example of the framework's usage.
>
> The load_script function is responsible for parsing the shebang line
> (`#!`) of script files. This makes it an excellent candidate for
> KFuzzTest, as it involves parsing user-controlled data within the
> binary loading path, which is not directly exposed as a system call.
>
> The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
> how to fuzz a function that requires more involved setup - here, we only
> let the fuzzer generate input for the `buf` field of struct linux_bprm,
> and manually set the other fields with sensible values inside of the
> FUZZ_TEST body.
>
> To demonstrate the effectiveness of the fuzz target, a buffer overflow
> bug was injected in the load_script function like so:
>
> - buf_end =3D bprm->buf + sizeof(bprm->buf) - 1;
> + buf_end =3D bprm->buf + sizeof(bprm->buf) + 1;
>
> Which was caught in around 40 seconds by syzkaller simultaneously
> fuzzing four other targets, a realistic use case where targets are
> continuously fuzzed. It also requires that the fuzzer be smart enough to
> generate an input starting with `#!`.
>
> While this bug is shallow, the fact that the bug is caught quickly and
> with minimal additional code can potentially be a source of confidence
> when modifying existing implementations or writing new functions.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
