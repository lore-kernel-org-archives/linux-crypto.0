Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AF0C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBE321743
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="N1nJ11V+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfFMPXJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:23:09 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:37340 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731915AbfFMMcU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:32:20 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Pjmc3ZLpz9tyyr;
        Thu, 13 Jun 2019 14:32:16 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=N1nJ11V+; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 65clM26o8HPp; Thu, 13 Jun 2019 14:32:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Pjmc2WFmz9tyyq;
        Thu, 13 Jun 2019 14:32:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560429136; bh=3dVkbT/RsDJuQ1SDxSTRwxXBGJ5VhupziMUNo4LBj4o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=N1nJ11V+L5AV4a0LyeJq0SVfHDSz2duv88WXKKNvEFZ8+3zusPO5JEpZxTlQFHzd4
         RZoRnM30BJT/mqiTv0sSAnH4QBxWDZl6W5/kY1h/TCRzMMwLMh9RDfRjPpv1c12ul3
         ZhBw8Raeib2Lvu57DnSGXZ41pni+NCCtZx23x+sQ=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A25CA8B8E3;
        Thu, 13 Jun 2019 14:32:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id UGdLyK93zdQH; Thu, 13 Jun 2019 14:32:17 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DBE418B8B9;
        Thu, 13 Jun 2019 14:32:16 +0200 (CEST)
Subject: Re: [PATCH v2 1/4] crypto: talitos - move struct talitos_edesc into
 talitos.h
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <d9b5fade242f0806a587392d31c272709949479f.1560263641.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485C0F4CB13F8674B8B5A5598EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <7fb54918-4524-1e6b-dd29-46be8843577b@c-s.fr>
 <VI1PR0402MB34858ABA5DE0324FA6E2CFCD98EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <ce6beda2-75c8-f360-9e01-5a883128d153@c-s.fr>
Date:   Thu, 13 Jun 2019 14:32:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB34858ABA5DE0324FA6E2CFCD98EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 13/06/2019 à 14:24, Horia Geanta a écrit :
> On 6/13/2019 3:16 PM, Christophe Leroy wrote:
>>
>>
>> Le 13/06/2019 à 14:13, Horia Geanta a écrit :
>>> On 6/11/2019 5:39 PM, Christophe Leroy wrote:
>>>> Next patch will require struct talitos_edesc to be defined
>>>> earlier in talitos.c
>>>>
>>>> This patch moves it into talitos.h so that it can be used
>>>> from any place in talitos.c
>>>>
>>>> Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>> Again, this patch does not qualify as a fix.
>>>
>>
>> But as I said, the following one is a fix and require that one, you told
>> me to add stable in Cc: to make it explicit it was to go into stable.
> Yes, but you should remove the Fixes tag.
> And probably replace "Next patch" with the commit headline.
> 
>> If someone tries to merge following one into stable with taking that one
>> first, build will fail.
> This shouldn't happen, order from main tree should be preserved.
> 

When they pick up fixes, AFAIK they don't take all the preceeding commits.

But ok, I'll resend.

Christophe
