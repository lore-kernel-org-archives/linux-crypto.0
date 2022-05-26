Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BC5C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 26 May 2022 11:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiEZLws (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 May 2022 07:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243077AbiEZLwr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 May 2022 07:52:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33718D0299
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 04:52:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nn3-20020a17090b38c300b001e0e091cf03so800747pjb.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 04:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D+BwAbtq7PbjJx/zNFP7MiT9jCGBk4mUErsk+pe7pAU=;
        b=7V+NpEmZmO31hpNTsPcLeaBIPx3MvcSG6EnbkzaL75U3Otc6IZ1ys0f0we/rGyTpyu
         Jl5Ore1a1TR9/l9JAvGRvMWCpQfW0DPNg3xPFGLSqQiwCA5wJGbyjG8LAItYcdXAB3lq
         eZr0zp507hgVrYrXJH4rFshV2wAUxobLsrrbHkO1l+RVxcr1U4ceuLJYR1zE6qcIgcTD
         uYSGv71PBWDUHvSRg3jLeTNp9OCfjn6y4Ts7TlnJT/Kjmr+kZhS5FZL/XjiWDu5Y8lwp
         /ltjNyml2nqpwUXioN+V27kDlkKYgbSUOGl7QOvJ78Kqr17CDab4KnQT9693BKgt6E4E
         PeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D+BwAbtq7PbjJx/zNFP7MiT9jCGBk4mUErsk+pe7pAU=;
        b=oPh+1zStBKP8LtuP0dY2c55k51qBX5IKY/2BGUANp1EUefEV+q5RogI3zA6kI9AV3/
         dEngmxWF3D8Xo3Xb1V57om8lFeiVQiEZLk5J9ZF9siZzLledLcQ//pw4jXLryhTPpGKq
         QQbVGCm3nKUsQc/9xxM6kzrS8OpBJ7XbqDVQDU6zfZOF0QFRffXxLlbca8qWFE5Tu58k
         yyu6l6oEQ4wUyGlnUxKFbswFgrddhmgZNLs9G9CV+7UbuUejBtvsFIKGne0wMplBW7HT
         ryuBfUsnX8kZnMwQqgw87UdRAuzzV9MSd+sHyn/rrkUsRj+w8/ZPgA4P2utmXGkGZZb1
         QnWw==
X-Gm-Message-State: AOAM530dtdcSIyTF9oLSCQVPjTHWc+ONaDAIdOlcmCssdMC/ezQhzBft
        zLIcls0F6vQXddqcDwvLfwd1cGGEnSxSMA==
X-Google-Smtp-Source: ABdhPJyyiNl52ggLRLeyMuhJGhyoN84cF5I8Az4M7VvEjlwwun1iTUUO9DYQRCWihpO5JhnClxv6bA==
X-Received: by 2002:a17:90b:4a0f:b0:1e0:edc:c1f with SMTP id kk15-20020a17090b4a0f00b001e00edc0c1fmr2167022pjb.93.1653565964631;
        Thu, 26 May 2022 04:52:44 -0700 (PDT)
Received: from [10.255.70.20] ([139.177.225.235])
        by smtp.gmail.com with ESMTPSA id v68-20020a622f47000000b0050dc76281e3sm1285645pfv.189.2022.05.26.04.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 04:52:43 -0700 (PDT)
Message-ID: <0e8a0334-7854-16e2-d108-0a7b6d977e8d@bytedance.com>
Date:   Thu, 26 May 2022 19:48:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Re: [PATCH v7 0/9] Introduce akcipher service for virtio-crypto
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com,
        Lei He <helei.sig11@bytedance.com>, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        cohuck@redhat.com
References: <20220525090118.43403-1-helei.sig11@bytedance.com>
 <Yo9a50mWNcopioEr@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <Yo9a50mWNcopioEr@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Daniel

Thanks a lot for your review!

On 5/26/22 18:48, Daniel P. Berrangé wrote:
> I've sent a pull request containing all the crypto/ changes,
> as that covers stuff I maintain. ie patches 2-8
> 
> Patches 1 and 9, I'll leave for MST to review & queue since the
> virtual hardware is not my area of knowledge.
> 
> On Wed, May 25, 2022 at 05:01:09PM +0800, Lei He wrote:
>> v6 -> v7:
>> - Fix serval build errors for some specific platforms/configurations.
>> - Use '%zu' instead of '%lu' for size_t parameters.
>> - AkCipher-gcrypt: avoid setting wrong error messages when parsing RSA
>>    keys.
>> - AkCipher-benchmark: process constant amount of sign/verify instead
>>   of running sign/verify for a constant duration.
>>
>> v5 -> v6:
>> - Fix build errors and codestyles.
>> - Add parameter 'Error **errp' for qcrypto_akcipher_rsakey_parse.
>> - Report more detailed errors.
>> - Fix buffer length check and return values of akcipher-nettle, allows caller to
>>   pass a buffer with larger size than actual needed.
>>
>> A million thanks to Daniel!
>>
>> v4 -> v5:
>> - Move QCryptoAkCipher into akcipherpriv.h, and modify the related comments.
>> - Rename asn1_decoder.c to der.c.
>> - Code style fix: use 'cleanup' & 'error' lables.
>> - Allow autoptr type to auto-free.
>> - Add test cases for rsakey to handle DER error.
>> - Other minor fixes.
>>
>> v3 -> v4:
>> - Coding style fix: Akcipher -> AkCipher, struct XXX -> XXX, Rsa -> RSA,
>> XXX-alg -> XXX-algo.
>> - Change version info in qapi/crypto.json, from 7.0 -> 7.1.
>> - Remove ecdsa from qapi/crypto.json, it would be introduced with the implemetion later.
>> - Use QCryptoHashAlgothrim instead of QCryptoRSAHashAlgorithm(removed) in qapi/crypto.json.
>> - Rename arguments of qcrypto_akcipher_XXX to keep aligned with qcrypto_cipher_XXX(dec/enc/sign/vefiry -> in/out/in2), and add qcrypto_akcipher_max_XXX APIs.
>> - Add new API: qcrypto_akcipher_supports.
>> - Change the return value of qcrypto_akcipher_enc/dec/sign, these functions return the actual length of result.
>> - Separate ASN.1 source code and test case clean.
>> - Disable RSA raw encoding for akcipher-nettle.
>> - Separate RSA key parser into rsakey.{hc}, and implememts it with builtin-asn1-decoder and nettle respectivly.
>> - Implement RSA(pkcs1 and raw encoding) algorithm by gcrypt. This has higher priority than nettle.
>> - For some akcipher operations(eg, decryption of pkcs1pad(rsa)), the length of returned result maybe less than the dst buffer size, return the actual length of result instead of the buffer length to the guest side. (in function virtio_crypto_akcipher_input_data_helper)
>> - Other minor changes.
>>
>> Thanks to Daniel!
>>
>> Eric pointed out this missing part of use case, send it here again.
>>
>> In our plan, the feature is designed for HTTPS offloading case and other applications which use kernel RSA/ecdsa by keyctl syscall. The full picture shows bellow:
>>
>>
>>                   Nginx/openssl[1] ... Apps
>> Guest   -----------------------------------------
>>                    virtio-crypto driver[2]
>> -------------------------------------------------
>>                    virtio-crypto backend[3]
>> Host    -----------------------------------------
>>                   /          |          \
>>               builtin[4]   vhost     keyctl[5] ...
>>
>>
>> [1] User applications can offload RSA calculation to kernel by keyctl syscall. There is no keyctl engine in openssl currently, we developed a engine and tried to contribute it to openssl upstream, but openssl 1.x does not accept new feature. Link:
>>     https://github.com/openssl/openssl/pull/16689
>>
>> This branch is available and maintained by Lei <helei.sig11@bytedance.com>
>>     https://github.com/TousakaRin/openssl/tree/OpenSSL_1_1_1-kctl_engine
>>
>> We tested nginx(change config file only) with openssl keyctl engine, it works fine.
>>
>> [2] virtio-crypto driver is used to communicate with host side, send requests to host side to do asymmetric calculation.
>>     https://lkml.org/lkml/2022/3/1/1425
>>
>> [3] virtio-crypto backend handles requests from guest side, and forwards request to crypto backend driver of QEMU.
>>
>> [4] Currently RSA is supported only in builtin driver. This driver is supposed to test the full feature without other software(Ex vhost process) and hardware dependence. ecdsa is introduced into qapi type without implementation, this may be implemented in Q3-2022 or later. If ecdsa type definition should be added with the implementation together, I'll remove this in next version.
>>
>> [5] keyctl backend is in development, we will post this feature in Q2-2022. keyctl backend can use hardware acceleration(Ex, Intel QAT).
>>
>> Setup the full environment, tested with Intel QAT on host side, the QPS of HTTPS increase to ~200% in a guest.
>>
>> VS PCI passthrough: the most important benefit of this solution makes the VM migratable.
>>
>> v2 -> v3:
>> - Introduce akcipher types to qapi
>> - Add test/benchmark suite for akcipher class
>> - Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
>>   - crypto: Introduce akcipher crypto class
>>   - virtio-crypto: Introduce RSA algorithm
>>
>> v1 -> v2:
>> - Update virtio_crypto.h from v2 version of related kernel patch.
>>
>> v1:
>> - Support akcipher for virtio-crypto.
>> - Introduce akcipher class.
>> - Introduce ASN1 decoder into QEMU.
>> - Implement RSA backend by nettle/hogweed.
>>
>> Lei He (6):
>>    qapi: crypto-akcipher: Introduce akcipher types to qapi
>>    crypto: add ASN.1 DER decoder
>>    crypto: Implement RSA algorithm by hogweed
>>    crypto: Implement RSA algorithm by gcrypt
>>    test/crypto: Add test suite for crypto akcipher
>>    tests/crypto: Add test suite for RSA keys
>>
>> Zhenwei Pi (3):
>>    virtio-crypto: header update
>>    crypto: Introduce akcipher crypto class
>>    crypto: Introduce RSA algorithm
>>
>>   backends/cryptodev-builtin.c                   | 272 ++++++-
>>   backends/cryptodev-vhost-user.c                |  34 +-
>>   backends/cryptodev.c                           |  32 +-
>>   crypto/akcipher-gcrypt.c.inc                   | 595 +++++++++++++++
>>   crypto/akcipher-nettle.c.inc                   | 451 +++++++++++
>>   crypto/akcipher.c                              | 108 +++
>>   crypto/akcipherpriv.h                          |  55 ++
>>   crypto/der.c                                   | 189 +++++
>>   crypto/der.h                                   |  81 ++
>>   crypto/meson.build                             |   6 +
>>   crypto/rsakey-builtin.c.inc                    | 200 +++++
>>   crypto/rsakey-nettle.c.inc                     | 158 ++++
>>   crypto/rsakey.c                                |  44 ++
>>   crypto/rsakey.h                                |  92 +++
>>   hw/virtio/virtio-crypto.c                      | 323 ++++++--
>>   include/crypto/akcipher.h                      | 158 ++++
>>   include/hw/virtio/virtio-crypto.h              |   5 +-
>>   include/standard-headers/linux/virtio_crypto.h |  82 +-
>>   include/sysemu/cryptodev.h                     |  83 ++-
>>   meson.build                                    |  11 +
>>   qapi/crypto.json                               |  64 ++
>>   tests/bench/benchmark-crypto-akcipher.c        | 137 ++++
>>   tests/bench/meson.build                        |   1 +
>>   tests/bench/test_akcipher_keys.inc             | 537 ++++++++++++++
>>   tests/unit/meson.build                         |   2 +
>>   tests/unit/test-crypto-akcipher.c              | 990 +++++++++++++++++++++++++
>>   tests/unit/test-crypto-der.c                   | 290 ++++++++
>>   27 files changed, 4854 insertions(+), 146 deletions(-)
>>   create mode 100644 crypto/akcipher-gcrypt.c.inc
>>   create mode 100644 crypto/akcipher-nettle.c.inc
>>   create mode 100644 crypto/akcipher.c
>>   create mode 100644 crypto/akcipherpriv.h
>>   create mode 100644 crypto/der.c
>>   create mode 100644 crypto/der.h
>>   create mode 100644 crypto/rsakey-builtin.c.inc
>>   create mode 100644 crypto/rsakey-nettle.c.inc
>>   create mode 100644 crypto/rsakey.c
>>   create mode 100644 crypto/rsakey.h
>>   create mode 100644 include/crypto/akcipher.h
>>   create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>>   create mode 100644 tests/bench/test_akcipher_keys.inc
>>   create mode 100644 tests/unit/test-crypto-akcipher.c
>>   create mode 100644 tests/unit/test-crypto-der.c
>>
>> -- 
>> 2.11.0
>>
> 
> With regards,
> Daniel

-- 
zhenwei pi
