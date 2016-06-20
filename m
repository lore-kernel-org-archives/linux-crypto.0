From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
Date: Tue, 21 Jun 2016 07:49:00 +0800
Message-ID: <20160620234900.GA18131@gondor.apana.org.au>
References: <1466174265-4546-1-git-send-email-salvatore.benedetto@intel.com>
 <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
 <20160620111524.GB10601@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193586D@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42833 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbcFUAeK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 20:34:10 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D03193586D@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 20, 2016 at 11:43:28AM +0000, Benedetto, Salvatore wrote:
>
> > While you're at it, it would be nice if you could make the encoded format
> > little-endian, that way we can make test vectors for all kpp algorithms use
> > the same format.
> > 
> 
> The input format is the same for DH and ECDH.
> Only the software implementation of ECC requires little-endian format.

What I mean is to get rid of the DH-specific code in testmgr.c
and directly encode the secret into the test vector rather than
calling the helper.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
