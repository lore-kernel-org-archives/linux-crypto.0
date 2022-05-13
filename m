Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F77BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 11:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353968AbiEMLA0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 07:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiEMLA0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 07:00:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C9442A18BC
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 04:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652439623;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=zZrIwMPrV7aXvgErdC7nm1yxiW6pvUg//LfsRRdQwLg=;
        b=fAeaQ5SKCAfKAuY6g7t720ZtI4FPTZSji1UKb56Xi6/yG0bzYi1ApV/4jzptbfAMeEda58
        WVclEd5kPNRCytrg4qDGYp1+B43ZYEPpgSA4bEkrttSU8gzkbAFX1BeJW7RM8pnItCC9zl
        6LSv8SBRR5L3QwR5FwjWIlfoTn9OjEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-1_GVJnRXNgqngVUMXaBjYQ-1; Fri, 13 May 2022 07:00:20 -0400
X-MC-Unique: 1_GVJnRXNgqngVUMXaBjYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06708811E76;
        Fri, 13 May 2022 11:00:20 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C26438EDA;
        Fri, 13 May 2022 11:00:18 +0000 (UTC)
Date:   Fri, 13 May 2022 12:00:16 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v5 6/9] crypto: Implement RSA algorithm by gcrypt
Message-ID: <Yn46QCP2XzF0S28i@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-7-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220428135943.178254-7-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 28, 2022 at 09:59:40PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Added gcryt implementation of RSA algorithm, RSA algorithm
> implemented by gcrypt has a higher priority than nettle because
> it supports raw padding.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
>  crypto/akcipher-gcrypt.c.inc | 520 +++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c            |   4 +-
>  2 files changed, 523 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/akcipher-gcrypt.c.inc
> 
> diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
> new file mode 100644
> index 0000000000..32ff502f71
> --- /dev/null
> +++ b/crypto/akcipher-gcrypt.c.inc
> @@ -0,0 +1,520 @@
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
> +#include <gcrypt.h>
> +
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
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
> +static void qcrypto_gcrypt_rsa_free(QCryptoAkCipher *akcipher)
> +{
> +    QCryptoGcryptRSA *rsa = (QCryptoGcryptRSA *)akcipher;
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
> +    switch (opts->alg) {
> +    case QCRYPTO_AKCIPHER_ALG_RSA:
> +        return (QCryptoAkCipher *)qcrypto_gcrypt_rsa_new(
> +            &opts->u.rsa, type, key, keylen, errp);
> +
> +    default:
> +        error_setg(errp, "Unsupported algorithm: %u", opts->alg);
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
> +    g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
> +        QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE, key, keylen);
> +    gcry_mpi_t n = NULL, e = NULL, d = NULL, p = NULL, q = NULL, u = NULL;
> +    bool compute_mul_inv = false;
> +    int ret = -1;
> +    gcry_error_t err;
> +
> +    if (!rsa_key) {
> +        return ret;
> +    }

If qcrypto_akcipher_rsakey_parse can fail, we need to get a
'Error **errp' in/out of it

> +
> +    err = gcry_mpi_scan(&n, GCRYMPI_FMT_STD,
> +                        rsa_key->n.data, rsa_key->n.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }

Please add an 'Error **errp' parameter to this method, and
populate it with an error message that includes the output
of gcry_

> +
> +    err = gcry_mpi_scan(&e, GCRYMPI_FMT_STD,
> +                        rsa_key->e.data, rsa_key->e.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    err = gcry_mpi_scan(&d, GCRYMPI_FMT_STD,
> +                        rsa_key->d.data, rsa_key->d.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    err = gcry_mpi_scan(&p, GCRYMPI_FMT_STD,
> +                        rsa_key->p.data, rsa_key->p.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    err = gcry_mpi_scan(&q, GCRYMPI_FMT_STD,
> +                        rsa_key->q.data, rsa_key->q.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
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
> +        goto cleanup;
> +    }
> +    qcrypto_gcrypt_set_rsa_size((QCryptoAkCipher *)rsa,  n);
> +    ret = 0;
> +
> +cleanup:
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
> +    g_autoptr(QCryptoAkCipherRSAKey) rsa_key = qcrypto_akcipher_rsakey_parse(
> +        QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC, key, keylen);
> +    gcry_mpi_t n = NULL, e = NULL;
> +    int ret = -1;
> +    gcry_error_t err;
> +
> +    if (!rsa_key) {
> +        return ret;
> +    }
> +
> +    err = gcry_mpi_scan(&n, GCRYMPI_FMT_STD,
> +                        rsa_key->n.data, rsa_key->n.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }

Same note about having 'Error **errp' parameters for this
method.

> +
> +    err = gcry_mpi_scan(&e, GCRYMPI_FMT_STD,
> +                        rsa_key->e.data, rsa_key->e.len, NULL);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    err = gcry_sexp_build(&rsa->key, NULL,
> +                          "(public-key (rsa (n %m) (e %m)))", n, e);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +    qcrypto_gcrypt_set_rsa_size((QCryptoAkCipher *)rsa, n);
> +    ret = 0;
> +
> +cleanup:
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
> +    QCryptoGcryptRSA *rsa = (QCryptoGcryptRSA *)akcipher;
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
> +        goto cleanup;
> +    }

We've got an 'Error **errp' parameter in this methood, but we're
failing to set it here and in other failure scenarios below.

> +
> +    err = gcry_pk_encrypt(&cipher_sexp, data_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    /* S-expression of cipher: (enc-val (rsa (a a-mpi))) */
> +    cipher_sexp_item = gcry_sexp_find_token(cipher_sexp, "a", 0);
> +    if (!cipher_sexp_item || gcry_sexp_length(cipher_sexp_item) != 2) {
> +        goto cleanup;
> +    }
> +
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        cipher_mpi = gcry_sexp_nth_mpi(cipher_sexp_item, 1, GCRYMPI_FMT_USG);
> +        if (!cipher_mpi) {
> +            goto cleanup;
> +        }
> +        err = gcry_mpi_print(GCRYMPI_FMT_USG, out, out_len,
> +                             &actual_len, cipher_mpi);
> +        if (gcry_err_code(err) != 0 || actual_len > out_len) {
> +            goto cleanup;
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
> +            goto cleanup;
> +        }
> +        memcpy(out, result, actual_len);
> +        ret = actual_len;
> +    }
> +
> +cleanup:
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
> +    QCryptoGcryptRSA *rsa = (QCryptoGcryptRSA *)akcipher;
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
> +        goto cleanup;
> +    }

Again failing to set 'Error **errp'

> +
> +    err = gcry_pk_decrypt(&data_sexp, cipher_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    /* S-expression of cipher: (value plaintext) */
> +    if (rsa->padding_alg == QCRYPTO_RSA_PADDING_ALG_RAW) {
> +        data_mpi = gcry_sexp_nth_mpi(data_sexp, 1, GCRYMPI_FMT_USG);
> +        if (!data_mpi) {
> +            goto cleanup;
> +        }
> +        err = gcry_mpi_print(GCRYMPI_FMT_USG, out, out_len,
> +                             &actual_len, data_mpi);
> +        if (gcry_err_code(err) != 0) {
> +            goto cleanup;
> +        }
> +         if (actual_len > out_len) {
> +            goto cleanup;
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
> +            goto cleanup;
> +        }
> +        memcpy(out, result, actual_len);
> +        ret = actual_len;
> +    }
> +
> +cleanup:
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
> +    QCryptoGcryptRSA *rsa = (QCryptoGcryptRSA *)akcipher;
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
> +        error_setg(errp, "Invalid padding %u", rsa->padding_alg);
> +        return ret;
> +    }
> +    err = gcry_sexp_build(&dgst_sexp, NULL,
> +                          "(data (flags pkcs1) (hash %s %b))",
> +                          QCryptoHashAlgorithm_str(rsa->hash_alg),
> +                          in_len, in);
> +
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }

Again failing to set 'Error **errp'


> +
> +    err = gcry_pk_sign(&sig_sexp, dgst_sexp, rsa->key);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    /* S-expression of signature: (sig-val (rsa (s s-mpi))) */
> +    sig_sexp_item = gcry_sexp_find_token(sig_sexp, "s", 0);
> +    if (!sig_sexp_item || gcry_sexp_length(sig_sexp_item) != 2) {
> +        goto cleanup;
> +    }
> +
> +    result = gcry_sexp_nth_data(sig_sexp_item, 1, &actual_len);
> +    if (!result || actual_len > out_len) {
> +        goto cleanup;
> +    }
> +    memcpy(out, result, actual_len);
> +    ret = actual_len;
> +
> +cleanup:
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
> +    QCryptoGcryptRSA *rsa = (QCryptoGcryptRSA *)akcipher;
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
> +        goto cleanup;
> +    }

