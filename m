Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D74EE49AB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Aug 2023 07:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjHWHbq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Aug 2023 03:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjHWHbp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2023 03:31:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68623185
        for <linux-crypto@vger.kernel.org>; Wed, 23 Aug 2023 00:31:43 -0700 (PDT)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RVyX41FNXzTmcG;
        Wed, 23 Aug 2023 15:29:24 +0800 (CST)
Received: from hulk-vt.huawei.com (10.67.174.118) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 23 Aug 2023 15:31:39 +0800
From:   Lu Jialin <lujialin4@huawei.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC:     Lu Jialin <lujialin4@huawei.com>, Guo Zihua <guozihua@huawei.com>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH v2] crypto: Fix hungtask for PADATA_RESET
Date:   Wed, 23 Aug 2023 07:30:47 +0000
Message-ID: <20230823073047.1515137-1-lujialin4@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.118]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We found a hungtask bug in test_aead_vec_cfg as follows:

INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call trace:
 __switch_to+0x98/0xe0
 __schedule+0x6c4/0xf40
 schedule+0xd8/0x1b4
 schedule_timeout+0x474/0x560
 wait_for_common+0x368/0x4e0
 wait_for_completion+0x20/0x30
 test_aead_vec_cfg+0xab4/0xd50
 test_aead+0x144/0x1f0
 alg_test_aead+0xd8/0x1e0
 alg_test+0x634/0x890
 cryptomgr_test+0x40/0x70
 kthread+0x1e0/0x220
 ret_from_fork+0x10/0x18
 Kernel panic - not syncing: hung_task: blocked tasks

For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
case, aead_request_complete() will be called in pcrypt_aead_serial and the
return err is 0 for padata_do_parallel. But, when pinst->flags is
PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
hung at wait_for_completion(&wait->completion), which will cause
hungtask.

The problem comes as following:
(padata_do_parallel)                 |
    rcu_read_lock_bh();              |
    err = -EINVAL;                   |   (padata_replace)
                                     |     pinst->flags |= PADATA_RESET;
    err = -EBUSY                     |
    if (pinst->flags & PADATA_RESET) |
        rcu_read_unlock_bh()         |
        return err

In order to resolve the problem, we retry at most 5 times when
padata_do_parallel return -EBUSY. For more than 5 times, we replace the
return err -EBUSY with -EAGAIN, which means parallel_data is changing, and
the caller should call it again.

v2:
introduce padata_try_do_parallel() in pcrypt_aead_encrypt and
pcrypt_aead_decrypt to solve the hungtask

Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Guo Zihua <guozihua@huawei.com>
---
 crypto/pcrypt.c | 33 +++++++++++++++++++++++++++------
 kernel/padata.c |  2 +-
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8c1d0ca41213..9d4470482165 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -74,6 +74,31 @@ static void pcrypt_aead_done(void *data, int err)
 	padata_do_serial(padata);
 }
 
+/*
+ *  We retry at most 5 times when padata_do_parallel return -EBUSY.
+ *  For more than 5 times, we replace the return err -EBUSY with -EAGAIN,
+ *  which means parallel_data is changing, the caller should call it again.
+ */
+static int padata_try_do_paralell(struct padata_shell *ps,
+				  struct padata_priv *padata, int *cb_cpu)
+{
+	int err = 0;
+	int nr_retries = 5;
+
+	while (nr_retries--) {
+		err = padata_do_parallel(ps, padata, cb_cpu);
+		if (err != -EBUSY)
+			break;
+	}
+
+	if (err == 0)
+		err = -EINPROGRESS;
+	else if (err == -EBUSY)
+		err = -EAGAIN;
+
+	return err;
+}
+
 static void pcrypt_aead_enc(struct padata_priv *padata)
 {
 	struct pcrypt_request *preq = pcrypt_padata_request(padata);
@@ -114,9 +139,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
-	if (!err)
-		return -EINPROGRESS;
+	err = padata_try_do_paralell(ictx->psenc, padata, &ctx->cb_cpu);
 
 	return err;
 }
@@ -161,9 +184,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
-	if (!err)
-		return -EINPROGRESS;
+	err = padata_try_do_paralell(ictx->psenc, padata, &ctx->cb_cpu);
 
 	return err;
 }
diff --git a/kernel/padata.c b/kernel/padata.c
index 222d60195de6..81c8183f3176 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -202,7 +202,7 @@ int padata_do_parallel(struct padata_shell *ps,
 		*cb_cpu = cpu;
 	}
 
-	err =  -EBUSY;
+	err = -EBUSY;
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-- 
2.34.1

