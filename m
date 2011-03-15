From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [patch] crypto: caam - ARRAY_SIZE() vs sizeof()
Date: Tue, 15 Mar 2011 17:20:37 -0500
Message-ID: <20110315172037.f212db80.kim.phillips@freescale.com>
References: <20110315065955.GP2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:25963
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab1COWUm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2011 18:20:42 -0400
In-Reply-To: <20110315065955.GP2008@bicker>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 15 Mar 2011 09:59:55 +0300
Dan Carpenter <error27@gmail.com> wrote:

> ARRAY_SIZE() was intended here instead of sizeof().  sizeof() is four
> times larger than ARRAY_SIZE().  outstr is normally 256 chars so 
> printing garbage to it could overfill the buffer and corrupt memory.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks Dan,

Kim
