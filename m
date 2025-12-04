Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4B926B777
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862005; cv=none; b=B3r5HNx50qAp4CguHAw38ALbe2aF++uJqtzDq+F/WqNSh8po6YdpbTzKYPEQf4QG3vlQgaaqgsvuQ/K4FfbtDhqSyz/fRRy+Mo4NUFWw9U6wFuA+j5rIu2EtilYw5/8jCkp/ZCkHmhhC4XP1uAGQc6vMTLdIo4TG8+mWnFz1tdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862005; c=relaxed/simple;
	bh=EHJ/Uvi1Nnp5iTXNu29uC7C+96Kv3WpdEYpqBQ6/1ZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CoaD5vU362ud1gpHNcjFXYdhB9ad/PTgGYoJY/x7XpLmv1qr6vDrh5/OjHLgbsg9nCiqn5ZxigCk4Pd+GTrUpjgAAm1MLVt46nIORizM3hanx1VJPUQQ/I7fwpiv6xTnFh5LxAJjEphuTjSfAtoH5HKTT6+vZ6ihDyBcun+S9LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFcixpaG; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFcixpaG"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7633027cb2so175586166b.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862001; x=1765466801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRDq8VRZX7ObisK4LUGIJP6XjIFCzmZAVr9+RtuDKSA=;
        b=gFcixpaGtpew+3ZmTL7QV/kw3nLtMLDpQrwweu2iElPG+eEylYEwwydGUFHkY0rsJp
         VG7bnY5Zw6KVCuXCvOV1LrhS5VZQnmTI9FCXRnA5jd71NUEk26xFTwuZT9XPi3VGaWuf
         zOUeiPJo/9T58xYpjnbMQ2lW5FoPOJcmp5q1ufIjeeC3x3tG8iTJpdwrPnNlvsNuG+C+
         9QYgjrbJ4strXWa7B82dj9KnEcMYBkF730jc4v/uKTHyE7FZy35TqEMLCc8EbnYL46s0
         Yy26f5wE4LW0CBVrI6rvAqKix/mUHFCJHLt4RoQxRrY2/OdnCLzXIFfhM/sCXk8Wi/um
         5lfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862001; x=1765466801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRDq8VRZX7ObisK4LUGIJP6XjIFCzmZAVr9+RtuDKSA=;
        b=NIn3m1Sta2mGQXRMlwoggcl3xzCVzQYbGRvisAhjqhld8T92aNrS5/p1UR8euTO5l6
         UxdJ1wxqNQVZcwm5VaXForIu6vCY+Bnp37K3eX1EUPM+6U8nLpl184O+PbgPDXaoYAhG
         qxLaCJ5gfeBQu/IRz4USKT0xPAg5JaC6XMtUHX54m0sChzXNT9r2s6dA+bB+SD6GXe1t
         8lFgiD8zPCJYoo1DoHjdwan6ggWAU443QEVBDb9VMh5h1CJYwcgazYqtjiFODYiAZbaE
         6nwUSnvSkCVFT2kpZZtO/HG6PqpBccd+pHwkEx9esAHJCjJRskCw3cYZ2HYei3vm8H5P
         N2yg==
X-Forwarded-Encrypted: i=1; AJvYcCXaf3iL9TxW20FMucNToPL0JWNgJAQayvXbqd/zvAtTOXSQfk/r6UhEsCk7G+pkzFV6tsvM/Cdh9b59Vbk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4uo08rhL4gQ8fVJqeZcYZj1VltVJPMUiXvU93Y0sn4wnX+aAA
	Qbhb6/p3gI3j0ghUHGDu3EuDntGDRfaK962e2KgNwknQSXizUVg/Xm+d4+nxh4oW4SkPoH/0FiN
	J9wOdcm8+M7kxeiGpGzOlbCQxP87zePY=
