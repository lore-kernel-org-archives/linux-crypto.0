Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84658C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 07:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjAJHom (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 02:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjAJHol (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 02:44:41 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A4817595
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 23:44:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pF9JG-00FwqT-7o; Tue, 10 Jan 2023 15:44:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Jan 2023 15:44:38 +0800
Date:   Tue, 10 Jan 2023 15:44:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/6] crypto/realtek: hash algorithms
Message-ID: <Y70XZgwmxVzRLLd2@gondor.apana.org.au>
References: <Y7fjfYCQdbP+2MU8@gondor.apana.org.au>
 <0d119d3f54eb5decec58b2afcb2119902d8373db.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d119d3f54eb5decec58b2afcb2119902d8373db.camel@gmx.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 06, 2023 at 05:09:25PM +0100, Markus Stockhausen wrote:
>
> I thought that using wait_event() inside the above function should be
> sufficient to handle that. Any good example of how to achieve that type
> of completion?

I think most other drivers in drivers/crypto are async.

Essentially, you return -EINPROGRESS in the update/final functions
if the request was successfully queued to the hardware, and
once it completes you invoke the completion function.

If you don't have your own queueing mechanism, you should use
the crypto_engine API to queue the requests before they are
processed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
