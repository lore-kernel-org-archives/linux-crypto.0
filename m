Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CE4C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC207217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Ky102oXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389349AbfEXIqj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 04:46:39 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:57912 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389341AbfEXIqj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 04:46:39 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 459KjS3cTcz9v2n8;
        Fri, 24 May 2019 10:46:36 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Ky102oXG; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Asa4_l_WQ9QK; Fri, 24 May 2019 10:46:36 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 459KjS2bBNz9v2mv;
        Fri, 24 May 2019 10:46:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558687596; bh=Yxsu2RbH+V8qQpRufmIec3nFlM1bh8+oq2gRQyNLWzk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ky102oXGkptwyX0mviv9p61sazNJy0gqUBgcx6HwlefiqiuPw5MNbllSTxn2SFC7S
         L0wWhPaZGza+S1ZJI1Gr3+Ldhesl+IbZMqE8RZaAmB5J/cY1cu5DaMT9K/CwJ9ErTN
         pIupsHLYxGXZ26VeNt19ThEfdbQJKCzrOv7PuHL8=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6B9708B7A3;
        Fri, 24 May 2019 10:46:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 3AoDaHpRNUmx; Fri, 24 May 2019 10:46:37 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 44AF68B79E;
        Fri, 24 May 2019 10:46:37 +0200 (CEST)
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
Date:   Fri, 24 May 2019 10:46:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 24/05/2019 à 10:44, Pascal Van Leeuwen a écrit :
>>> Valid? A totally fabricated case, if you ask me. Yes, you could do that,
>>> but is it *useful* at all? Really?
>>> No, it's not because a file of length 0 is a file of length 0, the length
>>> in itself is sufficient guarantee of its contents. The hash does not add
>>> *anything* in this case. It's a constant anyway, the same value for *any*
>>> zero-length file. It doesn't tell you anything you didn't already know.
>>> IMHO the tool should just return a message stating "hashing an empty file
>>> does not make any sense at all ...".
>>>
>>
>> Of course it's useful.  It means that *every* possible file has a SHA-256
>> digest.  So if you're validating a file, you just check the SHA-256 digest;
>> or
>> if you're creating a manifest, you just hash the file and list the SHA-256
>> digest.  Making everyone handle empty files specially would be insane.
>>
> As I already mentioned in another thread somewhere, this morning in the
> shower I realised that this may be useful if you have no expectation of
> the length itself. But it's still a pretty specific use case which was
> never considered for our hardware. And our HW doesn't seem to be alone in
> this.
> Does shaXXXsum or md5sum use the kernel crypto API though?

The ones from libkcapi do (http://www.chronox.de/libkcapi.html)

Christophe
