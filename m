From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 00/12] crypto: caam - Add RTA descriptor creation library
Date: Wed, 3 Sep 2014 12:59:34 +0300
Message-ID: <5406E686.3010803@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
 <20140816061655.d2fa481b47f701f2f2bd8552@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [207.46.163.140] ([207.46.163.140]:48176 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756338AbaICKBs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Sep 2014 06:01:48 -0400
In-Reply-To: <20140816061655.d2fa481b47f701f2f2bd8552@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/16/2014 2:16 PM, Kim Phillips wrote:
> On Thu, 14 Aug 2014 15:54:22 +0300
> Horia Geanta <horia.geanta@freescale.com> wrote:
> 
>> This patch set adds Run Time Assembler (RTA) SEC descriptor library.
>> RTA is a replacement for incumbent "inline append".
>>
>> The library is intended to be a single code base for SEC descriptors creation
>> for all Freescale products. This comes with a series of advantages, such as
>> library being maintained / kept up-to-date with latest platforms, i.e. SEC
>> functionalities (for e.g. SEC incarnations present in Layerscape LS1 and LS2).
>>
>> RTA detects options in SEC descriptors that are not supported
>> by a SEC HW revision ("Era") and reports this back.
>> Say a descriptor uses Sequence Out Pointer (SOP) option for the SEQINPTR
>> command, which is supported starting from SEC Era 5. If the descriptor would
>> be built on a P4080R3 platform (which has SEC Era 4), RTA would report
>> "SEQ IN PTR: Flag(s) not supported by SEC Era 4".
>> This is extremely useful and saves a lot of time wasted on debugging.
>> SEC HW detects only *some* of these problems, leaving user wonder what causes
>> a "DECO Watchdog Timeout". And when it prints something more useful, sometimes
>> it does not point to the exact opcode.
> 
> again, RTA just adds bloat to the kernel driver - the kernel driver
> is supposed to generate the appropriate descriptor for its target
> running SEC version no matter what, not "report back" what is/is not
> supported.  This is a flaw at the RTA design level, as far as the
> kernel driver is concerned.

What is your understanding of developing a descriptor?
First it needs to be written, then tested - within the kernel driver.
Having no error checking in the code that generates descriptors
increases testing / debugging time significantly. Again, SEC HW provides
some error reporting, but in many cases this is a clueless Watchdog Timeout.
SEC descriptors development is complex enough to deserve a few
indications along the way.

Regards,
Horia
