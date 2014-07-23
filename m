From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Base AXI DMA cache settings on device tree
Date: Wed, 23 Jul 2014 21:35:27 +0800
Message-ID: <20140723133527.GA29756@gondor.apana.org.au>
References: <20140710155835.17665.84896.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51786 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGWNfb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 09:35:31 -0400
Content-Disposition: inline
In-Reply-To: <20140710155835.17665.84896.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 10, 2014 at 10:58:35AM -0500, Tom Lendacky wrote:
> The default cache operations for ARM64 were changed during 3.15.
> To use coherent operations a "dma-coherent" device tree property
> is required.  If that property is not present in the device tree
> node then the non-coherent operations are assigned for the device.
> 
> Add support to the ccp driver to assign the AXI DMA cache settings
> based on whether the "dma-coherent" property is present in the device
> node.  If present, use settings that work with the caches.  If not
> present, use settings that do not look at the caches.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
