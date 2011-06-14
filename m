From: Kent Borg <kentborg@borg.org>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 20:39:44 -0400
Message-ID: <4DF6ADD0.6080607@borg.org>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com> <4DF690E4.1060004@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
Received: from borg.org ([64.105.205.123]:41950 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1FNAju (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 20:39:50 -0400
In-Reply-To: <4DF690E4.1060004@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

H. Peter Anvin wrote:
 > However, the big issue with this is that it's recursive... what 
causes this to
 > be invoked... probably an interrupt, which is going to have been
 > invoked by a timer, quite possible the TSC deadline timer. Oops.

I was assuming that drivers, responding to an interrupt from some 
external event, would want to make this call. 

Such as a network driver.  The canonical example is an entropy-starved 
server that doesn't see much light at all, let alone a local user with a 
mouse.  But such a server does see plenty of packets.  Packets that go 
through various delays before getting to the ethernet port.

And even if an outside observer could get past the physical security 
that isolates such a poor starved server and tap at the ethernet port, 
an ethernet port is still many centimeters, a lot of gates, and even 
some firmware away from the IRQ pin, and that pin itself is some 
distance from the TSC.  Knowing that LSB is extremely hard.  Knowing 
exactly when the LSB is going to be sampled is extremely hard.  Knowing 
both presents very real theoretical hurdles.  And those hurdles get much 
higher with every meter of distance.

 > at the very least I would multiply the low 32 bits of
 > the TSC with a 32-bit prime number before mixing.

Two points:

 1. Why look at the high-order bits?  How are they going to have values 
that cannot be inferred?  If you are looking for entropy, the low-order 
bits is where they're going keep it.  (Think Willie Sutton.)  If looking 
at the low-byte is cheaper, then let's be cheap.  If, however, if 
looking at more bytes *is* as cheap, then there is no harm.  But in any 
case let's keep the code lean enough that it can be called from an 
interrupt service routine.

 2. Don't confuse collecting entropy with how to mix the pool.  Whether 
or not to multiply by a prime number is the domain of how to mix the 
pool.  Possibly we need a patch on that, too, you might have a point 
there, but that is a different question from whether we should be 
allowed a function to use the TSC to mix the pool.  Different issues. 


-kb, the Kent who insists that it is better to credit no entropy and be 
safe, than to collect no entropy and be certain.
