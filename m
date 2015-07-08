From: Stephan Mueller <smueller@chronox.de>
Subject: Re: akcipher: continuous memory for input/output
Date: Wed, 08 Jul 2015 17:54:35 +0200
Message-ID: <3241575.xDOc5hzFrC@tauon.atsec.com>
References: <4018710.nx8zEmrfD4@tauon.atsec.com> <20150708152932.GA23750@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47924 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574AbbGHPym (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 11:54:42 -0400
In-Reply-To: <20150708152932.GA23750@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 8. Juli 2015, 23:29:32 schrieb Herbert Xu:

Hi Herbert,

>On Wed, Jul 08, 2015 at 05:27:15PM +0200, Stephan Mueller wrote:
>> But according to Tadeusz it may be viable to register hybrid asym ciphers
>> with the akcipher API. If there is a full blown hybrid asym cipher we have
>> to handle potentially large chunks of data. I am now wondering whether a
>> flat buffer still makes sense or whether the akcipher should be converted
>> to scatter lists as all the other cipher types.
>> 
>> If it shall stay as is, how would we be handling larger buffers?
>
>What is a hybrid cipher and why would we want to have it in the
>kernel?

Please consider the thread from June 25 between Tadeusz and me. With hybrid 
cipher, I am referring to the asym + sym cipher combo to implement a "real" 
complete asymmetric encryption/decryption. Or I am referring to the asym + 
hash combo to implement a "real" signature generation/verification.

Tadeusz' rsa.c implements the raw RSA modular exponentiation operation. But 
that does not make a usable encryption or signature operation. For example, 
the kernel module signature verification illustrates that very nicely:

mod_verify_sig():
...
	/* hash the code */
        pks = mod_make_digest(ms.hash, mod, modlen);
...
	/* RSA verify the hash */
	ret = verify_signature(key, pks);

What I am wondering is that whether such hybrid operation (hash+asym or 
sym+asym) may be entirely implemented in hardware. If you tell me that this 
will never be the case, I will stop asking and would be happy with the plain 
buffer. :-)

But IIRC, there are systems out there which perform a full hybrid asym 
operation. Without having checked in detail, I believe this is true for IBM 
cryptoexpress or Cavium cards.


The reason for having it in the kernel is what Tadeusz describes: the kernel 
does not need asym operations. But the hardware is only accessible from kernel 
space. With this, the kernel crypto API together with a yet to be written 
AF_ALG akcipher would make the asym hardware available to user space.

Ciao
Stephan
