Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68318C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Mar 2022 09:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiC1JQu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbiC1JQt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Mar 2022 05:16:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8572445067
        for <linux-crypto@vger.kernel.org>; Mon, 28 Mar 2022 02:15:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so11726531plg.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Mar 2022 02:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XjwdjpM5hizrcDlUajI8eDysocGXPt6/ewM91vYNjIE=;
        b=7MKpFE78gPJImqLvDWiQ3R3FBzymHMEcSc+yX+Ti/DsKb6r5FQScbn6grh76X1EX7p
         07LS7Py8SWSG/i4SWNjm8roeInQ/7Rwvx37pGJzTK20ArrfuwHX8XyCwrBkTsW/NjxmV
         1eTulvnrNlCovXMtEj3dmHCyDkpsPTJkq9867F7Aqpppm248taa6VZDk5iIKi/gG4K48
         +jWLuF5KuBUl/o2PZx6WP5QBZkvA004pNkxSK/1d3aW/MspivBbdI+Wb7EpMa7H+FNaj
         UtUPIe/Mba4XeXIz+Q5EqBbapNEfPc50ezkKFAoODTDzJwHI5QTjIkZA5YF0rM8jFiZ4
         VdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XjwdjpM5hizrcDlUajI8eDysocGXPt6/ewM91vYNjIE=;
        b=cZQqfPsC4mHzvbC5XRyWWb5U+SwcwEea+DPGkqhPLxOJH2neC1tWe1HoIjhFln9D1I
         0qEomjC/8pYIfJbMO0BBVBv2mz++1CCpd34qSOrp+/ZkYJ1uj8fxeIMUJs8EXwlfZ/b7
         6WmEn9kwDm3vT90hk5LOzb7EMXWdyLENW2PmIwNz+7hdFSKb19nxH5+NvzAczltG0Xri
         vueeQ9WTi9cWDhpPvW9OygYmmWI3quN9CDAKYbmhFpOQF0kGYrQ91pa4BkIVoEN9tVp4
         Fh1SOE25E27g0D7QxayQpmGYQhqJjCJ8NKAL3dyoMkRjPwPxSe48S/Js2E/iltw7BSJc
         i+aA==
X-Gm-Message-State: AOAM53170FfhGxawB0sqsdIwRc2XiuonGTrB5+/14icINAF0k7mXwnzh
        ZiiuwSTtOpVlp/dycEMHZbda5g==
X-Google-Smtp-Source: ABdhPJxTMGWyhAt7Gh4FnynWO3mwb2x9UPVerD+Si/9GVu+thp6L51XswAqtfUAb/154KeV/ws8JOQ==
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id f13-20020a17090aa78d00b001bcd11cad40mr27507567pjq.246.1648458906784;
        Mon, 28 Mar 2022 02:15:06 -0700 (PDT)
Received: from [10.254.225.118] ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id w8-20020a63a748000000b0038117e18f02sm12446072pgo.29.2022.03.28.02.15.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Mar 2022 02:15:06 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [External] [PATCH v3 4/6] crypto: Implement RSA algorithm by
 hogweed
From:   =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
In-Reply-To: <YjslpEGnzgnExDk+@redhat.com>
Date:   Mon, 28 Mar 2022 17:14:56 +0800
Cc:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>, arei.gonglei@huawei.com,
        "Michael S. Tsirkin" <mst@redhat.com>, herbert@gondor.apana.org.au,
        jasowang@redhat.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2A51F70-B35B-484E-A2AC-3289DD8D8D6B@bytedance.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-5-pizhenwei@bytedance.com>
 <YjslpEGnzgnExDk+@redhat.com>
