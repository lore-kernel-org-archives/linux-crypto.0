From: =?KOI8-R?B?88XSx8XKIO3J0s/Oz9c=?= <ierton@gmail.com>
Subject: understanding concept, async block ciphers
Date: Tue, 12 May 2009 13:21:43 +0400
Message-ID: <aa09d86e0905120221n2dadd1e5jd99a7adc11658e2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:26037 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZELJVo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2009 05:21:44 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1641114fkq.5
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2009 02:21:43 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello. I'm developing driver for our crypto platform-device on
arm-realview arch. Could you please help with understanding some
CryptoAPI concepts?

Our device  is hw implementation of 3DES/AES cipher. it allows:
- encrypt/decrypt 64-bit words   (slave mode, data exchange via
registers, CBC/ECB controlled by driver)
- encrypt/decrypt blocks of data   (master mode, data exchange via DMA
transfers, CBC/ECB controlled by device)

I've implemented CRYPTO_ALG_TYPE_CIPHER driver for "slave" mode (just
as i in geode-aes driver). CBC and ECB templates are working fine. But
for "master" mode i have a questions:

1. Whats the difference between async crypto_alg's with
    .cra_type = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC
and
    .cra_type = CRYPTO_ALG_TYPE_ABLKCIPHER

Seems, that both are async. What is typical use-cases for them?

2. What are the rules for naming my alorithms?
I looked in code, and think, that name is constructed like
template_name1 ( template_name2 ( ... ( algorithm_name ) ... )

For example (as i saw in tcrypt.c), if my crypto_alg has
   .cra_flags = CRYPTO_ALG_TYPE_CIPHER ,
   .cra_name =   "des3_ede"
then it is possible to alloc CRYPTO_ALG_TYPE_BLKCIPHER request by
names  "cbc(des3_ede)"  or "ecb(des3_ede)" and
CRYPTO_ALG_TYPE_BLKCIPHER  | CRYPTO_ALG_ASYNC  request with
"cryptd(cbc(des3_ede)))" ?   Am i right ?

Thanks.

-- 
Sergey
