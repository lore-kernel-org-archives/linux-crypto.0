From: Mathias Krause <minipli@googlemail.com>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Date: Wed, 17 Sep 2014 22:10:55 +0200
Message-ID: <CA+rthh9cO5WsThL4SwO-1Avxhp4RDvvGQZQtYpQULa2oEg0NYw@mail.gmail.com>
References: <87sijti8kh.fsf@kima.orebokech.com>
	<87fvfr2v3w.fsf@kima.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: Romain Francoise <romain@orebokech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:65530 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaIQUK5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Sep 2014 16:10:57 -0400
Received: by mail-la0-f46.google.com with SMTP id el20so2604868lab.33
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2014 13:10:55 -0700 (PDT)
In-Reply-To: <87fvfr2v3w.fsf@kima.orebokech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16 September 2014 22:01, Romain Francoise <romain@orebokech.com> wrote:
> On Mon, Sep 15, 2014 at 10:36:46AM +0200, Romain Francoise wrote:
>> I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
>> fails, which makes my IPsec tunnels unhappy (see trace below). Before I
>> start bisecting (2cddcc7df8fd3 is probably my first guess), is this
>> already known?
>
>> Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni [...]

I do not get the above message on a SandyBridge i7-2620M, even though
the module makes use of the "by8" variant on my system, too:

[    0.340626] AVX version of gcm_enc/dec engaged.
[    0.340627] AES CTR mode by8 optimization enabled
[    0.341273] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)

> Update: reverting 2cddcc7df8 ("crypto: aes - AES CTR x86_64 "by8" AVX
> optimization") fixes this. This machine is Sandy Bridge (Core i7-2600),
> and the problem doesn't seem to occur with the exact same kernel image
> on Ivy Bridge (Xeon E3-1240v2).

Can you please provide the full kernel log and /proc/cpuinfo of those
machines? It would be interesting to know which variant was used on
those machines -- the new "by8" or the old one.


Thanks,
Mathias
