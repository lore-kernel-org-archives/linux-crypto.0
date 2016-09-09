From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Kernel panic - encryption/decryption failed when open file on Arm64
Date: Fri, 9 Sep 2016 11:56:33 +0100
Message-ID: <CAKv+Gu8w+BuwxQjOtpnFPHnJNUzq7m0K+KJ8=FG2wHigaB54ng@mail.gmail.com>
References: <57D15BD3.40903@huawei.com> <20160908124709.GA26586@gondor.apana.org.au>
 <57D28CB8.4080904@huawei.com> <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        nhorman@tuxdriver.com, mh1@iki.fi,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bintian <bintian.wang@huawei.com>, liushuoran@huawei.com,
        Huxinwei <huxinwei@huawei.com>, zhangzhibin.zhang@huawei.com
To: xiakaixu <xiakaixu@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36018 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbcIIK4e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2016 06:56:34 -0400
Received: by mail-oi0-f46.google.com with SMTP id q188so18443419oia.3
        for <linux-crypto@vger.kernel.org>; Fri, 09 Sep 2016 03:56:34 -0700 (PDT)
In-Reply-To: <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9 September 2016 at 11:31, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 9 September 2016 at 11:19, xiakaixu <xiakaixu@huawei.com> wrote:
>> Hi,
>>
>> After a deeply research about this crash, seems it is a specific
>> bug that only exists in armv8 board. And it occurs in this function
>> in arch/arm64/crypto/aes-glue.c.
>>
>> static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>>                        struct scatterlist *src, unsigned int nbytes)
>> {
>>        ...
>>
>>         desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>>         blkcipher_walk_init(&walk, dst, src, nbytes);
>>         err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE); --->
>> page allocation failed
>>
>>         ...
>>
>>         while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {           ---->
>> walk.nbytes = 0, and skip this loop
>>                 aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>>                                 (u8 *)ctx->key_enc, rounds, blocks, walk.iv,
>>                                 first);
>>         ...
>>                 err = blkcipher_walk_done(desc, &walk,
>>                                           walk.nbytes % AES_BLOCK_SIZE);
>>         }
>>         if (nbytes) {                                                 ---->
>> enter this if() statement
>>                 u8 *tdst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
>>                 u8 *tsrc = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
>>         ...
>>
>>                 aes_ctr_encrypt(tail, tsrc, (u8 *)ctx->key_enc, rounds,
>> ----> the the sencond input parameter is NULL, so crash...
>>                                 blocks, walk.iv, first);
>>         ...
>>         }
>>         ...
>> }
>>
>>
>> If the page allocation failed in the function blkcipher_walk_virt_block(),
>> the variable walk.nbytes = 0, so it will skip the while() loop and enter
>> the if(nbytes) statment. But here the varibale tsrc is NULL and it is also
>> the sencond input parameter of the function aes_ctr_encrypt()... Kernel
>> Panic...
>>
>> I have also researched the similar function in other architectures, and
>> there if(walk.nbytes) is used, not this if(nbytes) statement in the armv8.
>> so I think this armv8 function ctr_encrypt() should deal with the page
>> allocation failed situation.
>>

Does this solve your problem?

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5c888049d061..6b2aa0fd6cd0 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -216,7 +216,7 @@ static int ctr_encrypt(struct blkcipher_desc
*desc, struct scatterlist *dst,
                err = blkcipher_walk_done(desc, &walk,
                                          walk.nbytes % AES_BLOCK_SIZE);
        }
-       if (nbytes) {
+       if (walk.nbytes % AES_BLOCK_SIZE) {
                u8 *tdst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
                u8 *tsrc = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
                u8 __aligned(8) tail[AES_BLOCK_SIZE];
