From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: rsa - generalize ASN.1 sequences
Date: Mon, 25 Apr 2016 13:58:56 +0800
Message-ID: <20160425055856.GA8248@gondor.apana.org.au>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1459949826-11840-2-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160415135245.GA334@gondor.apana.org.au>
 <VI1PR04MB13110F6720DB1578EC6AF0B2B8680@VI1PR04MB1311.eurprd04.prod.outlook.com>
 <20160415143851.GK733@gondor.apana.org.au>
 <VI1PR04MB1311589CC8A871EF1543B4ECB8680@VI1PR04MB1311.eurprd04.prod.outlook.com>
 <VI1PR04MB1311D4BC09290639FD8F6581B8620@VI1PR04MB1311.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'linux-crypto@vger.kernel.org'" <linux-crypto@vger.kernel.org>,
	"'tadeusz.struk@intel.com'" <tadeusz.struk@intel.com>,
	"'smueller@chronox.de'" <smueller@chronox.de>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40859 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcDYF7F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 01:59:05 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR04MB1311D4BC09290639FD8F6581B8620@VI1PR04MB1311.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 05:54:44AM +0000, Tudor-Dan Ambarus wrote:
>
> Do you want me to address some suggestions, or do you intend to apply this patch set?

Please ensure that we have exactly one parser for the RSA keys.
It should just return the raw integer with no other processing.

The software RSA implementation can then do the MPI conversion
on top.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
