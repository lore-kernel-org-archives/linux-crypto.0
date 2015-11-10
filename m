From: Orlando <orlcp440@gmail.com>
Subject: Hardware Crypto Driver
Date: Tue, 10 Nov 2015 09:49:40 -0500
Message-ID: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36514 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbbKJOtl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Nov 2015 09:49:41 -0500
Received: by vkas68 with SMTP id s68so13394134vka.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2015 06:49:40 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, I am new to the crypto framework in linux kernel and mailing
list in general. I am porting a driver omap-aes.c to my platform and
having problems with IV being modified against my will. I am doing
AES-128-CTR and I need the IV to increment by 1 every 16 bytes.
Instead some garbage IV is being returned to me after I do an encrypt
operation.

I have no idea how the IV is being manipulated since the omap-aes.c
driver accepts and write the IV to the Hardware that comes from upper
layers but it never writes it back to the upper layers after doing
encryption.

I found this entry in the algo registration structure in the device driver
.cra_u.ablkcipher = {
.min_keysize = AES_MIN_KEY_SIZE,
.max_keysize = AES_MAX_KEY_SIZE,
.geniv = "seqiv",

>From some clues I got online the .geniv is telling a module to
generate the IV? The module says that it will salt the IV but my
requirements are that the IV must be used as is without salt. I
removed the .geniv line from the source code but still my IV seems to
be getting corrupted/modified. Does anybody know what I should do to
fix this or which resource online I should read to learn how to deal
with this?
