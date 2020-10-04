Return-Path: <SRS0=YnP8=DL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC7EC47095
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 21:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D87772078A
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601846185;
	bh=1/fg8uWl3pmlAi0Q2vkVcGSaTYg3h3TSf7CL3PVW6XU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=uouDjqMT1azduoR6s6s4vZvrCR8F0k0ivkHrTdVh+2Ng+Y9WILStsIg41bgAS05lQ
	 TiElyPkbBCY4AhGIbVZAZYcAL3YK05E4sTcyBgUlc1ycrnhHUAuaGzu+h8ziYylGxl
	 qLdU/QEx8RhtMKLZ9R6lAZyizpaKHbUrCKLZytQk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgJDVQW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Oct 2020 17:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgJDVQW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Oct 2020 17:16:22 -0400
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7B7206DD;
        Sun,  4 Oct 2020 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601846181;
        bh=1/fg8uWl3pmlAi0Q2vkVcGSaTYg3h3TSf7CL3PVW6XU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uTK+erHhSMum0+TGO/vLDyFgcw5IsFcym9B07ZCSVM+GDdZqJE2PVTasSn/qc8Q2c
         ZByi2Iws3yyNhmEdaX8jj+6pPdrEanjwSMN5AiIpwAcOEGugcLz7CdEPW2oJE7cnlA
         b76kJyaa7ebB7QmvBqy/R8HwAMoO1gyJ9bad5ieY=
Received: by mail-oo1-f46.google.com with SMTP id k13so1775743oor.2;
        Sun, 04 Oct 2020 14:16:21 -0700 (PDT)
X-Gm-Message-State: AOAM532E8oK3LWjHfFPEKArFodkuIhJQ9ANFYhJuoxOfcHlYtOn0M9K+
        9qzT5ox08kZ5/FQUhMWZ+ULrV+79Tg/FVXV90s0=
X-Google-Smtp-Source: ABdhPJzbSIfSBAxeJ/fBJn3YGgIvi4EOvZt7/umB0jBhBQeEQ8eh0nOR6qLVF9wMfUk6r7mTDuaJvIKYlt8QX7pK2KQ=
X-Received: by 2002:a4a:c3ca:: with SMTP id e10mr3026860ooq.41.1601846181147;
 Sun, 04 Oct 2020 14:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200930065617.934638-1-palmerdabbelt@google.com>
 <20201002064905.GA27115@infradead.org> <5692716.lOV4Wx5bFT@positron.chronox.de>
In-Reply-To: <5692716.lOV4Wx5bFT@positron.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 4 Oct 2020 23:16:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com>
Message-ID: <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 4 Oct 2020 at 20:48, Stephan M=C3=BCller <smueller@chronox.de> wrot=
e:
>
> The RISC-V architecture is about to implement the callback
> random_get_entropy with a function that is not exported to modules.

Why is that? Wouldn't it be better to export the symbol instead?

> Thus, the Jitter RNG is changed to be only bound statically into the
> kernel removing the option to compile it as module.
>
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 094ef56ab7b4..5b20087b117f 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1853,7 +1853,7 @@ config CRYPTO_DRBG
>  endif  # if CRYPTO_DRBG_MENU
>
>  config CRYPTO_JITTERENTROPY
> -       tristate "Jitterentropy Non-Deterministic Random Number Generator=
"
> +       bool "Jitterentropy Non-Deterministic Random Number Generator"
>         select CRYPTO_RNG
>         help
>           The Jitterentropy RNG is a noise that is intended
> --
> 2.26.2
>
>
>
>
