From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel	AES-NI	instructions
Date: Wed, 17 Dec 2008 12:26:17 +1100
Message-ID: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
References: <1229476462.5936.314.camel@yhuang-dev.sh.intel.com>
Cc: herbert@gondor.apana.org.au, suresh.b.siddha@intel.com,
	linux-crypto@ml.breakpoint.cc, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: ying.huang@intel.com (Huang Ying)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbYLQB01 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Dec 2008 20:26:27 -0500
In-Reply-To: <1229476462.5936.314.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huang Ying <ying.huang@intel.com> wrote:
>
> f. if TS is clear, then use x86_64 implementation. Otherwise if
> user-space has touched the FPU, we save the state, if not then simply
> clear TS.

Well I'd rather avoid using the x86_64 implementation ever because
unless the chip guys have really screwed up we should be looking at
a difference of at least a factor of 10.

BTW I wasn't very clear in the original email.  You'd only do the
asynchronous operation for CBC/ECB.  For the simple AES case I
suppose we'll just have to stick to the x86_64 fallback.  This'll
really suck for disk encryption but I guess you could always add
an LRW/XTS mode to your code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
