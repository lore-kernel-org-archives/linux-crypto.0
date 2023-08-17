Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55725C2FC29
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Aug 2023 13:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjHQNtB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351591AbjHQNs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2023 09:48:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE53210D
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2023 06:48:57 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RRRC93sytz1GDJw;
        Thu, 17 Aug 2023 21:47:33 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 17 Aug
 2023 21:48:55 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <yuehaibing@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: chelsio - Remove unused declarations
Date:   Thu, 17 Aug 2023 21:48:54 +0800
Message-ID: <20230817134854.18772-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These declarations are not implemented now, remove them.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_core.h   | 1 -
 drivers/crypto/chelsio/chcr_crypto.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index f7c8bb95a71b..5e9d568131fe 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -133,7 +133,6 @@ int start_crypto(void);
 int stop_crypto(void);
 int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
 			const struct pkt_gl *pgl);
-int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev);
 int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 		     int err);
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 7f88ddb08631..1d693b8436e6 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -344,7 +344,6 @@ void chcr_add_cipher_dst_ent(struct skcipher_request *req,
 			     struct cpl_rx_phys_dsgl *phys_cpl,
 			     struct  cipher_wr_param *wrparam,
 			     unsigned short qid);
-int sg_nents_len_skip(struct scatterlist *sg, u64 len, u64 skip);
 void chcr_add_hash_src_ent(struct ahash_request *req, struct ulptx_sgl *ulptx,
 			   struct hash_wr_param *param);
 int chcr_hash_dma_map(struct device *dev, struct ahash_request *req);
-- 
2.34.1

