From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 2/2] arm64: add support for AES using ARMv8 Crypto Extensions
Date: Sat, 14 Sep 2013 15:30:45 +0200
Message-ID: <CAKv+Gu9fCaaTVyCt-r-ijpqYDo4LTfvzrorzjWWCYMM17QUOQA@mail.gmail.com>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org>
	<1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org>
	<5234196D.9050101@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-arm@lists.infradead.org, linux-crypto@vger.kernel.org,
	Nicolas Pitre <nico@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steve Capper <steve.capper@arm.com>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64507 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3INNar (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Sep 2013 09:30:47 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so2909544lbh.37
        for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2013 06:30:45 -0700 (PDT)
In-Reply-To: <5234196D.9050101@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14 September 2013 10:08, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> On 13.09.2013 18:08, Ard Biesheuvel wrote:
>> This adds ARMv8 Crypto Extensions based implemenations of
>> AES in CBC, CTR and XTS mode.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
> ..snip..
>> +static int xts_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>> +                    unsigned int key_len)
>> +{
>> +     struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
>> +     u32 *flags = &tfm->crt_flags;
>> +     int ret;
>> +
>> +     ret = crypto_aes_expand_key(&ctx->key1, in_key, key_len/2);
>> +     if (!ret)
>> +             ret = crypto_aes_expand_key(&ctx->key2, &in_key[key_len/2],
>> +                                         key_len/2);
>
> Use checkpatch.
>

Um, I did get a bunch of errors and warnings from checkpatch.pl tbh,
put not in this particular location. Care to elaborate?

>> +     if (!ret)
>> +             return 0;
>> +
>> +     *flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
>> +     return -EINVAL;
>> +}
>> +
>> +static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>> +                    struct scatterlist *src, unsigned int nbytes)
>> +{
>> +     struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
>> +     int err, first, rounds = 6 + ctx->key_length/4;
>> +     struct blkcipher_walk walk;
>> +     unsigned int blocks;
>> +
>> +     blkcipher_walk_init(&walk, dst, src, nbytes);
>> +     err = blkcipher_walk_virt(desc, &walk);
>> +
>> +     kernel_neon_begin();
>
> Is sleeping allowed within kernel_neon_begin/end block? If not, you need to
> clear CRYPTO_TFM_REQ_MAY_SLEEP on desc->flags. Otherwise blkcipher_walk_done
> might sleep.
>

Good point. No, sleeping is not allowed in this case, so I should
clear the flag.

>> +     for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
>> +             aesce_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>> +                               (u8*)ctx->key_enc, rounds, blocks, walk.iv,
>> +                               first);
>> +
>> +             err = blkcipher_walk_done(desc, &walk, blocks * AES_BLOCK_SIZE);
>> +     }
>> +     kernel_neon_end();
>> +
>> +     /* non-integral sizes are not supported in CBC */
>> +     if (unlikely(walk.nbytes))
>> +             err = -EINVAL;
>
> I think blkcipher_walk_done already does this check by comparing against
> alg.cra_blocksize.
>

You're right, it does. I will remove it.

>> +
>> +     return err;
>> +}
> ..snip..
>> +
>> +static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>> +                    struct scatterlist *src, unsigned int nbytes)
>> +{
>> +     struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
>> +     int err, first, rounds = 6 + ctx->key_length/4;
>> +     struct blkcipher_walk walk;
>> +     u8 ctr[AES_BLOCK_SIZE];
>> +
>> +     blkcipher_walk_init(&walk, dst, src, nbytes);
>> +     err = blkcipher_walk_virt(desc, &walk);
>> +
>> +     memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
>> +
>> +     kernel_neon_begin();
>> +     for (first = 1; (nbytes = walk.nbytes); first = 0) {
>> +             aesce_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>> +                               (u8*)ctx->key_enc, rounds, nbytes, ctr, first);
>> +
>> +             err = blkcipher_walk_done(desc, &walk, 0);
>> +
>> +             /* non-integral block *must* be the last one */
>> +             if (unlikely(walk.nbytes && (nbytes & (AES_BLOCK_SIZE-1)))) {
>> +                     err = -EINVAL;
>
> Other CTR implementations do not have this.. not needed?
>

I should be using blkcipher_walk_virt_block() here with a block size
of AES_BLOCK_SIZE. In that case, all calls but the last one will be at
least AES_BLOCK_SIZE long. But that still means I need to take care to
only consume multiples of AES_BLOCK_SIZE in all iterations except the
last one.

>> +                     break;
>> +             }
>> +     }
> ..snip..
>> +static struct crypto_alg aesce_cbc_algs[] = { {
>> +     .cra_name               = "__cbc-aes-aesce",
>> +     .cra_driver_name        = "__driver-cbc-aes-aesce",
>> +     .cra_priority           = 0,
>> +     .cra_flags              = CRYPTO_ALG_TYPE_BLKCIPHER,
>> +     .cra_blocksize          = AES_BLOCK_SIZE,
>> +     .cra_ctxsize            = sizeof(struct crypto_aes_ctx),
>> +     .cra_alignmask          = 0,
>> +     .cra_type               = &crypto_blkcipher_type,
>> +     .cra_module             = THIS_MODULE,
>> +     .cra_u = {
>> +             .blkcipher = {
>> +                     .min_keysize    = AES_MIN_KEY_SIZE,
>> +                     .max_keysize    = AES_MAX_KEY_SIZE,
>> +                     .ivsize         = AES_BLOCK_SIZE,
>> +                     .setkey         = crypto_aes_set_key,
>> +                     .encrypt        = cbc_encrypt,
>> +                     .decrypt        = cbc_decrypt,
>> +             },
>> +     },
>> +}, {
>> +     .cra_name               = "__ctr-aes-aesce",
>> +     .cra_driver_name        = "__driver-ctr-aes-aesce",
>> +     .cra_priority           = 0,
>> +     .cra_flags              = CRYPTO_ALG_TYPE_BLKCIPHER,
>> +     .cra_blocksize          = AES_BLOCK_SIZE,
>
> CTR mode is stream cipher, cra_blocksize must be set to 1.
>
> This should have been picked up by in-kernel run-time tests, check
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS (and CONFIG_CRYPTO_TEST/tcrypt
> module).
>

Well, run-time implies access to hardware :-) As I indicated in the
cover letter, these bits are only compile tested.

[...]

>> +.Lencsteal:
>> +     ldrb            w6, [x1], #1
>> +     ldrb            w7, [x2, #-16]
>> +     strb            w6, [x2, #-16]
>> +     strb            w7, [x2], #1
>> +     subs            x5, x5, #1
>> +     bne             .Lencsteal
>
> Cipher text stealing here is dead-code, since alg.cra_blocksize is set
> to 16 bytes.
>
> Currently other XTS implementations do not have CTS either so this is
> not really needed anyway atm (crypto/xts.c: "sector sizes which are not
> a multiple of 16 bytes are, however currently unsupported").
>

I'll remove it then, if we can't test it anyway.

Cheers,
Ard.
