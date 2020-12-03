Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B469C63777
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 08:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31036217A0
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 08:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgLCIfC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLCIfC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Dec 2020 03:35:02 -0500
X-Gm-Message-State: AOAM5318Q0F9G6RFSTrsh3ykdzXu3n9cO4RbPD2VBHqb7M//Ug/i98Ah
        27C4IpykI7KfPhNTv6T28FVXpaCtP5+juUqsKW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606984461;
        bh=TNRBc8S70fvhf0yHPyoCSgJuCvQHb9iMJHwcNzjGzxc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RoODslOz3BhkHfLn8+8sRO2TBxS4PKAj8zSzfTJDcToF45/5pq2xVEWyOJdJlLPql
         kgHHkbGw5q14RS3IChotlTaVjAn24iEipCHSpLd/x9m4TR2ubLMsE7LfUz3cdtszAE
         7GjBQONeiX/ZSZlHBgHqk70Tp43RogS91UnSGlXTfa8VA4h9cgWEQX/08wF2p+veP/
         EA7qtYFuX+bT3EK8p5ujud0kvhM1bnsxf3awESRZrkuwcsqpznM1u/BjT5CWDl86Er
         d9IlxDmStAZzKkM7eKpJphr+k/T+uUPzrhTysKnUmCvl6N8+bK5X0wMknPe7n6swu6
         jMU4GSZUez6wQ==
X-Google-Smtp-Source: ABdhPJzf/lk1AM9MePWVi9O9FasTnU78oWvJQPhG9AV4DMgNQjdXYlVVVWEciE8XVC0YG1P5PqsrcpB7pMiy9CyiS2c=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr1341707otk.108.1606984460342;
 Thu, 03 Dec 2020 00:34:20 -0800 (PST)
MIME-Version: 1.0
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
In-Reply-To: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 3 Dec 2020 09:34:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH+a2ZH=06GXsz4Lj2Bx2YOHmGubeY6i7x=ar5ubvP+7g@mail.gmail.com>
Message-ID: <CAMj1kXH+a2ZH=06GXsz4Lj2Bx2YOHmGubeY6i7x=ar5ubvP+7g@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: caam - avoid allocating memory at crypto
 request runtime
To:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 3 Dec 2020 at 02:35, Iuliana Prodan (OSS)
<iuliana.prodan@oss.nxp.com> wrote:
>
> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>
> This series removes CRYPTO_ALG_ALLOCATES_MEMORY flag and
> allocates the memory needed by the driver, to fulfil a
> request, within the crypto request object.
> The extra size needed for base extended descriptor, hw
> descriptor commands and link tables is added to the reqsize
> field that indicates how much memory could be needed per request.
>
> CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
> dm-crypt use-cases, which seems to be 4 entries maximum.
> Therefore in reqsize we allocate memory for maximum 4 entries
> for src and 4 for dst, aligned.
> If the driver needs more than the 4 entries maximum, the memory
> is dynamically allocated, at runtime.
>

I'm confused. So the driver does allocate memory in some cases, right?
So why is it justified to remove CRYPTO_ALG_ALLOCATES_MEMORY?

> Iuliana Prodan (5):
>   crypto: caam/jr - avoid allocating memory at crypto request runtime
>     for skcipher
>   crypto: caam/jr - avoid allocating memory at crypto request runtime
>     for aead
>   crypto: caam/jr - avoid allocating memory at crypto request runtime
>     fost hash
>   crypto: caam/qi - avoid allocating memory at crypto request runtime
>   crypto: caam/qi2 - avoid allocating memory at crypto request runtime
>
>  drivers/crypto/caam/caamalg.c     | 141 +++++++---
>  drivers/crypto/caam/caamalg_qi.c  | 134 ++++++----
>  drivers/crypto/caam/caamalg_qi2.c | 415 ++++++++++++++++++++----------
>  drivers/crypto/caam/caamalg_qi2.h |   6 +
>  drivers/crypto/caam/caamhash.c    |  77 ++++--
>  5 files changed, 538 insertions(+), 235 deletions(-)
>
> --
> 2.17.1
>
