From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gf128mul - remove incorrect comment
Date: Fri, 22 Dec 2017 20:07:10 +1100
Message-ID: <20171222090710.GD32542@gondor.apana.org.au>
References: <20171211215826.72183-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Harsh Jain <harsh@chelsio.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46420 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933922AbdLVJHR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:07:17 -0500
Content-Disposition: inline
In-Reply-To: <20171211215826.72183-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 01:58:26PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The comment in gf128mul_x8_ble() was copy-and-pasted from gf128mul.h and
> makes no sense in the new context.  Remove it.
> 
> Cc: Harsh Jain <harsh@chelsio.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
