Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C28C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2218208A9
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 07:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHTH3O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:29:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48956 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgHTH3N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 03:29:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8f0Y-0006GE-Vl; Thu, 20 Aug 2020 17:29:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Aug 2020 17:29:10 +1000
Date:   Thu, 20 Aug 2020 17:29:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200820072910.GA21631@gondor.apana.org.au>
References: <20200818221550.GA27421@gondor.apana.org.au>
 <20200818222719.GA27622@gondor.apana.org.au>
 <bee1a9ce-25d1-2520-5f6a-3966bfa501d2@candelatech.com>
 <20200818223359.GA27712@gondor.apana.org.au>
 <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
 <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au>
 <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au>
 <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 20, 2020 at 09:19:16AM +0200, Ard Biesheuvel wrote:
>
> Actually, I'm not so sure that they will be so much worse. The
> expensive FPU preserve/restore occurs for every 16 bytes of data
> processed by the AES cipher, which I'd estimate to take ~10 cycles per
> byte for an unaccelerated implementation. But table based AES should
> be avoided, especially for MAC algorithms where the plaintext may be
> known to an attacker who is after the key.

On my machine the performance difference on a 1472-byte request
between SIMD and generic is 2161 vs. 7558 (cycles).
> 
> However, the CCMP handling is invoked from softirq context or from
> task context, and so SIMD is generally available unless the softirq
> happens to be taken over the back of a hardirq that interrupted a task
> running in the kernel that was using the SIMD already. IOW, this
> happens so rarely in practice that I would not expect it to be
> noticeable in the performance stats.

What if the same machine was doing TLS/IPsec sends at full throttle?
That would be exactly the wrong time to slow down softirqs four-fold,
no?

> My v2 attempt at cbcmac(aesni) implements an ahash, but a synchronous
> one. This means we can amortize the FPU preserve/restore over the
> entire scatterlist, instead of relying on the ahash walk to present
> the data in virtually mapped chunks.
> 
> I'd still like to explore this approach, but I simply haven't had the
> spare cycles to spend on this.

I don't have an issue your patch per se.  But please make it so that
it has the async path like everything else.  Also wireless uses shash
so it can't use an ahash anyway even if it is sync.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
