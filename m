Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE785C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 09:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD526525D
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 09:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCIJaZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:30:25 -0500
Received: from linux.microsoft.com ([13.77.154.182]:57906 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhCIJaD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 04:30:03 -0500
Received: from [192.168.0.114] (unknown [49.207.210.77])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0CE1B20B26C5;
        Tue,  9 Mar 2021 01:29:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0CE1B20B26C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615282202;
        bh=CDYqG2GIuZVR5z0oqm1GZmaheRjDizkca+UJHZd+0GI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NVeEjgcK9BRcMfN+1DWoFPF7F0iWQG11DSKd1RS7RpOgd96fzaUGJsKVno8QnpaQh
         A/m2/byHvmbLabts1yxTAYtkMEDvIRO8cGdyLneaxrB82B6YrMMlcZwAuAVn2++s2j
         aD8AJWIqe1JXOP7k7Vxz9IhcBEcfAUYNFaPJZwbs=
Subject: Re: [PATCH v5 01/19] crypto: amcc: convert tasklets to use new
 tasklet_setup() API
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
 <20210208094238.571015-2-allen.lkml@gmail.com>
 <20210304062644.GA5107@gondor.apana.org.au>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <2e2604a3-b0b1-92f2-aa7b-f413fae4cb51@linux.microsoft.com>
Date:   Tue, 9 Mar 2021 14:59:51 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210304062644.GA5107@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


>>
>> In preparation for unconditionally passing the
>> struct tasklet_struct pointer to all tasklet
>> callbacks, switch to using the new tasklet_setup()
>> and from_tasklet() to pass the tasklet pointer explicitly.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
>> ---
>>   drivers/crypto/amcc/crypto4xx_core.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> This introduces a compiler warning with C=1 W=1.

Okay. I will check and send out a fix.

Thanks.
