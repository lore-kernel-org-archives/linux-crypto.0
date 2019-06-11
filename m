Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81363C43218
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 12:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 535DE2089E
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 12:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="EQD49fo6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388043AbfFKMid (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 08:38:33 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:20903 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387596AbfFKMid (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 08:38:33 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45NV0k0lbbz9tyZn;
        Tue, 11 Jun 2019 14:38:30 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=EQD49fo6; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Yzt-cnmLSSyP; Tue, 11 Jun 2019 14:38:30 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45NV0j6pNYz9tyZm;
        Tue, 11 Jun 2019 14:38:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560256709; bh=BnL8IVV6Yq5wD86SmLNonMbSs9KBZFPcrKoyJr9Obpc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EQD49fo6h3lsSLZ+DpNf78l9VkYz9BqyS7T1QaZeYw+UyeXMdN/OdnioDPd0u5rYZ
         ISWcfxnLQcWGXzctazyhvDWI83vS0QWhi1Vu6ENZ0bgGoxsfPVtlztPurXB4QyTKIP
         bPBnxDpXhq+SYJrXJ7sD35c67OeQdkkbbrI5hE0M=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 487508B7F3;
        Tue, 11 Jun 2019 14:38:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id m055cEBEDQ_Y; Tue, 11 Jun 2019 14:38:31 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7F30E8B7F1;
        Tue, 11 Jun 2019 14:38:30 +0200 (CEST)
Subject: Re: [PATCH v1 2/5] crypto: talitos - move struct talitos_edesc into
 talitos.h
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <cover.1559819372.git.christophe.leroy@c-s.fr>
 <108a23c4d2f0803b1302bc00c7321d799e42edc1.1559819372.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485848D81EF07419EB0128F98ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <a3474daf-3e51-4ce9-0634-8690c2e3045d@c-s.fr>
Date:   Tue, 11 Jun 2019 14:38:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB3485848D81EF07419EB0128F98ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 11/06/2019 à 13:57, Horia Geanta a écrit :
> On 6/6/2019 2:31 PM, Christophe Leroy wrote:
>> Next patch will require struct talitos_edesc to be defined
>> earlier in talitos.c
>>
>> This patch moves it into talitos.h so that it can be used
>> from any place in talitos.c
>>
>> Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
> This isn't really a fix, so please drop the tag.

As the next patch requires this one and Fixes 37b5e8897eb5, by setting 
Fixes: 37b5e8897eb5 here was for me a way to tell stable that this one 
is required for the following one.

Otherwise, how can I ensure that this one will be taken when next one is 
taken ?

Christophe


> 
> Thanks,
> Horia
> 
