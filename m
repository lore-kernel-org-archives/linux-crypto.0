Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF6EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 11:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiDZLzE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiDZLzD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 07:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 391613BBF6
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 04:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650973913;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=12tUVIAFwfMh6wnHJD5zSxycUtnYWvMhnRhi4bvquDc=;
        b=IafKWCra7d50kyq6mMx8IwnKfhQ+uqYI98iG6Bc7eg8ouhimYDk6S4/AT+eI/l3a7zVIWy
        hQJ3ffosLj1c3IDfpO9N6R9YwCJsMQXSkI4ymK8dBAhsAgijlNV18GkJiUrnsetRWe3qFv
        whICkrQi6C9t+FPpghgqadOa+fxifl0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-RnJVFDXOPQ-Bs0-9cHxa_Q-1; Tue, 26 Apr 2022 07:51:47 -0400
X-MC-Unique: RnJVFDXOPQ-Bs0-9cHxa_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5683180418F;
        Tue, 26 Apr 2022 11:51:41 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0BCBC27E8F;
        Tue, 26 Apr 2022 11:51:34 +0000 (UTC)
Date:   Tue, 26 Apr 2022 12:51:31 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v4 5/8] crypto: Implement RSA algorithm by hogweed
Message-ID: <Ymfcw4emMUEW9vdi@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
 <20220411104327.197048-6-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220411104327.197048-6-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 06:43:24PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Implement RSA algorithm by hogweed from nettle. Thus QEMU supports
