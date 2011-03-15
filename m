From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [patch] crypto: caam - dereferencing ERR_PTR on allocation
 failure
Date: Tue, 15 Mar 2011 17:20:34 -0500
Message-ID: <20110315172034.3038b124.kim.phillips@freescale.com>
References: <20110315065747.GO2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:26552
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab1COWfn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2011 18:35:43 -0400
In-Reply-To: <20110315065747.GO2008@bicker>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 15 Mar 2011 09:57:47 +0300
Dan Carpenter <error27@gmail.com> wrote:

> t_alg is an ERR_PTR here so we can't dereference it.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
