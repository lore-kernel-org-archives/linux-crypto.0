Return-Path: <SRS0=mI8h=3T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6E2C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jan 2020 13:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2A4206F0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jan 2020 13:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgA3NTu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jan 2020 08:19:50 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40946 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgA3NTt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jan 2020 08:19:49 -0500
Received: by mail-oi1-f194.google.com with SMTP id a142so3429310oii.7;
        Thu, 30 Jan 2020 05:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rlmgmcdJs51yvRlMadmtWD4wMTDT049oFy7CE6s07as=;
        b=RL5XxQboaEwPbBVF9g7mFHJKij8eHRLh4Kk6PZ9r9ePM9tA8SgiHGMwiG1xfI9PhCq
         fy1+sLaJk+TL7E2CXTjpShwecSRq9Hxuq/aCDBD4F71tEFYe8k70S4ZwM8AOfpXVotYT
         W/7LbPX4z7vdz6+xo2S7YcqXMwdwWSdAI3m9v9lKs9mjBvkDL7clDCuuHbbx4dUFdzdl
         j+m9fftGPIr8B6qoYQn72pdGuaj4ilCUGljVB51laa/8100+LnlLUhL0pXPcU02pXQRx
         TMSdl0ucyD2vrQLv7OB/taWeX8QHkiG/NyBry+zlxP6YIRwhNYrFS3qKgjxVpjEq434u
         kGlQ==
X-Gm-Message-State: APjAAAXcIvtepqOLHcSLL1KZF4SbEUOJCvZf5erGgxFdOTDAF8STvQog
        5TaswVHxK+/Z3+KWFdHhzi5DPA0Y5bLwRaIqVd0=
X-Google-Smtp-Source: APXvYqwmPHal/1zELCYionjQ8J4zvZmXaJuskwPE4xb4L0RxdK4fNDQE/yG8pjewoTv8S4OfG5wjm04cPesM6HXhEqg=
X-Received: by 2002:aca:5905:: with SMTP id n5mr2881985oib.54.1580390388518;
 Thu, 30 Jan 2020 05:19:48 -0800 (PST)
MIME-Version: 1.0
References: <20200129143757.680-1-gilad@benyossef.com> <20200129143757.680-5-gilad@benyossef.com>
 <CAMuHMdVb_AGa7980fRXaxon=uDojZ1x5d6z-FCJAt5aMEGMcbw@mail.gmail.com> <CAOtvUMdUBMkmZ6nzGVxi1W_Y4yFvcd6rfvz6BA63h4eq2QFUdA@mail.gmail.com>
In-Reply-To: <CAOtvUMdUBMkmZ6nzGVxi1W_Y4yFvcd6rfvz6BA63h4eq2QFUdA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 30 Jan 2020 14:19:37 +0100
Message-ID: <CAMuHMdXecd0KAN6B4GWKMp-DsmZVTJqOJfm5CymwwPMwDqG0qA@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: ccree - fix AEAD blocksize registration
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gilad,

On Thu, Jan 30, 2020 at 12:33 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Wed, Jan 29, 2020 at 5:17 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jan 29, 2020 at 3:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > > Fix an error causing no block sizes to be reported during
> > > all AEAD registrations.
> > >
> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >
> > Thanks, this fixes:
> >
> >     alg: aead: blocksize for authenc-hmac-sha1-cbc-aes-ccree (0)
> > doesn't match generic impl (16)
> >     alg: aead: blocksize for authenc-hmac-sha256-cbc-aes-ccree (0)
> > doesn't match generic impl (16)
> >
> > which you may want to mention in the commit description, so
> > people who search for the error message will find the fix.
> >
> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Note that even after applying this series, the kernel still crashes with
> >
> > kernel BUG at kernel/dma/swiotlb.c:497!
> > ....
> > Call trace:
> >  swiotlb_tbl_map_single+0x30c/0x380
> >  swiotlb_map+0xb0/0x300
> >  dma_direct_map_page+0xb8/0x140
> >  dma_direct_map_sg+0x78/0xe0
> >  cc_map_sg+0xa0/0xd0
> >  cc_aead_chain_data.constprop.25+0x17c/0x6a0
> >  cc_map_aead_request+0x61c/0x990
> >  cc_proc_aead+0x140/0xeb0
> >  cc_aead_decrypt+0x48/0x68
> >  crypto_aead_decrypt+0x30/0x48
> >  test_aead_vec_cfg+0x5a0/0x8d0
> >
> > but you may be aware of that.
> >
> > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>
> OK, this is a new one yet - we are now crashing in out-of-place decryption.
> And again, I am not seeing this in the different test board, even with
> DMA debug turned on.

I'm using a tree based on renesas-drivers[*], with renesas_defconfig
(also from [*]), and the two config changes above.

> Can you help me out and print the cryptlen and assoclen (I'm guessing
> both are zero), authlen and which AEAD/mode this is?

