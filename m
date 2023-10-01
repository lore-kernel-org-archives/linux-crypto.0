Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE54E748ED
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 08:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbjJAIfZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 04:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjJAIfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 04:35:25 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91783
        for <linux-crypto@vger.kernel.org>; Sun,  1 Oct 2023 01:35:22 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qmruy-002PYg-CW; Sun, 01 Oct 2023 16:35:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Oct 2023 16:35:16 +0800
Date:   Sun, 1 Oct 2023 16:35:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 0/2] crypto: CMake crypto_engine_exit() return void
Message-ID: <ZRkvRKhqOqv9hwJz@gondor.apana.org.au>
References: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 23, 2023 at 12:08:04PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> all but one crypto driver ignore the return code of
> crypto_engine_exit(). This is ok as this function is called in
> situations (remove callback, or error path of probe) where errors cannot
> be handled anyhow. This series adapts the only driver that doesn't
> ignore the error code (and removes the bogous try to handle it) and then
> changes crypto_engine_exit() to return void to prevent similar silly
> tries in the future.
> 
> Note however there is still something to fix: If crypto_engine_stop()
> fails in crypto_engine_exit() the kworker stays around but *engine will
> be freed. So if something triggers the worker afterwards, this results
> in an oops (or memory corruption if the freed memory is reused already).
> This needs adaptions in the core, specific device drivers are unaffected
> by this, so changing crypto_engine_exit() to return void is a step in
> the right direction for this fix, too.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (2):
>   crypto: keembay - Don't pass errors to the caller in .remove()
>   crypto: Make crypto_engine_exit() return void
> 
>  crypto/crypto_engine.c                              |  8 ++------
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 11 +++--------
>  include/crypto/engine.h                             |  2 +-
>  3 files changed, 6 insertions(+), 15 deletions(-)
> 
> base-commit: 940fcc189c51032dd0282cbee4497542c982ac59
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
