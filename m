Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CF9C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4268F2065D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="JbkdBmWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGMIkf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:40:35 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39308 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgGMIkf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 04:40:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06D8eVAG065670;
        Mon, 13 Jul 2020 03:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594629631;
        bh=661LBLxGonMMwGUmFergDT5VKY4kgMx6uE8FOsaBPYs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JbkdBmWmNyA1UmXO8icDE8Bi3nboAoGm2SIGytDUBjaG/RXnkirrSDsEu5cLeqKag
         YvStX/K2O2gc6Ca2QX0yMr/IDG3/1gv4pv6NILkcguic/Vjy2IszTy9EjE9UXSN8k3
         3Owhg3+7TEjvqhKRC0N5B+RXEVXLa/0IDjg2mC/I=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06D8eVa0049637;
        Mon, 13 Jul 2020 03:40:31 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 13
 Jul 2020 03:40:31 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 13 Jul 2020 03:40:30 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06D8eTdh042581;
        Mon, 13 Jul 2020 03:40:29 -0500
Subject: Re: [PATCHv5 2/7] crypto: sa2ul: Add crypto driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <j-keerthy@ti.com>
References: <20200701080553.22604-1-t-kristo@ti.com>
 <20200701080553.22604-3-t-kristo@ti.com>
 <20200709080301.GA11760@gondor.apana.org.au>
 <20200709080612.GA16409@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <c3cc7fcf-c5c4-8329-f669-2f512a44ac44@ti.com>
Date:   Mon, 13 Jul 2020 11:40:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200709080612.GA16409@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 09/07/2020 11:06, Herbert Xu wrote:
> On Thu, Jul 09, 2020 at 06:03:01PM +1000, Herbert Xu wrote:
>> On Wed, Jul 01, 2020 at 11:05:48AM +0300, Tero Kristo wrote:
>>> From: Keerthy <j-keerthy@ti.com>
>>>
>>> Adds a basic crypto driver and currently supports AES/3DES
>>> in cbc mode for both encryption and decryption.
>>>
>>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>>> [t-kristo@ti.com: major re-work to fix various bugs in the driver and to
>>>   cleanup the code]
>>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>>> ---
>>>   drivers/crypto/Kconfig  |   14 +
>>>   drivers/crypto/Makefile |    1 +
>>>   drivers/crypto/sa2ul.c  | 1391 +++++++++++++++++++++++++++++++++++++++
>>>   drivers/crypto/sa2ul.h  |  380 +++++++++++
>>>   4 files changed, 1786 insertions(+)
>>>   create mode 100644 drivers/crypto/sa2ul.c
>>>   create mode 100644 drivers/crypto/sa2ul.h
>>
>> I get lots of sparse warnings with this driver.  Please fix them
>> and resubmit.
> 
> Please also compile test with W=1.

Just fixed all these and posted v6.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
