Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DDF341AD8
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918935; cv=none; b=ANsAQRmYS+e3QSaB3kmpzhdXtorZIRKR6sEn5nEK44vFnAYLxDHMmghppwFiAtWom2xGOcFUdoPrFmQO/mZgikiGx/8t7M94XhdzrohIDKJ5DEfEGAVLMWQtwRcTN4UeszcFDdo0c/aGVFmMyMmzKp6Ipof5reuOeyIjjG1uC5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918935; c=relaxed/simple;
	bh=v3VvIeq1kalKsC6WM5dMlVLengQEPJKTqscmAdyMeYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RXz7JoqJ7zA5Xgrdcx8FVt0SkwhEU2okCN3u4zkuqSz3NDm96zps1smQsorXjY4Jm2Y6XWxyOITGED86uc5PKst3MzZfXgA+BNtT7hghyshNv/u8sTlRPyTMTXeIyQ9+J86a8Qg8ZJ/06iIbtehc8DxlTULxOx4HcAIlLB8pfIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cob1Qxz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cob1Qxz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F97EC4CEF8
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761918935;
	bh=v3VvIeq1kalKsC6WM5dMlVLengQEPJKTqscmAdyMeYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Cob1Qxz39lpi2xIg4Mj3s4Gz1VcIl4/pAX6C8duKOD5RssUYSdDtdhPKHSrnAoIu5
	 dg26ILKtrkjhcG9IlQZGPYX/7SPzrnpItbS1qq0f4A7M3CEYli+ALSHlnQTIBCZcPy
	 oylytXG4+riabH80DYVVETBVMeFyC8nDH1J465jqDAw5CKhjPCLesGcQhpjWDiGaYY
	 AjlcLU7PrLvxyIqS+tNN9x+b9Ic4V+rP/Va6RQbiyTiDOWTQU95xqxTmWNRXc4Pp7p
	 HxXA6ZDu+VZhIRqPg1ssftD/pqD/aqCWIGRtoqmQvr/kMtxlRzRDtFjl3RJX5UvfMY
	 OjfBevp9hlmfA==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-58d29830058so2907224e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 06:55:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXKd45VIws7v/s0qlsQ/bJyyZix+oMJZNteKCsbxlq/qPSsiGb7d9T5yIKUWaNMWPo0gclHOFDnr1eJiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm00NLwBXhdcQ8R8mcM/Ak+UNJjTYlssYFjQa9smYxHOL+hEov
	M5EJSDp6MDrpXaCUhBsHCTdYhcy47T7jBBJ3exWowanx7b5p+7L5flPFnEFKKlXY3JSft1p+bZZ
	qMG9HxwftDqy2wwHrnVcljNLhPhi5BNM=
X-Google-Smtp-Source: AGHT+IG1bte6snjK1s3dK2Umz9uoYmGqVGgRP20JEm9bJQ/H77GL9ShEJSh/fhD2EeRJZGQNy75zI3xS5uaxX1JUBlE=
X-Received: by 2002:a05:6512:1247:b0:592:f601:641c with SMTP id
 2adb3069b0e04-5941d51804amr1532755e87.13.1761918933518; Fri, 31 Oct 2025
 06:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com> <20251031103858.529530-39-ardb+git@google.com>
 <20251031135235.000007cb@huawei.com>
In-Reply-To: <20251031135235.000007cb@huawei.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 31 Oct 2025 14:55:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH+3F7qeYEtOYmNFyLgkuAQ9N6UZBf69CmQde7AiRY-6g@mail.gmail.com>
X-Gm-Features: AWmQ_bmr9chj-sk4Yy6yeLAmYJTGZ-449jqdx9KPPiSXON9Geeejeh87JQ5JRaE
Message-ID: <CAMj1kXH+3F7qeYEtOYmNFyLgkuAQ9N6UZBf69CmQde7AiRY-6g@mail.gmail.com>
Subject: Re: [PATCH v4 16/21] crypto/arm64: sm3 - Switch to 'ksimd' scoped
 guard API
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Oct 2025 at 14:52, Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Fri, 31 Oct 2025 11:39:15 +0100
> Ard Biesheuvel <ardb+git@google.com> wrote:
>
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Switch to the more abstract 'scoped_ksimd()' API, which will be modified
> > in a future patch to transparently allocate a kernel mode FP/SIMD state
> > buffer on the stack, so that kernel mode FP/SIMD code remains
> > preemptible in principe, but without the memory overhead that adds 528
> > bytes to the size of struct task_struct.
> >
> > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Hi Ard,
>
> Trivial comment inline.
>
> > ---
> >  arch/arm64/crypto/sm3-ce-glue.c   | 15 ++++++++-------
> >  arch/arm64/crypto/sm3-neon-glue.c | 16 ++++++----------
> >  2 files changed, 14 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
> > index eac6f5fa0abe..24c1fcfae072 100644
> > --- a/arch/arm64/crypto/sm3-ce-glue.c
> > +++ b/arch/arm64/crypto/sm3-ce-glue.c
> > @@ -5,7 +5,6 @@
> >   * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
> >   */
> >
> > -#include <asm/neon.h>
> >  #include <crypto/internal/hash.h>
> >  #include <crypto/sm3.h>
> >  #include <crypto/sm3_base.h>
> > @@ -13,6 +12,8 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >
> > +#include <asm/simd.h>
> > +
> >  MODULE_DESCRIPTION("SM3 secure hash using ARMv8 Crypto Extensions");
> >  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
> >  MODULE_LICENSE("GPL v2");
> > @@ -25,18 +26,18 @@ static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
> >  {
> >       int remain;
> >
> > -     kernel_neon_begin();
> > -     remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
> > -     kernel_neon_end();
> > +     scoped_ksimd() {
>
> Why does this get brackets unlike other cases?
>

No reason other than the fact that some time passed between writing
the other patches and these ones, and there is no functional
difference.
