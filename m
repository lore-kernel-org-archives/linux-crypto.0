Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0A1C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Oct 2022 12:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiJSMiM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Oct 2022 08:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiJSMh5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Oct 2022 08:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB121929B9
        for <linux-crypto@vger.kernel.org>; Wed, 19 Oct 2022 05:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666181821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UwAADYaBhMI4DLZZZOIrDaoebmjiM8VensEpVYKYeQg=;
        b=TdDQwTwMCq7dYNeuHsaiMYES/YLoNR/nrNDv769VkdCygPLPOPTDIq5iFRWYJ/oQ3GPri6
        4zFYZOsL9Wpb5Fz7/3RdJRaU3F5h9et+o8k+7NJduivZ3rXmOj8lxowWJXTw96wVJ1a9Uh
        BSFfBpWFbt3R0G7rYP9Kno1GdlnkQts=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-wwnOITPFNoGd9Y7kIkxLgQ-1; Wed, 19 Oct 2022 08:13:26 -0400
X-MC-Unique: wwnOITPFNoGd9Y7kIkxLgQ-1
Received: by mail-lj1-f198.google.com with SMTP id s7-20020a2eb8c7000000b0026fdd80df37so5337295ljp.23
        for <linux-crypto@vger.kernel.org>; Wed, 19 Oct 2022 05:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UwAADYaBhMI4DLZZZOIrDaoebmjiM8VensEpVYKYeQg=;
        b=kcRDGQ/QqoOOaGQxVKxS04ljhpTfdoVUMOEUADaX3JPqUb5guFTwmCmH7jbldr/KZ6
         SeurrTGxM1ijDFHCSDQ82VI2HVu0iH4RBuNYCbNAX5dmB2juv+NSq9LmLxnz+ELos+nF
         vsoZAIICN+129MVw6sf36UMfGwn9AT6R1u24z7COfUXraft9cp3bSqoYx2H/mbek969a
         UPz4KamBeUNSMlKkCYs9buVbait+mBJmESLXhA394vamyYdO1M62i3Pd9YNGZnY1eqvD
         oMDUaOXQiRyVzyz5j/tLg2pE7vgqI2SYfAmwROGIA9nQiQpGOoYkrsMYSE55f6wMOAAg
         rgIg==
X-Gm-Message-State: ACrzQf2N8qpKl7cLZP9wZQr7uRzHj/T5i84P3Ltwgar0XJmQ7kUqf0it
        676ierOFtRoTD1EfLdlxz/BbzbrQAEkHBu55liRoVxpRfqhdpBVvxAH4/QRh4wS42I3w51cvcfO
        XaeJiiJSlP35mXxdcLwxTvwz38VBg7dnuwvpZLncO
X-Received: by 2002:a2e:b8c6:0:b0:26f:b759:66d2 with SMTP id s6-20020a2eb8c6000000b0026fb75966d2mr2746651ljp.37.1666181604380;
        Wed, 19 Oct 2022 05:13:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6q0sj1zanPLyVRx95568WePqRixtwb+79ruFpim+/PnSCAKjmCpcYePqVUNMfxQgZcmjGBVvlzMBymxooDa/Y=
X-Received: by 2002:a2e:b8c6:0:b0:26f:b759:66d2 with SMTP id
 s6-20020a2eb8c6000000b0026fb75966d2mr2746641ljp.37.1666181604075; Wed, 19 Oct
 2022 05:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <Y08rHF09/qxCVK+K@sol.localdomain> <20221018230412.886349-1-nhuck@google.com>
In-Reply-To: <20221018230412.886349-1-nhuck@google.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Wed, 19 Oct 2022 14:13:12 +0200
Message-ID: <CA+QYu4qqkczCnRf=ATztsw-=KQvXg_8-4fjoh5V5tEmtkUKWhw@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: x86/polyval - Fix crashes when keys are not
 16-byte aligned
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     ebiggers@kernel.org, ardb@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Oct 2022 at 01:04, Nathan Huckleberry <nhuck@google.com> wrote:
>
> crypto_tfm::__crt_ctx is not guaranteed to be 16-byte aligned on x86-64.
> This causes crashes due to movaps instructions in clmul_polyval_update.
>
> Add logic to align polyval_tfm_ctx to 16 bytes.
>
> Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
> Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  arch/x86/crypto/polyval-clmulni_glue.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
> index b7664d018851..8fa58b0f3cb3 100644
> --- a/arch/x86/crypto/polyval-clmulni_glue.c
> +++ b/arch/x86/crypto/polyval-clmulni_glue.c
> @@ -27,13 +27,17 @@
>  #include <asm/cpu_device_id.h>
>  #include <asm/simd.h>
>
> +#define POLYVAL_ALIGN  16
> +#define POLYVAL_ALIGN_ATTR __aligned(POLYVAL_ALIGN)
> +#define POLYVAL_ALIGN_EXTRA ((POLYVAL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
> +#define POLYVAL_CTX_SIZE (sizeof(struct polyval_tfm_ctx) + POLYVAL_ALIGN_EXTRA)
>  #define NUM_KEY_POWERS 8
>
>  struct polyval_tfm_ctx {
>         /*
>          * These powers must be in the order h^8, ..., h^1.
>          */
> -       u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
> +       u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE] POLYVAL_ALIGN_ATTR;
>  };
>
>  struct polyval_desc_ctx {
> @@ -45,6 +49,11 @@ asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
>         const u8 *in, size_t nblocks, u8 *accumulator);
>  asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
>
> +static inline struct polyval_tfm_ctx *polyval_tfm_ctx(struct crypto_shash *tfm)
> +{
> +       return PTR_ALIGN(crypto_shash_ctx(tfm), POLYVAL_ALIGN);
> +}
> +
>  static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
>         const u8 *in, size_t nblocks, u8 *accumulator)
>  {
> @@ -72,7 +81,7 @@ static void internal_polyval_mul(u8 *op1, const u8 *op2)
>  static int polyval_x86_setkey(struct crypto_shash *tfm,
>                         const u8 *key, unsigned int keylen)
>  {
> -       struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
> +       struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(tfm);
>         int i;
>
>         if (keylen != POLYVAL_BLOCK_SIZE)
> @@ -102,7 +111,7 @@ static int polyval_x86_update(struct shash_desc *desc,
>                          const u8 *src, unsigned int srclen)
>  {
>         struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> -       const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
> +       const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
>         u8 *pos;
>         unsigned int nblocks;
>         unsigned int n;
> @@ -143,7 +152,7 @@ static int polyval_x86_update(struct shash_desc *desc,
>  static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
>  {
>         struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> -       const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
> +       const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
>
>         if (dctx->bytes) {
>                 internal_polyval_mul(dctx->buffer,
> @@ -167,7 +176,7 @@ static struct shash_alg polyval_alg = {
>                 .cra_driver_name        = "polyval-clmulni",
>                 .cra_priority           = 200,
>                 .cra_blocksize          = POLYVAL_BLOCK_SIZE,
> -               .cra_ctxsize            = sizeof(struct polyval_tfm_ctx),
> +               .cra_ctxsize            = POLYVAL_CTX_SIZE,
>                 .cra_module             = THIS_MODULE,
>         },
>  };
> --
> 2.38.0.413.g74048e4d9e-goog
>

Thanks, this patch worked well for me.

Bruno

