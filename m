Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0F1C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 11:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiDZL56 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239701AbiDZL55 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 07:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A116271A3E
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 04:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650974088;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=lWy3+iBM0hzkxkmaGclysQSSiY/cztGYE8k6lXFQn0M=;
        b=a/91zpdeW/s5cBbF2vcJaPRcyunZ4AKfp9a7nrO9IfFhz2MxJlhlixzYIoEP6pIut8gygG
        VH/UBLvRf09UBVYSuK7O4chbmfmbdE7NXKbUOjNhImL61HX7ApSO+DDzPs4R4ZiZYW9Fag
        sb9SAypS5gXWJn+0x8EWCv+zhqhRcYQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-ne1IrrZKOQCTl2iF6DKK8w-1; Tue, 26 Apr 2022 07:54:45 -0400
X-MC-Unique: ne1IrrZKOQCTl2iF6DKK8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9F9B3C10ABF;
        Tue, 26 Apr 2022 11:54:44 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0632EC28132;
        Tue, 26 Apr 2022 11:54:41 +0000 (UTC)
Date:   Tue, 26 Apr 2022 12:54:39 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v4 6/8] crypto: Implement RSA algorithm by gcrypt
Message-ID: <Ymfdf1ylxuE88+sI@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
 <20220411104327.197048-7-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220411104327.197048-7-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 06:43:25PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Added gcryt implementation of RSA algorithm, RSA algorithm
