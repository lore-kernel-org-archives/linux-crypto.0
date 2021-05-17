Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEDEC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 11:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9F2611CA
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 11:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhEQLEC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 07:04:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2997 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbhEQLEC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 07:04:02 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkGNN3PGZzQp1h;
        Mon, 17 May 2021 18:59:16 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 19:02:44 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 19:02:44 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] crypto: Fix spelling mistakes in header files
Date:   Mon, 17 May 2021 19:02:34 +0800
Message-ID: <20210517110234.7416-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix some spelling mistakes in comments:
cipherntext ==> ciphertext
syncronise ==> synchronise
feeded ==> fed

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/crypto/aead.h   | 2 +-
 include/crypto/engine.h | 2 +-
 include/crypto/hash.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index e728469c4ccc..5af914c1ab8e 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -490,7 +490,7 @@ static inline void aead_request_set_callback(struct aead_request *req,
  * The memory structure for cipher operation has the following structure:
  *
  * - AEAD encryption input:  assoc data || plaintext
- * - AEAD encryption output: assoc data || cipherntext || auth tag
+ * - AEAD encryption output: assoc data || ciphertext || auth tag
  * - AEAD decryption input:  assoc data || ciphertext || auth tag
  * - AEAD decryption output: assoc data || plaintext
  *
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 3f06e40d063a..26cac19b0f46 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -28,7 +28,7 @@
  * of a failed backlog request
  * crypto-engine, in head position to keep order
  * @list: link with the global crypto engine list
- * @queue_lock: spinlock to syncronise access to request queue
+ * @queue_lock: spinlock to synchronise access to request queue
  * @queue: the crypto queue of the engine
  * @rt: whether this queue is set to run as a realtime task
  * @prepare_crypt_hardware: a request will soon arrive from the queue
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b2bc1e46e86a..f140e4643949 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -458,7 +458,7 @@ int crypto_ahash_finup(struct ahash_request *req);
  *
  * Return:
  * 0		if the message digest was successfully calculated;
- * -EINPROGRESS	if data is feeded into hardware (DMA) or queued for later;
+ * -EINPROGRESS	if data is fed into hardware (DMA) or queued for later;
  * -EBUSY	if queue is full and request should be resubmitted later;
  * other < 0	if an error occurred
  */
-- 
2.25.1


