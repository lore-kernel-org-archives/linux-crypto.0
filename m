From: Stephan Mueller <smueller@chronox.de>
Subject: Re: skcipher
Date: Mon, 02 May 2016 07:51:21 +0200
Message-ID: <1544687.NtFoiUyCFs@tauon.atsec.com>
References: <CAKJ7aR5-GbkuFPQkw7DdKJLCKV48LzRY-WUeTeayZkK_h7cTUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54392 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbcEBFvZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 01:51:25 -0400
In-Reply-To: <CAKJ7aR5-GbkuFPQkw7DdKJLCKV48LzRY-WUeTeayZkK_h7cTUQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 11:14:01 schrieb Gadre Nayan:

Hi Gadre,

> Hello,
> 
> I have read the crypto library documentation on chronox.de.
> 
> I used there sample code for symmetric key cipher operation.
> However in the check:
> 
> skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
> if (IS_ERR(skcipher)) {
> pr_info("could not allocate skcipher handle\n");
> return PTR_ERR(skcipher);
> }
> 
> I get could not allocate skcipher handle.
> 
> I have loaded all possible related modules for crypto:
> lsmod (relevant):
> algif_skcipher         32768  0
> algif_hash             20480  0
> algif_aead             20480  0
> af_alg                 24576  3 algif_aead,algif_hash,algif_skcipher
> cryptd
> ablk_helper.
> 
> What am I missing here?
> 
> Also IS_ERR checks if the skcipher value may be <1000, it may include
> the NULL check right?.

The allocation of the cipher failed. Please check /proc/crypto whether you 
have the cipher registered with the kernel crypto API.

The module listing does not show the AESNI cipher module.

Ciao
Stephan
