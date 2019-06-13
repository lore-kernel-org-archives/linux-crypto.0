Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57484C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A5C21743
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="jjVrlzgZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbfFMPXP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:23:15 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:61639 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbfFMM24 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:28:56 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Pjhg5Y5nz9tyyr;
        Thu, 13 Jun 2019 14:28:51 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=jjVrlzgZ; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id t1FmrBA-mTCn; Thu, 13 Jun 2019 14:28:51 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Pjhg4W1Fz9tyyq;
        Thu, 13 Jun 2019 14:28:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560428931; bh=2lgTds9Ez+Act/eI3r7EuN8KPltls6Liv5UATwaFdA8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jjVrlzgZziKbmWxq5pBLawp4u/+Sg06uDLfo9+LyyaU+ZuT6B3XImtsNMkkViP7ye
         d4a3GOPqNr40JYGgAnJV0ZWBL4uKzi2lnfDx4gnUneZ/VhRilPO08zvcQetBEi3ZEl
         loAfBcsePZojPB2MRZ86WxmtOfxd1JcPxfYjKUk0=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id F0E208B8E3;
        Thu, 13 Jun 2019 14:28:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id A89TBiKKs0oV; Thu, 13 Jun 2019 14:28:52 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 49A128B8B9;
        Thu, 13 Jun 2019 14:28:52 +0200 (CEST)
Subject: Re: [PATCH v2 4/4] crypto: talitos - drop icv_ool
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <cover.1560263641.git.christophe.leroy@c-s.fr>
 <39be46fb40ad77e40ae5c1a979ca6a2ccfab244a.1560263641.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB34852F501B30A09A4E515B4798EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <b2db68d5-d89b-2f38-d5b4-7b7eccf68204@c-s.fr>
Date:   Thu, 13 Jun 2019 14:28:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB34852F501B30A09A4E515B4798EF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 13/06/2019 à 14:21, Horia Geanta a écrit :
> On 6/11/2019 5:39 PM, Christophe Leroy wrote:
>> icv_ool is not used anymore, drop it.
>>
>> Fixes: 9cc87bc3613b ("crypto: talitos - fix AEAD processing")
> I can't find this SHA1.
> 
> Are you referring to commit e345177ded17 ("crypto: talitos - fix AEAD processing.")?
> 
> Horia
> 

Oops yes, that's the sha1 it had in my tree before it got merged.

Do I have to resend it or can Herbert just drop the wrong reference and 
take the following one:

Fixes: e345177ded17 ("crypto: talitos - fix AEAD processing.")


Christophe
