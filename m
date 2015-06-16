From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 11/11] crypto: caam - fix RNG buffer cache alignment
Date: Tue, 16 Jun 2015 14:41:57 +0800
Message-ID: <20150616064157.GD22176@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-12-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55613 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbFPGmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:42:00 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-12-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:59PM -0700, Victoria Milhoan wrote:
> From: Steve Cornelius <steve.cornelius@freescale.com>
> 
> The hwrng output buffers (2) are cast inside of a a struct (caam_rng_ctx)
> allocated in one DMA-tagged region. While the kernel's heap allocator
> should place the overall struct on a cacheline aligned boundary, the 2
> buffers contained within may not necessarily align. Consenquently, the ends
> of unaligned buffers may not fully flush, and if so, stale data will be left
> behind, resulting in small repeating patterns.

Applied to crypto with stable CC.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
