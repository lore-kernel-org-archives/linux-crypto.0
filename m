From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Moving from blkcipher to skcipher
Date: Mon, 03 Oct 2016 19:36:20 +0200
Message-ID: <3528786.X6pky90e93@tauon.atsec.com>
References: <CA+cSK1134BGVm7FprZcrDxVoU7P33GkJP17itLGvTpc8ECB9zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Alex Cope <alexcope@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48098 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752143AbcJCRgZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 13:36:25 -0400
In-Reply-To: <CA+cSK1134BGVm7FprZcrDxVoU7P33GkJP17itLGvTpc8ECB9zw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 3. Oktober 2016, 10:06:23 CEST schrieb Alex Cope:

Hi Alex,

> I'm currently working on implementing HEH encryption, and am in the
> process of switching from the blkcipher interface to the skcipher
> interface.  All the examples I have found that use skcipher are
> wrapping another mode of operation I.E. cts in cts(cbc(aes)) rather
> than being directly above the block cipher I.E. ctr in ctr(aes). Are
> there any existing examples of the latter type that I could use as a
> reference? If not, is there an estimate on when that work will be
> available?

The issue is that a blkcipher is a synchronous version of the skcipher. So, 
you could easily move from blkcipher to skcipher and just rename the invoked 
API, provided you change the initialization to the following which triggers a 
synchronous operation:

tfm = crypto_alloc_skcipher(kccavs_test->name, 0, CRYPTO_ALG_ASYNC);

Note, you can only use ciphers marked as blkcipher or cipher in /proc/crypto 
with that.

If you want to use all symmetric cipher implementation, you must use the async 
skcipher operation which is identical to the previous ablkcipher API. An 
example is given in the crypto API documentation, such as http://
www.chronox.de/crypto-API/Code.html#id-1.8.2

Ciao
Stephan
