Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B183CE748E9
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 08:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbjJAIeH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 04:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjJAIeG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 04:34:06 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A19E0
        for <linux-crypto@vger.kernel.org>; Sun,  1 Oct 2023 01:34:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qmrtm-002PVd-Ec; Sun, 01 Oct 2023 16:33:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Oct 2023 16:34:02 +0800
Date:   Sun, 1 Oct 2023 16:34:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>
Subject: Re: [PATCH 0/3] crypto: jitter - Offer compile-time options
Message-ID: <ZRku+rwwvPTmzBfb@gondor.apana.org.au>
References: <2700818.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2700818.mvXUDI8C0e@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 21, 2023 at 01:47:32PM +0200, Stephan Müller wrote:
> Hi,
> 
> the following patchset offers a set of compile-time options to
> accommodate different hardware with different entropy rates implied
> in their timers. This allows configuring the Jitter RNG in systems
> which exhibits insufficient entropy with the default parameters. The
> default parameters defined by the patches, however, are identical to
> the existing code and thus do not alter the Jitter RNG behavior.
> 
> The first patch sets the state by allowing the configuration of
> different oversampling rates. The second patch allows the configuration
> of different memory sizes and the third allows the configuration
> of differnet oversampling rates.
> 
> The update of the power up test with the first patch also addresses
> reports that the Jitter RNG did not initialize due to it detected
> insufficient entropy.
> 
> Stephan Mueller (3):
>   crypto: jitter - add RCT/APT support for different OSRs
>   crypto: jitter - Allow configuration of memory size
>   crypto: jitter - Allow configuration of oversampling rate
> 
>  crypto/Kconfig               |  60 +++++++++
>  crypto/jitterentropy-kcapi.c |  17 ++-
>  crypto/jitterentropy.c       | 249 ++++++++++++++++++-----------------
>  crypto/jitterentropy.h       |   5 +-
>  4 files changed, 207 insertions(+), 124 deletions(-)
> 
> -- 
> 2.42.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
