From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v11 0/2] crypto: AF_ALG memory management fix
Date: Fri, 28 Jul 2017 21:56:36 +0800
Message-ID: <20170728135636.GA21943@gondor.apana.org.au>
References: <6602969.vlMq0gDBpR@positron.chronox.de>
 <20170728134936.GA21401@gondor.apana.org.au>
 <3098923.xryRsmobXR@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39950 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdG1N4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 09:56:42 -0400
Content-Disposition: inline
In-Reply-To: <3098923.xryRsmobXR@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 28, 2017 at 03:53:55PM +0200, Stephan Müller wrote:
>
> I would add the common service code to crypto/af_alg.c or do you prefer a 
> separate or different file?

af_alg.c is OK.

> As the copy-AAD patch is also outstanding, in which order would you like to 
> receive the patches (first the code consolidation patches or first the copy-
> AAD patch)?

Either way is fine by me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
