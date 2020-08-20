Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F55C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B889720855
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgHTHoS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:44:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48980 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgHTHoR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:44:17 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8fF8-0006RC-Up; Thu, 20 Aug 2020 17:44:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Aug 2020 17:44:14 +1000
Date:   Thu, 20 Aug 2020 17:44:14 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200820074414.GA21848@gondor.apana.org.au>
References: <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
 <20200818223359.GA27712@gondor.apana.org.au>
 <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
 <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au>
 <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au>
 <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au>
 <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 20, 2020 at 09:33:21AM +0200, Ard Biesheuvel wrote:
>
> > On my machine the performance difference on a 1472-byte request
> > between SIMD and generic is 2161 vs. 7558 (cycles).
> 
> Sure. But your machine does not have the pathological FPU
> preserve/restore performance.

Why does that matter? These are numbers for cbc-aesni which means
just a single preserve/restore for the whole request.

Or are you saying on Ben's machine cbc-aesni would have worse
performance vs. aes-generic?
 
> The mac80211 CCMP code uses a synchronous ccm aead, which gets backed
> by a skcipher+ahash combo by the ccm template. So a synchronous ahash
> is fine for this particular case.

OK I was just grepping for cmac so didn't see this.

For this case, I think it's even more important that it be converted
over to async because its sending path is also in user context just
like IPsec.

So simply by sending wireless packets you can hog the CPU while
doing SIMD in kernel context which would then kill the receive
path if you're using the generic fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
