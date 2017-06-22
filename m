From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Thu, 22 Jun 2017 15:53:38 +0800
Message-ID: <20170622075338.GA25314@gondor.apana.org.au>
References: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
 <20170622024051.GA24529@gondor.apana.org.au>
 <DB6PR04MB317607AE27DD1AC235D0103C8BDB0@DB6PR04MB3176.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
To: Radu Solea <radu.solea@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34526 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdFVHyD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 03:54:03 -0400
Content-Disposition: inline
In-Reply-To: <DB6PR04MB317607AE27DD1AC235D0103C8BDB0@DB6PR04MB3176.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 22, 2017 at 05:03:44AM +0000, Radu Solea wrote:
> I'm adding ____cacheline_aligned to iv and result. That is done so hash, iv and result never share a cache line.

Yes but you're doing it in crypto/gcm.c which isn't even used by
caam AFAIK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
