Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEEDC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 12:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbiCWMiP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 08:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiCWMiO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 08:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F31367B54D
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 05:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648039003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fa9QTM48OUejCQPoDl5NAKjvkdcSmGmWd5J/s9MvAqs=;
        b=EEklwHqWQ57LuxND1eHovVQm2K2c28TasU8mr2iM6rUtvMnbbz9mjKuHKSCgficl2JsgG2
        Lq8BU2UCqJu/vUdm51joK0fCfPD4CQHSzcFTW1wFUvv6GlI06UQKnl0SCJ7lF+I4QxLW2C
        oC9PlR6pOJlZDgdkdVj9IOdqorg728Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-TPOiBl7nNc6I16Kxup6APg-1; Wed, 23 Mar 2022 08:36:41 -0400
X-MC-Unique: TPOiBl7nNc6I16Kxup6APg-1
Received: by mail-wm1-f71.google.com with SMTP id r9-20020a1c4409000000b0038c15a1ed8cso2744258wma.7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 05:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fa9QTM48OUejCQPoDl5NAKjvkdcSmGmWd5J/s9MvAqs=;
        b=NPzqmSBcQziCFxv2BKcpyiqxgupIiXlab1nk4yx77/6Ch7esbMjg7Z7a5G/ZAnvGJJ
         /Tk76DyV7xDjEoTZWskXCT0ENWVw1QvoBBvMWJ6ieTXGWNRMy7Xd7Mc3z0mR0arG/vjQ
         yuIcXGQI2bqjTsVC4wKy6AF3VAGygP7fgJYn+YdWakUeymaMRHtBd6rcoGsQAc4TcMMr
         FXsjCQCCKom1Yg4p6DCTIcm+GJ0Gc5WqeW5ttf69Oe23bfdAcsO9lKB2UYoPCorvxKVJ
         RRMVhTjF/tRxyxek17peUmaSLamIvrL1ZQTFzjwDKDaqwGqUcS07bDu6cfg4k06RhOgl
         BIZA==
X-Gm-Message-State: AOAM533MROhaEIjYugJrgnLHjOZIUO/8CVFWyymlbF0i/E/vene4DHW3
        +a1Pjnjyl7UDjGU8VqYM0wxDWiWPUhbZOeU6MIwWYQJXEgU51tNfhSigYGfNQQKS+RdcIN/Em2z
        AP3evBEP+XjSDVjALjK0d2DWA
X-Received: by 2002:a5d:6b0b:0:b0:1ef:d826:723a with SMTP id v11-20020a5d6b0b000000b001efd826723amr27400457wrw.420.1648039000395;
        Wed, 23 Mar 2022 05:36:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBxeWRoCDIdMerVIOvtlAnOjiNcVTIj/UD5hdtcw5XobeVf2TSLgENh4CA6UmlgZGf3azmWw==
X-Received: by 2002:a5d:6b0b:0:b0:1ef:d826:723a with SMTP id v11-20020a5d6b0b000000b001efd826723amr27400445wrw.420.1648039000212;
        Wed, 23 Mar 2022 05:36:40 -0700 (PDT)
Received: from redhat.com ([2.55.151.118])
        by smtp.gmail.com with ESMTPSA id r15-20020a5d6c6f000000b002040552e88esm11818773wrz.29.2022.03.23.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:36:39 -0700 (PDT)
Date:   Wed, 23 Mar 2022 08:36:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Message-ID: <20220323083558-mutt-send-email-mst@kernel.org>
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 10:49:06AM +0800, zhenwei pi wrote:
> v2 -> v3:
> - Introduce akcipher types to qapi
> - Add test/benchmark suite for akcipher class
> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>   - crypto: Introduce akcipher crypto class
>   - virtio-crypto: Introduce RSA algorithm

Thanks!
I tagged this but qemu is in freeze. If possible pls ping or
repost after the release to help make sure I don't lose it.

> v1 -> v2:
> - Update virtio_crypto.h from v2 version of related kernel patch.
> 
> v1:
> - Support akcipher for virtio-crypto.
> - Introduce akcipher class.
> - Introduce ASN1 decoder into QEMU.
> - Implement RSA backend by nettle/hogweed.
> 
> Lei He (3):
>   crypto-akcipher: Introduce akcipher types to qapi
>   crypto: Implement RSA algorithm by hogweed
>   tests/crypto: Add test suite for crypto akcipher
> 
> Zhenwei Pi (3):
>   virtio-crypto: header update
>   crypto: Introduce akcipher crypto class
>   virtio-crypto: Introduce RSA algorithm
> 
>  backends/cryptodev-builtin.c                  | 319 +++++++-
>  backends/cryptodev-vhost-user.c               |  34 +-
>  backends/cryptodev.c                          |  32 +-
>  crypto/akcipher-nettle.c                      | 523 +++++++++++++
>  crypto/akcipher.c                             |  81 ++
>  crypto/asn1_decoder.c                         | 185 +++++
>  crypto/asn1_decoder.h                         |  42 +
>  crypto/meson.build                            |   4 +
>  hw/virtio/virtio-crypto.c                     | 326 ++++++--
>  include/crypto/akcipher.h                     | 155 ++++
>  include/hw/virtio/virtio-crypto.h             |   5 +-
>  .../standard-headers/linux/virtio_crypto.h    |  82 +-
>  include/sysemu/cryptodev.h                    |  88 ++-
>  meson.build                                   |  11 +
>  qapi/crypto.json                              |  86 +++
>  tests/bench/benchmark-crypto-akcipher.c       | 163 ++++
>  tests/bench/meson.build                       |   6 +
>  tests/bench/test_akcipher_keys.inc            | 277 +++++++
>  tests/unit/meson.build                        |   1 +
>  tests/unit/test-crypto-akcipher.c             | 715 ++++++++++++++++++
>  20 files changed, 2990 insertions(+), 145 deletions(-)
>  create mode 100644 crypto/akcipher-nettle.c
>  create mode 100644 crypto/akcipher.c
>  create mode 100644 crypto/asn1_decoder.c
>  create mode 100644 crypto/asn1_decoder.h
>  create mode 100644 include/crypto/akcipher.h
>  create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>  create mode 100644 tests/bench/test_akcipher_keys.inc
>  create mode 100644 tests/unit/test-crypto-akcipher.c
> 
> -- 
> 2.25.1

