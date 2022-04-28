Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D667EC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Apr 2022 14:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiD1OIH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241057AbiD1OIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Apr 2022 10:08:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E8FB714C
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 07:04:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so4100874pga.0
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2022 07:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zkXWp8YkbHgF6tQunE9Dc1g1IZuQaUaeHQc84WiuWuw=;
        b=KBf5cjMviFZ3XkhqoulAuU+Jozs8mLNv5F50zJqFkTDeA1vc1WC+OIpkszs1/B6/Si
         5OpAckCU1cI+q4cMIwDF2JXatP1r7CO6u2va16Bq6oWc1WDFcNVejtRuNg3SdnpqQkh3
         O6eLvIGjcDA5YoOCQJXIvkyHwG6RwYEzkQvTbokrO5hMGUj8z5fuFw2jb3Xq4wq4wGEH
         aNPEwhWKFY5y2XN/Fb31CLW2mpvD0njJ7sxC400FLH6bUoyTsIuCTquJwHkZgSHjE8Wm
         OJ9hkPOE66NwbsoJ7fAGbd5feXBs/WoYAMxTNwPwY4OkknzyjcxkIz6D6D+1OAzX21Db
         uo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zkXWp8YkbHgF6tQunE9Dc1g1IZuQaUaeHQc84WiuWuw=;
        b=rEqO1zBR51AFCKtO5d13C+zyU2BAsxkrRkWtDwZjjfiTLqZ4pRgLnULWYKk771pWRt
         zJK7keILPGcKFih1YAkIcOkku1d7L2zDBN8c7QLRduU/31+Rv+1Z/afsUbiNTLLgbuFq
         VHRnDsQD5zSe8ZznAPlmKulYzlo8cLJELBnk2aWlw9KMZMOym4S76Gos4y958/PAe0BD
         tqwq9zQbiUvArBSLZE0kWc1fhWuyUflz+vWECFFT4WR+cTX+mTy+SrL3ssqUeTUMOa67
         92zhRDWT1jP8UndZHt4eHOnHpM2B0id4+AeRvC8n52oNrly/2DOuZUu7anteCxypzdkO
         HH1g==
X-Gm-Message-State: AOAM533VOV96eSOR4OCLaaXLU+k6v4OfjsDYlfMa5qeBNknlJDKR4WUF
        5dg9K3EG7I95FAmvoAkxgCRd0Q==
X-Google-Smtp-Source: ABdhPJxbR3dazvNTLyiio1zH4TfsUXSelYR5IENf0r/5fyXtYZI4SWjfy6a0vf2pfkG2atZ8JyAmjA==
X-Received: by 2002:a05:6a00:b4d:b0:50d:7e9f:1ff0 with SMTP id p13-20020a056a000b4d00b0050d7e9f1ff0mr9151453pfo.80.1651154658806;
        Thu, 28 Apr 2022 07:04:18 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id x129-20020a623187000000b0050835f6d6a1sm38975pfx.9.2022.04.28.07.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:04:18 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v5 0/9] Introduce akcipher service for virtio-crypto
Date:   Thu, 28 Apr 2022 21:59:34 +0800
Message-Id: <20220428135943.178254-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Lei & MST

Daniel has started to review the akcipher framework and nettle & gcrypt
implementation, this part seems to be ready soon. Thanks a lot to Daniel!

And the last patch "crypto: Introduce RSA algorithm" handles akcipher
requests from guest and uses the new akcipher service. The new feature
can be used to test by the builtin driver. I would appreciate it if you
could review patch.

v4 -> v5:
- Move QCryptoAkCipher into akcipherpriv.h, and modify the related comments.
- Rename asn1_decoder.c to der.c.
- Code style fix: use 'cleanup' & 'error' lables.
- Allow autoptr type to auto-free.
- Add test cases for rsakey to handle DER error.
- Other minor fixes.

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

Lei He (6):
  qapi: crypto-akcipher: Introduce akcipher types to qapi
  crypto: add ASN.1 DER decoder
  crypto: Implement RSA algorithm by hogweed
  crypto: Implement RSA algorithm by gcrypt
  test/crypto: Add test suite for crypto akcipher
  tests/crypto: Add test suite for RSA keys

Zhenwei Pi (3):
  virtio-crypto: header update
  crypto: Introduce akcipher crypto class
  crypto: Introduce RSA algorithm

 backends/cryptodev-builtin.c                  | 272 ++++-
 backends/cryptodev-vhost-user.c               |  34 +-
 backends/cryptodev.c                          |  32 +-
 crypto/akcipher-gcrypt.c.inc                  | 520 +++++++++
 crypto/akcipher-nettle.c.inc                  | 432 ++++++++
 crypto/akcipher.c                             | 108 ++
 crypto/akcipherpriv.h                         |  55 +
 crypto/der.c                                  | 190 ++++
 crypto/der.h                                  |  82 ++
 crypto/meson.build                            |   6 +
 crypto/rsakey-builtin.c.inc                   | 209 ++++
 crypto/rsakey-nettle.c.inc                    | 154 +++
 crypto/rsakey.c                               |  44 +
 crypto/rsakey.h                               |  94 ++
 hw/virtio/virtio-crypto.c                     | 323 ++++--
 include/crypto/akcipher.h                     | 158 +++
 include/hw/virtio/virtio-crypto.h             |   5 +-
 .../standard-headers/linux/virtio_crypto.h    |  82 +-
 include/sysemu/cryptodev.h                    |  83 +-
 meson.build                                   |  11 +
 qapi/crypto.json                              |  64 ++
 tests/bench/benchmark-crypto-akcipher.c       | 157 +++
 tests/bench/meson.build                       |   4 +
 tests/bench/test_akcipher_keys.inc            | 537 ++++++++++
 tests/unit/meson.build                        |   2 +
 tests/unit/test-crypto-akcipher.c             | 990 ++++++++++++++++++
 tests/unit/test-crypto-der.c                  | 290 +++++
 27 files changed, 4792 insertions(+), 146 deletions(-)
 create mode 100644 crypto/akcipher-gcrypt.c.inc
 create mode 100644 crypto/akcipher-nettle.c.inc
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/akcipherpriv.h
 create mode 100644 crypto/der.c
 create mode 100644 crypto/der.h
 create mode 100644 crypto/rsakey-builtin.c.inc
 create mode 100644 crypto/rsakey-nettle.c.inc
 create mode 100644 crypto/rsakey.c
 create mode 100644 crypto/rsakey.h
 create mode 100644 include/crypto/akcipher.h
 create mode 100644 tests/bench/benchmark-crypto-akcipher.c
 create mode 100644 tests/bench/test_akcipher_keys.inc
 create mode 100644 tests/unit/test-crypto-akcipher.c
 create mode 100644 tests/unit/test-crypto-der.c

-- 
2.20.1

