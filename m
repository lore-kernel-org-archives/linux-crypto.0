Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A840C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 10:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377107AbiEMKTT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 06:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379330AbiEMKTQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 06:19:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B39C82DD5D
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652437152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPf7Pu0P3apZDaVMQixl1n2kADN4YzofhOzrTrcdAa8=;
        b=EF/UcIwdl7moyk3ky1AjTgecFbbejzxP++bjUncjyw4a/B34AYABQ2znah3jpCMdN3hIP8
        Vj7etZeL+jyPcT+v5Ozswuv19ZBvRC15QDYU8/DU3AK1WpSZwgEbYUZW5SMx5aZhvR+cOe
        7ov2CCgEDGpBWMJvrh5A7BzcjG32coQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-cgzFrn3dOo-AF_xc94iL-Q-1; Fri, 13 May 2022 06:19:11 -0400
X-MC-Unique: cgzFrn3dOo-AF_xc94iL-Q-1
Received: by mail-wr1-f69.google.com with SMTP id o13-20020adfa10d000000b0020c6fa5a77cso2753268wro.23
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 03:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EPf7Pu0P3apZDaVMQixl1n2kADN4YzofhOzrTrcdAa8=;
        b=HHCaGxwmC2cqD4x08lig2C6+pJkAtIWP7i/W/i4Npmh5BGHqBv0/j+vl172ndlmNL3
         mtx9fADeeQmrUm1MeqsLTCQCPcRLR9dU+012ORltn0u/AqcY3SXTmuUQxqMfFkW0d7tt
         M9TWuiZcM+QE1FiKFEHy8ZFqOEbSa0X3H6VsNgfVvfNUoEXDMIOFB0+9oBrSjkhxgYhO
         MfCYQzlrpZG7rO2s2TC3Ye7HuNcfOs+ckT1dPI1/98uLYGbnP9qPkEGffEyY5OqT0nlv
         fpxBerQVO3VLto4ehv/5sOitgUaZIJey6PYGVw9jsCPi09yQR0OsmdIQkUUDRZ9f77VE
         TOig==
X-Gm-Message-State: AOAM531NZUPTyaXASm1QpUxCWZEQOEdJzPtAZYO63H/SSyeWS0G3KM4Z
        OaaY7p9IvO+ri3iGoLhbtT27EpJ/UXZf7vw3qP213NZJAB/ZwMV3mR2wRPKNMz7V3qPavioj+ay
        byzEgzQ4oMMiSZwDkUr3aypB7
X-Received: by 2002:a5d:59af:0:b0:20c:52e9:6c49 with SMTP id p15-20020a5d59af000000b0020c52e96c49mr3323841wrr.319.1652437150449;
        Fri, 13 May 2022 03:19:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOvQ9dLuL2eP6se0sIQQw2vcFkFPnn3HUq1CsaeQRIonOi4eo7q34RY1zmOYpDDtAhLHncpw==
X-Received: by 2002:a5d:59af:0:b0:20c:52e9:6c49 with SMTP id p15-20020a5d59af000000b0020c52e96c49mr3323804wrr.319.1652437150126;
        Fri, 13 May 2022 03:19:10 -0700 (PDT)
Received: from redhat.com ([2.53.15.195])
        by smtp.gmail.com with ESMTPSA id r21-20020adfb1d5000000b0020c5253d924sm1732386wra.112.2022.05.13.03.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 03:19:09 -0700 (PDT)
Date:   Fri, 13 May 2022 06:19:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     arei.gonglei@huawei.com, berrange@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v5 0/9] Introduce akcipher service for virtio-crypto
Message-ID: <20220513061844-mutt-send-email-mst@kernel.org>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428135943.178254-1-pizhenwei@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 28, 2022 at 09:59:34PM +0800, zhenwei pi wrote:
> Hi, Lei & MST
> 
> Daniel has started to review the akcipher framework and nettle & gcrypt
> implementation, this part seems to be ready soon. Thanks a lot to Daniel!
> 
> And the last patch "crypto: Introduce RSA algorithm" handles akcipher
> requests from guest and uses the new akcipher service. The new feature
> can be used to test by the builtin driver. I would appreciate it if you
> could review patch.


I applied the first 6 patches. Tests need to address Daniel's comments.