> a 'real' RSA backend to handle request from guest side. It's
> important to test RSA offload case without OS & hardware requirement.
> 
> Signed-off-by: Lei He <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  crypto/akcipher-nettle.c.inc | 448 +++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c            |   4 +
>  crypto/meson.build           |   4 +
>  crypto/rsakey-builtin.c.inc  | 150 ++++++++++++
>  crypto/rsakey-nettle.c.inc   | 141 +++++++++++
>  crypto/rsakey.c              |  43 ++++
>  crypto/rsakey.h              |  96 ++++++++
>  meson.build                  |  11 +
>  8 files changed, 897 insertions(+)
>  create mode 100644 crypto/akcipher-nettle.c.inc
>  create mode 100644 crypto/rsakey-builtin.c.inc
>  create mode 100644 crypto/rsakey-nettle.c.inc
>  create mode 100644 crypto/rsakey.c
>  create mode 100644 crypto/rsakey.h
> 
> diff --git a/crypto/akcipher-nettle.c.inc b/crypto/akcipher-nettle.c.inc
> new file mode 100644
> index 0000000000..de163cd89e
> --- /dev/null
> +++ b/crypto/akcipher-nettle.c.inc
> @@ -0,0 +1,448 @@
> +/*
> + * QEMU Crypto akcipher algorithms
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: lei he <helei.sig11@bytedance.com>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include <stdbool.h>
> +
> +#include <nettle/rsa.h>
> +
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
> +#include "asn1_decoder.h"
> +#include "crypto/akcipher.h"
> +#include "crypto/random.h"
> +#include "qapi/error.h"
> +#include "sysemu/cryptodev.h"
> +#include "rsakey.h"
> +
> +typedef struct QCryptoNettleRSA {
> +    QCryptoAkCipher akcipher;
> +    struct rsa_public_key pub;
> +    struct rsa_private_key priv;
> +    QCryptoRSAPaddingAlgorithm padding_alg;
> +    QCryptoHashAlgorithm hash_alg;
> +} QCryptoNettleRSA;
> +
> +static void qcrypto_nettle_rsa_destroy(void *ptr)
> +{
> +    QCryptoNettleRSA *rsa = (QCryptoNettleRSA *)ptr;
> +    if (!rsa) {
> +        return;
> +    }
> +
> +    rsa_public_key_clear(&rsa->pub);
> +    rsa_private_key_clear(&rsa->priv);
> +    g_free(rsa);
> +}
> +
> +static QCryptoAkCipher *qcrypto_nettle_rsa_new(
> +    const QCryptoAkCipherOptionsRSA *opt,
> +    QCryptoAkCipherKeyType type,
> +    const uint8_t *key,  size_t keylen,
> +    Error **errp);
> +
> +QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
> +                                      QCryptoAkCipherKeyType type,
> +                                      const uint8_t *key, size_t keylen,
> +                                      Error **errp)
> +{
> +    switch (opts->algorithm) {
> +    case QCRYPTO_AKCIPHER_ALG_RSA:
> +        return qcrypto_nettle_rsa_new(&opts->u.rsa, type, key, keylen, errp);
> +
> +    default:
> +        error_setg(errp, "Unsupported algorithm: %u", opts->algorithm);
> +        return NULL;
> +    }
> +
> +    return NULL;
> +}
> +
> +static void qcrypto_nettle_rsa_set_akcipher_size(QCryptoAkCipher *akcipher,
> +                                                 int key_size)
> +{
> +    akcipher->max_plaintext_len = key_size;
> +    akcipher->max_ciphertext_len = key_size;
> +    akcipher->max_signature_len = key_size;
> +    akcipher->max_dgst_len = key_size;
> +}
> +
> +static int qcrypt_nettle_parse_rsa_private_key(QCryptoNettleRSA *rsa,
> +                                               const uint8_t *key,
> +                                               size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa_key =
> +        qcrypto_akcipher_parse_rsa_private_key(key, keylen);
> +    int ret = -1;
> +    if (!rsa_key) {
> +        return ret;
> +    }
> +
> +    nettle_mpz_init_set_str_256_u(rsa->pub.n, rsa_key->n.len, rsa_key->n.data);
> +    nettle_mpz_init_set_str_256_u(rsa->pub.e, rsa_key->e.len, rsa_key->e.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.d, rsa_key->d.len, rsa_key->d.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.p, rsa_key->p.len, rsa_key->p.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.q, rsa_key->q.len, rsa_key->q.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.a, rsa_key->dp.len,
> +                                  rsa_key->dp.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.b, rsa_key->dq.len,
> +                                  rsa_key->dq.data);
> +    nettle_mpz_init_set_str_256_u(rsa->priv.c, rsa_key->u.len, rsa_key->u.data);
> +
> +    if (!rsa_public_key_prepare(&rsa->pub)) {
> +        goto clear;
> +    }
> +
> +    /**
> +     * Since in the kernel's unit test, the p, q, a, b, c of some
> +     * private keys is 0, only the simplest length check is done here
> +     */
> +    if (rsa_key->p.len > 1 &&
> +        rsa_key->q.len > 1 &&
> +        rsa_key->dp.len > 1 &&
> +        rsa_key->dq.len > 1 &&
> +        rsa_key->u.len > 1) {
> +        if (!rsa_private_key_prepare(&rsa->priv)) {
> +            goto clear;
> +        }
> +    } else {
> +        rsa->priv.size = rsa->pub.size;
> +    }
> +    qcrypto_nettle_rsa_set_akcipher_size(
> +        (QCryptoAkCipher *)rsa, rsa->priv.size);
> +    ret = 0;
> +
> +clear:
> +    qcrypto_akcipher_free_rsa_key(rsa_key);
> +    return ret;
> +}
> +
> +static int qcrypt_nettle_parse_rsa_public_key(QCryptoNettleRSA *rsa,
> +                                              const uint8_t *key,
> +                                              size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa_key =
> +        qcrypto_akcipher_parse_rsa_public_key(key, keylen);
> +    int ret = -1;
> +    if (!rsa_key) {
> +        return ret;
> +    }
> +    nettle_mpz_init_set_str_256_u(rsa->pub.n, rsa_key->n.len, rsa_key->n.data);
> +    nettle_mpz_init_set_str_256_u(rsa->pub.e, rsa_key->e.len, rsa_key->e.data);
> +
> +    if (!rsa_public_key_prepare(&rsa->pub)) {
> +        goto clear;
> +    }
> +    qcrypto_nettle_rsa_set_akcipher_size(
> +        (QCryptoAkCipher *)rsa, rsa->pub.size);
> +    ret = 0;
> +
> +clear:
> +    qcrypto_akcipher_free_rsa_key(rsa_key);
> +    return ret;
> +}
> +
> +static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t *out)
> +{
> +    /* TODO: check result */
> +    qcrypto_random_bytes(out, len, NULL);
> +}
> +
> +static int qcrypto_nettle_rsa_encrypt(QCryptoAkCipher *akcipher_driver,
> +                                      const void *data, size_t data_len,
> +                                      void *enc, size_t enc_len,
> +                                      Error **errp)
> +{
> +
> +    QCryptoNettleRSA *rsa =
> +        container_of(akcipher_driver, QCryptoNettleRSA, akcipher);
> +    mpz_t c;
> +    int ret = -1;
> +
> +    if (data_len > rsa->pub.size || enc_len != rsa->pub.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    /* Nettle do not support RSA encryption without any padding */
> +    switch (rsa->padding_alg) {
> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
> +        error_setg(errp, "RSA with raw padding is not supported");
> +        break;
> +
> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
> +        mpz_init(c);
> +        if (rsa_encrypt(&rsa->pub, NULL, wrap_nettle_random_func,
> +                          data_len, (uint8_t *)data, c) != 1) {
> +            error_setg(errp, "Failed to encrypt");
> +        } else {
> +            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
> +            ret = enc_len;
> +        }
> +        mpz_clear(c);
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown padding");
> +    }
> +
> +    return ret;
> +}
> +
> +static int qcrypto_nettle_rsa_decrypt(QCryptoAkCipher *akcipher,
> +                                      const void *enc, size_t enc_len,
> +                                      void *data, size_t data_len,
> +                                      Error **errp)
> +{
> +    QCryptoNettleRSA *rsa = container_of(akcipher, QCryptoNettleRSA, akcipher);
> +    mpz_t c;
> +    int ret = -1;
> +    if (enc_len > rsa->priv.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    switch (rsa->padding_alg) {
> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
> +        error_setg(errp, "RSA with raw padding is not supported");
> +        break;
> +
> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
> +        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
> +        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) {
> +            error_setg(errp, "Failed to decrypt");
> +        } else {
> +            ret = data_len;
> +        }
> +
> +        mpz_clear(c);
> +        break;
> +
> +    default:
> +        ret = -1;
> +        error_setg(errp, "Unknown padding");
> +    }
> +
> +    return ret;
> +}
> +
> +static int qcrypto_nettle_rsa_sign(QCryptoAkCipher *akcipher,
> +                                   const void *data, size_t data_len,
> +                                   void *sig, size_t sig_len, Error **errp)
> +{
> +    QCryptoNettleRSA *rsa = container_of(akcipher, QCryptoNettleRSA, akcipher);
> +    int ret;
> +    mpz_t s;
> +
> +    /**
> +     * The RSA algorithm cannot be used for signature/verification
> +     * without padding.
> +     */
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        error_setg(errp, "Try to make signature without padding");
> +        return -1;
> +    }
> +
> +    if (data_len > rsa->priv.size || sig_len != rsa->priv.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return -1;
> +    }
> +
> +    mpz_init(s);
> +    switch (rsa->hash_alg) {
> +    case QCRYPTO_HASH_ALG_MD5:
> +        ret = rsa_md5_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA1:
> +        ret = rsa_sha1_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA256:
> +        ret = rsa_sha256_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA512:
> +        ret = rsa_sha512_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown hash algorithm");
> +        ret = -1;
> +        goto clear;
> +    }
> +
> +    if (ret != 1) {
> +        error_setg(errp, "Failed to make signature");
> +        ret = -1;
> +        goto clear;
> +    }
> +    nettle_mpz_get_str_256(sig_len, (uint8_t *)sig, s);
> +    ret = sig_len;
> +
> +clear:

Could you call this 'cleanup' since that's a naming convention
I try to use in crypto code. Basically the two common naming
conventions are:

 'cleanup:' - if both success & failure paths go through it
 'error:'   - if only the failure path goes through it


> +    mpz_clear(s);
> +
> +    return ret;
> +}
> +
> +static int qcrypto_nettle_rsa_verify(QCryptoAkCipher *akcipher,
> +                                     const void *sig, size_t sig_len,
> +                                     const void *data, size_t data_len,
> +                                     Error **errp)
> +{
> +    QCryptoNettleRSA *rsa = container_of(akcipher, QCryptoNettleRSA, akcipher);
> +
> +    int ret;
> +    mpz_t s;
> +
> +    /**
> +     * The RSA algorithm cannot be used for signature/verification
> +     * without padding.
> +     */
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        error_setg(errp, "Operation not supported");
> +        return -1;
> +    }
> +    if (data_len > rsa->pub.size || sig_len < rsa->pub.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return -1;
> +    }
> +
> +    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
> +    switch (rsa->hash_alg) {
> +    case QCRYPTO_HASH_ALG_MD5:
> +        ret = rsa_md5_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA1:
> +        ret = rsa_sha1_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA256:
> +        ret = rsa_sha256_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_HASH_ALG_SHA512:
> +        ret = rsa_sha512_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unsupported hash algorithm");
> +        ret = -1;
> +        goto clear;
> +    }
> +
> +    if (ret != 1) {
> +        error_setg(errp, "Failed to verify");
> +        ret = -1;
> +        goto clear;
> +    }
> +    ret = 0;
> +
> +clear:
> +    mpz_clear(s);
> +
> +    return ret;
> +}
> +
> +static int qcrypto_nettle_rsa_free(QCryptoAkCipher *akcipher,
> +                                   Error **errp)
> +{
> +    qcrypto_nettle_rsa_destroy(akcipher);
> +    return 0;
> +}
> +
> +QCryptoAkCipherDriver nettle_rsa = {
> +    .encrypt = qcrypto_nettle_rsa_encrypt,
> +    .decrypt = qcrypto_nettle_rsa_decrypt,
> +    .sign = qcrypto_nettle_rsa_sign,
> +    .verify = qcrypto_nettle_rsa_verify,
> +    .free = qcrypto_nettle_rsa_free,
> +};
> +
> +static QCryptoAkCipher *qcrypto_nettle_rsa_new(
> +    const QCryptoAkCipherOptionsRSA *opt,
> +    QCryptoAkCipherKeyType type,
> +    const uint8_t *key, size_t keylen,
> +    Error **errp)
> +{
> +    QCryptoNettleRSA *rsa = g_new0(QCryptoNettleRSA, 1);
> +
> +    rsa->padding_alg = opt->padding_alg;
> +    rsa->hash_alg = opt->hash_alg;
> +    rsa->akcipher.driver = &nettle_rsa;
> +    rsa_public_key_init(&rsa->pub);
> +    rsa_private_key_init(&rsa->priv);
> +
> +    switch (type) {
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
> +        if (qcrypt_nettle_parse_rsa_private_key(rsa, key, keylen) != 0) {
> +            error_setg(errp, "Failed to parse rsa private key");
> +            goto err;
> +        }
> +        break;
> +
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
> +        if (qcrypt_nettle_parse_rsa_public_key(rsa, key, keylen) != 0) {
> +            error_setg(errp, "Failed to parse rsa public rsa key");
> +            goto err;
> +        }
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown akcipher key type %d", type);

Here we need 'goto err'

> +    }
> +
> +    return (QCryptoAkCipher *)rsa;
> +
> +err:

Lets call the label 'error' since that's the more common convention
in crypto code.

> +    qcrypto_nettle_rsa_destroy(rsa);
> +    return NULL;
> +}
> +
> +
> +bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
> +{
> +    switch (opts->algorithm) {
> +    case QCRYPTO_AKCIPHER_ALG_RSA:
> +        switch (opts->u.rsa.padding_alg) {
> +        case QCRYPTO_RSA_PADDING_ALG_PKCS1:
> +            switch (opts->u.rsa.hash_alg) {
> +            case QCRYPTO_HASH_ALG_MD5:
> +            case QCRYPTO_HASH_ALG_SHA1:
> +            case QCRYPTO_HASH_ALG_SHA256:
> +            case QCRYPTO_HASH_ALG_SHA512:
> +                return true;
> +
> +            default:
> +                return false;
> +            }
> +
> +        case QCRYPTO_RSA_PADDING_ALG_RAW:
> +        default:
> +            return false;
> +        }
> +        break;
> +
> +    default:
> +        return false;
> +    }
> +}
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index 7323a48073..dc29127bb4 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -23,6 +23,9 @@
>  #include "crypto/akcipher.h"
>  #include "akcipherpriv.h"
>  
> +#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
> +#include "akcipher-nettle.c.inc"
> +#else
>  QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
>                                        QCryptoAkCipherKeyType type,
>                                        const uint8_t *key, size_t keylen,
> @@ -37,6 +40,7 @@ bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
>  {
>      return false;
>  }
> +#endif
>  
>  int qcrypto_akcipher_encrypt(QCryptoAkCipher *akcipher,
>                               const void *in, size_t in_len,
> diff --git a/crypto/meson.build b/crypto/meson.build
> index 57f29d6f74..43a90ef211 100644
> --- a/crypto/meson.build
> +++ b/crypto/meson.build
> @@ -21,10 +21,14 @@ crypto_ss.add(files(
>    'tlscredspsk.c',
>    'tlscredsx509.c',
>    'tlssession.c',
> +  'rsakey.c',
>  ))
>  
>  if nettle.found()
>    crypto_ss.add(nettle, files('hash-nettle.c', 'hmac-nettle.c', 'pbkdf-nettle.c'))
> +  if hogweed.found()
> +    crypto_ss.add(gmp, hogweed)
> +  endif
>    if xts == 'private'
>      crypto_ss.add(files('xts.c'))
>    endif
> diff --git a/crypto/rsakey-builtin.c.inc b/crypto/rsakey-builtin.c.inc
> new file mode 100644
> index 0000000000..d9cdae9e4b
> --- /dev/null
> +++ b/crypto/rsakey-builtin.c.inc
> @@ -0,0 +1,150 @@
> +/*
> + * QEMU Crypto akcipher algorithms
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: lei he <helei.sig11@bytedance.com>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include "rsakey.h"
> +#include "asn1_decoder.h"
> +
> +static int extract_mpi(void *ctx, const uint8_t *value, size_t vlen)
> +{
> +    QCryptoAkCipherMpi *mpi = (QCryptoAkCipherMpi *)ctx;
> +    mpi->data = g_memdup2(value, vlen);
> +    mpi->len = vlen;
> +    return 0;
> +}
> +
> +static int extract_version(void *ctx, const uint8_t *value, size_t vlen)
> +{
> +    uint8_t *version = (uint8_t *)ctx;
> +    if (vlen != 1) {
> +        return -1;
> +    }
> +    if (*value > 1) {
> +        return -1;
> +    }
> +    *version = *value;
> +    return 0;
> +}
> +
> +static int extract_content(void *ctx, const uint8_t *value, size_t vlen)
> +{
> +    const uint8_t **content = (const uint8_t **)ctx;
> +    *content = value;
> +    return 0;
> +}
> +
> +/**
> + *
> + *        RsaPubKey ::= SEQUENCE {
> + *             n           INTEGER
> + *             e           INTEGER
> + *         }
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_public_key(const uint8_t *key,
> +                                                             size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
> +    const uint8_t *seq;
> +    size_t seq_length;
> +    int decode_ret;
> +
> +    decode_ret = der_decode_seq(&key, &keylen, extract_content, &seq);
> +    if (decode_ret <= 0 || keylen != 0) {
> +        goto err;
> +    }
> +    seq_length = decode_ret;
> +
> +    if (der_decode_int(&seq, &seq_length, extract_mpi, &rsa->n) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->e) <= 0 ||
> +        seq_length != 0) {
> +        goto err;
> +    }
> +
> +    return rsa;
> +
> +err:
> +    qcrypto_akcipher_free_rsa_key(rsa);
> +    return NULL;
> +}
> +
> +/**
> + *        RsaPrivKey ::= SEQUENCE {
> + *             version     INTEGER
> + *             n           INTEGER
> + *             e           INTEGER
> + *             d           INTEGER
> + *             p           INTEGER
> + *             q           INTEGER
> + *             dp          INTEGER
> + *             dq          INTEGER
> + *             u           INTEGER
> + *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
> + *         }
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_private_key(
> +    const uint8_t *key, size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
> +    uint8_t version;
> +    const uint8_t *seq;
> +    int decode_ret;
> +    size_t seq_length;
> +
> +    decode_ret = der_decode_seq(&key, &keylen, extract_content, &seq);
> +    if (decode_ret <= 0 || keylen != 0) {
> +        goto err;
> +    }
> +    seq_length = decode_ret;
> +
> +    if (der_decode_int(&seq, &seq_length,
> +                       extract_version, &version) != sizeof(version) ||
> +        version > 1) {
> +        goto err;
> +    }
> +    if (der_decode_int(&seq, &seq_length, extract_mpi, &rsa->n) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->e) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->d) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->p) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->q) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->dp) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->dq) <= 0 ||
> +        der_decode_int(&seq, &seq_length, extract_mpi, &rsa->u) <= 0) {
> +        goto err;
> +    }
> +    /**
> +     * According to the standard, otherPrimeInfos must be present for version 1.
> +     * There is no strict verification here, this is to be compatible with
> +     * the unit test of the kernel. TODO: remove this until linux kernel's
> +     * unit-test is fixed.
> +     */
> +    if (version == 1 && seq_length != 0) {
> +        if (der_decode_seq(&seq, &seq_length, NULL, NULL) <= 0) {
> +            goto err;
> +        }
> +    }
> +    if (seq_length != 0) {
> +        goto err;
> +    }
> +    return rsa;
> +
> +err:
> +    qcrypto_akcipher_free_rsa_key(rsa);
> +    return NULL;
> +}
> diff --git a/crypto/rsakey-nettle.c.inc b/crypto/rsakey-nettle.c.inc
> new file mode 100644
> index 0000000000..3516eba69f
> --- /dev/null
> +++ b/crypto/rsakey-nettle.c.inc
> @@ -0,0 +1,141 @@
> +/*
> + * QEMU Crypto akcipher algorithms
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: lei he <helei.sig11@bytedance.com>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include <nettle/asn1.h>
> +#include <stdbool.h>
 
No need for stdbool.h, provided you include qemu/osdep.h

> +
> +#include "rsakey.h"
> +
> +static bool DumpMpi(struct asn1_der_iterator *i, QCryptoAkCipherMpi *mpi)
> +{
> +    mpi->data = g_memdup2(i->data, i->length);
> +    mpi->len = i->length;
> +    return true;
> +}
> +
> +static bool GetMpi(struct asn1_der_iterator *i, QCryptoAkCipherMpi *mpi)
> +{
> +    if (asn1_der_iterator_next(i) != ASN1_ITERATOR_PRIMITIVE ||
> +        i->type != ASN1_INTEGER) {
> +        return false;
> +    }
> +    return DumpMpi(i, mpi);
> +}
> +
> +
> +/**
> + *        RsaPrivKey ::= SEQUENCE {
> + *             version     INTEGER
> + *             n           INTEGER
> + *             e           INTEGER
> + *             d           INTEGER
> + *             p           INTEGER
> + *             q           INTEGER
> + *             dp          INTEGER
> + *             dq          INTEGER
> + *             u           INTEGER
> + *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
> + *         }
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_private_key(
> +    const uint8_t *key, size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
> +    struct asn1_der_iterator i;
> +    uint32_t version;
> +    int tag;
> +
> +    /* Parse entire struct */
> +    if (asn1_der_iterator_first(&i, keylen, key) != ASN1_ITERATOR_CONSTRUCTED
> +        || i.type != ASN1_SEQUENCE
> +        || asn1_der_decode_constructed_last(&i) != ASN1_ITERATOR_PRIMITIVE
> +        || i.type != ASN1_INTEGER
> +        || !asn1_der_get_uint32(&i, &version)
> +        || version > 1
> +        || !GetMpi(&i, &rsa->n)
> +        || !GetMpi(&i, &rsa->e)
> +        || !GetMpi(&i, &rsa->d)
> +        || !GetMpi(&i, &rsa->p)
> +        || !GetMpi(&i, &rsa->q)
> +        || !GetMpi(&i, &rsa->dp)
> +        || !GetMpi(&i, &rsa->dq)
> +        || !GetMpi(&i, &rsa->u)) {
> +        goto err;
> +    }

