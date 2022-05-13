Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2818EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 12:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiEMM02 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 08:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380250AbiEMM0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 08:26:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDAE289B5
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 05:26:21 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 137so7360336pgb.5
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 05:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OoZMt75SpCKj3r1itS3PFDvnqYzwUbb6o5Z8wEUDPdQ=;
        b=6pMgxgN30PeF9GG7YRiVfyURsHiDQvKmojSnb+1ahpODxzlbtl1FLQOhWzYXcd9mFU
         2LR5lQl8hwGAWuMQk5f18iUMfDvIfNs1dSXxTTzvyhPAZ2NMnZDAXxW3cSyvMzX/qRf6
         1jNTRhrvc6NPx0sKO8moGHsYAZVaYKZMUJS5P/1SKk4FncOxvmOQUZ7A4Ah571XhAfzb
         uzdMBzgy8HGDAbOEQ/cn6PO86perUCfvNkNmF5u0CQf4m5DV0Zgxn47KF/Sx1Rta6ni1
         jJg0ytaF3DXcIlcMBbtjjz1651uuPmwR+pxd4zyOdjG+I56FF02m21tUDh5j0wPjN2rX
         adbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OoZMt75SpCKj3r1itS3PFDvnqYzwUbb6o5Z8wEUDPdQ=;
        b=O12fYMwNHClgs00dn0AutCtowAXmpeotlwXgO+BJeAiwl4R/7hw6i0MoudxBgp7aXZ
         mQtkMDO1PlQXcIzG6D1Or8aZynUCcVYPH9MPZfqBNr2aMvYZ9Wdc2BMCD3pz8C1bBic/
         7ZVLQC69i/Z6bPRcKQuE1wNOrdcIl8+HKz/eWBckuXsqz+IE0FBSoSJWO4DBECNRRlbV
         1mitM8Xo0BnwuubrqsccMwpPQt02tqzJm8c0FzCfnsBPedg+Kv4rCBOhHdrRldJzkOx/
         M4XTNDJwlNrJgfIOLBBDN2TyC8/GqFscQ9fToh7x1N3/tFUpS4CHy7uQvktqV5w/Gkce
         jCsQ==
X-Gm-Message-State: AOAM531z8IQi/egIoIpNwXHderduZGS247pPwQlxv5rDoMZSi5D5bX6X
        WvhDZ7iHjegR6ew1rFFvaQN2sA==
X-Google-Smtp-Source: ABdhPJxbO/6nSdXOt55aAoUD7Bbd9HhGY5l7tqZrf5dD4jgCJ58hReSae+MZ/5n9LBJtZ0YChFBIug==
X-Received: by 2002:a62:1850:0:b0:50d:2398:b43b with SMTP id 77-20020a621850000000b0050d2398b43bmr4538190pfy.59.1652444781178;
        Fri, 13 May 2022 05:26:21 -0700 (PDT)
Received: from [10.254.83.239] ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id i197-20020a6287ce000000b00512e4b5af0fsm1484305pfe.174.2022.05.13.05.26.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 May 2022 05:26:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [External] [PATCH v5 5/9] crypto: Implement RSA algorithm by
 hogweed
From:   =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
In-Reply-To: <Yn45CxgJ+KNIxXek@redhat.com>
Date:   Fri, 13 May 2022 20:26:14 +0800
Cc:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>,
        zhenwei pi <pizhenwei@bytedance.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>, arei.gonglei@huawei.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <90F3B18B-9B7E-423C-A909-45D4527A6B3C@bytedance.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-6-pizhenwei@bytedance.com>
 <Yn45CxgJ+KNIxXek@redhat.com>
