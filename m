Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F24C19F2D
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Aug 2022 15:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiHFPpb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 6 Aug 2022 11:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHFPpa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Aug 2022 11:45:30 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C972CE18
        for <linux-crypto@vger.kernel.org>; Sat,  6 Aug 2022 08:45:27 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4M0Rck0MFHz9sl1;
        Sat,  6 Aug 2022 17:45:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2Kq1ANbQhRFG; Sat,  6 Aug 2022 17:45:25 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4M0Rcj6VGMz9skJ;
        Sat,  6 Aug 2022 17:45:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C98A88B76C;
        Sat,  6 Aug 2022 17:45:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Ui3-ODUsv8Bd; Sat,  6 Aug 2022 17:45:25 +0200 (CEST)
Received: from [192.168.234.210] (unknown [192.168.234.210])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7E0F28B765;
        Sat,  6 Aug 2022 17:45:25 +0200 (CEST)
Message-ID: <de9d2ae5-e794-6e54-baf6-f83a16d710a3@csgroup.eu>
Date:   Sat, 6 Aug 2022 17:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: talitos b0030000.crypto: length exceeds h/w max limit
Content-Language: fr-FR
To:     =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <4d9e644d-3d2d-518a-3d05-2539c69d88c1@c-s.fr>
 <1955828.3d07pK88Qj@tauon.chronox.de>
 <326109a3-bb5c-eac4-1340-70c179a3ad2a@c-s.fr>
 <10231361.cnp4CI42qt@positron.chronox.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <10231361.cnp4CI42qt@positron.chronox.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le 31/07/2019 à 09:11, Stephan Müller a écrit :
>>>>> If I remember correctly, the implementation with vmsplice was slower by
>>>>> a
>>>>> factor of 10 compared to sendmsg on the ISO image on an x86 system.
>>>>
>>>> At the time being I have an issue with this fix, because the talitos
>>>> driver only accepts 32k bytes at a time. With vmsplice, data is handed
>>>> over to the driver by blocks of PAGE_SIZE (16k in my case). With
>>>> sendmsg(), data is handed over to the driver with a single block.
>>>
>>> Ok. But wouldn't your driver need to process the data in the chunk size
>>> your hardware requires?
>>
>> Sure it needs to process the data in the chunk size the HW requires, but
>> do you know if there is a way to tell the core than the driver doesn't
>> accepts chunks of more than 32kbytes, or shall the driver be able to
>> handle data of any size ?
> 
> Coming back to this: Were you able to find a fix?

As far as I know the problem still exists.

We want to upgrade libkcapi on our target, but still facing the issue 
with libkcapi newer than 1.1.3 : When a file is bigger than 32 Kb, 
hashing operation (md5 or sha256) fails and the kernel prints the 
following message:

[ 2369.772999] talitos b0030000.crypto: length exceeds h/w max limit

Is there a way to tell crypto kernel core that a given driver has a 
fixed limit and that data shall be sent in chunks ? Or is it the 
responsibility of the driver to cut off the data in acceptable chunks ? 
I guess the Talitos driver is not the only driver with such a limit, so 
something centralised must exist to handle it ?

Thanks
Christophe