> v4 -> v5:
> - Move QCryptoAkCipher into akcipherpriv.h, and modify the related comments.
> - Rename asn1_decoder.c to der.c.
> - Code style fix: use 'cleanup' & 'error' lables.
> - Allow autoptr type to auto-free.
> - Add test cases for rsakey to handle DER error.
> - Other minor fixes.
> 
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
>                   Nginx/openssl[1] ... Apps
> Guest   -----------------------------------------
>                    virtio-crypto driver[2]
> -------------------------------------------------
>                    virtio-crypto backend[3]
> Host    -----------------------------------------
>                   /          |          \
>               builtin[4]   vhost     keyctl[5] ...
> 
> 
> [1] User applications can offload RSA calculation to kernel by keyctl syscall. There is no keyctl engine in openssl currently, we developed a engine and tried to contribute it to openssl upstream, but openssl 1.x does not accept new feature. Link:
>     https://github.com/openssl/openssl/pull/16689
> 
> This branch is available and maintained by Lei <helei.sig11@bytedance.com>
>     https://github.com/TousakaRin/openssl/tree/OpenSSL_1_1_1-kctl_engine
> 
> We tested nginx(change config file only) with openssl keyctl engine, it works fine.
> 
> [2] virtio-crypto driver is used to communicate with host side, send requests to host side to do asymmetric calculation.
>     https://lkml.org/lkml/2022/3/1/1425
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
>   - crypto: Introduce akcipher crypto class
>   - virtio-crypto: Introduce RSA algorithm
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
> Lei He (6):
>   qapi: crypto-akcipher: Introduce akcipher types to qapi
>   crypto: add ASN.1 DER decoder
>   crypto: Implement RSA algorithm by hogweed
>   crypto: Implement RSA algorithm by gcrypt
>   test/crypto: Add test suite for crypto akcipher
>   tests/crypto: Add test suite for RSA keys
> 
> Zhenwei Pi (3):
>   virtio-crypto: header update
>   crypto: Introduce akcipher crypto class
>   crypto: Introduce RSA algorithm
> 
>  backends/cryptodev-builtin.c                  | 272 ++++-
>  backends/cryptodev-vhost-user.c               |  34 +-
>  backends/cryptodev.c                          |  32 +-
>  crypto/akcipher-gcrypt.c.inc                  | 520 +++++++++
>  crypto/akcipher-nettle.c.inc                  | 432 ++++++++
>  crypto/akcipher.c                             | 108 ++
>  crypto/akcipherpriv.h                         |  55 +
>  crypto/der.c                                  | 190 ++++
>  crypto/der.h                                  |  82 ++
>  crypto/meson.build                            |   6 +
>  crypto/rsakey-builtin.c.inc                   | 209 ++++
>  crypto/rsakey-nettle.c.inc                    | 154 +++
>  crypto/rsakey.c                               |  44 +
>  crypto/rsakey.h                               |  94 ++
>  hw/virtio/virtio-crypto.c                     | 323 ++++--
>  include/crypto/akcipher.h                     | 158 +++
>  include/hw/virtio/virtio-crypto.h             |   5 +-
>  .../standard-headers/linux/virtio_crypto.h    |  82 +-
>  include/sysemu/cryptodev.h                    |  83 +-
>  meson.build                                   |  11 +
>  qapi/crypto.json                              |  64 ++
>  tests/bench/benchmark-crypto-akcipher.c       | 157 +++
>  tests/bench/meson.build                       |   4 +
>  tests/bench/test_akcipher_keys.inc            | 537 ++++++++++
>  tests/unit/meson.build                        |   2 +
>  tests/unit/test-crypto-akcipher.c             | 990 ++++++++++++++++++
>  tests/unit/test-crypto-der.c                  | 290 +++++
>  27 files changed, 4792 insertions(+), 146 deletions(-)
>  create mode 100644 crypto/akcipher-gcrypt.c.inc
>  create mode 100644 crypto/akcipher-nettle.c.inc
>  create mode 100644 crypto/akcipher.c
>  create mode 100644 crypto/akcipherpriv.h
>  create mode 100644 crypto/der.c
>  create mode 100644 crypto/der.h
>  create mode 100644 crypto/rsakey-builtin.c.inc
>  create mode 100644 crypto/rsakey-nettle.c.inc
>  create mode 100644 crypto/rsakey.c
>  create mode 100644 crypto/rsakey.h
>  create mode 100644 include/crypto/akcipher.h
>  create mode 100644 tests/bench/benchmark-crypto-akcipher.c
>  create mode 100644 tests/bench/test_akcipher_keys.inc
>  create mode 100644 tests/unit/test-crypto-akcipher.c
>  create mode 100644 tests/unit/test-crypto-der.c
> 
> -- 
> 2.20.1

