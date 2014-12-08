From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic, don't buffer old output
Date: 8 Dec 2014 15:34:36 -0500
Message-ID: <20141208203436.32204.qmail@ns.horizon.com>
References: <20141208180755.GA4238@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:42283 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752432AbaLHUeh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 15:34:37 -0500
In-Reply-To: <20141208180755.GA4238@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Not your motivations, just the posting mechanics.  If you just want to
> discuss a patch, and aren't yet proposing it for inclusion, you should
> put RFC in the prefix of every patch header.

I understand the principle, and I should have on those patches (mea
culpa), but really *all* patch postings are for comment; I think of RFC
as "comment only; please don't apply this".

But it wasn't marked RFC, so that's why I posted a note downgrading
it when I realized I messed it up.  The note was basically "oh, shit,
I introduced a bug at the last minute; thankfully that was the most RFC
of the entire series, so nobody's likely to have merged it."

But it certainly is the case that for any significant patch series,
I really don't expect v1 to get merged as-is.

I'm serious about the changes, and it wouldn't have been a problem if
you had applied v1, but it would have surprised me.  Realistically,
I expect a couple of rounds of discussion and tweaking of the specific
form of the changes before people agree it's ready to go in.

And I think that's the case here; I adjusted a lot of details based on
feedback, but at a high level nothing changed; v2 makes the same changes
that v1 did.

> Not particularly opposed to the idea, I just know that several use cases
> rely on deterministic behavior for those entities that share the secret
> information, so I need to be sure that the deterministic behavior remains
> and is the default.

Right, because it's advertised as a PRNG.  Thinking about it, would
a separate crypto_alg with a different seedsize be a better solution
than obscure rules about seed size?  And something in the cra_flags
to indicate it's nondeterminsitic?
