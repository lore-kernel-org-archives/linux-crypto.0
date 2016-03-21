From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 01/10] crypto: rsa - generalize ASN.1 sequences
Date: Mon, 21 Mar 2016 10:11:53 +0000
Message-ID: <AM3PR04MB1300BAEA8175AAA8B7BD5A41B88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <56EEB974.2030702@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0054.outbound.protection.outlook.com ([157.55.234.54]:30848
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbcCUKL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 06:11:56 -0400
In-Reply-To: <56EEB974.2030702@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

> -----Original Message-----
> From: Tadeusz Struk [mailto:tadeusz.struk@intel.com]
> Sent: Sunday, March 20, 2016 4:54 PM
> To: Tudor-Dan Ambarus; herbert@gondor.apana.org.au
> Cc: linux-crypto@vger.kernel.org; smueller@chronox.de; Horia Ioan Geanta
> Neag
> Subject: Re: [PATCH 01/10] crypto: rsa - generalize ASN.1 sequences


> static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  			    unsigned int keylen)
>  {
> 	struct rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> 	struct rsa_mpi_key *pkey = &ctx->key;
>  	int ret;
> 
> 	ctx->action = &impl_action;

[ta] we can do this once, when initializing the tfm object.

I agree with all your suggestions, I will implement them.

Thank you for the review,
ta
