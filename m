Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24A6C7619A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Mar 2023 05:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCUFxv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Mar 2023 01:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCUFxt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2023 01:53:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE8168B0;
        Mon, 20 Mar 2023 22:53:44 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1peUCr-006uMX-Mi; Tue, 21 Mar 2023 13:06:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Mar 2023 13:06:45 +0800
Date:   Tue, 21 Mar 2023 13:06:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaurav Jain <gaurav.jain@nxp.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] crypto: caam: Clear some memory in
 instantiate_rng()
Message-ID: <ZBk7ZdSacxFzJSxJ@gondor.apana.org.au>
References: <16d6bf3bd7a6e96a8262fcd4680e3ccbb5a50478.1679355849.git.christophe.jaillet@wanadoo.fr>
 <ZBkj9tUFl8OJeoic@gondor.apana.org.au>
 <AM0PR04MB6004F6DC17B8CB859D13EF1EE7819@AM0PR04MB6004.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6004F6DC17B8CB859D13EF1EE7819@AM0PR04MB6004.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 21, 2023 at 05:03:24AM +0000, Gaurav Jain wrote:
>
> memset() is needed to clear the desc for each state handle before recreating descriptor.
> So it is required.

OK so we should move it to the top of the loop then.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
