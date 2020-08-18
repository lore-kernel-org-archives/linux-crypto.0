Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBC3C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 559B1207DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597739517;
	bh=UW7nnIQ76NC7iO+hRkeklUdTODs+X3AQJBdrj1XNqLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Z1PFkY7wkU87ZNmxRkBX+R3DzkP03E51cp7hQS1rpYMoWtUuuZKefJ55OE5LjA3KR
	 eq9JMvqS+FNKlvaiVdKSMu5E69eza0e1pOE5wqcFxOYkRSyaa1ZppqLyZBipNeqUs+
	 VLHPYkF+/hUyJe3S0nRWl0W6l+fOLxJ+6woexHlk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgHRIb4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgHRIbw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:31:52 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6ED220789
        for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2020 08:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597739511;
        bh=UW7nnIQ76NC7iO+hRkeklUdTODs+X3AQJBdrj1XNqLQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eBtu5l0pFBwihrjirIAdDakm5+AJAV1FBSSbDGrOBmgpQuTL/E0lWrf7MOyNXozMg
         oeExdhbu3dW9hasM81BVrFoOB/YUis9D1TQtid0fVFhY42Er/NM2rClWCdtUFYHkko
         nxQg6EEZdrY60wT+dIFORHra3I3EW5ggeqN3QJyI=
Received: by mail-ot1-f54.google.com with SMTP id v6so15606617ota.13
        for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2020 01:31:51 -0700 (PDT)
X-Gm-Message-State: AOAM532ag1IzWRdKj2ZSbNiUsfSKRpAAqHhgHiVINBASE3ii4NDjP+dk
        gm7n7ro6DCHdmCRSkBobwdrw25Tq7DIkj8s1j1k=
X-Google-Smtp-Source: ABdhPJw/9fGkYYfGFUXOOPKzkM7oSgLUCM+Go14n9e8CzyB8c5f8kEePwQy4xudwZ2Ih78ksBrcl7Ly5doJBb1iwMVo=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr13703952otl.108.1597739510995;
 Tue, 18 Aug 2020 01:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200802090616.1328-1-ardb@kernel.org> <20200818082410.GA24497@gondor.apana.org.au>
In-Reply-To: <20200818082410.GA24497@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Aug 2020 10:31:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
Message-ID: <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 18 Aug 2020 at 10:24, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Aug 02, 2020 at 12:06:16PM +0300, Ard Biesheuvel wrote:
> > Ben reports that CCM using AES-NI instructions performs pathologically
> > poorly, which is due to the overhead of preserving/restoring the SIMD
> > state, which is repeated after every 16 bytes of input when executing
> > the CBCMAC portion of the algorithm.
> >
> > So let's clone the arm64 implementation of cbcmac(aes), which takes
> > care to only preserve/restore the SIMD state after processing the
> > whole input. Since cmac(aes) and xcbc(aes) can reuse most of the code,
> > let's expose those as well.
> >
> > Cc: Ben Greear <greearb@candelatech.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/x86/crypto/Makefile           |   2 +-
> >  arch/x86/crypto/aesni-intel.h      |  39 +++
> >  arch/x86/crypto/aesni-intel_glue.c |  42 +---
> >  arch/x86/crypto/aesni-intel_mac.c  | 257 ++++++++++++++++++++
> >  4 files changed, 306 insertions(+), 34 deletions(-)
>
> We should just use the accelerated cbc skcipher.
>

What do you mean? You cannot implement cbcmac using a cbc skcipher
unless you provide a scratch buffer of arbitrary size as the
destination, in order to capture the skcipher output IV as the MAC.
