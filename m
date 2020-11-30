Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D70C64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8492207BC
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/8Dc6Pb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgK3MsD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgK3MsD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 07:48:03 -0500
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB057207BC
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2020 12:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606740442;
        bh=8RxdMuG6a6mMddTxQNnZRKG4dMrJGGLLz+GeVFQF9UI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z/8Dc6PbRz9nE9NHnA+E2m0MCckwvw4iSqEa6V/dwTcFB/l2/z8Gtt7NW1mU/up2b
         WbMbUfOULrP1Mxycz/PaSuTTQvQAg2i87/3dBoGr4sPLUoECmYHqQ03KAAZfYTrqS2
         9cRSLFhOnxQpe75Wa3qf8oWKQ1sUiyOayLqDTV8U=
Received: by mail-ot1-f50.google.com with SMTP id h39so11112396otb.5
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2020 04:47:21 -0800 (PST)
X-Gm-Message-State: AOAM5336SUbXeH4YBhZprNoabRrRcsq6/ryLbjTcSFeOi2oQKlfUOEdv
        2H5Qf9TfG7fwT1h5doIYqk7FHQTV2c0v/iq5jhA=
X-Google-Smtp-Source: ABdhPJy5TJM1PFhxHP9B2qaeHFJwS+IJZUyPjzNwdTd6m/Z8luL97paANBKGi3bD5qy6u2IroIFjMPI6f6NQRiDzT7M=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr16069966otd.90.1606740441115;
 Mon, 30 Nov 2020 04:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20201130122620.16640-1-ardb@kernel.org> <CAMuHMdW39bXXS+OACMOFWXgf2=zgmfN0WjhV+_H4aZLbfAQVjw@mail.gmail.com>
In-Reply-To: <CAMuHMdW39bXXS+OACMOFWXgf2=zgmfN0WjhV+_H4aZLbfAQVjw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 30 Nov 2020 13:47:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHtW_+mJ+JLcQbO3T5v=G=mnRdtMZ5_14736-eTAaw6xQ@mail.gmail.com>
Message-ID: <CAMj1kXHtW_+mJ+JLcQbO3T5v=G=mnRdtMZ5_14736-eTAaw6xQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - avoid spurious references crypto_aegis128_update_simd
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Nov 2020 at 13:42, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Ard,
>
> On Mon, Nov 30, 2020 at 1:26 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > Geert reports that builds where CONFIG_CRYPTO_AEGIS128_SIMD is not set
> > may still emit references to crypto_aegis128_update_simd(), which
> > cannot be satisfied and therefore break the build. These references
> > only exist in functions that can be optimized away, but apparently,
> > the compiler is not always able to prove this.
>
> The code is not unreachable. Both crypto_aegis128_encrypt_simd() and
> crypto_aegis128_decrypt_simd() call crypto_aegis128_process_ad(..., true);
>

Those functions themselves can be optimized away too, as well as
struct aead_alg crypto_aegis128_alg_simd, which is the only thing that
refers to those functions, and is itself only referenced inside a 'if
(IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))' conditional block. This is
why it works fine most of the time.
