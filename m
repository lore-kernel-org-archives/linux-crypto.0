From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Tue, 14 Jun 2011 11:22:44 -0400
Message-ID: <4DF77CC4.2020309@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308006912.15617.67.camel@calx> <4DF77BBC.8090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab1FNPXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 11:23:15 -0400
In-Reply-To: <4DF77BBC.8090702@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarod Wilson wrote:
> Matt Mackall wrote:
>> On Mon, 2011-06-13 at 18:06 -0400, Jarod Wilson wrote:
>>> Many server systems are seriously lacking in sources of entropy,
>>> as we typically only feed the entropy pool by way of input layer
>>> events, a few NIC driver interrupts and disk activity. A non-busy
>>> server can easily become entropy-starved. We can mitigate this
>>> somewhat by periodically mixing in entropy data based on the
>>> delta between multiple high-resolution clocksource reads, per:
>>>
>>> https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html
>>>
>>>
>>> Additionally, NIST already approves of similar implementations, so
>>> this should be usable in high-securtiy deployments requiring a
>>> fair chunk of available entropy data for frequent use of /dev/random.
>>
>> So, mixed feelings here:
>>
>> Yes: it's a great idea to regularly mix other data into the pool. More
>> samples are always better for RNG quality.
>>
>> Maybe: the current RNG is not really designed with high-bandwidth
>> entropy sources in mind, so this might introduce non-negligible overhead
>> in systems with, for instance, huge numbers of CPUs.
>
> The current implementation is opt-in, and single-threaded, so at least
> currently, I don't think there should be any significant issues.

I stand corrected. Hadn't considered the possible issues with doing a 
regular preempt_disable() and __get_cpu_var() on a system with tons of 
cpus. (I'm still not sure exactly what the issues would be, but I think 
I see the potential for issues of some sort.)

-- 
Jarod Wilson
jarod@redhat.com
