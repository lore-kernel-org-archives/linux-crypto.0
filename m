Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E38C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836A564E92
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhBHJpz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:45:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12491 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhBHJmk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:42:40 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ1GJ0fpGzjKqr;
        Mon,  8 Feb 2021 17:40:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:20 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 4/9] net/bluetooth: modify ECDH name in 'crypto_alloc_kpp'
Date:   Mon, 8 Feb 2021 17:38:52 +0800
Message-ID: <1612777137-51067-5-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Algorithm name of ECDH will be changed in crypto, so we modify its name
when we call ECDH.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 net/bluetooth/ecdh_helper.c | 2 --
 net/bluetooth/selftest.c    | 2 +-
 net/bluetooth/smp.c         | 6 +++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 3226fe0..989401f 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -126,8 +126,6 @@ int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
 	int err;
 	struct ecdh p = {0};
 
-	p.curve_id = ECC_CURVE_NIST_P256;
-
 	if (private_key) {
 		tmp = kmalloc(32, GFP_KERNEL);
 		if (!tmp)
diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f71c6fa..f49604d 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -205,7 +205,7 @@ static int __init test_ecdh(void)
 
 	calltime = ktime_get();
 
-	tfm = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		err = PTR_ERR(tfm);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index c659c46..5de73de 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1387,7 +1387,7 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 		goto zfree_smp;
 	}
 
-	smp->tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	smp->tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(smp->tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		goto free_shash;
@@ -3282,7 +3282,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 		return ERR_CAST(tfm_cmac);
 	}
 
-	tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
@@ -3807,7 +3807,7 @@ int __init bt_selftest_smp(void)
 		return PTR_ERR(tfm_cmac);
 	}
 
-	tfm_ecdh = crypto_alloc_kpp("ecdh", 0, 0);
+	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
 		crypto_free_shash(tfm_cmac);
-- 
2.8.1

