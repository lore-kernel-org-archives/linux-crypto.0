Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFC9C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D382D214AE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fHsLEEI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCMKcK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:32:10 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40441 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfCMKcJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:32:09 -0400
Received: by mail-io1-f65.google.com with SMTP id p17so1175051iol.7
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eA6+rOwsm00cLBKSpkx4jaMhHNZZ6PvNPXAbQEg1QgE=;
        b=fHsLEEI8u9P68xH4oM70hf68mJbKVLPFivsTHqydIZTlqTQuOvgYrZkrwSGrVTLMx2
         K6ZrGdHBMSvY9KHM/d6qZoc0QblX9Cx9+/bn+LFrCzydtTSzHqP6J3ynxweIWh6vfKmp
         hlvF2TwiDQp6yJ9WXcvTw8TSMvGeUBTFvthVdNLOcuMQ0leYtCHm1QDiTx0wKKaLLiqi
         HnbfCAvKJPr5C3zz2vQe/fCZ5YPOXVgqA3HzHjLqCITHQf/V/Apd4oWGdwpFuJmyy5q0
         omMxuWsAetgPpEBC2NtWO8+RcessnIZR84hFg1Hub0XTJgiZjCuAk5Zi3Oon/8EeDZ0v
         6dvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eA6+rOwsm00cLBKSpkx4jaMhHNZZ6PvNPXAbQEg1QgE=;
        b=P1uZhxolVN9ixi7XBhU5UqkveU1f7zJcOWHhWkaXpw/l8Tu/HJDBWOvGE8cUbn0yb5
         0gws8GNxFFrTsGboE542Il5kgif9Ag9vevgJFWDC5J3iYIv/moNHViNZYocb5atJLUDB
         nU6+wrPVUlJj4iUP0Kp4SsVR1xoiApg+x0clE2GMxPfHigQghFUnC3EZ/5Fl+snpjb0o
         FcFNEDh5uclUrxtsmQZfSgJj7FlnAW41st0LGpUmKlwNoJ9gOgztLZgP4xdnzwBU3kmX
         /wNoROcSdWmS4HxvTN5bnTcrwZBpGZTXEX9/h466ldeS+Atd7PA7D/9V7C+A2DBwn2ey
         Lx9A==
X-Gm-Message-State: APjAAAUdwEN7hKfnjINwzjAv1rBsj79xsX+eAvR6NpxQqbeXvvpLBX48
        RvtpzmhyMefk1w4YOQXMtuP0FtmwwbLQopB8TSySvA==
X-Google-Smtp-Source: APXvYqweQZl/vz7ZiZ1xiVkAxziTTIwqzQoZtP5wKi1p6GtIOePHFMIlv0Oii8ppPQHURoPHruFjwARPz81c3VqMNCE=
X-Received: by 2002:a5e:9b17:: with SMTP id j23mr5832014iok.60.1552473128411;
 Wed, 13 Mar 2019 03:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-4-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-4-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:31:57 +0100
Message-ID: <CAKv+Gu_LBa9Rf+0i3V3o86wC+vWtoqP+9Wn681W2Kzmkg0tjHQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] crypto: simd,testmgr - introduce crypto_simd_usable()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Mar 2019 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> So that the no-SIMD fallback code can be tested by the crypto
> self-tests, add a macro crypto_simd_usable() which wraps may_use_simd(),
> but also returns false if the crypto self-tests have set a per-CPU bool
> to disable SIMD in crypto code on the current CPU.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/testmgr.c               | 26 +++++++++++++++++++++++++-
>  include/crypto/internal/simd.h | 24 ++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 5d56b2990762..52417dde811f 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -37,6 +37,7 @@
>  #include <crypto/akcipher.h>
>  #include <crypto/kpp.h>
>  #include <crypto/acompress.h>
> +#include <crypto/internal/simd.h>
>
>  #include "internal.h"
>
> @@ -52,6 +53,9 @@ MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
>  static unsigned int fuzz_iterations = 100;
>  module_param(fuzz_iterations, uint, 0644);
>  MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
> +
> +DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
> +EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
>  #endif
>
>  #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> @@ -838,7 +842,27 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
>
>         WARN_ON_ONCE(!valid_testvec_config(cfg));
>  }
> -#endif /* CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
> +
> +static void crypto_disable_simd_for_test(void)
> +{
> +       preempt_disable();
> +       __this_cpu_write(crypto_simd_disabled_for_test, true);
> +}
> +
> +static void crypto_reenable_simd_for_test(void)
> +{
> +       __this_cpu_write(crypto_simd_disabled_for_test, false);
> +       preempt_enable();
> +}
> +#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
> +static void crypto_disable_simd_for_test(void)
> +{
> +}
> +
> +static void crypto_reenable_simd_for_test(void)
> +{
> +}
> +#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
>
>  static int check_nonfinal_hash_op(const char *op, int err,
>                                   u8 *result, unsigned int digestsize,
> diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
> index a23b18b6ad61..d2316242a988 100644
> --- a/include/crypto/internal/simd.h
> +++ b/include/crypto/internal/simd.h
> @@ -6,6 +6,9 @@
>  #ifndef _CRYPTO_INTERNAL_SIMD_H
>  #define _CRYPTO_INTERNAL_SIMD_H
>
> +#include <linux/percpu.h>
> +#include <linux/types.h>
> +
>  /* skcipher support */
>
>  struct simd_skcipher_alg;
> @@ -42,4 +45,25 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
>  void simd_unregister_aeads(struct aead_alg *algs, int count,
>                            struct simd_aead_alg **simd_algs);
>
> +/*
> + * crypto_simd_usable() - is it allowed at this time to use SIMD instructions or
> + *                       access the SIMD register file?
> + *
> + * This delegates to may_use_simd(), except that this also returns false if SIMD
> + * in crypto code has been temporarily disabled on this CPU by the crypto
> + * self-tests, in order to test the no-SIMD fallback code.  This override is
> + * currently limited to configurations where the extra self-tests are enabled,
> + * because it might be a bit too invasive to be part of the regular self-tests.
> + *
> + * This is a macro so that <asm/simd.h>, which some architectures don't have,
> + * doesn't have to be included directly here.
> + */
> +#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> +DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
> +#define crypto_simd_usable() \
> +       (may_use_simd() && !this_cpu_read(crypto_simd_disabled_for_test))
> +#else
> +#define crypto_simd_usable() may_use_simd()
> +#endif
> +
>  #endif /* _CRYPTO_INTERNAL_SIMD_H */
> --
> 2.21.0
>
