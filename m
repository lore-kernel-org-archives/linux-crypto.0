From: Mathias Krause <minipli@googlemail.com>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Date: Thu, 25 Sep 2014 08:27:05 +0200
Message-ID: <CA+rthh8jCbx3gGq8t53QS8GD4065Z_8uv4d=p22Nn2V0gF=4cg@mail.gmail.com>
References: <87sijti8kh.fsf@kima.orebokech.com>
	<87fvfr2v3w.fsf@kima.orebokech.com>
	<20140917112911.GA2129@gondor.apana.org.au>
	<CA+rthh-oZQhT0eAney-T0jkSTxB51-qRWofi7omfCcD5J0-9gQ@mail.gmail.com>
	<1411597436.2324.5.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	James Guilford <james.guilford@intel.com>,
	Sean Gulley <sean.m.gulley@intel.com>,
	Romain Francoise <romain@orebokech.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36836 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIYG1H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Sep 2014 02:27:07 -0400
Received: by mail-wi0-f181.google.com with SMTP id z2so8679229wiv.2
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2014 23:27:05 -0700 (PDT)
In-Reply-To: <1411597436.2324.5.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 25 September 2014 00:23, chandramouli narayanan
<mouli@linux.intel.com> wrote:
> On Mon, 2014-09-22 at 00:28 +0200, Mathias Krause wrote:
>> What might be worth noting, the failing test uses an IV value of
>> "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
>> or, in other words, a counter value that'll wrap after processing
>> three blocks. The Crypto++ implementation explicitly states, it can
>> handle the wrap around (see [1]). Dumping the IV before and after the
>> cryptomgr tests shows, the "by8" implementation only handles the lower
>> 32 bit as a counter. Looking at RFC 3686, it defines the "counter
>> block" as a 128 bit combination of nonce, IV and a 32 bit counter
>> value. It also defines the initial value of the counter part (1) and
>> how it should be incremented (increment the whole counter block, i.e.
>> the 128 bit value). However, it also states that the maximum number
>> blocks per packet are (2^32)-1. So, according to the RFC, the wrap
>> around cannot happen -- not even for the 32 bit part of the counter
>> block. However the other aesni-backed implementation does handle the
>> wrap around just fine. It does so by doing the increment on a integer
>> register so it can use the carry flag to detect the wrap around.
>> Changing the "by8" variant would be straight forward, but I fear
>> performance implications... :/
>>
>
> It will take some time for me to debug this issue. Is there a list of
> test vectors to debug with?

The failing test is aes_ctr_enc_tv_template[3] from crypto/testmgr.h.
It fails because of a wrong handling of counter overflows.

I'm already working on a patch that fixes the counter overflow issue.
It passes the cryptomgr test but I like to do some more thorough
tests. Especially some performance measurements as we now have
branches in the hot path.

I don't know if we should still rush fix this for v3.17 or delay this
for the next merge window. The offending code was already disabled in
Linus' tree and the fixes would be small enough to be backported if
there is interest.

Regards,
Mathias

>
> thanks
> -mouli
