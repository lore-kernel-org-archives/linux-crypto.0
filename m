Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73459C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 13:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbiCWNwn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCWNwm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 09:52:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA4657E08D
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 06:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043470;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=tA1IVt/60K43J8wwihKU6A+iwUjOFk4A0+fs4+olMuk=;
        b=Fx4+LDjMY1tyjZdWHBr5Y6DAWYPnbXMwbUeufJF/2jZ/1Pg62cE5+/86jnGVz60oWrlL82
        3syc586QRqX3+kcaUUYPeDaD2AM5mijlNlmL9gMdsOdiV+COWbGTTlynvLoUcItfZnNLUh
        GBtuyZ8BgoA1hxnHuGWeVkB91x+HOyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-P0JLxAKPN0y8XHbUEJhUIQ-1; Wed, 23 Mar 2022 09:51:06 -0400
X-MC-Unique: P0JLxAKPN0y8XHbUEJhUIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63A3585A5BC;
        Wed, 23 Mar 2022 13:51:06 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26A711121314;
        Wed, 23 Mar 2022 13:50:54 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:50:28 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com,
        herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, Lei He <helei.sig11@bytedance.com>
Subject: Re: [PATCH v3 4/6] crypto: Implement RSA algorithm by hogweed
Message-ID: <YjslpEGnzgnExDk+@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-5-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-5-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:10AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Introduce ASN.1 decoder, and implement RSA algorithm by hogweed
> from nettle. Thus QEMU supports a 'real' RSA backend to handle
> request from guest side. It's important to test RSA offload case
> without OS & hardware requirement.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  crypto/akcipher-nettle.c  | 523 ++++++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c         |   3 +
>  crypto/asn1_decoder.c     | 185 ++++++++++++++
>  crypto/asn1_decoder.h     |  42 +++

Please introduce the asn1 files in a separate commit, and also
provide a unit test to validate them in the same commit.

> diff --git a/crypto/akcipher-nettle.c b/crypto/akcipher-nettle.c
> new file mode 100644
> index 0000000000..45b93af772
> --- /dev/null
> +++ b/crypto/akcipher-nettle.c
> @@ -0,0 +1,523 @@
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
> +
> +typedef struct QCryptoNettleRsa {
> +    QCryptoAkcipher akcipher;
> +    struct rsa_public_key pub;
> +    struct rsa_private_key priv;
> +    QCryptoRsaPaddingAlgorithm padding_algo;
> +    QCryptoRsaHashAlgorithm hash_algo;
> +} QCryptoNettleRsa;

Call this QCryptoAkCipherNettleRSA

