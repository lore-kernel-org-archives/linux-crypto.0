From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: geode-aes interface with ipsec
Date: Wed, 2 Apr 2008 08:48:47 +0200
Message-ID: <20080402064847.GD32234@Chamillionaire.breakpoint.cc>
References: <b25669db0803311049y37f497b2l86e47a7ce49e7718@mail.gmail.com> <b25669db0803311121k7620ca1dy3a883bcb493bee86@mail.gmail.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Vasile Marii <vasile.marii@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46876 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbYDBGst (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:48:49 -0400
Content-Disposition: inline
In-Reply-To: <b25669db0803311121k7620ca1dy3a883bcb493bee86@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Vasile Marii | 2008-03-31 20:21:25 [+0200]:

>I'm trying to write a driver for hardware accelerated aes-cbc crypting
>device to use with ipsec. I have a geode-aes and I'm spying on it
>trying to understand all the stuff needed to make it work.
>Well, when I'm initializing the geode module, I'm sending some test vectors:
> Key       : 0xc286696d887c9aa0611bbb3e2025a45a
>IV        : 0x562e17996d093d28ddb3ba695a2e6f58
>Plaintext : 0x000102030405060708090a0b0c0d0e0f
>              101112131415161718191a1b1c1d1e1f
>Ciphertext expected:
>               d296cd94 c2cccf8a 3a863028 b5e1dc0a
>              7586602d 253cfff9 1b8266be a6d61ab1
This looks like the test vector #2 for cbc enc.

>expecting to see the cipher text on output. I,m just sending the
>address of data stored on my local machine to src field on geode-aes
>engine AES_SOURCEA_REG, and all the flags needed for CBC encryption,
>it work
> surely because obtained data is decrypted to the original plain text.
>And i recieve this:
>c1398353 61a38726 4db45c3f 513bc0cc
>a1835114 42f2fdd0 86fc8bdc 5b3aeeef
Are you using the in kernel module or your own?
Which kernel version do you use?

>Where is the problem?
Try to run the tcrypt module for testing. 
 modprobe tcrypt mode=10
will test _all_ aes variants, you can ignore them all except the cbc
part.
 
>Is the plaintext in ipsec not so "plain"? Is the kernel doing some
>modifications on it while  trabelling thru blkcipher_walkvirt &
>friends?
No. That one should only walk through the scatterlist and ensures
alignment that is required.

> What is the real interface between ipsec and algorithms?
>Thanks in advance!
Take a look on tcrypt.c. That one is pretty easy. ipsec uses the
asynchronous interface.

>
>-- 
>Vasile Marii

Sebastian
