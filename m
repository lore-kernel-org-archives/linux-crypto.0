From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: akcipher API: plans
Date: Wed, 26 Aug 2015 21:51:56 +0800
Message-ID: <20150826135156.GA24618@gondor.apana.org.au>
References: <8426933.kyc3qjWJkc@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36407 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbHZNwK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Aug 2015 09:52:10 -0400
Content-Disposition: inline
In-Reply-To: <8426933.kyc3qjWJkc@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:38:24AM +0200, Stephan Mueller wrote:
> 
> - Type of input data: currently, the akcipher API uses linear buffers. The 
> question was raised to convert it to scatter lists. Linear buffers were seen 
> as appropriate as the data to be operated on is usually quite small. However, 
> some hardware seems to support scatter lists (CAAM was mentioned). 

I think an SG interface makes sense even if today's algorithms
don't need it.  The user-space interface is naturally SG based
for example.

> - Split of setkey into public/private setkey function. The current 
> implementation provides ASN.1 structure that allows setting all three 
> components forming a public and private key. However, considering the next 
> bullet, a split int pub/priv key may need to be considered.

I think this makes sense too.

> - Structure of keys: The current ASN.1 structure is used solely in the kernel. 
> Thus, DER keys generated in user space (like by OpenSSL) can only be loaded 
> after a conversion. To support such DER keys out of the box, I think only the 
> ASN.1 definition must be changed. In addition, the setkey function must be 
> split as the ASN.1 structures of a DER pub and private key are completely 
> different.

Ditto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
