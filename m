From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Tue, 21 Jun 2016 10:39:19 +0200
Message-ID: <2181960.PFpL2PhZMt@tauon.atsec.com>
References: <20160617155952.1021006-1-arnd@arndb.de> <10630099.jHjGp8aIto@positron.chronox.de> <3776557.os2uYrMn6M@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, y2038@lists.linaro.org,
	Kees Cook <keescook@chromium.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3776557.os2uYrMn6M@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 21. Juni 2016, 10:32:23 schrieb Arnd Bergmann:

Hi Arnd,

> On Tuesday, June 21, 2016 8:20:10 AM CEST Stephan Mueller wrote:
> > Am Freitag, 17. Juni 2016, 17:59:41 schrieb Arnd Bergmann:
> > 
> > Hi Arnd,
> > 
> > > The jent_get_nstime() function uses __getnstimeofday() to get
> > > something similar to a 64-bit nanosecond counter. As we want
> > > to get rid of struct timespec to fix the y2038 overflow,
> > > this patch changes the code to use __getnstimeofday64()
> > > instead, which returns a timespec64 structure.
> > > 
> > > Nothing changes about the algorithm, but it looks like it
> > > might be better to use
> > > 
> > >  *out = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
> > > 
> > > or even
> > > 
> > >  *out = ktime_get_raw_fast_ns();
> > 
> > I tested ktime_get_raw_fast_ns and it works perfectly well for the use
> > case, i.e. the RNG behavior is indistinguishable from RDTSC on x86.
> > 
> > Which time source is used for this function? I am wondering about
> > architectures other than X86.
> 
> (adding John Stultz to Cc, he can correct me if I say something wrong)
> 
> All ktime_get_* and *get*timeofday() functions use the same clocksource,
> which is configurable and picked from the available clocksources,
> using a combination of reliability, latency for reading and accuracy.
> 
> Compared to the previous __getnstimeofday(), the difference is
> 
> - using "monotonic" timebase instead of "real", so the zero time
>   is when the system booted rather than Jan 1 1970
> - "raw" means we don't honor updates for the rate based on ntp,
>   which is probably better as the ntp state might be observable
>   over the net (it probably doesn't matter, but it can't hurt)
> - "fast" means that in very rare cases, the time might appear
>   to go backwards (it probably can't happen here because you are not
>   called in an NMI).

Thank you for the explanation.
> 
> There may be other clocksources in the system that are more appropriate
> for the purpose of jent_get_nstime(), but I don't think we have a way
> of exposing them at the moment, because we have not needed it in the
> past.
> 
> I assume what you want is the highest-resolution clocksource, and
> you don't really care about

Correct, all I need is a high-res clocksource.
> 
> > Note, this function is used as a fallback when random_get_entropy is not
> > implemented. In addition the Jitter RNG has an online health test which
> > will catch the failure of the time stamp operation. Hence, even if this
> > function may not be suitable on one or the other arch, it should not hurt
> > though.
> Ok. For the ARM architecture, I think most (maybe all) of the modern ARMv7
> platforms have either an architected "global timer" or have their own
> replacement, while the majority of the older ARMv4/v5/v6 machines don't
> have one.
> 
> However, there are some machines that implement "sched_clock" but don't
> implement get_cycles (which is the default for random_get_entropy()).
> 
> It's possible that there are cases where it's better to call sched_clock()
> than ktime_get_raw_fast_ns() as a fallback, though I could not find
> specific examples so far.

Given your explanation above, considering that the RNG would scream in the 
kernel log when the timer is too coarse and the fact that we have not had bug 
reports on this issue, I would think that a replacement call that is equal to 
the old __getnstimeofday is fine.

Do you want to update your patch or shall I hand in the patch?

Ciao
Stephan
