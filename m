Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBC6C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 12:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiCWMiG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbiCWMh4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 08:37:56 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B587B54D
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 05:36:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o8so995225pgf.9
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 05:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1/cwjisYWhPAjguq3RkHg62B/Qtu8tC3102zHeh5xtA=;
        b=TOZkxKBkSLiML8A7JfcKmCcxE0a+yPgGERUi6wtN3p6/0lRDW3gjwd858Vme6h9GCR
         eIZVyojOyV/7FcpBYvOJ8U7SYGr8fF3ZbrDjFeaYl8C2Q+x6kpMn2h3eRq69yNNcF1Un
         Ws5yIxud1uHNkEfs9MZC4+NuSxwbKQDcoRg9Tc9KW2bHyWMgPovPTv4L5qY9mGH5I6Px
         kRlOBAO4To16zESLnLIK3E3D1G/jD2PJYGYtmzNxfH9vmJtMMRvrNW1A5PdspMPCCkbp
         DAiicZmchDbVwpRlZGBNEqncJC+orL4JuCROd8U3YJtpaYUtCvRP43EaaUOVlQAPYra3
         pPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1/cwjisYWhPAjguq3RkHg62B/Qtu8tC3102zHeh5xtA=;
        b=cRIAGqhPh/wuI4e8VyTYdA+cn0cI0lZEAgN/t/+f2FAMQDK9ABer6I+deqngYxeiNU
         Qqth/CLdzDfnGIRzrpB2mtl6M2XQsDn4/JQUNCwisot+albRGIK2ieNSB3asClvrx0kZ
         P5lYoThbYwFQDaOKGyWMxBOvcbUiA3yd0sTpPzhAkqQrJojIkNetNgQ40WrXbibHl6a1
         Aom1cNVN5KF5R3W5Ynim6dqglsSo9S6KDvaiPHe+g0G7vwnP+ruPQG8pYmioRF6hD6XL
         xL6Moxpth4DQIpQj+JO3YFKhRYIcNTPl74qCCMEYkln09qqTYFT0EcEijdLEU3z3TFGQ
         rLfA==
X-Gm-Message-State: AOAM532c4uuWJTR/m6jFKZhSJuGVLxiqyRHHnnIJNkq8WET8rby7NGds
        8HXLaCF3n0m9jWto2fTNoJc=
X-Google-Smtp-Source: ABdhPJz/hb43Jn0t74G4KrVSuw+vJtAKWyn3T/YQhVtIrwEzvIr6LmW1459H27J4c/Dq9i/j0ag09g==
X-Received: by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id h16-20020a056a00231000b004fa7eb1e855mr22772727pfh.14.1648038983119;
        Wed, 23 Mar 2022 05:36:23 -0700 (PDT)
Received: from [192.168.1.33] (198.red-83-50-65.dynamicip.rima-tde.net. [83.50.65.198])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a8b0300b001c735089cc2sm6115487pjn.54.2022.03.23.05.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 05:36:22 -0700 (PDT)
Message-ID: <6a63c13b-f5c6-5088-640e-8b2cd0ce0712@gmail.com>
Date:   Wed, 23 Mar 2022 13:36:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 0/6] Support akcipher for virtio-crypto
Content-Language: en-US
To:     zhenwei pi <pizhenwei@bytedance.com>, arei.gonglei@huawei.com,
        mst@redhat.com, Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     herbert@gondor.apana.org.au, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
References: <20220323024912.249789-1-pizhenwei@bytedance.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220323024912.249789-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cc'ing Daniel & Laurent.

On 23/3/22 03:49, zhenwei pi wrote:
> v2 -> v3:
> - Introduce akcipher types to qapi
> - Add test/benchmark suite for akcipher class
> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>    - crypto: Introduce akcipher crypto class
>    - virtio-crypto: Introduce RSA algorithm
> 
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
>    crypto-akcipher: Introduce akcipher types to qapi
>    crypto: Implement RSA algorithm by hogweed
>    tests/crypto: Add test suite for crypto akcipher
> 
> Zhenwei Pi (3):
>    virtio-crypto: header update
>    crypto: Introduce akcipher crypto class
>    virtio-crypto: Introduce RSA algorithm
> 
>   backends/cryptodev-builtin.c                  | 319 +++++++-
>   backends/cryptodev-vhost-user.c               |  34 +-
>   backends/cryptodev.c                          |  32 +-
>   crypto/akcipher-nettle.c                      | 523 +++++++++++++
>   crypto/akcipher.c                             |  81 ++
>   crypto/asn1_decoder.c                         | 185 +++++
>   crypto/asn1_decoder.h                         |  42 +
>   crypto/meson.build                            |   4 +
>   hw/virtio/virtio-crypto.c                     | 326 ++++++--
>   include/crypto/akcipher.h                     | 155 ++++
>   include/hw/virtio/virtio-crypto.h             |   5 +-
>   .../standard-headers/linux/virtio_crypto.h    |  82 +-
>   include/sysemu/cryptodev.h                    |  88 ++-
>   meson.build                                   |  11 +
>   qapi/crypto.json                              |  86 +++
>   tests/bench/benchmark-crypto-akcipher.c       | 163 ++++
>   tests/bench/meson.build                       |   6 +
>   tests/bench/test_akcipher_keys.inc            | 277 +++++++
>   tests/unit/meson.build                        |   1 +
>   tests/unit/test-crypto-akcipher.c             | 715 ++++++++++++++++++
>   20 files changed, 2990 insertions(+), 145 deletions(-)
>   create mode 100644 crypto/akcipher-nettle.c
>   create mode 100644 crypto/akcipher.c
>   create mode 100644 crypto/asn1_decoder.c
>   create mode 100644 crypto/asn1_decoder.h
>   create mode 100644 include/crypto/akcipher.h
>   create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>   create mode 100644 tests/bench/test_akcipher_keys.inc
>   create mode 100644 tests/unit/test-crypto-akcipher.c
> 

