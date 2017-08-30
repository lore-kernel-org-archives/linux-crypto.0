From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Wed, 30 Aug 2017 09:21:08 +0200
Message-ID: <A9698C42-3476-4DF6-A1E1-D8AFC9B86ABE@holtmann.org>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
 <3151047.7kO17u1kNV@tauon.chronox.de>
 <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
 <92b13089-acbf-6cf9-6e03-24a3b58a4f41@microchip.com>
 <0e6735b2-52cd-6369-38a3-f8b1f8b5d84f@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:56510 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdH3HVK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 03:21:10 -0400
In-Reply-To: <0e6735b2-52cd-6369-38a3-f8b1f8b5d84f@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

> akcipher can work with its own internal keys, now that we have crypto
> accelerators that can generate keys that never leave the hardware. Going
> through the kernel's key subsystem seems superfluous in this case.
> 
> I also understand the need of going through the kernel's key subsystem
> when the user wants to refer to a key which exists elsewhere, such as in
> TPM or within an SGX software enclave, but this seems orthogonal with
> crypto accelerators with key generation and retention support.
> 
> How should we interface akcipher/kpp with user-space?

you still need to get the public key out of the kernel if you want to use it from user space. Or feed the remote public key if you plan to use some sort of key derivation function.

I am saying this again, if you only have a hammer, everything looks like a nail. What about actually looking at how this would be used from user space in real crypto cases.

My point is that the usages here are key generation, some sort of key-exchange-agreement (aka DH) and key derivation into a symmetric key. Frankly the focus with asymmetric ciphers are the keys and the key derivation. They are not encryption and decryption of massive amounts of data.

Regards

Marcel
