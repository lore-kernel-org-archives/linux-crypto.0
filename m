From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: talitos: Avoid excessive loops in softirq
 context
Date: Thu, 11 Sep 2014 19:49:18 -0500
Message-ID: <20140911194918.9ea4795f7bb3f9d6e32490eb@freescale.com>
References: <1410338087-5317-1-git-send-email-helmut.schaa@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [157.56.111.140] ([157.56.111.140]:63744 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754821AbaILB3Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Sep 2014 21:29:25 -0400
In-Reply-To: <1410338087-5317-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 10 Sep 2014 10:34:47 +0200
Helmut Schaa <helmut.schaa@googlemail.com> wrote:

> The talitos driver can cause starvation of other softirqs and as such
> it can also cause rcu stalls like:
...
> Work around this by processing a maximum amount of 16 finished requests
> and rescheduling the done-tasklet if any work is left.
> This allows other softirqs to run.

16 sounds rather arbitrary, and application-dependent - talitos'
FIFO size is 24.

IIRC, netdev's NAPI can be refactored out of just being able to work
on network devices, and be made to apply to crypto devices, too.  In
fact, some old Freescale hacks of this nature have improved
performance.  Can we do something like refactor NAPI instead?

Thanks,

Kim
