Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D3DC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE4823B70
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgLRQPw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 11:15:52 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:39225 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgLRQPw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 11:15:52 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6a68cfe7
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zw4wXqB9HP72y02N0j6ubp0kXb4=; b=irunY8
        bgwZz2iFNTvI5C9RA4IUaCQ6Z9Dq7BMOKMCR+THys7QVfbfhPU2pPSXA6vJORFkg
        7zWWtL4gEqz6unGrYcoPMM7BFJXPGVAdhq+HwJ+mLmGhRzDbUCyIFNCAEuAMNrzE
        CnslK3PjqJsEABdqW2l0oLYog9mBMPHpriasiJfEUDQC4IfoYlpJ9CRnpnEWQVqI
        /qcagHrniR0htGfU2vnv24atPE4CSB0Cw4m5TFOSANJcROddRBhC3lBIr0zxm01C
        XdbwHgaxAM2nF9Z2BcC76qK1JM+028TMDxDRfQvMQZNVLBvng62dx9ZNT+NTJQu1
        UohjMh11q/hT4fEw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 566a7765 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 16:07:16 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id a16so2384347ybh.5
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 08:15:10 -0800 (PST)
X-Gm-Message-State: AOAM533C1korOAF7Of0kqDzRjQmIawYfcx+V5Q6HIJCp+lLJD7En2ge2
        7M6z2KmsYjlj8js4bKkq66Dd7ZLC4MacG+dzuOI=
X-Google-Smtp-Source: ABdhPJyIJVah3STIIIcCJNERzx2GmpF0dsHna2bPwuF9nngvL1lcwojoWvxXm9NPLrbteLXXMz/LM5xSF44nymeSIBg=
X-Received: by 2002:a25:2cd6:: with SMTP id s205mr6815605ybs.279.1608308109522;
 Fri, 18 Dec 2020 08:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20201217222138.170526-1-ebiggers@kernel.org> <20201217222138.170526-10-ebiggers@kernel.org>
In-Reply-To: <20201217222138.170526-10-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 18 Dec 2020 17:14:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com>
Message-ID: <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] crypto: blake2s - share the "shash" API
 boilerplate code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 11:25 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Move the boilerplate code for setkey(), init(), update(), and final()
> from blake2s_generic.ko into a new module blake2s_helpers.ko, and export
> it so that it can be used by other shash implementations of BLAKE2s.
>
> setkey() and init() are exported as-is, while update() and final() have
> a blake2s_compress_t function pointer argument added.  This allows the
> implementation of the compression function to be overridden, which is
> the only part that optimized implementations really care about.
>
> The helper functions are defined in a separate module blake2s_helpers.ko
> (rather than just than in blake2s_generic.ko) because we can't simply
> select CRYPTO_BLAKE2B from CRYPTO_BLAKE2S_X86.  Doing this selection
> unconditionally would make the library API select the shash API, while
> doing it conditionally on CRYPTO_HASH would create a recursive kconfig
> dependency on CRYPTO_HASH.  As a bonus, using a separate module also
> allows the generic implementation to be omitted when unneeded.
>
> These helper functions very closely match the ones I defined for
> BLAKE2b, except the BLAKE2b ones didn't go in a separate module yet
> because BLAKE2b isn't exposed through the library API yet.
>
> Finally, use these new helper functions in the x86 implementation of
> BLAKE2s.  (This part should be a separate patch, but unfortunately the
> x86 implementation used the exact same function names like
> "crypto_blake2s_update()", so it had to be updated at the same time.)

There's a similar situation happening with chacha20poly1305 and with
curve25519. Each of these uses a mildly different approach to how we
split things up between library and crypto api code. The _helpers.ko
is another one. There any opportunity here to take a more
unified/consistant approach? Or is shash slightly different than the
others and benefits from a third way?

Jason
