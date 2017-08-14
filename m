From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 08:01:52 +0200
Message-ID: <7295901.5kiTlHVF8D@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org> <CAOtvUMfcEDmyO976H0g5=s7BacHsxUf+JoPXLc0hGaPs_LduAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58730 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbdHNGBy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 02:01:54 -0400
In-Reply-To: <CAOtvUMfcEDmyO976H0g5=s7BacHsxUf+JoPXLc0hGaPs_LduAQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 13. August 2017, 10:52:00 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> While I don't have anything to contribute to the choice between
> keyctl() vs ALG_IF as interfaces for asymmetric  cryptography, I would
> like to point out that there is both interest and HW support for
> private symmetric key operations as well, for example for storage
> encryption via DM-Crypt and fscrypt, so I do hope (and will work on)
> adding some sort of HW key support the crypto API, community
> acceptance withstanding of course.
> 
> So I hope we won't treat the idea of crypto API lack of support for HW
> keys as a long standing immutable argument.

See the patch set that was offered by Tudor regarding the in-kernel or in-
hardware generation of the ECDH private keys. There is nothing that prevents 
us having such API for akcipher. In fact, it would even be more or less a 
copy-n-paste job.

Exporting that logic to user space could be done as follows:

- keyctl API is used to trigger the key generation process and to obtain a 
handle

- AF_ALG to perform the asym operation where the key handle from keyctl is 
handed into the kernel. I am aware that this link between AF_ALG and keyctl is 
yet missing. But it on my desk and I am willing to integrate it. The 
integration should even not be specific to algif_akcipher, but to all cipher 
types.

Ciao
Stephan
