From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: caam - fix signals handling
Date: Wed, 12 Jul 2017 18:51:23 +0800
Message-ID: <20170712105123.GA22109@gondor.apana.org.au>
References: <20170707135706.5487-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45576 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755884AbdGLKvy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 06:51:54 -0400
Content-Disposition: inline
In-Reply-To: <20170707135706.5487-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 07, 2017 at 04:57:06PM +0300, Horia Geantă wrote:
> Driver does not properly handle the case when signals interrupt
> wait_for_completion_interruptible():
> -it does not check for return value
> -completion structure is allocated on stack; in case a signal interrupts
> the sleep, it will go out of scope, causing the worker thread
> (caam_jr_dequeue) to fail when it accesses it
> 
> wait_for_completion_interruptible() is replaced with uninterruptable
> wait_for_completion().
> We choose to block all signals while waiting for I/O (device executing
> the split key generation job descriptor) since the alternative - in
> order to have a deterministic device state - would be to flush the job
> ring (aborting *all* in-progress jobs).
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 045e36780f115 ("crypto: caam - ahash hmac support")
> Fixes: 4c1ec1f930154 ("crypto: caam - refactor key_gen, sg")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
