From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 20:14:26 +0200
Message-ID: <48835296.96C5xuvVCT@positron.chronox.de>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <CAH8yC8mibb90J2rkD_YzM2X1HsNuHEOLbV7Wntq39dMxH4KCnQ@mail.gmail.com> <3163610.mmC4VCYNt8@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34846 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbcEZSOa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 14:14:30 -0400
In-Reply-To: <3163610.mmC4VCYNt8@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 19:30:01 schrieb Stephan Mueller:

Hi,

> 
> However, the key difference to a standard speed test is that I set up a new
> key schedule quite frequently. And I would suspect that something is going
> on here...

With tcrypt, there is some interesting hint: on smaller blocks, the C 
implementation is indeed faster:

[   20.391510] 
               testing speed of async ecb(aes) (ecb(aes-generic)) encryption
   20.391513] test 0 (128 bit key, 16 byte blocks): 1 operation in 275 cycles 
(16 bytes)
[   20.391517] test 1 (128 bit key, 64 byte blocks): 1 operation in 702 cycles 
(64 bytes)
[   20.391521] test 2 (128 bit key, 256 byte blocks): 1 operation in 2431 
cycles (256 bytes)
[   20.391532] test 3 (128 bit key, 1024 byte blocks): 1 operation in 9347 
cycles (1024 bytes)
[   20.391570] test 4 (128 bit key, 8192 byte blocks): 1 operation in 74375 
cycles (8192 bytes)


vs for ecb-aes-aesni:

[  143.482123] test 0 (128 bit key, 16 byte blocks): 1 operation in 1203 
cycles (16 bytes)
[  143.482138] test 1 (128 bit key, 64 byte blocks): 1 operation in 1328 
cycles (64 bytes)
[  143.482148] test 2 (128 bit key, 256 byte blocks): 1 operation in 1922 
cycles (256 bytes)
[  143.482159] test 3 (128 bit key, 1024 byte blocks): 1 operation in 3328 
cycles (1024 bytes)
[  143.482176] test 4 (128 bit key, 8192 byte blocks): 1 operation in 19483 
cycles (8192 bytes)


As I use crypto_cipher_encrypt_one, I only send one block at a time to AES-NI.


Ciao
Stephan
