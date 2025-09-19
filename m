Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EF8257855
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758294474; cv=none; b=bwrqiXC+JMbobQx5ny27QS+f0Wki4rR7QT0TbKoqZ20Gr7zWNWYqf5SqyoelkvCsjzGq/WRTL5jEcO9FS5cXEkMv/JuFFrokanxjlwBRHQCvf395JDm3/CciCQGNunUUho1mpamL0mhb//awEa0/rrdH8F+huW/K9t28QvcAkcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758294474; c=relaxed/simple;
	bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zg4oi/hoBVvbxz0MeyenS1GSnpEkn2tW1aFWIoiyYOQL3hU8prJuR1BUb8qE3ovoUUvhyeS8ODkgZ8i80N9SatKAV8DAcGseUzMwC8iqUA71rF7vyHAZcnzdCWQ5sdSAApCBj5MJgyeqjDp1UCrfihu3QgoJeKYn4ESQHxc3nz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GIYfUn5R; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GIYfUn5R"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-79390b83c7dso18488116d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 08:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294472; x=1758899272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
        b=GIYfUn5R7QznP9L9wCkjPaVtUpqOfnlhZTcJPugiJEH0RXeZa+xEpc8MEo1O0/eiMQ
         DIk8h7dBJFnwZPQ55ajLsI2C7HB3mrwsXQYLi6aCYp1DsgCBZCRNlfb69EqnFE33fvWZ
         ZmwK3tPLOBedyWgVuTTahkzqDW0e1yDoX6whSCwYanCpJvsPAF5/Dy2jC266S578hmra
         4F53p7jbD7DsiCkGEvdUetIF9+bXUr9+q1Hrv6hzhhKlbgK88BWoVj2RfIjClrSpuqLu
         E7OtlXQPGVDfkwZES8ynT/Fv7OY+rFfqi22HGwbJn8BI7vRzBPgxf915xiX0BbhK3RHB
         gsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294472; x=1758899272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
        b=UIJLqcsMKRJ9lm6pZc8G/yNl2MoDWap4kx5oE6nlT1rJowEM2OTb7hb3Drg56Q+QXN
         oxC5osPRp9PM6qa8WQ+XiM4HxrWrEH134hHuy6sYQuY+EXW7mhPT81NYkTj+jhW2Dukw
         zirumvKHFp8Ke6uvktnotxnXQbRzwYVUlRhQa4sd4YD+uvvrdA6N6KwbvFYCT1PHSjCG
         x+e+MAhyXx3Mq1GbYcJFWZ8xnI4nZXS694uiZLHvu6tgoaRgY9gR58DeiI+NjDvTKu22
         Dj+zwGuuk7es58nNLhiI9Pve9LpnGBmMWsjVxSGNN6TwK/EgvIASDu1IbKigXBLhCWpg
         MAZw==
X-Forwarded-Encrypted: i=1; AJvYcCWQhygumA8Zq/wz1ukQDPUvHFA02G/6cN0odECf9fMRn0aAvEzkv5mX8Box0RwZNyLWuMNN7+qW8OC8ZfM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq2l2AwgYJFjfR8EorYGj3PNWU+z4tThRSeKNglYrOaQ5nr1Pm
	vEkRV4GvoK6rxc4fpHx57+FQVJSOj6Eh5MdOopE0q6DA2zMfJGp+5i1WF7UMC9MWZnr2wfaP3eM
	RaUJvvKBskwxuH6qccs3RkkpgCBkY17E8A8LAsmqQ
X-Gm-Gg: ASbGnctCZAE49J8cSqBNIthUT7bHrA2FIT41OryFccrkQ66gmU9n3osxAUQYXj3J7Zg
	94la1VsfPmlYT5NCyiPIogArD1J01Y84DU8JIoGQt5RrA3d7mLI+J83cSkTYpvdRkWAp7KD3Z65
	rbd9pYOhxASXvWInt1XEWoaaSx9qj8IiOfeXM9+w6OAbEYcWq9WY/Ta5aGuLlzSDzog7e0WCeK0
	zwERlhZ3MBMbb8pDYKy32kagONSerbqQgxb2w==
X-Google-Smtp-Source: AGHT+IFrJzJuFA3uDy0oX1I+l6xaOubdUHrA6zUrrdRHERulJyx2tdaDsHhWPYomdV64GyBaRo1A+0ilKwtQxafKibQ=
X-Received: by 2002:a05:6214:260a:b0:780:24d7:fd35 with SMTP id
 6a1803df08f44-7991b0db9bfmr38784486d6.43.1758294471475; Fri, 19 Sep 2025
 08:07:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:07:14 +0200
X-Gm-Features: AS18NWCM6kR1_nk7adaxFawciRK7byb-Gyk4MeMsfOVVpcb45qo2C2pvMXupxjs
Message-ID: <CAG_fn=Xvkz_-UGuR8_4Jb_9HmwQn7dTHdJuDRe6usZX61CF0xw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
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
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.
>
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
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
