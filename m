From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Wed, 22 Jun 2016 08:54:16 -0400
Message-ID: <5df01797-ccf2-f7fb-5d39-15602a4a306a@gmail.com>
References: <1466007463.20087.11.camel@redhat.com>
 <1900555.p3fYFz9p7D@positron.chronox.de>
 <e7ab11a3-8bc5-ac3f-4034-87f5a8835b02@gmail.com>
 <2650602.0p6Dj5APxb@positron.chronox.de>
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
Received: from mail-io0-f177.google.com ([209.85.223.177]:35951 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbcFVMyY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 08:54:24 -0400
In-Reply-To: <2650602.0p6Dj5APxb@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-06-22 01:16, Stephan Mueller wrote:
> Am Dienstag, 21. Juni 2016, 15:31:07 schrieb Austin S. Hemmelgarn:
>
> Hi Austin,
>
>>> Little data, interesting statement for results on 200+ systems including
>>> all major CPU arches all showing information leading in the same
>>> directions.
>> Let me try rephrasing this to make it a bit clearer:
>> 1. You have lots of data on server systems.
>> 2. You have a significant amount of data on desktop/workstation type
>> systems.
>> 3. You have very little data on embedded systems.
>>
>> and here are your arguments:
>> A. This works well on server systems.
>> B. This works well on desktop systems.
>> C. This works well on embedded systems.
>>
>> Arguments A and B are substantiated directly by points 1 and 2.
>> Argument C is not substantiated thoroughly because of point 3.
>> My complaint is about argument C given point 3.
>
> Then let me rephrase what I try to say: my RNG rests on the intrinsic
> functionality of CPUs. When I show that such intrinsic behavior is present in
> various architectures I show that there is a common ground for the basis of
> the RNG.
You're not demonstrating it's inherently present in the architecture, 
your demonstrating that it's present for those particular 
micro-architectures you have tested.  You're dealing with effects 
resulting from such low-level details of the CPU that you can't assume 
it happens for the whole architecture.  In fact, your own results 
regarding the weak values from Pentium Celeron Mobile system reinforce 
that it's not an architectural effect at the ISA level, but results from 
low level designs.  Given the naming of that particular CPU, it's almost 
certainly a P6 or NetBurst micro-arch, neither of which had particularly 
complex branch-prediction or pipelining or similar things, and more 
significantly, probably did not have HyperThreading, which I'd be 
willing to bet is a significant contributing factor on the Xeon and Core 
processors you've got results for.
>
> I tested on all CPUs of all large scale architectures (including the
> architectures that are commonly used for embedded devices) and demonstrated
> that the fundamental phenomenon the RNG rests on is present in all
> architectures.
In all architectures you've tested.  Note that technically, from a 
low-level perspective of something like this, different revisions of an 
ISA are different architectures, and when you start talking about 
licensed IP cores like ARM and PPC (and MIPS, and SPARC), different 
manufacturer's designs almost count separately.  You're relying on 
complexities inherent in the CPU itself, which will be different between 
micro-architectures, and possibly even individual revisions of a 
specific model number.  Just because the test gives good results on an 
ARMv6 or ARMv7 does not mean it will on an ARMv4, because there are 
enough differences in typical designs of ARM CPU's that you can't 
directly draw conclusions based on such a small sample size (you've 
tested at most 4 manufacturer's designs, and even then only one from 
each, and there are about 10 different companies making ARM chips, each 
selling dozens of slightly different CPU's).
>
> I do not care about the form factor of the test system server, desktop or
> embedded systems nor do I care about the number of attached devices -- the
> form factor and number of attached devices is the differentiator of what you
> call embedded vs server vs desktop.
I don't care about form factor, I care about the CPU, and embedded 
systems almost always have simpler CPU designs (not including all the 
peripherals they love to add in on-die).  Your own analysis indicates 
that your getting entropy from the complex interaction of the different 
parts of the CPU.  Such complexities are less present in simpler CPU 
designs.
>
> Heck, I have written a test that executes the RNG on bare metal (without OS
> and with only a keyboard as device present -- i.e no interrupts are received
> apart from a keyboard), which demonstrates that the phenomenon is present.
>
> Furthermore, chapter 6 of my document analyzes the root cause of the RNG and
> here you see clearly that it has nothing to do with the size of the CPU or its
> attached devices or the size of RAM.
And yet averages are higher for systems that have more CPU cores, and 
thus more complex CPU's.  Prime examples of this are the UltraSPARC 
CPU's you've tested.  Those have more SMP cores (and threads of 
execution) than just about anything else you've listed, and they have 
significantly higher values than almost anything else you list.
>
> The massive number of x86 tests shall demonstrate the common theme I see: the
> newer the CPU the larger the phenomenon is the RNG rests on.
Except each iteration of x86 grows more complex branch-prediction and 
pipe-lining and other tricks to try and make the CPU process data 
faster.  That is the source of almost all of the increase your seeing in 
entropy for newer revisions.  The same is not inherently true of 
embedded processors, especially ones designed for hard-real-time usage 
(while I don't have the resources to do this myself, I'd love to see 
test results for this from a couple of Blackfin DSP's, I'd be willing to 
bet that you see extremely low entropy there because they're designed 
for real-time processing).
>
> I use different OSes (including microkernel systems) for testing to
> demonstrate that the OS does not materially change the test results.
>>
>> I'm not saying you have insufficient data to support argument A or B,
>> only that you have insufficient data to support argument C.
>
> And I think that this statement is not correct. But I would always welcome
> more testing.
>>
>> Android barely counts as an embedded system anymore, as many Android
>
> Then read F.28ff -- these are truly embedded systems (i.e. the routers that I
> have on my desk)
1. I'm actually rather curious what router you managed to get Android 
running on.
2. This is still an insanely small sample size compared to the rest of 
your results.
>
>> phones can outperform most inexpensive desktop and laptop systems, and
>> even some rather expensive laptops.  This leaves the only systems that
>> can be assumed without further information to be representative of
>> embedded boards to be the ones running Genode, and possibly the MIPS
>> systems, which is a total of about 10 results out of hundreds for
>> servers and desktops/workstations.
