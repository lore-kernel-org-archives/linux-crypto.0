Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F07C2BA1A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 07:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FE420857
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 07:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDXHrG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 03:47:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43352 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgDXHrG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 03:47:06 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jRt36-0000eU-Qe; Fri, 24 Apr 2020 17:47:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Apr 2020 17:47:00 +1000
Date:   Fri, 24 Apr 2020 17:47:00 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: Jitter RNG SP800-90B compliance
Message-ID: <20200424074700.GD24682@gondor.apana.org.au>
References: <9339058.MEWKF1lRGI@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9339058.MEWKF1lRGI@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 17, 2020 at 09:32:53PM +0200, Stephan Müller wrote:
> Hi,
> 
> This patch set adds SP800-90B compliance to the Jitter RNG. The
> SP800-90B patch is tested for more than half a year in user space
> with the Jitter RNG version 2.2.0.
> 
> The full SP800-90B assessment of the Jitter RNG is provided at [1].
> 
> In addition, the DRBG implementation is updated to always be
> reseeded from the Jitter RNG. To ensure the DRBG is reseeded within
> an appropriate amount of time, the reseed threshold is lowered.
> 
> Changes v2:
> * Instead of free/alloc of the Jitter RNG instance in case of a health
>   test error, re-initialize the RNG instance by performing the
>   power-up test and after a success, clear the health test status and
>   error.
> 
> [1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf
> 
> Stephan Mueller (2):
>   crypto: Jitter RNG SP800-90B compliance
>   crypto: DRBG always seeded with SP800-90B compliant noise source
> 
>  crypto/drbg.c                |  26 ++-
>  crypto/jitterentropy-kcapi.c |  27 +++
>  crypto/jitterentropy.c       | 417 ++++++++++++++++++++++++++---------
>  include/crypto/drbg.h        |   6 +-
>  4 files changed, 363 insertions(+), 113 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
