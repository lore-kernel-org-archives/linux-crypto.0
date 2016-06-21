From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [Y2038] [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Tue, 21 Jun 2016 18:34:01 +0200
Message-ID: <2575012.qQ3uE1GZEQ@tauon.atsec.com>
References: <20160617155952.1021006-1-arnd@arndb.de> <3776557.os2uYrMn6M@wuerfel> <CALAqxLWan2_2HhChvq+fXKpP8CyURwj-ccdnmfEve4LTOza=mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	y2038 Mailman List <y2038@lists.linaro.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <keescook@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37668 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbcFUQeH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 12:34:07 -0400
In-Reply-To: <CALAqxLWan2_2HhChvq+fXKpP8CyURwj-ccdnmfEve4LTOza=mg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 09:22:31 schrieb John Stultz:

Hi John,

> On Tue, Jun 21, 2016 at 1:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday, June 21, 2016 8:20:10 AM CEST Stephan Mueller wrote:
> >> Am Freitag, 17. Juni 2016, 17:59:41 schrieb Arnd Bergmann:
> > Compared to the previous __getnstimeofday(), the difference is
> > 
> > - using "monotonic" timebase instead of "real", so the zero time
> > 
> >   is when the system booted rather than Jan 1 1970
> 
> I haven't looked at the details of the calling code, but I'd worry for
> crypto uses, especially if its being used for entropy collection,
> using the monotonic clock instead of the realtime clock might be
> problematic.

Funnily it does not seem like that. All tests that I have conducted show that 
monotonic clocks behave equally as realtime clocks, because the uncertainty 
lies in the execution time of a set of instructions. All we need to do is to 
measure it with a timer that has a resolution that allows detecting these 
variations.
> 
> > - "raw" means we don't honor updates for the rate based on ntp,
> > 
> >   which is probably better as the ntp state might be observable
> >   over the net (it probably doesn't matter, but it can't hurt)
> 
> So... this feels like a very vague explanation, and the lack of
> frequency correction here probably need a really good comment. Keeping
> multiple time domains is usually asking for trouble, but we added the
> MONOTONIC_RAW clock to address a few cases where people really wanted
> an abstract hardware counter, which was unaffected by frequency
> corrections. I'd really make sure its clear why this is what you want
> vs the standard system time domain so we don't run into problems
> understanding it later.

Perfect, that is what I would be interested in.
> 
> > - "fast" means that in very rare cases, the time might appear
> > 
> >   to go backwards (it probably can't happen here because you are not
> >   called in an NMI).
> 
> "fast" really means "safe-for-nmi wrt to locking".  The tradeoff being
> that when frequency adjustments occur, and if your code is delayed,
> you might see time go backwards by a small amount. This allows

My code would not see that as an issue.

> tracing/sched code (or other code called from NMI)  to not have to
> duplicate the timekeeping infrastructure.
> 
> I think without a much better explanation, using the "fast" method
> isn't really warranted here.

Thanks a lot. With that, I would think that the proposed ktime_get_raw_fast_ns 
is good for use, which is supported with testing on my system.
> 
> thanks
> -john


Ciao
Stephan
