Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA7BC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 10:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EF02086A
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 10:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WTS8+AWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgGWKF0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 06:05:26 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:32769 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgGWKF0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 06:05:26 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d336b177
        for <linux-crypto@vger.kernel.org>;
        Thu, 23 Jul 2020 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=RyD29gGjJDqSqVIG++m7HJT3Qu8=; b=WTS8+A
        WnvfQ6EucnzgusWooDeiT9++F4LTn/1i1rqT9ysJoi1JWpukBNP2XVD0ItRmXoDN
        7yFhPWdnAcxEIeziP2FNryxwY4FR4VaMbvb9BY1z8tFGkiPfsq/BiXumIP71uHMj
        fkjnBD1igQfVJl0fmBNNFWF4vcgPMVJO2fZ/hFVjpg8NG2WF/pFu/E06Id3VZRFN
        WJbBqngw1cZrQWaC/HNYCOUb5NS7ghhc8zZOdDDVwCshASZqOLL37nZ3e3DZSivh
        MP6fIfLTCXbvWc6hSjoTrK4C7oZdFJDOzzWrLZjonAhSCxsQwGhriLPq7WPuBdBB
        lSWoS/6PPiBFxoBA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bbafeefb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 23 Jul 2020 09:42:35 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id r12so3846956ilh.4
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2020 03:05:22 -0700 (PDT)
X-Gm-Message-State: AOAM5339PtvzP/uNvitOzvzFbCoL4+5Z07gGs3zCiU0iyN8lWueHrEyX
        GjjxqpPTDbz/Jt/CwYAXB1QQDEnhA1e7ZztU6Ds=
X-Google-Smtp-Source: ABdhPJzv5KGCmfJkNAv11fl6B93Yls7UkGXbOnk1/+BL4vankm9f+f3QAaANL4zqqVTA/yy6b9pN+hqPbrLTqwbd3KY=
X-Received: by 2002:a92:8585:: with SMTP id f127mr4123945ilh.207.1595498721687;
 Thu, 23 Jul 2020 03:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200723075048.GA10966@gondor.apana.org.au>
In-Reply-To: <20200723075048.GA10966@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 23 Jul 2020 12:05:10 +0200
X-Gmail-Original-Message-ID: <CAHmME9rg-_2-Zj19zSZa6sujgfJcOdm6=L1N07Dif9aWJE7eQQ@mail.gmail.com>
Message-ID: <CAHmME9rg-_2-Zj19zSZa6sujgfJcOdm6=L1N07Dif9aWJE7eQQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/curve25519 - Remove unused carry variables
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Jul 23, 2020 at 9:51 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The carry variables are assigned but never used, which upsets
> the compiler.  This patch removes them.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
> index 8a17621f7d3a..8acbb6584a37 100644
> --- a/arch/x86/crypto/curve25519-x86_64.c
> +++ b/arch/x86/crypto/curve25519-x86_64.c
> @@ -948,10 +948,8 @@ static void store_felem(u64 *b, u64 *f)
>  {
>         u64 f30 = f[3U];
>         u64 top_bit0 = f30 >> (u32)63U;
> -       u64 carry0;
>         u64 f31;
>         u64 top_bit;
> -       u64 carry;
>         u64 f0;
>         u64 f1;
>         u64 f2;
> @@ -970,11 +968,11 @@ static void store_felem(u64 *b, u64 *f)
>         u64 o2;
>         u64 o3;
>         f[3U] = f30 & (u64)0x7fffffffffffffffU;
> -       carry0 = add_scalar(f, f, (u64)19U * top_bit0);
> +       add_scalar(f, f, (u64)19U * top_bit0);
>         f31 = f[3U];
>         top_bit = f31 >> (u32)63U;
>         f[3U] = f31 & (u64)0x7fffffffffffffffU;
> -       carry = add_scalar(f, f, (u64)19U * top_bit);
> +       add_scalar(f, f, (u64)19U * top_bit);
>         f0 = f[0U];
>         f1 = f[1U];
>         f2 = f[2U];
> --

That seems obvious and reasonable, and so I'm inclined to ack this,
but I first wanted to give Karthik (CC'd) a chance to chime in here,
as it's his HACL* project that's responsible, and he might have some
curious insight.

Jason
