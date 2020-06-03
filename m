Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EBFC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 10:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FF4206A2
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 10:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ncuvrLDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFCKBi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 06:01:38 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57160 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgFCKBi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 06:01:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 053A1Ti9067716;
        Wed, 3 Jun 2020 05:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591178489;
        bh=zag/3BfW8QqOm6F0FyF1A9UYYB3Id4j3qhYuHkejS4Y=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ncuvrLDvysh7HyndbARUFlSy1JDgrwQMnjA6St9jMLClA7Nl7PgvepP0ITFsPJ1rC
         GDw3NaBiOg7aTHsPFWD03tQde452Dvy29gbQ1k3L3IMA9ZzMb5ZauilRuwoYI0N8E4
         gRYN1RqZso14gvLsyaNcfcAJ8neQSrLIj9BjAAdw=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 053A1Th7030560
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Jun 2020 05:01:29 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 3 Jun
 2020 05:01:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 3 Jun 2020 05:01:29 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 053A1RJi014510;
        Wed, 3 Jun 2020 05:01:27 -0500
Subject: Re: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
To:     Rob Herring <robh@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
References: <20200511215343.GA10123@bogus>
 <20200514125005.23641-1-t-kristo@ti.com> <20200528152341.GA103581@bogus>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <a75b48ad-ecc0-89bc-f6a2-7149bc3fefb0@ti.com>
Date:   Wed, 3 Jun 2020 13:01:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528152341.GA103581@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/05/2020 18:23, Rob Herring wrote:
> On Thu, 14 May 2020 15:50:05 +0300, Tero Kristo wrote:
>> From: Keerthy <j-keerthy@ti.com>
>>
>> The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
>> cryptographic acceleration for the following use cases:
>>
>> * Encryption and authentication for secure boot
>> * Encryption and authentication of content in applications
>>    requiring DRM (digital rights management) and
>>    content/asset protection
>>
>> SA2UL provides support for number of different cryptographic algorithms
>> including SHA1, SHA256, SHA512, AES, 3DES, and various combinations of
>> the previous for AEAD use.
>>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> [t-kristo@ti.com: converted documentation to yaml]
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> ---
>> v3:
>>    - fixed a typo in rng child node regex
>>
>>   .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
>>   1 file changed, 76 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
>>
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Thanks Rob,

Herbert, whats the plan with the rest of the series? Do you want me to 
re-post it? It shows deferred under crypto patchwork currently.

-Tero


--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
