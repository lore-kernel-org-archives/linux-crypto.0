From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: aesni-intel - fix unaligned cbc decrypt for x86-32
Date: Thu, 31 May 2012 08:45:58 +0200
Message-ID: <CA+rthh9-FL6gqkHfqL21Sh_gvpqS-cPMmE2MQZpk2R0o+SGjpw@mail.gmail.com>
References: <1338334988-20025-1-git-send-email-minipli@googlemail.com>
	<20120531052754.GA17273@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	Daniel <garkein@mailueberfall.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2EaGp7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 May 2012 02:45:59 -0400
Received: by weyu7 with SMTP id u7so397229wey.19
        for <linux-crypto@vger.kernel.org>; Wed, 30 May 2012 23:45:58 -0700 (PDT)
In-Reply-To: <20120531052754.GA17273@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 31, 2012 at 7:27 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, May 30, 2012 at 01:43:08AM +0200, Mathias Krause wrote:
>> The 32 bit variant of cbc(aes) decrypt is using instructions requiring
>> 128 bit aligned memory locations but fails to ensure this constraint in
>> the code. Fix this by loading the data into intermediate registers with
>> load unaligned instructions.
>>
>> This fixes reported general protection faults related to aesni.
>>
>> References: https://bugzilla.kernel.org/show_bug.cgi?id=43223
>> Reported-by: Daniel <garkein@mailueberfall.de>
>> Cc: stable@kernel.org [v2.6.39+]
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>
> Have measured this against increasing alignmask to 15?

No, but the latter will likely be much slower as it would need to
memmove the data if it's not aligned, right?

My patch essentially just breaks the combined "XOR a memory operand
with a register" operation into two -- load memory into register, then
XOR with registers. It shouldn't be much slower compared to the
current version. But it fixes a bug the current version exposes when
working on unaligned data.

That said, I did some micro benchmark on "pxor (%edx), %xmm0" vs.
"movups (%edx), %xmm1; pxor %xmm1, %xmm0" and observed the latter
might be even slightly faster! But changing the code to perform better
is out of scope for this patch as it should just fix the bug in the
code. We can increase performance in a follow up patch.

Mathias
