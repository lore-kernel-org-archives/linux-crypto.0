From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix XTS-AES support on a version 5 CCP
Date: Fri, 21 Jul 2017 10:48:30 -0500
Message-ID: <93dffe62-1a53-e118-8d09-152cc9379245@amd.com>
References: <150032210775.102848.1585950131204303137.stgit@sosxen.amd.com>
 <14a02623-b19e-b4ae-c078-57912a83cd4b@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:42136
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754682AbdGUPtF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:49:05 -0400
In-Reply-To: <14a02623-b19e-b4ae-c078-57912a83cd4b@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/17/2017 04:48 PM, Lendacky, Thomas wrote:
> On 7/17/2017 3:08 PM, Gary R Hook wrote:
>> Version 5 CCPs have differing requirements for XTS-AES: key components
>> are stored in a 512-bit vector. The context must be little-endian
>> justified. AES-256 is supported now, so propagate the cipher size to
>> the command descriptor.
>>
>> Signed-off-by: Gary R Hook <gary.hook@amd.com>


Look for a version 2

>> ---
>>   drivers/crypto/ccp/ccp-crypto-aes-xts.c |   79 ++++++++++++++++---------------
>>   drivers/crypto/ccp/ccp-dev-v5.c         |    2 +
>>   drivers/crypto/ccp/ccp-dev.h            |    2 +
>>   drivers/crypto/ccp/ccp-ops.c            |   56 ++++++++++++++++++----
>>   4 files changed, 89 insertions(+), 50 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
>> index 58a4244b4752..8d248b198e22 100644
>> --- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
>> +++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
>> @@ -1,7 +1,7 @@
>>   /*
>>    * AMD Cryptographic Coprocessor (CCP) AES XTS crypto API support
>>    *
>> - * Copyright (C) 2013 Advanced Micro Devices, Inc.
>> + * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
>>    *
>>    * Author: Tom Lendacky <thomas.lendacky@amd.com>
>>    *
>> @@ -37,46 +37,26 @@ struct ccp_unit_size_map {
>>        u32 value;
>>   };
>>
>> -static struct ccp_unit_size_map unit_size_map[] = {
>> +static struct ccp_unit_size_map xts_unit_sizes[] = {
>>        {
>> -             .size   = 4096,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE_4096,
>> -     },
>> -     {
>> -             .size   = 2048,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE_2048,
>> -     },
>> -     {
>> -             .size   = 1024,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE_1024,
>> +             .size   = 16,
>> +             .value  = CCP_XTS_AES_UNIT_SIZE_16,
>>        },
>>        {
>> -             .size   = 512,
>> +             .size   = 512,
>>                .value  = CCP_XTS_AES_UNIT_SIZE_512,
>>        },
>>        {
>> -             .size   = 256,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE__LAST,
>> -     },
>> -     {
>> -             .size   = 128,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE__LAST,
>> -     },
>> -     {
>> -             .size   = 64,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE__LAST,
>> -     },
>> -     {
>> -             .size   = 32,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE__LAST,
>> +             .size   = 1024,
>> +             .value  = CCP_XTS_AES_UNIT_SIZE_1024,
>>        },
>>        {
>> -             .size   = 16,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE_16,
>> +             .size   = 2048,
>> +             .value  = CCP_XTS_AES_UNIT_SIZE_2048,
>>        },
>>        {
>> -             .size   = 1,
>> -             .value  = CCP_XTS_AES_UNIT_SIZE__LAST,
>> +             .size   = 4096,
>> +             .value  = CCP_XTS_AES_UNIT_SIZE_4096,
>>        },
>>   };
>
> Because of the way the unit size check is performed, you can't delete
> the intermediate size checks.  Those must remain so that unit sizes
> that aren't supported by the CCP are sent to the fallback mechanism.

Given the limitations of the CCP (w.r.t. XTS-AES) I thought it more 
clear to look
for only those unit-sizes that are supported, and to use the enumerated 
value
as the index.

> Also, re-arranging the order should be a separate patch if that doesn't
> really fix anything.

Yes, agreed.

>>
>> @@ -97,14 +77,20 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
>>                              unsigned int key_len)
>>   {
>>        struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
>> +     unsigned int ccpversion = ccp_version();
>>
>>        /* Only support 128-bit AES key with a 128-bit Tweak key,
>>         * otherwise use the fallback
>>         */
>> +
>
> Remove the addition of the blank line and update the above comment to
> indicate the new supported key size added below.

Yes.

>
>>        switch (key_len) {
>>        case AES_KEYSIZE_128 * 2:
>>                memcpy(ctx->u.aes.key, key, key_len);
>>                break;
>> +     case AES_KEYSIZE_256 * 2:
>> +             if (ccpversion > CCP_VERSION(3, 0))
>> +                     memcpy(ctx->u.aes.key, key, key_len);
>> +             break;
>
> Isn't u.aes.key defined with a maximum buffer size of AES_MAX_KEY_SIZE
> (which is 32)?  I think this will cause a buffer overrun on memcpy.

Yes, the structure member needs to be made larger.

>
>>        }
>>        ctx->u.aes.key_len = key_len / 2;
>>        sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
>> @@ -117,7 +103,10 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
>>   {
>>        struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
>>        struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
>> +     unsigned int ccpversion = ccp_version();
>> +     unsigned int fallback = 0;
>>        unsigned int unit;
>> +     u32 block_size = 0;
>>        u32 unit_size;
>>        int ret;
>>
>> @@ -131,17 +120,29 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
>>                return -EINVAL;
>>
>>        unit_size = CCP_XTS_AES_UNIT_SIZE__LAST;
>> -     if (req->nbytes <= unit_size_map[0].size) {
>
> This check can't be deleted.  It was added specifically to catch cases
> where the size was greater than 4096.

My version two approach will address this.

>
>> -             for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++) {
>> -                     if (!(req->nbytes & (unit_size_map[unit].size - 1))) {
>> -                             unit_size = unit_size_map[unit].value;
>> -                             break;
>> -                     }
>> +     for (unit = ARRAY_SIZE(xts_unit_sizes); unit-- > 0; ) {
>> +             if (!(req->nbytes & (xts_unit_sizes[unit].size - 1))) {
>> +                     unit_size = unit;
>> +                     block_size = xts_unit_sizes[unit].size;
>> +                     break;
>>                }
>>        }
>>
>> -     if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
>> -         (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
>> +     /* The CCP has restrictions on block sizes. Also, a version 3 device
>> +      * only supports AES-128 operations; version 5 CCPs support both
>> +      * AES-128 and -256 operations.
>> +      */
>> +     if (unit_size == CCP_XTS_AES_UNIT_SIZE__LAST)
>> +             fallback = 1;
>> +     if ((ccpversion < CCP_VERSION(5, 0)) &&
>> +         (ctx->u.aes.key_len != AES_KEYSIZE_128))
>> +             fallback = 1;
>> +     if ((ctx->u.aes.key_len != AES_KEYSIZE_128) &&
>> +         (ctx->u.aes.key_len != AES_KEYSIZE_256))
>> +             fallback = 1;
>> +     if (req->nbytes != block_size)
>> +             fallback = 1;
>
> I don't believe this is correct.  Everything should fall out properly
> for fallback based on the unit size and key size checks above.

The changes for a version 5 device require additional checks. Also the 
next patch
version will correct/clarify the logic by which I arrive at the fallback 
choice.
