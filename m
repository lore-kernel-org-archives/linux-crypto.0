From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Crypto hash function decryption
Date: Sun, 01 May 2016 15:24:18 +0200
Message-ID: <7386652.LF5ZBdauM9@positron.chronox.de>
References: <CAKJ7aR4t_7fhRuFDX0xMPRSCxEAvL4Wn0mjXRy_4-WA9T5xRDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54328 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbcEANYV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 May 2016 09:24:21 -0400
In-Reply-To: <CAKJ7aR4t_7fhRuFDX0xMPRSCxEAvL4Wn0mjXRy_4-WA9T5xRDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 1. Mai 2016, 18:35:51 schrieb Gadre Nayan:

Hi Gadre,

> Hi,
> 
> I wanted to implement a simple encryption decryption of data in kernel
> space to start with the kernel crypto library.
> 
> I have the following:
> 
> int myFunction() {
> 
>         struct scatterlist sg;
>         struct crypto_hash *tfm;
>         struct hash_desc desc;
>         unsigned char input[21];
> 
>         pr_err("Starting Crypto hash function\n");
>         strcpy(input, "12345678901234567890");
> 
>         tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
> 
>         desc.tfm = tfm;
>         desc.flags = 0;
> 
>         sg_init_one(&sg, input, 21);
>         crypto_hash_init(&desc);
> 
>         crypto_hash_update(&desc, &sg, 10);
>         crypto_hash_final(&desc, dataptr);
> 
>         crypto_free_hash(tfm);
>         pr_err("Encryption done\nip: %s\nop: %s\n", input, dataptr);
> 
> 
>         return 0;
> }
> 
> So I can get this function to encrypt the data. I wanted to know how I
> can decrypt this data (dataptr) back to my original string "123....".
> 
> What api's should I use.

Maybe a peek into Handbook of Applied Cryptography may help here: a hash 
cannot be decrypted.

Besides the crypto_hash_* API is discouraged to be used.

Ciao
Stephan
