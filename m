Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55995C0650E
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5152173B
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="GE/Z85X4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405627AbfFKRQd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 13:16:33 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:15384 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405226AbfFKRQc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 13:16:32 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Nc9T6Ks4z9v1Dv;
        Tue, 11 Jun 2019 19:16:29 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=GE/Z85X4; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id dt5_FGmXaT0A; Tue, 11 Jun 2019 19:16:29 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Nc9T594wz9v1Dt;
        Tue, 11 Jun 2019 19:16:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560273389; bh=kovbowBulTTTkU12hV0icfjhdrL5jEiLi1EE3kyGX8c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GE/Z85X4NVMvmUNAnbEaPR4yocDd/zKp6Fd6sPAz2RhoCYj5T2diE3Ks1oMSQV6gD
         dGuP/+oiIMOKRRVdWf+pFPMNIxItQm1Wdj5yrvtWCRCeAnBHwIw2O+94Di0o6QX6KZ
         T4ABIq9lISX662+sL0SffhYFy8dtgWsxnAtmxZ28=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 693198B7FA;
        Tue, 11 Jun 2019 19:16:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Yi0S9Pm4FyPm; Tue, 11 Jun 2019 19:16:31 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A60BD8B75B;
        Tue, 11 Jun 2019 19:16:30 +0200 (CEST)
Subject: Re: [PATCH v2 0/4] Additional fixes on Talitos driver
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB34853CAF031426F4183FE29B98ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <0cb7c534-6e48-5284-899c-c0ef85c3c126@c-s.fr>
 <VI1PR0402MB3485AD965F36709F27EFB72698ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e6d9f707-487b-e1a3-2ef1-d73ad4c8755e@c-s.fr>
Date:   Tue, 11 Jun 2019 19:16:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB3485AD965F36709F27EFB72698ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 11/06/2019 à 18:30, Horia Geanta a écrit :
> On 6/11/2019 6:40 PM, Christophe Leroy wrote:
>>
>>
>> Le 11/06/2019 à 17:37, Horia Geanta a écrit :
>>> On 6/11/2019 5:39 PM, Christophe Leroy wrote:
>>>> This series is the last set of fixes for the Talitos driver.
>>>>
>>>> We now get a fully clean boot on both SEC1 (SEC1.2 on mpc885) and
>>>> SEC2 (SEC2.2 on mpc8321E) with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS:
>>>>
>>> I am getting below failures on a sec 3.3.2 (p1020rdb) for hmac(sha384) and
>>> hmac(sha512):
>>
>> Is that new with this series or did you already have it before ?
>>
> Looks like this happens with or without this series.
> 
> I haven't checked the state of this driver for quite some time.
> Since I've noticed increased activity, I thought it would be worth
> actually testing the changes.
> 
> Are changes in patch 2/4 ("crypto: talitos - fix hash on SEC1.")
> strictly for sec 1.x or they affect all revisions?

They are strictly for sec 1.x

> 
>> What do you mean by "fuzz testing" enabled ? Is that
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS or something else ?
>>
> Yes, it's this config symbol.

Indeed SEC 2.2 only supports up to SHA-256.

Christophe

> 
> Horia
> 
