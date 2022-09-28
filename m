Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987D9C04A95
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Sep 2022 10:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiI1K01 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Sep 2022 06:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI1K00 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2022 06:26:26 -0400
X-Greylist: delayed 68 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 03:26:23 PDT
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E1EB5A46;
        Wed, 28 Sep 2022 03:26:23 -0700 (PDT)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 28 Sep
 2022 13:25:06 +0300
Received: from KANASHIN1.fintech.ru (10.0.253.125) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 28 Sep
 2022 13:25:06 +0300
From:   Natalia Petrova <n.petrova@fintech.ru>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Natalia Petrova <n.petrova@fintech.ru>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>
Subject: [PATCH] nitrox: avoid double free on error path in nitrox_sriov_init()
Date:   Wed, 28 Sep 2022 13:25:05 +0300
Message-ID: <20220928102505.39709-1-n.petrova@fintech.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.125]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If alloc_workqueue() fails in nitrox_mbox_init() it deallocates
ndev->iov.vfdev and returns error code, but then nitrox_sriov_init()
calls nitrox_sriov_cleanup() where ndev->iov.vfdev is deallocated
again.

Fix this by nulling ndev->iov.vfdev after the first deallocation.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/crypto/cavium/nitrox/nitrox_mbx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index 9e7308e39b30..d4e06999af9b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -195,6 +195,7 @@ int nitrox_mbox_init(struct nitrox_device *ndev)
 	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", 0, 0);
 	if (!ndev->iov.pf2vf_wq) {
 		kfree(ndev->iov.vfdev);
+		ndev->iov.vfdev = NULL;
 		return -ENOMEM;
 	}
 	/* enable pf2vf mailbox interrupts */
-- 
2.34.1

