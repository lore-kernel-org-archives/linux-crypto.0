From: Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Tue, 06 Sep 2011 16:09:39 +0200
Message-ID: <4E6629A3.3090004@atsec.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <CACXcFmkxX2=qGDgCdYJ4ZjhX1TOxSmq686eHymc1RgVNuVqMXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:57279 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab1IFOUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Sep 2011 10:20:50 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id 3DE6678076
	for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2011 16:09:43 +0200 (CEST)
In-Reply-To: <CACXcFmkxX2=qGDgCdYJ4ZjhX1TOxSmq686eHymc1RgVNuVqMXA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05.09.2011 04:36:29, +0200, Sandy Harris <sandyinchina@gmail.com> wrote:

Hi Sandy,

> On Fri, Sep 2, 2011 at 10:37 PM, Jarod Wilson <jarod@redhat.com> wrote:
> 
>> Certain security-related certifications and their respective review
>> bodies have said that they find use of /dev/urandom for certain
>> functions, such as setting up ssh connections, is acceptable, but if and
>> only if /dev/urandom can block after a certain threshold of bytes have
>> been read from it with the entropy pool exhausted. ...
>>
>> At present, urandom never blocks, even after all entropy has been
>> exhausted from the entropy input pool. random immediately blocks when
>> the input pool is exhausted. Some use cases want behavior somewhere in
>> between these two, where blocking only occurs after some number have
>> bytes have been read following input pool entropy exhaustion. Its
>> possible to accomplish this and make it fully user-tunable, by adding a
>> sysctl to set a max-bytes-after-0-entropy read threshold for urandom. In
>> the out-of-the-box configuration, urandom behaves as it always has, but
>> with a threshold value set, we'll block when its been exceeded.
> 
> Is it possible to calculate what that threshold should be? The Yarrow
> paper includes arguments about the frequency of rekeying required to
> keep a block cipher based generator secure. Is there any similar
> analysis for the has-based pool? (& If not, should we switch to a
> block cipher?)

The current /dev/?random implementation is quite unique. It does not
seem to follow "standard" implementation like Yarrow. Therefore, I have
not seen any analysis about how often a rekeying is required.

Switching to a "standard" implementation may be worthwhile, but may take
some effort to do it right. According to the crypto folks at the German
BSI, /dev/urandom is not allowed for generating key material precisely
due to the non-blocking behavior. It would be acceptable for BSI to use
/dev/urandom, if it blocks after some threshold. Therefore, considering
the patch from Jarod is the low-hanging fruit which should not upset
anybody as /dev/urandom behaves as expected per default. Moreover, in
more sensitive environments, we can use /dev/urandom with the
"delayed-blocking" behavior where using /dev/random is too restrictive.
> 
> /dev/urandom should not block unless both it has produced enough
> output since the last rekey that it requires a rekey and there is not
> enough entropy in the input pool to drive that rekey.

That is exactly what this patch is supposed to do, is it not?
> 
> But what is a reasonable value for "enough" in that sentence?

That is a good question. I will enter a discussion with BSI to see what
"enough" means from the German BSI. After conclusion of that discussion,
we would let you know.


Thanks
Stephan
