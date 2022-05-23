Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2214C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 23 May 2022 09:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiEWJm3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 May 2022 05:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiEWJk2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 May 2022 05:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4BAA2B18D
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653298826;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=Nx0F2upiPenzA/N8IHYkNFz5WS3VzOzTAlo4y6sAXjA=;
        b=W8GtHjoN+YloKlY2Km9Cn75w5ZlfRvlsdQVmRAnk71F6XpuQ3IRqAzdb7vA+CPD3apT+32
        Aif2cgLRwR8oKLEYFzsyrFJR4w9fJk4q58NcnVJNhQ9dFYHViZ1oPrfA8w+uk9ljfnX423
        m56/n5mRgzxCyNX9rICSyPy11UQmn+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-CtaIJETkONef60Hv_PfcFw-1; Mon, 23 May 2022 05:40:23 -0400
X-MC-Unique: CtaIJETkONef60Hv_PfcFw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA6C580419C;
        Mon, 23 May 2022 09:40:22 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CFA4492CA2;
        Mon, 23 May 2022 09:40:21 +0000 (UTC)
Date:   Mon, 23 May 2022 10:40:19 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v6 6/9] crypto: Implement RSA algorithm by gcrypt
Message-ID: <YotWg3KXjbyx9CrN@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220514005504.1042884-1-pizhenwei@bytedance.com>
 <20220514005504.1042884-7-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220514005504.1042884-7-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 14, 2022 at 08:55:01AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Added gcryt implementation of RSA algorithm, RSA algorithm
> implemented by gcrypt has a higher priority than nettle because
> it supports raw padding.
> 
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
>  crypto/akcipher-gcrypt.c.inc | 597 +++++++++++++++++++++++++++++++++++
>  crypto/akcipher.c            |   4 +-
>  2 files changed, 600 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/akcipher-gcrypt.c.inc
> 
> diff --git a/crypto/akcipher-gcrypt.c.inc b/crypto/akcipher-gcrypt.c.inc
> new file mode 100644
> index 0000000000..6c5daa301e
> --- /dev/null
> +++ b/crypto/akcipher-gcrypt.c.inc
> @@ -0,0 +1,597 @@
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
> +        if (qcrypto_gcrypt_parse_rsa_private_key(rsa, key, keylen, errp) != 0) {
> +            error_setg(errp, "Failed to parse rsa private key");

Not need now, since qcrypto_gcrypt_parse_rsa_private_key reports the
real error message.

> +            goto error;
> +        }
> +        break;
> +
> +    case QCRYPTO_AKCIPHER_KEY_TYPE_PUBLIC:
> +        if (qcrypto_gcrypt_parse_rsa_public_key(rsa, key, keylen, errp) != 0) {
> +            error_setg(errp, "Failed to parse rsa public rsa key");

Likewise not needed.

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

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

