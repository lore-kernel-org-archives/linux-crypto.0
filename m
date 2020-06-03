Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476FAC433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D96020823
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 12:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="CgVG1p+x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgFCMiV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:38:21 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47400 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFCMiU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 08:38:20 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 053Cc62E108628;
        Wed, 3 Jun 2020 07:38:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591187886;
        bh=6nFAbwpk/+42gTZXi/zpOqibBO6o3fG4PM/MJZ19Xzo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=CgVG1p+xtO90Me2IuCI7bThJKHwftB7AavyMUNAgQmFzMxvkOrmpotsouVwTJmm+e
         NZGGQbWwWdmAt2UGHib3Z1o259jRyl51v7JN5NLxIvUV4jxKoyTIJddbVhwcN3lu6l
         tt59+uIeGQ33n99aWfsxOddAqHrKB125sGQbq+s4=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 053Cc6JK117405
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Jun 2020 07:38:06 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 3 Jun
 2020 07:38:06 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 3 Jun 2020 07:38:06 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 053Cc473063204;
        Wed, 3 Jun 2020 07:38:04 -0500
Subject: Re: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Rob Herring <robh@kernel.org>, <davem@davemloft.net>,
        Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20200511215343.GA10123@bogus>
 <20200514125005.23641-1-t-kristo@ti.com> <20200528152341.GA103581@bogus>
 <a75b48ad-ecc0-89bc-f6a2-7149bc3fefb0@ti.com>
 <20200603122726.GB31719@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <18c28e88-e3a7-2ec4-1d0c-f4d4163aff1c@ti.com>
Date:   Wed, 3 Jun 2020 15:38:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603122726.GB31719@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 03/06/2020 15:27, Herbert Xu wrote:
> On Wed, Jun 03, 2020 at 01:01:26PM +0300, Tero Kristo wrote:
>>
>> Herbert, whats the plan with the rest of the series? Do you want me to
>> re-post it? It shows deferred under crypto patchwork currently.
> 
> Please repost because v3 contains just a single patch.

Also I guess this should be posted against 5.8-rc1 once it is out, as 
merge window is already open. Or are you planning to pick it up for 5.8 
already?

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
