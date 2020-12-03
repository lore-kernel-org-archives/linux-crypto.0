Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E53BC63777
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 08:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A92B21D1A
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Dec 2020 08:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgLCIjZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:39:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57736 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbgLCIjU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Dec 2020 03:39:20 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kkk8D-00055r-5D; Thu, 03 Dec 2020 19:38:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Dec 2020 19:38:29 +1100
Date:   Thu, 3 Dec 2020 19:38:29 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH 0/5] crypto: caam - avoid allocating memory at crypto
 request runtime
Message-ID: <20201203083829.GA20873@gondor.apana.org.au>
References: <20201203013524.30495-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH+a2ZH=06GXsz4Lj2Bx2YOHmGubeY6i7x=ar5ubvP+7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH+a2ZH=06GXsz4Lj2Bx2YOHmGubeY6i7x=ar5ubvP+7g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 03, 2020 at 09:34:08AM +0100, Ard Biesheuvel wrote:
>
> > CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to
> > dm-crypt use-cases, which seems to be 4 entries maximum.
> > Therefore in reqsize we allocate memory for maximum 4 entries
> > for src and 4 for dst, aligned.
> > If the driver needs more than the 4 entries maximum, the memory
> > is dynamically allocated, at runtime.
> 
> I'm confused. So the driver does allocate memory in some cases, right?
> So why is it justified to remove CRYPTO_ALG_ALLOCATES_MEMORY?

Because it's only required by dm-crypt, we should modify the
semantics for ALLOCATES_MEMORY such that it only includes those
that require allocations even when the SG list is of 4 entries
or less.

We should update the documentation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
