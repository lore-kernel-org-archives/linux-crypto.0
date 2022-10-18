Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41877C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 21:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiJRVCC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJRVB4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 17:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C9C1DB7
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 14:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C04DB82113
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 21:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3F5C433D7
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666126830;
        bh=ej51CpjiZXy86mgGMyLkxsOTs+9vMFqdO/OfqIapnvQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ThLue1AzVRloOaczEUjK95SljbkLKaTDmxkezq34iIeRgP8qi+zHHvPfX3iPaT3uU
         dsHmJQYpNNkBgKa8/8FAw3k18GB7U0t70BUkXulcLnvOHNgEnyyBaUETjDem93eKzA
         I3As91Z3Cb3CUYOpqSGNBKKn8JAmaEu4aob8Lqw6nWvXB3MWd1KyvGwrLRnHRX80K1
         ZMOrmHSBzUxqF/Ueyan/1UeGvjR4g6q3o1maWBBxaET6YnPvjRmWMWC+H7UiV4Be6g
         2JY1FAyKoFXQkExKdhxoszcyAOUsuQurierBRq18rqKWRE7GHUZ4i6dANEKRAdVkbZ
         DX1bnUE+6Bw2A==
Received: by mail-lj1-f181.google.com with SMTP id by36so19646369ljb.4
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 14:00:30 -0700 (PDT)
X-Gm-Message-State: ACrzQf1Nc8Ex0JIDPxH+r7forIEi12wJ2KHfOeDVxJy/O9C0yRoX4zB/
        j/lEKLW9ZnA4oZPtIiJVv66wuhaooGyvRTk1obo=
X-Google-Smtp-Source: AMsMyM5/kJqCCT7eF3cvpkBCbmHjiwF9okT1k4KmcFNPV6fPtqgjdPNtotlxTmcTa2ty0KrNq/GZO4ImPZuOrUZK3l0=
X-Received: by 2002:a05:651c:4d0:b0:26f:cd9b:419f with SMTP id
 e16-20020a05651c04d000b0026fcd9b419fmr1620206lji.415.1666126828145; Tue, 18
 Oct 2022 14:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221018200422.179372-1-ardb@kernel.org> <CAHmME9pPNxQthg6sMThdRswWc-um17OcPuhLWO+r=1jXrEDd5g@mail.gmail.com>
In-Reply-To: <CAHmME9pPNxQthg6sMThdRswWc-um17OcPuhLWO+r=1jXrEDd5g@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Oct 2022 23:00:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGWY2wGZUayaeTNAGPARARURgetXjp5zbP1x-DVTqQNuQ@mail.gmail.com>
Message-ID: <CAMj1kXGWY2wGZUayaeTNAGPARARURgetXjp5zbP1x-DVTqQNuQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] crypto: Add GCM-AES implementation to lib/crypto
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org,
        ebiggers@kernel.org, herbert@gondor.apana.org.au, nikunj@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Oct 2022 at 22:11, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Oct 18, 2022 at 2:04 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Provide a generic library implementation of GCM-AES which can be used
>
> Every place else in the world, this is called AES-GCM. Can we stick
> with the convention?

Good point, I'll change that next time around.
