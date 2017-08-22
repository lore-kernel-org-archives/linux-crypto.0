From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: testmgr - add chunked test cases for chacha20
Date: Tue, 22 Aug 2017 15:58:36 +0800
Message-ID: <20170822075836.GH6269@gondor.apana.org.au>
References: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
 <20170814132815.24524-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        tobias@strongswan.org, martin@strongswan.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40886 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbdHVH6p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20170814132815.24524-2-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 14, 2017 at 02:28:15PM +0100, Ard Biesheuvel wrote:
> We failed to catch a bug in the chacha20 code after porting it to the
> skcipher API. We would have caught it if any chunked tests had been
> defined, so define some now so we will catch future regressions.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
