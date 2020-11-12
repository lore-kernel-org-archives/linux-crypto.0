Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DEAC2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659C621D91
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKK9rsj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgKLVtI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 16:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbgKLVtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 16:49:07 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF74C0613D1;
        Thu, 12 Nov 2020 13:49:07 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id ec16so3637978qvb.0;
        Thu, 12 Nov 2020 13:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GTBxlYQh5nK7nuyz9GGz2QSLc5KQMNKbZAAgKPoEC3k=;
        b=fKK9rsj4CvaN2DPz1cBj7XsP+v5XxbmJo8FHWUSJ0NYBrRhR/M/p9ZgB4w/0kCRu0b
         I9f05fYfq3Nv4XujegwmomNA74izSISXA0f7qWNM9WyLQK0LF0fGRQ8bwydXeg94zCbF
         rIoc4N6NKq9NGfkKO9MAbq5IaEXGrL/rktHCqIlAqQ3X+QcyImmsIFaW7d/8zrl51C+t
         vVOftIDacF5je0Gr5zFrd6wf+PkHWiq7xOd5RUiisDgDFZAt490w3HVOEEjgQJu40OiO
         FjumuZtDFX962ngsT8tX3mRR/b11dRCfYKieDYEd96tUWbGteDeh6WhqU9RPSh3gdh3C
         tJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GTBxlYQh5nK7nuyz9GGz2QSLc5KQMNKbZAAgKPoEC3k=;
        b=EWrLw7Hz/PApCSgECmUqY0iL4J/1J91tE0OfnjpJC5Y1qAuoSAhq/veC4djt6Ittcc
         bf+Swg7dA6gcf0KTQOCT2fMzyH7hv6ooV/BFnOY6hrOh/0yFFfF5NnDLv5nzatbOZOFF
         oFiSGM8Ctkduz62Fu6PvFXJQ4enH9v/QoBQvOSp0TlSzCCucqjgBUkQRI/WyuBNzY0/m
         mhCvci4WxQ4VJniYPXYF8ezCAy+zJ2ZR1Q5wwqmuc0AJYM0zzO6uaWFdMj7EJLBMUGEi
         G5ZJwAGQOGgEsOwlzg3OXQ4ui5I8Gpod+AlXveZG3butrgC7Rbqf9XtaxhOjpsfoUdeR
         ki7Q==
X-Gm-Message-State: AOAM5320mCu0v5OJmuRWTC+zmCi95AnpniuYayB0XlPUv67yG/D123hZ
        moZVl7UlsGvP+G+dWYWxMew=
X-Google-Smtp-Source: ABdhPJxcOg2KLEYNQ1bBChObUM230IiBCufytpEN2hLidCmfBNtvWiRPtPR6uz6w/oLWahM0vunObg==
X-Received: by 2002:a0c:99e1:: with SMTP id y33mr1838033qve.62.1605217746580;
        Thu, 12 Nov 2020 13:49:06 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 5sm5479575qtp.55.2020.11.12.13.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 13:49:05 -0800 (PST)
Date:   Thu, 12 Nov 2020 14:49:04 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR
 in crypto4xx_build_pd
Message-ID: <20201112214904.GA3194701@ubuntu-m3-large-x86>
References: <20201112200702.1664905-1-natechancellor@gmail.com>
 <1f5e8575-ab7e-59ea-6be7-0340df4d31c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f5e8575-ab7e-59ea-6be7-0340df4d31c5@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 12, 2020 at 10:21:35PM +0100, Christian Lamparter wrote:
