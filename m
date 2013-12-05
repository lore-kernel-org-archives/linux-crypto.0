From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - fix locating offending descriptor in
 error path
Date: Thu, 5 Dec 2013 22:35:45 +0800
Message-ID: <20131205143544.GC1976@gondor.apana.org.au>
References: <1384338037-25287-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Lei Xu <Lei.Xu@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34276 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3LEOfr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 09:35:47 -0500
Content-Disposition: inline
In-Reply-To: <1384338037-25287-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 13, 2013 at 12:20:37PM +0200, Horia Geanta wrote:
> Commit 3e721aeb3df3816e283ab18e327cd4652972e213
> ("crypto: talitos - handle descriptor not found in error path")
> tried to address the fact that CDPR (Current Descriptor Pointer Register)
> is unreliable.
> 
> As it turns out, there are still issues in the function detecting the
> offending descriptor:
> -only 32 bits of the descriptor address are read, however the address is
> 36-bit - since reset_channel() initializes channels with EAE (extended
> address) bit set
> -reading CDPR can return zero in cur_desc; when searching the channel
> fifo for this address, cur_desc == dma_desc (= 0) case might happen,
> leading to an oops when trying to return desc->hdr (desc is zero)
> -read channel's .tail only once; the tail is a moving target; use a
> local variable for the end of search condition
> 
> Signed-off-by: Lei Xu <Lei.Xu@freescale.com>
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> Tested-by: Kalyani Chowdhury <Kalyani.Chowdhury@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
