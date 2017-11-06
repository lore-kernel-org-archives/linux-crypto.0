From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: caam - remove unused param of
 ctx_map_to_sec4_sg()
Date: Mon, 6 Nov 2017 15:07:23 +0800
Message-ID: <20171106070723.GB14274@gondor.apana.org.au>
References: <20171101071311.4328-1-horia.geanta@nxp.com>
 <20171101071311.4328-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51730 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdKFHHw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 02:07:52 -0500
Content-Disposition: inline
In-Reply-To: <20171101071311.4328-2-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 01, 2017 at 09:13:11AM +0200, Horia Geantă wrote:
> ctx_map_to_sec4_sg() function, added in
> commit 045e36780f115 ("crypto: caam - ahash hmac support")
> has never used the "desc" parameter, so let's drop it.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
