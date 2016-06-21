From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 15:31:07 -0400
Message-ID: <e7ab11a3-8bc5-ac3f-4034-87f5a8835b02@gmail.com>
References: <1466007463.20087.11.camel@redhat.com>
 <1526644.Bum3kD6iTD@tauon.atsec.com>
 <5d1a9ce4-a2e5-4ec7-9ca8-22d75281025f@gmail.com>
 <1900555.p3fYFz9p7D@positron.chronox.de>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1900555.p3fYFz9p7D@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2016-06-21 14:04, Stephan Mueller wrote:
> Am Dienstag, 21. Juni 2016, 13:51:15 schrieb Austin S. Hemmelgarn:
>>>> 6. You have a significant lack of data regarding embedded systems, which
>>>> is one of the two biggest segments of Linux's market share.  You list no
>>>> results for any pre-ARMv6 systems (Linux still runs on and is regularly
>>>> used on ARMv4 CPU's, and it's worth also pointing out that the values on
>>>> the ARMv6 systems are themselves below average), any MIPS systems other
>>>> than 24k and 4k (which is not a good representation of modern embedded
>>>> usage), any SPARC CPU's other than UltraSPARC (ideally you should have
>>>> results on at least a couple of LEON systems as well), no tight-embedded
>>>> PPC chips (PPC 440 processors are very widely used, as are the 7xx and
>>>> 970 families, and Freescale's e series), and only one set of results for
>>>> a tight-embedded x86 CPU (the Via Nano, you should ideally also have
>>>> results on things like an Intel Quark).  Overall, your test system
>>>> selection is not entirely representative of actual Linux usage (yeah,
>>>> ther'es a lot of x86 servers out there running Linux, there's at least
>>>> as many embedded systems running it too though, even without including
>>>> Android).
>>>
>>> Perfectly valid argument. But I programmed that RNG as a hobby -- I do not
>>> have the funds to buy all devices there are.
>>
>> I'm not complaining as much about the lack of data for such devices as I
>> am about you stating that it will work fine for such devices when you
>> have so little data to support those claims.  Many of the devices you
>
> Little data, interesting statement for results on 200+ systems including all
> major CPU arches all showing information leading in the same directions.

Let me try rephrasing this to make it a bit clearer:
1. You have lots of data on server systems.
2. You have a significant amount of data on desktop/workstation type 
systems.
3. You have very little data on embedded systems.

and here are your arguments:
A. This works well on server systems.
B. This works well on desktop systems.
C. This works well on embedded systems.

Arguments A and B are substantiated directly by points 1 and 2. 
Argument C is not substantiated thoroughly because of point 3.
My complaint is about argument C given point 3.

I'm not saying you have insufficient data to support argument A or B, 
only that you have insufficient data to support argument C.

Android barely counts as an embedded system anymore, as many Android 
phones can outperform most inexpensive desktop and laptop systems, and 
even some rather expensive laptops.  This leaves the only systems that 
can be assumed without further information to be representative of 
embedded boards to be the ones running Genode, and possibly the MIPS 
systems, which is a total of about 10 results out of hundreds for 
servers and desktops/workstations.
