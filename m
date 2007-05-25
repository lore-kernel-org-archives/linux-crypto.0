From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 12:55:10 +0400
Message-ID: <20070525085509.GA3808@2ka.mipt.ru>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070525081417.GA26691@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49292 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760036AbXEYIzm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 04:55:42 -0400
Content-Disposition: inline
In-Reply-To: <20070525081417.GA26691@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert.

On Fri, May 25, 2007 at 06:14:17PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Likely it is not even a request for testing, since I see at least one
> > problem with current approach: what to do when crypto hardware queue is
> > full and no new packets can arrive? Current code just returns an error
> > -EINVAL if there is real error and -EBUSY if queue is full.
> 
> Each device should have a crypto_queue dedicated to it to handle this
> situation.  So when the hardware queue is full you start filling up
> the software crypto_queue using crypto_enqueue_request.  When that
> becomes full the caller either gets an error or it can enqueue one
> last request and then block by setting the CRYPTO_TFM_REQ_MAY_BACKLOG
> flag.  In either case it'll get back a -EBUSY error.
> 
> When your hardware queue is drained you should try to refill it by
> calling crypto_dequeue_request.

Well, it is just hardware queue increase, so essentially for correct
work it should return -EBUSY in case driver does not accept requests
anymore (no matter if they are pushed into hardware or linked into
backlog queue). According to sleeping with CRYPTO_TFM_REQ_MAY_BACKLOG -
what about ipsec, where it is not allowed to sleep?
dm-crypt as the only user of async cryptoapi is allowed to sleep, but
I'm sure eventually ipsec will be converted (or heavily
hacked/uglymoroned like I did in acrypto) into async mode too, but
netowrk processing does not sleep at all. I do not think creating
dedicated thread for ipsec processing is a good idea, but who knows...

> > Due to problems with interrupt storms and possible adapter freeze
> > (sorry, but HIFN spec I have really sucks, so likely it is programming
> > error, but who knows) I added special watchdog, which fires if after
> > predefined timeout sessions which are supposed to be completed are not.
> > In that case callback is invoked with -EBUSY error.
> 
> Yes we do need watchdogs for all hardware devices to handle situations
> like this.  Feel free to add helpers to the API to aid drivers in
> handling this.

It is doable and likely needs to be pushed into generic code, but I will
postpone it until this driver is ready.

> > This driver supports old-style crypto_alg with "aes" string only, and I
> > would like to rise a discussion of the needs to support several
> > structures for cbc(aes), ecb(aes) and so on, since some hardware
> > supports plenty of modes, and allocating set of structures for each
> > hardware adapter found in the system would be an overkill.
> 
> It was an explicit design decision to avoid using bitmasks.  Just as
> we use strings as the unique key to identify algorithms rather than
> integers as that provides the freedom for expansion, we now use strings
> to describe cipher modes rather than bitmasks.  There are numerous
> new cipher modes in recent years and there is no way we're going back
> to describing these using bitmasks again.
> 
> As to allocating an object for each algorithm that you support being
> an overkill, are you concerned about the data size?  That shouldn't
> be an issue because you'd only have one such object per algorithm
> per device and they really aren't that big.
> 
> If you're worried about duplicate code then we can probably look at
> providing helpers to eliminate as much of that as possible.  Have a
> look at padlock/s390 for example.  They handle these in a fairly
> sane way.

I mostly worry about allocation/freeing/init code amount, memory 
overhead is not that big, since amount of devices is limited.
One says lazyness is a progress engine, but somtimes I do not agree :)

> > Current driver only supports AES ECB encrypt/decrypt, since I do not 
> > know how to detect operation mode in runtime (a question).
> 
> For each incoming request you have an associated tfm object which has
> a link to the algorithm object.  The algorithm object provides you
> the info you need to know which algorithm to use and the tfm object
> provides the session-specific information which would be the key for
> ciphers.

That is how crypto processing is being done, but there is no information
about how blocks are managed, i.e. were they chained into cbc or just
one-by-one in ecb. As far as I can see, there is no such knowledge until
algorithm was registered with new syle scheme with ecb(algo)/cbc(algo)
strings and so on, in that case there are different strings and/or
function pointers.

> > Another issue unknown issue is a possibility to call setkey() the same
> > time encrypt/decrypt is called. As far as I can see it can not be done,
> > but I may be wrong, if so, small changes are needed in hifn_setkey
> > (mainly operation must be done under dev->lock).
> 
> Indeed users should not call setkey while there are still outstanding
> operations.

Hmm, in that case all setkey operations must be protected against
appropriate crypto processing ones, but I do not see if it is ever done
in any driver. Probably they rely on higher layer not to call setkey
simultaneously with encrypt/decrypt (this assumption correct for both
ipsec and dm-crypt), but what if another kernel module will use them?

-- 
	Evgeniy Polyakov
