Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C176C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D1D464E8B
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhBHJpL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:45:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11701 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhBHJmN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:42:13 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ1Fn0v32zlDXl;
        Mon,  8 Feb 2021 17:39:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:19 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 0/9] add ECDH and CURVE25519 algorithms support for Kunpeng 930
Date:   Mon, 8 Feb 2021 17:38:48 +0800
Message-ID: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
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

2. Add new elliptic(nist-p224, nist-p384, nist-p521) curve parameters
   definitions, and reorder ECDH 'Curves IDs';

3. Add new file 'include/crypto/ecc_curve.h', and move 'struct ecc_point' and
   'struct ecc_curve' definitions to it, also add new APIs 'ecc_get_curveXXX'
   into it, with these APIs, users in kernel tree can get ECDH and
   curve25519 parameters;

4. Add ECDH and CURVE25519 algorithms support for Kunpeng 930.

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



Meng Yu (9):
  crypto: hisilicon/hpre - add version adapt to new algorithms
  crypto: hisilicon/hpre - add algorithm type
  crypto: atmel-ecc - move curve_id of ECDH from the key to algorithm
    name
  net/bluetooth: modify ECDH name in 'crypto_alloc_kpp'
  crypto: move curve_id of ECDH to algorithm name
  crypto: add new ecc curve and expose them
  crypto: hisilicon/hpre - add 'ECDH' algorithm
  crypto: add curve25519 params and expose them
  crypto: hisilicon/hpre - add 'CURVE25519' algorithm

 crypto/ecc.c                                |   17 +-
 crypto/ecc.h                                |   37 +-
 crypto/ecc_curve_defs.h                     |  124 +++
 crypto/ecdh.c                               |   72 +-
 crypto/ecdh_helper.c                        |    4 +-
 crypto/testmgr.c                            |   11 +-
 crypto/testmgr.h                            |   32 +-
 drivers/crypto/atmel-ecc.c                  |   14 +-
 drivers/crypto/hisilicon/Kconfig            |    1 +
 drivers/crypto/hisilicon/hpre/hpre.h        |   17 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 1097 +++++++++++++++++++++++++--
 drivers/crypto/hisilicon/hpre/hpre_main.c   |   12 +-
 drivers/crypto/hisilicon/qm.c               |    4 +-
 drivers/crypto/hisilicon/qm.h               |    4 +-
 drivers/crypto/hisilicon/sec2/sec.h         |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h  |    4 +-
 drivers/crypto/hisilicon/zip/zip.h          |    4 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |    4 +-
 include/crypto/ecc_curve.h                  |   60 ++
 include/crypto/ecdh.h                       |    7 +-
 net/bluetooth/ecdh_helper.c                 |    2 -
 net/bluetooth/selftest.c                    |    2 +-
 net/bluetooth/smp.c                         |    6 +-
 24 files changed, 1370 insertions(+), 173 deletions(-)
 create mode 100644 include/crypto/ecc_curve.h

-- 
2.8.1

