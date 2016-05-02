From: Gadre Nayan <gadrenayan@gmail.com>
Subject: skcipher
Date: Mon, 2 May 2016 11:14:01 +0530
Message-ID: <CAKJ7aR5-GbkuFPQkw7DdKJLCKV48LzRY-WUeTeayZkK_h7cTUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35740 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbcEBFoD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 01:44:03 -0400
Received: by mail-io0-f176.google.com with SMTP id d62so159236996iof.2
        for <linux-crypto@vger.kernel.org>; Sun, 01 May 2016 22:44:02 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have read the crypto library documentation on chronox.de.

I used there sample code for symmetric key cipher operation.
However in the check:

skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
if (IS_ERR(skcipher)) {
pr_info("could not allocate skcipher handle\n");
return PTR_ERR(skcipher);
}

I get could not allocate skcipher handle.

I have loaded all possible related modules for crypto:
lsmod (relevant):
algif_skcipher         32768  0
algif_hash             20480  0
algif_aead             20480  0
af_alg                 24576  3 algif_aead,algif_hash,algif_skcipher
cryptd
ablk_helper.

What am I missing here?

Also IS_ERR checks if the skcipher value may be <1000, it may include
the NULL check right?.

Thanks.
