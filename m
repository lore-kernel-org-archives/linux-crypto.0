From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 9 Oct 2009 10:07:18 +0200
Message-ID: <20091009080718.GQ15653@secunet.com>
References: <20091008072537.GG15653@secunet.com> <20091008072818.GI15653@secunet.com> <20091008.231833.107456737.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:50125 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbZJIIH5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2009 04:07:57 -0400
Content-Disposition: inline
In-Reply-To: <20091008.231833.107456737.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2009 at 11:18:33PM -0700, David Miller wrote:
> 
> Steffen are we going to end up adding a softirq for every crypto
> transform type?
> 
> That won't work, softirqs are to be scarcely allocated and operate
> at a very high level.
> 
> I can think of two alternatives:
> 
> 1) One softirq that does per-cpu padata work via some generic
>    callout mechanism.

I tried already to reduce the softirqs by using the same softirq for
encryption and decryption. But in case of IPsec this had a negative
performance impact. So if we stay with softirqs we would probaply need
at least two for the whole crypto layer.

Best would be if we would not need softirqs at all. In fact I started
with a thread based version but the thread based version had never that
performance like the softirq version has.

Anyway, in between the workqueue interface changed so perhaps it is
worth to try again with workqueues.

> 
> 2) Use tasklets
> 

Tasklets are not sufficient because I can't control on which cpu the
tasklet will run on. Also we can run just one tasklet of the same type
the time, so tasklets don't parallelize.
