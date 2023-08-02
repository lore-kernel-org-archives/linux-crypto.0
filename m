Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67E9C001DE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Aug 2023 09:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjHBJSF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Aug 2023 05:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbjHBJRV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2023 05:17:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F832D68
        for <linux-crypto@vger.kernel.org>; Wed,  2 Aug 2023 02:17:10 -0700 (PDT)
Received: from dggpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RG5tt03P7zrRvw;
        Wed,  2 Aug 2023 17:16:06 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500009.china.huawei.com (7.185.36.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 17:17:08 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 2 Aug
 2023 17:17:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
CC:     <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yangyingliang@huawei.com>
Subject: [PATCH -next] crypto: qat - use kfree_sensitive instead of memset/kfree()
Date:   Wed, 2 Aug 2023 17:14:27 +0800
Message-ID: <20230802091427.3269183-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kfree_sensitive() instead of memset() and kfree().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 3f1f35283266..7842a9f22178 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -234,8 +234,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
 			 DMA_FROM_DEVICE);
-	memset(dc_data->ovf_buff, 0, dc_data->ovf_buff_sz);
-	kfree(dc_data->ovf_buff);
+	kfree_sensitive(dc_data->ovf_buff);
 	devm_kfree(dev, dc_data);
 	accel_dev->dc_data = NULL;
 }
-- 
2.25.1

