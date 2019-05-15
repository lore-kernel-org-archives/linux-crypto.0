Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FDFC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 11:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4776720843
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 11:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Xu2Fb7+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfEOL6U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 07:58:20 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:56475 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfEOL6T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 07:58:19 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 453tNm5Dq2z9vDbV;
        Wed, 15 May 2019 13:58:16 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Xu2Fb7+V; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id MqTJTkSxMsQw; Wed, 15 May 2019 13:58:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 453tNm49NMz9vDbT;
        Wed, 15 May 2019 13:58:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557921496; bh=+73gT6NA6NW2DnlTlmM/3gPkuFToS2cIKSvZcSZ7FvQ=;
        h=From:Subject:To:Cc:Date:From;
        b=Xu2Fb7+VYB3DeD/mZBpLLa7d/2fJklNODkR+354e8kNLVh6u9Ayy6cU2PVeLvG9l8
         RwC5B0vK7T8AiWnbMKhafVMQ6LU3KVECbIJWCZmo+7dFz6tVHud9HZzqSgeZySN+pG
         Jg2fpJsqHEIsNASsqdml/MZMF+xs0aM/SzauTf1c=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E19048B902;
        Wed, 15 May 2019 13:58:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id k0XBLXGVxpgI; Wed, 15 May 2019 13:58:17 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BEEA58B8F7;
        Wed, 15 May 2019 13:58:17 +0200 (CEST)
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Can scatterlist elements cross page boundary ?
To:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Message-ID: <798a42c9-bcda-6612-088c-cb90c35a578f@c-s.fr>
Date:   Wed, 15 May 2019 13:58:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I had understood that scatterlists where lists of buffers, each buffer 
being enclosed within a single memory PAGE. Isn't that right ?

As far as I understand, dma_map_sg() expects each entry to be DMA mapable.

But at the time being, I'm getting the following errors on the Talitos 
algorithmes:

[    2.382845] alg: aead: authenc-hmac-sha1-cbc-aes-talitos encryption 
test failed (wrong result) on test vector 0, cfg="misaligned splits 
crossing pages, inplace"

[    2.430178] alg: aead: authenc-hmac-sha1-cbc-aes-talitos encryption 
test failed (wrong result) on test vector 1, cfg="misaligned splits 
crossing pages, inplace"

[    2.509270] alg: aead: authenc-hmac-sha256-cbc-aes-talitos encryption 
test failed (wrong result) on test vector 0, cfg="uneven misaligned 
splits, may sleep"

When comparing the expected and actual results, I see (respectively for 
the 3 fails above tests) :

[    2.362271] 00000000: e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a
[    2.368529] 00000010: 1b 13 cb af 89 5e e1
[    2.372429] 00000000: e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a
[    2.378924] 00000010: fe fe fe fe fe fe fe

[    2.398908] 00000000: d2 96 cd 94 c2 cc cf 8a 3a 86 30 28 b5 e1 dc 0a
[    2.405185] 00000010: 75 86 60 2d 25 3c ff f9 1b 82 66 be a6 d6 1a b1
[    2.411407] 00000020: ad 9b 4c
[    2.414427] 00000000: d2 96 cd 94 c2 cc cf 8a 3a 86 30 28 b5 e1 dc 0a
[    2.420926] 00000010: 75 86 60 2d 25 3c ff f9 1b 82 66 be a6 d6 1a b1
[    2.427287] 00000020: fe fe fe

[    2.491701] 00000000: e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a
[    2.498125] 00000010: cc
[    2.500403] 00000000: e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a
[    2.507012] 00000010: fe


Looking at the test manager, I understand that it builds scatterlists 
with buffers that are using 2 pages. Am I correct ?

Then how do we expect the driver to behave ?

Thanks
Christophe
