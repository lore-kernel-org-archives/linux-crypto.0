Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4851EC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A6621872
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="JGNKJHNf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfAXFzS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:55:18 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44653 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfAXFzS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 00:55:18 -0500
Received: by mail-pl1-f194.google.com with SMTP id e11so2376440plt.11
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 21:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uCrF0MHFiiOEn/l4nkIlAADg2vAfaRqdogSuqFtzV9k=;
        b=JGNKJHNfB8OpS+iqfBYSqEZmTbwnhdAh72JuR+u7tWudBZETFbpORniJwId0PaTomh
         MnQK0pINot+0uTLkzC69EkObthIGj9NdWyGDjya6f04uljmgqMgxf7b97X0/G2LtZBH2
         kWRKG8CCYHWouyTsX2tEfQus59wm7apcMSyvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uCrF0MHFiiOEn/l4nkIlAADg2vAfaRqdogSuqFtzV9k=;
        b=D1xnsX1pn5e3ADp9IVLBceTXLRjIcr/x0lOpl3Cs+IRqqJ4nk/28c+Lm/7sWG9stFJ
         AYf8OwqZLoXoJARKN3DBF77FhAJjkMslPC8YaQMpWodzFFUIqG7aMuHjrOLzZ7yLzeV4
         49JqlDrAlExWvwtWvwJkL3n5Hewa3/B1P8kV4qYo6PYPYa5fIKhBPgDo8A9W+/smWT7w
         SO9k4lKjIHs50/11oqFysoSkkRH9H+osdXViaK8eQ4NUbgdRUtF39E/TeZmoVa1AUriV
         zJWA4Jk/PbjFOOhfoQCYw4hgdOxATlIYWYvBTHZLiTvFGj4ICwjK7JVHPO5D1Il59h6X
         j/Dg==
X-Gm-Message-State: AJcUukfW1pwwWLZ8TGBpiPGO8sbLYHapz4PbePr/L16azNvNfZiAsv8p
        UsP3c3ol9OjjWbhxrRFyvzr6qw==
X-Google-Smtp-Source: ALg8bN6ldiMHHBIFS2VBhl+ZRCCYNNzvlKEAWtoexLEWKT9BE7xEVh7a5Ihwaj/R+IK9ToXMpW0jtg==
X-Received: by 2002:a17:902:6bc9:: with SMTP id m9mr5165878plt.173.1548309317693;
        Wed, 23 Jan 2019 21:55:17 -0800 (PST)
Received: from localhost.localdomain ([117.196.233.31])
        by smtp.gmail.com with ESMTPSA id i2sm32297287pfi.66.2019.01.23.21.55.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Jan 2019 21:55:17 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v5 2/4] tee: add supp_nowait flag in tee_context struct
Date:   Thu, 24 Jan 2019 11:24:37 +0530
Message-Id: <1548309279-5281-3-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This flag indicates that requests in this context should not wait for
tee-supplicant daemon to be started if not present and just return
with an error code. It is needed for requests which should be
non-blocking in nature like ones arising from TEE based kernel drivers
or any in kernel api that uses TEE internal client interface.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/optee/supp.c | 10 +++++++++-
 drivers/tee/tee_core.c   | 13 +++++++++++++
 include/linux/tee_drv.h  |  6 ++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

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
index 9f4c8bc..2612dfa 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -105,6 +105,11 @@ static int tee_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
+	/*
+	 * Default user-space behaviour is to wait for tee-supplicant
+	 * if not present for any requests in this context.
+	 */
+	ctx->supp_nowait = false;
 	filp->private_data = ctx;
 	return 0;
 }
@@ -981,6 +986,14 @@ tee_client_open_context(struct tee_context *start,
 	} while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
 
 	put_device(put_dev);
+	/*
+	 * Default behaviour for in kernel client is to not wait for
+	 * tee-supplicant if not present for any requests in this context.
+	 * Also this flag could be configured again before call to
+	 * tee_client_open_session() if any in kernel client requires
+	 * different behaviour.
+	 */
+	ctx->supp_nowait = true;
 	return ctx;
 }
 EXPORT_SYMBOL_GPL(tee_client_open_context);
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index ce957ce..56d7f1b 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -50,6 +50,11 @@ struct tee_shm_pool;
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
@@ -57,6 +62,7 @@ struct tee_context {
 	void *data;
 	struct kref refcount;
 	bool releasing;
+	bool supp_nowait;
 };
 
 struct tee_param_memref {
-- 
2.7.4

