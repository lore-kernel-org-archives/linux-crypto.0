From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 18:35:10 -0400
Message-ID: <4DF6909E.60103@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab1FMWfd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:33 -0400
In-Reply-To: <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Venkatesh Pallipadi wrote:
> On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson<jarod@redhat.com>  wrote:
>> TSC is high enough resolution that we can use its low-order byte to
>> stir new data into the random number generator entropy pool.
>
>  From what I vaguely remember from years past, rdtsc, especially last
> few bits of it are not very good as random number source. As they are
> based on lower bus frequency and a multiplier. May be things have
> changed these days. Adding Peter and Suresh for comments.

Ah, that would definitely be good to know. I *have* enabled debug spew 
on my primary test rig though, and the randomness appears to be quite 
good in the low byte using tsc as the primary clocksource. Its a ~3+ 
year old core 2 duo 2.67GHz system though, so things could easily be 
better or worse with more current systems, and I can't say that I've 
tried it out exhaustively with the cpu at full-bore, which could affect 
things (system is mostly idle, so acpi-cpufreq had the cpu dialed back).

-- 
Jarod Wilson
jarod@redhat.com
