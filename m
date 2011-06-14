From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 11:11:11 -0700
Message-ID: <4DF7A43F.5040901@zytor.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	 <1308002818-27802-5-git-send-email-jarod@redhat.com>	 <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>	 <4DF690E4.1060004@zytor.com> <1308006608.15617.62.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:54387 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1FNSMA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 14:12:00 -0400
In-Reply-To: <1308006608.15617.62.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/13/2011 04:10 PM, Matt Mackall wrote:
> 
> Well the issue is that samples are going to be roughly aligned to some
> multiple of the bus frequency. If an interrupt occurs on bus cycle X,
> this code will be hit at roughly TSC cycle X*M+d.
> 
>> This is correct; at the very least I would multiply the low 32 bits of
>> the TSC with a 32-bit prime number before mixing.
> 
> This multiply doesn't actually accomplish anything. Mixing known values
> into the pool is harmless because the mixing function is fully
> reversable. ie:
> 
>  unmix(sample, mix(sample, pool)) = pool
> 
> If you didn't know the contents of pool before, you can't guess it
> after.
> 
> The danger comes if you (a) already know pool and (b) can narrow sample
> to a tractable set of values. Then you can calculate a set of possible
> pool' values and compare the resulting output to confirm the actual
> state of pool' (aka state extension attack). Sticking a constant
> multiplier on sample doesn't affect this attack at all.
> 

It only matters if you actually truncate it to LSBs.

>> However, the big issue with this is that it's recursive... what causes
>> this to be invoked... probably an interrupt, which is going to have been
>> invoked by a timer, quite possible the TSC deadline timer.  Oops.
> 
> ..and the sampling function already mixes in a TSC timestamp with the
> provided timestamp.

Right.

	-hpa
