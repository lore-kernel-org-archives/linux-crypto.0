From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 16:34:38 +0800
Message-ID: <20090623083438.GA8315@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au> <20090623082921.GB20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34065 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbZFWIel (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 04:34:41 -0400
Content-Disposition: inline
In-Reply-To: <20090623082921.GB20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2009 at 10:29:21AM +0200, Steffen Klassert wrote:
>
> I did already tests with a work queue based parallelization, but the
> throughput and the latency on networking tests were much better with the
> remote softirq based version. The serialization engine must always wait
> for the cpu that processes the 'next' packet to keep the packets in the
> right order. And softirqs are a good way to ensure that the packets are
> processed as soon as possible.

OK, do you have some numbers that we can add to the patches?

Also note that the real time folks are turning softirq into threads
so this complexity might be moot in the end.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
