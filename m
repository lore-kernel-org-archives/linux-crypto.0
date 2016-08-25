From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Problems with cbc(aes) and do_alg0test()
Date: Thu, 25 Aug 2016 02:45:01 +0200
Message-ID: <1510671.Z01xXXj6zB@positron.chronox.de>
References: <1887F274-344C-4810-B2DD-DD6551CC4980@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Michael McKay <mmckay@vmware.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37294 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbcHYGEx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 02:04:53 -0400
In-Reply-To: <1887F274-344C-4810-B2DD-DD6551CC4980@vmware.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. August 2016, 22:44:39 CEST schrieb Michael McKay:

Hi Michael,

> We are writing a device driver with kernel v3.14, and trying to encrypt some
> data using the Linux kernel algorithm “cbc(aes)”. Our /proc/crypto shows
> the following is loaded: driver “cbc-aes-aesni”, module “aesni_intel”, and
> type “ablkcipher”. But crypto_has_alg() gives us an error indicating the
> algo is not loaded. So knowing we have the algo string correct, most likely
> the problem is with the two other input variables: mask or type.
 
> Since AESNI is in use, we have a decent guess at the types by looking at the
> .cra_flags field in aensi-Intel_glue.c (which has
> “CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC”). That leaves just a few
> mask fields to guess at, but CRYPTO_ALG_TYPE_BLKCIPHER_MASK and
> CRYPTO_ALG_TYPE_MASK don’t work (not does OR’ing them together). 
 
> What are the correct mask and type values for AESNI, and can you point me to
> any documentation? What else might we be doing wrong? Is /proc/crypto
> giving us relevant information? Thanks,

You can only use the cbc-aes-aesni code with the ablkcipher API. Using it with 
the blkcipher API will not work.

So, a simple crypto_alloc_ablkcipher("cbc-aes-aesni", 0, 0) should work. If 
not, what is the return code?

Ciao
Stephan
