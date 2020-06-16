Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056FBC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 04:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C777020776
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 04:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AzAk8oMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgFPEYk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:24:40 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33252 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgFPEYj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 00:24:39 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05G4OLKx098869;
        Mon, 15 Jun 2020 23:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592281461;
        bh=ThaAyWLSMOIe+/0BXs13JX/wpbe2DZuw6Fx9tKINAQQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AzAk8oMPjuu+vWdMhJ8MbC4IDNo7BwtyMxh1q6OqBbTlyuIFm8P8NsQoc5ZooOZry
         72gBaAj6nqZkOzkmk0PSRIIqoZ3I2zQTBkI6qsbVqZX4qfiLJ5jKKU1NWARC+gnjpq
         9NJQe2x9fTbHubJJ7H6mhDXM7Rfe/ThsrFlExWu0=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05G4OLh7005653
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 23:24:21 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 15
 Jun 2020 23:24:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 15 Jun 2020 23:24:20 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05G4OIOs119071;
        Mon, 15 Jun 2020 23:24:19 -0500
Subject: Re: [PATCHv4 0/7] crypto: sa2ul support for TI K3 SoCs
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <j-keerthy@ti.com>
References: <20200615071452.25141-1-t-kristo@ti.com>
 <20200615182029.GA85413@gmail.com>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <b8ac78c4-dbd1-aa47-e41c-89624d1960fa@ti.com>
Date:   Tue, 16 Jun 2020 07:24:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615182029.GA85413@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/06/2020 21:20, Eric Biggers wrote:
> On Mon, Jun 15, 2020 at 10:14:45AM +0300, Tero Kristo wrote:
>> Hi,
>>
>> This is basically just a rebase of v2 to 5.8-rc1, and application of
>> Rob's Ack on the dt-binding patch. No other changes.
>>
>> Only driver side + DT binding should be applied via the crypto tree, DTS
>> patches should be queued separately via ARM SoC tree (I can take care of
>> that myself assuming the driver side gets applied.)
>>
>> -Tero
> 
> Does this driver pass all the crypto self-tests, including with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

Yes, this passes full self test suite with no failures at all, including 
the extra tests.

> Please include details about testing in your commits.

I believe I mentioned this on the first iteration of the series.

In addition to self tests I've been testing the driver with tcrypt.ko, 
IPSec, and openssl (via cryptodev.)

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
