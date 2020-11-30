Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55571C64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED96720825
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgK3NKU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:10:20 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33927 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgK3NKT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 08:10:19 -0500
Received: by mail-ot1-f67.google.com with SMTP id h19so11223787otr.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2020 05:10:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=syueVib23V0V7ir42+aU8JSvF0sFTmAkdHUTkEANl68=;
        b=XbpdxFKLpTJc5bZ9Vogpx8VkldNhBY7ySuyOUVarXB68NhfNnOJjLRCQYdGWMTg3sM
         zw1ei/piLILMQ47lBDX62Y71XzWppbhaEl5TeXrTVxKQ8cC3vqrsUZKy7qVgf5Odunms
         PflBauL6ZO6tGVHK/wLDnofD6YmBemql9UBMcXYmo+lkGWp5AmVB/vEItqIOCU2CZbYZ
         l5tcVIN213jBJWWXtnBxBuGvVRRiUTrvnvZc7d4p5rJUIrgrQz38SeKi6pvhHO5w3TSv
         MQ/cHQbCmStGFw8U+rD4Kn1P39oehpVEsJbNAhqxq4cGaqjEvLyUT1FeleA/JWJtTG62
         63vg==
X-Gm-Message-State: AOAM533T8k/neERlnERd0/w7pC58DVNeDyjVH4eGYlJx/Ihuji4kmsCf
        4KsuDjtbVOIrNz/IwJ31yQQW184QBbKzAJTKibbBfCiHmIM=
X-Google-Smtp-Source: ABdhPJzq9Qahbq4AM+FeSkcwcyCFSNPS+rt3lZUAJVYOW6suQxSrd//UCH7Rd+yd1EH3HNYv2WYndtPlyQLBu8ASZww=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr8307244oth.250.1606741777254;
 Mon, 30 Nov 2020 05:09:37 -0800 (PST)
MIME-Version: 1.0
References: <20201130122620.16640-1-ardb@kernel.org> <CAMuHMdW39bXXS+OACMOFWXgf2=zgmfN0WjhV+_H4aZLbfAQVjw@mail.gmail.com>
 <CAMj1kXHtW_+mJ+JLcQbO3T5v=G=mnRdtMZ5_14736-eTAaw6xQ@mail.gmail.com>
In-Reply-To: <CAMj1kXHtW_+mJ+JLcQbO3T5v=G=mnRdtMZ5_14736-eTAaw6xQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 Nov 2020 14:09:26 +0100
Message-ID: <CAMuHMdV+eWLWQe2wfnakfG9=OLPNA8jNTfxnLyz22oBBpB5VHA@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - avoid spurious references crypto_aegis128_update_simd
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Nov 30, 2020 at 1:47 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> On Mon, 30 Nov 2020 at 13:42, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Nov 30, 2020 at 1:26 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > Geert reports that builds where CONFIG_CRYPTO_AEGIS128_SIMD is not set
> > > may still emit references to crypto_aegis128_update_simd(), which
> > > cannot be satisfied and therefore break the build. These references
> > > only exist in functions that can be optimized away, but apparently,
> > > the compiler is not always able to prove this.
> >
> > The code is not unreachable. Both crypto_aegis128_encrypt_simd() and
> > crypto_aegis128_decrypt_simd() call crypto_aegis128_process_ad(..., true);
> >
>
> Those functions themselves can be optimized away too, as well as
> struct aead_alg crypto_aegis128_alg_simd, which is the only thing that
> refers to those functions, and is itself only referenced inside a 'if
> (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))' conditional block. This is
> why it works fine most of the time.

I stand corrected: I missed the conditional registration of
crypto_aegis128_alg_simd.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
