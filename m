Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB2FC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 02:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiCWCyX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiCWCyX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 22:54:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62BA4A93A
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:52:53 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c23so347238plo.0
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0D/WBKifaDu0QJZs9LIL569qdjw+FHM82ekkuU6fuM=;
        b=KoN+nML2TonJR5xMgMr2gMwkQES9A1FLa7BAlsvaQ9f1w5K4h4DgAyB0dhKwP7wtiG
         HrCJDRQiUP8skWsJMTV+GJZkwIt4iOMdNEwvFBPHsZHzRukCNGcKlfxbmWcQ2qjS+UsN
         IzLXJ65q/j5ijvMs3h+fZX+VBNaPgkKPagKLxCglfYX6TEPjEiCrxGfsMWXg/DOer4cs
         Q1K77VSirNxaSNNvcmonpH5NyriNtv5/A1M35DA2w2rKjth/kpjiNHeycdqEAvVDbbCg
         8FI3Dr6WXU9WPceBfJvv20+zLz7mfPZ5WF7EQNMe9fV7igx6VkBrN8WrNtev+T/69JHp
         ryeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0D/WBKifaDu0QJZs9LIL569qdjw+FHM82ekkuU6fuM=;
        b=2G81GCgXvXeNBTaCYs8ybqyOHmuAs8YMlOLWkS/nj/SUExSh3ehaXmfe2ngaSRnCVZ
         SggMLB8zOsy4YXjr6hLlb7evWs88G5r9kP+FOhvir+0UGnbYiV32W6lkAYAWHY4OxXuI
         j271X42w0MiG16tUIw8wQXM4oTTIK4/K0uZp8OKJM+PVe0actkRXqXWXD5d96t2MQwDl
         5wSL5gq8dSPXlA61/1jgcR0TLUFeL5AuQUOpu1Poo+l3j4jSIA4tipYLEk8PjllgrN88
         yfoXw9aYnMDy87YdmA/00lcUpnGcU17v+66Q+e69smc0gG8wUDBg6x3renhiBRei+HOh
         d+ow==
X-Gm-Message-State: AOAM530DfNDM6ZEb6xIoewaJt1opWWjmHDLDk+iq53uXL522d8S21jRD
        aq1vvozpMIklJhq7/vTYZAs6SQ==
X-Google-Smtp-Source: ABdhPJxYBmxv6gXRXs+b+cxGIwP3jmoRCvK74xS07EPSxgN90S1/2mQYEwexyNb2ELj/F4UwKJNm3A==
X-Received: by 2002:a17:902:6845:b0:153:9af1:3134 with SMTP id f5-20020a170902684500b001539af13134mr21522767pln.169.1648003973459;
        Tue, 22 Mar 2022 19:52:53 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id t2-20020a63a602000000b0038062a0bc6fsm18104869pge.67.2022.03.22.19.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 19:52:52 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v3 0/6] Support akcipher for virtio-crypto
Date:   Wed, 23 Mar 2022 10:49:06 +0800
Message-Id: <20220323024912.249789-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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

Lei He (3):
  crypto-akcipher: Introduce akcipher types to qapi
  crypto: Implement RSA algorithm by hogweed
  tests/crypto: Add test suite for crypto akcipher

Zhenwei Pi (3):
  virtio-crypto: header update
  crypto: Introduce akcipher crypto class
  virtio-crypto: Introduce RSA algorithm

 backends/cryptodev-builtin.c                  | 319 +++++++-
 backends/cryptodev-vhost-user.c               |  34 +-
 backends/cryptodev.c                          |  32 +-
 crypto/akcipher-nettle.c                      | 523 +++++++++++++
 crypto/akcipher.c                             |  81 ++
 crypto/asn1_decoder.c                         | 185 +++++
 crypto/asn1_decoder.h                         |  42 +
 crypto/meson.build                            |   4 +
 hw/virtio/virtio-crypto.c                     | 326 ++++++--
 include/crypto/akcipher.h                     | 155 ++++
 include/hw/virtio/virtio-crypto.h             |   5 +-
 .../standard-headers/linux/virtio_crypto.h    |  82 +-
 include/sysemu/cryptodev.h                    |  88 ++-
 meson.build                                   |  11 +
 qapi/crypto.json                              |  86 +++
 tests/bench/benchmark-crypto-akcipher.c       | 163 ++++
 tests/bench/meson.build                       |   6 +
 tests/bench/test_akcipher_keys.inc            | 277 +++++++
 tests/unit/meson.build                        |   1 +
 tests/unit/test-crypto-akcipher.c             | 715 ++++++++++++++++++
 20 files changed, 2990 insertions(+), 145 deletions(-)
 create mode 100644 crypto/akcipher-nettle.c
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/asn1_decoder.c
 create mode 100644 crypto/asn1_decoder.h
 create mode 100644 include/crypto/akcipher.h
 create mode 100644 tests/bench/benchmark-crypto-akcipher.c
 create mode 100644 tests/bench/test_akcipher_keys.inc
 create mode 100644 tests/unit/test-crypto-akcipher.c

-- 
2.25.1

