From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypt: bfin_crc: Remove useless SSYNC instruction and
 cache flush to DMA coherent memory
Date: Mon, 10 Mar 2014 20:21:00 +0800
Message-ID: <20140310122059.GB10556@gondor.apana.org.au>
References: <1393382356-9422-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47469 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaCJMVD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:21:03 -0400
Content-Disposition: inline
In-Reply-To: <1393382356-9422-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 26, 2014 at 10:39:16AM +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> 1) SSYNC instruction is blackfin specific and takes no effect in this driver.
> 2) DMA descriptor and SG middle buffer are in DMA coherent memory. No need
> to flush.
> 3) Turn kzalloc, ioremap and request_irq into managed device APIs respectively.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
