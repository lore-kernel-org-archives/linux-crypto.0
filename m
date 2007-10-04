From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Thu, 4 Oct 2007 13:49:23 +0800
Message-ID: <20071004054923.GA16226@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au> <20071003120518.GA20250@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4509 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbXJDFtd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 01:49:33 -0400
Content-Disposition: inline
In-Reply-To: <20071003120518.GA20250@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 03, 2007 at 04:05:18PM +0400, Evgeniy Polyakov wrote:
>
> What is may backlog option? I did not find it in cryptd.c, which I used
> for reference. I found a backlog variables in the driver, but without
> any signs for the outside world - queue is initialized and backlog is
> being set to that queue - since there is a dequeueing code, what is a
> purpose for backlog in that case?

It's not directly in cryptd because it uses the helpers from
algapi.c.  In particular ablkcipher_enqueue_request has the
necessary logic to handle this correctly.

You could either use that helper yourself once your hardware
queue fills up, or implement your own backlog logic.  The key
is each tfm object must be guaranteed to be able to queue at
least one request.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