Again failing to set 'Error **errp'


> +
> +    err = gcry_sexp_build(&dgst_sexp, NULL,
> +                          "(data (flags pkcs1) (hash %s %b))",
> +                          QCryptoHashAlgorithm_str(rsa->hash_alg),
> +                          in2_len, in2);
> +    if (gcry_err_code(err) != 0) {
> +        goto cleanup;
> +    }
> +
> +    err = gcry_pk_verify(sig_sexp, dgst_sexp, rsa->key);
> +    if (gcry_err_code(err) == 0) {
> +        ret = 0;
> +    }
> +
> +cleanup:
> +    gcry_sexp_release(dgst_sexp);
> +    gcry_sexp_release(sig_sexp);
> +
> +    return ret;
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
> +            goto error;
> +        }
> +        break;
> +
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
> +        if (qcrypto_gcrypt_parse_rsa_public_key(rsa, key, keylen) != 0) {
> +            error_setg(errp, "Failed to parse rsa public rsa key");
> +            goto error;
> +        }
> +        break;
> +
> +    default:
> +        error_setg(errp, "Unknown akcipher key type %d", type);
> +        goto error;
> +    }
> +
> +    return rsa;
> +
> +error:
> +    qcrypto_gcrypt_rsa_free((QCryptoAkCipher *)rsa);
> +    return NULL;
> +}
> +
> +
> +bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
> +{
> +    switch (opts->alg) {
> +    case QCRYPTO_AKCIPHER_ALG_RSA:
> +        switch (opts->u.rsa.padding_alg) {
> +        case QCRYPTO_RSA_PADDING_ALG_RAW:
> +            return true;
> +
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
> +        default:
> +            return false;
> +        }
> +
> +    default:
> +        return true;
> +    }
> +}
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index f287083f92..ad88379c1e 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -23,7 +23,9 @@
>  #include "crypto/akcipher.h"
>  #include "akcipherpriv.h"
>  
> -#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
> +#if defined(CONFIG_GCRYPT)
> +#include "akcipher-gcrypt.c.inc"
> +#elif defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
>  #include "akcipher-nettle.c.inc"
>  #else
>  QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions *opts,
> -- 
> 2.20.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

