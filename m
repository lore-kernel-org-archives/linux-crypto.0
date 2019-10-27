Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848B8CA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363DC214AF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 13:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="GjF5gmkb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0NFh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 09:05:37 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:20401 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfJ0NFh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 09:05:37 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 471J4C0WRkz9tyWY;
        Sun, 27 Oct 2019 14:05:31 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=GjF5gmkb; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 8ruFRMxT8yho; Sun, 27 Oct 2019 14:05:31 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 471J4B6QyKz9tyWT;
        Sun, 27 Oct 2019 14:05:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1572181530; bh=ZkDwy6Sno2a9AfyEsnf5dSEC4o46Th483Xjb8pRTU5Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GjF5gmkb9JNqlHTR05PuC/vwvHMkaSyR3I4rBl4gj64+QV+wFH/ct9dXr+R8SRAk4
         jHPLGF7GdKPy2n5mSFTHT5xUsPWOUpJrEqGnqa5wwKQ718z4Y0102jnDI3zpZD847m
         02Z+WUOXyJS1tFPtFyRUMA/NIxQh87I8xOcE5htI=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1F3698B93C;
        Sun, 27 Oct 2019 14:05:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id xZi8zKxpblSz; Sun, 27 Oct 2019 14:05:34 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4260E8B938;
        Sun, 27 Oct 2019 14:05:33 +0100 (CET)
Subject: Re: [PATCH v2 24/27] crypto: talitos - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-25-ard.biesheuvel@linaro.org>
 <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
 <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <be890dfd-a1aa-86e1-b1c7-99b72ad137d0@c-s.fr>
Date:   Sun, 27 Oct 2019 14:05:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 27/10/2019 à 12:05, Ard Biesheuvel a écrit :
> On Sun, 27 Oct 2019 at 11:45, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>>
>>
>>
>> Le 24/10/2019 à 15:23, Ard Biesheuvel a écrit :
>>> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
>>> dated 20 august 2015 introduced the new skcipher API which is supposed to
>>> replace both blkcipher and ablkcipher. While all consumers of the API have
>>> been converted long ago, some producers of the ablkcipher remain, forcing
>>> us to keep the ablkcipher support routines alive, along with the matching
>>> code to expose [a]blkciphers via the skcipher API.
>>>
>>> So switch this driver to the skcipher API, allowing us to finally drop the
>>> blkcipher code in the near future.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> With this series, I get the following Oops at boot:
>>
> 
> Thanks for the report.
> 
> Given that the series only modifies ablkcipher implementations, it is
> rather curious that the crash occurs in ahash_init(). Can you confirm
> that the crash does not occur with this patch reverted?

Yes I confirm.

You changed talitos_cra_init_ahash(). talitos_init_common() is not 
called anymore. I think that's the reason.

Christophe

