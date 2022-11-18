Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED6EC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 20:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKRU22 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 15:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiKRU21 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 15:28:27 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45E5250
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 12:28:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x2so8729062edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 12:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vZwGHNcQb0fQL0dIXVfO9Z/ROsXVh+NZri45yvzXL3A=;
        b=OVoFdFdQbkLGMmf+NMi3IyzgUaB2vBMEp5b5g6wg+bl/c5Dd9mSrKnyUTUMaBDt/OR
         vVOElPooUgIwzZeaiEciN6TNDy8PKBh6AXh+dDeWBPJI9hq/s+UkaiI/y59+HOdczAb9
         r6RDTmwv8Gnxn6+Tef9wzmZJEZauIRCoPQBIW7dHzZFFloK5DzmwU2EfkTxXkWllikMq
         Kn93WBT2Iv52Z/G/FnzQmHhANwgOu5Vw47M90fGrHrJpQKxB9achWFUYc0CFtXV3BABU
         21+2tvvQgas1dGyu6+FIFL/jXnm07b/jwf+6V6nG4zBvuCsLsIn7JrsmQjarjOIWJ2Bj
         k6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZwGHNcQb0fQL0dIXVfO9Z/ROsXVh+NZri45yvzXL3A=;
        b=5rZ0YYcCpdwubExHVDwTAbHAmwN3h5DbuHePz/ti/q2NcDwxAPd+oqfKn81Yhd5zCh
         a3aFjFNZSe2NVjEjIjU393y5XpC0YldrkR+gIXDooab53cq0XdAnA/fTxrWiv8rPohCR
         OzAj9Q9OgJlefh+lrDS41PTv7mw0PzndZ4+qaUMiZjXgGd7YqrdjyGylU0HSuEaV+vSY
         a88AcbQYyn/GxNAYGsvavEHz2MaJnY3PydkDjtz5KkZGq/Agbg0SyX8H5BiWccrYkcjD
         Y19KYAltH/OKhi2n/rQbdUg6XjWa76+or6xa7L1dbsWiEnzfzDMC0a5R+oYMKpx8mi1P
         0AfA==
X-Gm-Message-State: ANoB5pmLir2H0YJJj+2hL6/D3J3hKqMUFh+1kI0Tm4TP60vYlJlSeOb9
        ysLEvyNCpOF8Dy4lV+pxJNtFgSmqNg+k1fvWsPIkttNJ3eg=
X-Google-Smtp-Source: AA0mqf45jRsyYb5BuyDC74B98aAlOFvZMbhmhvF/73FMFxckYhC+TwvHaiYeD4cW1inE2bRIyCDQK4RfWUdt8Ko2rGg=
X-Received: by 2002:a05:6402:3893:b0:461:b033:90ac with SMTP id
 fd19-20020a056402389300b00461b03390acmr5824070edb.257.1668803303099; Fri, 18
 Nov 2022 12:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20221118194421.160414-1-ebiggers@kernel.org> <20221118194421.160414-9-ebiggers@kernel.org>
 <Y3fmskgfAb/xxzpS@sol.localdomain>
In-Reply-To: <Y3fmskgfAb/xxzpS@sol.localdomain>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Fri, 18 Nov 2022 12:27:46 -0800
Message-ID: <CABCJKudPXbDx2MSURDxGanTLhBkJjpMx=G=2RPDi6+96LGxcvw@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 12:10 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Nov 18, 2022 at 11:44:17AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > sm4_aesni_avx_ctr_enc_blk8(), sm4_aesni_avx_cbc_dec_blk8(),
> > sm4_aesni_avx_cfb_dec_blk8(), sm4_aesni_avx2_ctr_enc_blk16(),
> > sm4_aesni_avx2_cbc_dec_blk16(), and sm4_aesni_avx2_cfb_dec_blk16() are
> > called via indirect function calls.  Therefore they need to use
> > SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
> > hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
> > Otherwise, the code crashes with a CFI failure.
> >
> > (Or at least that should be the case.  For some reason the CFI checks in
> > sm4_avx_cbc_decrypt(), sm4_avx_cfb_decrypt(), and sm4_avx_ctr_crypt()
> > are not always being generated, using current tip-of-tree clang.
> > Anyway, this patch is a good idea anyway.)
>
> Sami, is it expected that a CFI check isn't being generated for the indirect
> call to 'func' in sm4_avx_cbc_decrypt()?  I'm using LLVM commit 4a7be42d922af0.

If the compiler emits an indirect call, it should also emit a CFI
check. What's the assembly code it generates here?

Sami
