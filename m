Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3D7C169C4
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 05:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A99D20989
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 05:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="M2yTK49o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfA2FuU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Jan 2019 00:50:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35983 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfA2FuU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Jan 2019 00:50:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so8882726plo.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Jan 2019 21:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4tsUCYoQCIITudwXX50zEbDS6TS2iz02PTI9NIhLDSg=;
        b=M2yTK49o123n+gyCleT//uhWceNdbgf1/lcglQPUIKwSvTk2G2sC4WVNBtfig0q3s3
         bJttwPzQCKii3dz0SYLBeAXTjNhfZcLC4aceMXniAxmlE9zHQpbo+29QEc6gHt+jo3MW
         UIig8KmF3EVsUT6IU+JYb5EihUwmQxesv7afs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4tsUCYoQCIITudwXX50zEbDS6TS2iz02PTI9NIhLDSg=;
        b=pnUu4zeG0J33DK2AeUDaFekwHLmPA6qRki1j+resYL6PhYuisoBt4Tax0YYJbn+rnj
         XBcpQqUOZE5WWOdF1Iaq13UjfWdzX9n+pI00p9HFi4YhoQu2PiNf1O0tso+jjaSi8BcZ
         3orndUDfFAhRA3cjHiTdoHK4DV7XSrlU86LZP+E8Qwqxi8waSX2FLpE6t+mODQpdBrmC
         N3bTjrEkC4O0tkZhYUHpEiBKtgiAc9FpaBXTYhNezpBRHqq5NPVIWUbkgq/uxuh9SQeU
         4UKc0WCJzsiGpUc72gCMi1XrELp0Zg/mL0RXPwCcYb+SybO1Hr4RJo9nTorRI0WBNBjJ
         q/eg==
X-Gm-Message-State: AJcUukdt7U3FFuz03LRt03mODiw9lA4SNFrINboEcIZwQG0Gn/ZB35w5
        sZmxt4QAzECFumOAcgEiHw+DLw==
X-Google-Smtp-Source: ALg8bN6NppfwJXWi0wuczeIpQyewmgyUiXuJj0bo3GE2f5i5fz0Z+ZPL5dLk71HnwbhoI00B76bP+g==
X-Received: by 2002:a17:902:bf03:: with SMTP id bi3mr24741865plb.83.1548741020115;
        Mon, 28 Jan 2019 21:50:20 -0800 (PST)
Received: from localhost.localdomain ([117.252.69.38])
        by smtp.gmail.com with ESMTPSA id y12sm57379437pfk.70.2019.01.28.21.50.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 21:50:19 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v6 2/4] tee: add supp_nowait flag in tee_context struct
Date:   Tue, 29 Jan 2019 11:19:36 +0530
Message-Id: <1548740978-28495-3-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
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
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
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
index 1e14897..25f3b9c 100644
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

