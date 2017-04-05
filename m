From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix invalid dereference in
 caam_rsa_init_tfm()
Date: Wed, 5 Apr 2017 22:08:51 +0800
Message-ID: <20170405140851.GB27150@gondor.apana.org.au>
References: <20170403153007.30455-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37480 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755510AbdDEON5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:13:57 -0400
Content-Disposition: inline
In-Reply-To: <20170403153007.30455-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 03, 2017 at 06:30:07PM +0300, Horia Geantă wrote:
> In case caam_jr_alloc() fails, ctx->dev carries the error code,
> thus accessing it with dev_err() is incorrect.
> 
> Cc: <stable@vger.kernel.org> # 4.8+
> Fixes: 8c419778ab57e ("crypto: caam - add support for RSA algorithm")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
