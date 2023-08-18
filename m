Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF61C7113C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 09:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358935AbjHRJHM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358987AbjHRJHG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 05:07:06 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB24100;
        Fri, 18 Aug 2023 02:07:04 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 37I96ZKE055690;
        Fri, 18 Aug 2023 04:06:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1692349595;
        bh=upWGZ08Ag7ZkIKjE4aoKarr1uV5vkbFFohJdu5uXs3s=;
        h=From:To:CC:Subject:In-Reply-To:References:Date;
        b=MEZFUUAL8lzfFn1grmOljrTXC4qaUMc4GBjop3lqh/SkFkbY8yE1vDXd/ddguSrnK
         1bLQDyP22c5QuksnhKToIvnCd2kAGNtBwTSLzpg/HTxSRnQwgV+vPaeure6avUk6gm
         6QU6l1qwLcAnKKLOtIHFW8sk8d6CLVJENpRq5kDw=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 37I96ZW5106682
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Aug 2023 04:06:35 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 18
 Aug 2023 04:06:35 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 18 Aug 2023 04:06:35 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 37I96Ynp051919;
        Fri, 18 Aug 2023 04:06:35 -0500
From:   Kamlesh Gurudasani <kamlesh@ti.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/6] Add support for Texas Instruments
 MCRC64 engine
In-Reply-To: <20230812030116.GF971@sol.localdomain>
References: <20230719-mcrc-upstream-v2-0-4152b987e4c2@ti.com>
 <20230812030116.GF971@sol.localdomain>
Date:   Fri, 18 Aug 2023 14:36:34 +0530
Message-ID: <87h6owen39.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Fri, Aug 11, 2023 at 12:58:47AM +0530, Kamlesh Gurudasani wrote:
>> Add support for MCRC64 engine to calculate 64-bit CRC in Full-CPU mode
>> 
>> MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
>> according to the ISO 3309 standard.
>> 
>> The ISO 3309 64-bit CRC model parameters are as follows:
>>     Generator Polynomial: x^64 + x^4 + x^3 + x + 1
>>     Polynomial Value: 0x000000000000001B
>>     Initial value: 0x0000000000000000
>>     Reflected Input: False
>>     Reflected Output: False
>>     Xor Final: 0x0000000000000000
>> 
>> Tested with
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>> 
>> and tcrypt,
>> sudo modprobe tcrypt mode=329 sec=1
>> 
>> User space application implemented using algif_hash,
>> https://gist.github.com/ti-kamlesh/73abfcc1a33318bb3b199d36b6209e59
>> 
>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>
> I do not see any in-kernel user of this CRC variant being introduced, which
> leaves algif_hash as the only use case.
>
> Can you elaborate on the benefit this brings to your application?  Yes, it
> allows you to use your hardware CRC engine.  But, that comes with all the
> overhead from the syscalls, algif_hash, and the driver.  How does performance
> compare to a properly optimized software CRC implementation on your platform,
> i.e. an implementation using carryless multiplication instructions (e.g. ARMv8
> CE) if available on your platform, otherwise an implementation using the
> slice-by-8 or slice-by-16 method?
>
> - Eric
Hi Eric,

We are more interested in offload than performance, with splice system
call and DMA mode in driver(will be implemented after this series gets
merged), good amount of cpu cycles will be saved.

There is one more mode(auto mode) in mcrc64 which helps to verify crc64
values against pre calculated crc64, saving the efforts of comparing in
userspace.

Current generic implementation of crc64-iso(part of this series)
gives 173 Mb/s of speed as opposed to mcrc64 which gives speed of 812
Mb/s when tested with tcrypt.

Regard,
Kamlesh

