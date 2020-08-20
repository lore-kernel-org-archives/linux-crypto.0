Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EFAC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF48720738
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597907080;
	bh=ba9cSIZhP+6Gb3XMbmNMqHrN83S2vBN8NC7SAzX4eFU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=n7OSu2fIyISlzsEreB5LPCiglEqsf8acX05zYKMNK7ot0CpYoT0e/4rPSujvbXxuR
	 hB7J0YHpuKv+hLnj78rr/8MHA6uXVHU6c814rjhMtHIiVa17zRmalMFNKviWROqhy+
	 0bczpCBr4oAel7xRtDZD14cpDD6veJoo3USgS42Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHTHEj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgHTHEi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:04:38 -0400
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E35E20855
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 07:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597907078;
        bh=ba9cSIZhP+6Gb3XMbmNMqHrN83S2vBN8NC7SAzX4eFU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gFlnGd9hvzKHH5oDhmDzOeaTA1MWEsovPvQ1HaIKBRt9L0CpgaKkT0rDvAM8CFQsY
         anLaq293se1DX5Iqw3EvSXqgxJ81Xw6Wx0UsHrOrtAJLWoylGGHdwXGAKqZ0K8NkSs
         b/oOOFHICWIr2iEtawHVMuMhI+QJUlr4njboFP9M=
Received: by mail-ot1-f41.google.com with SMTP id x24so675769otp.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2020 00:04:38 -0700 (PDT)
X-Gm-Message-State: AOAM530mOinE2FGg84a4NkVopoHAqnurM3ZSl+HA+wwsXr0Sdnpc8fVI
        7jzAYDHuOBoPofB0XX7Dzjeo402RTHRqPnL9iyk=
X-Google-Smtp-Source: ABdhPJzxAQhfm7TjeyYU10nheLT+rrtCMeHXjGqENB6dJi9RsmZk6CIBoydbClGJ8i8mqWjD+kZQ79MTIgosQwdLefM=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr1164113otl.108.1597907077488;
 Thu, 20 Aug 2020 00:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200818135128.GA25652@gondor.apana.org.au> <2aad9569-877e-4398-88ef-e40d9bbf7656@candelatech.com>
 <20200818140532.GA25807@gondor.apana.org.au> <be188471-b75f-d2e2-d657-265a1cd9831b@candelatech.com>
 <20200818221550.GA27421@gondor.apana.org.au> <20200818222719.GA27622@gondor.apana.org.au>
 <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com> <20200818223359.GA27712@gondor.apana.org.au>
 <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com> <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au>
In-Reply-To: <20200820070142.GA21343@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 20 Aug 2020 09:04:26 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
Message-ID: <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Aug 2020 at 09:01, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 20, 2020 at 08:58:15AM +0200, Ard Biesheuvel wrote:
> >
> > But if we look at the actual issue at hand, we might also look into
> > amortizing the FPU preserve/restore over multiple invocations of a
> > cipher. I proposed a patch a while ago that makes cipher an internal
> > crypto API abstraction, and we could easily add pre/post hooks that
> > preserve/restore the FPU in this case, in which case we would not need
> > any changes at higher levels.
>
> I think any use of SIMD crypto_cipher on bulk data is just wrong.
> Because the performance degradation when SIMD cannot be used is
> too great for this to make sense.
>
> So optimising the FPU overhead is attacking the wrong problem.
>

I don't disagree with that, especially given all the effort that went
into optimizing FPU preserve/restore on both arm64 and x86. But the
bottom line is that this is what is causing the degradation in Ben's
case, so we cannot disregard it.
