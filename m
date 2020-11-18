Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DC0C5519F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC16B20DD4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgKRDsw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 22:48:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7639 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgKRDsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 22:48:51 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CbTLV6Tm7z15Mhy;
        Wed, 18 Nov 2020 11:48:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 11:48:40 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/5] crypto: hisilicon/hpre - add something for Kunpeng 930
Date:   Wed, 18 Nov 2020 11:46:56 +0800
Message-ID: <1605671221-30692-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add algorithms(ECDH and CURVE25519) in Kunpeng 930.

v2 -> v3:
- patch #1: add a 'Signed-off-by' from its author
- patch #5: fix sparse warnings
- patch #5: add 'CRYPTO_LIB_CURVE25519_GENERIC' in 'Kconfig'

v1 -> v2:
- patch #5: delete 'curve25519_null_point'

Hui Tang (1):
  crypto: hisilicon/hpre - add initial settings adapt to 'Kunpeng 930'

Meng Yu (4):
  crypto: hisilicon/hpre - add version adapt to new algorithms
  crypto: hisilicon/hpre - add algorithm type
  crypto: hisilicon/hpre - add 'ECDH' algorithm
  crypto: hisilicon/hpre - add 'CURVE25519' algorithm

 drivers/crypto/hisilicon/Kconfig            |    1 +
 drivers/crypto/hisilicon/hpre/hpre.h        |   25 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 1194 ++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  105 ++-
 drivers/crypto/hisilicon/qm.c               |    4 +-
 drivers/crypto/hisilicon/qm.h               |    4 +-
 drivers/crypto/hisilicon/sec2/sec.h         |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h  |    4 +-
 drivers/crypto/hisilicon/zip/zip.h          |    4 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |    4 +-
 11 files changed, 1289 insertions(+), 64 deletions(-)

-- 
2.8.1