To:     =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Mar 23, 2022, at 9:50 PM, Daniel P. Berrang=C3=A9 =
<berrange@redhat.com> wrote:
>=20
> On Wed, Mar 23, 2022 at 10:49:10AM +0800, zhenwei pi wrote:
>> From: Lei He <helei.sig11@bytedance.com>
>>=20
>> Introduce ASN.1 decoder, and implement RSA algorithm by hogweed
>> from nettle. Thus QEMU supports a 'real' RSA backend to handle
>> request from guest side. It's important to test RSA offload case
>> without OS & hardware requirement.
>>=20
>> Signed-off-by: lei he <helei.sig11@bytedance.com>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>> crypto/akcipher-nettle.c  | 523 =
++++++++++++++++++++++++++++++++++++++
>> crypto/akcipher.c         |   3 +
>> crypto/asn1_decoder.c     | 185 ++++++++++++++
>> crypto/asn1_decoder.h     |  42 +++
>=20
> Please introduce the asn1 files in a separate commit, and also
> provide a unit test to validate them in the same commit.
>=20
>> diff --git a/crypto/akcipher-nettle.c b/crypto/akcipher-nettle.c
>> new file mode 100644
>> index 0000000000..45b93af772
>> --- /dev/null
>> +++ b/crypto/akcipher-nettle.c
>> @@ -0,0 +1,523 @@
>> +/*
>> + * QEMU Crypto akcipher algorithms
>> + *
>> + * Copyright (c) 2022 Bytedance
>> + * Author: lei he <helei.sig11@bytedance.com>
>> + *
>> + * This library is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU Lesser General Public
>> + * License as published by the Free Software Foundation; either
>> + * version 2.1 of the License, or (at your option) any later =
version.
>> + *
>> + * This library is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * Lesser General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU Lesser General Public
>> + * License along with this library; if not, see =
<http://www.gnu.org/licenses/>.
>> + *
>> + */
>> +
>> +#include <stdbool.h>
>> +
>> +#include <nettle/rsa.h>
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/host-utils.h"
>> +#include "asn1_decoder.h"
>> +#include "crypto/akcipher.h"
>> +#include "crypto/random.h"
>> +#include "qapi/error.h"
>> +#include "sysemu/cryptodev.h"
>> +
>> +typedef struct QCryptoNettleRsa {
>> +    QCryptoAkcipher akcipher;
>> +    struct rsa_public_key pub;
>> +    struct rsa_private_key priv;
>> +    QCryptoRsaPaddingAlgorithm padding_algo;
>> +    QCryptoRsaHashAlgorithm hash_algo;
>> +} QCryptoNettleRsa;
>=20
> Call this QCryptoAkCipherNettleRSA
>=20
>> +
>> +struct asn1_parse_ctx {
>> +    const uint8_t *data;
>> +    size_t dlen;
>> +};
>> +
>> +#define Octet 8
>> +
>> +static int extract_value(void *p, const uint8_t *data, size_t dlen)
>> +{
>> +    struct asn1_parse_ctx *ctx =3D (struct asn1_parse_ctx *)p;
>> +    ctx->data =3D (uint8_t *)data;
>> +    ctx->dlen =3D dlen;
>> +
>> +    return 0;
>> +}
>> +
>> +static int extract_mpi(void *p, const uint8_t *data, size_t dlen)
>> +{
>> +    mpz_t *target =3D (mpz_t *)p;
>> +    nettle_mpz_set_str_256_u(*target, dlen, data);
>> +
>> +    return 0;
>> +}
>> +
>> +static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void);
>> +
>> +static void qcrypto_nettle_rsa_destroy(void *ptr)
>> +{
>> +    QCryptoNettleRsa *rsa =3D (QCryptoNettleRsa *)ptr;
>> +    if (!rsa) {
>> +        return;
>> +    }
>> +
>> +    rsa_public_key_clear(&rsa->pub);
>> +    rsa_private_key_clear(&rsa->priv);
>> +    g_free(rsa);
>> +}
>> +
>> +static QCryptoAkcipher *qcrypto_nettle_new_rsa(
>> +    QCryptoAkcipherKeyType type,
>> +    const uint8_t *key,  size_t keylen,
>> +    QCryptoRsaOptions *opt, Error **errp);
>> +
>> +QCryptoAkcipher =
*qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
>> +                                             QCryptoAkcipherKeyType =
type,
>> +                                             const uint8_t *key,
>> +                                             size_t keylen, void =
*para,
>> +                                             Error **errp)
>> +{
>> +    switch (alg) {
>> +    case QCRYPTO_AKCIPHER_ALG_RSA:
>> +        return qcrypto_nettle_new_rsa(type, key, keylen,
>> +                                      (QCryptoRsaOptions *)para, =
errp);
>> +    default:
>> +        error_setg(errp, "Unsupported algorithm: %u", alg);
>> +        return NULL;
>> +    }
>> +
>> +    return NULL;
>> +}
>> +
>> +/**
>> + * Parse ber encoded rsa private key, asn1 schema:
>> + *        RsaPrivKey ::=3D SEQUENCE {
>> + *             version     INTEGER
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *             d           INTEGER
>> + *             p           INTEGER
>> + *             q           INTEGER
>> + *             e1          INTEGER
>> + *             e2          INTEGER
>> + *             u           INTEGER
>> + *         }
>> + */
>> +static int parse_rsa_private_key(QCryptoNettleRsa *rsa,
>> +                                 const uint8_t *key, size_t keylen)
>> +{
>> +    struct asn1_parse_ctx ctx;
>> +
>> +    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) !=3D 0 ||
>> +        keylen !=3D 0) {
>> +        return -1;
>> +    }
>> +
>> +    if (ber_decode_int(&ctx.data, &ctx.dlen, NULL, NULL) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->pub.n) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->pub.e) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.d) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.p) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.q) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.a) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.b) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->priv.c) !=3D 0 ||
>> +        ctx.dlen !=3D 0) {
>> +        return -1;
>> +    }
>> +
>> +    if (!rsa_public_key_prepare(&rsa->pub)) {
>> +        return -1;
>> +    }
>> +
>> +    /**
>> +     * Since in the kernel's unit test, the p, q, a, b, c of some
>> +     * private keys is 0, only the simplest length check is done =
here
>> +     */
>> +    rsa->priv.size =3D rsa->pub.size;
>> +
>> +    return 0;
>> +}
>> +
>> +/**
>> + * Parse ber encoded rsa pubkey, asn1 schema:
>> + *        RsaPrivKey ::=3D SEQUENCE {
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *         }
>> + */
>> +static int parse_rsa_public_key(QCryptoNettleRsa *rsa,
>> +                                const uint8_t *key,
>> +                                size_t keylen)
>> +{
>> +    struct asn1_parse_ctx ctx;
>> +
>> +    if (ber_decode_seq(&key, &keylen, extract_value, &ctx) !=3D 0 ||
>> +        keylen !=3D 0) {
>> +        return -1;
>> +    }
>> +
>> +    if (ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->pub.n) !=3D 0 ||
>> +        ber_decode_int(&ctx.data, &ctx.dlen, extract_mpi, =
&rsa->pub.e) !=3D 0 ||
>> +        ctx.dlen !=3D 0) {
>> +        return -1;
>> +    }
>> +
>> +    if (!rsa_public_key_prepare(&rsa->pub)) {
>> +        return -1;
>> +    }
>> +
>> +    return 0;
>> +}
>=20
> I'd like to see these APIs for parsing RSA keys split out into
> a separate file, crypto/rsakey.{c,h}.  Define a struct to hold
> the RSA key parameters so it isn't tied to nettle, allowing
> its potential reuse with a gcrypt/gnutls impl of these APIs

