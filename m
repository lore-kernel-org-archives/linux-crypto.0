From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Problem with key sizes
Date: Sat, 17 Mar 2007 21:28:53 +0100
Message-ID: <20070317202853.GA7454@Chamillionaire.breakpoint.cc>
References: <20070316152347.GE13744@Chamillionaire.breakpoint.cc> <E1HSQHB-0000Sn-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48887 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXCQU26 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Mar 2007 16:28:58 -0400
Content-Disposition: inline
In-Reply-To: <E1HSQHB-0000Sn-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-03-17 15:12:17 [+1100]:

>What exactly is the aes-special algorithm and where can I find a copy?
The only difference between -special and -generic is the limited key
size. It was just an example.

>Yes key length support is missing as far as algorithm selection
>is concerned.  I haven't worried too much about it because there
>hasn't been that many algorithms needing this.
>
>So my question is how hard is it to make aes-special support 16-bit keys?
I was browsing through the api and noticed that the key size is not
considered (except in proc code). If aes-special utilizes some hardware
device to do the job it may be possible, that the hardware does not
support all key sizes. This is the case for the Geode AES driver [1] and
for the s390 aes driver [2]. The latter checks at runtime what key sizes
are supported while Geode can only handle 16 byte long keys (according to
the source). 
The author may still add part of the aes-generic code as a fall back or
try to load a fullback algorithm like VIA PadLock SHA1 does [3]. I
prefer the latter. Anyway: I don't like the idea of adding fall back code
for a key size, that I never claimed to support.

>If you find no source code after the clone all you have to do is check
>them out with 'git-checkout-index -a'.
ach, thx.

[1] drivers/crypto/geode-aes.c
[2] arch/s390/crypto/aes_s390.c
[3] drivers/crypto/padlock-sha.c
>Cheers,
-- 
Regards
Sebastian Siewior
