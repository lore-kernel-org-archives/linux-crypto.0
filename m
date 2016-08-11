From: miaoqing@codeaurora.org
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Thu, 11 Aug 2016 10:54:11 +0800
Message-ID: <14a3879458f3bfc36068c2e8294ca448@codeaurora.org>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
 <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com>
 <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
 <20160810132449.GH2013@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	linux-crypto@vger.kernel.org,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbcHKCzG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 22:55:06 -0400
In-Reply-To: <20160810132449.GH2013@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jason,

On 2016-08-10 21:24, Jason Cooper wrote:
> *gentle reminder: others are reading which may not be directly included
> in the conversation.  Including the archives.  Please avoid top 
> posting.
> :)

Thanks:)

> The fact is, barring userspace expectations of /dev/hwrng, hw_random is
> the appropriate place for it.  It's not a devicetree blob, mac address,
> or pci config space.  Which are things we feed in once for the heck of
> it.  This is a *continuous* source or questionable quality.
> 
> I'm seriously considering putting this and timeriomem-rng into a
> subdirectory under hw_random/, maybe environ/.  Anything in there gets
> quality=0 for default, and *doesn't* contribute to /dev/hwrng.
> 
> Regardless which path we take, I think we should include 'adc' in the
> name.  I've heard countless times about "Atheros cards come with an rng
> on board". :-/

If I understand correctly, you want to bind the ADC source to 
/dev/hwrng,
and then change rng-tools to set the entropy to zero in the ioctl call ?
There are two major problems with that approach,

1) We already tried once before to bind our solution to /dev/hwrng, and 
got
so much complaints. The conclusion was that maybe we know that the 
output of
/dev/hwrng does not have perfect entropy, but a normal user does not 
know and
will misuse it. You mentioned in 
https://www.kernel.org/doc/Documentation/hw_random.txt
we have

"This data is NOT CHECKED by any
	fitness tests, and could potentially be bogus (if the
	hardware is faulty or has been tampered with).  Data is only
	output if the hardware "has-data" flag is set, but nevertheless
	a security-conscious person would run fitness tests on the
	data before assuming it is truly random."

But this is not enough to convince upstream to switch to /dev/hwrng. I 
think the
concern of users misusing the solution is a very valid concern.

2) If we set the entropy to zero in rng-tools, we cannot tolerate the 
load.
Rng-tools is not a timer-based solution. Similar to our solution, it is 
based on
/proc/sys/kernel/random/write_wakeup_threshold. If we do not increase 
the entropy
counter, rng-tools keep writing into the pool, and both rng-tools and 
WiFi chip will
be overloaded.


Thanks,
Miaoqing