So we should define the following structures to avoid tieing to nettle?

struct QCryptoRSAParameter {
	uint8_t *data;
       size_t data_len;
};

struct QCryptoRSAKey {
	QCryptoRSAParameter n;
	QCryptoRSAParameter e;
	QCryptoRSAParameter d;
	QCryptoRSAParameter p;
	QCryptoRSAParameter q;
       ...
};

>=20
>> +
>> +static void qcrypto_nettle_rsa_set_akcipher_size(QCryptoAkcipher =
*akcipher,
>> +                                                 int key_size)
>> +{
>> +    akcipher->max_plaintext_len =3D key_size;
>> +    akcipher->max_ciphertext_len =3D key_size;
>> +    akcipher->max_signature_len =3D key_size;
>> +    akcipher->max_dgst_len =3D key_size;
>> +}
>> +
>> +static QCryptoAkcipher *qcrypto_nettle_new_rsa(
>> +    QCryptoAkcipherKeyType type,
>> +    const uint8_t *key, size_t keylen,
>> +    QCryptoRsaOptions *opt, Error **errp)
>> +{
>> +    QCryptoNettleRsa *rsa =3D qcrypto_nettle_rsa_malloc();
>> +    rsa->padding_algo =3D opt->padding_algo;
>> +    rsa->hash_algo =3D opt->hash_algo;
>> +
>> +    switch (type) {
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
>> +        if (parse_rsa_private_key(rsa, key, keylen) =3D=3D 0) {
>> +            qcrypto_nettle_rsa_set_akcipher_size(
>> +                (QCryptoAkcipher *)rsa, rsa->priv.size);
>> +            return (QCryptoAkcipher *)rsa;
>> +        }
>> +        error_setg(errp, "Failed to parse rsa private key");
>=20
> This code pattern is back to front of what we would normally
> do.  ie I'd expect it to look like this:
>=20
>         if (parse_rsa_private_key(rsa, key, keylen) !=3D 0) {
>             error_setg(errp, "Failed to parse rsa private key");
> 	     goto error;
>         }
>=20
>         qcrypto_nettle_rsa_set_akcipher_size(
>                 (QCryptoAkcipher *)rsa, rsa->priv.size);
>         return (QCryptoAkcipher *)rsa;
>=20
>=20
>=20
>> +        break;
>> +
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
>> +        if (parse_rsa_public_key(rsa, key, keylen) =3D=3D 0) {
>> +            qcrypto_nettle_rsa_set_akcipher_size(
>> +                (QCryptoAkcipher *)rsa, rsa->pub.size);
>> +            return (QCryptoAkcipher *)rsa;
>> +        }
>> +        error_setg(errp, "Failed to parse rsa public rsa key");
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown akcipher key type %d", type);
>> +    }
>> +
>> +    qcrypto_nettle_rsa_destroy(rsa);
>> +    return NULL;
>> +}
>> +
>> +
>> +/**
>> + * nettle does not provide RSA interfaces without padding,
>> + * here we implemented rsa algorithm with nettle/mpz.
>> + */
>=20
> Urgh, this is really unpleasant. I don't want to see QEMU
> implementing any further crypto algorithms directly, only
> ever consume and wrap impls from external libraries. We've
> got a few in QEMU for historical reasons, but don't want
> to add more. There are too many ways to mess up crypto
> opening the door to subtle timing / side channel attacks,
> and crypto impls also cause distributors pain with export
> compliance rules.
>=20
> If nettle doesn't provide an impl without padding, then
> simply don't implement it. Report an error if the caller
> tries to enable it.
>=20
> An alternate gcrypt impl of these APIs might allow for
> an impl without padding.
>=20
>> +static int _rsa_enc_raw(QCryptoNettleRsa *rsa, const void *data,
>> +                        size_t data_len, void *enc,
>> +                        size_t enc_len, Error **errp)
>> +{
>> +    mpz_t m;
>> +    int ret;
>> +
>> +    nettle_mpz_init_set_str_256_u(m, data_len, data);
>> +    /* (1) Validate 0 <=3D m < n */
>> +    if (mpz_cmp_ui(m, 0) < 0 || mpz_cmp(m, rsa->pub.n) >=3D 0) {
>> +        error_setg(errp, "Failed to validate input data");
>> +        return -1;
>> +    }
>> +
>> +    /* (2) c =3D m ^ e mod n */
>> +    mpz_powm(m, m, rsa->pub.e, rsa->pub.n);
>> +    if ((mpz_sizeinbase(m, 2) + Octet - 1) / Octet > enc_len) {
>> +        ret =3D -1;
>> +    } else {
>> +        ret =3D enc_len;
>> +        nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, m);
>> +    }
>> +
>> +    mpz_clear(m);
>> +
>> +    return ret;
>> +}
>> +
>> +static int _rsa_dec_raw(QCryptoNettleRsa *rsa,
>> +                        const void *enc,
>> +                        size_t enc_len,
>> +                        void *data,
>> +                        size_t data_len,
>> +                        Error **errp)
>> +{
>> +    mpz_t c;
>> +    int ret;
>> +    nettle_mpz_init_set_str_256_u(c, enc_len, enc);
>> +
>> +    /* (1) Validate 0 <=3D c < n */
>> +    if (mpz_cmp_ui(c, 0) < 0 || mpz_cmp(c, rsa->pub.n) >=3D 0) {
>> +        error_setg(errp, "Failed to validate input data");
>> +        return -1;
>> +    }
>> +
>> +    /* (2) m =3D c ^ d mod n */
>> +    mpz_powm(c, c, rsa->priv.d, rsa->pub.n);
>> +    if ((mpz_sizeinbase(c, 2) + Octet - 1) / Octet > data_len) {
>> +        ret =3D -1;
>> +    } else {
>> +        ret =3D data_len;
>> +        nettle_mpz_get_str_256(data_len, (uint8_t *)data, c);
>> +    }
>> +
>> +    mpz_clear(c);
>> +
>> +    return ret;
>> +}
>> +
>> +static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t =
*out)
>> +{
>> +    /* TODO: check result */
>> +    qcrypto_random_bytes(out, len, NULL);
>> +}
>> +
>> +static int qcrypto_nettle_rsa_encrypt(QCryptoAkcipher =
*akcipher_driver,
>> +                                      const void *data, size_t =
data_len,
>> +                                      void *enc, size_t enc_len,
>> +                                      Error **errp)
>> +{
>> +
>> +    QCryptoNettleRsa *rsa =3D
>> +        container_of(akcipher_driver, QCryptoNettleRsa, akcipher);
>> +    mpz_t c;
>> +    int enc_ret;
>> +
>> +    if (data_len > rsa->pub.size || enc_len !=3D rsa->pub.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>> +
>> +    switch (rsa->padding_algo) {
>> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
>> +        return _rsa_enc_raw(rsa, data, data_len, enc, enc_len, =
errp);
>> +
>> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
>> +        mpz_init(c);
>> +        enc_ret =3D rsa_encrypt(&rsa->pub, NULL, =
wrap_nettle_random_func,
>> +                              data_len, (uint8_t *)data, c);
>> +        if (enc_ret !=3D 1) {
>> +            error_setg(errp, "Failed to encrypt");
>> +            enc_ret =3D -1;
>> +        } else {
>> +            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
>> +            enc_ret =3D enc_len;
>> +        }
>> +        mpz_clear(c);
>> +        return enc_ret;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown padding");
>> +        return -1;
>> +    }
>> +
>> +    return -1;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_decrypt(QCryptoAkcipher *akcipher,
>> +                                      const void *enc, size_t =
enc_len,
>> +                                      void *data, size_t data_len,
>> +                                      Error **errp)
>> +{
>> +    QCryptoNettleRsa *rsa =3D container_of(akcipher, =
QCryptoNettleRsa, akcipher);
>> +    mpz_t c;
>> +    int ret;
>> +    if (enc_len > rsa->priv.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>> +
>> +    switch (rsa->padding_algo) {
>> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
>> +        ret =3D _rsa_dec_raw(rsa, enc, enc_len, data, data_len, =
errp);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
>> +        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
>> +        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) =
{
>> +            error_setg(errp, "Failed to decrypt");
>> +            ret =3D -1;
>> +        } else {
>> +            ret =3D data_len;
>> +        }
>> +
>> +        mpz_clear(c);
>> +        break;
>> +
>> +    default:
>> +        ret =3D -1;
>> +        error_setg(errp, "Unknown padding");
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_sign(QCryptoAkcipher *akcipher,
>> +                                   const void *data, size_t =
data_len,
>> +                                   void *sig, size_t sig_len, Error =
**errp)
>> +{
>> +    QCryptoNettleRsa *rsa =3D container_of(akcipher, =
QCryptoNettleRsa, akcipher);
>> +    int ret;
>> +    mpz_t s;
>> +
>> +    /**
>> +     * The RSA algorithm cannot be used for signature/verification
>> +     * without padding.
>> +     */
>> +    if (rsa->padding_algo =3D=3D QCRYPTO_RSA_PADDING_ALG_RAW) {
>> +        error_setg(errp, "Try to make signature without padding");
>> +        return -1;
>> +    }
>> +
>> +    if (data_len > rsa->priv.size || sig_len !=3D rsa->priv.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>> +
>> +    mpz_init(s);
>> +    switch (rsa->hash_algo) {
>> +    case QCRYPTO_RSA_HASH_ALG_MD5:
>> +        ret =3D rsa_md5_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA1:
>> +        ret =3D rsa_sha1_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA256:
>> +        ret =3D rsa_sha256_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA512:
>> +        ret =3D rsa_sha512_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown hash algorithm");
>> +        ret =3D -1;
>> +        goto clear;
>> +    }
>> +
>> +    if (ret !=3D 1) {
>> +        error_setg(errp, "Failed to make signature");
>> +        ret =3D -1;
>> +        goto clear;
>> +    }
>> +    nettle_mpz_get_str_256(sig_len, (uint8_t *)sig, s);
>> +    ret =3D sig_len;
>> +
>> +clear:
>> +    mpz_clear(s);
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_verify(QCryptoAkcipher *akcipher,
>> +                                     const void *sig, size_t =
sig_len,
>> +                                     const void *data, size_t =
data_len,
>> +                                     Error **errp)
>> +{
>> +    QCryptoNettleRsa *rsa =3D container_of(akcipher, =
QCryptoNettleRsa, akcipher);
>> +
>> +    int ret;
>> +    mpz_t s;
>> +
>> +    /**
>> +     * The RSA algorithm cannot be used for signature/verification
>> +     * without padding.
>> +     */
>> +    if (rsa->padding_algo =3D=3D QCRYPTO_RSA_PADDING_ALG_RAW) {
>> +        error_setg(errp, "Operation not supported");
>> +        return -1;
>> +    }
>> +    if (data_len > rsa->pub.size || sig_len < rsa->pub.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>> +
>> +    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
>> +    switch (rsa->hash_algo) {
>> +    case QCRYPTO_RSA_HASH_ALG_MD5:
>> +        ret =3D rsa_md5_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA1:
>> +        ret =3D rsa_sha1_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA256:
>> +        ret =3D rsa_sha256_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_RSA_HASH_ALG_SHA512:
>> +        ret =3D rsa_sha512_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unsupported hash algorithm");
>> +        ret =3D -1;
>> +        goto clear;
>> +    }
>> +
>> +    if (ret !=3D 1) {
>> +        error_setg(errp, "Failed to verify");
>> +        ret =3D -1;
>> +        goto clear;
>> +    }
>> +    ret =3D 0;
>> +
>> +clear:
>> +    mpz_clear(s);
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_free(struct QCryptoAkcipher *akcipher,
>> +                                   Error **errp)
>> +{
>> +    qcrypto_nettle_rsa_destroy(akcipher);
>> +    return 0;
>> +}
>> +
>> +QCryptoAkcipherDriver nettle_rsa =3D {
>> +    .encrypt =3D qcrypto_nettle_rsa_encrypt,
>> +    .decrypt =3D qcrypto_nettle_rsa_decrypt,
>> +    .sign =3D qcrypto_nettle_rsa_sign,
>> +    .verify =3D qcrypto_nettle_rsa_verify,
>> +    .free =3D qcrypto_nettle_rsa_free,
>> +};
>> +
>> +static QCryptoNettleRsa *qcrypto_nettle_rsa_malloc(void)
>> +{
>> +    QCryptoNettleRsa *rsa =3D g_malloc0(sizeof(QCryptoNettleRsa));
>=20
> s/g_mallo0/g_new0/
>=20
>> +    memset(rsa, 0, sizeof(QCryptoNettleRsa));
>=20
> It is already initialized to zero by the allocator above.
>=20
>> +    rsa->akcipher.driver =3D &nettle_rsa;
>> +    rsa_public_key_init(&rsa->pub);
>> +    rsa_private_key_init(&rsa->priv);
>=20
> I don't think this method should exist at all though. It only
> has one caller, so just put the code inline there.
>=20
>> +
>> +    return rsa;
>> +}
>> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
>> index 1e52f2fd76..b5c04e8424 100644
>> --- a/crypto/akcipher.c
>> +++ b/crypto/akcipher.c
>> @@ -31,6 +31,9 @@ QCryptoAkcipher =
*qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
>> {
>>     QCryptoAkcipher *akcipher =3D NULL;
>>=20
>> +    akcipher =3D qcrypto_akcipher_nettle_new(alg, type, key, keylen,
>> +                                           para, errp);
>> +
>>     return akcipher;
>> }
>=20
> Hard-wiring this to use the nettle impl is not at all desirable. It
> needs to use a pluggable approach, with a strong preferance to match
> the design of the crypto/cipher.c
>=20
>>=20
>> diff --git a/crypto/asn1_decoder.c b/crypto/asn1_decoder.c
>> new file mode 100644
>> index 0000000000..bfb145e84e
>> --- /dev/null
>> +++ b/crypto/asn1_decoder.c
>> @@ -0,0 +1,185 @@
>> +/*
>> + * QEMU Crypto akcipher algorithms
>=20
> This comment is wrong
>=20
>> + *
>> + * Copyright (c) 2022 Bytedance
>> + * Author: lei he <helei.sig11@bytedance.com>
>> + *
>> + * This library is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU Lesser General Public
>> + * License as published by the Free Software Foundation; either
>> + * version 2.1 of the License, or (at your option) any later =
version.
>> + *
>> + * This library is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * Lesser General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU Lesser General Public
>> + * License along with this library; if not, see =
<http://www.gnu.org/licenses/>.
>> + *
>> + */
>> +
>> +#include <stdint.h>
>> +#include <stddef.h>
>> +
>> +#include "crypto/asn1_decoder.h"
>> +
>> +enum ber_type_tag {
>> +    ber_type_tag_bool =3D 0x1,
>> +    ber_type_tag_int =3D 0x2,
>> +    ber_type_tag_bit_str =3D 0x3,
>> +    ber_type_tag_oct_str =3D 0x4,
>> +    ber_type_tag_oct_null =3D 0x5,
>> +    ber_type_tag_oct_oid =3D 0x6,
>> +    ber_type_tag_seq =3D 0x10,
>> +    ber_type_tag_set =3D 0x11,
>> +};
>> +
>> +#define BER_CONSTRUCTED_MASK 0x20
>> +#define BER_SHORT_LEN_MASK 0x80
>> +
>> +static uint8_t ber_peek_byte(const uint8_t **data, size_t *dlen)
>> +{
>> +    return **data;
>> +}
>> +
>> +static int invoke_callback(BerDecodeCb cb, void *ctx,
>> +                           const uint8_t *value, size_t vlen)
>> +{
>> +    if (!cb) {
>> +        return 0;
>> +    }
>> +
>> +    return cb(ctx, value, vlen);
>> +}
>> +
>> +static void ber_cut_nbytes(const uint8_t **data, size_t *dlen,
>> +                           size_t nbytes)
>> +{
>> +    *data +=3D nbytes;
>> +    *dlen -=3D nbytes;
>> +}
>> +
>> +static uint8_t ber_cut_byte(const uint8_t **data, size_t *dlen)
>> +{
>> +    uint8_t val =3D ber_peek_byte(data, dlen);
>> +
>> +    ber_cut_nbytes(data, dlen, 1);
>> +
>> +    return val;
>> +}
>> +
>> +static int ber_extract_definite_data(const uint8_t **data, size_t =
*dlen,
>> +                                     BerDecodeCb cb, void *ctx)
>> +{
>> +    const uint8_t *value;
>> +    size_t vlen =3D 0;
>> +    uint8_t byte_count =3D ber_cut_byte(data, dlen);
>> +
>> +    /* short format of definite-length */
>> +    if (!(byte_count & BER_SHORT_LEN_MASK)) {
>> +        if (byte_count > *dlen) {
>> +            return -1;
>> +        }
>> +
>> +        value =3D *data;
>> +        vlen =3D byte_count;
>> +        ber_cut_nbytes(data, dlen, vlen);
>> +
>> +        return invoke_callback(cb, ctx, value, vlen);
>> +    }
>> +
>> +    /* Ignore highest bit */
>> +    byte_count &=3D ~BER_SHORT_LEN_MASK;
>> +
>> +    /*
>> +     * size_t is enough to express the length, although the ber =
encoding
>> +     * standard supports larger length.
>> +     */
>> +    if (byte_count > sizeof(size_t)) {
>> +        return -1;
>> +    }
>> +
>> +    while (byte_count--) {
>> +        vlen <<=3D 8;
>> +        vlen +=3D ber_cut_byte(data, dlen);
>> +    }
>> +
>> +    if (vlen > *dlen) {
>> +        return -1;
>> +    }
>> +
>> +    value =3D *data;
>> +    ber_cut_nbytes(data, dlen, vlen);
>> +
>> +    return invoke_callback(cb, ctx, value, vlen);
>> +}
>> +
>> +static int ber_extract_undefinite_data(const uint8_t **data, size_t =
*dlen,
>> +                                       BerDecodeCb cb, void *ctx)
>> +{
>> +    size_t vlen =3D 0;
>> +    const uint8_t *value;
>> +
>> +    if (*dlen < 3) {
>> +        return -1;
>> +    }
>> +
>> +    /* skip undefinite-length-mask 0x80 */
>> +    ber_cut_nbytes(data, dlen, 1);
>> +
>> +    value =3D *data;
>> +    while (vlen < *dlen) {
>> +        if ((*data)[vlen] !=3D 0) {
>> +            vlen++;
>> +            continue;
>> +        }
>> +
>> +        if (vlen + 1 < *dlen && (*data[vlen + 1] =3D=3D 0)) {
>> +            ber_cut_nbytes(data, dlen, vlen + 2);
>> +            return invoke_callback(cb, ctx, value, vlen);
>> +        }
>> +
>> +        vlen +=3D 2;
>> +    }
>> +
>> +    return -1;
>> +}
>> +
>> +static int ber_extract_data(const uint8_t **data, size_t *dlen,
>> +                            BerDecodeCb cb, void *ctx)
>> +{
>> +    uint8_t val =3D ber_peek_byte(data, dlen);
>> +
>> +    if (val =3D=3D BER_SHORT_LEN_MASK) {
>> +        return ber_extract_undefinite_data(data, dlen, cb, ctx);
>> +    }
>> +
>> +    return ber_extract_definite_data(data, dlen, cb, ctx);
>> +}
>> +
>> +int ber_decode_int(const uint8_t **data, size_t *dlen,
>> +                   BerDecodeCb cb, void *ctx)
>> +{
>> +    uint8_t tag =3D ber_cut_byte(data, dlen);
>> +
>> +    /* INTEGER must encoded in primitive-form */
>> +    if (tag !=3D ber_type_tag_int) {
>> +        return -1;
>> +    }
>> +
>> +    return ber_extract_data(data, dlen, cb, ctx);
>> +}
>> +
>> +int ber_decode_seq(const uint8_t **data, size_t *dlen,
>> +                   BerDecodeCb cb, void *ctx)
>> +{
>> +    uint8_t val =3D ber_cut_byte(data, dlen);
>> +
>> +    /* SEQUENCE must use constructed form */
>> +    if (val !=3D (ber_type_tag_seq | BER_CONSTRUCTED_MASK)) {
>> +        return -1;
>> +    }
>> +
>> +    return ber_extract_data(data, dlen, cb, ctx);
>> +}
>=20
> Nettle has some asn1 APIs - can we not use those instead of
> implementing all it ourselves ?
>=20

Of course, we can use the API provided by nettle. There is a little =
doubt=20
here: If we use nettle's API directly, the implementation of rsakey.{hc} =
will=20
be tied to nettle, or we should define a new structure independent of=20
nettle/mpz_t to save the parameters of RSA?

>=20
>> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
>> index 03cc3bf46b..2ec7f0f8d7 100644
>> --- a/include/crypto/akcipher.h
>> +++ b/include/crypto/akcipher.h
>> @@ -135,5 +135,21 @@ int qcrypto_akcipher_verify(struct =
QCryptoAkcipher *akcipher,
>>=20
>> int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error =
**errp);
>>=20
>> +#ifdef CONFIG_HOGWEED
>> +QCryptoAkcipher =
*qcrypto_akcipher_nettle_new(QCryptoAkcipherAlgorithm alg,
>> +                                             QCryptoAkcipherKeyType =
type,
>> +                                             const uint8_t *key, =
size_t keylen,
>> +                                             void *para, Error =
**errp);
>> +#else
>> +static inline QCryptoAkcipher *qcrypto_akcipher_nettle_new(
>> +                                             =
QCryptoAkcipherAlgorithm alg,
>> +                                             QCryptoAkcipherKeyType =
type,
>> +                                             const uint8_t *key, =
size_t keylen,
>> +                                             void *para, Error =
**errp)
>> +{
>> +    error_setg(errp, "qcrypto akcipher has no nettle/hogweed =
support");
>> +    return NULL;
>> +}
>> +#endif
>=20
>=20
> These methods are private impl details and should not be in the
> akcipher.h public header. This ties back to my earlier comment
> about making this akcipher impl pluggable in the same way as
> the cipher impl is.
>=20
>=20
> With regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    =
https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            =
https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    =
https://www.instagram.com/dberrange :|

