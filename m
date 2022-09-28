Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E255C04A95
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Sep 2022 07:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiI1Hkc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Sep 2022 03:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiI1Hjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2022 03:39:53 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918071129C3;
        Wed, 28 Sep 2022 00:38:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guanjun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VQv1uEy_1664350687;
Received: from localhost(mailfrom:guanjun@linux.alibaba.com fp:SMTPD_---0VQv1uEy_1664350687)
          by smtp.aliyun-inc.com;
          Wed, 28 Sep 2022 15:38:08 +0800
From:   'Guanjun' <guanjun@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, elliott@hpe.com
Cc:     zelin.deng@linux.alibaba.com, guanjun@linux.alibaba.com,
        xuchun.shang@linux.alibaba.com, artie.ding@linux.alibaba.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] Drivers for Alibaba YCC (Yitian Cryptography Complex) cryptographic accelerator
Date:   Wed, 28 Sep 2022 15:37:58 +0800
Message-Id: <1664350687-47330-1-git-send-email-guanjun@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Guanjun <guanjun@linux.alibaba.com>

Hi,

This patch series aims to add drivers for Alibaba YCC (Yitian Cryptography Complex)
cryptographic accelerator. Enables the on-chip cryptographic accelerator of
Alibaba Yitian SoCs which is based on ARMv9 architecture.

It includes PCIe enabling, skcipher, aead, rsa, sm2 support.

Please help to review.

Thanks,
Guanjun.

Change log:
v1 RESEND -> v2:
 - [01/09] Remove char device that is not used now.

v1 -> v1 RESEND:
  - [01/09] Adjust the Kconfig entry in alphabetical order
  - [05/09][07/09][08/09] Adjust the format of algorithm names

v1: https://lore.kernel.org/all/1661334621-44413-1-git-send-email-guanjun@linux.alibaba.com/
v1 RESEND: https://lore.kernel.org/all/1662435353-114812-1-git-send-email-guanjun@linux.alibaba.com/

Guanjun (3):
  crypto/ycc: Add skcipher algorithm support
  crypto/ycc: Add aead algorithm support
  crypto/ycc: Add rsa algorithm support

Xuchun Shang (1):
  crypto/ycc: Add sm2 algorithm support

Zelin Deng (5):
  crypto/ycc: Add YCC (Yitian Cryptography Complex) accelerator driver
  crypto/ycc: Add ycc ring configuration
  crypto/ycc: Add irq support for ycc kernel rings
  crypto/ycc: Add device error handling support for ycc hw errors
  MAINTAINERS: Add Yitian Cryptography Complex (YCC) driver maintainer
    entry

 MAINTAINERS                            |   8 +
 drivers/crypto/Kconfig                 |   2 +
 drivers/crypto/Makefile                |   1 +
 drivers/crypto/ycc/Kconfig             |  18 +
 drivers/crypto/ycc/Makefile            |   4 +
 drivers/crypto/ycc/sm2signature_asn1.c |  38 ++
 drivers/crypto/ycc/sm2signature_asn1.h |  13 +
 drivers/crypto/ycc/ycc_aead.c          | 646 ++++++++++++++++++++++
 drivers/crypto/ycc/ycc_algs.h          | 176 ++++++
 drivers/crypto/ycc/ycc_dev.h           | 157 ++++++
 drivers/crypto/ycc/ycc_drv.c           | 567 ++++++++++++++++++++
 drivers/crypto/ycc/ycc_isr.c           | 279 ++++++++++
 drivers/crypto/ycc/ycc_isr.h           |  12 +
 drivers/crypto/ycc/ycc_pke.c           | 944 +++++++++++++++++++++++++++++++++
 drivers/crypto/ycc/ycc_ring.c          | 652 +++++++++++++++++++++++
 drivers/crypto/ycc/ycc_ring.h          | 168 ++++++
 drivers/crypto/ycc/ycc_ske.c           | 925 ++++++++++++++++++++++++++++++++
 17 files changed, 4610 insertions(+)
 create mode 100644 drivers/crypto/ycc/Kconfig
 create mode 100644 drivers/crypto/ycc/Makefile
 create mode 100644 drivers/crypto/ycc/sm2signature_asn1.c
 create mode 100644 drivers/crypto/ycc/sm2signature_asn1.h
 create mode 100644 drivers/crypto/ycc/ycc_aead.c
 create mode 100644 drivers/crypto/ycc/ycc_algs.h
 create mode 100644 drivers/crypto/ycc/ycc_dev.h
 create mode 100644 drivers/crypto/ycc/ycc_drv.c
 create mode 100644 drivers/crypto/ycc/ycc_isr.c
 create mode 100644 drivers/crypto/ycc/ycc_isr.h
 create mode 100644 drivers/crypto/ycc/ycc_pke.c
 create mode 100644 drivers/crypto/ycc/ycc_ring.c
 create mode 100644 drivers/crypto/ycc/ycc_ring.h
 create mode 100644 drivers/crypto/ycc/ycc_ske.c

-- 
1.8.3.1