> +
> +struct asn1_parse_ctx {
> +    const uint8_t *data;
> +    size_t dlen;
> +};
> +
> +#define Octet 8
> +
> +static int extract_value(void *p, const uint8_t *data, size_t dlen)
> +{
> +    struct asn1_parse_ctx *ctx = (struct asn1_parse_ctx *)p;
> +    ctx->data = (uint8_t *)data;
> +    ctx->dlen = dlen;
> +
> +    return 0;
> +}
> +
> +static int extract_mpi(void *p, const uint8_t *data, size_t dlen)
> +{
> +    mpz_t *target = (mpz_t *)p;
> +    nettle_mpz_set_str_256_u(*target, dlen, data);
> +
> +    return 0;
> +}
> +
> +static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void);
> +
> +static void qcrypto_nettle_rsa_destroy(void *ptr)
> +{
> +    QCryptoNettleRsa *rsa = (QCryptoNettleRsa *)ptr;
> +    if (!rsa) {
> +        return;
> +    }
> +
> +    rsa_public_key_clear(&rsa->pub);
> +    rsa_private_key_clear(&rsa->priv);
> +    g_free(rsa);
> +}
> +
> +static QCryptoAkcipher *qcrypto_nettle_new_rsa(
> +    QCryptoAkcipherKeyType type,
> +    const uint8_t *key,  size_t keylen,
> +    QCryptoRsaOptions *opt, Error **errp);
> +
> +QCryptoAkcipher *qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
> +                                             QCryptoAkcipherKeyType type,
> +                                             const uint8_t *key,
> +                                             size_t keylen, void *para,
> +                                             Error **errp)
> +{
> +    switch (alg) {
> +    case QCRYPTO_AKCIPHER_ALG_RSA:
> +        return qcrypto_nettle_new_rsa(type, key, keylen,
> +                                      (QCryptoRsaOptions *)para, errp);
> +    default:
> +        error_setg(errp, "Unsupported algorithm: %u", alg);
> +        return NULL;
> +    }
> +
> +    return NULL;
> +}
> +
> +/**
> + * Parse ber encoded rsa private key, asn1 schema:
> + *        RsaPrivKey ::= SEQUENCE {
> + *             version     INTEGER
> + *             n           INTEGER
> + *             e           INTEGER
> + *             d           INTEGER
> + *             p           INTEGER
> + *             q           INTEGER
> + *             e1          INTEGER
> + *             e2          INTEGER
> + *             u           INTEGER
> + *         }
> + */
> +static int parse_rsa_private_key(QCryptoNettleRsa *rsa,
> +                                 const uint8_t *key, size_t keylen)
> +{
> +    struct asn1_parse_ctx ctx;
> +
> +    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) != 0 ||
> +        keylen != 0) {
> +        return -1;
> +    }
> +
> +    if (ber_decode_int(&ctx.data, &ctx.dlen, NULL, NULL) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.n) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.e) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.d) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.p) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.q) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.a) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.b) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->priv.c) != 0 ||
> +        ctx.dlen != 0) {
> +        return -1;
> +    }
> +
> +    if (!rsa_public_key_prepare(&rsa->pub)) {
> +        return -1;
> +    }
> +
> +    /**
> +     * Since in the kernel's unit test, the p, q, a, b, c of some
> +     * private keys is 0, only the simplest length check is done here
> +     */
> +    rsa->priv.size = rsa->pub.size;
> +
> +    return 0;
> +}
> +
> +/**
> + * Parse ber encoded rsa pubkey, asn1 schema:
> + *        RsaPrivKey ::= SEQUENCE {
> + *             n           INTEGER
> + *             e           INTEGER
> + *         }
> + */
> +static int parse_rsa_public_key(QCryptoNettleRsa *rsa,
> +                                const uint8_t *key,
> +                                size_t keylen)
> +{
> +    struct asn1_parse_ctx ctx;
> +
> +    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) != 0 ||
> +        keylen != 0) {
> +        return -1;
> +    }
> +
> +    if (ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.n) != 0 ||
> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, &rsa->pub.e) != 0 ||
> +        ctx.dlen != 0) {
> +        return -1;
> +    }
> +
> +    if (!rsa_public_key_prepare(&rsa->pub)) {
> +        return -1;
> +    }
> +
> +    return 0;
> +}

I'd like to see these APIs for parsing RSA keys split out into
a separate file, crypto/rsakey.{c,h}.  Define a struct to hold
the RSA key parameters so it isn't tied to nettle, allowing
its potential reuse with a gcrypt/gnutls impl of these APIs

> +
> +static void qcrypto_nettle_rsa_set_akcipher_size(QCryptoAkcipher *akcipher,
> +                                                 int key_size)
> +{
> +    akcipher->max_plaintext_len = key_size;
> +    akcipher->max_ciphertext_len = key_size;
> +    akcipher->max_signature_len = key_size;
> +    akcipher->max_dgst_len = key_size;
> +}
> +
> +static QCryptoAkcipher *qcrypto_nettle_new_rsa(
> +    QCryptoAkcipherKeyType type,
> +    const uint8_t *key, size_t keylen,
> +    QCryptoRsaOptions *opt, Error **errp)
> +{
> +    QCryptoNettleRsa *rsa = qcrypto_nettle_rsa_malloc();
> +    rsa->padding_algo = opt->padding_algo;
> +    rsa->hash_algo = opt->hash_algo;
> +
> +    switch (type) {
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
> +        if (parse_rsa_private_key(rsa, key, keylen) == 0) {
> +            qcrypto_nettle_rsa_set_akcipher_size(
> +                (QCryptoAkcipher *)rsa, rsa->priv.size);
> +            return (QCryptoAkcipher *)rsa;
> +        }
> +        error_setg(errp, "Failed to parse rsa private key");

This code pattern is back to front of what we would normally
do.  ie I'd expect it to look like this:

         if (parse_rsa_private_key(rsa, key, keylen) != 0) {
             error_setg(errp, "Failed to parse rsa private key");
	     goto error;
         }

         qcrypto_nettle_rsa_set_akcipher_size(
                 (QCryptoAkcipher *)rsa, rsa->priv.size);
         return (QCryptoAkcipher *)rsa;



> +        break;
> +
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
> +        if (parse_rsa_public_key(rsa, key, keylen) == 0) {
> +            qcrypto_nettle_rsa_set_akcipher_size(
> +                (QCryptoAkcipher *)rsa, rsa->pub.size);
> +            return (QCryptoAkcipher *)rsa;
> +        }
> +        error_setg(errp, "Failed to parse rsa public rsa key");
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown akcipher key type %d", type);
> +    }
> +
> +    qcrypto_nettle_rsa_destroy(rsa);
> +    return NULL;
> +}
> +
> +
> +/**
> + * nettle does not provide RSA interfaces without padding,
> + * here we implemented rsa algorithm with nettle/mpz.
> + */

