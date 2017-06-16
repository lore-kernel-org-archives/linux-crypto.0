From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/2] crypto: caam - fix cts(cbc(aes)) with CAAM driver
Date: Fri, 16 Jun 2017 15:59:41 +0800
Message-ID: <20170616075941.GA5346@gondor.apana.org.au>
References: <20170602122446.2427-1-david@sigma-star.at>
 <VI1PR0401MB25910B19DB95DABF62C00A7598C00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB25913AAA76159D27E8EB13DF98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57134 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbdFPIAK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 04:00:10 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB25913AAA76159D27E8EB13DF98C10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 16, 2017 at 07:57:00AM +0000, Horia Geantă wrote:
>
> Commit 0605c41cc53ca ("crypto: cts - Convert to skcipher") appends
> CRYPTO_TFM_REQ_MAY_BACKLOG to the original crypto request flags for the
> last block - when calling cts_cbc_encrypt().
> Is it really needed?

Yes, because at this point we cannot tell the sender to back off.

> For cts(cbc(aes)) with cbc(aes) offloaded in HW, i.e. running in async
> mode, we get the below stack for CAAM driver.
> Driver is told that it can sleep (CRYPTO_TFM_REQ_MAY_BACKLOG flag), so
> it uses GFP_KERNEL to allocate memory. However, this is incorrect, since
> driver runs in atomic context (softirq).

This is wrong.  Whether you can sleep or not is determined by
MAY_SLEEP, not MAY_BACKLOG.  MAY_BACKLOG only indicates that this
request must be queued, even if the queue is full.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
