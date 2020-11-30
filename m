Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1925FC64E8A
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C034E207BC
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 12:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgK3Mnd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:43:33 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37506 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgK3Mnc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 07:43:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id l36so11118192ota.4
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2020 04:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQoRoLg6AL+Rr69xJkqRAE7jW3puMS6I4KpvYjqnsNk=;
        b=ubiNqqJDsx4el1vZMwie/mc26vBLrSgECiiee7A4BWl1qBXyb+gSmWE4hLiyLfHdoF
         3HzundGt/XAlByO354+GqTbJ80YMZKdiawbQTUa233gi3rzUa61MJSOeNaOIOyxfFF++
         mxnKehRGIys8r6VzGlSMov4oxrE/hj8AcwPlBAXq6dwKQbz3r3g7+wCSxftWJZfxkFJ7
         a/of5v0s8yELt41mcuXjwe3gkR5M55p0ruFGjz377HL7FD/UICTlx9k2jsDEufxwbK58
         YqN64SgAbehSkj8OJSzIXdaVpPScqhTHbwqQv7Zy+lqeIbn9rdQ33roJ+J5FAPpDOa+d
         6csw==
X-Gm-Message-State: AOAM530AfCAFB8q903KXN171Wi9//6Vx/I1+YUYlubDSnq4qljLTd/Ga
        8yIr3YD5I+IKOK784/Xgf+5/S1200KSazPEjRXN0a9/P2t8=
X-Google-Smtp-Source: ABdhPJyptR2iwccbNwLCRcEvObwhkh4TIVYmQO5RnWEmlGQAZ5UoK2eLFrQEMPtiZ/BEsAwgQ2xmAloW00mluVtzr+o=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr15547437otc.145.1606740171421;
 Mon, 30 Nov 2020 04:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20201130122620.16640-1-ardb@kernel.org>
In-Reply-To: <20201130122620.16640-1-ardb@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 Nov 2020 13:42:40 +0100
Message-ID: <CAMuHMdW39bXXS+OACMOFWXgf2=zgmfN0WjhV+_H4aZLbfAQVjw@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - avoid spurious references crypto_aegis128_update_simd
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Nov 30, 2020 at 1:26 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> Geert reports that builds where CONFIG_CRYPTO_AEGIS128_SIMD is not set
> may still emit references to crypto_aegis128_update_simd(), which
> cannot be satisfied and therefore break the build. These references
> only exist in functions that can be optimized away, but apparently,
> the compiler is not always able to prove this.

The code is not unreachable. Both crypto_aegis128_encrypt_simd() and
crypto_aegis128_decrypt_simd() call crypto_aegis128_process_ad(..., true);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
