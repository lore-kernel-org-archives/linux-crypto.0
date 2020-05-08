Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3AEC38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 05:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F61D208D6
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 05:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Dr0qkalJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgEHFr1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 01:47:27 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58752 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgEHFr0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 01:47:26 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0485lGJL109548;
        Fri, 8 May 2020 00:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588916836;
        bh=tpWf5GzOkQk9w0yvuv9UJ6t9JNzfSmCCoxsTbekiY4k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Dr0qkalJM4pOiKfAI1xoD09ZlXTZPWVIrJyJK39Bl6KKuGsQBeLayrk7E3BE0snoY
         TFKSGBa8Qq6AmWecEv1Z+K3ulqcbvtPVWQ9Q+5D7XvSDHpR6JEwui/8fTUh2PDDB3R
         rDD6H/lLbZGUndnsJYtpvNagZYcHJSh3oqStlDvc=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0485lGpo057726
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 May 2020 00:47:16 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 8 May
 2020 00:47:15 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 8 May 2020 00:47:15 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0485lCES064291;
        Fri, 8 May 2020 00:47:14 -0500
Subject: Re: [PATCH 3/6] crypto: omap-crypto: fix userspace copied buffer
 access
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20200429144205.5291-1-t-kristo@ti.com>
 <20200429144205.5291-4-t-kristo@ti.com>
 <20200508050848.GA21823@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <4c7e94c4-3e09-5344-1ec7-b998a4d7fd65@ti.com>
Date:   Fri, 8 May 2020 08:47:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200508050848.GA21823@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/05/2020 08:08, Herbert Xu wrote:
> On Wed, Apr 29, 2020 at 05:42:02PM +0300, Tero Kristo wrote:
>>
>> diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
>> index cc88b7362bc2..cbc5a4151c3c 100644
>> --- a/drivers/crypto/omap-crypto.c
>> +++ b/drivers/crypto/omap-crypto.c
>> @@ -178,11 +178,14 @@ static void omap_crypto_copy_data(struct scatterlist *src,
>>   		amt = min(src->length - srco, dst->length - dsto);
>>   		amt = min(len, amt);
>>   
>> -		srcb = sg_virt(src) + srco;
>> -		dstb = sg_virt(dst) + dsto;
>> +		srcb = kmap_atomic(sg_page(src)) + srco + src->offset;
>> +		dstb = kmap_atomic(sg_page(dst)) + dsto + dst->offset;
>>   
>>   		memcpy(dstb, srcb, amt);
>>   
>> +		kunmap_atomic(srcb);
>> +		kunmap_atomic(dstb);
> 
> With dst you also need to flush the cache.  Please refer to the
> flush dcache call in include/crypto/scatterwalk.h.

Ok, let me try that out, flushing a single page should be fine (meaning 
not catastrophic to performance.)

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
