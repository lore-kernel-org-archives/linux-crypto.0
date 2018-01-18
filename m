From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: chelsio - Cleanup and bug fixes
Date: Thu, 18 Jan 2018 23:04:04 +1100
Message-ID: <20180118120404.GH20717@gondor.apana.org.au>
References: <cover.1515669022.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55396 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753505AbeARMEP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:04:15 -0500
Content-Disposition: inline
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 04:45:47PM +0530, Harsh Jain wrote:
> This series include cleanup, bug fixes and authenc algo supporting
>  ctr(aes)-sha operation.
> 
> Harsh Jain (5):
>   crypto: chelsio - Fix Indentation
>   crypto: chelsio - check for sg null
>   crypto: chelsio - Fix IV updated in XTS operation
>   crypto: chelsio - Add authenc versions of ctr and sha
>   crypto: chelsio - Remove dst sg size zero check
> 
>  drivers/crypto/chelsio/chcr_algo.c   | 299 ++++++++++++++++++++++++++---------
>  drivers/crypto/chelsio/chcr_crypto.h |   7 +-
>  2 files changed, 233 insertions(+), 73 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
