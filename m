From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Crypto hash function decryption
Date: Sun, 1 May 2016 18:35:51 +0530
Message-ID: <CAKJ7aR4t_7fhRuFDX0xMPRSCxEAvL4Wn0mjXRy_4-WA9T5xRDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35863 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcEANFw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 May 2016 09:05:52 -0400
Received: by mail-ig0-f178.google.com with SMTP id u10so63109343igr.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 May 2016 06:05:51 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I wanted to implement a simple encryption decryption of data in kernel
space to start with the kernel crypto library.

I have the following:

int myFunction() {

        struct scatterlist sg;
        struct crypto_hash *tfm;
        struct hash_desc desc;
        unsigned char input[21];

        pr_err("Starting Crypto hash function\n");
        strcpy(input, "12345678901234567890");

        tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);

        desc.tfm = tfm;
        desc.flags = 0;

        sg_init_one(&sg, input, 21);
        crypto_hash_init(&desc);

        crypto_hash_update(&desc, &sg, 10);
        crypto_hash_final(&desc, dataptr);

        crypto_free_hash(tfm);
        pr_err("Encryption done\nip: %s\nop: %s\n", input, dataptr);


        return 0;
}

So I can get this function to encrypt the data. I wanted to know how I
can decrypt this data (dataptr) back to my original string "123....".

What api's should I use.

THanks.
