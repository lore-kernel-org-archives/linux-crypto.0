From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 01/10] crypto: testmgr - avoid DMA mapping from text,
 rodata, stack
Date: Wed, 23 Jul 2014 21:35:51 +0800
Message-ID: <20140723133551.GB29756@gondor.apana.org.au>
References: <1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
 <1406105978-16279-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36257 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGWNfy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 09:35:54 -0400
Content-Disposition: inline
In-Reply-To: <1406105978-16279-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 23, 2014 at 11:59:38AM +0300, Horia Geanta wrote:
> With DMA_API_DEBUG set, following warnings are emitted
> (tested on CAAM accelerator):
> DMA-API: device driver maps memory from kernel text or rodata
> DMA-API: device driver maps memory from stack
> and the culprits are:
> -key in __test_aead and __test_hash
> -result in __test_hash
> 
> MAX_KEYLEN is changed to accommodate maximum key length from
> existing test vectors in crypto/testmgr.h (131 bytes) and rounded.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
> v2: Addressed Kim's comments.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
