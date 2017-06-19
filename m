From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos: Extend max key length for
 SHA384/512-HMAC and AEAD
Date: Mon, 19 Jun 2017 14:38:24 +0800
Message-ID: <20170619063824.GA13667@gondor.apana.org.au>
References: <20170502133835.GA17402@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org, horia.geanta@nxp.com
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59624 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdFSGiw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:38:52 -0400
Content-Disposition: inline
In-Reply-To: <20170502133835.GA17402@darwin.bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Martin Hicks <mort@bork.org> wrote:
> 
> An updated patch that also handles the additional key length requirements
> for the AEAD algorithms.
> 
> The max keysize is not 96.  For SHA384/512 it's 128, and for the AEAD
> algorithms it's longer still.  Extend the max keysize for the
> AEAD size for AES256 + HMAC(SHA512).
> 
> Cc: <stable@vger.kernel.org> # 3.6+
> Fixes: 357fb60502ede ("crypto: talitos - add sha224, sha384 and sha512 to existing AEAD algorithms")
> Signed-off-by: Martin Hicks <mort@bork.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
