From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
Date: Wed, 11 May 2016 18:52:34 +0800
Message-ID: <20160511105234.GA25016@gondor.apana.org.au>
References: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160503073957.GA16836@gondor.apana.org.au>
 <VI1PR04MB1311A94658FE756E27429557B8720@VI1PR04MB1311.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33862 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbcEKKwk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 06:52:40 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR04MB1311A94658FE756E27429557B8720@VI1PR04MB1311.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 11, 2016 at 07:41:31AM +0000, Tudor-Dan Ambarus wrote:
>
> If I move the DMA primitives to the driver context,
> I can't assure software coherency enforcement in rsa helper.
> 
> If so, after the ANS.1 parsing, if a driver needs to enforce software
> coherency, it will have to allocate coherent memory and copy
> the ANS.1 parsed data there. Is this acceptable?

Of course you can assume the memory comes from kmalloc.  Since
your driver is going to be calling the RSA helper to parse the
keys we can surely make the guarantee that the RSA helper only
returns kmalloced memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
