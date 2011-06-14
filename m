From: Kent Borg <kentborg@borg.org>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 16:04:05 -0400
Message-ID: <4DF7BEB5.1070006@borg.org>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	 <1308002818-27802-5-git-send-email-jarod@redhat.com>	 <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>	 <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org>	 <4DF6BDB4.2060201@zytor.com>  <4DF75688.2050509@borg.org>	 <1308062037.15617.71.camel@calx>  <4DF79EF1.3010004@borg.org> <1308074432.15617.136.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:59778 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1FNUEI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 16:04:08 -0400
In-Reply-To: <1308074432.15617.136.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matt Mackall wrote:
 > [network adapters are] a great source of potential entropy, a bad
 > source of guaranteed entropy. The current RNG tries to do
 > accounting on the latter. Accounting on the former is extremely
 > suspect.

So we need a patch that:

 - Deletes the IRQF_SAMPLE_RANDOM mention in feature-removal-schedule.txt,

 - Restores instances of IRQF_SAMPLE_RANDOM in drivers, and

 - Changes the credit_entropy_bits() to credit less entropy*.

   * The code seems to only handle integer values of entropy.  Maybe 
when crediting, choose between 1 and 0 credits. 

Then once that kernel makes it into the field, a bunch of entropy 
starved machines will no longer be entropy starved.  A few machines that 
are run by people who worship an entropy estimate will still have to 
install mice and users, explicit RNGs, etc., but entropy will flow.

Make sense?


-kb
