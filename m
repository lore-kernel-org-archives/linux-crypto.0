Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16337425CFE
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768915470; cv=pass; b=oIlg+XSeCWzfqxkMOhBlVqF1OUBZXnci3PG5fmkL2KC5k2Gskj1I6neBw2bp/p6/xsY6paKBRdBiU1FKtTgLR8VsQOtjkfHhoNhT9b7VRdb0UDsMN/4YIAVsCgem9ddxGQSruJYDjjJcmb5A1USBI9cqnS5lwmoECXdpNuzqBD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768915470; c=relaxed/simple;
	bh=ifyIZmUcoqP4AYnRLk1FJhnUEF4kgE3SN65ZgMTmws4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z6LX7/3F2wo6PWCRr8QnCCVkhcNlWN910vu0GYCywqwRVpS4KgRe+8m8GTumtAAWG7GB9Xsh6BSRE7YevR53/lqEu/LWtAT6sjfRT8C/up0neENbJ4oOXXpiu/dFFlsWAOfZMFh8XgD6E/URE/MGc5kZNMpSOlUjOrw+lTbLp88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCtKFzYK; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCtKFzYK"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c6a7638f42so675805985a.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 05:24:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768915468; cv=none;
        d=google.com; s=arc-20240605;
        b=aRsdWzPX1wB0sU3oj1UE4SyaqOaEEUBhVOnNVAip0MISRJ7tnYpqmzW8dL6FlBTpr2
         UgsVzeOkxPKBsrmG9fSpAzpGNgWRlyFMES7i8w1PZHocZpmiA39N5oJa30eFNO4ybtgA
         QYDESb3PxXNsoTwvjJnPA0eXZf56kGNNGh59wh7PxcwIMDAPhuDkPtPyTEtCljuFp2OO
         L1Jr1Dv/C4V8cMC1sWkNGo7VXwvpLmS6hz8be6BVhj9g2oMpVw1x85XcvA0eJWiCrVol
         dAA6ejyvgUgLJRtBa/TCXpYwoZ85SX40EXZp9nKrKjFJfhGJFxSa92O/LahFOlapwGJH
         j99w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        fh=Eyta76gst2whjf/xtI2D4IFLHF3xXno+HD/DBhJ7SNQ=;
        b=GAe/Jb7ZSKs0bjtrrGyR+JyU2fiqw5dszJ0idGR2VgR36PnHRZz0nzqnXB0AiMQ+bN
         L0/swofauE46BBD84uX/lVV27T9bGHYBht4DEqfp0FQR/gQ0/uW+ycWF9v1qbbi76P/1
         j2pF/PGvAs5VNcItKmny2SsGBCOZVK3fhPdAXSJU3g5sOwZbYodtQHeTy2sQZf6XIAPS
         AJl02Wt7aj4Ki/5z5Qs5cGEp/HaWJMlwPh9Kl3XcYTnSAZa50fwfUWqTqeiWbh4Z6liD
         X/Obc3NXrwCRGP9o+jK920Yc+JHzR8P91bc5WPMfprEZfR7DBQuKXNjzmogBfmBm500E
         fjFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768915468; x=1769520268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        b=XCtKFzYK1iIk8nJwvks8CUfWgFSCxof7BVxo0lEl6uOfVTr0tXUqRIyBowOuo6d+lt
         tZ09NkxwHO5wezB9ebIC0hBtPOweeHB2kds9YS2/QoJ8BNPVL4oNEcxKz85nCiv0yNOP
         ByhkYfGaY1z+OYcImVodvwjg3nzWIgS1ZdI8EA/TY745936lNh94vTFGSVY6l8t+lj9E
         AndzDOCzunBJC3K+H2ArGJD3LLVCPjeOBkk23Ly4TDkDLjRNDW3DxNSVFWiNMifVG0Q/
         PQtYBTM3aeNN5dnMHwdU3ZXw6MIpVMmE5w2bWMfALVr1MmshNDRTwdNz6fH32m0E9zmS
         ECwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768915468; x=1769520268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4nu4xZEY0rSvLbxW/bG040Gc/VM91yZ6fjUuBWMnaOo=;
        b=oUbTkNlpfIfHl16BM1mwPzzpieHuEZT5HSbacv581YQxogLcD3F0a4i0u+vCEsNM5y
         dKodikqcyoklo4iDjlhSx7cFfzOWga03AOkgONQFrnt3U7M91zMf3SJJhbYjGmGo3LwY
         2FRhQ1dX6Mm9lHZKQQ56CUvQtkl/MZWiUGqWUKYVjNK4pwfW1Q2SCxk0ml/Q5zDlzyzp
         OSm6H/POvAZpHW+ZjOquEoItdEXSyxJuvw4hVlvhu59ceVpAr1TUSXMMrvwWIOYaFHD3
         3ZfesfSunCEBbhud111R9Pgrm3CzQT0gQ/ToBI4A4e/IotFmR/PPa8i1Lf22UhoE6BH4
         1AEg==
