From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: aesni - disable "by8" AVX CTR optimization
Date: Sun, 14 Dec 2014 18:41:38 +0100
Message-ID: <CA+rthh-WGeRFTd3-_p+6QQoFFXpyC71f1_-P0BW6p=v8h5K7pA@mail.gmail.com>
References: <20140917112911.GA2129@gondor.apana.org.au>
	<1411504267-10170-1-git-send-email-minipli@googlemail.com>
	<54895B58.8030200@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Romain Francoise <romain@orebokech.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Yonan <james@openvpn.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49620 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaLNRlk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 12:41:40 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so6795974wib.16
        for <linux-crypto@vger.kernel.org>; Sun, 14 Dec 2014 09:41:38 -0800 (PST)
In-Reply-To: <54895B58.8030200@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On 11 December 2014 at 09:52, James Yonan <james@openvpn.net> wrote:
> I'm seeing some anomalous results with the "by8" AVX CTR optimization in
> 3.18.

the patch you're replying to actually *disabled* the "by8" variant for
v3.17 as it had another bug related to wrong counter handling in GCM.
The fix for that particular issue only made it to v3.18, so the code
got re-enabled only for v3.18. But it looks like that there's yet
another bug :/

> In particular, crypto_aead_encrypt appears to produce different ciphertext
> from the same plaintext depending on whether or not the optimization is
> enabled.
>
> See the attached patch to tcrypt that demonstrates the discrepancy.

I can reproduce your observations, so I can confirm the difference,
when using the "by8" variant compared to other AES implementations.
When applying this very patch (commit 7da4b29d496b ("crypto: aesni -
disable "by8" AVX CTR optimization")) -- the patch that disables the
"by8" variant -- on top of v3.18 the discrepancies are gone. So the
behavior is bound to the "by8" optimization, only.
As it was Chandramouli, who contributed the code, maybe he has a clue
what's wrong here. Chandramouli?


Mathias

>
> James
