From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/5] crypto pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:11 +0530
Message-ID: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38693 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933486AbdIYKhW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 06:37:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Arvind Yadav (5):
  [PATCH 1/5] crypto: omap-aes: pr_err() strings should end with newlines
  [PATCH 2/5] crypto: virtio: pr_err() strings should end with newlines
  [PATCH 3/5] crypto: chelsio: pr_err() strings should end with newlines
  [PATCH 4/5] crypto: qat: pr_err() strings should end with newlines
  [PATCH 5/5] crypto: bcm: pr_err() strings should end with newlines

 drivers/crypto/bcm/util.c                  | 14 +++++++-------
 drivers/crypto/chelsio/chcr_core.c         |  2 +-
 drivers/crypto/omap-aes-gcm.c              |  2 +-
 drivers/crypto/qat/qat_common/qat_uclo.c   | 12 ++++++------
 drivers/crypto/virtio/virtio_crypto_algs.c |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

-- 
1.9.1