> Hello,
> 
> On 12/11/2020 21:07, Nathan Chancellor wrote:
> > Clang warns:
> > 
> > drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
> > lower precedence than '|'; '|' will be evaluated first
> > [-Wbitwise-conditional-parentheses]
> >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> >                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
> > drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> > around the '|' expression to silence this warning
> >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> >                                                                           ^
> >                                                                          )
> > drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> > around the '?:' expression to evaluate it first
> >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> >                                                                           ^
> >                   (
> > 1 warning generated.
> > 
> > It looks like this should have been a logical OR so that
> > PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
> > is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD.
> Yes. This probably wasn't spotted earlier since the driver doesn't make
> use of CRYPTO_ALG_TYPE_AHASH (yet). This is because the hash accelerator
> setup cost was never worth it.
> 
> > Change the operator so that everything works properly.
> I'm curious if this is true. Is there a way to break this somehow on purpose?

I do not really have a way to validate that statement, I just figured
that the operator being wrong meant that something could go wrong that
was not intended.

> I've extracted the code from line 921 and added the defines
> (the CRYPTO_ALG_... from the current 5.10-rc3 crypto.h and the PD_CTL_
> from crypto4xx_reg_def.h) and replaced the u32 with uint32_t
> so it runs in userspace too:
> 
> --- crypto4xx_test.c ---
> /* test study - is it possible to break the | vs || in crypto4xx's code */
> 
> #include <stdio.h>
> #include <stdint.h>
> 
> #define CRYPTO_ALG_TYPE_AEAD 	0x00000003
> #define CRYPTO_ALG_TYPE_AHASH	0x0000000f
> #define PD_CTL_HASH_FINAL	(1<<4) /* Stand-in for BIT(4) */
> #define PD_CTL_HOST_READY	(1<<0) /* BIT(0) */
> 
> uint32_t func_with_bitwise_or(uint32_t alg_type)
> {
> 	return PD_CTL_HOST_READY |
> 		((alg_type == CRYPTO_ALG_TYPE_AHASH) |
> 		 (alg_type == CRYPTO_ALG_TYPE_AEAD) ?
> 			PD_CTL_HASH_FINAL : 0);
> }

Looking at this more, I think the only reason that the code works as is
is because PD_CTL_HOST_READY is 1 AND CRYPTO_ALG_TYPE_AHASH is not used.

(alg_type == CRYPTO_ALG_TYPE_AEAD) ? PD_CTL_HASH_FINAL : 0 is evaluated
first, which results in either PD_CTL_HASH_FINAL or 0.

Then (alg_type == CRYPTO_ALG_TYPE_AHASH) is evaluated, which is
evaluated to either 0 or 1.

Then we mask everything together:

PD_CTL_HOST_READY | (0 || 1) | (PD_CTL_HOST_READY || 0)

If PD_CTL_HOST_READY was anything other than BIT(0), we would have an
extra 0x1 in the mask. That realistically might not matter, I did not
have a full look over the code to see what this might mean. If
CRYPTO_ALG_TYPE_AHASH was used, it could be used over
CRYPTO_ALG_TYPE_AEAD and PD_CTL_HASH_FINAL would never get added to the
mask, which certainly sounds like a bug.

> uint32_t func_with_logical_or(uint32_t alg_type)
> {
> 	return PD_CTL_HOST_READY |
> 		((alg_type == CRYPTO_ALG_TYPE_AHASH) ||
> 		 (alg_type == CRYPTO_ALG_TYPE_AEAD) ?
> 			PD_CTL_HASH_FINAL : 0);
> }
> 
> int main(int arg, char **args)
> {
> 	uint32_t alg;
> 
> 	for (alg = 0; alg < 0x10; alg++) { /* this is because CRYPTO_ALG_TYPE_MASK is 0xf */
> 		if (func_with_bitwise_or(alg) != func_with_logical_or(alg)) {
> 			printf("for alg_type:%d, the bitwise result=%d doesn't match the logical result=%d\n",
> 				alg, func_with_bitwise_or(alg), func_with_logical_or(alg));
> 			return 1;
> 		}
> 	}
> 	printf("logical and bitwise always agreed.\n");
> 
> 	return 0;
> }
> --- EOF ---
> 
> Both gcc (gcc version 10.2.0 (Debian 10.2.0-17)) or clang (clang version 9.0.1-15)
> version always gave the "logical and bitwise always agreed.". which means there wasn't
> anything wrong and this patch just makes clang happy? Or can you get it to break?
> 
> Also, can you please give this patch a try:
> --- extra-bracket.patch
> 
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -932,8 +932,8 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
>  	}
> 
>  	pd->pd_ctl.w = PD_CTL_HOST_READY |
> -		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
> -		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> +		(((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
> +		  (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD)) ?
>  			PD_CTL_HASH_FINAL : 0);
>  	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
>  	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
> 
> ---
> I'm mostly curious if clang will warn about it too.

It does not with that diff. I guess it is entirely up to you which one
we go with.

> That said:
> Reviewed-by: Christian Lamparter <chunkeey@gmail.com>

Thank you for all the analysis and taking a look over the patch, I
appreciate it!

Cheers,
Nathan
