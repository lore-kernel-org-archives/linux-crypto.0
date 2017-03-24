From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: DRBG - initialize SGL only once
Date: Fri, 24 Mar 2017 22:15:05 +0800
Message-ID: <20170324141504.GJ14780@gondor.apana.org.au>
References: <1909030.BalyQCuxjY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42734 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965313AbdCXOPT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:15:19 -0400
Content-Disposition: inline
In-Reply-To: <1909030.BalyQCuxjY@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 22, 2017 at 03:26:36PM +0100, Stephan Müller wrote:
> An SGL to be initialized only once even when its buffers are written
> to several times.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