Urgh, this is really unpleasant. I don't want to see QEMU
implementing any further crypto algorithms directly, only
ever consume and wrap impls from external libraries. We've
got a few in QEMU for historical reasons, but don't want
to add more. There are too many ways to mess up crypto
opening the door to subtle timing / side channel attacks,
and crypto impls also cause distributors pain with export
compliance rules.

If nettle doesn't provide an impl without padding, then
simply don't implement it. Report an error if the caller
tries to enable it.

An alternate gcrypt impl of these APIs might allow for
an impl without padding.

> +static int _rsa_enc_raw(QCryptoNettleRsa *rsa, const void *data,
> +                        size_t data_len, void *enc,
> +                        size_t enc_len, Error **errp)
> +{
> +    mpz_t m;
> +    int ret;
> +
> +    nettle_mpz_init_set_str_256_u(m, data_len, data);
> +    /* (1) Validate 0 <= m < n */
> +    if (mpz_cmp_ui(m, 0) < 0 || mpz_cmp(m, rsa->pub.n) >= 0) {
> +        error_setg(errp, "Failed to validate input data");
> +        return -1;
> +    }
> +
> +    /* (2) c = m ^ e mod n */
> +    mpz_powm(m, m, rsa->pub.e, rsa->pub.n);
> +    if ((mpz_sizeinbase(m, 2) + Octet - 1) / Octet > enc_len) {
> +        ret = -1;
> +    } else {
> +        ret = enc_len;
> +        nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, m);
> +    }
> +
> +    mpz_clear(m);
> +
> +    return ret;
> +}
> +
> +static int _rsa_dec_raw(QCryptoNettleRsa *rsa,
> +                        const void *enc,
> +                        size_t enc_len,
> +                        void *data,
> +                        size_t data_len,
> +                        Error **errp)
> +{
> +    mpz_t c;
> +    int ret;
> +    nettle_mpz_init_set_str_256_u(c, enc_len, enc);
> +
> +    /* (1) Validate 0 <= c < n */
> +    if (mpz_cmp_ui(c, 0) < 0 || mpz_cmp(c, rsa->pub.n) >= 0) {
> +        error_setg(errp, "Failed to validate input data");
> +        return -1;
> +    }
> +
> +    /* (2) m = c ^ d mod n */
> +    mpz_powm(c, c, rsa->priv.d, rsa->pub.n);
> +    if ((mpz_sizeinbase(c, 2) + Octet - 1) / Octet > data_len) {
> +        ret = -1;
> +    } else {
> +        ret = data_len;
> +        nettle_mpz_get_str_256(data_len, (uint8_t *)data, c);
> +    }
> +
> +    mpz_clear(c);
> +
> +    return ret;
> +}
> +
> +static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t *out)
> +{
> +    /* TODO: check result */
> +    qcrypto_random_bytes(out, len, NULL);
> +}
> +
> +static int qcrypto_nettle_rsa_encrypt(QCryptoAkcipher *akcipher_driver,
> +                                      const void *data, size_t data_len,
> +                                      void *enc, size_t enc_len,
> +                                      Error **errp)
> +{
> +
> +    QCryptoNettleRsa *rsa =
> +        container_of(akcipher_driver, QCryptoNettleRsa, akcipher);
> +    mpz_t c;
> +    int enc_ret;
> +
> +    if (data_len > rsa->pub.size || enc_len != rsa->pub.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return -1;
> +    }
> +
> +    switch (rsa->padding_algo) {
> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
> +        return _rsa_enc_raw(rsa, data, data_len, enc, enc_len, errp);
> +
> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
> +        mpz_init(c);
> +        enc_ret = rsa_encrypt(&rsa->pub, NULL, wrap_nettle_random_func,
> +                              data_len, (uint8_t *)data, c);
> +        if (enc_ret != 1) {
> +            error_setg(errp, "Failed to encrypt");
> +            enc_ret = -1;
> +        } else {
> +            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
> +            enc_ret = enc_len;
> +        }
> +        mpz_clear(c);
> +        return enc_ret;
> +
> +    default:
> +        error_setg(errp, "Unknown padding");
> +        return -1;
> +    }
> +
> +    return -1;
> +}
> +
> +static int qcrypto_nettle_rsa_decrypt(QCryptoAkcipher *akcipher,
> +                                      const void *enc, size_t enc_len,
> +                                      void *data, size_t data_len,
> +                                      Error **errp)
> +{
> +    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
> +    mpz_t c;
> +    int ret;
> +    if (enc_len > rsa->priv.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return -1;
> +    }
> +
> +    switch (rsa->padding_algo) {
> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
> +        ret = _rsa_dec_raw(rsa, enc, enc_len, data, data_len, errp);
> +        break;
> +
> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
> +        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
> +        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) {
> +            error_setg(errp, "Failed to decrypt");
> +            ret = -1;
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
> +static int qcrypto_nettle_rsa_sign(QCryptoAkcipher *akcipher,
> +                                   const void *data, size_t data_len,
> +                                   void *sig, size_t sig_len, Error **errp)
> +{
> +    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
> +    int ret;
> +    mpz_t s;
> +
> +    /**
> +     * The RSA algorithm cannot be used for signature/verification
> +     * without padding.
> +     */
> +    if (rsa->padding_algo == QCRYPTO_RSA_PADDING_ALG_RAW) {
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
> +    switch (rsa->hash_algo) {
> +    case QCRYPTO_RSA_HASH_ALG_MD5:
> +        ret = rsa_md5_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA1:
> +        ret = rsa_sha1_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA256:
> +        ret = rsa_sha256_sign_digest(&rsa->priv, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA512:
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
> +    mpz_clear(s);
> +
> +    return ret;
> +}
> +
> +static int qcrypto_nettle_rsa_verify(QCryptoAkcipher *akcipher,
> +                                     const void *sig, size_t sig_len,
> +                                     const void *data, size_t data_len,
> +                                     Error **errp)
> +{
> +    QCryptoNettleRsa *rsa = container_of(akcipher, QCryptoNettleRsa, akcipher);
> +
> +    int ret;
> +    mpz_t s;
> +
> +    /**
> +     * The RSA algorithm cannot be used for signature/verification
> +     * without padding.
> +     */
> +    if (rsa->padding_algo == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        error_setg(errp, "Operation not supported");
> +        return -1;
> +    }
> +    if (data_len > rsa->pub.size || sig_len < rsa->pub.size) {
> +        error_setg(errp, "Invalid buffer size");
> +        return -1;
> +    }
> +
> +    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
> +    switch (rsa->hash_algo) {
> +    case QCRYPTO_RSA_HASH_ALG_MD5:
> +        ret = rsa_md5_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA1:
> +        ret = rsa_sha1_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA256:
> +        ret = rsa_sha256_verify_digest(&rsa->pub, data, s);
> +        break;
> +
> +    case QCRYPTO_RSA_HASH_ALG_SHA512:
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
> +static int qcrypto_nettle_rsa_free(struct QCryptoAkcipher *akcipher,
> +                                   Error **errp)
> +{
> +    qcrypto_nettle_rsa_destroy(akcipher);
> +    return 0;
> +}
> +
> +QCryptoAkcipherDriver nettle_rsa = {
> +    .encrypt = qcrypto_nettle_rsa_encrypt,
> +    .decrypt = qcrypto_nettle_rsa_decrypt,
> +    .sign = qcrypto_nettle_rsa_sign,
> +    .verify = qcrypto_nettle_rsa_verify,
> +    .free = qcrypto_nettle_rsa_free,
> +};
> +
> +static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void)
> +{
> +    QCryptoNettleRsa *rsa = g_malloc0(sizeof(QCryptoNettleRsa));

s/g_mallo0/g_new0/

> +    memset(rsa, 0, sizeof(QCryptoNettleRsa));

It is already initialized to zero by the allocator above.

> +    rsa->akcipher.driver = &nettle_rsa;
> +    rsa_public_key_init(&rsa->pub);
> +    rsa_private_key_init(&rsa->priv);

I don't think this method should exist at all though. It only
has one caller, so just put the code inline there.

> +
> +    return rsa;
> +}
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index 1e52f2fd76..b5c04e8424 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -31,6 +31,9 @@ QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
>  {
>      QCryptoAkcipher *akcipher = NULL;
>  
> +    akcipher = qcrypto_akcipher_nettle_new(alg, type, key, keylen,
> +                                           para, errp);
> +
>      return akcipher;
>  }

Hard-wiring this to use the nettle impl is not at all desirable. It
needs to use a pluggable approach, with a strong preferance to match
the design of the crypto/cipher.c

>  
> diff --git a/crypto/asn1_decoder.c b/crypto/asn1_decoder.c
> new file mode 100644
> index 0000000000..bfb145e84e
> --- /dev/null
> +++ b/crypto/asn1_decoder.c
> @@ -0,0 +1,185 @@
> +/*
> + * QEMU Crypto akcipher algorithms

This comment is wrong

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
> +#include <stdint.h>
> +#include <stddef.h>
> +
> +#include "crypto/asn1_decoder.h"
> +
> +enum ber_type_tag {
> +    ber_type_tag_bool = 0x1,
> +    ber_type_tag_int = 0x2,
> +    ber_type_tag_bit_str = 0x3,
> +    ber_type_tag_oct_str = 0x4,
> +    ber_type_tag_oct_null = 0x5,
> +    ber_type_tag_oct_oid = 0x6,
> +    ber_type_tag_seq = 0x10,
> +    ber_type_tag_set = 0x11,
> +};
> +
> +#define BER_CONSTRUCTED_MASK 0x20
> +#define BER_SHORT_LEN_MASK 0x80
> +
> +static uint8_t ber_peek_byte(const uint8_t **data, size_t *dlen)
> +{
> +    return **data;
> +}
> +
> +static int invoke_callback(BerDecodeCb cb, void *ctx,
> +                           const uint8_t *value, size_t vlen)
> +{
> +    if (!cb) {
> +        return 0;
> +    }
> +
> +    return cb(ctx, value, vlen);
> +}
> +
> +static void ber_cut_nbytes(const uint8_t **data, size_t *dlen,
> +                           size_t nbytes)
> +{
> +    *data += nbytes;
> +    *dlen -= nbytes;
> +}
> +
> +static uint8_t ber_cut_byte(const uint8_t **data, size_t *dlen)
> +{
> +    uint8_t val = ber_peek_byte(data, dlen);
> +
> +    ber_cut_nbytes(data, dlen, 1);
> +
> +    return val;
> +}
> +
> +static int ber_extract_definite_data(const uint8_t **data, size_t *dlen,
> +                                     BerDecodeCb cb, void *ctx)
> +{
> +    const uint8_t *value;
> +    size_t vlen = 0;
> +    uint8_t byte_count = ber_cut_byte(data, dlen);
> +
> +    /* short format of definite-length */
> +    if (!(byte_count & BER_SHORT_LEN_MASK)) {
> +        if (byte_count > *dlen) {
> +            return -1;
> +        }
> +
> +        value = *data;
> +        vlen = byte_count;
> +        ber_cut_nbytes(data, dlen, vlen);
> +
> +        return invoke_callback(cb, ctx, value, vlen);
> +    }
> +
> +    /* Ignore highest bit */
> +    byte_count &= ~BER_SHORT_LEN_MASK;
> +
> +    /*
> +     * size_t is enough to express the length, although the ber encoding
> +     * standard supports larger length.
> +     */
> +    if (byte_count > sizeof(size_t)) {
> +        return -1;
> +    }
> +
> +    while (byte_count--) {
> +        vlen <<= 8;
> +        vlen += ber_cut_byte(data, dlen);
> +    }
> +
> +    if (vlen > *dlen) {
> +        return -1;
> +    }
> +
> +    value = *data;
> +    ber_cut_nbytes(data, dlen, vlen);
> +
> +    return invoke_callback(cb, ctx, value, vlen);
> +}
> +
> +static int ber_extract_undefinite_data(const uint8_t **data, size_t *dlen,
> +                                       BerDecodeCb cb, void *ctx)
> +{
> +    size_t vlen = 0;
> +    const uint8_t *value;
> +
> +    if (*dlen < 3) {
> +        return -1;
> +    }
> +
> +    /* skip undefinite-length-mask 0x80 */
> +    ber_cut_nbytes(data, dlen, 1);
> +
> +    value = *data;
> +    while (vlen < *dlen) {
> +        if ((*data)[vlen] != 0) {
> +            vlen++;
> +            continue;
> +        }
> +
> +        if (vlen + 1 < *dlen && (*data[vlen + 1] == 0)) {
> +            ber_cut_nbytes(data, dlen, vlen + 2);
> +            return invoke_callback(cb, ctx, value, vlen);
> +        }
> +
> +        vlen += 2;
> +    }
> +
> +    return -1;
> +}
> +
> +static int ber_extract_data(const uint8_t **data, size_t *dlen,
> +                            BerDecodeCb cb, void *ctx)
> +{
> +    uint8_t val = ber_peek_byte(data, dlen);
> +
> +    if (val == BER_SHORT_LEN_MASK) {
> +        return ber_extract_undefinite_data(data, dlen, cb, ctx);
> +    }
> +
> +    return ber_extract_definite_data(data, dlen, cb, ctx);
> +}
> +
> +int ber_decode_int(const uint8_t **data, size_t *dlen,
> +                   BerDecodeCb cb, void *ctx)
> +{
> +    uint8_t tag = ber_cut_byte(data, dlen);
> +
> +    /* INTEGER must encoded in primitive-form */
> +    if (tag != ber_type_tag_int) {
> +        return -1;
> +    }
> +
> +    return ber_extract_data(data, dlen, cb, ctx);
> +}
> +
> +int ber_decode_seq(const uint8_t **data, size_t *dlen,
> +                   BerDecodeCb cb, void *ctx)
> +{
> +    uint8_t val = ber_cut_byte(data, dlen);
> +
> +    /* SEQUENCE must use constructed form */
> +    if (val != (ber_type_tag_seq | BER_CONSTRUCTED_MASK)) {
> +        return -1;
> +    }
> +
> +    return ber_extract_data(data, dlen, cb, ctx);
> +}

Nettle has some asn1 APIs - can we not use those instead of
implementing all it ourselves ?


> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index 03cc3bf46b..2ec7f0f8d7 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -135,5 +135,21 @@ int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
>  
>  int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp);
>  
> +#ifdef CONFIG_HOGWEED
> +QCryptoAkcipher *qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
> +                                             QCryptoAkcipherKeyType type,
> +                                             const uint8_t *key, size_t keylen,
> +                                             void *para, Error **errp);
> +#else
> +static inline QCryptoAkcipher *qcrypto_akcipher_nettle_new(
> +                                             QCryptoAkcipherAlgorithm alg,
> +                                             QCryptoAkcipherKeyType type,
> +                                             const uint8_t *key, size_t keylen,
> +                                             void *para, Error **errp)
> +{
> +    error_setg(errp, "qcrypto akcipher has no nettle/hogweed support");
> +    return NULL;
> +}
> +#endif


These methods are private impl details and should not be in the
akcipher.h public header. This ties back to my earlier comment
about making this akcipher impl pluggable in the same way as
the cipher impl is.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