X-Gm-Gg: ASbGncs7JanNQRdBao9Aa6BTPU0djaj6JSPmUtyPudfIIliuFbs296x3QL5ND7DAY6w
	umkzttJsHU8AKYviKJyXe7XgrIqVhUy4FuCEbHuLGMZ6vWa3wyx94zIYecsbx49twnJWt1PW0fL
	I6k2FIomKSEbL1WTx+aqotf5NfIHo4AAm7Fj3t30GJE/l7yZFq2rwXMpipmMbWoIkofi4MmXhFW
	SGZYBdB6Je/qQ953bnotcAMDdpBk7R7WQS8i/5IPV8Att9pmeh4qbDCbCwKINaeMKuyH4NT2hcL
	kdFM/eoSAlWs+8Z3HD6L1tvIBKxOvkxj+xWtjpsYRn/k2mXZ+18Rd1p2AfiRSthIGQTQuMg=
X-Google-Smtp-Source: AGHT+IHf4+6vdMmQuH6atM/AUDdteHFf5jPA5YYue6DOqMU4c8+wmNtqOkyMXD6oyoIIyUvm8ALQ6uS3zQy9c2rbSf4=
X-Received: by 2002:a17:906:6a09:b0:b73:210a:44e with SMTP id
 a640c23a62f3a-b79dc51af33mr666433666b.30.1764862001190; Thu, 04 Dec 2025
 07:26:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com> <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
In-Reply-To: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:26:05 +0200
X-Gm-Features: AWmQ_bmIoeQpAWoaWpHaqI6dnG4PTWdKQq3rnGgG66adF0zPHqO5BwO2Z5x6PEQ
Message-ID: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 4:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.

drivers/...

(no leading /)

> To validate the correctness and effectiveness of this KFuzzTest target,
> a bug was injected into parse_xy() like so:
>
> drivers/auxdisplay/charlcd.c:179
> - s =3D p;
> + s =3D p + 1;
>
> Although a simple off-by-one bug, it requires a specific input sequence
> in order to trigger it, thus demonstrating the power of pairing
> KFuzzTest with a coverage-guided fuzzer like syzkaller.

fuzzers

> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

I believe one of two SoBs is enough.

> Acked-by: Alexander Potapenko <glider@google.com>

...

> --- a/drivers/auxdisplay/Makefile
> +++ b/drivers/auxdisplay/Makefile
> @@ -6,6 +6,9 @@
>  obj-$(CONFIG_ARM_CHARLCD)      +=3D arm-charlcd.o
>  obj-$(CONFIG_CFAG12864B)       +=3D cfag12864b.o cfag12864bfb.o
>  obj-$(CONFIG_CHARLCD)          +=3D charlcd.o
> +ifeq ($(CONFIG_KFUZZTEST),y)
> +CFLAGS_charlcd.o +=3D -include $(src)/tests/charlcd_kfuzz.c
> +endif
>  obj-$(CONFIG_HD44780_COMMON)   +=3D hd44780_common.o
>  obj-$(CONFIG_HD44780)          +=3D hd44780.o
>  obj-$(CONFIG_HT16K33)          +=3D ht16k33.o

Yes, this level of intrusion is fine to me.

...

> +++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c

So, this will require it to be expanded each time we want to add
coverage. Can this be actually generated based on the C
(preprocessed?) level of prototypes listed? Ideally I would like to
see only some small meta-data and then the fuzzer should create the
object based on the profile of the module.

Input like:

bool parse_xy(const char *s $nonnull$, unsigned long *x $nonnull$,
unsigned long *y $nonnull$)
Or even with the expected ranges, and then you can generate a code
that tests the behaviour inside given ranges and outside, including
invalid input, etc.

But okay, the below seems not too big enough.

> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * charlcd KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <linux/kfuzztest.h>
> +
> +struct parse_xy_arg {
> +       const char *s;
> +};

> +static bool parse_xy(const char *s, unsigned long *x, unsigned long *y);

Is it still needed?

I mean, can we make sure that include in this case works as tail one
and not head, because otherwise we would need to add the respective
includes, i.e. for bool type here, which is missing. Also I *hope&
that kfuzztest.h is NOT Yet Another Include EVERYTHING type of
headers. Otherwise it breaks the whole idea behind modularity of the
headers.

> +FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
> +{
> +       unsigned long x, y;
> +
> +       KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
> +       KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
> +       parse_xy(arg->s, &x, &y);
> +}


--=20
With Best Regards,
Andy Shevchenko
