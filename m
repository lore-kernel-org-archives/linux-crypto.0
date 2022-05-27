Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BBBC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 21:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354706AbiE0VQC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 17:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbiE0VQB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 17:16:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BC428E33
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 14:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 639A6B82178
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 21:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C4C385A9
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 21:15:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nkN/C0SC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653686155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+76Kx76so7mIqkbo9tW56yAwJo4fLnE4YnYywTrMaW4=;
        b=nkN/C0SCb9p2L1kOaeTPHiiTZ2s5/3ZQdkS96oREuUUTdDWzNiBKfco8YPRVmUKKeDyZpw
        k+nQno3WPjbyEQ4usMv5OP7qe4KudKVe178fYJk26n6EXUIipE+z/KF4dVdS93UofvO9SZ
        BwlJsYi2smUSry7ZRR5xo2i6MME/t+c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 116beb5a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 27 May 2022 21:15:55 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-300beab2b76so59325977b3.13
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 14:15:54 -0700 (PDT)
X-Gm-Message-State: AOAM532AFu9DBp4/ZyNAmeSbcbvreWj3D7Y1xFnd8dZWOtvoEYRyGp5p
        Fgk+q+CqF0kzufk/h0VVmTJtcgwZh/k280PU9cc=
X-Google-Smtp-Source: ABdhPJz7mwv2lJv5ft25ZDasezhsU1MuTqWwmIas2UGdRupZjP/4V783Z2Uba8HLZHTrxu4WdiNcTJvdLPVyuA0auq8=
X-Received: by 2002:a81:13c9:0:b0:30a:94b8:78c3 with SMTP id
 192-20020a8113c9000000b0030a94b878c3mr2986971ywt.404.1653686154113; Fri, 27
 May 2022 14:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <202205271557.oReeyAVT-lkp@intel.com> <20220527201931.63955-1-Jason@zx2c4.com>
 <CAHk-=whyH8xx=2LVmOdQDTy9RRqBs_JJz_oMV2+6a2myk8+wow@mail.gmail.com>
In-Reply-To: <CAHk-=whyH8xx=2LVmOdQDTy9RRqBs_JJz_oMV2+6a2myk8+wow@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 27 May 2022 23:15:43 +0200
X-Gmail-Original-Message-ID: <CAHmME9oAqBT5bOd94Na-q_tHHNZqVyU7eLk0odei7-KB07VPRA@mail.gmail.com>
Message-ID: <CAHmME9oAqBT5bOd94Na-q_tHHNZqVyU7eLk0odei7-KB07VPRA@mail.gmail.com>
Subject: Re: [PATCH crypto v2] crypto: poly1305 - cleanup stray CRYPTO_LIB_POLY1305_RSIZE
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus,

On Fri, May 27, 2022 at 11:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh well. I already applied your v1 patch earlier today..
>
>        Linus

Whoops. I sent this to linux-crypto/Herbert assuming that it'd work
with the "2 weeks pass and nobody complains --> queued up" flow of
that list.

I can send you a patch on top of your tree to fix the v1 you applied.
But let's let the kernel test robot chew on my v2 for a day or two.
The crypto/ Kconfig system is incredibly convoluted, and the config
fuzzing the robot does tends to be (unfortunately) helpful.

Jason
