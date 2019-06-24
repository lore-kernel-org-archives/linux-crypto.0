Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02B0C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B27E208C3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GT0ywkN6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfFXOhh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 10:37:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33755 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFXOhh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 10:37:37 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so914391iop.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 07:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8t2dI3qcQHJ03st0n/Xa4z9xUhlY5mkfwBdJ9AK0hb4=;
        b=GT0ywkN6dZdrUPXDLfalysL0wv0r19AWbL4Zby7v/a5CZKA5R9z2PZbMfLiDlgtLlo
         Xj+PWHGAoNCCdI+/VCBkivmZN7ruZQyVsS/PUtG6FqEAhVYc6HDHR0xvQUf7nLcw2Uc/
         wXvBqaH1Mt8CufOobp7I2xaUtGM0iog2CqoX5oqgHRkDKJ7cNGGNtyqIgV8lpS1iVXvF
         f+5Y7/uOsvB6w0+8oP3k9clyKULFn2PUD2w933FBZNhEVC9cASUrqHGhAsJBpoaL1Noe
         g3MqJPHHVMOCetv0mEFzpj5nwGqPtWn6/+eMsTjSDe9H8Cz7PM6HvBWPqzdmjn6d4jN4
         0wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8t2dI3qcQHJ03st0n/Xa4z9xUhlY5mkfwBdJ9AK0hb4=;
        b=t09bnrKHSXQmvkzNLPZeh1H2fAgMFgFgj6LLpRT/JkJp/hamMFA+vOziVn1qRzPw25
         XMs4eKtYxWeq9ZLoiZTWY+GXYXOCMe6jXY/1fHPy7wmtY5MbjeAa7ZiDWiU9tPt+x3bL
         r+pG5vCLxtKfI+twtTj/gwhPbR9rVZFlH0hKU0/7aGYJZBXvuX8cc6H2hEEVMB4/leH8
         sSMc1krH5snl7teYhdO7/IzH2bMLiQ4/HE7ofxXYJyajzZQOKTtAjsieD0xUAeNHEuva
         8FzeToV17ic5BEO/UyFpl+OT0DCC/36FaJiJcas7NZZ2I6D7HPRPa6V1+xJGdkI/eXh+
         OFaA==
X-Gm-Message-State: APjAAAW0lN6GZKsMp0ktvqWMmj/tdIY0NPtbG1MOsKyDUHlM6SQw0gbB
        +wAJ0ebdG8TliTuUU0ze1CoyVElr+q6RhBbt9mfe506XIMk=
X-Google-Smtp-Source: APXvYqzThl3l6ewnU4Zyr8pwLRNTMEXCKxpGLr3u+l8OupJIXWgOokRIzTky0FyGc6ws5GFPfPEEV7wS59Cxfl4Lw6A=
X-Received: by 2002:a02:1a86:: with SMTP id 128mr26144285jai.95.1561387056479;
 Mon, 24 Jun 2019 07:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org> <20190624073818.29296-6-ard.biesheuvel@linaro.org>
In-Reply-To: <20190624073818.29296-6-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 24 Jun 2019 16:37:25 +0200
Message-ID: <CAKv+Gu-6KX-=N9=GykoPQgppAZTZ=2a4RNcCZyQwuE9YPKV=Eg@mail.gmail.com>
Subject: Re: [PATCH 5/6] crypto: aegis128 - provide a SIMD implementation
 based on NEON intrinsics
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 Jun 2019 at 09:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Provide an accelerated implementation of aegis128 by wiring up the
> SIMD hooks in the generic driver to an implementation based on NEON
> intrinsics, which can be compiled to both ARM and arm64 code.
>
> This results in a performance of 2.2 cycles per byte on Cortex-A53,
> which is a performance increase of ~11x compared to the generic
> code.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig               |   5 +
>  crypto/Makefile              |  12 ++
>  crypto/aegis128-neon-inner.c | 142 ++++++++++++++++++++
>  crypto/aegis128-neon.c       |  43 ++++++
>  4 files changed, 202 insertions(+)
>
...
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 266a4cdbb9e2..f4a55cfb7f17 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -92,6 +92,18 @@ obj-$(CONFIG_CRYPTO_GCM) += gcm.o
>  obj-$(CONFIG_CRYPTO_CCM) += ccm.o
>  obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
>  obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
> +aegis128-y := aegis128.o
> +

This doesn't actually work when building a module. I'll have to rename
the .c file so that the module that combines the objects can retain
its name
