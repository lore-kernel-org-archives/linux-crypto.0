From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Question about error codes
Date: Tue, 16 Jun 2009 22:34:06 +0200
Message-ID: <20090616203406.GA19710@Chamillionaire.breakpoint.cc>
References: <4A37CC93.8040905@lotspeich.org>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@redhat.com>
To: Erik Lotspeich <erik@lotspeich.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60922 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915AbZFPUeH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2009 16:34:07 -0400
Content-Disposition: inline
In-Reply-To: <4A37CC93.8040905@lotspeich.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Erik Lotspeich | 2009-06-16 11:47:15 [-0500]:

>Hi,
Hi,

>
>I have a question about the meaning of the error codes returned by the
>Linux kernel crypto API.  In particular, I am interested in the codes
>returned by crypto_ablkcipher_encrypt() & crypto_ablkcipher_decrypt().
>I am receiving a return value of 22 from crypto_ablkcipher_encrypt.  I
I thing you mean -22 and that one means 
| #define EINVAL          22      /* Invalid argument */ 

You can look them up in include/asm-generic/errno-base.h _or_ strerror()
in userland.

>would like to find what this means.  I don't get this error code
>consistently, so I'm trying to find out if I am using the API
>incorrectly; I'm using the test code, tcrypt.c, as a guide.
So you are using an older kernel. Starting with v2.6.28 that part of
tcrypt moved to test_skcipher() in crypto/testmgr.c. Hoewever, the logic
as it did not change.

>I looked through the source, but it was not obvious in the code where
>these error codes were coming from; I did not see them enumerated in a
>header file either.
It besically depends on the algorithm you are using. So in case of
cbc(aes) you go through
 crypto_ablkcipher_encrypt -> crypto_cbc_encrypt -> aes_encrypt
plus a little API in between tof those calls.


>Any help would be greatly appreciated.
I guess the number of bytes to decrypt/encrypt ist not always a modulos
of the blockmode.

>Regards,
>
>Erik

Sebastian
