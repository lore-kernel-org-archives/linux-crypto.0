From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Mon, 26 Jun 2017 14:47:44 +0800
Message-ID: <20170626064744.GA3540@gondor.apana.org.au>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
 <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170620012858.GA16207@gondor.apana.org.au>
 <2EF4805B-514F-48AD-95BB-170AF7B24D36@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Gstir <david@sigma-star.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38346 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdFZGsP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 02:48:15 -0400
Content-Disposition: inline
In-Reply-To: <2EF4805B-514F-48AD-95BB-170AF7B24D36@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 26, 2017 at 07:40:58AM +0200, David Gstir wrote:
>
> So, am I correct in assuming that it is required for all modes including AEAD modes like GCM?
> In that case I'll include a fix for the CAAM GCM mode too.

It's only required for skcihper.  As we do not do chunking/streaming
with our AEAD interface it is not required for GCM.
  
Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
