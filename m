Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C35C47080
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 13:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57CF60233
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 13:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhFANEk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:04:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:3466 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhFANEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 09:04:40 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4FvXQ85hJPzBF1p;
        Tue,  1 Jun 2021 15:02:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BEPUFl63s1O9; Tue,  1 Jun 2021 15:02:56 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FvXQ84k7czBF1j;
        Tue,  1 Jun 2021 15:02:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5A2718B815;
        Tue,  1 Jun 2021 15:02:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BW4lKJ5eY-g1; Tue,  1 Jun 2021 15:02:56 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8B90D8B7C3;
        Tue,  1 Jun 2021 15:02:55 +0200 (CEST)
Subject: Re: [PATCH] drivers: crypto: talitos.c: Replace space with tabs
To:     shubh vk <shubhankarvk@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
References: <20210525140903.nqj5rdohduzemm4l@kewl-virtual-machine>
 <20210525182018.Horde.RpVsAs9V_zh-RmbuxnlQTQ2@messagerie.c-s.fr>
 <CAOMz5Fg0FW=_i_V9sKCuvUZj9+vmoF13LD384S97YiMXGfGEwA@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <b25b51d2-df56-31c8-83a7-44c0dac1270d@csgroup.eu>
Date:   Tue, 1 Jun 2021 15:02:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAOMz5Fg0FW=_i_V9sKCuvUZj9+vmoF13LD384S97YiMXGfGEwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 25/05/2021 à 20:15, shubh vk a écrit :
> 
> 
> On Tue, 25 May 2021, 9:45 pm Christophe Leroy, <christophe.leroy@csgroup.eu 
> <mailto:christophe.leroy@csgroup.eu>> wrote:
> 
>     Shubhankar Kuranagatti <shubhankarvk@gmail.com <mailto:shubhankarvk@gmail.com>> a écrit :
> 
>      > Tabs have been used instead of spaces for indentation
>      > This is done to maintain code uniformity(LINDENT).
> 
>     Nack.
> 
>     The changes done by this patch break linux codying style. For
>     instance, additional lines alignment must match open parenthesis.
> 
>     Did you run checkpatch.pl <http://checkpatch.pl/> on your path?
> 
>     Yes, I have run checkpatch on my file and it showed no errors or warnings.


Surprisingly, checkpatch on your patch doesn't say anything, but checkpatch on 
drivers/crypto/talitos.c after applying your patch returns the following in addition to the ones 
returned without your patch:

CHECK: Alignment should match open parenthesis
#177: FILE: drivers/crypto/talitos.c:177:
+		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
+				TALITOS_CCCR_LO_IWSE);

CHECK: Alignment should match open parenthesis
#252: FILE: drivers/crypto/talitos.c:252:
+		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
+				TALITOS_MDEUICR_LO_ICE);





Christophe
