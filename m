Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A200EC4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 23:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7263323A21
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 23:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgLGX0Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgLGX0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 18:26:23 -0500
X-Gm-Message-State: AOAM530+0U/eIc8TN3l+hpeROhOfDJCRjH4mvmMjC6wJ4P4LPl2Sad41
        xB9QsIEr3jnQo3GOBJaXF2A/t2/ivaKo6bqfzcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607383542;
        bh=1DUL/oz0Zec2pO+/hYfI39RYrWnIW40L053+WnZaPYE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=neFwU26Y+8/nUfCO20y0Nvpe1PmRB3om83JwaFLZH8yvMsQbEIzwhQDqau3djB6JH
         Yi+fbjeQvFHzPGSRccb/nWrjWCYi6J5Icd0mXSTubRUGo3bJlJudg/z55fno1nLIgp
         y7Dd66tAjtL3wb1Xn8KuG9AJEGTpfz2qgxbc51eRo7YWOtkC4OUSekfnNbQmlHsEdS
         S1EpoBkA9yNbOL9M/9vMFP0aV2vtYY1HGxFFS+zy8BJwiO+eb824jVkMeNwwUruRa0
         MZKU4yav6ULKo1XKdoEX5IEjVNNQu17+Gcq0uLCtZn1CyRvP6VoHiU/g0EzoG1mpDv
         DbRBoSN+CxIEQ==
X-Google-Smtp-Source: ABdhPJyNUSbulYzbmmt2B+9lTRcfej0KjoZ7Nz6oEv2MDwEyMSrWi102qEBxpSia1dEIMUNSNhzZ2jC6kd9VxRsqAuM=
X-Received: by 2002:a4a:c60c:: with SMTP id l12mr12716735ooq.45.1607383542056;
 Mon, 07 Dec 2020 15:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20201206224523.30777-1-ardb@kernel.org> <X854h5CjaI8ru7PT@gmail.com>
In-Reply-To: <X854h5CjaI8ru7PT@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 8 Dec 2020 00:25:31 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGx7epED2rcwYz89GK-gfjktjLwRiGN_HLLui=M8f-84w@mail.gmail.com>
Message-ID: <CAMj1kXGx7epED2rcwYz89GK-gfjktjLwRiGN_HLLui=M8f-84w@mail.gmail.com>
Subject: Re: [PATCH] crypto: aes-ni - implement support for cts(cbc(aes))
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 7 Dec 2020 at 19:46, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Dec 06, 2020 at 11:45:23PM +0100, Ard Biesheuvel wrote:
> > Follow the same approach as the arm64 driver for implementing a version
> > of AES-NI in CBC mode that supports ciphertext stealing. Compared to the
> > generic CTS template wrapped around the existing cbc-aes-aesni skcipher,
> > this results in a ~2x speed increase for relatively short inputs (less
> > than 256 bytes), which is relevant given that AES-CBC with ciphertext
> > stealing is used for filename encryption in the fscrypt layer. For larger
> > inputs, the speedup is still significant (~25% on decryption, ~6% on
> > encryption).
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > Full tcrypt benchmark results for cts(cbc-aes-aesni) vs cts-cbc-aes-aesni
> > after the diff (Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz)
> >
> >  arch/x86/crypto/aesni-intel_asm.S  |  87 +++++++++++++
> >  arch/x86/crypto/aesni-intel_glue.c | 133 ++++++++++++++++++++
> >  2 files changed, 220 insertions(+)
>
> This is passing the self-tests (including the extra tests), and it's definitely
> faster, and would be useful for fscrypt.  I did my own benchmarks and got
>
> Encryption:
>
>         Message size  Before (MB/s)  After (MB/s)
>         ------------  -------------  ------------
>         32            136.83         273.04
>         64            230.03         262.04
>         128           372.92         487.71
>         256           541.41         652.95
>
> Decryption:
>
>         Message size  Before (MB/s)  After (MB/s)
>         ------------  -------------  ------------
>         32            121.95         280.04
>         64            208.72         279.72
>         128           397.98         635.79
>         256           723.09         1105.05
>
> (This was with "Intel(R) Xeon(R) Gold 6154 CPU @ 3.00GHz")
>
> So feel free to add:
>
> Tested-by: Eric Biggers <ebiggers@google.com>
>

Thanks!

> I might not have time to fully review this, but one comment below:
>
> > +static int cts_cbc_encrypt(struct skcipher_request *req)
> > +{
> [...]
> > +static int cts_cbc_decrypt(struct skcipher_request *req)
> > +{
> [...]
> >  #ifdef CONFIG_X86_64
> > +     }, {
> > +             .base = {
> > +                     .cra_name               = "__cts(cbc(aes))",
> > +                     .cra_driver_name        = "__cts-cbc-aes-aesni",
> > +                     .cra_priority           = 400,
> > +                     .cra_flags              = CRYPTO_ALG_INTERNAL,
> > +                     .cra_blocksize          = AES_BLOCK_SIZE,
> > +                     .cra_ctxsize            = CRYPTO_AES_CTX_SIZE,
> > +                     .cra_module             = THIS_MODULE,
> > +             },
> > +             .min_keysize    = AES_MIN_KEY_SIZE,
> > +             .max_keysize    = AES_MAX_KEY_SIZE,
> > +             .ivsize         = AES_BLOCK_SIZE,
> > +             .walksize       = 2 * AES_BLOCK_SIZE,
> > +             .setkey         = aesni_skcipher_setkey,
> > +             .encrypt        = cts_cbc_encrypt,
> > +             .decrypt        = cts_cbc_decrypt,
>
> The algorithm is conditional on CONFIG_X86_64, but the function definitions
> aren't.
>
> It needs to be one way or the other, otherwise there will be a compiler warning
> on 32-bit builds.
>

Ah yes, thanks for spotting that. I couldn't make up my mind whether
to bother with 32-bit support or not, but I think I'll just add it, as
it is rather straight-forward.
