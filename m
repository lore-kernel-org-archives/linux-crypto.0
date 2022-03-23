Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D113AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 13:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbiCWNJ7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiCWNJz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 09:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 098B12AF6
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 06:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648040903;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=70BVFp/ay2GtzV9l/8pyutFT6h5mVJO5vmRO+wXGVxo=;
        b=GlfCOazb21J5quqEqAWGk1c585UoLuL21Znm6hMcZTztKsUC1hLD6DqwBmCNdlNZyfc8tB
        DRrdlFx1or3UqZ10s/vpbx9EZJgk4nsHf5VSBnZeK7S7JM0Q8zoppmACQeLT5vT+KsbiOF
        IdpDYXhTORbpqPW2HOtCpwMKFsPq4oo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-NABzQSV7NqqciiVi62vQng-1; Wed, 23 Mar 2022 09:08:22 -0400
X-MC-Unique: NABzQSV7NqqciiVi62vQng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8FAD29ABA29;
        Wed, 23 Mar 2022 13:08:21 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A93B1400E70;
        Wed, 23 Mar 2022 13:08:19 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:08:16 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com,
        herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, Lei He <helei.sig11@bytedance.com>
Subject: Re: [PATCH v3 2/6] crypto-akcipher: Introduce akcipher types to qapi
Message-ID: <YjsbwNhayhkVJ9G0@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
 <20220323024912.249789-3-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-3-pizhenwei@bytedance.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:08AM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> Introduce akcipher types, also include RSA & ECDSA related types.
> 
> Signed-off-by: Lei He <helei.sig11@bytedance.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  qapi/crypto.json | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/qapi/crypto.json b/qapi/crypto.json
> index 1ec54c15ca..d44c38e3b1 100644
> --- a/qapi/crypto.json
> +++ b/qapi/crypto.json
> @@ -540,3 +540,89 @@
>    'data': { '*loaded': { 'type': 'bool', 'features': ['deprecated'] },
>              '*sanity-check': 'bool',
>              '*passwordid': 'str' } }
> +##
> +# @QCryptoAkcipherAlgorithm:

Should be named  QCryptoAkCipherAlgorithm

> +#
> +# The supported algorithms for asymmetric encryption ciphers
> +#
> +# @rsa: RSA algorithm
> +# @ecdsa: ECDSA algorithm
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoAkcipherAlgorithm',
> +  'prefix': 'QCRYPTO_AKCIPHER_ALG',
> +  'data': ['rsa', 'ecdsa']}
> +
> +##
> +# @QCryptoAkcipherKeyType:

Should be named  QCryptoAkCipherKeyType

> +#
> +# The type of asymmetric keys.
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoAkcipherKeyType',
> +  'prefix': 'QCRYPTO_AKCIPHER_KEY_TYPE',
> +  'data': ['public', 'private']}
> +
> +##
> +# @QCryptoRsaHashAlgorithm:
> +#
> +# The hash algorithm for RSA pkcs1 padding algothrim
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoRsaHashAlgorithm',
> +  'prefix': 'QCRYPTO_RSA_HASH_ALG',
> +  'data': [ 'md2', 'md3', 'md4', 'md5', 'sha1', 'sha256', 'sha384', 'sha512', 'sha224' ]}

We already have QCryptoHashAlgorithm and I don't see the
benefit in duplicating it here.

We don't have md2, md3, and md4 in QCryptoHashAlgorithm, but
that doesn't look like a real negative as I can't imagine
those should be used today.

> +##
> +# @QCryptoRsaPaddingAlgorithm:
> +#
> +# The padding algorithm for RSA.
> +#
> +# @raw: no padding used
> +# @pkcs1: pkcs1#v1.5
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoRsaPaddingAlgorithm',
> +  'prefix': 'QCRYPTO_RSA_PADDING_ALG',
> +  'data': ['raw', 'pkcs1']}
> +
> +##
> +# @QCryptoCurveId:

Should be named  QCryptoCurveID

> +#
> +# The well-known curves, referenced from https://csrc.nist.gov/csrc/media/publications/fips/186/3/archive/2009-06-25/documents/fips_186-3.pdf
> +#
> +# Since: 7.0
> +##
> +{ 'enum': 'QCryptoCurveId',
> +  'prefix': 'QCRYPTO_CURVE_ID',
> +  'data': ['nist-p192', 'nist-p224', 'nist-p256', 'nist-p384', 'nist-p521']}


> +
> +##
> +# @QCryptoRsaOptions:

This should be named  QCryptoAkCipherOptionsRSA

> +#
> +# Specific parameters for RSA algorithm.
> +#
> +# @hash-algo: QCryptoRsaHashAlgorithm
> +# @padding-algo: QCryptoRsaPaddingAlgorithm
> +#
> +# Since: 7.0
> +##
> +{ 'struct': 'QCryptoRsaOptions',
> +  'data': { 'hash-algo':'QCryptoRsaHashAlgorithm',
> +            'padding-algo': 'QCryptoRsaPaddingAlgorithm'}}

Our naming convention is  'XXX-alg' rather than 'XXX-algo'.

> +
> +##
> +# @QCryptoEcdsaOptions:

This should be named  QCryptoAkCipherOptionsECDSA

> +#
> +# Specific parameter for ECDSA algorithm.
> +#
> +# @curve-id: QCryptoCurveId
> +#
> +# Since: 7.0
> +##
> +{ 'struct': 'QCryptoEcdsaOptions',
> +  'data': { 'curve-id': 'QCryptoCurveId' }}

Having these two structs standalone looks wrong to me. I suspect that
callers will need to be able to conditionally pass in either one, and
so require the API to use a discriminated union

  { 'union': 'QCryptoAkCipherOptions'
    'base': { 'algorithm': 'QCryptoAkCipherAlgorithm' },
    'discriminator': 'algorithm',
    'data': { 'rsa': 'QCryptoAkCipherOptionsRSA' ,
              'ecdsa': 'QCryptoAkCipherOptionsECDSA' } }


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

