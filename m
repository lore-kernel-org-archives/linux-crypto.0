Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C778C61DA4
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 04:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjCOEd7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Mar 2023 00:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjCOEdz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2023 00:33:55 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5AE46142;
        Tue, 14 Mar 2023 21:33:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcI0Q-004UX3-62; Wed, 15 Mar 2023 11:40:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Mar 2023 11:40:50 +0800
Date:   Wed, 15 Mar 2023 11:40:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam/jr - fix algorithms exit/cleanup
Message-ID: <ZBE+QhPBxG7VhBry@gondor.apana.org.au>
References: <20230314180733.4167836-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314180733.4167836-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 11:37:33PM +0530, meenakshi.aggarwal@nxp.com wrote:
> From: Horia GeantA <horia.geanta@nxp.com>
> 
> Current implementations is not being able to gracefully unregister
> crypto algorithms from crypto API while there are users / allocated
> tfms (cra_refcnt > 1).
> 
> When unloading the caam_jr module, the .remove callback for the last JR
> device exits with -EBUSY and doesn't perform the clean-up
> (crypto algorithms unregistering etc.).
> 
> One side effect of this is leading to an oops, which occurs due to a
> corruption in the linked list of "misc devices"
> (drivers/char/misc.c - misc_list)
> 
> Signed-off-by: Horia GeantA <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/jr.c | 39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)

Sorry, I don't think this is the right way to go.

We need to disassociate the registration of the Crypto algorithms
(soft) from the presence of the hardware (hard).

Sure, you can certainly refuse to register any algorithms until
the first piece of hardware shows up.  But once you are registered,
you must not unregister yourself from the Crypto API until the module
actually goes away (when built-in that means never).

The complexity then goes into making sure that your driver fails
gracefully when the device goes away in the *middle* of a crypto
computation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
