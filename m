From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Fri, 04 Jul 2008 01:36:33 +0200
Message-ID: <87iqvmsfpa.fsf@basil.nowhere.org>
References: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
	<20080703203955.GA13654@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:3313 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYGCXgg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 19:36:36 -0400
In-Reply-To: <20080703203955.GA13654@Chamillionaire.breakpoint.cc> (Sebastian Siewior's message of "Thu, 3 Jul 2008 22:39:55 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> writes:
>
> Anything wrong with get_random_bytes()?
> Whats the advantage over get_random_bytes()?

get_random_bytes() is not a _pseudo_ random number generator,
it doesn't have a seed and you cannot get repeatable sequences
out of it.

random32.c is though, but currently it's not reseedable either.
I needed a true reseedable prng a few times too so this
would be useful, although i guess random32.c could have been
fixed. But perhaps there's a need for a more cryptographically
strong PRNG too.

-Andi
