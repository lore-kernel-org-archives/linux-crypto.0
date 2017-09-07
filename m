From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Thu, 7 Sep 2017 14:09:22 +0800
Message-ID: <20170907060922.GA21281@gondor.apana.org.au>
References: <4634467.01PS30tDXi@positron.chronox.de>
 <3142753.SSoe9WBuHN@positron.chronox.de>
 <20170907060108.GA21208@gondor.apana.org.au>
 <1950183.Or1rzax7nU@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56470 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753437AbdIGGJi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 02:09:38 -0400
Content-Disposition: inline
In-Reply-To: <1950183.Or1rzax7nU@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 07, 2017 at 08:04:25AM +0200, Stephan Mueller wrote:
>
> I sill send a new patch -- shall I first send it excluding stable so that we 
> can review it before bothering the stable folks?

You don't need to cc the email to stable@vger.kernel.org, just add
a Cc: tag in the patch description and it'll automatically go to
stable when it hits mainline.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
