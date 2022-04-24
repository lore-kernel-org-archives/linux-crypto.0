Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A508C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Apr 2022 10:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbiDXKso (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Apr 2022 06:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbiDXKsh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Apr 2022 06:48:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5354F18380
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w16so5811502pfj.2
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 03:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hgm0iMTcbJlWpJC7de8Vsbhe1vIzSyz1TGNEgDqQz+s=;
        b=ikRtpf8MarBHAoBqvMR+OoxFFlHT4UonYiMPc6JtqDOyLGlKd7Yxjo+Ysp+CehIzUE
         Gbt2nTdm3Q7mqK5pKyBxG/qVQc/ZRKsv/NrGCJQhoDnRj/ppQqaKvnaZFtVxJIK9x7qq
         tZl+vXUNMrpAMC5rV1pALvQzfNAxPxDhLnrVh8OP5qDN409ngYEauF0+fJTexGKTnZE5
         P/KtbNfkp8PJ171jnacykY093Kn8MaAkLSgZur2IQa/YDk/9vqnRrXLaLtTaDqwZ86oP
         n2iYLh9HUI/mOLxpILAybQoiGZ9AJuyMZDI91eVjoFwrIW+AXFfx1vtC31ARhlZRq+cw
         1Bhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hgm0iMTcbJlWpJC7de8Vsbhe1vIzSyz1TGNEgDqQz+s=;
        b=Dx+H8DGRpGYIHDNiSehrgsEvrAqIL6/cmRXlXUb75OLunIDU3+F0DEXkDjC1MhIO+l
         DGUl0rAn+60MiS/NbDpW7CBENPjnKouBTwoHCOwBpZpNtykSdy1g+8HcJDiQZsmDYlva
         iFNolL0cvT/YFRn2/hevkCstZHmicceQuh2CBIpb5cyqzTHtqKv1lJERwAZXmwvaenrN
         EcGY2T7YFIaAbEgf0wwIhL3QCYI/bGPk3tSbUg+9Ka7NweFczZIfVQ/25Wic9na8Y3dF
         fX/JeORz/lcMqHXlj59OH9HUjfHPTxEBaoBwfnM9Yt0bYwmUTau0Z6u6C8CQFh/0s2KJ
         JGiQ==
X-Gm-Message-State: AOAM533NPjQ6ZffJo1PnILdYuValw1Iby1u/nvJ0jAv2FFOIpNKi97SD
        HH6IX+Q45ZRnouVJaXIwFXe5Gg==
X-Google-Smtp-Source: ABdhPJzIq0JOsGhq12ZVie8DTSsfCThiz74j8+by2Hiziw6U0PFUHueUFgGrCYA3vhcWggPqU6xmoQ==
X-Received: by 2002:a05:6a00:ad0:b0:50a:51b3:1e3d with SMTP id c16-20020a056a000ad000b0050a51b31e3dmr13758409pfl.18.1650797135837;
        Sun, 24 Apr 2022 03:45:35 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id y2-20020a056a00190200b004fa865d1fd3sm8287295pfi.86.2022.04.24.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 03:45:35 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        davem@davemloft.net, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v4 0/5] virtio-crypto: Improve performance
Date:   Sun, 24 Apr 2022 18:41:35 +0800
Message-Id: <20220424104140.44841-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Lei
I'd like to move helper and callback functions(Eg, virtcrypto_clear_request
 and virtcrypto_ctrlq_callback) from xx_core.c to xx_common.c,
then the xx_core.c supports:
  - probe/remove/irq affinity seting for a virtio device
  - basic virtio related operations

xx_common.c supports:
  - common helpers/functions for algos

Do you have any suggestion about this?

v3 -> v4:
 - Don't create new file virtio_common.c, the new functions are added
   into virtio_crypto_core.c
 - Split the first patch into two parts:
     1, change code style,
     2, use private buffer instead of shared buffer
 - Remove relevant change.
 - Other minor changes.

v2 -> v3:
 - Jason suggested that spliting the first patch into two part:
     1, using private buffer
     2, remove the busy polling
   Rework as Jason's suggestion, this makes the smaller change in
   each one and clear.

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

zhenwei pi (3):
  virtio-crypto: change code style
  virtio-crypto: use private buffer for control request
  virtio-crypto: wait ctrl queue instead of busy polling

 .../virtio/virtio_crypto_akcipher_algs.c      |  83 ++++++-----
 drivers/crypto/virtio/virtio_crypto_common.h  |  21 ++-
 drivers/crypto/virtio/virtio_crypto_core.c    |  55 ++++++-
 .../virtio/virtio_crypto_skcipher_algs.c      | 140 ++++++++----------
 4 files changed, 180 insertions(+), 119 deletions(-)

-- 
2.20.1

