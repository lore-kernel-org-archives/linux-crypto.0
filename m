From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 15:36:20 -0700
Message-ID: <4DF690E4.1060004@zytor.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57704 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab1FMWgy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:54 -0400
In-Reply-To: <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/13/2011 03:27 PM, Venkatesh Pallipadi wrote:
> On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson <jarod@redhat.com> wrote:
>> TSC is high enough resolution that we can use its low-order byte to
>> stir new data into the random number generator entropy pool.
> 
> From what I vaguely remember from years past, rdtsc, especially last
> few bits of it are not very good as random number source. As they are
> based on lower bus frequency and a multiplier. May be things have
> changed these days. Adding Peter and Suresh for comments.

This is correct; at the very least I would multiply the low 32 bits of
the TSC with a 32-bit prime number before mixing.

However, the big issue with this is that it's recursive... what causes
this to be invoked... probably an interrupt, which is going to have been
invoked by a timer, quite possible the TSC deadline timer.  Oops.

	-hpa