The common QEMU code style is to have the '||' at the end of the previous
line, rather than start of the following line.


> +
> +    if (version == 1) {
> +        tag = asn1_der_iterator_next(&i);
> +        /**
> +         * According to the standard otherPrimeInfos must be present for
> +         * version 1. There is no strict verification here, this is to be
> +         * compatible with the unit test of the kernel. TODO: remove this
> +         * until linux-kernel's unit-test is fixed;
> +         */
> +        if (tag == ASN1_ITERATOR_END) {
> +            return rsa;
> +        }
> +        if (tag != ASN1_ITERATOR_CONSTRUCTED ||
> +            i.type != ASN1_SEQUENCE) {
> +                goto err;
> +        }
> +    }
> +
> +    if (asn1_der_iterator_next(&i) != ASN1_ITERATOR_END) {
> +        goto err;
> +    }
> +
> +    return rsa;
> +
> +    /* fallthrough to err */
> +err:
> +    qcrypto_akcipher_free_rsa_key(rsa);
> +    return NULL;
> +}
> +
> +/**
> + *
> + *        RsaPubKey ::= SEQUENCE {
> + *             n           INTEGER
> + *             e           INTEGER
> + *         }
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_public_key(
> +    const uint8_t *key, size_t keylen)
> +{
> +
> +    QCryptoAkCipherRSAKey *rsa = g_new0(QCryptoAkCipherRSAKey, 1);
> +    struct asn1_der_iterator i;
> +
> +    if (asn1_der_iterator_first(&i, keylen, key) != ASN1_ITERATOR_CONSTRUCTED
> +        || i.type != ASN1_SEQUENCE
> +        || asn1_der_decode_constructed_last(&i) != ASN1_ITERATOR_PRIMITIVE
> +        || !DumpMpi(&i, &rsa->n)
> +        || !GetMpi(&i, &rsa->e)
> +        || asn1_der_iterator_next(&i) != ASN1_ITERATOR_END) {
> +        goto err;
> +    }
> +
> +    return rsa;
> +
> +err:
> +    qcrypto_akcipher_free_rsa_key(rsa);
> +    return NULL;
> +}
> diff --git a/crypto/rsakey.c b/crypto/rsakey.c
> new file mode 100644
> index 0000000000..24704f6b9e
> --- /dev/null
> +++ b/crypto/rsakey.c
> @@ -0,0 +1,43 @@
> +/*
> + * QEMU Crypto RSA key parser
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: lei he <helei.sig11@bytedance.com>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#include "rsakey.h"
> +
> +void qcrypto_akcipher_free_rsa_key(QCryptoAkCipherRSAKey *rsa_key)
> +{
> +    if (!rsa_key) {
> +        return;
> +    }
> +    g_free(rsa_key->n.data);
> +    g_free(rsa_key->e.data);
> +    g_free(rsa_key->d.data);
> +    g_free(rsa_key->p.data);
> +    g_free(rsa_key->q.data);
> +    g_free(rsa_key->dp.data);
> +    g_free(rsa_key->dq.data);
> +    g_free(rsa_key->u.data);
> +}
> +
> +#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
> +#include "rsakey-nettle.c.inc"
> +#else
> +#include "rsakey-builtin.c.inc"
> +#endif
> diff --git a/crypto/rsakey.h b/crypto/rsakey.h
> new file mode 100644
> index 0000000000..6345b2222f
> --- /dev/null
> +++ b/crypto/rsakey.h
> @@ -0,0 +1,96 @@
> +/*
> + * QEMU Crypto RSA key parser
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: lei he <helei.sig11@bytedance.com>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#ifndef QCRYPTO_RSAKEY_H
> +#define QCRYPTO_RSAKEY_H
> +
> +#include <nettle/bignum.h>
> +
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
> +#include "crypto/akcipher.h"
> +
> +typedef struct QCryptoAkCipherRSAKey QCryptoAkCipherRSAKey;
> +typedef struct QCryptoAkCipherMpi QCryptoAkCipherMpi;

For an abbreviation like Mpi, we should use capitals eg

  typedef struct QCryptoAkCipherMPI QCryptoAkCipherMPI;
  
> +
> +/**
> + * Multiple precious integer, encoded as two' complement,
> + * copied directly from DER encoded ASN.1 structures.
> + */
> +struct QCryptoAkCipherMpi {
> +    uint8_t *data;
> +    size_t len;
> +};
> +
> +/* See rfc2437: https://datatracker.ietf.org/doc/html/rfc2437 */
> +struct QCryptoAkCipherRSAKey {
> +    /* The modulus */
> +    QCryptoAkCipherMpi n;
> +    /* The public exponent */
> +    QCryptoAkCipherMpi e;
> +    /* The private exponent */
> +    QCryptoAkCipherMpi d;
> +    /* The first factor */
> +    QCryptoAkCipherMpi p;
> +    /* The second factor */
> +    QCryptoAkCipherMpi q;
> +    /* The first factor's exponent */
> +    QCryptoAkCipherMpi dp;
> +    /* The second factor's exponent */
> +    QCryptoAkCipherMpi dq;
> +    /* The CRT coefficient */
> +    QCryptoAkCipherMpi u;
> +};
> +
> +/**
> + * Parse DER encoded ASN.1 RSA private key, expected ASN.1 schema:
> + *        RsaPrivKey ::= SEQUENCE {
> + *             version     INTEGER
> + *             n           INTEGER
> + *             e           INTEGER
> + *             d           INTEGER
> + *             p           INTEGER
> + *             q           INTEGER
> + *             dp          INTEGER
> + *             dq          INTEGER
> + *             u           INTEGER
> + *         }
> + *
> + * Return: On success QCryptoAkCipherRSAKey is returned, otherwise returns NULL
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_private_key(
> +    const uint8_t *key, size_t keylen);
> +/**
> + * Parse DER encoded ASN.1 RSA public key, expected ASN.1 schema:
> + *        RsaPubKey ::= SEQUENCE {
> + *             n           INTEGER
> + *             e           INTEGER
> + *         }
> + *
> + * Return: On success QCryptoAkCipherRSAKey is returned, otherwise returns NULL
> + */
> +QCryptoAkCipherRSAKey *qcrypto_akcipher_parse_rsa_public_key(
> +    const uint8_t *key, size_t keylen);

We could just have one method using QCryptoAkCipherKeyType as a param eg

     qcrypto_akcipher_rsakey_parse(QCryptoAkCipherKeyType type,
                                   const uint8_t *key, size_t keylen);

> +void qcrypto_akcipher_free_rsa_key(QCryptoAkCipherRSAKey *key);

Could you call this one  qcrypto_akcipher_rsakey_free 

Add add g_autoptr support using:

  G_DEFINE_AUTOPTR_CLEANUP_FUNC(QCryptoAkCipherRSAKey, qcrypto_akcipher_rsakey_free)


> +
> +#endif

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

