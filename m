Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6865FEB64DD
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jul 2023 02:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGVCN5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jul 2023 22:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGVCN4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2023 22:13:56 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF5430F0;
        Fri, 21 Jul 2023 19:13:54 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qN27f-002D80-OH; Sat, 22 Jul 2023 12:13:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Jul 2023 14:13:24 +1200
Date:   Sat, 22 Jul 2023 14:13:24 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     aric.pzqi@ingenic.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: hwrng: ingenic: simplify the code
Message-ID: <ZLs7RGhlbdhbOUK7@gondor.apana.org.au>
References: <20230710202733.116133-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710202733.116133-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 10, 2023 at 10:27:26PM +0200, Martin Kaiser wrote:
> Simplify the ingenic-trng driver a bit. Switch to devm_clk_get_enabled and
> devm_hwrng_register. Remove some unused code.
> 
> The changes were compile-tested only (I don't have this hardware).
> 
> Martin Kaiser (7):
>   hwrng: ingenic - enable compile testing
>   hwrng: ingenic - remove two unused defines
>   hwrng: ingenic - remove dead assignments
>   hwrng: ingenic - use devm_clk_get_enabled
>   hwrng: ingenic - use dev_err_probe in error paths
>   hwrng: ingenic - don't disable the rng in ingenic_trng_remove
>   hwrng: ingenic - switch to device managed registration
> 
>  drivers/char/hw_random/Kconfig        |  3 +-
>  drivers/char/hw_random/ingenic-trng.c | 57 ++++++---------------------
>  2 files changed, 12 insertions(+), 48 deletions(-)
> 
> -- 
> 2.30.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
