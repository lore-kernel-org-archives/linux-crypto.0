Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15F1C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 09:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiDRJHJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 05:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiDRJHJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 05:07:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7FE101D2
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso13524459pjf.5
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 02:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zwb8mG+JIzADfsDfu33jNg4PhKLseW5IOVJoEfJh+pU=;
        b=Q51XoRzYcy3Iq4zZECeVxoNnEwswZKxs01rU4rfPh3NYRYFK5llkZQGhFhpG+hYXE6
         7CGeg6r6SHSAUjsXLL42uwwDLyYx+fbpVYGGar9E0ixVUE6JwbV6z13e+KuPwtbm6n9Q
         5+AdJn3h4XNciFzz4QPahKtLkKzWni91j23FntOjP7jX+7ccUdxF0WAROoS6XkhStLVP
         XafEStfMYTX1b4fLoJu85vnIIYxf4S6XjQXLiltE6tlPXwKiuwEZqlElROaU9PdvqlVz
         7O+8coD9+WiZffIuoXsl4SclNoILqlMzNdaNUFawJei16OG3H3NZfEJk1yQRMxQigfK8
         fSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zwb8mG+JIzADfsDfu33jNg4PhKLseW5IOVJoEfJh+pU=;
        b=6JlNFLvfEeaIQZJaBQCxD8JAu88BureraFgM8N+sRza4al8dcaX1pe9GhAuX03mbRV
         bmudc9ps68ymYvbun4QbxExvC5JTVouqX9cc1/qzmCQrRjxjM35gxkmUMGQkrN3cbuPW
         P1usK07FaBc3dlSvZHDR5+LgJc2UiUBwXoKDwp07jQQMbjuOD6qNviJRvjWuMnFyhV0m
         euXfIOH1i9OWzjR8ZsnaK4Fedrl3OeI00Pz3SN3UaHQ0Z8chPOJm249HAEfKH1Haxkld
         wAapyb1qmqPA0fLNy79ZUfmOpgv/j8ga5AdV7HvfyLzc8zJR/DMJXYkWGfaXTzRfMkRx
         HSvw==
X-Gm-Message-State: AOAM530Zs5C26FKDLZNPVvjGpDJRx2BSlIZTDcUxsVnzAFLCT5R4i53x
        01I5Hs0Jn0BZzvTx1uYsdGTPHA==
X-Google-Smtp-Source: ABdhPJzUzc4cYn2K0PfMzlKo4MeWwU0ulkQ6wJc7kLElOp+ZdHUtAw0JCPmVHhRUWWSy0Xc583iZRA==
X-Received: by 2002:a17:902:e881:b0:159:828:b6dd with SMTP id w1-20020a170902e88100b001590828b6ddmr1072674plg.127.1650272669849;
        Mon, 18 Apr 2022 02:04:29 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a7f9500b001c97c6bcaf4sm16408071pjl.39.2022.04.18.02.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 02:04:29 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 0/4] virtio-crypto: Improve performance
Date:   Mon, 18 Apr 2022 17:00:47 +0800
Message-Id: <20220418090051.372803-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v1 -> v2:
 - Use kfree instead of kfree_sensitive for insensitive buffer.
 - Several coding style fix.
 - Use memory from current node, instead of memory close to device
 - Add more message in commit, also explain why removing per-device
   request buffer.
 - Add necessary comment in code to explain why using kzalloc to
   allocate struct virtio_crypto_ctrl_request.

v1:
The main point of this series is to improve the performance for
virtio crypto:
- Use wait mechanism instead of busy polling for ctrl queue, this
  reduces CPU and lock racing, it's possiable to create/destroy session
  parallelly, QPS increases from ~40K/s to ~200K/s.
- Enable retry on crypto engine to improve performance for data queue,
  this allows the larger depth instead of 1.
- Fix dst data length in akcipher service.
- Other style fix.

lei he (2):
  virtio-crypto: adjust dst_len at ops callback
  virtio-crypto: enable retry for virtio-crypto-dev

zhenwei pi (2):
  virtio-crypto: wait ctrl queue instead of busy polling
  virtio-crypto: move helpers into virtio_crypto_common.c

 drivers/crypto/virtio/Makefile                |   1 +
 .../virtio/virtio_crypto_akcipher_algs.c      |  95 ++++++-------
 drivers/crypto/virtio/virtio_crypto_common.c  |  92 ++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h  |  27 +++-
 drivers/crypto/virtio/virtio_crypto_core.c    |  37 +----
 .../virtio/virtio_crypto_skcipher_algs.c      | 133 ++++++++----------
 6 files changed, 224 insertions(+), 161 deletions(-)
 create mode 100644 drivers/crypto/virtio/virtio_crypto_common.c

-- 
2.20.1

