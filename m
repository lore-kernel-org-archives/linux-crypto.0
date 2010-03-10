From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hmac(sha1)
Date: Wed, 10 Mar 2010 12:05:09 +0800
Message-ID: <20100310040509.GA20091@gondor.apana.org.au>
References: <4B970862.5060904@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55582 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756166Ab0CJEFO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Mar 2010 23:05:14 -0500
Content-Disposition: inline
In-Reply-To: <4B970862.5060904@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
> 
> Can you please answer the following questions with regards to an 
> ahash_alg implementation:
> 
> 1) Do I need to implement .digest?

Yes.

> 2) Please confirm that .init should setup a context in the req->ctx to 
> be used by .update and .final and that .final should destroy that context.

Yes to an extent.  You should not store anything in a request
between operations other than the hash state.  IOW, you should
not leak memory if someone calls init and then never invokes
final.

> 3) Can the .init request carry data?

No.

> 4) Can the .final request carry data?

No.

Please keep in mind that unless your hardware supports exporting
the partial hash state, you must use a software fallback to
implement init/update.

> 5) If any of  the functions (.init, .update, .final) completes the work 
> scheduled synchronously, it should return 0 and not call the complete 
> function of the request.

Right.

> 6) If any of  the functions (.init, .update, .final) returns without 
> completing the work scheduled, it should return -EINPROGRESS and call 
> the complete function (if not NULL) of the req when the work is completed.

Yes.

> 7) When calling the complete function, what context should it be called 
> from? For example, can it be interrupt context? Should I take any 
> precautions/locks before calling the complete function callback?

It must be called with hard IRQs on and soft IRQs off.  IOW it
should be in done in BH context, or process context with BH
disabled.

> 8) Could you say a few words about the threading model that is in 
> effect? For example, if I move the context in the req struct, do I need 
> any kind of locking? Can I assume that the tfm, will not be changing 
> under my feet, when inside a init/update/final call?

You can assume that setkey will not occur, or that the tfm will not
be freed.  You must not however modify the tfm in anyway without
locking as operations can be issued in parallel (via different
reqeust structures).

> 9) Is there a concept of a default key for a hash? For example, could 
> .init be called calling set_key prior to it? If yes, what should the key 
> be in that case?

That depends on your algorithm.  For SHA there is no key so this
is not an issue.  For HMAC(SHA) setkey is required.  But you
may provide a default key, that is, you're not required to indicate
an error if setkey was never invoked.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
