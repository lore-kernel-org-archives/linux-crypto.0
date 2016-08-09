From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 0/7] Various fixes for the cesa driver
Date: Tue, 9 Aug 2016 11:48:16 +0200
Message-ID: <20160809114816.08b4150c@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org,
	Gregory Clement <gregory.clement@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:41510 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198AbcHIJsU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:48:20 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Is it normal that Herbert, as the crypto maintainer, is not Cc'ed on
those patches?

On Tue,  9 Aug 2016 11:03:13 +0200, Romain Perier wrote:
> This patches series contains various fixes for ahash requests, dma
> operations and an important fixe in the core of the driver (cesa.c). It
> also includes some code cleanups.
> 
> Romain Perier (3):
>   crypto: marvell - Update transformation context for each dequeued req
>   crypto: marvell - Don't overwrite default creq->state during
>     initialization

I think those two patches should have come first in the series, to make
it clear that they are the two fixes that are important to merge for
the 4.8 release cycle.

>   crypto: marvell - Don't hardcode block size in mv_cesa_ahash_cache_req
> 
> Thomas Petazzoni (4):
>   crypto: marvell: be explicit about destination in mv_cesa_dma_add_op()
>   crypto: marvell: remove unused parameter in
>     mv_cesa_ahash_dma_add_cache()
>   crypto: marvell: turn mv_cesa_ahash_init() into a function returning
>     void
>   crypto: marvell: make mv_cesa_ahash_cache_req() return bool

Those 5 other patches (the four from me and the last one from you) are
more cleanups/improvements, which can wait the 4.9 release cycle.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
