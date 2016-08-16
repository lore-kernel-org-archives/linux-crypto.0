From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Tue, 16 Aug 2016 15:49:25 -0700
Message-ID: <5a2a350c-65c0-3893-aeb3-66775157fc8b@linux.intel.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <2c3286c8-7150-12db-937d-b6407d50d748@linux.intel.com>
 <2672856.NsbgmUcCJx@tauon.atsec.com>
 <2f43d23f-5fbe-9653-fc1c-489db1c7bde4@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, Joe Perches <joe@perches.com>,
	Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:56608 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbcHPWt1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 18:49:27 -0400
In-Reply-To: <2f43d23f-5fbe-9653-fc1c-489db1c7bde4@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/16/16 15:28, H. Peter Anvin wrote:
> On 08/15/16 22:45, Stephan Mueller wrote:
>> Am Montag, 15. August 2016, 13:42:54 CEST schrieb H. Peter Anvin:
>>
>> Hi H,
>>
>>> On 08/11/16 05:24, Stephan Mueller wrote:
>>>> * prevent fast noise sources from dominating slow noise sources
>>>>
>>>>   in case of /dev/random
>>>
>>> Can someone please explain if and why this is actually desirable, and if
>>> this assessment has been passed to someone who has actual experience
>>> with cryptography at the professional level?
>>
>> There are two motivations for that:
>>
>> - the current /dev/random is compliant to NTG.1 from AIS 20/31 which requires 
>> (in brief words) that entropy comes from auditible noise sources. Currently in 
>> my LRNG only RDRAND is a fast noise source which is not auditible (and it is 
>> designed to cause a VM exit making it even harder to assess it). To make the 
>> LRNG to comply with NTG.1, RDRAND can provide entropy but must not become the 
>> sole entropy provider which is the case now with that change.
>>
>> - the current /dev/random implementation follows the same concept with the 
>> exception of 3.15 and 3.16 where RDRAND was not rate-limited. In later 
>> versions, this was changed.
>>
> 
> I'm not saying it should be *sole*.  I am questioning the value in
> limiting it, as it seems to me that it could only ever produce a worse
> result.
> 

Also, it would be great to actually get a definition for "auditable".  A
quantum white noise source which exceeds the sampling bandwidth is an
ideal RNG; how do you "audit" that?  If what you are doing is looking
for imperfections, those imperfections can be trivially emulated.  If
what you mean is an audit on the chip or circuit level, that would
require some mechanism to know that all items were built identically
without deviation, which may be possible for intelligence agencies or
the military who have full control of their supply chain, but for anyone
else that is most likely an impossible task.  How many people are going
to crack the case and look at even a discrete transistor circuit, and
how many of *those* are going to be able to discern if that circuit is
subject to RF capture, or its output even used?

I have been trying to figure out how to reasonably solve this problem
for a long time now, and it is not just a problem for RDSEED (RDRAND is
a slightly different beast.)  The only reason RDSEED exposes the problem
particularly harshly is because it is extremely high bandwidth compared
to other noise sources and it is architecturally integrated into the
CPU, but the same would apply to an external noise generator connected
via PCIe, for example.

Incidentally, I am hoping -- and this is a personal statement and
nothing official from Intel -- that at some future date RDRAND (not
RDSEED) will be fast enough that it can completely replace even
prandom_u32(), which I really hope can be non-controversial as
prandom_u32() isn't cryptographically strong in the first place.

	-hpa
