From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [PATCH] crypto: Jitter RNG - use ktime_get_raw_ns as fallback
Date: Tue, 21 Jun 2016 21:37:03 +0200
Message-ID: <4528708.L2m6px9Mjb@wuerfel>
References: <8242305.3NQCWfJAlD@positron.chronox.de> <1724645.8YjKaqazLv@positron.chronox.de> <CALAqxLW-TKy2CpTst=AtJY8JNGYg_WB0MxTU3Kf4J6ijKCtBVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <keescook@chromium.org>
To: y2038@lists.linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLW-TKy2CpTst=AtJY8JNGYg_WB0MxTU3Kf4J6ijKCtBVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday, June 21, 2016 12:05:06 PM CEST John Stultz wrote:
> On Tue, Jun 21, 2016 at 11:49 AM, Stephan Mueller <smueller@chronox.de> wrote:
> > Am Dienstag, 21. Juni 2016, 11:11:42 schrieb John Stultz:
> >
> > Hi John,
> >
> >> I don't see in the above an explanation of *why* you're using
> >> ktime_get_raw_ns() instead of ktime_get_ns().
> >
> > Could you help me understand what the difference is or point me to some
> > documentation? I understood that we only talked about the _raw variant.
> 
> Using specialized interfaces with subtle semantics w/o understanding
> them is sort of my concern here.
> 
> There are reasons why you might want to use the ktime_get_raw_ns()
> interface over ktime_get_ns(), but they have not been made clear in
> the comment. Arnd discussed some potential concerns that the freq
> adjustment done by ntp might be somewhat predictable/controlled by
> remote parties, which could have some effect in the calculation. That
> feels a little overly vague to me, but I'm no crypto expert, so if
> that is a reasonable concern, then it should be a conscious and
> documented decision.

My original patch changed __getnstimeofday() to __getnstimeofday64(),
which kept the original semantics of not warning in case the clock
source is suspended (which is the only different to the normal
getnstimeofday{,64}().

I did the patch a while time ago along with a number of other patches
that I never sent out until last week, so I don't remember the
reasoning for suggesting ktime_get_raw_fast_ns() over ktime_get_raw_ns(),
but I sure wanted to keep the non-warning behavior, and ktime_get_ns()
warns on timekeeping_suspended() while the other two don't.

If we don't care about the non-warning aspect, ktime_get_ns() makes
most sense here, and the original code should probably have used
getnstimeofday() as well.

	Arnd
