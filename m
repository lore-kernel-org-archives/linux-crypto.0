From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 10:02:00 -0400
Message-ID: <4DF769D8.508@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>	<1308002818-27802-5-git-send-email-jarod@redhat.com> <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com> <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org> <4DF6BDB4.2060201@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kent Borg <kentborg@borg.org>,
	Venkatesh Pallipadi <venki@google.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1FNOCw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 10:02:52 -0400
In-Reply-To: <4DF6BDB4.2060201@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

H. Peter Anvin wrote:
> On 06/13/2011 05:39 PM, Kent Borg wrote:
>> I was assuming that drivers, responding to an interrupt from some
>> external event, would want to make this call.
>> Such as a network driver.
>
> Those already are doing this.
>
>> Two points:
>>
>> 1. Why look at the high-order bits?  How are they going to have values
>> that cannot be inferred?  If you are looking for entropy, the low-order
>> bits is where they're going keep it.  (Think Willie Sutton.)  If looking
>> at the low-byte is cheaper, then let's be cheap.  If, however, if
>> looking at more bytes *is* as cheap, then there is no harm.  But in any
>> case let's keep the code lean enough that it can be called from an
>> interrupt service routine.
>
> Consider the case where the TSC is running in steps of 64 and you're
> using the low 6 bits.

What if we mix the low byte into the pool, but only increase the entropy 
estimate if a comparison with the prior read actually shows a change?

Another thought is to perhaps mix the counter value with a value read 
from ansi_cprng, which is similar to a tactic referred to in NIST's 
140sp750.pdf.

Peter, as long as I've got your attention here... Patch 3 in the set 
adds essentially the same sort of support using the hpet instead of the 
tsc. Is that less contentious, as far as precision in the low byte(s) to 
provide entropy data?

My initial local implementation was actually hpet-only, before reworking 
things to try to be more generic.

-- 
Jarod Wilson
jarod@redhat.com