The crashing test is "ccm(aes)" from alg_test_descs[].

With DEBUG=y, and a few extra debug prints, the last few lines
leading to the crash were:

ccree e6601000.crypto: Copy-to-sram: mlli_dma=00000260, mlli_size=40
ccree e6601000.crypto: ASSOC buffer type MLLI
ccree e6601000.crypto: CIPHER: SRC/DST buffer type MLLI
ccree e6601000.crypto: Setting key in context @00000000ceb78614 for
ccm(aes). key=00000000ae78472c keylen=32
ccree e6601000.crypto: enc_keylen=32  authkeylen=0
ccree e6601000.crypto: authlen=16
cc_aead_decrypt:2086: assoclen = 32 cryptlen = 48
cc_aead_decrypt:2087: iv = ffff80000a5d3980 src = ffff0006f8a28040 dst
= ffff0006f8a28040
ccree e6601000.crypto: Dec context=00000000ceb78614
req=0000000057b9c395 iv=00000000784a9e35 src=00000000b9e80940
src_ofs=24 dst=00000000b9e80940 dst_ofs=24 cryptolen=48
ccree e6601000.crypto: Copy-to-sram: mlli_dma=00000260, mlli_size=16
ccree e6601000.crypto: ASSOC buffer type MLLI
ccree e6601000.crypto: CIPHER: SRC/DST buffer type DLLI
ccree e6601000.crypto: Setting key in context @00000000ceb78614 for
ccm(aes). key=00000000ae78472c keylen=32
ccree e6601000.crypto: enc_keylen=32  authkeylen=0
ccree e6601000.crypto: authlen=16
cc_aead_decrypt:2086: assoclen = 32 cryptlen = 48
cc_aead_decrypt:2087: iv = ffff80000a5d39b1 src = ffff0006f8a28040 dst
= ffff0006f8a28290
ccree e6601000.crypto: Dec context=00000000ceb78614
req=0000000057b9c395 iv=00000000e16df7d7 src=00000000b07b5b54
src_ofs=23 dst=00000000b3abbd9e dst_ofs=23 cryptolen=48
ccree e6601000.crypto: Copy-to-sram: mlli_dma=00000260, mlli_size=16
ccree e6601000.crypto: ASSOC buffer type MLLI
ccree e6601000.crypto: CIPHER: SRC/DST buffer type DLLI
ccree e6601000.crypto: Setting key in context @00000000ceb78614 for
ccm(aes). key=0000000061847879 keylen=32
ccree e6601000.crypto: enc_keylen=32  authkeylen=0
ccree e6601000.crypto: authlen=16
cc_aead_decrypt:2086: assoclen = 32 cryptlen = 48
cc_aead_decrypt:2087: iv = ffff80000a5d3980 src = ffff0006f8a28040 dst
= ffff0006f8a28040
ccree e6601000.crypto: Dec context=00000000ceb78614
req=0000000057b9c395 iv=00000000784a9e35 src=0000000026c45683
src_ofs=8 dst=0000000026c45683 dst_ofs=8 cryptolen=48
ccree e6601000.crypto: Copy-to-sram: mlli_dma=00000260, mlli_size=16
ccree e6601000.crypto: ASSOC buffer type MLLI
ccree e6601000.crypto: CIPHER: SRC/DST buffer type DLLI
ccree e6601000.crypto: Setting key in context @00000000ceb78614 for
ccm(aes). key=000000002490788f keylen=16
ccree e6601000.crypto: enc_keylen=16  authkeylen=0
ccree e6601000.crypto: authlen=8
cc_aead_decrypt:2086: assoclen = 0 cryptlen = 8
cc_aead_decrypt:2087: iv = ffff80000a5d3980 src = ffff0006f8a28040 dst
= ffff0006f8a28040
ccree e6601000.crypto: Dec context=00000000ceb78614
req=0000000057b9c395 iv=00000000784a9e35 src=000000006ab00be2
src_ofs=0 dst=000000006ab00be2 dst_ofs=0 cryptolen=8
ccree e6601000.crypto: Payload authentication failure, (auth-size=8, cipher=8)
ccree e6601000.crypto: Setting key in context @00000000ceb78614 for
ccm(aes). key=000000002490788f keylen=16
ccree e6601000.crypto: enc_keylen=16  authkeylen=0
ccree e6601000.crypto: authlen=8
cc_aead_decrypt:2086: assoclen = 0 cryptlen = 8
cc_aead_decrypt:2087: iv = ffff80000a5d3980 src = ffff0006f8a28040 dst
= ffff0006f8a28290
ccree e6601000.crypto: Dec context=00000000ceb78614
req=0000000057b9c395 iv=00000000784a9e35 src=000000006ab00be2
src_ofs=0 dst=00000000c4bfb383 dst_ofs=0 cryptolen=8

[*] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git/tag/?h=renesas-drivers-2020-01-28-v5.5

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
