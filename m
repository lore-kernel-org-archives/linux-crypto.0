From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto: aesni - disable "by8" AVX CTR optimization
Date: Mon, 15 Dec 2014 12:26:08 -0700
Message-ID: <548F35D0.1020503@openvpn.net>
References: <20140917112911.GA2129@gondor.apana.org.au>	<1411504267-10170-1-git-send-email-minipli@googlemail.com>	<54895B58.8030200@openvpn.net> <CA+rthh-WGeRFTd3-_p+6QQoFFXpyC71f1_-P0BW6p=v8h5K7pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Romain Francoise <romain@orebokech.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.yonan.net ([54.244.116.145]:52855 "EHLO mail.yonan.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaLOT0K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 14:26:10 -0500
In-Reply-To: <CA+rthh-WGeRFTd3-_p+6QQoFFXpyC71f1_-P0BW6p=v8h5K7pA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mathias,

>> I'm seeing some anomalous results with the "by8" AVX CTR optimization in
>> 3.18.
>
> the patch you're replying to actually *disabled* the "by8" variant for
> v3.17 as it had another bug related to wrong counter handling in GCM.
> The fix for that particular issue only made it to v3.18, so the code
> got re-enabled only for v3.18. But it looks like that there's yet
> another bug :/

Right, I should have clarified that I initially suspected the "by8" 
variant was to blame because your patch that disables it resolves the 
discrepancy.

>> In particular, crypto_aead_encrypt appears to produce different ciphertext
>> from the same plaintext depending on whether or not the optimization is
>> enabled.
>>
>> See the attached patch to tcrypt that demonstrates the discrepancy.
>
> I can reproduce your observations, so I can confirm the difference,
> when using the "by8" variant compared to other AES implementations.
> When applying this very patch (commit 7da4b29d496b ("crypto: aesni -
> disable "by8" AVX CTR optimization")) -- the patch that disables the
> "by8" variant -- on top of v3.18 the discrepancies are gone. So the
> behavior is bound to the "by8" optimization, only.

Right -- this is exactly what I'm seeing as well.

> As it was Chandramouli, who contributed the code, maybe he has a clue
> what's wrong here. Chandramouli?

A few more observations:

* Encryption produces bad ciphertext only when the size of plaintext 
exceeds a certain threshold.  In test_aead_encrypt_consistency in the 
tcrypt patch, I found that data_size must be >= 128 to produce bad 
ciphertext.

* Encrypting then decrypting data always gets back to the original
plaintext, no matter what the size.

* The bad ciphertext from encryption is only evident when the same 
encrypt operation is performed on a different AES implementation and the 
ciphertexts are compared.

* When the encrypt operation produces bad ciphertext, the generated auth 
tag is actually correct, so another AES implementation that decrypts the 
ciphertext will end up with corrupted plaintext that succeeds 
authentication.

James
