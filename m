Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2ABC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 13:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244305AbiCWNfA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiCWNe7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 09:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 293461F616
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 06:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648042407;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=y5Rgz7zRBtwS9sgp9hliTVIYayavWePuczXPGQW/xDc=;
        b=HUYxt5Ly5wcfMO8P44jqWY2IFAwx9CHUka5TGm8JGw5XqMHoEObbKwxUTaqvm1ZxLXZyN4
        LE2kYWmKsWwuidbVO54oSwuWupv7etCkOFIaNzBbbDffggyoVkjq7/h9ofZZyEUr8F2dNx
        2cHKcAqyV1k0I49YljNGuVHELmrWRac=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-AS287SegM2Wd-SIAuhaOsg-1; Wed, 23 Mar 2022 09:33:24 -0400
X-MC-Unique: AS287SegM2Wd-SIAuhaOsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1F2F1C07831;
        Wed, 23 Mar 2022 13:33:23 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6543141ADA5;
        Wed, 23 Mar 2022 13:33:21 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:33:19 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com,
        herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, lei he <helei.sig11@bytedance.com>
Subject: Re: [PATCH v3 3/6] crypto: Introduce akcipher crypto class
Message-ID: <Yjshn2T0n0hyuup5@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-4-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-4-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:09AM +0800, zhenwei pi wrote:
> Support basic asymmetric operations: encrypt, decrypt, sign and
> verify.
> 
> Co-developed-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  crypto/akcipher.c         |  78 +++++++++++++++++++++
>  crypto/meson.build        |   1 +
>  include/crypto/akcipher.h | 139 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 218 insertions(+)
>  create mode 100644 crypto/akcipher.c
>  create mode 100644 include/crypto/akcipher.h
> 
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> new file mode 100644
> index 0000000000..1e52f2fd76
> --- /dev/null
> +++ b/crypto/akcipher.c
> @@ -0,0 +1,78 @@
> +/*
> + * QEMU Crypto akcipher algorithms
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: zhenwei pi <pizhenwei@bytedance.com>
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
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
> +#include "qapi/error.h"
> +#include "crypto/akcipher.h"
> +
> +QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
> +                                      QCryptoAkcipherKeyType type,
> +                                      const uint8_t *key, size_t keylen,
> +                                      void *para, Error **errp)
> +{
> +    QCryptoAkcipher *akcipher = NULL;
> +
> +    return akcipher;
> +}
> +
> +int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
> +                             const void *data, size_t data_len,
> +                             void *enc, size_t enc_len, Error **errp)
> +{
> +    const QCryptoAkcipherDriver *drv = akcipher->driver;
> +
> +    return drv->encrypt(akcipher, data, data_len, enc, enc_len, errp);
> +}
> +
> +int qcrypto_akcipher_decrypt(struct QCryptoAkcipher *akcipher,
> +                             const void *enc, size_t enc_len,
> +                             void *data, size_t data_len, Error **errp)
> +{
> +    const QCryptoAkcipherDriver *drv = akcipher->driver;
> +
> +    return drv->decrypt(akcipher, enc, enc_len, data, data_len, errp);
> +}
> +
> +int qcrypto_akcipher_sign(struct QCryptoAkcipher *akcipher,
> +                          const void *data, size_t data_len,
> +                          void *sig, size_t sig_len, Error **errp)
> +{
> +    const QCryptoAkcipherDriver *drv = akcipher->driver;
> +
> +    return drv->sign(akcipher, data, data_len, sig, sig_len, errp);
> +}
> +
> +int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,
> +                            const void *sig, size_t sig_len,
> +                            const void *data, size_t data_len, Error **errp)
> +{
> +    const QCryptoAkcipherDriver *drv = akcipher->driver;
> +
> +    return drv->verify(akcipher, sig, sig_len, data, data_len, errp);
> +}
> +
> +int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp)
> +{
> +    const QCryptoAkcipherDriver *drv = akcipher->driver;
> +
> +    return drv->free(akcipher, errp);
> +}
> diff --git a/crypto/meson.build b/crypto/meson.build
> index 19c44bea89..c32b57aeda 100644
> --- a/crypto/meson.build
> +++ b/crypto/meson.build
> @@ -19,6 +19,7 @@ crypto_ss.add(files(
>    'tlscredspsk.c',
>    'tlscredsx509.c',
>    'tlssession.c',
> +  'akcipher.c',
>  ))
>  
>  if nettle.found()
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> new file mode 100644
> index 0000000000..03cc3bf46b
> --- /dev/null
> +++ b/include/crypto/akcipher.h
> @@ -0,0 +1,139 @@
> +/*
> + * QEMU Crypto asymmetric algorithms
> + *
> + * Copyright (c) 2022 Bytedance
> + * Author: zhenwei pi <pizhenwei@bytedance.com>
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
> +#ifndef QCRYPTO_AKCIPHER_H
> +#define QCRYPTO_AKCIPHER_H
> +
> +#include "qemu/typedefs.h"
> +#include "qapi/qapi-types-crypto.h"
> +
> +typedef struct QCryptoAkcipher QCryptoAkcipher;
> +typedef struct QCryptoAkcipherDriver QCryptoAkcipherDriver;
> +
> +struct QCryptoAkcipherDriver {
> +    int (*encrypt)(struct QCryptoAkcipher *akcipher,
> +                   const void *data, size_t data_len,
> +                   void *enc, size_t enc_len, Error **errp);
> +    int (*decrypt)(struct QCryptoAkcipher *akcipher,
> +                   const void *enc, size_t enc_len,
> +                   void *data, size_t data_len, Error **errp);
> +    int (*sign)(struct QCryptoAkcipher *akcipher,
> +                const void *data, size_t data_len,
> +                void *sig, size_t sig_len, Error **errp);
> +    int (*verify)(struct QCryptoAkcipher *akcipher,
> +                  const void *sig, size_t sig_len,
> +                  const void *data, size_t data_len, Error **errp);
> +    int (*free)(struct QCryptoAkcipher *akcipher, Error **errp);
> +};
> +
> +struct QCryptoAkcipher {
> +    QCryptoAkcipherAlgorithm alg;
> +    QCryptoAkcipherKeyType type;
> +    uint8_t *key;
> +    size_t keylen;
> +    int max_plaintext_len;
> +    int max_ciphertext_len;
> +    int max_signature_len;
> +    int max_dgst_len;
> +    QCryptoAkcipherDriver *driver;
> +};

These two structs should be treated as private impl details for
the crypto subsystem, so they should not be exposed in the public
include/crypto/akcipher.h

There needs to be a crypto/akcipherpriv.h file, as we've done with
other APIs in crypto/*priv.h

Also, as with the QAPI def, I'd suggest QCryptoAkCipher as the
capitalization for all the structs.

> +
> +QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkcipherAlgorithm alg,
> +                                      QCryptoAkcipherKeyType type,
> +                                      const uint8_t *key, size_t keylen,
> +                                      void *para, Error **errp);

'void *para'  looks pretty dubious.  I suspect this is where 
it needs to be using the discriminated union for the options.
ie

 QCryptoAkcipher *qcrypto_akcipher_new(QCryptoAkCipherOptions opts,
                                       QCryptoAkcipherKeyType type,
                                       const uint8_t *key, size_t keylen,
                                       Error **errp);

> +
> +/**
> + * qcrypto_akcipher_encrypt:
> + * @akcipher: akcipher used to do encryption
> + * @data: plaintext pending to be encrypted
> + * @data_len: length of the plaintext, MUST less or equal
> + * akcipher->max_plaintext_len
> + * @enc: buffer to store the ciphertext
> + * @enc_len: the length of ciphertext buffer, usually equals to
> + * akcipher->max_ciphertext_len
> + * @errp: error pointer
> + *
> + * Encrypt data and write ciphertext into enc
> + *
> + * Returns: length of ciphertext if encrypt succeed, otherwise -1 is returned
> + */
> +int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
> +                             const void *data, size_t data_len,
> +                             void *enc, size_t enc_len, Error **errp);

