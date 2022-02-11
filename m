Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88734C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbiBKIpI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:45:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244156AbiBKIpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:45:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699EAE67
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso9700229pjd.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaB4eX5eIfNXcpFcbMwDNqkLnPT1dKU3PJWq0bzJplM=;
        b=YpWYXFjjs6RShsyABwDfvNm6jx79gmMxhaw1Fpaq+dJnqQXoCYTu2GmkSgtK8IZYXY
         ldohj3ygggnAWQK1+pJA3V4adQAXBiEp0ytiDNvAeVChe997HsHLoeN3u+h4vSOG9D1M
         o43M0/OhPBlte0SUrPcDRLxSeJ/S9VllFkQTzLBmwC1zbhC/2+XiI9zKYvm5b1CCBN3+
         AwzmtABTi/bzBfI9eKAijCHDVlELazxGygu5gV3p6iyoEsib1M41OqteIaqsa4z2AT6g
         maVOY4zLbvGkCzoEeYrOHIrAs15FYATsD6ndXrahQJOx7QCAJm29Ld3cdUoI+GX/YldI
         a/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaB4eX5eIfNXcpFcbMwDNqkLnPT1dKU3PJWq0bzJplM=;
        b=3GmikZb2wqOL+ClIBn4mVkBNLcUiByRqiMtYBhuXtn5y43QifzJtU4BYjSyvN4xBZb
         PtYVcoy3ezyVvxPYnavt4deBOk1O/NzpFzIai+tqiG4XTvtCrYSGht6qD9rC0uqDqfk8
         Ie7FcFeslo8xQ575AkDOHxn7BZjqRis0LIaMS7dbXSJ0T3HnSIpGYwlIy/l++FHp4Klh
         dxqN012Hf34XQQQ1evnG4B4P/aMZ87A2n5WFAs5qiX+H6LRrXncFok2Xnsjfqt7Cz9IK
         p1C+MfO8nVGcOHu/NAB2l9m2gct/LGVBc2BAFLF9BRvm89cZQq6z481QM86NtskJF9ZQ
         MtJg==
X-Gm-Message-State: AOAM531Ef8CZGPXs8o8TN7xZkNxcbMbQuqRtDYKtyKBl3mtU9yLLpqf6
        zIoBVzmSNexlIQWF2UycnM93Og==
X-Google-Smtp-Source: ABdhPJw8xZ6h9/FQPj8RwTXVV6Zt8ueVO/BXP2VbGZMp+CjlsH2Wx34zZmbUYlsiJxVDnpE/0+of0A==
X-Received: by 2002:a17:902:b493:: with SMTP id y19mr615916plr.97.1644569105992;
        Fri, 11 Feb 2022 00:45:05 -0800 (PST)
Received: from libai.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id u7sm3832686pgc.93.2022.02.11.00.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 00:45:05 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        helei.sig11@bytedance.com, herbert@gondor.apana.org.au,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 0/3] Support akcipher for virtio-crypto
Date:   Fri, 11 Feb 2022 16:43:32 +0800
Message-Id: <20220211084335.1254281-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v1 -> v2:
- Update virtio_crypto.h from v2 version of related kernel patch.

v1:
- Support akcipher for virtio-crypto.
- Introduce akcipher class.
- Introduce ASN1 decoder into QEMU.
- Implement RSA backend by nettle/hogweed.

Lei He (1):
  crypto: Introduce RSA algorithm

Zhenwei Pi (2):
  virtio-crypto: header update
  virtio_crypto: Support virtio crypto asym operation

 backends/cryptodev-builtin.c                  | 201 ++++++--
 backends/cryptodev-vhost-user.c               |  34 +-
 backends/cryptodev.c                          |  32 +-
 crypto/akcipher-nettle.c                      | 486 ++++++++++++++++++
 crypto/akcipher.c                             |  91 ++++
 crypto/asn1_decoder.c                         | 185 +++++++
 crypto/asn1_decoder.h                         |  42 ++
 crypto/meson.build                            |   4 +
 hw/virtio/virtio-crypto.c                     | 328 +++++++++---
 include/crypto/akcipher.h                     |  77 +++
 include/hw/virtio/virtio-crypto.h             |   5 +-
 .../standard-headers/linux/virtio_crypto.h    |  82 ++-
 include/sysemu/cryptodev.h                    |  88 +++-
 meson.build                                   |  11 +
 14 files changed, 1518 insertions(+), 148 deletions(-)
 create mode 100644 crypto/akcipher-nettle.c
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/asn1_decoder.c
 create mode 100644 crypto/asn1_decoder.h
 create mode 100644 include/crypto/akcipher.h

-- 
2.20.1

