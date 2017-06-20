From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Tue, 20 Jun 2017 09:28:58 +0800
Message-ID: <20170620012858.GA16207@gondor.apana.org.au>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
 <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60810 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdFTCWP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 22:22:15 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 19, 2017 at 10:31:27AM +0000, Horia Geantă wrote:
>
> IIUC, IV update is required only in case of CBC.
> Since this callback is used also for CTR, we should avoid the copy:
> if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC) ...

No it is needed for CTR too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
