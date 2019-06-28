Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A07C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5DF2070D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="dDcHXyNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF1FYK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:24:10 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:36334 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1FYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:24:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S5O2IZ033667;
        Fri, 28 Jun 2019 00:24:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561699442;
        bh=mpYlm12k50Y2IG6Z0/YvEbMsQANay4iaP7Ic4q1ygZ4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dDcHXyNc1WQcEbS9lRFb0KSH/YJxf8Lb4OuAfR1+QS5V/TvYMhMnmmg+NoWiLQA+Y
         JqSgRsZ1ebzOMwOJrcxg3kvsKM0O1pvc8thh+lAYLDUcrI0toeqKuj2c0cWWMvpMry
         axprcIPUkMqnONDnm7p0bILfPk8cEwSde6PlaPc0=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S5O2S1050156
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Jun 2019 00:24:02 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 28
 Jun 2019 00:24:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 28 Jun 2019 00:24:02 -0500
Received: from [172.24.191.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S5NwZA082212;
        Fri, 28 Jun 2019 00:23:59 -0500
Subject: Re: [RESEND PATCH 02/10] crypto: sa2ul: Add crypto driver
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <linux-crypto@vger.kernel.org>, <nm@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-3-j-keerthy@ti.com>
 <20190628050756.GD673@sol.localdomain>
From:   Keerthy <j-keerthy@ti.com>
Message-ID: <e86c6c6b-116d-f065-52a4-9b4d2951d100@ti.com>
Date:   Fri, 28 Jun 2019 10:54:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628050756.GD673@sol.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 28/06/19 10:37 AM, Eric Biggers wrote:
> On Fri, Jun 28, 2019 at 09:57:37AM +0530, Keerthy wrote:
>> The Security Accelerator (SA2_UL) subsystem provides hardware
>> cryptographic acceleration for the following use cases:
>> • Encryption and authentication for secure boot
>> • Encryption and authentication of content in applications
>>    requiring DRM (digital rights management) and
>>    content/asset protection
>> The device includes one instantiation of SA2_UL named SA2_UL0
>>
>> SA2_UL supports the following cryptographic industry standards to enable data authentication, data
>> integrity and data confidentiality.
>>
>> Crypto function library for software acceleration
>> o AES operation
>> o 3DES operation
>> o SHA1 operation
>> o MD5 operation
>> o SHA2 – 224, 256, 384, 512 operation
>>
>> Authentication supported via following hardware cores
>> o SHA1
>> o MD5
>> o SHA2 -224
>> o SHA2-256
>> o SHA2-384
>> o SHA2-512
> 
> What about HMAC?
> 
> Your actual driver only exposes HMAC-SHA*, not SHA* anything.
> 
> What does the hardware actually support?

Hardware supports both SHA and HMAC-SHA

> 
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index 603413f28fa3..b9a3fa026c74 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -785,4 +785,21 @@ config CRYPTO_DEV_CCREE
>>   
>>   source "drivers/crypto/hisilicon/Kconfig"
>>   
>> +config CRYPTO_DEV_SA2UL
>> +	tristate "Support for TI security accelerator"
>> +	depends on ARCH_K3 || COMPILE_TEST
>> +	select ARM64_CRYPTO
>> +	select CRYPTO_AES
>> +	select CRYPTO_AES_ARM64
>> +	select CRYPTO_SHA1
>> +	select CRYPTO_MD5
>> +	select CRYPTO_ALGAPI
>> +	select CRYPTO_AUTHENC
>> +	select HW_RANDOM
>> +	default m if ARCH_K3
>> +	help
>> +	  Keystone devices include a security accelerator engine that may be
>> +	  used for crypto offload.  Select this if you want to use hardware
>> +	  acceleration for cryptographic algorithms on these devices.
> 
> This shouldn't be enabled by default.  Note that arm64 defconfig sets ARCH_K3 as
> well as lots of other ARCH_* options, so clearly just because ARCH_K3 is set
> doesn't mean the kernel is being built specifically for your platform.

okay. I will remove that.

> 
>> +/*
>> + * Mode Control Instructions for various Key lengths 128, 192, 256
>> + * For CBC (Cipher Block Chaining) mode for encryption
>> + */
>> +static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
>> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
>> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x4a, 0xaa, 0x4b, 0x7e, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
>> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x8a, 0xaa, 0x4b, 0x7e, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
>> +};
> 
> Use 'const' for static constants.

Okay

> 
>> +static int sa_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
>> +			     unsigned int keylen)
>> +{
>> +	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
> 
> Need to check from error for all memory allocations.
> 
>> +static struct sa_alg_tmpl sa_algs[] = {
>> +	{.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
> 
> ablkcipher API is deprecated.  Use skcipher instead.

Okay

> 
> (To be clear, these are just a few things I happened to notice from very quickly
> skimming through this patch.  I don't have time to do a proper review of random
> drivers.)

I will incorporate the comments in v2.

Thanks for your quick review.

> 
> - Eric
> 
