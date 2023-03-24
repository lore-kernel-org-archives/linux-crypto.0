Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61749C6FD1C
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 10:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjCXK3s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjCXK3h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 06:29:37 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AAF20544
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 03:29:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfefk-008FcZ-Kb; Fri, 24 Mar 2023 18:29:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Mar 2023 18:29:24 +0800
Date:   Fri, 24 Mar 2023 18:29:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] crypto: keembay-ocs-aes: Drop if with an always false
 condition
Message-ID: <ZB17hCeD5rSxnPic@gondor.apana.org.au>
References: <20230314182338.2869452-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314182338.2869452-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 07:23:38PM +0100, Uwe Kleine-König wrote:
> A platform device's remove callback is only ever called after the probe
> callback returned success.
> 
> In the case of kmb_ocs_aes_remove() this means that kmb_ocs_aes_probe()
> succeeded before and so platform_set_drvdata() was called with a
> non-zero argument and platform_get_drvdata() returns non-NULL.
> 
> This prepares making remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/keembay/keembay-ocs-aes-core.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
