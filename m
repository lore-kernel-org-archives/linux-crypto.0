From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: omap-sham: Adjust DMA parameters
Date: Fri, 3 Sep 2010 19:20:52 +0800
Message-ID: <20100903112052.GD31881@gondor.apana.org.au>
References: <cover.1283436919.git.dmitry.kasatkin@nokia.com> <018d83bcce6fea623a9c7d19b3739ec7b54610c5.1283436919.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Samu Onkalo <samu.p.onkalo@nokia.com>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47989 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0ICLUz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Sep 2010 07:20:55 -0400
Content-Disposition: inline
In-Reply-To: <018d83bcce6fea623a9c7d19b3739ec7b54610c5.1283436919.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 02, 2010 at 05:17:35PM +0300, Dmitry Kasatkin wrote:
> From: Samu Onkalo <samu.p.onkalo@nokia.com>
> 
> DMA is set to use burst mode also for source channel. It should
> descrease memory bandwidth needs.
> 
> DMA synchronization is set to use prefetch mechanism. SHAM block is behind
> L4 bus and it doesn't have fifo. SHAM block is stalling as long as the new
> data is available. It takes time to fetch data from memory and transfer it
> via L4 bus. With prefetch enabled, data is waiting in DMA fifo and SHAM block
> receives new data block faster.
> This increases SHA processing speed up to 30 percent depending on the
> bus / memory load.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
