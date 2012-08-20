From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni_intel - improve lrw and xts performance
 by utilizing parallel AES-NI hardware pipelines
Date: Mon, 20 Aug 2012 16:31:19 +0800
Message-ID: <20120820083119.GA22951@gondor.apana.org.au>
References: <20120722151837.28864.2550.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:57487 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755394Ab2HTIbX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:31:23 -0400
Content-Disposition: inline
In-Reply-To: <20120722151837.28864.2550.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 22, 2012 at 06:18:37PM +0300, Jussi Kivilinna wrote:
> Use parallel LRW and XTS encryption facilities to better utilize AES-NI
> hardware pipelines and gain extra performance.
> 
> Tcrypt benchmark results (async), old vs new ratios:
> 
> Intel Core i5-2450M CPU (fam: 6, model: 42, step: 7)
> 
> aes:128bit
>         lrw:256bit      xts:256bit
> size    lrw-enc lrw-dec xts-dec xts-dec
> 16B     0.99x   1.00x   1.22x   1.19x
> 64B     1.38x   1.50x   1.58x   1.61x
> 256B    2.04x   2.02x   2.27x   2.29x
> 1024B   2.56x   2.54x   2.89x   2.92x
> 8192B   2.85x   2.99x   3.40x   3.23x
> 
> aes:192bit
>         lrw:320bit      xts:384bit
> size    lrw-enc lrw-dec xts-dec xts-dec
> 16B     1.08x   1.08x   1.16x   1.17x
> 64B     1.48x   1.54x   1.59x   1.65x
> 256B    2.18x   2.17x   2.29x   2.28x
> 1024B   2.67x   2.67x   2.87x   3.05x
> 8192B   2.93x   2.84x   3.28x   3.33x
> 
> aes:256bit
>         lrw:348bit      xts:512bit
> size    lrw-enc lrw-dec xts-dec xts-dec
> 16B     1.07x   1.07x   1.18x   1.19x
> 64B     1.56x   1.56x   1.70x   1.71x
> 256B    2.22x   2.24x   2.46x   2.46x
> 1024B   2.76x   2.77x   3.13x   3.05x
> 8192B   2.99x   3.05x   3.40x   3.30x
> 
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.  Thanks Jussi!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
