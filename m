Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74D5C4361B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F08564EFD
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhCDGj3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:39:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13469 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhCDGjC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:39:02 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Drh3T2ZyDzjW5l;
        Thu,  4 Mar 2021 14:36:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Mar 2021 14:38:12 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 0/7] add ECDH and CURVE25519 algorithms support for Kunpeng 930
Date:   Thu, 4 Mar 2021 14:35:43 +0800
Message-ID: <1614839750-29670-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Move  curve ID from the key into the algorithm name (like 'ecdh-nist-pxxx'
   so we get its tfm like 'crypto_alloc_kpp("ecdh-nist-p256", 0, 0)'),
   in 'crypto/ecc.c' (has been verified by testmgr) and 'crypto/atmel-ecc.c'
   (only compiled, not do test), and modify 'testmgr.c' and 'net/bluetooth/smp.c'
   (only compiled, not do test) to adapt the modification;

2. Add new file 'include/crypto/ecc_curve.h', and move 'struct ecc_point' and
   'struct ecc_curve' definitions to it, also add new APIs 'ecc_get_curveXXX'
   into it, with these APIs, users in kernel tree can get ECDH and
   curve25519 parameters;

3. Add ECDH and CURVE25519 algorithms support for Kunpeng 930.

v9->v10:
- patch #3: delete 'atmel_ecdh_supported_curve' and 'n_sz' in atmel-ecc.c

v8->v9:
- patch #3: squash patches 3-5 in v8 into one in v9
- patch #4: delete ECDH curve parameters: P224, P384 and P521
- patch #5: delete ecdh-nist-p224, ecdh-nist-p384 and ecdh-nist-p521 support in HPRE

v7->v8:
- patch #3 and #5: move the curve ID from the key into the algorithm name instead

v6->v7:
- patch #4: add function interface to expose elliptic curve parameters
- patch #4: eliminate warning by 'kernel test robot'
- patch #5: add function interface to expose curve25519 parameters

v5->v6:
- patch #1: add a new patch (the first patch), which is the "depend on" patch before

v4->v5:
- patch #4: delete P-128 and P-320 curve, as the few using case in the kernel

v3 -> v4:
- patch #3: add new, and move ecc_curve params to "include/crypto"

v2 -> v3:
- patch #5: fix sparse warnings
- patch #5: add 'CRYPTO_LIB_CURVE25519_GENERIC' in 'Kconfig'

v1 -> v2:
- patch #5: delete `curve25519_null_point'


Meng Yu (7):
  crypto: hisilicon/hpre - add version adapt to new algorithms
  crypto: hisilicon/hpre - add algorithm type
  crypto: move curve_id of ECDH from the key to algorithm name
  crypto: and expose ecc curves
  crypto: hisilicon/hpre - add 'ECDH' algorithm
  crypto: add curve25519 params and expose them
  crypto: hisilicon/hpre - add 'CURVE25519' algorithm

 crypto/ecc.c                                |  11 +-
 crypto/ecc.h                                |  37 +-
 crypto/ecc_curve_defs.h                     |  17 +
 crypto/ecdh.c                               |  72 ++-
 crypto/ecdh_helper.c                        |   4 +-
 crypto/testmgr.c                            |  13 +-
 crypto/testmgr.h                            |  34 +-
 drivers/crypto/atmel-ecc.c                  |  28 +-
 drivers/crypto/hisilicon/Kconfig            |   1 +
 drivers/crypto/hisilicon/hpre/hpre.h        |  17 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 881 +++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  12 +-
 drivers/crypto/hisilicon/qm.c               |   4 +-
 drivers/crypto/hisilicon/qm.h               |   4 +-
 drivers/crypto/hisilicon/sec2/sec.h         |   4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |   4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h  |   4 +-
 drivers/crypto/hisilicon/zip/zip.h          |   4 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |   4 +-
 include/crypto/ecc_curve.h                  |  60 ++
 include/crypto/ecdh.h                       |   2 -
 net/bluetooth/ecdh_helper.c                 |   2 -
 net/bluetooth/selftest.c                    |   2 +-
 net/bluetooth/smp.c                         |   6 +-
 24 files changed, 1086 insertions(+), 141 deletions(-)
 create mode 100644 include/crypto/ecc_curve.h

-- 
2.8.1

