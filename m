Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D24C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F7E2175B
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="ULwrlH1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbfEXGVG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 02:21:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22769 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387936AbfEXGVG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 02:21:06 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 459GTX42qqzB09ZK;
        Fri, 24 May 2019 08:21:04 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=ULwrlH1K; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id fK8K6824bS2b; Fri, 24 May 2019 08:21:04 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 459GTX31F3zB09ZH;
        Fri, 24 May 2019 08:21:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558678864; bh=0kNON5XTeKK4o7LieIj9N9uE6W9s+0vmPCSwsAjAG70=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ULwrlH1K0ASETy0giF4mNwBV1Rhlz++Eh6YKI2BTX80Jr3WXh8cCQeFhMuKotoYrz
         HjCn18qzYS87Ryzp7d84Yo+YLnpXR9wABuP5JfUTq2jNELidjJOdkgyLkyIbHucxXT
         u06Orb7132NVnEwaK/datac9eT9KE99APGspfsS8=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 585AC8B790;
        Fri, 24 May 2019 08:21:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Nh7rH7RRI6wZ; Fri, 24 May 2019 08:21:05 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3C7D48B76F;
        Fri, 24 May 2019 08:21:05 +0200 (CEST)
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <6e5a9618-fc54-f649-6ca3-5c8ced027630@c-s.fr>
Date:   Fri, 24 May 2019 08:21:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

Le 23/05/2019 à 23:43, Pascal Van Leeuwen a écrit :
>> -----Original Message-----
>> From: Eric Biggers [mailto:ebiggers@kernel.org]

[...]

>> Note that it's not necessary that your *hardware* supports empty messages,
>> since you can simply do this in the driver instead:
>>
>>        if (req->cryptlen == 0)
>>                return 0;
>>
> For skciphers, yes, it's not such a problem. Neither for basic hash.
> (And thanks for the code suggestion BTW, this will be a lot more efficient
> then what I'm doing now for this particular case :-)
> For HMAC, however, where you would have to return a value depending on the
> key ... not so easy to solve. I don't have a solution for that yet :-(

I had the same issue when porting the SEC2 Talitos driver to also 
support SEC1. See following commit to see the way it has been fixed:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d02905ebd22c0271a25e424ab209c8b7067be67

Christophe

> 
> And I'm pretty sure this affects all Inside Secure HW drivers in the tree:
> inside-secure, amcc, mediatek and omap ...
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines, Inside Secure
> www.insidesecure.com
> 
