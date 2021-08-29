Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05273C432BE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Aug 2021 06:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF65A60F25
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Aug 2021 06:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhH2Ggl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Aug 2021 02:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2Ggk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Aug 2021 02:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5013A60F3A
        for <linux-crypto@vger.kernel.org>; Sun, 29 Aug 2021 06:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630218949;
        bh=gouh2jUKjraaXw/3WQe6g+nWymHOqcJ2u0l1N3+mCqA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MDNvM6+paTOLNzq+9xma1UkaN1M6PBfyOA/SZyuXPrMjNI8f3+kkJxYQcuXPylPpw
         iogXU4l0QBcq1jo2Kk+ku4nFgMd6mvAk6RgmUmcXA5QtWkJ+0R6AI/T5SIygAmJWL1
         0dhEINtpfWMZq42Iy5ec8JUZ1hoe2jX4mFE5rEStuy/PAg9SYOPEYT5lhXVBL436bT
         l33oSruzE5zNfA2SYOcjrCuPy4fwPzb5zCrcZ6LeP/yKVYQEgAZMALuzgR7ihksyrG
         hi6H3gwNtF/V41Z713YwxOwY6QA18zBdOMxUj8eSHFvTO8xeCTf51kNyltDyWnHKQ/
         n6KOEzQ9Gu9Vg==
Received: by mail-ot1-f54.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so13911919otf.6
        for <linux-crypto@vger.kernel.org>; Sat, 28 Aug 2021 23:35:49 -0700 (PDT)
X-Gm-Message-State: AOAM532CUBmAIMyf9ariJhy3vz8hl4VnvmhG1hI1HjztJq2TTTeCZMpy
        wgyFwyxLk6BKcBhc/qiscVHvqhFL+BfeMEQkpRU=
X-Google-Smtp-Source: ABdhPJxzrftEamDvYm7JdhcTDj5ebjJGLKg93L0yVU9jwdcwp+axRt14OZmvQE35gGnLPbkv1ES3h5PRWikc4AFSmd0=
X-Received: by 2002:a05:6830:444:: with SMTP id d4mr14670303otc.108.1630218948588;
 Sat, 28 Aug 2021 23:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210827070342.218276-1-ardb@kernel.org>
In-Reply-To: <20210827070342.218276-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 29 Aug 2021 08:35:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEUbPMadj1J7MWD_B-=2zRc2ir_zZQN3Puz3n+PjQw58Q@mail.gmail.com>
Message-ID: <CAMj1kXEUbPMadj1J7MWD_B-=2zRc2ir_zZQN3Puz3n+PjQw58Q@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] running kernel mode SIMD with softirqs disabled
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Aug 2021 at 09:03, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> This is a follow-up to [0], but given that the arm64 architectural
> pieces have been merged for arm64, the only remaining changes are crypto
> specific. Therefore, the audience has been reduced to those people who
> are somewhat more likely to care about these specifics.
>
> The AEAD and skcipher APIs may only be called from task or softirq
> context. This permits the arm64 AEAD and skcipher code to get rid of all
> scalar fallbacks, given that on this architecture, softirqs are now no
> longer served while the SIMD unit is being used in kernel mode, which
> means that the scalar fallbacks are never needed. These are removed in
> this series.
>
> Changes since v6:
> - add patch to yield the NEON every 4k of input when processing the AAD
> - add some more acks from Eric
>
> Changes since v5:
> - add Eric's R-b to patches #1 to #3
> - split CCM changes into 3 separate patches
>
> Changes since v4:
> - drop skcipher_walk layer change to deal with zero sized walks
> - drop aead/skcipher layer sanity checks on invocations from hardirq
>   context
> - add patch to clean up CCM a bit more after removing the SIMD code path
>
> Changes since v3:
> - clarify the nature of the issue addressed by patch #1, and apply the
>   same fix to the skcipher walker
> - update patches #2 and #3 so that the failures can be observed by the
>   crypto stats code
>
> [0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/
>
> Ard Biesheuvel (7):
>   crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
>   crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
>   crypto: arm64/aes-ce - stop using SIMD helper for skciphers
>   crypto: arm64/aes-ccm - yield NEON when processing auth-only data
>   crypto: arm64/aes-ccm - remove non-SIMD fallback path
>   crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
>   crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data
>

Herbert,

Any chance we could get this queued for v5.15? If it's too late,
please consider taking only the first three patches as an alternative,
and I will resend the CCM ones for v5.16 once they have all been
reviewed.

Thanks,
Ard.

>  arch/arm64/crypto/Kconfig           |   6 -
>  arch/arm64/crypto/aes-ce-ccm-core.S |  24 +--
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 203 ++++++-------------
>  arch/arm64/crypto/aes-glue.c        | 102 ++--------
>  arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
>  arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
>  6 files changed, 148 insertions(+), 518 deletions(-)
>
> --
> 2.30.2
>
