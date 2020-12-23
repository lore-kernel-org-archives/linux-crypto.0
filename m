Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7629C433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D3C22482
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgLWJH4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbgLWJHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 04:07:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D2620760
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608714435;
        bh=8MidONwWWze5P3m36JX1C/3bEdswDVgpMQR1AeneRSM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qW3JdSdmt4dgIch0Qc+0z6khWfS4rI2WCIH0EkodnPLKvNeJ3LI7KsF8y9O4ds54P
         V/DSiUwVtF1GU9wRtiFvHF+q/YZiPDkV0qTLroufa0xmfZXA7vBzl2NDllOCp64jTk
         a9W4rAIvFRdnyLTuQV9UnhuyiV/93Uftsau7kDJlDJKq0sBxGJcl1FvfYSJe4Jr16u
         AyjjuTcVdLT1CYDmmgB07CH59rQC28e4gPyELuTD3gUWmSivn4gogCbDpwLC0pox16
         HSkTLgWhjuCOiBBJ6ZyIAxSM6y1HklGMeb7D2C6HsfsIG3mdrc549db6gSRFBUsZr3
         2iTnGhgYZHFQg==
Received: by mail-ot1-f54.google.com with SMTP id x13so14429602oto.8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 01:07:14 -0800 (PST)
X-Gm-Message-State: AOAM532Ucg8NO9tfW3fPDEDURcIZJN37JuGMFy2m/vNmjeG+1LWO3gr0
        7DBiUSw6qtTugOvBPukXQoFgrWrXotGMxAQV/Vc=
X-Google-Smtp-Source: ABdhPJzrqrY6BlMIn/yL86+o1SM0iLdj5OgZRMC8dw1IA7z80emEBME1npLJ8l+ZToQ5QGUdGnNp6JzxONrJhFcBFas=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr18790670oto.90.1608714434115;
 Wed, 23 Dec 2020 01:07:14 -0800 (PST)
MIME-Version: 1.0
References: <20201223081003.373663-1-ebiggers@kernel.org> <20201223081003.373663-8-ebiggers@kernel.org>
In-Reply-To: <20201223081003.373663-8-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 23 Dec 2020 10:07:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHc8O0FxUqm5854f3o5dh+S13_smCQqorXeN7CVLdjWpw@mail.gmail.com>
Message-ID: <CAMj1kXHc8O0FxUqm5854f3o5dh+S13_smCQqorXeN7CVLdjWpw@mail.gmail.com>
Subject: Re: [PATCH v3 07/14] crypto: blake2s - add comment for blake2s_state fields
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Dec 2020 at 09:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The first three fields of 'struct blake2s_state' are used in assembly
> code, which isn't immediately obvious, so add a comment to this effect.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/crypto/blake2s.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
> index 734ed22b7a6aa..f1c8330a61a91 100644
> --- a/include/crypto/blake2s.h
> +++ b/include/crypto/blake2s.h
> @@ -24,6 +24,7 @@ enum blake2s_lengths {
>  };
>
>  struct blake2s_state {
> +       /* 'h', 't', and 'f' are used in assembly code, so keep them as-is. */
>         u32 h[8];
>         u32 t[2];
>         u32 f[2];
> --
> 2.29.2
>
