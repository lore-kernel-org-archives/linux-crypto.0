From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/9] crypto: caam - Add RTA descriptor creation library
Date: Mon, 21 Jul 2014 10:47:49 +0300
Message-ID: <53CCC5A5.1070004@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
	<20140718171339.fe181f6425daa57bc179ef81@freescale.com>
	<53C9B302.9000403@freescale.com>
 <20140718202326.75cfb9a11f3969ee3353135d@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	"Ruchika Gupta" <ruchika.gupta@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:31245
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbaGUHsW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jul 2014 03:48:22 -0400
In-Reply-To: <20140718202326.75cfb9a11f3969ee3353135d@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/19/2014 4:23 AM, Kim Phillips wrote:
> On Sat, 19 Jul 2014 02:51:30 +0300
> Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:
>
>> On 7/19/2014 1:13 AM, Kim Phillips wrote:
>>> On Fri, 18 Jul 2014 19:37:17 +0300
>>> Horia Geanta <horia.geanta@freescale.com> wrote:
>>>
>>>> This patch set adds Run Time Assembler (RTA) SEC descriptor librar=
y.
>>>>
>>>> The main reason of replacing incumbent "inline append" is
>>>> to have a single code base both for user space and kernel space.
>>>
>>> that's orthogonal to what this patchseries is doing from the kernel
>>> maintainer's perspective:  it's polluting the driver with a
>>> CodingStyle-violating (see, e.g., Chapter 12) 6000+ lines of code -
>>
>> Regarding coding style - AFAICT that's basically:
>> ERROR: Macros with complex values should be enclosed in parenthesis
>> and I am wiling to find a different approach.
>
> There's that, too.
>
>>> which can only mean it's slower and more susceptible to bugs - and
>>> AFAICT for no superior technical advantage:  NACK from me.
>>
>> The fact that the code size is bigger doesn't necessarily mean a bad=
 thing:
>> 1-code is better documented - cloc reports ~ 1000 more lines of
>> comments; patch 09 even adds support for generating a docbook
>> 2-pure code (i.e. no comments, white spaces) - cloc reports ~ 5000 m=
ore
>> lines; this reflects two things, AFAICT:
>> 2.1-more features: options (for e.g. new SEC instructions, little en=
dian
>> env. support), platform support includes Era 7 and Era 8, i.e.
>> Layerscape LS1 and LS2; this is important to note, since plans are t=
o
>> run the very same CAAM driver on ARM platforms
>
> um, *those* features should not cost any driver *that many* lines of
> code!

You are invited to comment on the code at hand. I am pretty sure it's
not perfect.

>
>> 2.2-more error-checking - from this perspective, I'd say driver is l=
ess
>> susceptible to bugs, especially subtle ones in CAAM descriptors that=
 are
>> hard to identify / debug; RTA will complain when generating descript=
ors
>> using features (say a new bit in an instruction opcode) that are not
>> supported on the SEC on device
>
> ?  The hardware does the error checking.  This just tells me RTA is
> slow, inflexible, and requires unnecessary maintenance by design:
> all the more reason to keep it out of the kernel :)

This is just like saying a toolchain isn't performing any checks and
lets the user generate invalid machine code and deal with HW errors.

Beside this, there are (quite a few) cases when SEC won't emit any
error, but still the results are different than expected.
SEC HW is complex enough to deserve descriptor error checking.

>
>> RTA currently runs on:
>> -QorIQ platforms - userspace (USDPAA)
>> -Layerscape platforms - AIOP accelerator
>> (obviously, plans are to run also on QorIQ/PowerPC and LS/ARM kernel=
s)
>
> inline append runs elsewhere, too, but I don't see how this is
> related to the subject I'm bringing up.

This is relevant, since having a piece of SW running in multiple
environments should lead to better testing, more exposure, finding bugs
faster.
inline append *could run* elsewhere , but it doesn't AFAICT. Last time
I checked, USDPAA and AIOP use RTA.

>
>> Combined with:
>> -comprehensive unit testing suite
>> -RTA kernel port is bit-exact in terms of SEC descriptors hex dumps =
with
>> inline append; besides this, it was tested with tcrypt and in IPsec
>> scenarios
>> I would say that RTA is tested more than inline append. In the end, =
this
>> is a side effect of having a single code base.
>
> inline append has been proven stable for years now.  RTA just adds
> redundant code and violates CodingStyle AFAICT.

New platform support is not redundant.
Error checking is not redundant, as explained above.
kernel-doc is always helpful.
Coding Style can be fixed.

Thanks,
Horia
