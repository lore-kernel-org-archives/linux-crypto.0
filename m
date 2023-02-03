Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A64C61DA4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 09:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjBCJiL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Feb 2023 04:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBCJiH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2023 04:38:07 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A9CEFA6;
        Fri,  3 Feb 2023 01:38:06 -0800 (PST)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P7VsR1M9PzJsG4;
        Fri,  3 Feb 2023 17:36:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 3 Feb 2023 17:38:04 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 0/5] crypto: hisilicon/qm - some fixes and cleanups
Date:   Fri, 3 Feb 2023 17:37:25 +0800
Message-ID: <20230203093730.49314-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix and clean up some issues in qm.c and sgl.c.

Weili Qian (5):
  crypto: hisilicon/qm - remove some unused defines
  crypto: hisilicon/qm - change data type in min_t
  crypto: hisilicon/qm - change function names
  crypto: hisilicon/qm - update comments to match function
  crypto: hisilicon/qm - fix coding style issues

 drivers/crypto/hisilicon/qm.c  | 54 ++++++++++++----------------------
 drivers/crypto/hisilicon/sgl.c |  1 -
 include/linux/hisi_acc_qm.h    |  5 ++--
 3 files changed, 21 insertions(+), 39 deletions(-)

-- 
2.33.0