> 
>> [    3.715154] BUG: Kernel NULL pointer dereference at 0x00000084
>> [    3.720721] Faulting instruction address: 0xc0348c9c
>> [    3.725641] Oops: Kernel access of bad area, sig: 11 [#1]
>> [    3.730981] BE PAGE_SIZE=16K PREEMPT CMPC885
>> [    3.735223] CPU: 0 PID: 69 Comm: cryptomgr_test Tainted: G        W
>>         5.4.0-rc4-s3k-dev-00852-ga6dfc2456b41 #2442
>> [    3.745858] NIP:  c0348c9c LR: c021dd88 CTR: c0348c30
>> [    3.750864] REGS: c6303be0 TRAP: 0300   Tainted: G        W
>> (5.4.0-rc4-s3k-dev-00852-ga6dfc2456b41)
>> [    3.760559] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 24002202  XER: 00000000
>> [    3.767192] DAR: 00000084 DSISR: c0000000
>> [    3.767192] GPR00: c021dd88 c6303c98 c61c1e00 c6348800 c7fc1a40
>> 00000830 00000028 c7fc1a82
>> [    3.767192] GPR08: 00000001 00000000 c7f90000 00000004 84002202
>> 00000000 c003b9b8 c62452e0
>> [    3.767192] GPR16: c6339a00 c6348830 c06a7ee8 000000dc c6303d30
>> c6339930 c6348a00 c6303db0
>> [    3.767192] GPR24: 00000010 00000400 c6348c00 c05b13c8 c05d6924
>> c6303cc0 00000000 c6348800
>> [    3.804591] NIP [c0348c9c] ahash_init+0x6c/0x128
>> [    3.809161] LR [c021dd88] do_ahash_op.isra.33+0x24/0x70
>> [    3.814256] Call Trace:
>> [    3.816717] [c6303ca8] [c021dd88] do_ahash_op.isra.33+0x24/0x70
>> [    3.822573] [c6303cb8] [c021ebc8] test_ahash_vec_cfg+0x238/0x5a8
>> [    3.828514] [c6303da8] [c02215c8] __alg_test_hash.isra.38+0x16c/0x334
>> [    3.834879] [c6303e08] [c022180c] alg_test_hash+0x7c/0x164
>> [    3.840299] [c6303e28] [c0222168] alg_test+0xc0/0x384
>> [    3.845288] [c6303ef8] [c021ce40] cryptomgr_test+0x48/0x50
>> [    3.850705] [c6303f08] [c003ba98] kthread+0xe0/0x10c
>> [    3.855619] [c6303f38] [c000e1cc] ret_from_kernel_thread+0x14/0x1c
>> [    3.861675] Instruction dump:
>> [    3.864613] 5484ba74 814afff0 7c7f1b78 314affdf 7cc63110 54c60034
>> 38c60048 3d40c080
>> [    3.872271] 814a8208 90c30078 7c8a2214 54a504be <815e0084> 0f090000
>> 2f8a0000 409e0058
>>
>> Christophe
>>
>>
>>> ---
>>>    drivers/crypto/talitos.c | 306 +++++++++-----------
>>>    1 file changed, 142 insertions(+), 164 deletions(-)
>>>
>>> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
>>> index bcd533671ccc..c29f8c02ea05 100644
>>> --- a/drivers/crypto/talitos.c
>>> +++ b/drivers/crypto/talitos.c
>>> @@ -35,7 +35,7 @@
>>>    #include <crypto/md5.h>
>>>    #include <crypto/internal/aead.h>
>>>    #include <crypto/authenc.h>
>>> -#include <crypto/skcipher.h>
>>> +#include <crypto/internal/skcipher.h>
>>>    #include <crypto/hash.h>
>>>    #include <crypto/internal/hash.h>
>>>    #include <crypto/scatterwalk.h>
>>> @@ -1490,10 +1490,10 @@ static int aead_decrypt(struct aead_request *req)
>>>        return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
>>>    }
>>>
>>> -static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
>>> +static int skcipher_setkey(struct crypto_skcipher *cipher,
>>>                             const u8 *key, unsigned int keylen)
>>>    {
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>>        struct device *dev = ctx->dev;
>>>
>>>        if (ctx->keylen)
>>> @@ -1507,39 +1507,39 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
>>>        return 0;
>>>    }
>>>
>>> -static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
>>> +static int skcipher_des_setkey(struct crypto_skcipher *cipher,
>>>                                 const u8 *key, unsigned int keylen)
>>>    {
>>> -     return verify_ablkcipher_des_key(cipher, key) ?:
>>> -            ablkcipher_setkey(cipher, key, keylen);
>>> +     return verify_skcipher_des_key(cipher, key) ?:
>>> +            skcipher_setkey(cipher, key, keylen);
>>>    }
>>>
>>> -static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
>>> +static int skcipher_des3_setkey(struct crypto_skcipher *cipher,
>>>                                  const u8 *key, unsigned int keylen)
>>>    {
>>> -     return verify_ablkcipher_des3_key(cipher, key) ?:
>>> -            ablkcipher_setkey(cipher, key, keylen);
>>> +     return verify_skcipher_des3_key(cipher, key) ?:
>>> +            skcipher_setkey(cipher, key, keylen);
>>>    }
>>>
>>> -static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
>>> +static int skcipher_aes_setkey(struct crypto_skcipher *cipher,
>>>                                  const u8 *key, unsigned int keylen)
>>>    {
>>>        if (keylen == AES_KEYSIZE_128 || keylen == AES_KEYSIZE_192 ||
>>>            keylen == AES_KEYSIZE_256)
>>> -             return ablkcipher_setkey(cipher, key, keylen);
>>> +             return skcipher_setkey(cipher, key, keylen);
>>>
>>> -     crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>>> +     crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>>>
>>>        return -EINVAL;
>>>    }
>>>
>>>    static void common_nonsnoop_unmap(struct device *dev,
>>>                                  struct talitos_edesc *edesc,
>>> -                               struct ablkcipher_request *areq)
>>> +                               struct skcipher_request *areq)
>>>    {
>>>        unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
>>>
>>> -     talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->nbytes, 0);
>>> +     talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
>>>        unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
>>>
>>>        if (edesc->dma_len)
>>> @@ -1547,20 +1547,20 @@ static void common_nonsnoop_unmap(struct device *dev,
>>>                                 DMA_BIDIRECTIONAL);
>>>    }
>>>
>>> -static void ablkcipher_done(struct device *dev,
>>> +static void skcipher_done(struct device *dev,
>>>                            struct talitos_desc *desc, void *context,
>>>                            int err)
>>>    {
>>> -     struct ablkcipher_request *areq = context;
>>> -     struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> -     unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
>>> +     struct skcipher_request *areq = context;
>>> +     struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>> +     unsigned int ivsize = crypto_skcipher_ivsize(cipher);
>>>        struct talitos_edesc *edesc;
>>>
>>>        edesc = container_of(desc, struct talitos_edesc, desc);
>>>
>>>        common_nonsnoop_unmap(dev, edesc, areq);
>>> -     memcpy(areq->info, ctx->iv, ivsize);
>>> +     memcpy(areq->iv, ctx->iv, ivsize);
>>>
>>>        kfree(edesc);
>>>
>>> @@ -1568,17 +1568,17 @@ static void ablkcipher_done(struct device *dev,
>>>    }
>>>
>>>    static int common_nonsnoop(struct talitos_edesc *edesc,
>>> -                        struct ablkcipher_request *areq,
>>> +                        struct skcipher_request *areq,
>>>                           void (*callback) (struct device *dev,
>>>                                             struct talitos_desc *desc,
>>>                                             void *context, int error))
>>>    {
>>> -     struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> +     struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>>        struct device *dev = ctx->dev;
>>>        struct talitos_desc *desc = &edesc->desc;
>>> -     unsigned int cryptlen = areq->nbytes;
>>> -     unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
>>> +     unsigned int cryptlen = areq->cryptlen;
>>> +     unsigned int ivsize = crypto_skcipher_ivsize(cipher);
>>>        int sg_count, ret;
>>>        bool sync_needed = false;
>>>        struct talitos_private *priv = dev_get_drvdata(dev);
>>> @@ -1638,65 +1638,65 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>>>        return ret;
>>>    }
>>>
>>> -static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
>>> +static struct talitos_edesc *skcipher_edesc_alloc(struct skcipher_request *
>>>                                                    areq, bool encrypt)
>>>    {
>>> -     struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> -     unsigned int ivsize = crypto_ablkcipher_ivsize(cipher);
>>> +     struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>> +     unsigned int ivsize = crypto_skcipher_ivsize(cipher);
>>>
>>>        return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
>>> -                                areq->info, 0, areq->nbytes, 0, ivsize, 0,
>>> +                                areq->iv, 0, areq->cryptlen, 0, ivsize, 0,
>>>                                   areq->base.flags, encrypt);
>>>    }
>>>
>>> -static int ablkcipher_encrypt(struct ablkcipher_request *areq)
>>> +static int skcipher_encrypt(struct skcipher_request *areq)
>>>    {
>>> -     struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> +     struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>>        struct talitos_edesc *edesc;
>>>        unsigned int blocksize =
>>> -                     crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
>>> +                     crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
>>>
>>> -     if (!areq->nbytes)
>>> +     if (!areq->cryptlen)
>>>                return 0;
>>>
>>> -     if (areq->nbytes % blocksize)
>>> +     if (areq->cryptlen % blocksize)
>>>                return -EINVAL;
>>>
>>>        /* allocate extended descriptor */
>>> -     edesc = ablkcipher_edesc_alloc(areq, true);
>>> +     edesc = skcipher_edesc_alloc(areq, true);
>>>        if (IS_ERR(edesc))
>>>                return PTR_ERR(edesc);
>>>
>>>        /* set encrypt */
>>>        edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
>>>
>>> -     return common_nonsnoop(edesc, areq, ablkcipher_done);
>>> +     return common_nonsnoop(edesc, areq, skcipher_done);
>>>    }
>>>
>>> -static int ablkcipher_decrypt(struct ablkcipher_request *areq)
>>> +static int skcipher_decrypt(struct skcipher_request *areq)
>>>    {
>>> -     struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
>>> -     struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
>>> +     struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
>>>        struct talitos_edesc *edesc;
>>>        unsigned int blocksize =
>>> -                     crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
>>> +                     crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
>>>
>>> -     if (!areq->nbytes)
>>> +     if (!areq->cryptlen)
>>>                return 0;
>>>
>>> -     if (areq->nbytes % blocksize)
>>> +     if (areq->cryptlen % blocksize)
>>>                return -EINVAL;
>>>
>>>        /* allocate extended descriptor */
>>> -     edesc = ablkcipher_edesc_alloc(areq, false);
>>> +     edesc = skcipher_edesc_alloc(areq, false);
>>>        if (IS_ERR(edesc))
>>>                return PTR_ERR(edesc);
>>>
>>>        edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
>>>
>>> -     return common_nonsnoop(edesc, areq, ablkcipher_done);
>>> +     return common_nonsnoop(edesc, areq, skcipher_done);
>>>    }
>>>
>>>    static void common_nonsnoop_hash_unmap(struct device *dev,
>>> @@ -2257,7 +2257,7 @@ struct talitos_alg_template {
>>>        u32 type;
>>>        u32 priority;
>>>        union {
>>> -             struct crypto_alg crypto;
>>> +             struct skcipher_alg skcipher;
>>>                struct ahash_alg hash;
>>>                struct aead_alg aead;
>>>        } alg;
>>> @@ -2702,123 +2702,102 @@ static struct talitos_alg_template driver_algs[] = {
>>>                                     DESC_HDR_MODE1_MDEU_PAD |
>>>                                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>>>        },
>>> -     /* ABLKCIPHER algorithms. */
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "ecb(aes)",
>>> -                     .cra_driver_name = "ecb-aes-talitos",
>>> -                     .cra_blocksize = AES_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                  CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = AES_MIN_KEY_SIZE,
>>> -                             .max_keysize = AES_MAX_KEY_SIZE,
>>> -                             .setkey = ablkcipher_aes_setkey,
>>> -                     }
>>> +     /* SKCIPHER algorithms. */
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "ecb(aes)",
>>> +                     .base.cra_driver_name = "ecb-aes-talitos",
>>> +                     .base.cra_blocksize = AES_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = AES_MIN_KEY_SIZE,
>>> +                     .max_keysize = AES_MAX_KEY_SIZE,
>>> +                     .setkey = skcipher_aes_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_AESU,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "cbc(aes)",
>>> -                     .cra_driver_name = "cbc-aes-talitos",
>>> -                     .cra_blocksize = AES_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                     CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = AES_MIN_KEY_SIZE,
>>> -                             .max_keysize = AES_MAX_KEY_SIZE,
>>> -                             .ivsize = AES_BLOCK_SIZE,
>>> -                             .setkey = ablkcipher_aes_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "cbc(aes)",
>>> +                     .base.cra_driver_name = "cbc-aes-talitos",
>>> +                     .base.cra_blocksize = AES_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = AES_MIN_KEY_SIZE,
>>> +                     .max_keysize = AES_MAX_KEY_SIZE,
>>> +                     .ivsize = AES_BLOCK_SIZE,
>>> +                     .setkey = skcipher_aes_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_AESU |
>>>                                     DESC_HDR_MODE0_AESU_CBC,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "ctr(aes)",
>>> -                     .cra_driver_name = "ctr-aes-talitos",
>>> -                     .cra_blocksize = 1,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                  CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = AES_MIN_KEY_SIZE,
>>> -                             .max_keysize = AES_MAX_KEY_SIZE,
>>> -                             .ivsize = AES_BLOCK_SIZE,
>>> -                             .setkey = ablkcipher_aes_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "ctr(aes)",
>>> +                     .base.cra_driver_name = "ctr-aes-talitos",
>>> +                     .base.cra_blocksize = 1,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = AES_MIN_KEY_SIZE,
>>> +                     .max_keysize = AES_MAX_KEY_SIZE,
>>> +                     .ivsize = AES_BLOCK_SIZE,
>>> +                     .setkey = skcipher_aes_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
>>>                                     DESC_HDR_SEL0_AESU |
>>>                                     DESC_HDR_MODE0_AESU_CTR,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "ecb(des)",
>>> -                     .cra_driver_name = "ecb-des-talitos",
>>> -                     .cra_blocksize = DES_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                  CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = DES_KEY_SIZE,
>>> -                             .max_keysize = DES_KEY_SIZE,
>>> -                             .setkey = ablkcipher_des_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "ecb(des)",
>>> +                     .base.cra_driver_name = "ecb-des-talitos",
>>> +                     .base.cra_blocksize = DES_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = DES_KEY_SIZE,
>>> +                     .max_keysize = DES_KEY_SIZE,
>>> +                     .setkey = skcipher_des_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_DEU,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "cbc(des)",
>>> -                     .cra_driver_name = "cbc-des-talitos",
>>> -                     .cra_blocksize = DES_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                  CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = DES_KEY_SIZE,
>>> -                             .max_keysize = DES_KEY_SIZE,
>>> -                             .ivsize = DES_BLOCK_SIZE,
>>> -                             .setkey = ablkcipher_des_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "cbc(des)",
>>> +                     .base.cra_driver_name = "cbc-des-talitos",
>>> +                     .base.cra_blocksize = DES_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = DES_KEY_SIZE,
>>> +                     .max_keysize = DES_KEY_SIZE,
>>> +                     .ivsize = DES_BLOCK_SIZE,
>>> +                     .setkey = skcipher_des_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_DEU |
>>>                                     DESC_HDR_MODE0_DEU_CBC,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "ecb(des3_ede)",
>>> -                     .cra_driver_name = "ecb-3des-talitos",
>>> -                     .cra_blocksize = DES3_EDE_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                  CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = DES3_EDE_KEY_SIZE,
>>> -                             .max_keysize = DES3_EDE_KEY_SIZE,
>>> -                             .setkey = ablkcipher_des3_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "ecb(des3_ede)",
>>> +                     .base.cra_driver_name = "ecb-3des-talitos",
>>> +                     .base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = DES3_EDE_KEY_SIZE,
>>> +                     .max_keysize = DES3_EDE_KEY_SIZE,
>>> +                     .setkey = skcipher_des3_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_DEU |
>>>                                     DESC_HDR_MODE0_DEU_3DES,
>>>        },
>>> -     {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>>> -             .alg.crypto = {
>>> -                     .cra_name = "cbc(des3_ede)",
>>> -                     .cra_driver_name = "cbc-3des-talitos",
>>> -                     .cra_blocksize = DES3_EDE_BLOCK_SIZE,
>>> -                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>>> -                                     CRYPTO_ALG_ASYNC,
>>> -                     .cra_ablkcipher = {
>>> -                             .min_keysize = DES3_EDE_KEY_SIZE,
>>> -                             .max_keysize = DES3_EDE_KEY_SIZE,
>>> -                             .ivsize = DES3_EDE_BLOCK_SIZE,
>>> -                             .setkey = ablkcipher_des3_setkey,
>>> -                     }
>>> +     {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
>>> +             .alg.skcipher = {
>>> +                     .base.cra_name = "cbc(des3_ede)",
>>> +                     .base.cra_driver_name = "cbc-3des-talitos",
>>> +                     .base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>>> +                     .base.cra_flags = CRYPTO_ALG_ASYNC,
>>> +                     .min_keysize = DES3_EDE_KEY_SIZE,
>>> +                     .max_keysize = DES3_EDE_KEY_SIZE,
>>> +                     .ivsize = DES3_EDE_BLOCK_SIZE,
>>> +                     .setkey = skcipher_des3_setkey,
>>>                },
>>>                .desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>>>                                     DESC_HDR_SEL0_DEU |
>>> @@ -3036,40 +3015,39 @@ static int talitos_init_common(struct talitos_ctx *ctx,
>>>        return 0;
>>>    }
>>>
>>> -static int talitos_cra_init(struct crypto_tfm *tfm)
>>> +static int talitos_cra_init_aead(struct crypto_aead *tfm)
>>>    {
>>> -     struct crypto_alg *alg = tfm->__crt_alg;
>>> +     struct aead_alg *alg = crypto_aead_alg(tfm);
>>>        struct talitos_crypto_alg *talitos_alg;
>>> -     struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
>>> +     struct talitos_ctx *ctx = crypto_aead_ctx(tfm);
>>>
>>> -     if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
>>> -             talitos_alg = container_of(__crypto_ahash_alg(alg),
>>> -                                        struct talitos_crypto_alg,
>>> -                                        algt.alg.hash);
>>> -     else
>>> -             talitos_alg = container_of(alg, struct talitos_crypto_alg,
>>> -                                        algt.alg.crypto);
>>> +     talitos_alg = container_of(alg, struct talitos_crypto_alg,
>>> +                                algt.alg.aead);
>>>
>>>        return talitos_init_common(ctx, talitos_alg);
>>>    }
>>>
>>> -static int talitos_cra_init_aead(struct crypto_aead *tfm)
>>> +static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
>>>    {
>>> -     struct aead_alg *alg = crypto_aead_alg(tfm);
>>> +     struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
>>>        struct talitos_crypto_alg *talitos_alg;
>>> -     struct talitos_ctx *ctx = crypto_aead_ctx(tfm);
>>> +     struct talitos_ctx *ctx = crypto_skcipher_ctx(tfm);
>>>
>>>        talitos_alg = container_of(alg, struct talitos_crypto_alg,
>>> -                                algt.alg.aead);
>>> +                                algt.alg.skcipher);
>>>
>>>        return talitos_init_common(ctx, talitos_alg);
>>>    }
>>>
>>>    static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>>>    {
>>> +     struct crypto_alg *alg = tfm->__crt_alg;
>>> +     struct talitos_crypto_alg *talitos_alg;
>>>        struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
>>>
>>> -     talitos_cra_init(tfm);
>>> +     talitos_alg = container_of(__crypto_ahash_alg(alg),
>>> +                                struct talitos_crypto_alg,
>>> +                                algt.alg.hash);
>>>
>>>        ctx->keylen = 0;
>>>        crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
>>> @@ -3116,7 +3094,8 @@ static int talitos_remove(struct platform_device *ofdev)
>>>
>>>        list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
>>>                switch (t_alg->algt.type) {
>>> -             case CRYPTO_ALG_TYPE_ABLKCIPHER:
>>> +             case CRYPTO_ALG_TYPE_SKCIPHER:
>>> +                     crypto_unregister_skcipher(&t_alg->algt.alg.skcipher);
>>>                        break;
>>>                case CRYPTO_ALG_TYPE_AEAD:
>>>                        crypto_unregister_aead(&t_alg->algt.alg.aead);
>>> @@ -3160,15 +3139,14 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
>>>        t_alg->algt = *template;
>>>
>>>        switch (t_alg->algt.type) {
>>> -     case CRYPTO_ALG_TYPE_ABLKCIPHER:
>>> -             alg = &t_alg->algt.alg.crypto;
>>> -             alg->cra_init = talitos_cra_init;
>>> +     case CRYPTO_ALG_TYPE_SKCIPHER:
>>> +             alg = &t_alg->algt.alg.skcipher.base;
>>>                alg->cra_exit = talitos_cra_exit;
>>> -             alg->cra_type = &crypto_ablkcipher_type;
>>> -             alg->cra_ablkcipher.setkey = alg->cra_ablkcipher.setkey ?:
>>> -                                          ablkcipher_setkey;
>>> -             alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
>>> -             alg->cra_ablkcipher.decrypt = ablkcipher_decrypt;
>>> +             t_alg->algt.alg.skcipher.init = talitos_cra_init_skcipher;
>>> +             t_alg->algt.alg.skcipher.setkey =
>>> +                     t_alg->algt.alg.skcipher.setkey ?: skcipher_setkey;
>>> +             t_alg->algt.alg.skcipher.encrypt = skcipher_encrypt;
>>> +             t_alg->algt.alg.skcipher.decrypt = skcipher_decrypt;
>>>                break;
>>>        case CRYPTO_ALG_TYPE_AEAD:
>>>                alg = &t_alg->algt.alg.aead.base;
>>> @@ -3465,10 +3443,10 @@ static int talitos_probe(struct platform_device *ofdev)
>>>                        }
>>>
>>>                        switch (t_alg->algt.type) {
>>> -                     case CRYPTO_ALG_TYPE_ABLKCIPHER:
>>> -                             err = crypto_register_alg(
>>> -                                             &t_alg->algt.alg.crypto);
>>> -                             alg = &t_alg->algt.alg.crypto;
>>> +                     case CRYPTO_ALG_TYPE_SKCIPHER:
>>> +                             err = crypto_register_skcipher(
>>> +                                             &t_alg->algt.alg.skcipher);
>>> +                             alg = &t_alg->algt.alg.skcipher.base;
>>>                                break;
>>>
>>>                        case CRYPTO_ALG_TYPE_AEAD:
>>>
