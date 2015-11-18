From: Ismail Kizir <ikizir@gmail.com>
Subject: Re: A new, fast and "unbreakable" encryption algorithm
Date: Wed, 18 Nov 2015 21:39:49 +0200
Message-ID: <CAFJyfaMgf7zud5qUH66GjzgJeUjKX6oySYsXcXsuzf6m9B9xkw@mail.gmail.com>
References: <CAFJyfaOpgXj7pJfGA5jf7-95VfgC+-yZu4t6_6OGRvx_OtuzuQ@mail.gmail.com>
	<CACXcFmkefuSVyk1vrFQ12c9UdyN1zBqqtz-2MpdKcs4hS15d7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33692 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbKRTjv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 14:39:51 -0500
Received: by wmec201 with SMTP id c201so295330796wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2015 11:39:50 -0800 (PST)
In-Reply-To: <CACXcFmkefuSVyk1vrFQ12c9UdyN1zBqqtz-2MpdKcs4hS15d7A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Sandy,

I agree every word you wrote.
That's why, I am trying to explain all my login publicly to
professionals. It's not rocket science. You will "just understand"
when you read:

Until today, we were looking from the "wrong side" I guess.

We were all thinking that we must have a "fixed" key which must never change!

Why?


I begun to ask that question: "Why the key must be fixed?" and changed
the paradigm.

And I decided to dynamically update the key in encyption and decryption process.


The essential logic of the algorithm is using the key as a "jump
table" which is dynamically updated with every "jump" we make.


To understand better how it functions, suppose that we don't have a
complex function.


Given the key body length(L) is a power of 2, and M is an integer to
tell us where we are in the "key body":


We just take the byte at position M of the key body, we XOR that byte
with the byte to be encrypted(X).

We increase the byte at position M and "jump to" (M+X)%L


So, every time we encrypt a byte, we also change the key. It's a bit
more complicated than this. But essentially this is the base logic. In
real function, we do more complex operations with more variables like
the salt(or nonce) value, the last byte we encrypted, the key
checksum(against related key attacks) etc.

Briefly, to decypher a ciphertext, a cracker needs to find out the
key, and, to find out the key, cracker needs to find out the
plaintext, because the key is dynamically updated according the
plaintext during encryption process: Impossible!


If you want to learn about the details, just take a look at the source
code I've published on this blog.


I believe this algorithm is the future of the encryption.


Use it! And please, let me know if you use: ikizir@gmail.com

On Wed, Nov 18, 2015 at 9:31 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
> On Wed, Nov 18, 2015 at 12:10 AM, Ismail Kizir <ikizir@gmail.com> wrote:
>
>> I've developed a new encryption algorithm, which dynamically changes
>> the key according to plaintext and practically impossible to break.
>
> There is a very long history of crypto whose author considers is
> secure being quickly broken. This happens to nearly all methods
> devised by amateurs and quite a few from professionals.
>
> Despite that, amateurs like me & (I presume) you keep trying.
> This is probably a good thing. Here's one of mine:
> https://aezoo.compute.dtu.dk/doku.php?id=enchilada
>
>> I also opened to public with MIT&GPL dual License.
>
> This is excellent. Many people make claims for their
> algorithm without publishing details, which is ludicrous
> since no-one can analyze it without those details. You
> have avoided that pitfall.
>
>> I will present a paper on a Turkish National Inet-tr 2015 Symposium
>
> A paper describing the design would make analysis
> much easier than doing it from source code, and
> like every other algorithm yours will need lots of
> analysis before it might become sensible for
> people to trust it.
>
> I suggest you subscribe to the crypto list:
> http://www.metzdowd.com/mailman/listinfo/cryptography
>
> Once your paper is published, post a link there
> to invite analysis.
