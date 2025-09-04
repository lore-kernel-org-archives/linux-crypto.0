Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2EC2D12E3
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 09:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979990; cv=none; b=GjgD+1I5AY82LPQyJb4/uYpFu5xoRP4Rsygzz1lT/pMmvKNIaroEdW9GYVcMSnSw/8zkD4VzwQQHh2/EYL1b8ie7FmH8L3xdj4H2SEsBxJBSnyGaCmTFUgBWwc6Z4JxkGBwi3JR+Vl2Q66A91TIjuklv4rCdj6kQZV4WnOnjtvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979990; c=relaxed/simple;
	bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ULBH93UnYtlFnSF61gFU1Hg+7eM+Jkdxm7/mEYFgvFMhmc8BxMER458il/zT+tpq7Yq2q0+ssqtqonkf1nDoJL5tSlRa5jQXxm0KSgiHJBqWkuw1498WJqmDxosb3qNs4cquwUZweCkS3T2HI5u36G/R3h8F+fneR/KoTK8b8tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BOBrub+T; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BOBrub+T"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-72631c2c2fbso9551996d6.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Sep 2025 02:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756979987; x=1757584787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
        b=BOBrub+TZH5c0OUCABsKHFUkeq5pzsdHdC9K/lhEN4bUf1YJ1uuDMpE2pICrQfZEIO
         2fxvd9Olpa8eKI+vJAOwYereBVW6Rvbwn8uvHmNr8AzowOzqvKwlkrsZ3qPHrO3O1lzq
         W3YHwCx6Iu94jTdm/nHN1Hbv4Um0xBlHeUidptcmPHhBorNOUZlK0rlLkcCAfocK8ElO
         cxnjU0vpglG7bR13fyBq0fYw4waiWVMQa6psOhFgxo4dsyMAOeliQWpTs/nFtNxnQt6O
         lE0to02yF9DYQ5pbu30E+gBb4MNo0XsYS3j0pOqIA3Jwt9fE46BTfeEc/7Syva+J8Jex
         KLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756979987; x=1757584787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHOpn0x1n+X9bJMJ6KJ/yl+og8/86ttoBXUy6mB0ey0=;
        b=rzoufmqUAuDuwV83q40QS6zG5CMfgDxZXKCT4w5gebqumEAkzeXqDiGVYiJs6X5pRC
         r1U0CSQPaxBnbY/KYMdcfOekA1MqM8UFylmWN8d0Axcl6wRmnIAHw153ljFHjEJCQqzS
         QWryBJ6r4AV+YXdboVgHNRQZYx16nmcNZj6Fe/1pKjVYJh6AZC6UzRE9uDOAL713Em1c
         KK0TaKEHBeqkZ448HU+HWRpWVyWLcoNcBScnk2mYIvcPGr7Zf7oL9eClUUWTMiwjFseA
         4Zp9xgj6ianGGmkOQwRGTJirl9Vj4X/lmv42ZTniq23WTKlcIgiVnxOKG6edSfqb5upf
         XbWg==
X-Forwarded-Encrypted: i=1; AJvYcCXyzYLSGQjuWZRg2JUNqcfT+yUqK5iUvoo4p6rjeQz57oUVq2ZF5EcM1giJu2ODuctMlGR+vJ4/5fDrBro=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyuVRoC2hXyFbuozvdtm9Ge4MqdQsup4IEUIvUYnog7FzBun6o
	CMyiEEt8Z6dlRt10Ghfg4e0spF4JB1Arg+DTbOKHQbmHcUk5psNJm9rQ+6iBzlKjAohMooQga8y
	lnWTjzNJFtUjVYxM9Ue9pJPNM2dXCYy0ZyXPd7IC1
X-Gm-Gg: ASbGncvJTR+PsgO5piz00eFh8dJsgfyB3Z/a1c8ImrWUqxvGhx9rs4NHxmSctzdOIdg
	Q3b7v5V1FKfrCwH03CpzvGq0AWti1idCYTx3ia3i0NaODiKUaF2Rk3jrhKvSab1CrGnp1vLq3Sg
	a6ruBYX8+Hmgh/LsJ4K5g9JBFer2zr+hJlTYXyHJlDnSKs9F/FM7WuyQAMJhdOFa3JHk0MoM/Bv
	dgf3X7Zs+QwsPCVepAZgs3rWnEyQ07f67MhfyTnwmVJl+eJlDKuAg==
X-Google-Smtp-Source: AGHT+IGT4Lm1UEnlQ2bizwHe4ELvu4hzuE9iFObagSCtHAbdLbsZpQZ4v6gnTYWZ5T4wkKXfEhUwpiekj7TMD6WN37U=
X-Received: by 2002:a05:6214:e41:b0:709:c7de:ce70 with SMTP id
 6a1803df08f44-70fac700db8mr222215406d6.10.1756979986529; Thu, 04 Sep 2025
 02:59:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 4 Sep 2025 11:59:09 +0200
X-Gm-Features: Ac12FXzQlIV_NpJ1rduhtC1FclDh1AxIHe380g_TpXDcw3vnB7j2ZNk2kb8WbdI
Message-ID: <CAG_fn=WJrdSr_6u770ke3TxyFimuMXXeTSQhsDR73POy4U8iug@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 6/7] kfuzztest: add KFuzzTest sample fuzz targets
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 6:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add two simple fuzz target samples to demonstrate the KFuzzTest API and
> provide basic self-tests for the framework.
>
> These examples showcase how a developer can define a fuzz target using
> the FUZZ_TEST(), constraint, and annotation macros, and serve as runtime
> sanity checks for the core logic. For example, they test that out-of-boun=
ds
> memory accesses into poisoned padding regions are correctly detected in a
> KASAN build.
>
> These have been tested by writing syzkaller-generated inputs into their
> debugfs 'input' files and verifying that the correct KASAN reports were
> triggered.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
