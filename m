Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23C1C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 14 May 2022 02:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiENCx1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 22:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiENCx0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 22:53:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDFD35BC57
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id iq10so9494139pjb.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 17:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=02Rd1YQXVQ4m5IaVrxBzIMRnDUPYCQLIsiNiYltxKfE=;
        b=8LHfHaO2fY7TgtPbwy2xUMjMRbFCzSmLXEmfgj5jrnhB/P1MYX0BGREVvLrr6x+JBV
         toDBjP53fy8pi9V4hwt/PD9M5L2AsCuHHup3Gzi5p7ILU4ArVUpVMfYElm7O7xIGHWwm
         6elN/2nmTEy3oGztqZDLIkZX+0aM85hJvM1kKNH9OygsFK+UCCn46weidr69N5YDJDe1
         N5ASUPaeLnJp8T21jbRWT0iD6b/xFNH7zJ9IWuITpohJpiu53n5ZVulUZ7qh7LTRHPVV
         Vb4nF6V2HYSwEiBXgYiqL+BtAFor/YQK3Xook0hTO/4TpxxU2SbG7uCk25buJpVa+QbS
         3uPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=02Rd1YQXVQ4m5IaVrxBzIMRnDUPYCQLIsiNiYltxKfE=;
        b=01mFZguAiU2JJyQKCzj1dD1+BOiowBHperlDBcPyGlEvA5EKFFJ3QAABulnonxlkRE
         +w6vULQ9kbSu/wMLZ4rCTrQUoDlLvFMf6DiqemB+Hmm7xBcsQ+3IE7n2eF+0X/hzmLRw
         fG1t1Ikq546QN0CtV9PQ/Dex/u5tUgrdIMf1TPIcafsMsfYwPpqjQWWOV378Cf57IM92
         dURXFo7gHli5R+6iguM8t39f/mAm7y9xZCw8r+GWa8LThi4F1CRSSbQKynSSD0g6iRJH
         QA+iB4oM2dy+9z+Syj3GOpXUZo06f4wPIMOMhqbuRmi9RfZ4JiR05UTg2GQRbtwHNbYz
         C18A==
X-Gm-Message-State: AOAM530P9bkmSnGqRRAZgclNqvDr+LL0UktI6d7De3EugoCk/I3eUnar
        BGA/MGDWZ6i+zghBUbszluxD3FJxJfNxLA==
X-Google-Smtp-Source: ABdhPJw91YzAigU+p2T8yJcLgHQAAoJujKmJ0iVabKWpOeeY1pFpHMz2lvthp0qAwY92bmevrD8XOA==
X-Received: by 2002:a17:90b:3c4e:b0:1dc:9999:44eb with SMTP id pm14-20020a17090b3c4e00b001dc999944ebmr18677189pjb.179.1652489957394;
        Fri, 13 May 2022 17:59:17 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id t24-20020a170902b21800b0015e8d4eb1dbsm2466125plr.37.2022.05.13.17.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 17:59:16 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com, berrange@redhat.com
Cc:     qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, pizhenwei@bytedance.com, cohuck@redhat.com
Subject: [PATCH v6 0/9] Introduce akcipher service for virtio-crypto
Date:   Sat, 14 May 2022 08:54:55 +0800
Message-Id: <20220514005504.1042884-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v5 -> v6:
- Fix build errors and codestyles.
- Add parameter 'Error **errp' for qcrypto_akcipher_rsakey_parse.
- Report more detailed errors.
- Fix buffer length check and return values of akcipher-nettle, allows caller to
  pass a buffer with larger size than actual needed.

A million thanks to Daniel!

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
 crypto/akcipher-gcrypt.c.inc                  | 597 +++++++++++
 crypto/akcipher-nettle.c.inc                  | 451 ++++++++
 crypto/akcipher.c                             | 108 ++
 crypto/akcipherpriv.h                         |  55 +
 crypto/der.c                                  | 189 ++++
 crypto/der.h                                  |  81 ++
 crypto/meson.build                            |   6 +
 crypto/rsakey-builtin.c.inc                   | 200 ++++
 crypto/rsakey-nettle.c.inc                    | 158 +++
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
 tests/bench/meson.build                       |   1 +
 tests/bench/test_akcipher_keys.inc            | 537 ++++++++++
 tests/unit/meson.build                        |   2 +
 tests/unit/test-crypto-akcipher.c             | 990 ++++++++++++++++++
 tests/unit/test-crypto-der.c                  | 290 +++++
 27 files changed, 4878 insertions(+), 146 deletions(-)
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

