From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Fri, 23 Jun 2017 14:31:54 +0800
Message-ID: <20170623063154.GA29002@gondor.apana.org.au>
References: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
 <20170622024051.GA24529@gondor.apana.org.au>
 <DB6PR04MB317607AE27DD1AC235D0103C8BDB0@DB6PR04MB3176.eurprd04.prod.outlook.com>
 <20170622075338.GA25314@gondor.apana.org.au>
 <1498139799.26231.10.camel@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
To: Radu Solea <radu.solea@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35912 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754486AbdFWGcT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 02:32:19 -0400
Content-Disposition: inline
In-Reply-To: <1498139799.26231.10.camel@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 22, 2017 at 01:56:40PM +0000, Radu Solea wrote:
> There are two ways of fixing this AFAIK: the first is adding
> cacheline_aligned so those fields don't fall into the same cacheline.
> The second is to kzalloc hash and iv separately. kmalloc should honor
> ARCH_DMA_MINALIGN which would make this issue go away. 

Thanks for the explanation.  I see the problem now.

The crypto API cannot rely on users providing aligned buffers.  So
if your driver has an alignment requirement, it either has to use
the existing crypto API alignmask setting which can cope with some
unaligned inputs, e.g., the IV if you use the skcipher walk mechanism,
or you must copy unaligned data yourself before performing DMA on them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
