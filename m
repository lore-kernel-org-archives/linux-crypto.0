From: Stephan Mueller <smueller@chronox.de>
Subject: Kernel crypto API: cryptoperf performance measurement
Date: Sun, 17 Aug 2014 17:55:51 +0200
Message-ID: <56334718.JSiBY74glM@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51238 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaHQPzz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2014 11:55:55 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S2DD> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 17 Aug 2014 17:55:52 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

during playing around with the kernel crypto API, I implemented a performance 
measurement tool kit for the various kernel crypto API cipher types. The 
cryptoperf tool kit is provided in [1].

Comments are welcome.

In general, the results are as expected, i.e. the assembler implementations 
are faster than the pure C implementations. However, there are curious results 
which probably should be checked by the maintainers of the respective ciphers 
(hoping that my tool works correctly ;-) ):

ablkcipher
----------

- cryptd is slower by factor 10 across the board

blkcipher
---------

- Blowfish x86_64 assembler together with the generic C block chaining modes 
is significantly slower than Blowfish implemented in generic C

- Blowfish x86_64 assembler in ECB is significantly slower than generic C 
Blowfish ECB

- Serpent assembler implementations are not significantly faster than generic 
C implementations

- AES-NI ECB, LRW, CTR is significantly slower than AES i586 assembler.

- AES-NI ECB, LRW, CTR is not significantly faster than AES generic C

rng
---

- The ANSI X9.31 RNG seems to work massively faster than the underlying AES 
cipher (by about a factor of 5). I am unsure about the cause of this.


Caveat
------

Please note that there is one small error which I am unsure how to fix it as 
documented in the TODO file.

[1] http://www.chronox.de/cryptoperf.html

-- 
Ciao
Stephan
