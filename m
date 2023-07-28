Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D1AC001DE
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 10:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbjG1KWn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 06:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbjG1KWj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 06:22:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12263A9B;
        Fri, 28 Jul 2023 03:22:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qPKc3-0011rQ-PY; Fri, 28 Jul 2023 18:22:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jul 2023 18:22:23 +0800
Date:   Fri, 28 Jul 2023 18:22:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] hwrng: cctrng - simplify the code a bit
Message-ID: <ZMOW3+cl6hnWqInN@gondor.apana.org.au>
References: <20230719071806.335718-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719071806.335718-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 19, 2023 at 09:18:02AM +0200, Martin Kaiser wrote:
> We can use module_platform_driver and devm_clk_get_optional_enabled in the
> cctrng driver to make its code simpler.
> 
> The patches were compile tested only.
> 
> Martin Kaiser (4):
>   hwrng: cctrng - don't open code init and exit functions
>   hwrng: cctrng - let devres enable the clock
>   hwrng: cctrng - merge cc_trng_clk_init into its only caller
>   hwrng: cctrng - use dev_err_probe in error paths
> 
>  drivers/char/hw_random/cctrng.c | 93 +++++++--------------------------
>  1 file changed, 19 insertions(+), 74 deletions(-)

All applied.  Thanks.
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
