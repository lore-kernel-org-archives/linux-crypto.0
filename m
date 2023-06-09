Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21FCC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 13:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbjFINSp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbjFINSj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 09:18:39 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FDE3588;
        Fri,  9 Jun 2023 06:18:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VkiFA6C_1686316699;
Received: from localhost.localdomain(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VkiFA6C_1686316699)
          by smtp.aliyun-inc.com;
          Fri, 09 Jun 2023 21:18:28 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH 0/3] fixup potential cpu stall
Date:   Fri,  9 Jun 2023 21:18:14 +0800
Message-Id: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cpu stall issue may happen if device is configured with multi queues
and large queue depth, so fix it.

Xianting Tian (3):
  virtio-crypto: fixup potential cpu stall when free unused bufs
  virtio_console: fixup potential cpu stall when free unused bufs
  virtio_bt: fixup potential cpu stall when free unused bufs

 drivers/bluetooth/virtio_bt.c              | 1 +
 drivers/char/virtio_console.c              | 1 +
 drivers/crypto/virtio/virtio_crypto_core.c | 1 +
 3 files changed, 3 insertions(+)

-- 
2.17.1

