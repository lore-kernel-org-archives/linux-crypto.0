Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92480C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 07:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF9520449
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 07:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="TCcGOTat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfFCHCm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 03:02:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:18472 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCHCm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 03:02:42 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45HQwr0fSPz9v0Y5;
        Mon,  3 Jun 2019 09:02:36 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=TCcGOTat; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id da8KgaKUKkbA; Mon,  3 Jun 2019 09:02:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45HQwq6khSz9v0Xt;
        Mon,  3 Jun 2019 09:02:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1559545355; bh=NO4fB+m3OtDoIwxgAyZQiCGkauq5v+waq4FdkuigmOA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TCcGOTat3bZQ7bkcQdm/wp8174EbiGztQoOt3Nroel4ZcpBOBM7xv4KUBzOGrjQW0
         CHfpsfelf+b63UprrxeCeErjpLCtzb5c8AYn0203G6l53/GpslBB72eY8OKTKdfmrq
         1nScQrMYt5plsm4kwM84PgY2lGY6yIcLxhFYc4vo=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6141F8B7B1;
        Mon,  3 Jun 2019 09:02:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id PML3eTP_VqfM; Mon,  3 Jun 2019 09:02:40 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 35A848B7A1;
        Mon,  3 Jun 2019 09:02:40 +0200 (CEST)
Subject: Re: Conding style question regarding configuration
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
 <AM6PR09MB3523B77DE66DD5353F08A687D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190529180731.Horde.NGHeOXuCgw23pVdGqjc0fw9@messagerie.si.c-s.fr>
 <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e1dfd2d6-c8d2-b542-5378-bde21fa3cf1c@c-s.fr>
Date:   Mon, 3 Jun 2019 09:02:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 30/05/2019 à 12:16, Pascal Van Leeuwen a écrit :
>>>> Yes. Code and data with static linkage will just be optimized away by
>>>> the compiler if the CONFIG_xx option is not enabled, so all you need
>>>> to guard are the actual statements, function calls etc.
>>>>
>>> Ok, makes sense. Then I'll just config out the relevant function bodies
>>> and assume the compiler will do the rest ...
>>>
>>
>> No need to config out function bodies when they are static.
>>
> Well, I got a complaint from someone that my driver updates for adding PCIE
> support wouldn't  compile properly on a platform without a PCI(E) subsystem.
> So I figure I do have to config out the references to PCI specific function
> calls to fix that.

Do you have a link to your driver updates ? We could help you find the 
best solution.

Christophe

> 
> Or are you just referring to bodies of static subfunctions that are no
> longer being called? Would the compiler skip those entirely?
> 
>> If not, it's better to group then in a C file and associate that file
>> to the config symbol through Makefile
>>
>> Christophe
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> www.insidesecure.com
> 
