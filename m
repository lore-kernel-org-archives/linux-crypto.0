Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E71EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 01:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357358AbiDUBsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Apr 2022 21:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383715AbiDUBsG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Apr 2022 21:48:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E703815739
        for <linux-crypto@vger.kernel.org>; Wed, 20 Apr 2022 18:45:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so6437349pjn.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 Apr 2022 18:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lLFp+jcZPCDBptlsIznxTdve17ZyRswKCYMzv/KYwNs=;
        b=eIXSY94mJhIN8yUHyDxfX0SvMqUPkcn3XbS9T+n0csM9I8+eu0fqOeyOsoI2eGww1l
         nQG8IxES4nUl5ZdNPfzdBByNWDJVCYKpj2QwYcnqcobC5gyanMbn6LiUju38B0oKe5kI
         dWtLkQFLkabj89M6YIBZJSmkmiBiRtkZx4CHSsIhJm/b28vWn/3SrtfI1Gs01VY+vX8L
         GZb2J4XDt1+zZzgefXbZWgkORpMYBn0Dk1dTTe2DRtzpAd3k0RUmc5uzWOfOD1SHe4lK
         DdzT+MP1h8ZBP0UHDjiCYQk0aK6CYVeu5DjUMc7tQ5mU0BZcSZ+6d32BFWh6RIlSWd2w
         2b5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lLFp+jcZPCDBptlsIznxTdve17ZyRswKCYMzv/KYwNs=;
        b=7ehc1f+ru+tY2rMtyDyKnwMY2OdPO0iapBgRrHwcapRgEGuCEa/UryxPDPTHdrMWmR
         b2KzADK2WDKPBDgz0V1fFGlsKKVW1IGJlr2qJuieZ4GpQjeJuwLQF3c8uKQjK2VADuE0
         K4RFJhqZCXWXFF+smvfQYvkD6lyEelDJmJsiSOBIZRwXSmYQhH6c6PuOFxAsMRebgMkr
         CjXaX5oSgaIxLXx5Mw90xJxs9kDURe1yVTo8TWi0E4Et6RSaDJzJ00yBDS5kekoMAtQk
         lW4rwg4kUxs4/Qk7E+HzOPincA8sLfDRkt5S6+Mrd26AXx7wOPV2zVPbnLmoJ46S/vmJ
         s3Lw==
X-Gm-Message-State: AOAM532QeLNVKPngRTBYTa5wx2byUigvLxKJR96RPxwH6h2q/rP24YIx
        Jkr5Kp/Pj1kKf9C2xP/xB7PVEg==
X-Google-Smtp-Source: ABdhPJwmoXVK6D/qbEB2UeQpbMpyZ8W5u7ZKPfEEe9GI+7zMQJuHK1I2o2urYIvboqdPbEE9jhYDig==
X-Received: by 2002:a17:902:7ec1:b0:156:17a4:a2f8 with SMTP id p1-20020a1709027ec100b0015617a4a2f8mr24168256plb.155.1650505517363;
        Wed, 20 Apr 2022 18:45:17 -0700 (PDT)
Received: from [10.76.15.169] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id ay33-20020a056a00302100b00508374700b9sm20195756pfb.166.2022.04.20.18.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 18:45:16 -0700 (PDT)
Message-ID: <ed446ba2-75a0-aa0d-535e-0bb3501f558f@bytedance.com>
Date:   Thu, 21 Apr 2022 09:41:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: PING: [PATCH v4 0/8] Introduce akcipher service for virtio-crypto
Content-Language: en-US
To:     mst@redhat.com, berrange@redhat.com, arei.gonglei@huawei.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com
References: <20220411104327.197048-1-pizhenwei@bytedance.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20220411104327.197048-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Daniel,
Could you please review this series?


