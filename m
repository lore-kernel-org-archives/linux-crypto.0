From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mcryptd - remove pointless wrapper functions
Date: Thu, 15 Feb 2018 23:42:40 +0800
Message-ID: <20180215154240.GD7352@gondor.apana.org.au>
References: <20180125030907.679-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39476 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424241AbeBOPmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 10:42:50 -0500
Content-Disposition: inline
In-Reply-To: <20180125030907.679-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 24, 2018 at 07:09:07PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There is no need for ahash_mcryptd_{update,final,finup,digest}(); we
> should just call crypto_ahash_*() directly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