> implemented by gcrypt has a higher priority than nettle because
> it supports raw padding.
> 
> Signed-off-by: Lei He <helei.sig11@bytedance.com>
> ---
>  crypto/akcipher-gcrypt.c.inc | 531 +++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c            |   4 +-
>  2 files changed, 534 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/akcipher-gcrypt.c.inc
> 
> diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
> new file mode 100644
> index 0000000000..c109bf0566
> --- /dev/null
> +++ b/crypto/akcipher-gcrypt.c.inc
> @@ -0,0 +1,531 @@
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
> +#include <gcrypt.h>
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
> +typedef struct QCryptoGcryptRSA {
> +    QCryptoAkCipher akcipher;
> +    gcry_sexp_t key;
> +    QCryptoRSAPaddingAlgorithm padding_alg;
> +    QCryptoHashAlgorithm hash_alg;
> +} QCryptoGcryptRSA;
> +
> +static void qcrypto_gcrypt_rsa_destroy(QCryptoGcryptRSA *rsa)
> +{
> +    if (!rsa) {
> +        return;
> +    }
> +
> +    gcry_sexp_release(rsa->key);
> +    g_free(rsa);
> +}
> +
> +static QCryptoGcryptRSA *qcrypto_gcrypt_rsa_new(
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
> +        return (QCryptoAkCipher *)qcrypto_gcrypt_rsa_new(
> +            &opts->u.rsa, type, key, keylen, errp);
> +
> +    default:
> +        error_setg(errp, "Unsupported algorithm: %u", opts->algorithm);
> +        return NULL;
> +    }
> +
> +    return NULL;
> +}
> +
> +static void qcrypto_gcrypt_set_rsa_size(QCryptoAkCipher *akcipher, gcry_mpi_t n)
> +{
> +    size_t key_size = (gcry_mpi_get_nbits(n) + 7) / 8;
> +    akcipher->max_plaintext_len = key_size;
> +    akcipher->max_ciphertext_len = key_size;
> +    akcipher->max_dgst_len = key_size;
> +    akcipher->max_signature_len = key_size;
> +}
> +
> +static int qcrypto_gcrypt_parse_rsa_private_key(
> +    QCryptoGcryptRSA *rsa,
> +    const uint8_t *key, size_t keylen)
> +{
> +    QCryptoAkCipherRSAKey *rsa_key =
> +        qcrypto_akcipher_parse_rsa_private_key(key, keylen);

With my earlier suggestion, you can use

  g_autoptr(QCryptoAkCipherRSAKey) rsa_key = ...

and avoid need for the later  qcrypto_akcipher_free_rsa_key calls.

> +    gcry_mpi_t n = NULL, e = NULL, d = NULL, p = NULL, q = NULL, u = NULL;
> +    int ret = -1;
> +    bool compute_mul_inv = false;
> +    gcry_error_t err;
> +    if (!rsa_key) {
> +        return ret;
> +    }
> +
> +    err = gcry_mpi_scan(&n, GCRYMPI_FMT_STD,
> +                        rsa_key->n.data, rsa_key->n.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_mpi_scan(&e, GCRYMPI_FMT_STD,
> +                        rsa_key->e.data, rsa_key->e.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_mpi_scan(&d, GCRYMPI_FMT_STD,
> +                        rsa_key->d.data, rsa_key->d.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_mpi_scan(&p, GCRYMPI_FMT_STD,
> +                        rsa_key->p.data, rsa_key->p.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_mpi_scan(&q, GCRYMPI_FMT_STD,
> +                        rsa_key->q.data, rsa_key->q.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    if (gcry_mpi_cmp_ui(p, 0) > 0 && gcry_mpi_cmp_ui(q, 0) > 0) {
> +        compute_mul_inv = true;
> +
> +        u = gcry_mpi_new(0);
> +        if (gcry_mpi_cmp(p, q) > 0) {
> +            gcry_mpi_swap(p, q);
> +        }
> +        gcry_mpi_invm(u, p, q);
> +    }
> +
> +    if (compute_mul_inv) {
> +        err = gcry_sexp_build(&rsa->key, NULL,
> +            "(private-key (rsa (n %m) (e %m) (d %m) (p %m) (q %m) (u %m)))",
> +            n, e, d, p, q, u);
> +    } else {
> +        err = gcry_sexp_build(&rsa->key, NULL,
> +            "(private-key (rsa (n %m) (e %m) (d %m)))", n, e, d);
> +    }
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +    qcrypto_gcrypt_set_rsa_size((QCryptoAkCipher *)rsa,  n);
> +    ret = 0;
> +
> +clear:

Same note about using either 'cleanup' or 'error' depending on whether
this is for both successs+failure paths, or just failure path. This
case is a fit for 'cleanup'.

> +    qcrypto_akcipher_free_rsa_key(rsa_key);
> +    gcry_mpi_release(n);
> +    gcry_mpi_release(e);
> +    gcry_mpi_release(d);
> +    gcry_mpi_release(p);
> +    gcry_mpi_release(q);
> +    gcry_mpi_release(u);
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_parse_rsa_public_key(QCryptoGcryptRSA *rsa,
> +                                               const uint8_t *key,
> +                                               size_t keylen)
> +{
> +
> +    QCryptoAkCipherRSAKey *rsa_key =
> +        qcrypto_akcipher_parse_rsa_public_key(key, keylen);
> +    gcry_mpi_t n = NULL, e = NULL;
> +    int ret = -1;
> +    gcry_error_t err;
> +    if (!rsa_key) {
> +        return ret;
> +    }
> +
> +    err = gcry_mpi_scan(&n, GCRYMPI_FMT_STD,
> +                        rsa_key->n.data, rsa_key->n.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_mpi_scan(&e, GCRYMPI_FMT_STD,
> +                        rsa_key->e.data, rsa_key->e.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_sexp_build(&rsa->key, NULL,
> +                          "(public-key (rsa (n %m) (e %m)))", n, e);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +    qcrypto_gcrypt_set_rsa_size((QCryptoAkCipher *)rsa, n);
> +    ret = 0;
> +
> +clear:
> +    qcrypto_akcipher_free_rsa_key(rsa_key);
> +    gcry_mpi_release(n);
> +    gcry_mpi_release(e);
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_rsa_encrypt(QCryptoAkCipher *akcipher,
> +                                      const void *in, size_t in_len,
> +                                      void *out, size_t out_len,
> +                                      Error **errp)
> +{
> +    QCryptoGcryptRSA *rsa =
> +        container_of(akcipher, QCryptoGcryptRSA, akcipher);
> +    int ret = -1;
> +    gcry_sexp_t data_sexp = NULL, cipher_sexp = NULL;
> +    gcry_sexp_t cipher_sexp_item = NULL;
> +    gcry_mpi_t cipher_mpi = NULL;
> +    const char *result;
> +    gcry_error_t err;
> +    size_t actual_len;
> +
> +    if (in_len > akcipher->max_plaintext_len) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    err = gcry_sexp_build(&data_sexp, NULL,
> +                          "(data (flags %s) (value %b))",
> +                          QCryptoRSAPaddingAlgorithm_str(rsa->padding_alg),
> +                          in_len, in);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_pk_encrypt(&cipher_sexp, data_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    /* S-expression of cipher: (enc-val (rsa (a a-mpi))) */
> +    cipher_sexp_item = gcry_sexp_find_token(cipher_sexp, "a", 0);
> +    if (!cipher_sexp_item || gcry_sexp_length(cipher_sexp_item) != 2) {
> +        goto clear;
> +    }
> +
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        cipher_mpi = gcry_sexp_nth_mpi(cipher_sexp_item, 1, GCRYMPI_FMT_USG);
> +        if (!cipher_mpi) {
> +            goto clear;
> +        }
> +        err = gcry_mpi_print(GCRYMPI_FMT_USG, out, out_len,
> +                             &actual_len, cipher_mpi);
> +        if (gcry_err_code(err) != 0 || actual_len > out_len) {
> +            goto clear;
> +        }
> +
> +        /* We always padding leading-zeros for RSA-RAW */
> +        if (actual_len < out_len) {
> +            memmove((uint8_t *)out + (out_len - actual_len), out, actual_len);
> +            memset(out, 0, out_len - actual_len);
> +        }
> +        ret = out_len;
> +
> +    } else {
> +        result = gcry_sexp_nth_data(cipher_sexp_item, 1, &actual_len);
> +        if (!result || actual_len > out_len) {
> +            goto clear;
> +        }
> +        memcpy(out, result, actual_len);
> +        ret = actual_len;
> +    }
> +
> +clear:
> +    gcry_sexp_release(data_sexp);
> +    gcry_sexp_release(cipher_sexp);
> +    gcry_sexp_release(cipher_sexp_item);
> +    gcry_mpi_release(cipher_mpi);
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_rsa_decrypt(QCryptoAkCipher *akcipher,
> +                                      const void *in, size_t in_len,
> +                                      void *out, size_t out_len,
> +                                      Error **errp)
> +{
> +    QCryptoGcryptRSA *rsa =
> +        container_of(akcipher, QCryptoGcryptRSA, akcipher);
> +    int ret = -1;
> +    gcry_sexp_t data_sexp = NULL, cipher_sexp = NULL;
> +    gcry_mpi_t data_mpi = NULL;
> +    gcry_error_t err;
> +    size_t actual_len;
> +    const char *result;
> +
> +    if (in_len > akcipher->max_ciphertext_len) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    err = gcry_sexp_build(&cipher_sexp, NULL,
> +                          "(enc-val (flags %s) (rsa (a %b) ))",
> +                          QCryptoRSAPaddingAlgorithm_str(rsa->padding_alg),
> +                          in_len, in);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_pk_decrypt(&data_sexp, cipher_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    /* S-expression of cipher: (value plaintext) */
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        data_mpi = gcry_sexp_nth_mpi(data_sexp, 1, GCRYMPI_FMT_USG);
> +        if (!data_mpi) {
> +            goto clear;
> +        }
> +        err = gcry_mpi_print(GCRYMPI_FMT_USG, out, out_len,
> +                             &actual_len, data_mpi);
> +        if (gcry_err_code(err) != 0) {
> +            goto clear;
> +        }
> +         if (actual_len > out_len) {
> +            goto clear;
> +        }
> +        /* We always padding leading-zeros for RSA-RAW */
> +        if (actual_len < out_len) {
> +            memmove((uint8_t *)out + (out_len - actual_len), out, actual_len);
> +            memset(out, 0, out_len - actual_len);
> +        }
> +        ret = out_len;
> +    } else {
> +        result = gcry_sexp_nth_data(data_sexp, 1, &actual_len);
> +        if (!result || actual_len > out_len) {
> +            goto clear;
> +        }
> +        memcpy(out, result, actual_len);
> +        ret = actual_len;
> +    }
> +
> +clear:
> +    gcry_sexp_release(cipher_sexp);
> +    gcry_sexp_release(data_sexp);
> +    gcry_mpi_release(data_mpi);
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_rsa_sign(QCryptoAkCipher *akcipher,
> +                                   const void *in, size_t in_len,
> +                                   void *out, size_t out_len, Error **errp)
> +{
> +    QCryptoGcryptRSA *rsa =
> +        container_of(akcipher, QCryptoGcryptRSA, akcipher);
> +    int ret = -1;
> +    gcry_sexp_t dgst_sexp = NULL, sig_sexp = NULL;
> +    gcry_sexp_t sig_sexp_item = NULL;
> +    const char *result;
> +    gcry_error_t err;
> +    size_t actual_len;
> +
> +    if (in_len > akcipher->max_dgst_len) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    if (rsa->padding_alg != QCRYPTO_RSA_PADDING_ALG_PKCS1) {
> +        return ret;
> +    }
> +    err = gcry_sexp_build(&dgst_sexp, NULL,
> +                          "(data (flags pkcs1) (hash %s %b))",
> +                          QCryptoHashAlgorithm_str(rsa->hash_alg),
> +                          in_len, in);
> +
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_pk_sign(&sig_sexp, dgst_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    /* S-expression of signature: (sig-val (rsa (s s-mpi))) */
> +    sig_sexp_item = gcry_sexp_find_token(sig_sexp, "s", 0);
> +    if (!sig_sexp_item || gcry_sexp_length(sig_sexp_item) != 2) {
> +        goto clear;
> +    }
> +
> +    result = gcry_sexp_nth_data(sig_sexp_item, 1, &actual_len);
> +    if (!result || actual_len > out_len) {
> +        goto clear;
> +     }
> +    memcpy(out, result, actual_len);
> +    ret = actual_len;
> +
> +clear:
> +    gcry_sexp_release(dgst_sexp);
> +    gcry_sexp_release(sig_sexp);
> +    gcry_sexp_release(sig_sexp_item);
> +
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_rsa_verify(QCryptoAkCipher *akcipher,
> +                                     const void *in, size_t in_len,
> +                                     const void *in2, size_t in2_len,
> +                                     Error **errp)
> +{
> +    QCryptoGcryptRSA *rsa =
> +        container_of(akcipher, QCryptoGcryptRSA, akcipher);
> +    int ret = -1;
> +    gcry_sexp_t sig_sexp = NULL, dgst_sexp = NULL;
> +    gcry_error_t err;
> +
> +    if (in_len > akcipher->max_signature_len ||
> +        in2_len > akcipher->max_dgst_len) {
> +        error_setg(errp, "Invalid buffer size");
> +        return ret;
> +    }
> +
> +    if (rsa->padding_alg != QCRYPTO_RSA_PADDING_ALG_PKCS1) {
> +        error_setg(errp, "Invalid padding %u", rsa->padding_alg);
> +        return ret;
> +    }
> +
> +    err = gcry_sexp_build(&sig_sexp, NULL,
> +                          "(sig-val (rsa (s %b)))", in_len, in);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_sexp_build(&dgst_sexp, NULL,
> +                          "(data (flags pkcs1) (hash %s %b))",
> +                          QCryptoHashAlgorithm_str(rsa->hash_alg),
> +                          in2_len, in2);
> +    if (gcry_err_code(err) != 0) {
> +        goto clear;
> +    }
> +
> +    err = gcry_pk_verify(sig_sexp, dgst_sexp, rsa->key);
> +    if (gcry_err_code(err) == 0) {
> +        ret = 0;
> +    }
> +
> +clear:
> +    gcry_sexp_release(dgst_sexp);
> +    gcry_sexp_release(sig_sexp);
> +
> +    return ret;
> +}
> +
> +static int qcrypto_gcrypt_rsa_free(QCryptoAkCipher *akcipher,
> +                                   Error **errp)
> +{
> +    qcrypto_gcrypt_rsa_destroy((QCryptoGcryptRSA *)akcipher);
> +    return 0;
> +}
> +
> +QCryptoAkCipherDriver gcrypt_rsa = {
> +    .encrypt = qcrypto_gcrypt_rsa_encrypt,
> +    .decrypt = qcrypto_gcrypt_rsa_decrypt,
> +    .sign = qcrypto_gcrypt_rsa_sign,
> +    .verify = qcrypto_gcrypt_rsa_verify,
> +    .free = qcrypto_gcrypt_rsa_free,
> +};
> +
> +static QCryptoGcryptRSA *qcrypto_gcrypt_rsa_new(
> +    const QCryptoAkCipherOptionsRSA *opt,
> +    QCryptoAkCipherKeyType type,
> +    const uint8_t *key, size_t keylen,
> +    Error **errp)
> +{
> +    QCryptoGcryptRSA *rsa = g_new0(QCryptoGcryptRSA, 1);
> +    rsa->padding_alg = opt->padding_alg;
> +    rsa->hash_alg = opt->hash_alg;
> +    rsa->akcipher.driver = &gcrypt_rsa;
> +
> +    switch (type) {
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
> +        if (qcrypto_gcrypt_parse_rsa_private_key(rsa, key, keylen) != 0) {
> +            error_setg(errp, "Failed to parse rsa private key");
> +            goto err;
> +        }
> +        break;
> +
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
> +        if (qcrypto_gcrypt_parse_rsa_public_key(rsa, key, keylen) != 0) {
> +            error_setg(errp, "Failed to parse rsa public rsa key");
> +            goto err;
> +        }
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown akcipher key type %d", type);

'goto err' here

> +    }
> +
> +    return rsa;
> +
> +err:
> +    qcrypto_gcrypt_rsa_destroy(rsa);
> +    return NULL;
> +}
> +
> +

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

