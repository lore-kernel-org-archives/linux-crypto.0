From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Entropy sources (was: /dev/random - a new approach)
Date: Thu, 25 Aug 2016 14:30:02 -0700
Message-ID: <f57f675f-a914-4c72-f32a-4091e547905f@zytor.com>
References: <CAH8yC8nZyAZT2OiRXgT=CBfQ4RSw-E1uZaQvKuQZ9BDYuPmGvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:58010 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbcHYWpP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 18:45:15 -0400
In-Reply-To: <CAH8yC8nZyAZT2OiRXgT=CBfQ4RSw-E1uZaQvKuQZ9BDYuPmGvA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/20/16 22:37, Jeffrey Walton wrote:
>>
>> The biggest problem there is that the timer interrupt adds *no* entropy
>> unless there is a source of asynchronicity in the system.  On PCs,
>> traditionally the timer has been run from a completely different crystal
>> (14.31818 MHz) than the CPU, which is the ideal situation, but if they
>> are run off the same crystal and run in lockstep, there is very little
>> if anything there.  On some systems, the timer may even *be* the only
>> source of time, and the entropy truly is zero.
> 
> It seems like a networked computer should have an abundance on entropy
> available from the network stack. Every common case I can come up with
> includes a networked computer. If a handheld is outside of coverage,
> then it probably does not have the randomness demands because it can't
> communicate (i.e., TCP sequence numbers, key agreement, etc).
> 
> In fact, there are at least two papers that use bits from the network stack:
> 

The network stack is a good source of entropy, *once it is online*.
However, the most serious case is while the machine is still booting,
when the network will not have enabled yet.

	-hpa
