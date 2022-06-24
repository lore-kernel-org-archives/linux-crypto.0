Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A67CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 06:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiFXGvf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiFXGve (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jun 2022 02:51:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FB286363C
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 23:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656053491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bUnwlqgL9iprRVri7wCkAEBYhV184LNmNjS9YgkzioI=;
        b=bf3+T3+ZvC7gwN7hoTAlaQnsWF60DAZ0sZP4ljDUD17bhd5uzcyLqWhhoWH4ts0cQ2/mbi
        GRRXPjuqlE16NRw+6mTdS0J6QbbQp+MwgOXtLc3gVsII12oZ1jCX9MeMx+kyL+ZPq1UD0n
        HB3ISszseHF2XEZMoRO9tji4YsMDIKk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-fkRGh8tANFeNcV3l2q6VCw-1; Fri, 24 Jun 2022 02:51:29 -0400
X-MC-Unique: fkRGh8tANFeNcV3l2q6VCw-1
Received: by mail-wm1-f69.google.com with SMTP id h125-20020a1c2183000000b003a0374f1eb8so1512891wmh.8
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 23:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bUnwlqgL9iprRVri7wCkAEBYhV184LNmNjS9YgkzioI=;
        b=aT5Ck1P8W09mhomk3JwKWnm1vZ1yvs46w9bH+QQvFWM5DXbZ0xQpspME1QLkfpWLdl
         BvHuF3GIPzIF59xPU7lhl2JSB2+a9JKQq2YF052UEnl6FXP8oqwT89eo7d1dTdNwv6cy
         yBXPt1Y9On8WDh0KVU/4E7odYlp4HMvlAHdxF+Z6yyDDiRynhRsX93VsbHTc/W+uQqqp
         NJ9oyKpLMqgqd8Kzt8DFo5ozVyEf6OjK+jaicZvVjvNsfX0MNpdtaDt0wgOpYYuvOHUd
         Sr0O9u6rm+XMJabvMV1Ruw+a8POryzeHzflLXQ3Efvk6Yt74hW8tbngSJp8Q9BlK+8/h
         yZGg==
X-Gm-Message-State: AJIora8Kq1h9msCwZzCMJvzMe3/FpN+Wl/cOHGNjdQMUpiQqaiGjI+Sz
        7M5p1ORo84B6CLWw6s2qGzr0RotgUEmB5Kr09dI71ASOEy2HCSTBZKFUcOZsomhlAoS4hJ9sFvX
        i9eC0C7FtliUVIsGy0mnVsQHs
X-Received: by 2002:a05:600c:34d0:b0:3a0:2c07:73ac with SMTP id d16-20020a05600c34d000b003a02c0773acmr1959917wmq.85.1656053488599;
        Thu, 23 Jun 2022 23:51:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1voXV55tZXi2rNo9MNXfewxWTMRest917EZVoAYp5MZLvuULQPfn1DNEvFjgf71hscyoZ5Pnw==
X-Received: by 2002:a05:600c:34d0:b0:3a0:2c07:73ac with SMTP id d16-20020a05600c34d000b003a02c0773acmr1959895wmq.85.1656053488395;
        Thu, 23 Jun 2022 23:51:28 -0700 (PDT)
Received: from redhat.com ([2.55.188.216])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm8262079wms.1.2022.06.23.23.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:51:27 -0700 (PDT)
Date:   Fri, 24 Jun 2022 02:51:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, berrange@redhat.com,
        pizhenwei@bytedance.com
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
Message-ID: <20220624025114-mutt-send-email-mst@kernel.org>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623070550.82053-1-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 23, 2022 at 03:05:46PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> This patch supports the ECDSA algorithm for virtio-crypto.

virtio parts:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> V1 -> V2:
> - explicitly specified an appropriate base commit.
> - fixed the link error reported by kernel test robot <lkp@intl.com>.
> - removed irrelevant commits.
> 
> V1:
> - fixed the problem that the max_signature_size of ECDSA is
> incorrectly calculated.
> - make pkcs8_private_key_parser can identify ECDSA private keys.
> - implement ECDSA algorithm for virtio-crypto device
> 
> 
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
>  drivers/crypto/virtio/Kconfig                 |   1 +
>  .../virtio/virtio_crypto_akcipher_algs.c      | 259 ++++++++++++++++--
>  include/crypto/internal/ecdsa.h               |  15 +
>  include/linux/asn1_encoder.h                  |   2 +
>  lib/asn1_encoder.c                            |   3 +-
>  12 files changed, 361 insertions(+), 28 deletions(-)
>  create mode 100644 crypto/ecdsa_helper.c
>  create mode 100644 include/crypto/internal/ecdsa.h
> 
> 
> base-commit: 018ab4fabddd94f1c96f3b59e180691b9e88d5d8
> -- 
> 2.20.1

