From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [QUESTION] hash import and request initialization
Date: Mon, 25 Dec 2017 10:07:54 +0200
Message-ID: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33821 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdLYIHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Dec 2017 03:07:55 -0500
Received: by mail-oi0-f52.google.com with SMTP id u193so22342968oie.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Dec 2017 00:07:55 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi there,

I have ran into something I am unsure about regarding the ccree driver
implementation and would love to get some guidance:

I have assumed, based on previous list correspondence, that both of
the following sequences are legal:

Scenario A
1. ahash_request_alloc
2. ahash_import

Scenario B
1. ahash_request_alloc
2. crypto_ahash_init
3. ahash_import

However, I've run into the problem that since ahash_request_alloc does
not zero the allocated request memory
and specifically does not zero the tfm specific context part of it, I
have no way to distinguish  between A and B and therefore
if I have any initialization sequence that needs to happen once per
request (DMA buffer allocation and mapping in my
case), I cannot tell if I need to do them in ahash_import callback or not.

The testmgr test uses scenario A, but this is nor here nor there.

So, am I'm missing something here or is the B scenario simply not legal?

Many thanks and Happy Xmas if this applies to you,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
