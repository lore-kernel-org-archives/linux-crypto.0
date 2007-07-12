From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/2] SPU-AES support (kernel side)
Date: Thu, 12 Jul 2007 16:03:55 +0800
Message-ID: <E1I8teV-0005Ch-00@gondolin.me.apana.org.au>
References: <20070712073716.GB23840@Chamillionaire.breakpoint.cc>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: bigeasy@breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1779 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752716AbXGLID7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2007 04:03:59 -0400
In-Reply-To: <20070712073716.GB23840@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <bigeasy@breakpoint.cc> wrote:
>
> Limit means you want me to drop requests after a certain limit (i.e.
> when my queue is full)?

Yep, there's no point in holding onto lots of requests if the
hardware simply can't catch up.

> I would have to start an extra thread that removes requests from
> crypto_enqueue_request and enqueues them into kspu_enqueue_work_item.

I'm probably missing something but why couldn't you pull the requests
from crypto_enqueue_request in the same place where you pull requests
currently? In other words couldn't you just pull both queues?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
