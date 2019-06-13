Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE198C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942AB2054F
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="XGC4QkHz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfFMPVS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:21:18 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54985 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732006AbfFMMuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:50:18 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Pk9K4M2Dz9v00J;
        Thu, 13 Jun 2019 14:50:13 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=XGC4QkHz; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id r2jrMUr4S6_f; Thu, 13 Jun 2019 14:50:13 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Pk9K3CjSz9tyyl;
        Thu, 13 Jun 2019 14:50:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560430213; bh=tSiFMtfMvkoo1YAalFTMO8Zl4haXafUMn4htZhOOXBw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XGC4QkHz/G0dORO17fuH504YhMMnNB4P+pF78ct0KiG+4jyQdmULNQdkyH/XqHHht
         6s66fVMxgJEgh+Aip60kOx7jIFbYrY5g2IJCAANf+1A8GN3geioEzUWdoQsN8elEES
         Gs03Zln4G2Is0qj+AL0P2O8FfS0JZ5k+IeDT+sQI=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CB8C18B8E4;
        Thu, 13 Jun 2019 14:50:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id vxc-WCLWMvLI; Thu, 13 Jun 2019 14:50:14 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2DEFD8B8B9;
        Thu, 13 Jun 2019 14:50:14 +0200 (CEST)
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
 <ce6beda2-75c8-f360-9e01-5a883128d153@c-s.fr>
 <VI1PR0402MB348514C4AA9E41C26FF4430998EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <4c3808ec-783d-d5b3-6c0b-ae5092652233@c-s.fr>
Date:   Thu, 13 Jun 2019 14:50:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB348514C4AA9E41C26FF4430998EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 13/06/2019 à 14:39, Horia Geanta a écrit :
> On 6/13/2019 3:32 PM, Christophe Leroy wrote:
>>
>>
>> Le 13/06/2019 à 14:24, Horia Geanta a écrit :
>>> On 6/13/2019 3:16 PM, Christophe Leroy wrote:
>>>>
>>>>
>>>> Le 13/06/2019 à 14:13, Horia Geanta a écrit :
>>>>> On 6/11/2019 5:39 PM, Christophe Leroy wrote:
>>>>>> Next patch will require struct talitos_edesc to be defined
>>>>>> earlier in talitos.c
>>>>>>
>>>>>> This patch moves it into talitos.h so that it can be used
>>>>>> from any place in talitos.c
>>>>>>
>>>>>> Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>>> Again, this patch does not qualify as a fix.
>>>>>
>>>>
>>>> But as I said, the following one is a fix and require that one, you told
>>>> me to add stable in Cc: to make it explicit it was to go into stable.
>>> Yes, but you should remove the Fixes tag.
>>> And probably replace "Next patch" with the commit headline.
>>>
>>>> If someone tries to merge following one into stable with taking that one
>>>> first, build will fail.
>>> This shouldn't happen, order from main tree should be preserved.
>>>
>>
>> When they pick up fixes, AFAIK they don't take all the preceeding commits.
>>
> This is not about Fixes tag, but Cc tag:
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-1
> 

Ah, ok. So I need to keep the Cc tag. I misunderstood sorry.
