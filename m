From: Kent Borg <kentborg@borg.org>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 08:39:36 -0400
Message-ID: <4DF75688.2050509@borg.org>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com> <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org> <4DF6BDB4.2060201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:46331 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1FNMjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 08:39:42 -0400
In-Reply-To: <4DF6BDB4.2060201@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

H. Peter Anvin wrote:
 > Those already are doing this.

They used to via IRQF_SAMPLE_RANDOM, but these are being removed 
(according to Documentation/feature-removal-schedule.txt).  In 2.6.39 I 
can only find 10 remaining instances, out of many more network drivers. 

The alternative is supposed to be calls to add_*_randomness(), but that 
family of functions seems to only have one exported symbol: 
add_input_randomness(), which looks like is called only for things 
dealing with human input.

So network entropy is being eradicated, and nothing is being done to 
replace it.

This is crazy.

> Consider the case where the TSC is running in steps of 64 and you're 
> using the low 6 bits.

It does that?  I thought it was a "time stamp counter", that is 
incremented.  You know, incremented by one.  (Why would someone have it 
jump by 64?  Wiring it up on the cheap side of the clock multiplier?  
What chips do that?)


Maybe this patch is not sensible.  If it is only going to be called on 
timer, then there is the feedback issue that will badly limit the 
entropy, and if a TSC is sometimes only jumping in big steps, then the 
available entropy is being masked.


Let me fall back to a different (but related) topic: eradicating 
IRQF_SAMPLE_RANDOM is stupid.  The only argument in favor seems to be 
that the entropy estimation might be too high.  But entropy estimation 
is never going to be accurate.  Better to credit no entropy than to 
collect no entropy.


-kb
