Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30555C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 10:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbiDKKtV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345709AbiDKKtU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 06:49:20 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CA643ED8
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 66so13808717pga.12
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 03:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ch9eAVgtj1rN+vWV6m52FPC9lnbmsAZFUH8BEqY/nG4=;
        b=a7bnCvu+OFZhuBGR3sgaiM4l/1wQJrmxh2D4pxILOmEnsKa7nOm/9lB5MRREsD/dUR
         qH30aQEnqFHTlmLIzXvrY9dJcgjT/RbVziBYHp3ahoinRxWcGJ8cB2NrrLY3BcWdC69O
         90bg2BzanZNV8LId7w4TyxY8eQ5gumYxq49FI6M/mPfObXmvhnQ8sHBsFjyUz2vldRsV
         rPGHBHGqiEdhnfSoR+SxTnPFn2qzbFLAo8N2DD0KUqfn9DDofMlrL6sQS4Ebd6sleSpi
         7CxwOImpAceBuGPcITtRYuy9lpSWQ7g7u622nZfQWarmcm8dLKuc2e4uY/ziINCXu2FZ
         v9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ch9eAVgtj1rN+vWV6m52FPC9lnbmsAZFUH8BEqY/nG4=;
        b=tltEkRhHGB81S5CkiO46rjKUicFi4mYtSDkGG3vNBPjSvcraU5SxKzed7B1wE99kP6
         dYx5JZm+wthFD2maiuzcMCz3YrBOfXSD7R7rGav1OQ3iP/dwoUkXuLuknwSKBQkPIvDj
         HvCAUkHQCVmlqrVDdhngan3Bc7VqV0OlDvzkbhss9qxAkNtV+v77rDndgLz1HoPdObF5
         b34bJiMCNUYHip0AIwUUdy4dg+7xwhTxxWKd5F2rDXR3rFz0p+bi1frCbkpgAV08UWB+
         QWyAaSfGiGZKSGpSx6ydP0e2JKBMTixfvffnlNpJNezV50TDQzxIERsN/Ao06M2in0yV
         cQKQ==
X-Gm-Message-State: AOAM530fK41+uc4qhk9XlyXhisBxebW3/BF06v9JlCNqw7rPd/UdlqxJ
        yKXGMSw0GCtZxpGdu1H8rloIMw==
X-Google-Smtp-Source: ABdhPJyM/U/Gty0iFc8Rn9tgWEQZ1g0qf4l2I/GAmMqJ2uRI+Kbw/8e9qiPdJ5G2jY6YEhb0hPowLA==
X-Received: by 2002:a05:6a00:1a55:b0:4fd:ef0c:fad1 with SMTP id h21-20020a056a001a5500b004fdef0cfad1mr31940137pfv.50.1649674025279;
        Mon, 11 Apr 2022 03:47:05 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id d8-20020a636808000000b00398e9c7049bsm27541649pgc.31.2022.04.11.03.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:47:04 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, berrange@redhat.com, arei.gonglei@huawei.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        cohuck@redhat.com, jasowang@redhat.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 0/8] Introduce akcipher service for virtio-crypto
Date:   Mon, 11 Apr 2022 18:43:19 +0800
Message-Id: <20220411104327.197048-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v3 -> v4:
- Coding style fix: Akcipher -> AkCipher, struct XXX -> XXX, Rsa -> RSA,
XXX-alg -> XXX-algo.
- Change version info in qapi/crypto.json, from 7.0 -> 7.1.
- Remove ecdsa from qapi/crypto.json, it would be introduced with the implemetion later.
- Use QCryptoHashAlgothrim instead of QCryptoRSAHashAlgorithm(removed) in qapi/crypto.json.
- Rename arguments of qcrypto_akcipher_XXX to keep aligned with qcrypto_cipher_XXX(dec/enc/sign/vefiry -> in/out/in2), and add qcrypto_akcipher_max_XXX APIs.
- Add new API: qcrypto_akcipher_supports.
- Change the return value of qcrypto_akcipher_enc/dec/sign, these functions return the actual length of result.
- Separate ASN.1 source code and test case clean.
- Disable RSA raw encoding for akcipher-nettle.
- Separate RSA key parser into rsakey.{hc}, and implememts it with builtin-asn1-decoder and nettle respectivly.
- Implement RSA(pkcs1 and raw encoding) algorithm by gcrypt. This has higher priority than nettle.
- For some akcipher operations(eg, decryption of pkcs1pad(rsa)), the length of returned result maybe less than the dst buffer size, return the actual length of result instead of the buffer length to the guest side. (in function virtio_crypto_akcipher_input_data_helper)
- Other minor changes.

Thanks to Daniel!

Eric pointed out this missing part of use case, send it here again.

In our plan, the feature is designed for HTTPS offloading case and other applications which use kernel RSA/ecdsa by keyctl syscall. The full picture shows bellow:


                  Nginx/openssl[1] ... Apps
Guest   -----------------------------------------
                   virtio-crypto driver[2]
-------------------------------------------------
                   virtio-crypto backend[3]
