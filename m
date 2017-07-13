From: Xulin Sun <xulin.sun@windriver.com>
Subject: [PATCH v2] crypto: caam - free qman_fq after kill_fq
Date: Thu, 13 Jul 2017 05:21:01 -0400
Message-ID: <20170713092101.145505-1-xulin.sun@windriver.com>
References: <20170711062107.182889-1-xulin.sun@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xulinsun@gmail.com>, <xulin.sun@windriver.com>
To: <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:47710 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdGMJVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 05:21:15 -0400
In-Reply-To: <20170711062107.182889-1-xulin.sun@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kill_fq removes a complete frame queue, it needs to free the qman_fq
in the last. Else kmemleak will report the below warning:

unreferenced object 0xffff800073085c80 (size 128):
  comm "cryptomgr_test", pid 199, jiffies 4294937850 (age 67.840s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 a0 80 7e 00 00 80 ff ff
    00 00 00 00 00 00 00 00 04 00 04 00 5c 01 00 00
  backtrace:
    [<ffff8000001e5760>] create_object+0xf8/0x258
    [<ffff800000994e38>] kmemleak_alloc+0x58/0xa0
    [<ffff8000001d5f18>] kmem_cache_alloc_trace+0x2c8/0x358
    [<ffff8000007e8410>] create_caam_req_fq+0x40/0x170
    [<ffff8000007e870c>] caam_drv_ctx_update+0x54/0x248
    [<ffff8000007fca54>] aead_setkey+0x154/0x300
    [<ffff800000452120>] setkey+0x50/0xf0
    [<ffff80000045b144>] __test_aead+0x5ec/0x1028
    [<ffff80000045c28c>] test_aead+0x44/0xc8
    [<ffff80000045c368>] alg_test_aead+0x58/0xd0
    [<ffff80000045bdb4>] alg_test+0x14c/0x308
    [<ffff8000004588e8>] cryptomgr_test+0x50/0x58
    [<ffff8000000c3b2c>] kthread+0xdc/0xf0
    [<ffff800000083c00>] ret_from_fork+0x10/0x50

And check where the function kill_fq() is called to remove
the additional kfree to qman_fq and avoid re-calling the released qman_fq.

Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
---
v1->v2:
Checked where the function kill_fq() is called to avoid re-calling the released
qman_fq. 

 drivers/crypto/caam/qi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 1990ed4..608ce91 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -277,6 +277,7 @@ static int kill_fq(struct device *qidev, struct qman_fq *fq)
 		dev_err(qidev, "OOS of FQID: %u failed\n", fq->fqid);
 
 	qman_destroy_fq(fq);
+	kfree(fq);
 
 	return ret;
 }
@@ -342,8 +343,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 		drv_ctx->req_fq = old_fq;
 
 		if (kill_fq(qidev, new_fq))
-			dev_warn(qidev, "New CAAM FQ: %u kill failed\n",
-				 new_fq->fqid);
+			dev_warn(qidev, "New CAAM FQ kill failed\n");
 
 		return ret;
 	}
@@ -373,10 +373,9 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 		drv_ctx->req_fq = old_fq;
 
 		if (kill_fq(qidev, new_fq))
-			dev_warn(qidev, "New CAAM FQ: %u kill failed\n",
-				 new_fq->fqid);
+			dev_warn(qidev, "New CAAM FQ kill failed\n");
 	} else if (kill_fq(qidev, old_fq)) {
-		dev_warn(qidev, "Old CAAM FQ: %u kill failed\n", old_fq->fqid);
+		dev_warn(qidev, "Old CAAM FQ kill failed\n");
 	}
 
 	return 0;
@@ -511,7 +510,6 @@ int caam_qi_shutdown(struct device *qidev)
 
 		if (kill_fq(qidev, per_cpu(pcpu_qipriv.rsp_fq, i)))
 			dev_err(qidev, "Rsp FQ kill failed, cpu: %d\n", i);
-		kfree(per_cpu(pcpu_qipriv.rsp_fq, i));
 	}
 
 	/*
-- 
2.7.4
