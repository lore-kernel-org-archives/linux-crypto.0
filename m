Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCE2EB64D7
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 02:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjFSCQQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jun 2023 22:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjFSCQP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jun 2023 22:16:15 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5196FE56
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 19:16:05 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qktdl5QcqzTjvF;
        Mon, 19 Jun 2023 10:15:23 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 19 Jun
 2023 10:16:01 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH RFC v2 0/3] crypto: Introduce SM9 key exchange
Date:   Mon, 19 Jun 2023 10:15:00 +0800
Message-ID: <20230619021503.29814-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

v2:
  Added crypto/sm9.h which fixes build error.

GUO Zihua (3):
  MPI: Export mpi_add_ui and mpi_mod for SM9
  crypto: Introduce SM9 key exchange algorithm library
  crypto: Introduce SM9 key exchange algorithm

 crypto/Kconfig       |   15 +
 crypto/Makefile      |    4 +
 crypto/sm9.c         |  916 ++++++++++++++++++++++++
 crypto/sm9_lib.c     | 1584 ++++++++++++++++++++++++++++++++++++++++++
 crypto/sm9_lib.h     |   92 +++
 include/crypto/sm9.h |   84 +++
 lib/mpi/mpi-add.c    |    2 +-
 lib/mpi/mpi-mod.c    |    1 +
 8 files changed, 2697 insertions(+), 1 deletion(-)
 create mode 100644 crypto/sm9.c
 create mode 100644 crypto/sm9_lib.c
 create mode 100644 crypto/sm9_lib.h
 create mode 100644 include/crypto/sm9.h

-- 
2.17.1