X-Forwarded-Encrypted: i=1; AJvYcCVzs8nBG7tAJi8xtBn7OGQ1lYQoUflN+dNmZJ7StvO9451Hlghm4V5hFwFJiZ+mxrNz0bTLyqymBvQ7qFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT4ZWSTEhEuy8AdnsKJSyAIOdleT5ptCFkSsRmj8xW/85t29M/
	KvTcYcAV8FysMPAdW2DRTVnfdT1bMMIrwfrx31cUpLmCCsnCq7CNlu91QUxIYkyhm50QNgmZl+f
	YQUcot3Tq7MqSvOsazn7VfKDKIrNz2fjMkR9fxHnk
X-Gm-Gg: AY/fxX7tcc/ybcz2a9iS3wfF7Yjkc6nN+F6KimU8XjypJcFYt5GyKfx4Jx4qOeg2TPP
	Gfr8EqratWlF5/2mmif7ju51rxXkqiFsZNmebN9Ec59P99L/F+cO2fO/5SRVcp2ETFK+Tz9GA58
	rEU9dLSiNuOr1Vbs+SR4IR0+OMvnJIGWK65T4qfr6g0Gi+SHYuzmjSHeI0Apzea+CBpbn2nGLUw
	bx/r2LEp5f7f71aOZx3PoLWtswuXWT75yIQuom5iVAgaIbpvb8uuaZjxTNakcIttmYdepw0ycu6
	6rWKajrIJ2f0pVQ5dnfVq+N8jqTuRX022qk=
X-Received: by 2002:a05:620a:a819:b0:8c6:aaf3:cb44 with SMTP id
 af79cd13be357-8c6aaf3cd9bmr1776741585a.4.1768915467445; Tue, 20 Jan 2026
 05:24:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 14:23:50 +0100
X-Gm-Features: AZwV_QjW2mQ_xeztIGqfilZWMz9KqTXvzLTRYEAqSaJ4no1YJpwzVkinmD1XMRA
Message-ID: <CAG_fn=U46vT+gOAX1D1RxDP3oaduWbsRMs2RWG99U2ND+BM_Vg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmli=
nux.lds.h
> index ae2d2359b79e..5aa46dbbc9b2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -373,7 +373,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPE=
LLER_CLANG)
>         TRACE_PRINTKS()                                                 \
>         BPF_RAW_TP()                                                    \
>         TRACEPOINT_STR()                                                \
> -       KUNIT_TABLE()
> +       KUNIT_TABLE()                                                   \
> +       KFUZZTEST_TABLE()
>
>  /*
>   * Data section helpers
> @@ -966,6 +967,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROP=
ELLER_CLANG)
>                 BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
>                                 __kunit_init_suites, _start, _end)
>
> +#ifdef CONFIG_KFUZZTEST
> +#define KFUZZTEST_TABLE()                                              \
> +       . =3D ALIGN(PAGE_SIZE);                                          =
 \

Can you remind me if PAGE_SIZE alignment is strictly required here?


> +
> +#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)

Right now KFUZZTEST_MAX_INPUT_SIZE is only used in a single C file,
can you move it there?


> + * User-provided Logic:
> + * The developer must provide the body of the fuzz test logic within the=
 curly
> + * braces following the macro invocation. Within this scope, the framewo=
rk
> + * implicitly defines the following variables:
> + *
> + * - `char *data`: A pointer to the raw input data.
> + * - `size_t datalen`: The length of the input data.
> + *
> + * Example Usage:
> + *
> + * // 1. The kernel function that we want to fuzz.
> + * int process_data(const char *data, size_t datalen);

Maybe we'd better use u8 or unsigned char here for clarity?


                                \
> +               void *buffer;                                            =
                                               \
> +               int ret;                                                 =
                                               \
> +                                                                        =
                                               \
> +               ret =3D kfuzztest_write_cb_common(filp, buf, len, off, &b=
uffer);                                          \
> +               if (ret < 0)                                             =
                                               \
> +                       goto out;                                        =
                                               \
> +               ret =3D kfuzztest_simple_logic_##test_name(buffer, len); =
                                                 \
> +               if (ret =3D=3D 0)                                        =
                                                   \
> +                       ret =3D len;                                     =
                                                 \
> +               kfree(buffer);                                           =
                                               \

Please ensure we have includes for everything used in this header
(e.g. linux/slab.h is missing).
