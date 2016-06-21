From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 09:05:55 -0400
Message-ID: <6b8c8f6a-862a-3e7c-e950-75cd93cdc1f7@gmail.com>
References: <1466007463.20087.11.camel@redhat.com>
 <3381856.qSaz1KcX2Z@positron.chronox.de>
 <f22f4cd6-8198-71a0-9b79-9f10070758f3@gmail.com>
 <8999970.pstTbGZv5G@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	=?UTF-8?Q?David_Ja=c5=a1a?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35977 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbcFUNGD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 09:06:03 -0400
In-Reply-To: <8999970.pstTbGZv5G@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-06-20 14:32, Stephan Mueller wrote:
> Am Montag, 20. Juni 2016, 13:07:32 schrieb Austin S. Hemmelgarn:
>
> Hi Austin,
>
>> On 2016-06-18 12:31, Stephan Mueller wrote:
>>> Am Samstag, 18. Juni 2016, 10:44:08 schrieb Theodore Ts'o:
>>>
>>> Hi Theodore,
>>>
>>>> At the end of the day, with these devices you really badly need a
>>>> hardware RNG.  We can't generate randomness out of thin air.  The only
>>>> thing you really can do requires user space help, which is to generate
>>>> keys lazily, or as late as possible, so you can gather as much entropy
>>>> as you can --- and to feed in measurements from the WiFi (RSSI
>>>> measurements, MAC addresses seen, etc.)  This won't help much if you
>>>> have an FBI van parked outside your house trying to carry out a
>>>> TEMPEST attack, but hopefully it provides some protection against a
>>>> remote attacker who isn't try to carry out an on-premises attack.
>>>
>>> All my measurements on such small systems like MIPS or smaller/older ARMs
>>> do not seem to support that statement :-)
>>
>> Was this on real hardware, or in a virtual machine/emulator?  Because if
>> it's not on real hardware, you're harvesting entropy from the host
>> system, not the emulated one.  While I haven't done this with MIPS or
>> ARM systems, I've taken similar measurements on SPARC64, x86_64, and
>> PPC64 systems comparing real hardware and emulated hardware, and the
>> emulated hardware _always_ has higher entropy, even when running the
>> emulator on an identical CPU to the one being emulated and using KVM
>> acceleration and passing through all the devices possible.
>>
>> Even if you were testing on real hardware, I'm still rather dubious, as
>> every single test I've ever done on any hardware (SPARC, PPC, x86, ARM,
>> and even PA-RISC) indicates that you can't harvest entropy as
>> effectively from a smaller CPU compared to a large one, and this effect
>> is significantly more pronounced on RISC systems.
>
> It was on real hardware. As part of my Jitter RNG project, I tested all major
> CPUs from small to big -- see Appendix F [1]. For MIPS/ARM, see the trailing
> part of the big table.
>
> [1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

Specific things I notice about this:
1. QEMU systems are reporting higher values than almost anything else 
with the same ISA.  This makes sense, but you don't appear to have 
accounted for the fact that you can't trust almost any of the entropy in 
a VM unless you have absolute trust in the host system, because the host 
system can do whatever the hell it wants to you, including manipulating 
timings directly (with a little patience and some time spent working on 
it, you could probably get those number to show whatever you want just 
by manipulating scheduling parameters on the host OS for the VM software).
2. Quite a few systems have a rather distressingly low lower bound and 
still get accepted by your algorithm (a number of the S/390 systems, and 
a handful of the AMD processors in particular).
3. Your statement at the bottom of the table that 'all test systems at 
least un-optimized have a lower bound of 1 bit' is refuted by your own 
data, I count at least 2 data points where this is not the case.  One of 
them is mentioned at the bottom as an outlier, and you have data to back 
this up listed in the table, but the other (MIPS 4Kec v4.8) is the only 
system of that specific type that you tested, and thus can't be claimed 
as an outlier.
4. You state the S/390 systems gave different results when run 
un-optimized, but don't provide any data regarding this.
5. You discount the Pentium Celeron Mobile CPU as old and therefore not 
worth worrying about.  Linux still runs on 80486 and other 'ancient' 
systems, and there are people using it on such systems.  You need to 
account for this usage.
6. You have a significant lack of data regarding embedded systems, which 
is one of the two biggest segments of Linux's market share.  You list no 
results for any pre-ARMv6 systems (Linux still runs on and is regularly 
used on ARMv4 CPU's, and it's worth also pointing out that the values on 
the ARMv6 systems are themselves below average), any MIPS systems other 
than 24k and 4k (which is not a good representation of modern embedded 
usage), any SPARC CPU's other than UltraSPARC (ideally you should have 
results on at least a couple of LEON systems as well), no tight-embedded 
PPC chips (PPC 440 processors are very widely used, as are the 7xx and 
970 families, and Freescale's e series), and only one set of results for 
a tight-embedded x86 CPU (the Via Nano, you should ideally also have 
results on things like an Intel Quark).  Overall, your test system 
selection is not entirely representative of actual Linux usage (yeah, 
ther'es a lot of x86 servers out there running Linux, there's at least 
as many embedded systems running it too though, even without including 
Android).
7. The RISC CPU's that you actually tested have more consistency within 
a particular type than the CISC CPU's.  Many of them do have higher 
values than the CISC CPU's, but a majority of the ones I see listed 
which have such high values are either old systems not designed for low 
latency, or relatively big SMP systems (which will have higher entropy 
because of larger numbers of IRQ's, as well as other factors).
