Return-Path: <SRS0=PDVT=3I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EF8C33CB1
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jan 2020 10:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A600D20730
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jan 2020 10:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=bezdeka.de header.i=@bezdeka.de header.b="VzHlesaj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgASKKH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jan 2020 05:10:07 -0500
Received: from mx1.bezdeka.de ([5.181.50.93]:57924 "EHLO smtp.bezdeka.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbgASKKG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jan 2020 05:10:06 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2020 05:10:04 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bezdeka.de;
         s=mail201812; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4fl9CVcgZHgVZ+M+srvJ0LdSD5TR4orZnbwlr6QXZfQ=; b=VzHlesajHq/ppz4r+asLAK7u+R
        5ElrI6bT53fso0ruXWEtlsafg7khNiylug/K8+L7s9DpT1ttZ15Zr6bkq4TMFGrLDuvK9T66SNcaP
        K1pfhoLwAqB79F1svwKLQuoo+vGPxSwEdlKiGcXgXW82ZlJfm8YaVtptTByN0h1pQXY5dFCUXIH0M
        7TzyaS7qvbTn1z7LgbcGkLrfVT4R+crAVSo+xOHDy8ovhtkxf+H7X1PVU3vNaMU9kpFUX569T7mVJ
        LrY2CF32LEb0kBoTGd9WBQQvFvmuzCWFpilw6M0fLb6JWQ1JRWioDIltE0cyYyZ2Q7JvssN2rYmDN
        42dvI5DA==;
Received: from [2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e]
        by smtp.bezdeka.de with esmtpsa (TLSv1.3:TLS_AES_128_GCM_SHA256:128)
        (Exim 4.92.3)
        (envelope-from <florian@bezdeka.de>)
        id 1it7PC-0000jE-Kd; Sun, 19 Jan 2020 11:02:07 +0100
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
 <20191005122226.23552-1-florian@bezdeka.de>
 <CAKv+Gu8n0p7fab4Uosv09tDGvfmNbQY+2Sw=QrLB1=aJJmwCJg@mail.gmail.com>
From:   Florian Bezdeka <florian@bezdeka.de>
Message-ID: <8b9ced63-00b3-b2af-d554-1f049276b0a6@bezdeka.de>
Date:   Sun, 19 Jan 2020 11:02:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8n0p7fab4Uosv09tDGvfmNbQY+2Sw=QrLB1=aJJmwCJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-User: florian@bezdeka.de
X-Authenticator: plain
X-Exim-Version: 4.92.3 (build at 19-Nov-2019 13:15:30)
X-Date: 2020-01-19 11:02:06
X-Connected-IP: 2a02:810d:82bf:fffc:4b4d:6e34:bfdf:330e:48530
X-Message-Linecount: 227
X-Body-Linecount: 208
X-Message-Size: 8977
X-Body-Size: 8152
X-Received-Count: 1
X-Local-Recipient-Count: 2
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

Greg picked the non-backported version of the v2 patch and merged it into the 
4.9, 4.14 and 4.19 stable trees. The commit of the stable-queue repository [1] 
is [2].

Some days later he noticed that the non-backported version is not working as 
expected (failing the build) and he removed the patch from all affected stable 
trees again. The commit id is [3].

What are the right steps to get the backported version of this patch to the 
stable-queue and afterwards to the stable trees?

Thank you,
Florian

[1] git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
[2] ab6793e0731db6b937c47faf2ad95c5d9ef9ff86
[3] 23e4ec1db5b3ba3fb5cb60aac0b9b84e244e0a10

Am 08.10.19 um 13:36 schrieb Ard Biesheuvel:
> On Sat, 5 Oct 2019 at 14:22, Florian Bezdeka <florian@bezdeka.de> wrote:
>>
>> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
>> the generic CBC template wrapper from a blkcipher to a skcipher algo,
>> to get away from the deprecated blkcipher interface. However, as a side
>> effect, drivers that instantiate CBC transforms using the blkcipher as
>> a fallback no longer work, since skciphers can wrap blkciphers but not
>> the other way around. This broke the geode-aes driver.
>>
>> So let's fix it by moving to the sync skcipher interface when allocating
>> the fallback. At the same time, align with the generic API for ECB and
>> CBC by rejecting inputs that are not a multiple of the AES block size.
>>
>> Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
>> ---
>>
>> Ard, I just followed your instructions and created this patch
>> for usage on an 4.19 kernel. The patch was successfully tested
>> on two different Geode systems.
>>
>> Can you please review again and forward to the stable tree if the patch
>> looks OK?
>>
> 
> The patch looks fine to me, but we cannot send it to -stable before
> the mainline version is merged.
> 
>>  drivers/crypto/geode-aes.c | 57 +++++++++++++++++++++++---------------
>>  drivers/crypto/geode-aes.h |  2 +-
>>  2 files changed, 35 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>> index eb2a0a73cbed..cc33354d13c1 100644
>> --- a/drivers/crypto/geode-aes.c
>> +++ b/drivers/crypto/geode-aes.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/spinlock.h>
>>  #include <crypto/algapi.h>
>>  #include <crypto/aes.h>
>> +#include <crypto/skcipher.h>
>>
>>  #include <linux/io.h>
>>  #include <linux/delay.h>
>> @@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
>>         /*
>>          * The requested key size is not supported by HW, do a fallback
>>          */
>> -       op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>> -       op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
>> +       crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
>> +       crypto_skcipher_set_flags(op->fallback.blk,
>> +                                 tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
>>
>> -       ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
>> +       ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
>>         if (ret) {
>>                 tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
>> -               tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
>> +               tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
>> +                                 CRYPTO_TFM_RES_MASK;
>>         }
>>         return ret;
>>  }
>> @@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
>>                 struct scatterlist *dst, struct scatterlist *src,
>>                 unsigned int nbytes)
>>  {
>> -       unsigned int ret;
>> -       struct crypto_blkcipher *tfm;
>>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
>> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
>>
>> -       tfm = desc->tfm;
>> -       desc->tfm = op->fallback.blk;
>> -
>> -       ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
>> +       skcipher_request_set_tfm(req, op->fallback.blk);
>> +       skcipher_request_set_callback(req, 0, NULL, NULL);
>> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
>>
>> -       desc->tfm = tfm;
>> -       return ret;
>> +       return crypto_skcipher_decrypt(req);
>>  }
>> +
>>  static int fallback_blk_enc(struct blkcipher_desc *desc,
>>                 struct scatterlist *dst, struct scatterlist *src,
>>                 unsigned int nbytes)
>>  {
>> -       unsigned int ret;
>> -       struct crypto_blkcipher *tfm;
>>         struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
>> +       SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
>>
>> -       tfm = desc->tfm;
>> -       desc->tfm = op->fallback.blk;
>> -
>> -       ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
>> +       skcipher_request_set_tfm(req, op->fallback.blk);
>> +       skcipher_request_set_callback(req, 0, NULL, NULL);
>> +       skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
>>
>> -       desc->tfm = tfm;
>> -       return ret;
>> +       return crypto_skcipher_encrypt(req);
>>  }
>>
>>  static void
>> @@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
>>         struct blkcipher_walk walk;
>>         int err, ret;
>>
>> +       if (nbytes % AES_BLOCK_SIZE)
>> +               return -EINVAL;
>> +
>>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>>                 return fallback_blk_dec(desc, dst, src, nbytes);
>>
>> @@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
>>         struct blkcipher_walk walk;
>>         int err, ret;
>>
>> +       if (nbytes % AES_BLOCK_SIZE)
>> +               return -EINVAL;
>> +
>>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>>                 return fallback_blk_enc(desc, dst, src, nbytes);
>>
>> @@ -370,8 +374,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
>>         const char *name = crypto_tfm_alg_name(tfm);
>>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>>
>> -       op->fallback.blk = crypto_alloc_blkcipher(name, 0,
>> -                       CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
>> +       op->fallback.blk = crypto_alloc_skcipher(name, 0,
>> +                                                CRYPTO_ALG_ASYNC |
>> +                                                CRYPTO_ALG_NEED_FALLBACK);
>>
>>         if (IS_ERR(op->fallback.blk)) {
>>                 printk(KERN_ERR "Error allocating fallback algo %s\n", name);
>> @@ -385,7 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
>>  {
>>         struct geode_aes_op *op = crypto_tfm_ctx(tfm);
>>
>> -       crypto_free_blkcipher(op->fallback.blk);
>> +       crypto_free_skcipher(op->fallback.blk);
>>         op->fallback.blk = NULL;
>>  }
>>
>> @@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
>>         struct blkcipher_walk walk;
>>         int err, ret;
>>
>> +       if (nbytes % AES_BLOCK_SIZE)
>> +               return -EINVAL;
>> +
>>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>>                 return fallback_blk_dec(desc, dst, src, nbytes);
>>
>> @@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
>>         struct blkcipher_walk walk;
>>         int err, ret;
>>
>> +       if (nbytes % AES_BLOCK_SIZE)
>> +               return -EINVAL;
>> +
>>         if (unlikely(op->keylen != AES_KEYSIZE_128))
>>                 return fallback_blk_enc(desc, dst, src, nbytes);
>>
>> diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
>> index f442ca972e3c..c5763a041bb8 100644
>> --- a/drivers/crypto/geode-aes.h
>> +++ b/drivers/crypto/geode-aes.h
>> @@ -64,7 +64,7 @@ struct geode_aes_op {
>>         u8 *iv;
>>
>>         union {
>> -               struct crypto_blkcipher *blk;
>> +               struct crypto_skcipher *blk;
>>                 struct crypto_cipher *cip;
>>         } fallback;
>>         u32 keylen;
>> --
>> 2.21.0
>>
