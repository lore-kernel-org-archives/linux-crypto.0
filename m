From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/5] crypto: talitos: Add crypto async queue handling
Date: Fri, 20 Feb 2015 13:26:21 -0500
Message-ID: <CAJUS3XmPLvU2cWBJV0dVzQErVumaS+dVj+WzOfBKuKwT0wL-Mg@mail.gmail.com>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
	<CAJUS3XmnuUhgezxhBKeu2QLk-QqGVf3ZuwSycs_w=J3KC3BATg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46841 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbbBTS0V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 13:26:21 -0500
Received: by iecvy18 with SMTP id vy18so9769714iec.13
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 10:26:21 -0800 (PST)
In-Reply-To: <CAJUS3XmnuUhgezxhBKeu2QLk-QqGVf3ZuwSycs_w=J3KC3BATg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Resending to linux-crypto in plain text.
Sorry to everyone else for the duplication.
mh

On Fri, Feb 20, 2015 at 1:23 PM, Martin Hicks <mort@bork.org> wrote:
>
> I've just noticed that performance is pretty terrible with maxcpus=1, so
> I'll investigate that.
> mh
>
> On Fri, Feb 20, 2015 at 11:21 AM, Martin Hicks <mort@bork.org> wrote:
>>
>> I was testing dm-crypt performance with a Freescale P1022 board with
>> a recent kernel and was getting IO errors while doing testing with LUKS.
>> Investigation showed that all hardware FIFO slots were filling and
>> the driver was returning EAGAIN to the block layer, which is not an
>> expected response for an async crypto implementation.
>>
>> The following patch series adds a few small fixes, and reworks the
>> submission path to use the crypto_queue mechanism to handle the
>> request backlog.
>>
>>
>> Martin Hicks (5):
>>   crypto: talitos: Simplify per-channel initialization
>>   crypto: talitos: Remove MD5_BLOCK_SIZE
>>   crypto: talitos: Fix off-by-one and use all hardware slots
>>   crypto: talitos: Reorganize request submission data structures
>>   crypto: talitos: Add software backlog queue handling
>>
>>  drivers/crypto/talitos.c |  189
>> ++++++++++++++++++++++++----------------------
>>  drivers/crypto/talitos.h |   44 +++++++++--
>>  2 files changed, 137 insertions(+), 96 deletions(-)
>>
>> --
>> 1.7.10.4
>>
>
>
>
> --
> Martin Hicks P.Eng.      |         mort@bork.org
> Bork Consulting Inc.     |   +1 (613) 266-2296



-- 
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296
