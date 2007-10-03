From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Wed, 3 Oct 2007 16:05:18 +0400
Message-ID: <20071003120518.GA20250@2ka.mipt.ru>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:39725 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbXJCMFj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 08:05:39 -0400
Content-Disposition: inline
In-Reply-To: <20071003115405.GA8920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert.

On Wed, Oct 03, 2007 at 07:54:05PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > It has to be multiple of blocksize. I.e. it is impossible to 
> > crypt one byte - hardware will stall, DES test provides two bytes as
> > input - this will not work. If that is going to be handled in driver,
> > then it will relocate. I'm not sure it is the right decision.
> 
> Right.  However you can't force the user to give you data that's
> always layed out in blocks.  For example, an IP fragment might give
> you an sg element that's only half an AES block.
> 
> You should either use the blkcipher walking helpers to avoid
> this or do your own copying when you detect that you have a
> partial block in an sg element.

Ok, I will think more about this issues and ways to resolve the problem.

> Also, the MAY_BACKLOG option must be implemented or dm-crypt
> won't work properly.

What is may backlog option? I did not find it in cryptd.c, which I used
for reference. I found a backlog variables in the driver, but without
any signs for the outside world - queue is initialized and backlog is
being set to that queue - since there is a dequeueing code, what is a
purpose for backlog in that case?

-- 
	Evgeniy Polyakov
