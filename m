Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068FBC41604
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 16:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAEE8206F7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 16:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602002085;
	bh=a6c5AwcMG5F0F44sSkXP47hn4g9OAP1pGzRVxT9fZ14=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tcTXbAUTyxR9fDP6U6quDMAuuB0E+1DXGJ9hpbq5UnMS+m+nGSonWkieZLJvH5hiT
	 ARViMhyiXPmE5UFv90rII7upllMAPr8M6/Njt7qKPWYM9CW3MQo3k1HIjuY5EyBuIC
	 OZ7gIjLg7GcA1JGq+50KT/DgGca8ZlSmsp9IWmsE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgJFQep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 12:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgJFQep (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 12:34:45 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC59206F7;
        Tue,  6 Oct 2020 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602002084;
        bh=a6c5AwcMG5F0F44sSkXP47hn4g9OAP1pGzRVxT9fZ14=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FVHFKTW6F3/juhC64tTd2pkxFiLqZ9ZXjgSX+d4xa3S4dKlgl3D2nNDalX1RByCBj
         wBGZBbD53wuL4QVkp1b4aZye3B8O7kwI+pL0V9AjvP6ncCpBbfZ0fd234eFe9h+SX7
         /yxN75F6IKyrjbeo5S20n8aMhMSfXklU794qaasY=
Received: by mail-ot1-f54.google.com with SMTP id m13so12853388otl.9;
        Tue, 06 Oct 2020 09:34:43 -0700 (PDT)
X-Gm-Message-State: AOAM530MuIIqqqPMfIkOk2Y2bUK2bY/l0qC6Smaj5DLJT8OcTgjgqfWF
        BiFaNu8ic5cS6fP5k1/CXMKYNdapkx2jZtSzfbY=
X-Google-Smtp-Source: ABdhPJw5KQAXRlVPQg9ZdjXpTLUuvy51c/pdIVFCuNf2LMbDc4tZDOHyaCfYc1/f5xk6JJ9TWzhh29U6IqxShlda+Yw=
X-Received: by 2002:a9d:335:: with SMTP id 50mr3296908otv.90.1602002083171;
 Tue, 06 Oct 2020 09:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201006163326.2780619-1-jeremy.linton@arm.com>
In-Reply-To: <20201006163326.2780619-1-jeremy.linton@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 6 Oct 2020 18:34:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFexXNEmF0O0eQYLw_4vMr7_kxS+g0BAEgMb0B1jfJHnQ@mail.gmail.com>
Message-ID: <CAMj1kXFexXNEmF0O0eQYLw_4vMr7_kxS+g0BAEgMb0B1jfJHnQ@mail.gmail.com>
Subject: Re: [BUG][PATCH v3] crypto: arm64: Use x16 with indirect branch to bti_c
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 6 Oct 2020 at 18:33, Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> The AES code uses a 'br x7' as part of a function called by
> a macro. That branch needs a bti_j as a target. This results
> in a panic as seen below. Using x16 (or x17) with an indirect
> branch keeps the target bti_c.
>
>   Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
>   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>   pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
>   pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>   lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>   sp : ffff80001052b730
>
>   aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>    __xts_crypt+0xb0/0x2dc [aes_neon_bs]
>    xts_encrypt+0x28/0x3c [aes_neon_bs]
>   crypto_skcipher_encrypt+0x50/0x84
>   simd_skcipher_encrypt+0xc8/0xe0
>   crypto_skcipher_encrypt+0x50/0x84
>   test_skcipher_vec_cfg+0x224/0x5f0
>   test_skcipher+0xbc/0x120
>   alg_test_skcipher+0xa0/0x1b0
>   alg_test+0x3dc/0x47c
>   cryptomgr_test+0x38/0x60
>
> Fixes: 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/crypto/aes-neonbs-core.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index b357164379f6..63a52ad9a75c 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
>
>  0:     mov             bskey, x21
>         mov             rounds, x22
> -       br              x7
> +       br              x16
>  SYM_FUNC_END(__xts_crypt8)
>
>         .macro          __xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
> @@ -806,7 +806,7 @@ SYM_FUNC_END(__xts_crypt8)
>         uzp1            v30.4s, v30.4s, v25.4s
>         ld1             {v25.16b}, [x24]
>
> -99:    adr             x7, \do8
> +99:    adr             x16, \do8
>         bl              __xts_crypt8
>
>         ldp             q16, q17, [sp, #.Lframe_local_offset]
> --
> 2.25.4
>
