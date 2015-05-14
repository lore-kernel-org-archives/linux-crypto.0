From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] lib: fix 842 build on 32-bit architectures
Date: Thu, 14 May 2015 07:03:09 -0400
Message-ID: <CALZtONA9DcqPSnbUEQpEkhZChWs+XRYXqV8e4_AqQYjS5EwpYg@mail.gmail.com>
References: <2802721.Q9KnE9eNH4@wuerfel> <1431561144-29931-1-git-send-email-ddstreet@ieee.org>
 <CALZtONC5Fc-Dsw_aob7zyycYdS6rP6ckT-wdyxF1WJTNsSLp7g@mail.gmail.com> <9630890.oRRRs96DG8@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33030 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbENLDb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 May 2015 07:03:31 -0400
In-Reply-To: <9630890.oRRRs96DG8@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 14, 2015 at 6:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 14 May 2015 04:54:07 Dan Streetman wrote:
>> On Wed, May 13, 2015 at 7:52 PM, Dan Streetman <ddstreet@ieee.org> wrote:
>> >> Building the 842 code on 32-bit ARM currently results in this link
>> >> error:
>> >>
>> >> ERROR: "__aeabi_uldivmod" [lib/842/842_decompress.ko] undefined!
>> >
>> > Oops!  Guess I should build/test on 32 bit more.
>> >
>> >>
>> >> The reason is that the __do_index function performs a 64-bit
>> >> division by a power-of-two number, but it has no insight into
>> >> the function arguments.
>>
>> wait, do you mean the 64 bit mod, total % fsize?  That should already
>> be fixed in Herbert's tree, I changed it to subtraction instead.
>
> Yes, that's the one. I was looking at yesterday's linux-next which still
> had the bug, but your fix has made it into today's release, so my patch
> is no longer needed.
>
>> In any case, I looked at the code again and I think the fsize
>> parameter can be removed, and just simply calculated in the function,
>> it's just a shift.  I'll send a patch.
>
> Not necessary for this problem any more, but it could still make sense
> if you think that improves the code. You can also try to see if marking
> the function inline has any effect on code size or performance if either
> of them matters.

Yep, I'll run some performance tests both ways and send a patch if it
does improve things.  Thanks!

>
>         Arnd
