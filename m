Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEA2C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0F72070D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KbgV8x8z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfF1FbV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:31:21 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36730 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1FbV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:31:21 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S5VBps018069;
        Fri, 28 Jun 2019 00:31:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561699871;
        bh=le/kLOgKWgcGqGCbF2xBtsGaEOEKQgL9XFusz99WkeA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KbgV8x8zXO3WMbmYJmvPxMLaEiyMoy2ybzkc+1Jv7WTvmoVzj5+HXQTezb+hCXIe+
         6knPVYDjuoDzPbD8koQ8egH7OFuyEtoyU5tKIYZc/1TjK9NGhh6Nj70ktM2nT0e921
         vsJcJ6EddDMoXPR9HX/6o3eqRcxYYJxqclayrVa8=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S5VBpb111235
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Jun 2019 00:31:11 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 28
 Jun 2019 00:31:10 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 28 Jun 2019 00:31:10 -0500
Received: from [172.24.191.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S5V77S094198;
        Fri, 28 Jun 2019 00:31:08 -0500
Subject: Re: [RESEND PATCH 00/10] crypto: k3: Add sa2ul driver
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <linux-crypto@vger.kernel.org>, <nm@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628045318.GC673@sol.localdomain>
 <7ca64e49-6e1f-c74e-4d8e-0e08607fe5c5@ti.com>
 <20190628052544.GH673@sol.localdomain>
From:   Keerthy <j-keerthy@ti.com>
Message-ID: <17f6aab0-653f-cdb9-37ed-53d0429e3e5d@ti.com>
Date:   Fri, 28 Jun 2019 11:01:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628052544.GH673@sol.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 28/06/19 10:55 AM, Eric Biggers wrote:
> On Fri, Jun 28, 2019 at 10:44:26AM +0530, keerthy wrote:
>>
>>
>> On 6/28/2019 10:23 AM, Eric Biggers wrote:
>>> Hi Keerthy,
>>>
>>> On Fri, Jun 28, 2019 at 09:57:35AM +0530, Keerthy wrote:
>>>> The series adds Crypto hardware accelerator support for SA2UL.
>>>> SA2UL stands for security accelerator ultra lite.
>>>>
>>>> The Security Accelerator (SA2_UL) subsystem provides hardware
>>>> cryptographic acceleration for the following use cases:
>>>> • Encryption and authentication for secure boot
>>>> • Encryption and authentication of content in applications
>>>>     requiring DRM (digital rights management) and
>>>>     content/asset protection
>>>> The device includes one instantiation of SA2_UL named SA2_UL0
>>>>
>>>> SA2UL needs on tx channel and a pair of rx dma channels.
>>>>
>>>> This series has dependency on UDMA series. Hence is based on top of:
>>>>
>>>> https://patchwork.kernel.org/project/linux-dmaengine/list/?series=114105
>>>>
>>>> The above series adds couple of dmaengine APIs that are used
>>>> by the sa2ul driver. Hence there is a hard dependency on the
>>>> above series.
>>>>
>>>> Resending with linux-crypto list in Cc.
>>>>
>>>> Keerthy (10):
>>>>     dt-bindings: crypto: k3: Add sa2ul bindings documentation
>>>>     crypto: sa2ul: Add crypto driver
>>>>     crypto: sa2ul: Add AES ECB Mode support
>>>>     crypto: sa2ul: Add aead support for hmac(sha1)cbc(aes) algorithm
>>>>     crypto: sha256_generic: Export the Transform function
>>>>     crypto: sa2ul: Add hmac(sha256)cbc(aes) AEAD Algo support
>>>>     crypto: sa2ul: Add hmac(sha1) HMAC algorithm support
>>>>     crypto: sa2ul: Add hmac(sha256) HMAC algorithm support
>>>>     sa2ul: Add 3DES ECB & CBC Mode support
>>>>     arm64: dts: k3-am6: Add crypto accelarator node
>>>>
>>>>    .../devicetree/bindings/crypto/sa2ul.txt      |   47 +
>>>>    arch/arm64/boot/dts/ti/k3-am65-main.dtsi      |   33 +
>>>>    crypto/sha256_generic.c                       |    3 +-
>>>>    drivers/crypto/Kconfig                        |   17 +
>>>>    drivers/crypto/Makefile                       |    1 +
>>>>    drivers/crypto/sa2ul.c                        | 2232 +++++++++++++++++
>>>>    drivers/crypto/sa2ul.h                        |  384 +++
>>>>    include/crypto/sha.h                          |    1 +
>>>>    8 files changed, 2717 insertions(+), 1 deletion(-)
>>>>    create mode 100644 Documentation/devicetree/bindings/crypto/sa2ul.txt
>>>>    create mode 100644 drivers/crypto/sa2ul.c
>>>>    create mode 100644 drivers/crypto/sa2ul.h
>>>
>>> Did you run the crypto self-tests on this driver?  i.e. boot a kernel with
>>>
>>> 	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>>> 	CONFIG_DEBUG_KERNEL=y
>>> 	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>>>
>>> What are the results?
>>
>> Eric,
>>
>> Thanks for your response. I did try with that. All test cases
>> were passing on 4.19 kernel before the testmgr revamp.
>>
> 
> That's surprising, since your driver doesn't implement update() for hashing, so
> it should have been failing at least the HMAC tests.  Are you sure you really
> ran the tests?

Yes partial update was the failing case.

> 
>> Currently few of the test cases do fail. For ex: Appending
>> the last ivlen bytes of cipher text as the IV.
> 
> Well, these need to be fixed.

Okay. So passing all the crypto manager test cases seems to be the 
prerequisite. I will work on them.


> 
>>
>>>
>>> Also, this patchset does not compile for me.
>>
>> This has dependency on UDMA series:
>> https://patchwork.kernel.org/cover/10930969/
> 
> I had that applied.

Okay. I will check if there were additional patches that were needed.

Thanks,
Keerthy

> 
> - Eric
> 
