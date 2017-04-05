From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix RNG deinstantiation error checking
Date: Wed, 5 Apr 2017 22:09:00 +0800
Message-ID: <20170405140900.GC27150@gondor.apana.org.au>
References: <20170405084103.19053-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37518 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbdDEOQT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:16:19 -0400
Content-Disposition: inline
In-Reply-To: <20170405084103.19053-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 05, 2017 at 11:41:03AM +0300, Horia Geantă wrote:
> RNG instantiation was previously fixed by
> commit 62743a4145bb9 ("crypto: caam - fix RNG init descriptor ret. code checking")
> while deinstantiation was not addressed.
> 
> Since the descriptors used are similar, in the sense that they both end
> with a JUMP HALT command, checking for errors should be similar too,
> i.e. status code 7000_0000h should be considered successful.
> 
> Cc: <stable@vger.kernel.org> # 3.13+
> Fixes: 1005bccd7a4a6 ("crypto: caam - enable instantiation of all RNG4 state handles")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
