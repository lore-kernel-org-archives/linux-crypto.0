From: David Gstir <david@sigma-star.at>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Mon, 26 Jun 2017 07:40:58 +0200
Message-ID: <2EF4805B-514F-48AD-95BB-170AF7B24D36@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
 <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170620012858.GA16207@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: =?utf-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdFZFlB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 01:41:01 -0400
In-Reply-To: <20170620012858.GA16207@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

> On 20 Jun 2017, at 03:28, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> On Mon, Jun 19, 2017 at 10:31:27AM +0000, Horia Geantă wrote:
>> 
>> IIUC, IV update is required only in case of CBC.
>> Since this callback is used also for CTR, we should avoid the copy:
>> if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC) ...
> 
> No it is needed for CTR too.

So, am I correct in assuming that it is required for all modes including AEAD modes like GCM?
In that case I'll include a fix for the CAAM GCM mode too.

Thanks,
David
