From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] crypto: cavium: remove redundant null pointer check before kfree
Date: Fri, 21 Sep 2018 21:30:15 +0800
Message-ID: <1537536615-46814-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <george.cherian@cavium.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

kfree has taken the null pointer into account. hence it is safe
to remove the redundant null pointer check before kfree.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index b0ba433..ca549c5 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -308,21 +308,11 @@ void do_request_cleanup(struct cpt_vf *cptvf,
 		}
 	}
 
-	if (info->scatter_components)
-		kzfree(info->scatter_components);
-
-	if (info->gather_components)
-		kzfree(info->gather_components);
-
-	if (info->out_buffer)
-		kzfree(info->out_buffer);
-
-	if (info->in_buffer)
-		kzfree(info->in_buffer);
-
-	if (info->completion_addr)
-		kzfree((void *)info->completion_addr);
-
+	kzfree(info->scatter_components);
+	kzfree(info->gather_components);
+	kzfree(info->out_buffer);
+	kzfree(info->in_buffer);
+	kzfree((void *)info->completion_addr);
 	kzfree(info);
 }
 
-- 
1.7.12.4
