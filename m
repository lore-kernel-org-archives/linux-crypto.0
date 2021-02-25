Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D3C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 00:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DE464EF1
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 00:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhBYA6K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 19:58:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12997 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbhBYA5w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 19:57:52 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DmDq81WnszjS6b;
        Thu, 25 Feb 2021 08:55:32 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Feb 2021
 08:57:01 +0800
Subject: Re: [PATCH v9 3/7] crypto: move curve_id of ECDH from the key to
 algorithm name
To:     <Tudor.Ambarus@microchip.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <marcel@holtmann.org>,
        <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>
References: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
 <1614064219-40701-4-git-send-email-yumeng18@huawei.com>
 <8b96c136-dca9-5b6a-2221-e906d265c40b@microchip.com>
 <fd3b7c0f-d7f2-3d27-cfef-98ec3614dd1a@huawei.com>
 <e3b4c883-d2f3-0bf0-ffab-42ff5ffe31b8@microchip.com>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <ced696e8-c7f8-d360-5470-9fa8f61e886a@huawei.com>
Date:   Thu, 25 Feb 2021 08:56:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <e3b4c883-d2f3-0bf0-ffab-42ff5ffe31b8@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2021/2/24 18:15, Tudor.Ambarus@microchip.com 写道:
> On 2/24/21 3:29 AM, yumeng wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> 在 2021/2/23 18:44, Tudor.Ambarus@microchip.com 写道:
>>> Hi,
>>>
>>> On 2/23/21 9:10 AM, Meng Yu wrote:
>>>> --- a/drivers/crypto/atmel-ecc.c
>>>> +++ b/drivers/crypto/atmel-ecc.c
>>>> @@ -104,7 +104,7 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
>>>>                   return -EINVAL;
>>>>           }
>>>>
>>>> -       ctx->n_sz = atmel_ecdh_supported_curve(params.curve_id);
>>>> +       ctx->n_sz = atmel_ecdh_supported_curve(ctx->curve_id);
>>>>           if (!ctx->n_sz || params.key_size) {
>>>>                   /* fallback to ecdh software implementation */
>>>>                   ctx->do_fallback = true;
>>>
>>> Now that you moved the curve id info into the alg name, and it is
>>> no longer dynamically discovered when decoding the key, does it
>>> still make sense to keep the curve id, the key size checks, and
>>> the fallback to the software implementation?
>>> I think we can keep the curve id, the key size check if 'atmel-ecc' may
>> support other curves in the future, and if you're sure P256 is the only
>> curve 'atmel-ecc' uses, and it will be changed, we can delete it.
>>
>> And fallback to ecdh software implementation is needed when
>> params.key_size is zero.
>>
> 
> I've read the code again, now I remember. The fallback is needed indeed,
> but for other reason. ecdh-nist-p256 will be handled in the crypto IP
> only when its user provides a zero length private key: we will use a
> pre-provisioned private key that can't be read outside of the device.
> The fallback was needed for ecdh-nist-p256 when the user provides a
> non-zero private key, or for other curve IDs.
> 
> Since the atecc508 and atecc608 (for which there isn't support in kernel
> as of now) both support just NIST Standard P256 Elliptic Curve, and the
> curve id is now unique per alg, the ctx->curve_id handling does no longer
> make sense. So please remove the ctx->curve_id handling. ctx->n_sz can be
> removed too and use instead directly ATMEL_ECC_NIST_P256_N_SIZE, similar
> to how ATMEL_ECC_PUBKEY_SIZE is used.
> 

OK, thanks, I will remove it. But I'd like to wait 2 more days, as maybe 
the owners of other modules (like crypto or bluetooth) have any comments.

thanks.
