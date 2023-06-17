Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E438EB64D9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jun 2023 10:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjFQKPt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jun 2023 06:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjFQKPr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jun 2023 06:15:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E81B1BCF
        for <linux-crypto@vger.kernel.org>; Sat, 17 Jun 2023 03:15:46 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QjsND3FRNzTknD;
        Sat, 17 Jun 2023 18:15:08 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 17 Jun
 2023 18:15:43 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [RFC PATCH 0/3] crypto: Introduce SM9 key exchange
Date:   Sat, 17 Jun 2023 18:14:40 +0800
Message-ID: <20230617101443.6083-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ID-based key exchange algorithms provides the capability of using a
human-readable ID as the public key and generate corresponding private
key base on that ID. With a pre-defined pattern, the ID could be
generated with openly known knowledge of the opponent, eliminating the
need of a certificate and avoiding the whole verification chain.

Instead of CAs, ID-based crypto algorithm relies on a KGC (Key
Generation Center) for generating and distrubuting of private keys.
Unlike CAs, KGC is not directly involved in any of the crypto
procedures.

SM9 is an ID-based crypto algorithm within the ShangMi family. The key
exchange part of it was accepted in ISO/IEC 11770-3:2021. This patchset
introduces key exchange capability of SM9.

ID-based crypto algorithms are widely accepted as the next gen
asymmetric cryptography for various fileds including telecommunication,
emails, IoT etc..

You can find the technical details in the last two patch.

v4:
  Fixed typo in commit message; Marked non-exported function as static.

v3:
  Fixed memleaks.

v2:
  Updated the identification of initiator, changed function name for
getting sk; Split the patchset into 3 patches in order to ease code
review.

GUO Zihua (3):
  MPI: Export mpi_add_ui and mpi_mod for SM9
  crypto: Introduce SM9 key exchange algorithm library
  crypto: Introduce SM9 key exchange algorithm

 crypto/Kconfig    |   15 +
 crypto/Makefile   |    4 +
 crypto/sm9.c      |  916 ++++++++++++++++++++++++++
 crypto/sm9_lib.c  | 1584 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/sm9_lib.h  |   92 +++
 lib/mpi/mpi-add.c |    2 +-
 lib/mpi/mpi-mod.c |    1 +
 7 files changed, 2613 insertions(+), 1 deletion(-)
 create mode 100644 crypto/sm9.c
 create mode 100644 crypto/sm9_lib.c
 create mode 100644 crypto/sm9_lib.h

-- 
2.17.1

