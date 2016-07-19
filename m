From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell: Fix wrong flag used for GFP in
 mv_cesa_dma_add_iv_op
Date: Tue, 19 Jul 2016 15:44:53 +0800
Message-ID: <20160719074452.GA22473@gondor.apana.org.au>
References: <20160718120057.3acbfc95@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: romain.perier@free-electrons.com, arno@natisbad.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
	gregory.clement@free-electrons.com
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41244 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbcGSHpD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jul 2016 03:45:03 -0400
Content-Disposition: inline
In-Reply-To: <20160718120057.3acbfc95@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> On Mon, 18 Jul 2016 11:32:24 +0200
> Romain Perier <romain.perier@free-electrons.com> wrote:
> 
>> Use the parameter 'gfp_flags' instead of 'flag' as second argument of
>> dma_pool_alloc(). The parameter 'flag' is for the TDMA descriptor, its
>> content has no sense for the allocator.
>> 
>> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> 
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> Herbert, can you add the following line when applying then patch?
> 
> Fixes: bac8e805a30d ("crypto: marvell - Copy IV vectors by DMA transfers for acipher requests")

Patch applied with the fixes tag.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
