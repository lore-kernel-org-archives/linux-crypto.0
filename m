Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36775 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbfAJM0B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 07:26:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id b85so5242917pfc.3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2019 04:26:01 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jens.wiklander@linaro.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
Date: Thu, 10 Jan 2019 17:54:56 +0530
Message-Id: <1547123097-16431-4-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This flag indicates that requests in this context should not wait for
tee-supplicant daemon to be started if not present and just return
with an error code. It is needed for requests which should be
non-blocking in nature like ones arising from TEE based kernel drivers
or any in kernel api that uses TEE internal client interface.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/optee/supp.c | 10 +++++++++-
 drivers/tee/tee_core.c   |  2 ++
 include/linux/tee_drv.h  |  6 ++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/supp.c b/drivers/tee/optee/supp.c
index 43626e1..92f56b8 100644
--- a/drivers/tee/optee/supp.c
+++ b/drivers/tee/optee/supp.c
@@ -88,10 +88,18 @@ u32 optee_supp_thrd_req(struct tee_context *ctx, u32 func, size_t num_params,
 {
 	struct optee *optee = tee_get_drvdata(ctx->teedev);
 	struct optee_supp *supp = &optee->supp;
-	struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
+	struct optee_supp_req *req;
 	bool interruptable;
 	u32 ret;
 
+	/*
+	 * Return in case there is no supplicant available and
+	 * non-blocking request.
+	 */
+	if (!supp->ctx && ctx->supp_nowait)
+		return TEEC_ERROR_COMMUNICATION;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return TEEC_ERROR_OUT_OF_MEMORY;
 
diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 9ddb89e..5d6c317 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -105,6 +105,7 @@ static int tee_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	ctx->supp_nowait = false;
 	filp->private_data = ctx;
 	return 0;
 }
@@ -981,6 +982,7 @@ tee_client_open_context(struct tee_context *start,
 	} while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
 
 	put_device(put_dev);
+	ctx->supp_nowait = true;
 	return ctx;
 }
 EXPORT_SYMBOL_GPL(tee_client_open_context);
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index ed16bf1..fe1a920 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -49,6 +49,11 @@ struct tee_shm_pool;
  * @releasing:  flag that indicates if context is being released right now.
  *		It is needed to break circular dependency on context during
  *              shared memory release.
+ * @supp_nowait: flag that indicates that requests in this context should not
+ *              wait for tee-supplicant daemon to be started if not present
+ *              and just return with an error code. It is needed for requests
+ *              that arises from TEE based kernel drivers that should be
+ *              non-blocking in nature.
  */
 struct tee_context {
 	struct tee_device *teedev;
@@ -56,6 +61,7 @@ struct tee_context {
 	void *data;
 	struct kref refcount;
 	bool releasing;
+	bool supp_nowait;
 };
 
 struct tee_param_memref {
-- 
2.7.4
