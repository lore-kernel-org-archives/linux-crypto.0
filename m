From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: fix handling of sg buffers in ixp4xx driver
Date: Mon, 2 Mar 2009 20:42:39 +0000
Message-ID: <20090302204239.GC25699@n2100.arm.linux.org.uk>
References: <20090226232025.GE5811@n2100.arm.linux.org.uk> <20090227005033.GA20046@gondor.apana.org.au> <20090302114511.GE6283@elara.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, karl@hiramoto.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-k
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49533 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZCBUnD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2009 15:43:03 -0500
Content-Disposition: inline
In-Reply-To: <20090302114511.GE6283@elara.bln.innominate.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 02, 2009 at 12:45:12PM +0100, Christian Hohnstaedt wrote:
> 
>  - keep dma functions away from chained scatterlists.
>    Use the existing scatterlist iteration inside the driver
>    to call dma_map_single() for each chunk and avoid dma_map_sg().

Hmm, interesting.  So crypto has its own scatterlist chaining stuff which
is different and incompatible from what is supported by the rest of the
kernel.

That's really confusing.  There's know way to know whether a struct scatterlist
should be walked by using the scatterwalk_* stuff or the generic stuff.
Excellent for reviewing.

So, sorry, I'm not qualified to review this.  Please find someone else
who knows about crypto stuff.
