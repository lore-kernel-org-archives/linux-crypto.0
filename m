Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D04C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 07:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6794520759
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 07:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Q+cLGL1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgF3HUU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 03:20:20 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:46894 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730637AbgF3HUU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 03:20:20 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05U7KAGw065349;
        Tue, 30 Jun 2020 02:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593501610;
        bh=6Brzsw1lYCNLJ5e1uHm5326GF3+UxaADq2tLRXMYH6s=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Q+cLGL1qOjbbBGcSy+BwyhwyGgmmBe769tnQrKFOhh0rqVB77fyVWubnSH5mW/4xV
         53qz6Hkk9R9LOfV+JTDGjwHpgceNasnpiYEf5B1XGcsuuvMvqyKZf0esoMZ7EtYqn8
         caYj3gQpiMJur2rZzhPGuF7RVS6f4389eSGkII8s=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05U7KAiq091199
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 02:20:10 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 30
 Jun 2020 02:20:09 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 30 Jun 2020 02:20:09 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05U7K7LH027187;
        Tue, 30 Jun 2020 02:20:08 -0500
Subject: Re: [PATCHv4 3/7] crypto: sa2ul: add sha1/sha256/sha512 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <j-keerthy@ti.com>
References: <20200615071452.25141-1-t-kristo@ti.com>
 <20200615071452.25141-4-t-kristo@ti.com>
 <20200626043155.GA2683@gondor.apana.org.au>
 <2a89ea86-3b9e-06b5-fa8e-9dc6e5ad9aeb@ti.com>
 <20200630044936.GA22565@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <b8c209cd-2b5d-54e4-9b64-94e5d1f0e60c@ti.com>
Date:   Tue, 30 Jun 2020 10:20:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630044936.GA22565@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 30/06/2020 07:49, Herbert Xu wrote:
> On Fri, Jun 26, 2020 at 12:15:42PM +0300, Tero Kristo wrote:
>>
>> I have been experimenting with an alternate approach, where I have a small
>> buffer within the context, this would be more like the way other drivers do
>> this. If the buffer is closed before running out of space, I can push this
>> to be processed by HW, otherwise I must fallback to SW. Does this sound like
>> a better approach?
> 
> You can buffer up to a block obviously.  Anything beyond that
> should just use a fallback.

Only up-to block size? This would limit the buffer to 64-128 bytes.

I was hoping I could cache data upto 1024 bytes at least in the context, 
as this would allow running certain openssl cases with hw accelerated 
crypto. Openssl speed test via cryptodev appears to do sha_init - 
sha_update - sha_final chain with any size data.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
