Return-Path: <SRS0=hp4v=WW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E6EC3A59E
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Aug 2019 06:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A39217F4
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Aug 2019 06:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="nz82GQfv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfHZG5t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:57:49 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:16400 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfHZG5s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Aug 2019 02:57:48 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46H2rQ3Q7Kz9vBLK;
        Mon, 26 Aug 2019 08:57:42 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=nz82GQfv; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 0BLECxZKWJfM; Mon, 26 Aug 2019 08:57:42 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46H2rQ1rCSz9vBLJ;
        Mon, 26 Aug 2019 08:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1566802662; bh=aZYAcTNAf9puWpxcoR1X89KPq8JXWoAVBzsU7UH1tsU=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=nz82GQfvMScr0AQjq5gO9D3xMdPBK1dL9EyzLQ9i2VgfCsDkNp6F/+2AP8R5nJAzj
         nF6/zjSs/jGJylOK62HZC5U8kMMX9/raGKskxjzIDp04gKXrneYXVXQIAE9ytEF+Dd
         d8E1TgohuGVCTCH9yJJKfY8JrgZ7IaswU7qxmK04=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E01F78B7CE;
        Mon, 26 Aug 2019 08:57:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 6xB2eY4bRtgG; Mon, 26 Aug 2019 08:57:46 +0200 (CEST)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BDFF68B7B9;
        Mon, 26 Aug 2019 08:57:46 +0200 (CEST)
Subject: Re: Data size error interrupt with Talitos driver on 4.9.82 kernel
To:     Mukul Joshi <mukuljoshi2011@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <CANaw-r4i6qHXYNDFu5dZ4DsHedyPonk5N+-F9Mu4JvLRrD50sQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Kim Phillips <kim.phillips@arm.com>
Message-ID: <d20ab826-5a7a-e0e4-6591-4c7d4bdae5d8@c-s.fr>
Date:   Mon, 26 Aug 2019 08:57:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANaw-r4i6qHXYNDFu5dZ4DsHedyPonk5N+-F9Mu4JvLRrD50sQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mukul

Le 24/08/2019 à 18:40, Mukul Joshi a écrit :
> Hi Christophe,

[...]

> 
> I am working with MPC8360E SoC  and trying to setup IPSEC tunnel between 
> 2 hosts.
> I am able to setup the tunnel but I am seeing issues with packet 
> decryption. The sender side doesn't seem to have a problem and the 
> packet is also being encrypted by the EU.
> 
> Upon reception of packet, I am seeing Data size error interrupt go up in 
> the Interrupt status register of the EU.
> I see the problem with both AES and 3DES algos.
> 
> Here are the logs that I see in dmesg:
> AES:
> [  832.041102] talitos e0030000.crypto: AESUISR *0x00000000_00000100*
> [  832.041120] talitos e0030000.crypto: MDEUISR 0x00000000_00000000
> [  832.041131] talitos e0030000.crypto: DESCBUF 0x60235c0b_00000000
> [  832.041142] talitos e0030000.crypto: DESCBUF 0x00140000_0c8d353c
> [  832.041154] talitos e0030000.crypto: DESCBUF 0x00180000_12f57920
> [  832.041165] talitos e0030000.crypto: DESCBUF 0x00100000_144e3e40
> [  832.041176] talitos e0030000.crypto: DESCBUF 0x00100000_0c8d3550
> [  832.041188] talitos e0030000.crypto: DESCBUF 0x006c0000_12f57938
> [  832.041199] talitos e0030000.crypto: DESCBUF 0x00600c00_12f57938
> [  832.041210] talitos e0030000.crypto: DESCBUF 0x00100000_0c8d35dc
> 
> 3DES:
> [ 313.635521] talitos e0030000.crypto: DEUISR *0x00000000_00000100*
>   [  313.635539] talitos e0030000.crypto: DEUDSR *0x00000000_00000320*
>   [  313.635549] talitos e0030000.crypto: DEURCR 0x00000000_00000000
>   [  313.635560] talitos e0030000.crypto: DEUSR 0x00000000_00000025
>   [  313.635572] talitos e0030000.crypto: DEUICR 0x00000000_00003000
>   [  313.635583] talitos e0030000.crypto: MDEUISR 0x00000000_00000000
>   [  313.635594] talitos e0030000.crypto: DESCBUF 0x20635e0b_00000000
>   [  313.635605] talitos e0030000.crypto: DESCBUF 0x00100000_1abbc03c
>   [  313.635617] talitos e0030000.crypto: DESCBUF 0x00100000_1ef2f226
>   [  313.635628] talitos e0030000.crypto: DESCBUF 0x00080000_1abbdc80
>   [  313.635639] talitos e0030000.crypto: DESCBUF 0x00180000_1abbc04c
>   [  313.635650] talitos e0030000.crypto: DESCBUF 0x00640000_1ef2f236
> [  313.635726] talitos e0030000.crypto: DESCBUF 0x00580c00_1ef2f236
>   [  313.635738] talitos e0030000.crypto: DESCBUF 0x00080000_1abbc0dc
> 
> I was able to dump the data size register value for DES and it shows a 
> value of 0x320 in LO word.
> This shows that the Data size for decryption is not 64-bit multiple 
> which causes the Data size error interrupt to go up but I don't know how 
> this value gets written and why is the value as 0x320 when the the 
> tcpdump on the receive side shows a packet size of 112 bytes of 
> encrypted packets received.

Yes that's strange. The pointers in the descriptors dumped above all 
have valid size. The input data has size 0x64 ie 100 bytes, and the 
output data has size 88 + 12 bytes HMAC out.

Have you activated crypto tests at boot time ? Do they all pass ?

Can you have a look at CCPSR register ?

> 
> Can you please give me a few pointers about what could be causing this 
> issue and where else can I look further.

Can you try with kernel 4.9.190 ?

Have you tried with a newer LTS kernel, for instance 4.14.x or 4.19.x ?

Christophe
