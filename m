Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EA4CCA479
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jun 2022 11:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381539AbiFQLCp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jun 2022 07:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382299AbiFQLCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jun 2022 07:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C2956CAA8
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jun 2022 04:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655463741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ziFOWbv9by8WUWOuHr9i3fD+ni8iVbPClUxuq+yU6N4=;
        b=dfL9y/qQwPUY299SmRJW/Dd2MjnVj3J3s70jh245B57fmYty6Pts9ZmphlCQ6BjoR7fDN1
        r2WdWv2l11ZabIUwL6OW7nD/NhsFwGr6x+zrr7E6YC+XV7A6R6Ub545I6MZLgSjPHxuD1F
        ylwc7iZCzd2JJDjExUnRJgOip8fOrVY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-zdANyfOzOMaw-H4c2HfTNA-1; Fri, 17 Jun 2022 07:02:20 -0400
X-MC-Unique: zdANyfOzOMaw-H4c2HfTNA-1
Received: by mail-wm1-f70.google.com with SMTP id be12-20020a05600c1e8c00b0039c506b52a4so3596964wmb.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jun 2022 04:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ziFOWbv9by8WUWOuHr9i3fD+ni8iVbPClUxuq+yU6N4=;
        b=Owxpxwr2yGPj+QYxhYFTcURJkHq3/8LG8EHnWL1Bgi7HGvbPIY67Qq302SFtS2mIei
         8qEwNDe1gR51R0oSIVH9MYnmVlFuEuY4pbaf7A4OT+polGaZ4hNXH7HmP87gqhwpd4lt
         emMu+X4u3YRk/xvWAg7CpWcBTXwX0HIQbNqREPHnYgIIuNUeDsGrVNw+0nDwH1xPUvM4
         FZZOVD+gWitP32W89SDIEjYDz9pkMsaiUarVny51RbCB3ECoAQLAomi8tmYoUc1Es0pg
         AxSaMtJrUKgF4du1Ys6Pdc7e0jHGhfefWmKjeLDqNE9UixcUMQnjR+9+3EVhz4VY7dz+
         lZrg==
X-Gm-Message-State: AOAM533iSkeAOnlyBBFTNDST68UvSLuR1eZTacmtV0I/s4xwb5cZRsqN
        /JZ5XoZZVxB6wGTsciCuSatzAoQZcjfEhAxaDOWpqEjzTlzBzo0a9IRuSvH8C3axQYKdoMd4Td5
        ttu9YfDFWwr8lEmR58I+yUt93
X-Received: by 2002:a05:600c:1d94:b0:39c:68c0:403b with SMTP id p20-20020a05600c1d9400b0039c68c0403bmr20288841wms.125.1655463739485;
        Fri, 17 Jun 2022 04:02:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrl+Er1GbwVnF2EfagbXzpVeEsnXyeknhzxoI7syjv6S3yxm+1wOc0XP849K+/8yys6OUzvg==
X-Received: by 2002:a05:600c:1d94:b0:39c:68c0:403b with SMTP id p20-20020a05600c1d9400b0039c68c0403bmr20288821wms.125.1655463739205;
        Fri, 17 Jun 2022 04:02:19 -0700 (PDT)
Received: from redhat.com ([2.54.189.19])
        by smtp.gmail.com with ESMTPSA id f15-20020a5d568f000000b00213b93cff5fsm4121938wrv.98.2022.06.17.04.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 04:02:18 -0700 (PDT)
Date:   Fri, 17 Jun 2022 07:02:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        dhowells@redhat.com, arei.gonglei@huawei.com, jasowang@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com, f4bug@amsat.org, berrange@redhat.com
Subject: Re: [PATCH 0/4] virtio-crypto: support ECDSA algorithm
Message-ID: <20220617070201-mutt-send-email-mst@kernel.org>
References: <20220617070754.73667-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617070754.73667-1-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 17, 2022 at 03:07:49PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> This patch supports the ECDSA algorithm for virtio-crypto:
> 1. fixed the problem that the max_signature_size of ECDSA is
> incorrectly calculated.
> 2. make pkcs8_private_key_parser can identify ECDSA private keys.
> 3. implement ECDSA algorithm for virtio-crypto device

virtio bits:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> lei he (4):
>   crypto: fix the calculation of max_size for ECDSA
>   crypto: pkcs8 parser support ECDSA private keys
>   crypto: remove unused field in pkcs8_parse_context
>   virtio-crypto: support ECDSA algorithm
> 
>  crypto/Kconfig                                |   1 +
>  crypto/Makefile                               |   2 +
>  crypto/akcipher.c                             |  10 +
>  crypto/asymmetric_keys/pkcs8.asn1             |   2 +-
>  crypto/asymmetric_keys/pkcs8_parser.c         |  46 +++-
>  crypto/ecdsa.c                                |   3 +-
>  crypto/ecdsa_helper.c                         |  45 +++
>  .../virtio/virtio_crypto_akcipher_algs.c      | 259 ++++++++++++++++--
>  include/crypto/internal/ecdsa.h               |  15 +
>  include/linux/asn1_encoder.h                  |   2 +
>  lib/asn1_encoder.c                            |   3 +-
>  11 files changed, 360 insertions(+), 28 deletions(-)
>  create mode 100644 crypto/ecdsa_helper.c
>  create mode 100644 include/crypto/internal/ecdsa.h
> 
> -- 
> 2.20.1