On 4/11/22 18:43, zhenwei pi wrote:
> v3 -> v4:
> - Coding style fix: Akcipher -> AkCipher, struct XXX -> XXX, Rsa -> RSA,
> XXX-alg -> XXX-algo.
> - Change version info in qapi/crypto.json, from 7.0 -> 7.1.
> - Remove ecdsa from qapi/crypto.json, it would be introduced with the implemetion later.
> - Use QCryptoHashAlgothrim instead of QCryptoRSAHashAlgorithm(removed) in qapi/crypto.json.
> - Rename arguments of qcrypto_akcipher_XXX to keep aligned with qcrypto_cipher_XXX(dec/enc/sign/vefiry -> in/out/in2), and add qcrypto_akcipher_max_XXX APIs.
> - Add new API: qcrypto_akcipher_supports.
> - Change the return value of qcrypto_akcipher_enc/dec/sign, these functions return the actual length of result.
> - Separate ASN.1 source code and test case clean.
> - Disable RSA raw encoding for akcipher-nettle.
> - Separate RSA key parser into rsakey.{hc}, and implememts it with builtin-asn1-decoder and nettle respectivly.
> - Implement RSA(pkcs1 and raw encoding) algorithm by gcrypt. This has higher priority than nettle.
> - For some akcipher operations(eg, decryption of pkcs1pad(rsa)), the length of returned result maybe less than the dst buffer size, return the actual length of result instead of the buffer length to the guest side. (in function virtio_crypto_akcipher_input_data_helper)
> - Other minor changes.
> 
> Thanks to Daniel!
> 
> Eric pointed out this missing part of use case, send it here again.
> 
> In our plan, the feature is designed for HTTPS offloading case and other applications which use kernel RSA/ecdsa by keyctl syscall. The full picture shows bellow:
> 
> 
>                    Nginx/openssl[1] ... Apps
> Guest   -----------------------------------------
>                     virtio-crypto driver[2]
> -------------------------------------------------
>                     virtio-crypto backend[3]
> Host    -----------------------------------------
>                    /          |          \
>                builtin[4]   vhost     keyctl[5] ...
> 
> 
> [1] User applications can offload RSA calculation to kernel by keyctl syscall. There is no keyctl engine in openssl currently, we developed a engine and tried to contribute it to openssl upstream, but openssl 1.x does not accept new feature. Link:
>      https://github.com/openssl/openssl/pull/16689
> 
> This branch is available and maintained by Lei <helei.sig11@bytedance.com>
>      https://github.com/TousakaRin/openssl/tree/OpenSSL_1_1_1-kctl_engine
> 
> We tested nginx(change config file only) with openssl keyctl engine, it works fine.
> 
> [2] virtio-crypto driver is used to communicate with host side, send requests to host side to do asymmetric calculation.
>      https://lkml.org/lkml/2022/3/1/1425
> 
> [3] virtio-crypto backend handles requests from guest side, and forwards request to crypto backend driver of QEMU.
> 
> [4] Currently RSA is supported only in builtin driver. This driver is supposed to test the full feature without other software(Ex vhost process) and hardware dependence. ecdsa is introduced into qapi type without implementation, this may be implemented in Q3-2022 or later. If ecdsa type definition should be added with the implementation together, I'll remove this in next version.
> 
> [5] keyctl backend is in development, we will post this feature in Q2-2022. keyctl backend can use hardware acceleration(Ex, Intel QAT).
> 
> Setup the full environment, tested with Intel QAT on host side, the QPS of HTTPS increase to ~200% in a guest.
> 
> VS PCI passthrough: the most important benefit of this solution makes the VM migratable.
> 
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
> Lei He (4):
>    crypto-akcipher: Introduce akcipher types to qapi
>    crypto: add ASN.1 decoder
>    crypto: Implement RSA algorithm by hogweed
>    crypto: Implement RSA algorithm by gcrypt
> 
> Zhenwei Pi (3):
>    virtio-crypto: header update
>    crypto: Introduce akcipher crypto class
>    crypto: Introduce RSA algorithm
> 
> lei he (1):
>    tests/crypto: Add test suite for crypto akcipher
> 
>   backends/cryptodev-builtin.c                  | 261 ++++++-
>   backends/cryptodev-vhost-user.c               |  34 +-
>   backends/cryptodev.c                          |  32 +-
>   crypto/akcipher-gcrypt.c.inc                  | 531 +++++++++++++
>   crypto/akcipher-nettle.c.inc                  | 448 +++++++++++
>   crypto/akcipher.c                             | 108 +++
>   crypto/akcipherpriv.h                         |  43 ++
>   crypto/asn1_decoder.c                         | 161 ++++
>   crypto/asn1_decoder.h                         |  75 ++
>   crypto/meson.build                            |   6 +
>   crypto/rsakey-builtin.c.inc                   | 150 ++++
>   crypto/rsakey-nettle.c.inc                    | 141 ++++
>   crypto/rsakey.c                               |  43 ++
>   crypto/rsakey.h                               |  96 +++
>   hw/virtio/virtio-crypto.c                     | 323 ++++++--
>   include/crypto/akcipher.h                     | 151 ++++
>   include/hw/virtio/virtio-crypto.h             |   5 +-
>   .../standard-headers/linux/virtio_crypto.h    |  82 +-
>   include/sysemu/cryptodev.h                    |  83 +-
>   meson.build                                   |  11 +
>   qapi/crypto.json                              |  64 ++
>   tests/bench/benchmark-crypto-akcipher.c       | 161 ++++
>   tests/bench/meson.build                       |   4 +
>   tests/bench/test_akcipher_keys.inc            | 537 +++++++++++++
>   tests/unit/meson.build                        |   2 +
>   tests/unit/test-crypto-akcipher.c             | 708 ++++++++++++++++++
>   tests/unit/test-crypto-asn1-decoder.c         | 289 +++++++
>   27 files changed, 4404 insertions(+), 145 deletions(-)
>   create mode 100644 crypto/akcipher-gcrypt.c.inc
>   create mode 100644 crypto/akcipher-nettle.c.inc
>   create mode 100644 crypto/akcipher.c
>   create mode 100644 crypto/akcipherpriv.h
>   create mode 100644 crypto/asn1_decoder.c
>   create mode 100644 crypto/asn1_decoder.h
>   create mode 100644 crypto/rsakey-builtin.c.inc
>   create mode 100644 crypto/rsakey-nettle.c.inc
>   create mode 100644 crypto/rsakey.c
>   create mode 100644 crypto/rsakey.h
>   create mode 100644 include/crypto/akcipher.h
>   create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>   create mode 100644 tests/bench/test_akcipher_keys.inc
>   create mode 100644 tests/unit/test-crypto-akcipher.c
>   create mode 100644 tests/unit/test-crypto-asn1-decoder.c
> 

-- 
zhenwei pi
