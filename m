Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24679C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358715AbhKZFht (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:37:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57160 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhKZFfr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:35:47 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTqc-0008Rn-NF; Fri, 26 Nov 2021 13:32:34 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTqc-0004aC-KX; Fri, 26 Nov 2021 13:32:34 +0800
Date:   Fri, 26 Nov 2021 13:32:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Jitter RNG - consider 32 LSB for APT
Message-ID: <20211126053234.GF17477@gondor.apana.org.au>
References: <2572116.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2572116.vuYhMxLoTh@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 21, 2021 at 03:14:20PM +0100, Stephan Müller wrote:
> The APT compares the current time stamp with a pre-set value. The
> current code only considered the 4 LSB only. Yet, after reviews by
> mathematicians of the user space Jitter RNG version >= 3.1.0, it was
> concluded that the APT can be calculated on the 32 LSB of the time
> delta. Thi change is applied to the kernel.
> 
> This fixes a bug where an AMD EPYC fails this test as its RDTSC value
> contains zeros in the LSB. The most appropriate fix would have been to
> apply a GCD calculation and divide the time stamp by the GCD. Yet, this
> is a significant code change that will be considered for a future
> update. Note, tests showed that constantly the GCD always was 32 on
> these systems, i.e. the 5 LSB were always zero (thus failing the APT
> since it only considered the 4 LSB for its calculation).
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
