Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAFDC25B06
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Aug 2022 19:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbiHITDd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345377AbiHITCx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Aug 2022 15:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36C027B29
        for <linux-crypto@vger.kernel.org>; Tue,  9 Aug 2022 11:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660070214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m/RDB/JS2A+rkcJXiycrT7nlqCdePEvztzO47vN60tc=;
        b=OTkJLxugI4Q2ZVD685SUlA6NPwBdjnhlkdSfNOxBdbz1OJeXJWK9Ew2KlMw5duZAmMMRH5
        TID/6hnn4mhIW7wcUNuAFMA2uykx02fz50QUZ1NN9FXI9Ouwl1hvyexmX5v8rtfP9bq6SA
        LNzBesPsOLHzdjSPRkNE7jbtqZXDelw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-Konk8NQ8Pn6aCMVlRANAzA-1; Tue, 09 Aug 2022 14:36:49 -0400
X-MC-Unique: Konk8NQ8Pn6aCMVlRANAzA-1
Received: by mail-ed1-f72.google.com with SMTP id x20-20020a05640226d400b0043d50aadf3fso7811598edd.23
        for <linux-crypto@vger.kernel.org>; Tue, 09 Aug 2022 11:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=m/RDB/JS2A+rkcJXiycrT7nlqCdePEvztzO47vN60tc=;
        b=Y4Qfvd2zSyucMwXAslfsGJqFnOyCmFj8u7InHtAQVrWgNGtiSX3zR3tDGY6RmprjoC
         l2f8/dX7YOFTNUwIrwJM/SZJrlY3dDA4uYYZmDTI1T274F2W/PDYmTsZ0NMA1hJigHze
         G9Sx2KVhzHOCicMn3109cIAYxNstzwSULLhWlri8A+haSUMTZ/ihhAXV8yv2KmCW1TAw
         pidp3QMCoMnssMVYHYkh1dlpPNBsDq23HGSruSDFbz9BIq7CstDq4GjW7g1llSVMVTGz
         z3lFcS6YyfB2VjlkCBxG5CC4/nXoQIOmDDa6W/KJZR3b4veozDui22S+SBlY4gKnZ5So
         k38A==
X-Gm-Message-State: ACgBeo1nq3cShojavjb+OwmMBIg3XFNDWADVXa7uRbbrfZbla66npRRa
        kRlSCwyJorO5MX5qOWeehM0+Jo0DjZSopfe99qKoU5CeozbQU5xQNPGl5fXVmxs8Wuf9g5aZQBz
        AFFKSGgLGMfdiLSits1BSTBP5
X-Received: by 2002:a17:907:28c9:b0:731:e57:bf27 with SMTP id en9-20020a17090728c900b007310e57bf27mr12916953ejc.451.1660070204929;
        Tue, 09 Aug 2022 11:36:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6EzlIwxo5M9CoAjttFlYSxF5sujZStl/jx93pHpz0KHh5xypEXt7HG7RqiC3AKRhj9Vee8qQ==
X-Received: by 2002:a17:907:28c9:b0:731:e57:bf27 with SMTP id en9-20020a17090728c900b007310e57bf27mr12916940ejc.451.1660070204682;
        Tue, 09 Aug 2022 11:36:44 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id o3-20020a170906768300b0072b2ef2757csm1366205ejm.180.2022.08.09.11.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 11:36:43 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:36:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, berrange@redhat.com,
        pizhenwei@bytedance.com
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
Message-ID: <20220809143555-mutt-send-email-mst@kernel.org>
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
> 
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


So this depends on core crypto changes that need Herbert's ack.
I'll drop this from my radar for now.

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

