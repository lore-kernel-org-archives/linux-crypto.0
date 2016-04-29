From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Fri, 29 Apr 2016 23:54:43 +0200
Message-ID: <2585243.Yy23BEqhqI@positron.chronox.de>
References: <20160429200848.12765.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54228 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbcD2Vy5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 17:54:57 -0400
In-Reply-To: <20160429200848.12765.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. April 2016, 16:08:48 schrieb George Spelvin:

Hi George,

> > What I am saying that the bits in one given time stamp are mutually
> > independent. I.e. bit 0 of one time stamp does not depend on bit 1 of that
> > very same time stamp.
> 
> And I'm saying that's wrong.

I think we can agree that we disagree.

I am not sure whether you have a point or not. Though, I will get back to the 
drawing board and think about the problem of how to efficiently collect 
entropy.

Ciao
Stephan