Host    -----------------------------------------
                  /          |          \
              builtin[4]   vhost     keyctl[5] ...


[1] User applications can offload RSA calculation to kernel by keyctl syscall. There is no keyctl engine in openssl currently, we developed a engine and tried to contribute it to openssl upstream, but openssl 1.x does not accept new feature. Link:
    https://github.com/openssl/openssl/pull/16689

This branch is available and maintained by Lei <helei.sig11@bytedance.com>
    https://github.com/TousakaRin/openssl/tree/OpenSSL_1_1_1-kctl_engine

We tested nginx(change config file only) with openssl keyctl engine, it works fine.

[2] virtio-crypto driver is used to communicate with host side, send requests to host side to do asymmetric calculation.
    https://lkml.org/lkml/2022/3/1/1425

[3] virtio-crypto backend handles requests from guest side, and forwards request to crypto backend driver of QEMU.

[4] Currently RSA is supported only in builtin driver. This driver is supposed to test the full feature without other software(Ex vhost process) and hardware dependence. ecdsa is introduced into qapi type without implementation, this may be implemented in Q3-2022 or later. If ecdsa type definition should be added with the implementation together, I'll remove this in next version.

[5] keyctl backend is in development, we will post this feature in Q2-2022. keyctl backend can use hardware acceleration(Ex, Intel QAT).

Setup the full environment, tested with Intel QAT on host side, the QPS of HTTPS increase to ~200% in a guest.

VS PCI passthrough: the most important benefit of this solution makes the VM migratable.

v2 -> v3:
- Introduce akcipher types to qapi
- Add test/benchmark suite for akcipher class
- Seperate 'virtio_crypto: Support virtio crypto asym operation' into:
  - crypto: Introduce akcipher crypto class
  - virtio-crypto: Introduce RSA algorithm

v1 -> v2:
- Update virtio_crypto.h from v2 version of related kernel patch.

v1:
- Support akcipher for virtio-crypto.
- Introduce akcipher class.
- Introduce ASN1 decoder into QEMU.
- Implement RSA backend by nettle/hogweed.

Lei He (4):
  crypto-akcipher: Introduce akcipher types to qapi
  crypto: add ASN.1 decoder
  crypto: Implement RSA algorithm by hogweed
  crypto: Implement RSA algorithm by gcrypt

Zhenwei Pi (3):
  virtio-crypto: header update
  crypto: Introduce akcipher crypto class
  crypto: Introduce RSA algorithm

lei he (1):
  tests/crypto: Add test suite for crypto akcipher

 backends/cryptodev-builtin.c                  | 261 ++++++-
 backends/cryptodev-vhost-user.c               |  34 +-
 backends/cryptodev.c                          |  32 +-
 crypto/akcipher-gcrypt.c.inc                  | 531 +++++++++++++
 crypto/akcipher-nettle.c.inc                  | 448 +++++++++++
 crypto/akcipher.c                             | 108 +++
 crypto/akcipherpriv.h                         |  43 ++
 crypto/asn1_decoder.c                         | 161 ++++
 crypto/asn1_decoder.h                         |  75 ++
 crypto/meson.build                            |   6 +
 crypto/rsakey-builtin.c.inc                   | 150 ++++
 crypto/rsakey-nettle.c.inc                    | 141 ++++
 crypto/rsakey.c                               |  43 ++
 crypto/rsakey.h                               |  96 +++
 hw/virtio/virtio-crypto.c                     | 323 ++++++--
 include/crypto/akcipher.h                     | 151 ++++
 include/hw/virtio/virtio-crypto.h             |   5 +-
 .../standard-headers/linux/virtio_crypto.h    |  82 +-
 include/sysemu/cryptodev.h                    |  83 +-
 meson.build                                   |  11 +
 qapi/crypto.json                              |  64 ++
 tests/bench/benchmark-crypto-akcipher.c       | 161 ++++
 tests/bench/meson.build                       |   4 +
 tests/bench/test_akcipher_keys.inc            | 537 +++++++++++++
 tests/unit/meson.build                        |   2 +
 tests/unit/test-crypto-akcipher.c             | 708 ++++++++++++++++++
 tests/unit/test-crypto-asn1-decoder.c         | 289 +++++++
 27 files changed, 4404 insertions(+), 145 deletions(-)
 create mode 100644 crypto/akcipher-gcrypt.c.inc
 create mode 100644 crypto/akcipher-nettle.c.inc
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/akcipherpriv.h
 create mode 100644 crypto/asn1_decoder.c
 create mode 100644 crypto/asn1_decoder.h
 create mode 100644 crypto/rsakey-builtin.c.inc
 create mode 100644 crypto/rsakey-nettle.c.inc
 create mode 100644 crypto/rsakey.c
 create mode 100644 crypto/rsakey.h
 create mode 100644 include/crypto/akcipher.h
 create mode 100644 tests/bench/benchmark-crypto-akcipher.c
 create mode 100644 tests/bench/test_akcipher_keys.inc
 create mode 100644 tests/unit/test-crypto-akcipher.c
 create mode 100644 tests/unit/test-crypto-asn1-decoder.c

-- 
2.20.1

