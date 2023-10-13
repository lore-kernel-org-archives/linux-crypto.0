Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600F5CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 10:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjJMKjG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 06:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjJMKi7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 06:38:59 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD15C2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 03:38:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qrFZD-006jdY-AI; Fri, 13 Oct 2023 18:38:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Oct 2023 18:38:56 +0800
Date:   Fri, 13 Oct 2023 18:38:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        "Ospan, Abylay" <aospan@amazon.com>
Subject: Re: [PATCH] crypto: jitter - reuse allocated entropy collector
Message-ID: <ZSkeQN1BpELwkE2E@gondor.apana.org.au>
References: <2701954.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2701954.mvXUDI8C0e@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 07, 2023 at 09:10:43AM +0200, Stephan Müller wrote:
> In case a health test error occurs during runtime, the power-up health
> tests are rerun to verify that the noise source is still good and
> that the reported health test error was an outlier. For performing this
> power-up health test, the already existing entropy collector instance
> is used instead of allocating a new one. This change has the following
> implications:
> 
> * The noise that is collected as part of the newly run health tests is
>   inserted into the entropy collector and thus stirs the existing
>   data present in there further. Thus, the entropy collected during
>   the health test is not wasted. This is also allowed by SP800-90B.
> 
> * The power-on health test is not affected by the state of the entropy
>   collector, because it resets the APT / RCT state. The remainder of
>   the state is unrelated to the health test as it is only applied to
>   newly obtained time stamps.
> 
> This change also fixes a bug report about an allocation while in an
> atomic lock (the lock is taken in jent_kcapi_random, jent_read_entropy
> is called and this can call jent_entropy_init).
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy-kcapi.c |  2 +-
>  crypto/jitterentropy.c       | 36 ++++++++++++++++++++++++++----------
>  crypto/jitterentropy.h       |  2 +-
>  3 files changed, 28 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
