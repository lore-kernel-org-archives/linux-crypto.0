Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFE5C001DE
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjG1KX0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbjG1KXJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:23:09 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD96F3A81;
        Fri, 28 Jul 2023 03:23:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qPKcc-0011sJ-4x; Fri, 28 Jul 2023 18:22:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jul 2023 18:22:58 +0800
Date:   Fri, 28 Jul 2023 18:22:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hwrng: cn10k - trivial cleanups
Message-ID: <ZMOXAuksGr6p7iA7@gondor.apana.org.au>
References: <20230721085444.496863-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721085444.496863-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 21, 2023 at 10:54:42AM +0200, Martin Kaiser wrote:
> Two trivial cleanups of the cn10k driver. Compile tested only.
> 
> Martin Kaiser (2):
>   hwrng: cn10k - delete empty remove function
>   hwrng: cn10k - use dev_err_probe
> 
>  drivers/char/hw_random/cn10k-rng.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