I'd prefer to keep naming matching qcrypto_cipher_encrypt ie

 int qcrypto_akcipher_encrypt(QCryptoAkcipher *akcipher,
                              const void *in, size_t in_len,
                              void *out, size_t out_len,
			      Error **errp);

If thue caller njeeds to know about max_ciphertext_len, then we'll
need a API to query that, since the struct should be private.



> +/**
> + * qcrypto_akcipher_sign:
> + * @akcipher: akcipher used to generate signature
> + * @data: data to be signed
> + * @data_len: the length of data
> + * @sig: buffer to store the signature
> + * @sig_len: length of the signature buffer, usually equals to
> + * akcipher->max_signature_len
> + * @errp: error pointer
> + *
> + * Generate signature for data using akcipher
> + *
> + * Returns: length of signature if succeed, otherwise -1 is returned
> + */
> +int qcrypto_akcipher_sign(struct QCryptoAkcipher *akcipher,

Using 'struct' is redundant - use the typedef.

> +                          const void *data, size_t data_len,
> +                          void *sig, size_t sig_len, Error **errp);



> +
> +/**
> + * qcrypto_akcipher_verify:
> + * @akcipher: akcipher used to do verifycation
> + * @sig: pointer to the signature
> + * @sig_len: length of the signature
> + * @data: pointer to original data
> + * @data_len: the length of data
> + * @errp: error pointer
> + *
> + * Verify the signature and the data match or not
> + *
> + * Returns: 0 for succeed, otherwise -1 is returned
> + */
> +int qcrypto_akcipher_verify(struct QCryptoAkcipher *akcipher,

Using 'struct' is redundant - use the typedef.

> +                            const void *sig, size_t sig_len,
> +                            const void *data, size_t data_len, Error **errp);
> +
> +int qcrypto_akcipher_free(struct QCryptoAkcipher *akcipher, Error **errp);

Using 'struct' is redundant - use the typedef.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

