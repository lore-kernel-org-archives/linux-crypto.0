From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Entropy sources
Date: Thu, 25 Aug 2016 17:20:57 -0700
Message-ID: <5d672be5-6234-6bb7-fc2d-ee680742628c@zytor.com>
References: <CAH8yC8nZyAZT2OiRXgT=CBfQ4RSw-E1uZaQvKuQZ9BDYuPmGvA@mail.gmail.com>
 <f57f675f-a914-4c72-f32a-4091e547905f@zytor.com>
 <CACXcFmk8DWOxu+=J3i06bSvEW3tp_O2cxHLGdCuXTJROZ=hysA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jeffrey Walton <noloader@gmail.com>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACXcFmk8DWOxu+=J3i06bSvEW3tp_O2cxHLGdCuXTJROZ=hysA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/25/16 16:35, Sandy Harris wrote:
> On Thu, Aug 25, 2016 at 5:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> The network stack is a good source of entropy, *once it is online*.
>> However, the most serious case is while the machine is still booting,
>> when the network will not have enabled yet.
>>
>>         -hpa
> 
> One possible solution is at:
> https://github.com/sandy-harris/maxwell
> 
> A small (< 700 lines) daemon that gets entropy from timer imprecision
> and variations in time for arithmetic (cache misses, interrupts, etc.)
> and pumps it into /dev/random. Make it the first userspace program
> started and all should be covered. Directory above includes a PDF doc
> with detailed rationale and some discussion of alternate solutions.
> 
> Of course if you are dealing with a system-on-a-chip or low-end
> embedded CPU & the timer is really inadequate, this will not work
> well. Conceivably well enough, but we could not know that without
> detailed analysis for each chip in question.
> 

A lot of this is exactly the same thing /dev/random already does in
kernel space.  I have already in the past expressed skepticism toward
this approach, because a lot of the analysis done has simply been bogus.

	-hpa
