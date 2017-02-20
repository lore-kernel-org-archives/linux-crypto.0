From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 0/9]  improve performances on mediatek crypto driver
Date: Mon, 20 Feb 2017 17:26:53 +0800
Message-ID: <1487582822-30393-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-mediatek@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:50594 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752418AbdBTJ1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 04:27:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

Some patches of this series improve the performances whereas others
clean up code and refine data structure to make it more efficient.

It also adds support to AES-OFB and AES-CFB128. The new mode has been
tested by using the tcrypt

Ryder Lee (9):
  crypto: mediatek - rework interrupt handler
  crypto: mediatek - add MTK_* prefix and correct annotations.
  crypto: mediatek - make mtk_sha_xmit() more generic
  crypto: mediatek - simplify descriptor ring management
  crypto: mediatek - add queue_task tasklet
  crypto: mediatek - fix error handling in mtk_aes_complete()
  crypto: mediatek - add mtk_aes_gcm_tag_verify()
  crypto: mediatek - make hardware operation flow more efficient
  crypto: mediatek - add support to OFB mode and CFB128 mode

 drivers/crypto/mediatek/mtk-aes.c      | 503 +++++++++++++++++++--------------
 drivers/crypto/mediatek/mtk-platform.c |  15 +-
 drivers/crypto/mediatek/mtk-platform.h |  56 ++--
 drivers/crypto/mediatek/mtk-sha.c      | 309 ++++++++------------
 4 files changed, 446 insertions(+), 437 deletions(-)

-- 
1.9.1
