Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BF1C10F27
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966AF20848
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCHP5Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 11:57:25 -0400
Received: from foss.arm.com ([217.140.110.172]:45740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCHP5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 11:57:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 345FD7FA;
        Sun,  8 Mar 2020 08:57:24 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6D9B3F6CF;
        Sun,  8 Mar 2020 08:57:22 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: ccree - update register handling macros
Date:   Sun,  8 Mar 2020 17:57:04 +0200
Message-Id: <20200308155710.14546-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200308155710.14546-1-gilad@benyossef.com>
References: <20200308155710.14546-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hadar Gat <hadar.gat@arm.com>

Changed CC_GENMASK macro so it can be used for all HW registers.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 drivers/crypto/ccree/cc_driver.h        |  4 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h | 77 ++++++++++++-------------
 2 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 4790eb5cb8bd..a0fbf254f54b 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -71,9 +71,7 @@ enum cc_std_body {
 
 #define CC_NVM_IS_IDLE_MASK BIT(CC_NVM_IS_IDLE_VALUE_BIT_SHIFT)
 
-#define AXIM_MON_COMP_VALUE GENMASK(CC_AXIM_MON_COMP_VALUE_BIT_SIZE + \
-				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
-				    CC_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+#define AXIM_MON_COMP_VALUE CC_GENMASK(CC_AXIM_MON_COMP_VALUE)
 
 #define CC_CPP_AES_ABORT_MASK ( \
 	BIT(CC_HOST_IMR_REE_OP_ABORTED_AES_0_MASK_BIT_SHIFT) | \
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index 25ef28669989..15df58c66911 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -17,46 +17,43 @@
 /* Define max. available slots in HW queue */
 #define HW_QUEUE_SLOTS_MAX              15
 
-#define CC_REG_LOW(word, name)  \
-	(CC_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SHIFT)
-
-#define CC_REG_HIGH(word, name) \
-	(CC_REG_LOW(word, name) + \
-	 CC_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SIZE - 1)
-
-#define CC_GENMASK(word, name) \
-	GENMASK(CC_REG_HIGH(word, name), CC_REG_LOW(word, name))
-
-#define WORD0_VALUE		CC_GENMASK(0, VALUE)
-#define	WORD0_CPP_CIPHER_MODE	CC_GENMASK(0, CPP_CIPHER_MODE)
-#define WORD1_DIN_CONST_VALUE	CC_GENMASK(1, DIN_CONST_VALUE)
-#define WORD1_DIN_DMA_MODE	CC_GENMASK(1, DIN_DMA_MODE)
-#define WORD1_DIN_SIZE		CC_GENMASK(1, DIN_SIZE)
-#define WORD1_NOT_LAST		CC_GENMASK(1, NOT_LAST)
-#define WORD1_NS_BIT		CC_GENMASK(1, NS_BIT)
-#define WORD1_LOCK_QUEUE	CC_GENMASK(1, LOCK_QUEUE)
-#define WORD2_VALUE		CC_GENMASK(2, VALUE)
-#define WORD3_DOUT_DMA_MODE	CC_GENMASK(3, DOUT_DMA_MODE)
-#define WORD3_DOUT_LAST_IND	CC_GENMASK(3, DOUT_LAST_IND)
-#define WORD3_DOUT_SIZE		CC_GENMASK(3, DOUT_SIZE)
-#define WORD3_HASH_XOR_BIT	CC_GENMASK(3, HASH_XOR_BIT)
-#define WORD3_NS_BIT		CC_GENMASK(3, NS_BIT)
-#define WORD3_QUEUE_LAST_IND	CC_GENMASK(3, QUEUE_LAST_IND)
-#define WORD4_ACK_NEEDED	CC_GENMASK(4, ACK_NEEDED)
-#define WORD4_AES_SEL_N_HASH	CC_GENMASK(4, AES_SEL_N_HASH)
-#define WORD4_AES_XOR_CRYPTO_KEY CC_GENMASK(4, AES_XOR_CRYPTO_KEY)
-#define WORD4_BYTES_SWAP	CC_GENMASK(4, BYTES_SWAP)
-#define WORD4_CIPHER_CONF0	CC_GENMASK(4, CIPHER_CONF0)
-#define WORD4_CIPHER_CONF1	CC_GENMASK(4, CIPHER_CONF1)
-#define WORD4_CIPHER_CONF2	CC_GENMASK(4, CIPHER_CONF2)
-#define WORD4_CIPHER_DO		CC_GENMASK(4, CIPHER_DO)
-#define WORD4_CIPHER_MODE	CC_GENMASK(4, CIPHER_MODE)
-#define WORD4_CMAC_SIZE0	CC_GENMASK(4, CMAC_SIZE0)
-#define WORD4_DATA_FLOW_MODE	CC_GENMASK(4, DATA_FLOW_MODE)
-#define WORD4_KEY_SIZE		CC_GENMASK(4, KEY_SIZE)
-#define WORD4_SETUP_OPERATION	CC_GENMASK(4, SETUP_OPERATION)
-#define WORD5_DIN_ADDR_HIGH	CC_GENMASK(5, DIN_ADDR_HIGH)
-#define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
+#define CC_REG_LOW(name)  (name ## _BIT_SHIFT)
+#define CC_REG_HIGH(name) (CC_REG_LOW(name) + name ## _BIT_SIZE - 1)
+#define CC_GENMASK(name)  GENMASK(CC_REG_HIGH(name), CC_REG_LOW(name))
+
+#define CC_HWQ_GENMASK(word, field) \
+	CC_GENMASK(CC_DSCRPTR_QUEUE_WORD ## word ## _ ## field)
+
+#define WORD0_VALUE		CC_HWQ_GENMASK(0, VALUE)
+#define	WORD0_CPP_CIPHER_MODE	CC_HWQ_GENMASK(0, CPP_CIPHER_MODE)
+#define WORD1_DIN_CONST_VALUE	CC_HWQ_GENMASK(1, DIN_CONST_VALUE)
+#define WORD1_DIN_DMA_MODE	CC_HWQ_GENMASK(1, DIN_DMA_MODE)
+#define WORD1_DIN_SIZE		CC_HWQ_GENMASK(1, DIN_SIZE)
+#define WORD1_NOT_LAST		CC_HWQ_GENMASK(1, NOT_LAST)
+#define WORD1_NS_BIT		CC_HWQ_GENMASK(1, NS_BIT)
+#define WORD1_LOCK_QUEUE	CC_HWQ_GENMASK(1, LOCK_QUEUE)
+#define WORD2_VALUE		CC_HWQ_GENMASK(2, VALUE)
+#define WORD3_DOUT_DMA_MODE	CC_HWQ_GENMASK(3, DOUT_DMA_MODE)
+#define WORD3_DOUT_LAST_IND	CC_HWQ_GENMASK(3, DOUT_LAST_IND)
+#define WORD3_DOUT_SIZE		CC_HWQ_GENMASK(3, DOUT_SIZE)
+#define WORD3_HASH_XOR_BIT	CC_HWQ_GENMASK(3, HASH_XOR_BIT)
+#define WORD3_NS_BIT		CC_HWQ_GENMASK(3, NS_BIT)
+#define WORD3_QUEUE_LAST_IND	CC_HWQ_GENMASK(3, QUEUE_LAST_IND)
+#define WORD4_ACK_NEEDED	CC_HWQ_GENMASK(4, ACK_NEEDED)
+#define WORD4_AES_SEL_N_HASH	CC_HWQ_GENMASK(4, AES_SEL_N_HASH)
+#define WORD4_AES_XOR_CRYPTO_KEY CC_HWQ_GENMASK(4, AES_XOR_CRYPTO_KEY)
+#define WORD4_BYTES_SWAP	CC_HWQ_GENMASK(4, BYTES_SWAP)
+#define WORD4_CIPHER_CONF0	CC_HWQ_GENMASK(4, CIPHER_CONF0)
+#define WORD4_CIPHER_CONF1	CC_HWQ_GENMASK(4, CIPHER_CONF1)
+#define WORD4_CIPHER_CONF2	CC_HWQ_GENMASK(4, CIPHER_CONF2)
+#define WORD4_CIPHER_DO		CC_HWQ_GENMASK(4, CIPHER_DO)
+#define WORD4_CIPHER_MODE	CC_HWQ_GENMASK(4, CIPHER_MODE)
+#define WORD4_CMAC_SIZE0	CC_HWQ_GENMASK(4, CMAC_SIZE0)
+#define WORD4_DATA_FLOW_MODE	CC_HWQ_GENMASK(4, DATA_FLOW_MODE)
+#define WORD4_KEY_SIZE		CC_HWQ_GENMASK(4, KEY_SIZE)
+#define WORD4_SETUP_OPERATION	CC_HWQ_GENMASK(4, SETUP_OPERATION)
+#define WORD5_DIN_ADDR_HIGH	CC_HWQ_GENMASK(5, DIN_ADDR_HIGH)
+#define WORD5_DOUT_ADDR_HIGH	CC_HWQ_GENMASK(5, DOUT_ADDR_HIGH)
 
 /******************************************************************************
  *				TYPE DEFINITIONS
-- 
2.25.1

