From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH v2 3/5] crypto: talitos: Fix off-by-one and use all
 hardware slots
Date: Wed, 4 Mar 2015 09:46:19 -0500
Message-ID: <CAJUS3XmuKBRAjGmGuKKASKUZ=WZjnJvKQ9-53SHsqMFzmEoEug@mail.gmail.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-4-git-send-email-mort@bork.org>
	<20150303183531.312a8d332b1b776764a15a47@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35316 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbbCDOqU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 09:46:20 -0500
Received: by iecrl12 with SMTP id rl12so67586323iec.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2015 06:46:19 -0800 (PST)
In-Reply-To: <20150303183531.312a8d332b1b776764a15a47@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ok, I'm fine dropping this patch.  I'm sure it doesn't affect
performance in a measurable way.

mh

On Tue, Mar 3, 2015 at 7:35 PM, Kim Phillips <kim.phillips@freescale.com> wrote:
> On Tue,  3 Mar 2015 08:21:35 -0500
> Martin Hicks <mort@bork.org> wrote:
>
>> The submission count was off by one.
>>
>> Signed-off-by: Martin Hicks <mort@bork.org>
>> ---
> sadly, this directly contradicts:
>
> commit 4b24ea971a93f5d0bec34bf7bfd0939f70cfaae6
> Author: Vishnu Suresh <Vishnu@freescale.com>
> Date:   Mon Oct 20 21:06:18 2008 +0800
>
>     crypto: talitos - Preempt overflow interrupts off-by-one fix
>
> My guess is your request submission pattern differs from that of
> Vishnu's (probably IPSec and/or tcrypt), or later h/w versions have
> gotten better about dealing with channel near-overflow conditions.
> Either way, I'd prefer we not do this: it might break others, and
> I'm guessing doesn't improve performance _that_ much?
>
> If it does, we could risk it and restrict it to SEC versions 3.3 and
> above maybe?  Not sure what to do here exactly, barring digging up
> and old 2.x SEC and testing.
>
> Kim
>
> p.s. I checked, Vishnu isn't with Freescale anymore, so I can't
> cc him.



-- 
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296
