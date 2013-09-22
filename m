From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/4] crypto: create generic version of ablk_helper
Date: Sun, 22 Sep 2013 12:22:36 +0200
Message-ID: <9D87C0FB-CCA6-4937-A4F7-0E4D99CC1F44@linaro.org>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org> <1379702811-8025-2-git-send-email-ard.biesheuvel@linaro.org> <523EC0E2.4040307@iki.fi>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:56420 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3IVKWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Sep 2013 06:22:43 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so2070076wes.15
        for <linux-crypto@vger.kernel.org>; Sun, 22 Sep 2013 03:22:42 -0700 (PDT)
In-Reply-To: <523EC0E2.4040307@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> On 22 sep. 2013, at 12:05, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> 
>> On 20.09.2013 21:46, Ard Biesheuvel wrote:
>> Create a generic version of ablk_helper so it can be reused
>> by other architectures.
>> 
>> Acked-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Why resent this patch here when this was in the earlier patchset?
> http://marc.info/?l=linux-crypto-vger&m=137966378813818&w=2
> 

Apologies for the spam.

This second submission was a cross post from linux-arm-kernel because the later patches in the set depend on this one.

Regards,
Ard.

> 
>> ---
>> crypto/Kconfig               |   4 ++
>> crypto/Makefile              |   1 +
>> crypto/ablk_helper.c         | 150 +++++++++++++++++++++++++++++++++++++++++++
>> include/asm-generic/simd.h   |  14 ++++
>> include/crypto/ablk_helper.h |  31 +++++++++
>> 5 files changed, 200 insertions(+)
>> create mode 100644 crypto/ablk_helper.c
>> create mode 100644 include/asm-generic/simd.h
>> create mode 100644 include/crypto/ablk_helper.h
>> 
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index 69ce573..8179ae6 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -179,6 +179,10 @@ config CRYPTO_ABLK_HELPER_X86
>>    depends on X86
>>    select CRYPTO_CRYPTD
>> 
>> +config CRYPTO_ABLK_HELPER
>> +    tristate
>> +    select CRYPTO_CRYPTD
>> +
>> config CRYPTO_GLUE_HELPER_X86
>>    tristate
>>    depends on X86
>> diff --git a/crypto/Makefile b/crypto/Makefile
>> index 80019ba..5e1bdb1 100644
>> --- a/crypto/Makefile
>> +++ b/crypto/Makefile
>> @@ -104,3 +104,4 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
>> obj-$(CONFIG_XOR_BLOCKS) += xor.o
>> obj-$(CONFIG_ASYNC_CORE) += async_tx/
>> obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
>> +obj-$(CONFIG_CRYPTO_ABLK_HELPER) += ablk_helper.o
>> diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
>> new file mode 100644
>> index 0000000..62568b1
>> --- /dev/null
>> +++ b/crypto/ablk_helper.c
>> @@ -0,0 +1,150 @@
>> +/*
>> + * Shared async block cipher helpers
>> + *
>> + * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> + *
>> + * Based on aesni-intel_glue.c by:
>> + *  Copyright (C) 2008, Intel Corp.
>> + *    Author: Huang Ying <ying.huang@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
>> + * USA
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/crypto.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/hardirq.h>
>> +#include <crypto/algapi.h>
>> +#include <crypto/cryptd.h>
>> +#include <crypto/ablk_helper.h>
>> +#include <asm/simd.h>
>> +
>> +int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
>> +         unsigned int key_len)
>> +{
>> +    struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>> +    struct crypto_ablkcipher *child = &ctx->cryptd_tfm->base;
>> +    int err;
>> +
>> +    crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
>> +    crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(tfm)
>> +                    & CRYPTO_TFM_REQ_MASK);
>> +    err = crypto_ablkcipher_setkey(child, key, key_len);
>> +    crypto_ablkcipher_set_flags(tfm, crypto_ablkcipher_get_flags(child)
>> +                    & CRYPTO_TFM_RES_MASK);
>> +    return err;
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_set_key);
>> +
>> +int __ablk_encrypt(struct ablkcipher_request *req)
>> +{
>> +    struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>> +    struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>> +    struct blkcipher_desc desc;
>> +
>> +    desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
>> +    desc.info = req->info;
>> +    desc.flags = 0;
>> +
>> +    return crypto_blkcipher_crt(desc.tfm)->encrypt(
>> +        &desc, req->dst, req->src, req->nbytes);
>> +}
>> +EXPORT_SYMBOL_GPL(__ablk_encrypt);
>> +
>> +int ablk_encrypt(struct ablkcipher_request *req)
>> +{
>> +    struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>> +    struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>> +
>> +    if (!may_use_simd()) {
>> +        struct ablkcipher_request *cryptd_req =
>> +            ablkcipher_request_ctx(req);
>> +
>> +        memcpy(cryptd_req, req, sizeof(*req));
>> +        ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
>> +
>> +        return crypto_ablkcipher_encrypt(cryptd_req);
>> +    } else {
>> +        return __ablk_encrypt(req);
>> +    }
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_encrypt);
>> +
>> +int ablk_decrypt(struct ablkcipher_request *req)
>> +{
>> +    struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
>> +    struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>> +
>> +    if (!may_use_simd()) {
>> +        struct ablkcipher_request *cryptd_req =
>> +            ablkcipher_request_ctx(req);
>> +
>> +        memcpy(cryptd_req, req, sizeof(*req));
>> +        ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
>> +
>> +        return crypto_ablkcipher_decrypt(cryptd_req);
>> +    } else {
>> +        struct blkcipher_desc desc;
>> +
>> +        desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
>> +        desc.info = req->info;
>> +        desc.flags = 0;
>> +
>> +        return crypto_blkcipher_crt(desc.tfm)->decrypt(
>> +            &desc, req->dst, req->src, req->nbytes);
>> +    }
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_decrypt);
>> +
>> +void ablk_exit(struct crypto_tfm *tfm)
>> +{
>> +    struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
>> +
>> +    cryptd_free_ablkcipher(ctx->cryptd_tfm);
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_exit);
>> +
>> +int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
>> +{
>> +    struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
>> +    struct cryptd_ablkcipher *cryptd_tfm;
>> +
>> +    cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
>> +    if (IS_ERR(cryptd_tfm))
>> +        return PTR_ERR(cryptd_tfm);
>> +
>> +    ctx->cryptd_tfm = cryptd_tfm;
>> +    tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
>> +        crypto_ablkcipher_reqsize(&cryptd_tfm->base);
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_init_common);
>> +
>> +int ablk_init(struct crypto_tfm *tfm)
>> +{
>> +    char drv_name[CRYPTO_MAX_ALG_NAME];
>> +
>> +    snprintf(drv_name, sizeof(drv_name), "__driver-%s",
>> +                    crypto_tfm_alg_driver_name(tfm));
>> +
>> +    return ablk_init_common(tfm, drv_name);
>> +}
>> +EXPORT_SYMBOL_GPL(ablk_init);
>> +
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/asm-generic/simd.h b/include/asm-generic/simd.h
>> new file mode 100644
>> index 0000000..f57eb7b
>> --- /dev/null
>> +++ b/include/asm-generic/simd.h
>> @@ -0,0 +1,14 @@
>> +
>> +#include <linux/hardirq.h>
>> +
>> +/*
>> + * may_use_simd - whether it is allowable at this time to issue SIMD
>> + *                instructions or access the SIMD register file
>> + *
>> + * As architectures typically don't preserve the SIMD register file when
>> + * taking an interrupt, !in_interrupt() should be a reasonable default.
>> + */
>> +static __must_check inline bool may_use_simd(void)
>> +{
>> +    return !in_interrupt();
>> +}
>> diff --git a/include/crypto/ablk_helper.h b/include/crypto/ablk_helper.h
>> new file mode 100644
>> index 0000000..4f93df5
>> --- /dev/null
>> +++ b/include/crypto/ablk_helper.h
>> @@ -0,0 +1,31 @@
>> +/*
>> + * Shared async block cipher helpers
>> + */
>> +
>> +#ifndef _CRYPTO_ABLK_HELPER_H
>> +#define _CRYPTO_ABLK_HELPER_H
>> +
>> +#include <linux/crypto.h>
>> +#include <linux/kernel.h>
>> +#include <crypto/cryptd.h>
>> +
>> +struct async_helper_ctx {
>> +    struct cryptd_ablkcipher *cryptd_tfm;
>> +};
>> +
>> +int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
>> +            unsigned int key_len);
>> +
>> +int __ablk_encrypt(struct ablkcipher_request *req);
>> +
>> +int ablk_encrypt(struct ablkcipher_request *req);
>> +
>> +int ablk_decrypt(struct ablkcipher_request *req);
>> +
>> +void ablk_exit(struct crypto_tfm *tfm);
>> +
>> +int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name);
>> +
>> +int ablk_init(struct crypto_tfm *tfm);
>> +
>> +#endif /* _CRYPTO_ABLK_HELPER_H */
>> 
> 
