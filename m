From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Thu, 4 Oct 2007 13:22:20 +0400
Message-ID: <20071004092218.GA23613@2ka.mipt.ru>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au> <20071003120518.GA20250@2ka.mipt.ru> <20071004054923.GA16226@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailer.campus.mipt.ru ([194.85.82.4]:52358 "EHLO
	mailer.campus.mipt.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbXJDKKp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 06:10:45 -0400
Received: from 2ka.mipt.ru (2ka [194.85.82.65])
	by mailer.campus.mipt.ru (8.14.1/8.14.1) with ESMTP id l949g9PK026565
	for <linux-crypto@vger.kernel.org>; Thu, 4 Oct 2007 13:43:19 +0400
Content-Disposition: inline
In-Reply-To: <20071004054923.GA16226@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 04, 2007 at 01:49:23PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > What is may backlog option? I did not find it in cryptd.c, which I used
> > for reference. I found a backlog variables in the driver, but without
> > any signs for the outside world - queue is initialized and backlog is
> > being set to that queue - since there is a dequeueing code, what is a
> > purpose for backlog in that case?
> 
> It's not directly in cryptd because it uses the helpers from
> algapi.c.  In particular ablkcipher_enqueue_request has the
> necessary logic to handle this correctly.
> 
> You could either use that helper yourself once your hardware
> queue fills up, or implement your own backlog logic.  The key
> is each tfm object must be guaranteed to be able to queue at
> least one request.

I use ablkcipher_enqueue_request() when hardware can not handle new
request, so this should be ok.

-- 
	Evgeniy Polyakov