To:     =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On May 13, 2022, at 6:55 PM, Daniel P. Berrang=C3=A9 =
<berrange@redhat.com> wrote:
>=20
> On Thu, Apr 28, 2022 at 09:59:39PM +0800, zhenwei pi wrote:
>> From: Lei He <helei.sig11@bytedance.com>
>>=20
>> Implement RSA algorithm by hogweed from nettle. Thus QEMU supports
>> a 'real' RSA backend to handle request from guest side. It's
>> important to test RSA offload case without OS & hardware requirement.
>>=20
>> Signed-off-by: lei he <helei.sig11@bytedance.com>
>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
>> ---
>> crypto/akcipher-nettle.c.inc | 432 =
+++++++++++++++++++++++++++++++++++
>> crypto/akcipher.c            |   4 +
>> crypto/meson.build           |   4 +
>> crypto/rsakey-builtin.c.inc  | 209 +++++++++++++++++
>> crypto/rsakey-nettle.c.inc   | 154 +++++++++++++
>> crypto/rsakey.c              |  44 ++++
>> crypto/rsakey.h              |  94 ++++++++
>> meson.build                  |  11 +
>> 8 files changed, 952 insertions(+)
>> create mode 100644 crypto/akcipher-nettle.c.inc
>> create mode 100644 crypto/rsakey-builtin.c.inc
>> create mode 100644 crypto/rsakey-nettle.c.inc
>> create mode 100644 crypto/rsakey.c
>> create mode 100644 crypto/rsakey.h
>>=20
>=20
>=20
>> +
>> +static void wrap_nettle_random_func(void *ctx, size_t len, uint8_t =
*out)
>> +{
>> +    /* TODO: check result */
>> +    qcrypto_random_bytes(out, len, NULL);
>> +}
>=20
> Unfortunate meson requires this function to be void.
>=20
> Since we've no way to report errors, then our only option is assume
> qcrypto_random_bytes will never fail, and enforce that assumptiomn
> by passing '&error_abort' for the last parameter.
>=20
>> +
>> +static int qcrypto_nettle_rsa_encrypt(QCryptoAkCipher *akcipher,
>> +                                      const void *data, size_t =
data_len,
>> +                                      void *enc, size_t enc_len,
>> +                                      Error **errp)
>> +{
>> +
>> +    QCryptoNettleRSA *rsa =3D (QCryptoNettleRSA *)akcipher;
>> +    mpz_t c;
>> +    int ret =3D -1;
>> +
>> +    if (data_len > rsa->pub.size || enc_len !=3D rsa->pub.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return ret;
>> +    }
>=20
> Can you report the invalid & expect buffer sizes, as it'll
> make debugging much easier. You'll need a separate check
> and error reporting for enc_len and data_len.

In addition, 'enc_len !=3D rsa->pub.size' should be 'enc_len < =
rsa->pub.size', I
will fix this later.

>=20
>> +
>> +    /* Nettle do not support RSA encryption without any padding */
>> +    switch (rsa->padding_alg) {
>> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
>> +        error_setg(errp, "RSA with raw padding is not supported");
>> +        break;
>> +
>> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
>> +        mpz_init(c);
>> +        if (rsa_encrypt(&rsa->pub, NULL, wrap_nettle_random_func,
>> +                          data_len, (uint8_t *)data, c) !=3D 1) {
>> +            error_setg(errp, "Failed to encrypt");
>> +        } else {
>> +            nettle_mpz_get_str_256(enc_len, (uint8_t *)enc, c);
>> +            ret =3D enc_len;
>> +        }
>> +        mpz_clear(c);
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown padding");
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_decrypt(QCryptoAkCipher *akcipher,
>> +                                      const void *enc, size_t =
enc_len,
>> +                                      void *data, size_t data_len,
>> +                                      Error **errp)
>> +{
>> +    QCryptoNettleRSA *rsa =3D (QCryptoNettleRSA *)akcipher;
>> +    mpz_t c;
>> +    int ret =3D -1;
>> +    if (enc_len > rsa->priv.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return ret;
>> +    }
>=20
> Again please report the invalid & expected sizes in the message
>=20
> We don't need to validate 'data_len' in the decrypt case,
> as you did in encrypt ?

In the decrypt case, it is difficult (and unnecessary) to check =
'data_len' before=20
we completing the decryption action. If the plaintext buffer is too =
small,=20
following =E2=80=98rsa_decrypt=E2=80=99 will return an error, and it =
should be valid to pass a very=20
large buffer.

According to the pkcs#1 stardard, the length of ciphertext should always =
equal
to key size, and the length of plaintext can be any value in range [1, =
key_size - 11]:

https://datatracker.ietf.org/doc/html/rfc2437#section-7.2 =20

>=20
>> +
>> +    switch (rsa->padding_alg) {
>> +    case QCRYPTO_RSA_PADDING_ALG_RAW:
>> +        error_setg(errp, "RSA with raw padding is not supported");
>> +        break;
>> +
>> +    case QCRYPTO_RSA_PADDING_ALG_PKCS1:
>> +        nettle_mpz_init_set_str_256_u(c, enc_len, enc);
>> +        if (!rsa_decrypt(&rsa->priv, &data_len, (uint8_t *)data, c)) =
{
>> +            error_setg(errp, "Failed to decrypt");
>> +        } else {
>> +            ret =3D data_len;
>> +        }
>> +
>> +        mpz_clear(c);
>> +        break;
>> +
>> +    default:
>> +        ret =3D -1;
>=20
> 'ret' was initialized to '-1' at time of declaration
>=20
>> +        error_setg(errp, "Unknown padding");
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_sign(QCryptoAkCipher *akcipher,
>> +                                   const void *data, size_t =
data_len,
>> +                                   void *sig, size_t sig_len, Error =
**errp)
>> +{
>> +    QCryptoNettleRSA *rsa =3D (QCryptoNettleRSA *)akcipher;
>> +    int ret;
>=20
> For consistency with the earlier methods, initialize this to -1
>=20
>> +    mpz_t s;
>> +
>> +    /**
>> +     * The RSA algorithm cannot be used for signature/verification
>> +     * without padding.
>> +     */
>> +    if (rsa->padding_alg =3D=3D QCRYPTO_RSA_PADDING_ALG_RAW) {
>> +        error_setg(errp, "Try to make signature without padding");
>> +        return -1;
>> +    }
>> +
>> +    if (data_len > rsa->priv.size || sig_len !=3D rsa->priv.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>=20
> Same note about reporting the lengths.
>=20
>> +
>> +    mpz_init(s);
>> +    switch (rsa->hash_alg) {
>> +    case QCRYPTO_HASH_ALG_MD5:
>> +        ret =3D rsa_md5_sign_digest(&rsa->priv, data, s);
>=20
> I'd suggest using a separate variable 'rv' here, as I
> find it can be confusing to re-use a variable for two
> different purposes. Keep 'ret' exclusively for holdnig
> the method return value.
>=20
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA1:
>> +        ret =3D rsa_sha1_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA256:
>> +        ret =3D rsa_sha256_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA512:
>> +        ret =3D rsa_sha512_sign_digest(&rsa->priv, data, s);
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown hash algorithm");
>> +        ret =3D -1;
>=20
> No need if we initialize 'ret' upfront.
>=20
>> +        goto cleanup;
>> +    }
>> +
>> +    if (ret !=3D 1) {
>> +        error_setg(errp, "Failed to make signature");
>> +        ret =3D -1;
>> +        goto cleanup;
>> +    }
>> +    nettle_mpz_get_str_256(sig_len, (uint8_t *)sig, s);
>> +    ret =3D sig_len;
>> +
>> +cleanup:
>> +    mpz_clear(s);
>> +
>> +    return ret;
>> +}
>> +
>> +static int qcrypto_nettle_rsa_verify(QCryptoAkCipher *akcipher,
>> +                                     const void *sig, size_t =
sig_len,
>> +                                     const void *data, size_t =
data_len,
>> +                                     Error **errp)
>> +{
>> +    QCryptoNettleRSA *rsa =3D (QCryptoNettleRSA *)akcipher;
>> +
>> +    int ret;
>=20
> Initialize to -1 here.
>=20
>> +    mpz_t s;
>> +
>> +    /**
>> +     * The RSA algorithm cannot be used for signature/verification
>> +     * without padding.
>> +     */
>> +    if (rsa->padding_alg =3D=3D QCRYPTO_RSA_PADDING_ALG_RAW) {
>> +        error_setg(errp, "Operation not supported");
>> +        return -1;
>> +    }
>> +    if (data_len > rsa->pub.size || sig_len < rsa->pub.size) {
>> +        error_setg(errp, "Invalid buffer size");
>> +        return -1;
>> +    }
>=20
> Ssame note as earlier methods
>=20
>> +
>> +    nettle_mpz_init_set_str_256_u(s, sig_len, sig);
>> +    switch (rsa->hash_alg) {
>> +    case QCRYPTO_HASH_ALG_MD5:
>> +        ret =3D rsa_md5_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA1:
>> +        ret =3D rsa_sha1_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA256:
>> +        ret =3D rsa_sha256_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    case QCRYPTO_HASH_ALG_SHA512:
>> +        ret =3D rsa_sha512_verify_digest(&rsa->pub, data, s);
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unsupported hash algorithm");
>> +        ret =3D -1;
>=20
> Skip this
>=20
>> +        goto cleanup;
>> +    }
>> +
>> +    if (ret !=3D 1) {
>> +        error_setg(errp, "Failed to verify");
>> +        ret =3D -1;
>> +        goto cleanup;
>> +    }
>> +    ret =3D 0;
>> +
>> +cleanup:
>> +    mpz_clear(s);
>> +
>> +    return ret;
>> +}
>> +
>> +QCryptoAkCipherDriver nettle_rsa =3D {
>> +    .encrypt =3D qcrypto_nettle_rsa_encrypt,
>> +    .decrypt =3D qcrypto_nettle_rsa_decrypt,
>> +    .sign =3D qcrypto_nettle_rsa_sign,
>> +    .verify =3D qcrypto_nettle_rsa_verify,
>> +    .free =3D qcrypto_nettle_rsa_free,
>> +};
>> +
>> +static QCryptoAkCipher *qcrypto_nettle_rsa_new(
>> +    const QCryptoAkCipherOptionsRSA *opt,
>> +    QCryptoAkCipherKeyType type,
>> +    const uint8_t *key, size_t keylen,
>> +    Error **errp)
>> +{
>> +    QCryptoNettleRSA *rsa =3D g_new0(QCryptoNettleRSA, 1);
>> +
>> +    rsa->padding_alg =3D opt->padding_alg;
>> +    rsa->hash_alg =3D opt->hash_alg;
>> +    rsa->akcipher.driver =3D &nettle_rsa;
>> +    rsa_public_key_init(&rsa->pub);
>> +    rsa_private_key_init(&rsa->priv);
>> +
>> +    switch (type) {
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
>> +        if (qcrypt_nettle_parse_rsa_private_key(rsa, key, keylen) !=3D=
 0) {
>> +            error_setg(errp, "Failed to parse rsa private key");
>> +            goto error;
>> +        }
>> +        break;
>> +
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
>> +        if (qcrypt_nettle_parse_rsa_public_key(rsa, key, keylen) !=3D =
0) {
>> +            error_setg(errp, "Failed to parse rsa public rsa key");
>> +            goto error;
>> +        }
>> +        break;
>> +
>> +    default:
>> +        error_setg(errp, "Unknown akcipher key type %d", type);
>> +        goto error;
>> +    }
>> +
>> +    return (QCryptoAkCipher *)rsa;
>> +
>> +error:
>> +    qcrypto_nettle_rsa_free((QCryptoAkCipher *)rsa);
>> +    return NULL;
>> +}
>> +
>> +
>> +bool qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
>> +{
>> +    switch (opts->alg) {
>> +    case QCRYPTO_AKCIPHER_ALG_RSA:
>> +        switch (opts->u.rsa.padding_alg) {
>> +        case QCRYPTO_RSA_PADDING_ALG_PKCS1:
>> +            switch (opts->u.rsa.hash_alg) {
>> +            case QCRYPTO_HASH_ALG_MD5:
>> +            case QCRYPTO_HASH_ALG_SHA1:
>> +            case QCRYPTO_HASH_ALG_SHA256:
>> +            case QCRYPTO_HASH_ALG_SHA512:
>> +                return true;
>> +
>> +            default:
>> +                return false;
>> +            }
>> +
>> +        case QCRYPTO_RSA_PADDING_ALG_RAW:
>> +        default:
>> +            return false;
>> +        }
>> +        break;
>> +
>> +    default:
>> +        return false;
>> +    }
>> +}
>> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
>> index ab28bf415b..f287083f92 100644
>> --- a/crypto/akcipher.c
>> +++ b/crypto/akcipher.c
>> @@ -23,6 +23,9 @@
>> #include "crypto/akcipher.h"
>> #include "akcipherpriv.h"
>>=20
>> +#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
>> +#include "akcipher-nettle.c.inc"
>> +#else
>> QCryptoAkCipher *qcrypto_akcipher_new(const QCryptoAkCipherOptions =
*opts,
>>                                       QCryptoAkCipherKeyType type,
>>                                       const uint8_t *key, size_t =
keylen,
>> @@ -37,6 +40,7 @@ bool =
qcrypto_akcipher_supports(QCryptoAkCipherOptions *opts)
>> {
>>     return false;
>> }
>> +#endif
>>=20
>> int qcrypto_akcipher_encrypt(QCryptoAkCipher *akcipher,
>>                              const void *in, size_t in_len,
>> diff --git a/crypto/meson.build b/crypto/meson.build
>> index c9b36857a6..d9294eed83 100644
>> --- a/crypto/meson.build
>> +++ b/crypto/meson.build
>> @@ -21,10 +21,14 @@ crypto_ss.add(files(
>>   'tlscredspsk.c',
>>   'tlscredsx509.c',
>>   'tlssession.c',
>> +  'rsakey.c',
>> ))
>>=20
>> if nettle.found()
>>   crypto_ss.add(nettle, files('hash-nettle.c', 'hmac-nettle.c', =
'pbkdf-nettle.c'))
>> +  if hogweed.found()
>> +    crypto_ss.add(gmp, hogweed)
>> +  endif
>>   if xts =3D=3D 'private'
>>     crypto_ss.add(files('xts.c'))
>>   endif
>> diff --git a/crypto/rsakey-builtin.c.inc =
b/crypto/rsakey-builtin.c.inc
>> new file mode 100644
>> index 0000000000..0a93712f4f
>> --- /dev/null
>> +++ b/crypto/rsakey-builtin.c.inc
>> @@ -0,0 +1,209 @@
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
>> +#include "der.h"
>> +#include "rsakey.h"
>> +
>> +static int extract_mpi(void *ctx, const uint8_t *value,
>> +                       size_t vlen, Error **errp)
>> +{
>> +    QCryptoAkCipherMPI *mpi =3D (QCryptoAkCipherMPI *)ctx;
>> +    if (vlen =3D=3D 0) {
>> +        error_setg(errp, "Empty mpi field");
>> +        return -1;
>> +    }
>> +    mpi->data =3D g_memdup2(value, vlen);
>> +    mpi->len =3D vlen;
>> +    return 0;
>> +}
>> +
>> +static int extract_version(void *ctx, const uint8_t *value,
>> +                           size_t vlen, Error **errp)
>> +{
>> +    uint8_t *version =3D (uint8_t *)ctx;
>> +    if (vlen !=3D 1 || *value > 1) {
>> +        error_setg(errp, "Invalid rsakey version");
>> +        return -1;
>> +    }
>> +    *version =3D *value;
>> +    return 0;
>> +}
>> +
>> +static int extract_seq_content(void *ctx, const uint8_t *value,
>> +                               size_t vlen, Error **errp)
>> +{
>> +    const uint8_t **content =3D (const uint8_t **)ctx;
>> +    if (vlen =3D=3D 0) {
>> +        error_setg(errp, "Empty sequence");
>> +        return -1;
>> +    }
>> +    *content =3D value;
>> +    return 0;
>> +}
>> +
>> +/**
>> + *
>> + *        RsaPubKey ::=3D SEQUENCE {
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *         }
>> + */
>> +static QCryptoAkCipherRSAKey *qcrypto_builtin_rsa_public_key_parse(
>> +    const uint8_t *key, size_t keylen)
>> +{
>> +    QCryptoAkCipherRSAKey *rsa =3D g_new0(QCryptoAkCipherRSAKey, 1);
>> +    const uint8_t *seq;
>> +    size_t seq_length;
>> +    int decode_ret;
>> +    Error *local_error =3D NULL;
>> +
>> +    decode_ret =3D qcrypto_der_decode_seq(&key, &keylen,
>> +        extract_seq_content, &seq, &local_error);
>> +    if (decode_ret < 0) {
>> +        error_report_err(local_error);
>=20
> Nothing in the crypto/ directory should ever call error_report_err.
> Any methods  which can fail need to have an 'Error **errp' parameter
> and propagate this back to the caller(s).
>=20
>> +        goto error;
>> +    }
>> +    if (keylen !=3D 0) {
>> +        goto error;
>> +    }
>> +    seq_length =3D decode_ret;
>> +
>> +    if (qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
>> +                               &rsa->n, &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
>> +                               &rsa->e, &local_error) < 0) {
>> +        error_report_err(local_error);
>> +        goto error;
>> +    }
>> +    if (seq_length !=3D 0) {
>> +        goto error;
>> +    }
>> +
>> +    return rsa;
>> +
>> +error:
>> +    qcrypto_akcipher_rsakey_free(rsa);
>> +    return NULL;
>> +}
>> +
>> +/**
>> + *        RsaPrivKey ::=3D SEQUENCE {
>> + *             version     INTEGER
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *             d           INTEGER
>> + *             p           INTEGER
>> + *             q           INTEGER
>> + *             dp          INTEGER
>> + *             dq          INTEGER
>> + *             u           INTEGER
>> + *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
>> + *         }
>> + */
>> +static QCryptoAkCipherRSAKey *qcrypto_builtin_rsa_private_key_parse(
>> +    const uint8_t *key, size_t keylen)
>> +{
>> +    QCryptoAkCipherRSAKey *rsa =3D g_new0(QCryptoAkCipherRSAKey, 1);
>> +    uint8_t version;
>> +    const uint8_t *seq;
>> +    int decode_ret;
>> +    size_t seq_length;
>> +    Error *local_error =3D NULL;
>> +
>> +    decode_ret =3D qcrypto_der_decode_seq(&key, &keylen,
>> +        extract_seq_content, &seq, &local_error);
>> +    if (decode_ret < 0) {
>> +        error_report_err(local_error);
>> +        goto error;
>> +    }
>> +    if (keylen !=3D 0) {
>> +        goto error;
>> +    }
>> +    seq_length =3D decode_ret;
>> +
>> +    decode_ret =3D qcrypto_der_decode_int(&seq, &seq_length, =
extract_version,
>> +                                        &version, &local_error);
>> +    if (decode_ret < 0) {
>> +        error_report_err(local_error);
>> +        goto error;
>> +    }
>> +
>> +    if (qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
>> +                               &rsa->n, &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
>> +                               &rsa->e, &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi,
>> +                               &rsa->d, &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, =
&rsa->p,
>> +                               &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, =
&rsa->q,
>> +                               &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, =
&rsa->dp,
>> +                               &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, =
&rsa->dq,
>> +                               &local_error) < 0 ||
>> +        qcrypto_der_decode_int(&seq, &seq_length, extract_mpi, =
&rsa->u,
>> +                               &local_error) < 0) {
>> +        error_report_err(local_error);
>> +        goto error;
>> +    }
>> +    /**
>> +     * According to the standard, otherPrimeInfos must be present =
for version 1.
>> +     * There is no strict verification here, this is to be =
compatible with
>> +     * the unit test of the kernel. TODO: remove this until linux =
kernel's
>> +     * unit-test is fixed.
>> +     */
>> +    if (version =3D=3D 1 && seq_length !=3D 0) {
>> +        if (qcrypto_der_decode_seq(&seq, &seq_length,
>> +                                   NULL, NULL, &local_error) < 0) {
>> +            error_report_err(local_error);
>> +            goto error;
>> +        }
>> +        if (seq_length !=3D 0) {
>> +            goto error;
>> +        }
>> +        return rsa;
>> +    }
>> +    if (seq_length !=3D 0) {
>> +        goto error;
>> +    }
>> +
>> +    return rsa;
>> +
>> +error:
>> +    qcrypto_akcipher_rsakey_free(rsa);
>> +    return NULL;
>> +}
>> +
>> +QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
>> +    QCryptoAkCipherKeyType type, const uint8_t *key, size_t keylen)
>> +{
>> +    switch (type) {
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
>> +        return qcrypto_builtin_rsa_private_key_parse(key, keylen);
>> +
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
>> +        return qcrypto_builtin_rsa_public_key_parse(key, keylen);
>> +
>> +    default:
>> +        return NULL;
>> +    }
>> +}
>> diff --git a/crypto/rsakey-nettle.c.inc b/crypto/rsakey-nettle.c.inc
>> new file mode 100644
>> index 0000000000..2c89b3be88
>> --- /dev/null
>> +++ b/crypto/rsakey-nettle.c.inc
>> @@ -0,0 +1,154 @@
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
>> +#include <nettle/asn1.h>
>> +#include <stdbool.h>
>> +
>> +#include "rsakey.h"
>> +
>> +static bool DumpMPI(struct asn1_der_iterator *i, QCryptoAkCipherMPI =
*mpi)
>> +{
>> +    mpi->data =3D g_memdup2(i->data, i->length);
>> +    mpi->len =3D i->length;
>> +    return true;
>> +}
>> +
>> +static bool GetMPI(struct asn1_der_iterator *i, QCryptoAkCipherMPI =
*mpi)
>> +{
>> +    if (asn1_der_iterator_next(i) !=3D ASN1_ITERATOR_PRIMITIVE ||
>> +        i->type !=3D ASN1_INTEGER) {
>> +        return false;
>> +    }
>> +    return DumpMPI(i, mpi);
>> +}
>> +
>> +
>> +/**
>> + *        RsaPrivKey ::=3D SEQUENCE {
>> + *             version     INTEGER
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *             d           INTEGER
>> + *             p           INTEGER
>> + *             q           INTEGER
>> + *             dp          INTEGER
>> + *             dq          INTEGER
>> + *             u           INTEGER
>> + *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
>> + *         }
>> + */
>> +static QCryptoAkCipherRSAKey *qcrypto_nettle_rsa_private_key_parse(
>> +    const uint8_t *key, size_t keylen)
>> +{
>> +    QCryptoAkCipherRSAKey *rsa =3D g_new0(QCryptoAkCipherRSAKey, 1);
>> +    struct asn1_der_iterator i;
>> +    uint32_t version;
>> +    int tag;
>> +
>> +    /* Parse entire struct */
>> +    if (asn1_der_iterator_first(&i, keylen, key) !=3D =
ASN1_ITERATOR_CONSTRUCTED ||
>> +        i.type !=3D ASN1_SEQUENCE ||
>> +        asn1_der_decode_constructed_last(&i) !=3D =
ASN1_ITERATOR_PRIMITIVE ||
>> +        i.type !=3D ASN1_INTEGER ||
>> +        !asn1_der_get_uint32(&i, &version) ||
>> +        version > 1 ||
>> +        !GetMPI(&i, &rsa->n) ||
>> +        !GetMPI(&i, &rsa->e) ||
>> +        !GetMPI(&i, &rsa->d) ||
>> +        !GetMPI(&i, &rsa->p) ||
>> +        !GetMPI(&i, &rsa->q) ||
>> +        !GetMPI(&i, &rsa->dp) ||
>> +        !GetMPI(&i, &rsa->dq) ||
>> +        !GetMPI(&i, &rsa->u)) {
>> +        goto error;
>> +    }
>> +
>> +    if (version =3D=3D 1) {
>> +        tag =3D asn1_der_iterator_next(&i);
>> +        /**
>> +         * According to the standard otherPrimeInfos must be present =
for
>> +         * version 1. There is no strict verification here, this is =
to be
>> +         * compatible with the unit test of the kernel. TODO: remove =
this
>> +         * until linux-kernel's unit-test is fixed;
>> +         */
>> +        if (tag =3D=3D ASN1_ITERATOR_END) {
>> +            return rsa;
>> +        }
>> +        if (tag !=3D ASN1_ITERATOR_CONSTRUCTED ||
>> +            i.type !=3D ASN1_SEQUENCE) {
>> +            goto error;
>> +        }
>> +    }
>> +
>> +    if (asn1_der_iterator_next(&i) !=3D ASN1_ITERATOR_END) {
>> +        goto error;
>> +    }
>> +
>> +    return rsa;
>> +
>> +error:
>> +    qcrypto_akcipher_rsakey_free(rsa);
>> +    return NULL;
>> +}
>> +
>> +/**
>> + *        RsaPubKey ::=3D SEQUENCE {
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *         }
>> + */
>> +static QCryptoAkCipherRSAKey *qcrypto_nettle_rsa_public_key_parse(
>> +    const uint8_t *key, size_t keylen)
>> +{
>> +
>> +    QCryptoAkCipherRSAKey *rsa =3D g_new0(QCryptoAkCipherRSAKey, 1);
>> +    struct asn1_der_iterator i;
>> +
>> +    if (asn1_der_iterator_first(&i, keylen, key) !=3D =
ASN1_ITERATOR_CONSTRUCTED ||
>> +        i.type !=3D ASN1_SEQUENCE ||
>> +        asn1_der_decode_constructed_last(&i) !=3D =
ASN1_ITERATOR_PRIMITIVE ||
>> +        !DumpMPI(&i, &rsa->n) ||
>> +        !GetMPI(&i, &rsa->e) ||
>> +        asn1_der_iterator_next(&i) !=3D ASN1_ITERATOR_END) {
>> +        goto error;
>> +    }
>> +
>> +    return rsa;
>> +
>> +error:
>> +    qcrypto_akcipher_rsakey_free(rsa);
>> +    return NULL;
>> +}
>> +
>> +QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
>> +    QCryptoAkCipherKeyType type, const uint8_t *key, size_t keylen)
>> +{
>> +    switch (type) {
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PRIVATE:
>> +        return qcrypto_nettle_rsa_private_key_parse(key, keylen);
>> +
>> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
>> +        return qcrypto_nettle_rsa_public_key_parse(key, keylen);
>> +
>> +    default:
>> +        return NULL;
>> +    }
>> +}
>> diff --git a/crypto/rsakey.c b/crypto/rsakey.c
>> new file mode 100644
>> index 0000000000..cc40e072f0
>> --- /dev/null
>> +++ b/crypto/rsakey.c
>> @@ -0,0 +1,44 @@
>> +/*
>> + * QEMU Crypto RSA key parser
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
>> +#include "rsakey.h"
>> +
>> +void qcrypto_akcipher_rsakey_free(QCryptoAkCipherRSAKey *rsa_key)
>> +{
>> +    if (!rsa_key) {
>> +        return;
>> +    }
>> +    g_free(rsa_key->n.data);
>> +    g_free(rsa_key->e.data);
>> +    g_free(rsa_key->d.data);
>> +    g_free(rsa_key->p.data);
>> +    g_free(rsa_key->q.data);
>> +    g_free(rsa_key->dp.data);
>> +    g_free(rsa_key->dq.data);
>> +    g_free(rsa_key->u.data);
>> +    g_free(rsa_key);
>> +}
>> +
>> +#if defined(CONFIG_NETTLE) && defined(CONFIG_HOGWEED)
>> +#include "rsakey-nettle.c.inc"
>> +#else
>> +#include "rsakey-builtin.c.inc"
>> +#endif
>> diff --git a/crypto/rsakey.h b/crypto/rsakey.h
>> new file mode 100644
>> index 0000000000..a1e04ae021
>> --- /dev/null
>> +++ b/crypto/rsakey.h
>> @@ -0,0 +1,94 @@
>> +/*
>> + * QEMU Crypto RSA key parser
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
>> +#ifndef QCRYPTO_RSAKEY_H
>> +#define QCRYPTO_RSAKEY_H
>> +
>> +#include <nettle/bignum.h>
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/host-utils.h"
>> +#include "crypto/akcipher.h"
>> +
>> +typedef struct QCryptoAkCipherRSAKey QCryptoAkCipherRSAKey;
>> +typedef struct QCryptoAkCipherMPI QCryptoAkCipherMPI;
>> +
>> +/**
>> + * Multiple precious integer, encoded as two' complement,
>> + * copied directly from DER encoded ASN.1 structures.
>> + */
>> +struct QCryptoAkCipherMPI {
>> +    uint8_t *data;
>> +    size_t len;
>> +};
>> +
>> +/* See rfc2437: https://datatracker.ietf.org/doc/html/rfc2437 */
>> +struct QCryptoAkCipherRSAKey {
>> +    /* The modulus */
>> +    QCryptoAkCipherMPI n;
>> +    /* The public exponent */
>> +    QCryptoAkCipherMPI e;
>> +    /* The private exponent */
>> +    QCryptoAkCipherMPI d;
>> +    /* The first factor */
>> +    QCryptoAkCipherMPI p;
>> +    /* The second factor */
>> +    QCryptoAkCipherMPI q;
>> +    /* The first factor's exponent */
>> +    QCryptoAkCipherMPI dp;
>> +    /* The second factor's exponent */
>> +    QCryptoAkCipherMPI dq;
>> +    /* The CRT coefficient */
>> +    QCryptoAkCipherMPI u;
>> +};
>> +
>> +/**
>> + * Parse DER encoded ASN.1 RSA keys, expected ASN.1 schemas:
>> + *        RsaPrivKey ::=3D SEQUENCE {
>> + *             version     INTEGER
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *             d           INTEGER
>> + *             p           INTEGER
>> + *             q           INTEGER
>> + *             dp          INTEGER
>> + *             dq          INTEGER
>> + *             u           INTEGER
>> + *       otherPrimeInfos   OtherPrimeInfos OPTIONAL
>> + *         }
>> + *
>> + *        RsaPubKey ::=3D SEQUENCE {
>> + *             n           INTEGER
>> + *             e           INTEGER
>> + *         }
>> + *
>> + * Returns: On success QCryptoAkCipherRSAKey is returned, otherwise =
returns NULL
>> + */
>> +QCryptoAkCipherRSAKey *qcrypto_akcipher_rsakey_parse(
>> +    QCryptoAkCipherKeyType type,
>> +    const uint8_t *key, size_t keylen);
>> +
>> +void qcrypto_akcipher_rsakey_free(QCryptoAkCipherRSAKey *key);
>> +
>> +G_DEFINE_AUTOPTR_CLEANUP_FUNC(QCryptoAkCipherRSAKey,
>> +                              qcrypto_akcipher_rsakey_free);
>> +
>> +#endif
>> diff --git a/meson.build b/meson.build
>> index d083c6b7bf..fd0bf7aa5d 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -1049,6 +1049,7 @@ endif
>> # gcrypt over nettle for performance reasons.
>> gcrypt =3D not_found
>> nettle =3D not_found
>> +hogweed =3D not_found
>> xts =3D 'none'
>>=20
>> if get_option('nettle').enabled() and get_option('gcrypt').enabled()
>> @@ -1086,6 +1087,15 @@ if not gnutls_crypto.found()
>>   endif
>> endif
>>=20
>> +gmp =3D dependency('gmp', required: false, method: 'pkg-config', =
kwargs: static_kwargs)
>> +if nettle.found() and gmp.found()
>> +  hogweed =3D dependency('hogweed', version: '>=3D3.4',
>> +                       method: 'pkg-config',
>> +                       required: get_option('nettle'),
>> +                       kwargs: static_kwargs)
>> +endif
>> +
>> +
>> gtk =3D not_found
>> gtkx11 =3D not_found
>> vte =3D not_found
>> @@ -1567,6 +1577,7 @@ config_host_data.set('CONFIG_GNUTLS', =
gnutls.found())
>> config_host_data.set('CONFIG_GNUTLS_CRYPTO', gnutls_crypto.found())
>> config_host_data.set('CONFIG_GCRYPT', gcrypt.found())
>> config_host_data.set('CONFIG_NETTLE', nettle.found())
>> +config_host_data.set('CONFIG_HOGWEED', hogweed.found())
>> config_host_data.set('CONFIG_QEMU_PRIVATE_XTS', xts =3D=3D 'private')
>> config_host_data.set('CONFIG_MALLOC_TRIM', has_malloc_trim)
>> config_host_data.set('CONFIG_STATX', has_statx)
>> --=20
>> 2.20.1
>>=20
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

