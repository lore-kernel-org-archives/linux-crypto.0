From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 18:10:08 -0500
Message-ID: <1308006608.15617.62.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308002818-27802-5-git-send-email-jarod@redhat.com>
	 <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
	 <4DF690E4.1060004@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:56623 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1FNOlS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 10:41:18 -0400
In-Reply-To: <4DF690E4.1060004@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2011-06-13 at 15:36 -0700, H. Peter Anvin wrote:
> On 06/13/2011 03:27 PM, Venkatesh Pallipadi wrote:
> > On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson <jarod@redhat.com> wrote:
> >> TSC is high enough resolution that we can use its low-order byte to
> >> stir new data into the random number generator entropy pool.
> > 
> > From what I vaguely remember from years past, rdtsc, especially last
> > few bits of it are not very good as random number source. As they are
> > based on lower bus frequency and a multiplier. May be things have
> > changed these days. Adding Peter and Suresh for comments.

Well the issue is that samples are going to be roughly aligned to some
multiple of the bus frequency. If an interrupt occurs on bus cycle X,
this code will be hit at roughly TSC cycle X*M+d.

> This is correct; at the very least I would multiply the low 32 bits of
> the TSC with a 32-bit prime number before mixing.

This multiply doesn't actually accomplish anything. Mixing known values
into the pool is harmless because the mixing function is fully
reversable. ie:

 unmix(sample, mix(sample, pool)) = pool

If you didn't know the contents of pool before, you can't guess it
after.

The danger comes if you (a) already know pool and (b) can narrow sample
to a tractable set of values. Then you can calculate a set of possible
pool' values and compare the resulting output to confirm the actual
state of pool' (aka state extension attack). Sticking a constant
multiplier on sample doesn't affect this attack at all.

> However, the big issue with this is that it's recursive... what causes
> this to be invoked... probably an interrupt, which is going to have been
> invoked by a timer, quite possible the TSC deadline timer.  Oops.

..and the sampling function already mixes in a TSC timestamp with the
provided timestamp.

-- 
Mathematics is the supreme nostalgia of our time.
