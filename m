Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A34C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 11:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F2DA20801
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 11:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgFKLJx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 07:09:53 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:19302 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFKLJw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 07:09:52 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49jLjQ2d4Fz9txkK;
        Thu, 11 Jun 2020 13:09:46 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id CvG2DyrDl8xM; Thu, 11 Jun 2020 13:09:46 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49jLjQ1gBdz9txkH;
        Thu, 11 Jun 2020 13:09:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BC4FF8B850;
        Thu, 11 Jun 2020 13:09:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id DaXlctlmzFOu; Thu, 11 Jun 2020 13:09:47 +0200 (CEST)
Received: from [10.25.210.22] (po15451.idsi0.si.c-s.fr [10.25.210.22])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 91BC98B75B;
        Thu, 11 Jun 2020 13:09:47 +0200 (CEST)
Subject: Re: [PATCH] crypto: talitos - fix ECB and CBC algs ivsize
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Su Kang Yin <cantona@cantona.net>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <cantona@cantona.net> <20200611100745.6513-1-cantona@cantona.net>
 <718354b4-d284-8e47-4085-f45101f9ca36@csgroup.eu>
 <20200611110350.GA3954279@kroah.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <24a06073-1765-985e-029b-80a78ad02b89@csgroup.eu>
Date:   Thu, 11 Jun 2020 13:09:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611110350.GA3954279@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 11/06/2020 à 13:03, Greg KH a écrit :
> On Thu, Jun 11, 2020 at 12:50:24PM +0200, Christophe Leroy wrote:
>> Hi,
>>
>> Le 11/06/2020 à 12:07, Su Kang Yin a écrit :
>>> Patch for 4.9 upstream:
>>>
>>> commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
>>> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
>>
>> To make it clear and avoid this problem to happen again, please generate
>> your patch with option -U8
> 
> No need, this patch should be fine as-is.
> 

Still, this patch includes more than the original patch as far as I can 
see (scroll down and see other comments in that answer)

Christophe
