From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: caam - convert from ablkcipher -> skcipher
Date: Fri, 28 Jul 2017 16:56:22 +0800
Message-ID: <20170728085622.GC19664@gondor.apana.org.au>
References: <1472479884-1887-1-git-send-email-horia.geanta@nxp.com>
 <20160901101257.GA3362@gondor.apana.org.au>
 <VI1PR0401MB2591F6D4CAD871490564A2EE98BF0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37948 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdG1I43 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 04:56:29 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2591F6D4CAD871490564A2EE98BF0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 28, 2017 at 06:46:03AM +0000, Horia Geantă wrote:
>
> If I am to add a new driver, would it be possible and/or advisable to
> use skcipher?

It should be OK.  Let me know if you have any issues with the API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
