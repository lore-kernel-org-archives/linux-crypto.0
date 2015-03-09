From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [V3 PATCH 0/2]  fix some CAAM warnings.
Date: Mon, 9 Mar 2015 21:07:31 +1100
Message-ID: <20150309100731.GA4452@gondor.apana.org.au>
References: <1425609282-16568-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@freescale.com, davem@davemloft.net,
	kim.phillips@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	jinyanjiang@gmail.com
To: yanjiang.jin@windriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34002 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbbCIKHn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 06:07:43 -0400
Content-Disposition: inline
In-Reply-To: <1425609282-16568-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 06, 2015 at 10:34:40AM +0800, yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> Hi,
> 
> This patch series fix some CAAM compile and runtime warnings.
> 
> I have tested this on fsl-p5020ds board using upstream 4.0.0-rc2 with the below configs:
> 
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> 
> Change log:
> v3:
> 
> 0001-crypto-caamhash-fix-uninitialized-edesc-sec4_sg_byte.patch is same as before.
> 
> For 0002-crypto-caam_rng-fix-rng_unmap_ctx-s-DMA_UNMAP-size-p.patch
> 1. Fix an alignment issue;
> 2. update DESC_RNG_LEN to (4 * CAAM_CMD_SZ).
> 
> Abandon the v2 patch 0001-crypto-caam-fix-some-compile-warnings.patch.

All applied.  Thanks
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
