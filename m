From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 18:14:17 +1000
Message-ID: <20070525081417.GA26691@gondor.apana.org.au>
References: <20070522125828.GB8424@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2943 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbXEYIO2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 04:14:28 -0400
Content-Disposition: inline
In-Reply-To: <20070522125828.GB8424@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

HI Evgeniy:

On Tue, May 22, 2007 at 12:58:29PM +0000, Evgeniy Polyakov wrote:
> 
> This is preliminary driver for HIFN 795x crypto accelerator chip.

Thanks for the working on this!

> Likely it is not even a request for testing, since I see at least one
> problem with current approach: what to do when crypto hardware queue is
> full and no new packets can arrive? Current code just returns an error
> -EINVAL if there is real error and -EBUSY if queue is full.

Each device should have a crypto_queue dedicated to it to handle this
situation.  So when the hardware queue is full you start filling up
the software crypto_queue using crypto_enqueue_request.  When that
becomes full the caller either gets an error or it can enqueue one
last request and then block by setting the CRYPTO_TFM_REQ_MAY_BACKLOG
flag.  In either case it'll get back a -EBUSY error.

When your hardware queue is drained you should try to refill it by
calling crypto_dequeue_request.

> Due to problems with interrupt storms and possible adapter freeze
> (sorry, but HIFN spec I have really sucks, so likely it is programming
> error, but who knows) I added special watchdog, which fires if after
> predefined timeout sessions which are supposed to be completed are not.
> In that case callback is invoked with -EBUSY error.

Yes we do need watchdogs for all hardware devices to handle situations
like this.  Feel free to add helpers to the API to aid drivers in
handling this.

> This driver supports old-style crypto_alg with "aes" string only, and I
> would like to rise a discussion of the needs to support several
> structures for cbc(aes), ecb(aes) and so on, since some hardware
> supports plenty of modes, and allocating set of structures for each
> hardware adapter found in the system would be an overkill.

It was an explicit design decision to avoid using bitmasks.  Just as
we use strings as the unique key to identify algorithms rather than
integers as that provides the freedom for expansion, we now use strings
to describe cipher modes rather than bitmasks.  There are numerous
new cipher modes in recent years and there is no way we're going back
to describing these using bitmasks again.

As to allocating an object for each algorithm that you support being
an overkill, are you concerned about the data size?  That shouldn't
be an issue because you'd only have one such object per algorithm
per device and they really aren't that big.

If you're worried about duplicate code then we can probably look at
providing helpers to eliminate as much of that as possible.  Have a
look at padlock/s390 for example.  They handle these in a fairly
sane way.

> Current driver only supports AES ECB encrypt/decrypt, since I do not 
> know how to detect operation mode in runtime (a question).

For each incoming request you have an associated tfm object which has
a link to the algorithm object.  The algorithm object provides you
the info you need to know which algorithm to use and the tfm object
provides the session-specific information which would be the key for
ciphers.

> Another issue unknown issue is a possibility to call setkey() the same
> time encrypt/decrypt is called. As far as I can see it can not be done,
> but I may be wrong, if so, small changes are needed in hifn_setkey
> (mainly operation must be done under dev->lock).

Indeed users should not call setkey while there are still outstanding
operations.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
