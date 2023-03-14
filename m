Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B815C6FD1F
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Mar 2023 09:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCNJHs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCNJHr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 05:07:47 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F49B92BDC
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 02:07:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pc0d9-0043JH-W9; Tue, 14 Mar 2023 17:07:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Mar 2023 17:07:39 +0800
Date:   Tue, 14 Mar 2023 17:07:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 3/3] hwrng: xgene - Improve error reporting for problems
 during .remove()
Message-ID: <ZBA5WxV/ZqNHNne/@gondor.apana.org.au>
References: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
 <20230214162829.113148-4-u.kleine-koenig@pengutronix.de>
 <20230314090409.pwcveukfk55z2cuk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314090409.pwcveukfk55z2cuk@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 14, 2023 at 10:04:09AM +0100, Uwe Kleine-König wrote:
>
> I don't know how/if Herbert will fix this, but for the Record:
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I've fixed it in my tree.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
