Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FE5C676EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1A1421738
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bt8zc/t0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfAUJaJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:30:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43585 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfAUJaJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 04:30:09 -0500
Received: by mail-pg1-f193.google.com with SMTP id v28so9212976pgk.10
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jan 2019 01:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KVZe+JdIXEOq53OVAEyR9i83a9gBMP1LhsWNd9YK638=;
        b=Bt8zc/t0rEncfMEdzopClS60wNL6dg/68jiLQWvQvSVyqXf/yTbCxvq6JBHox1FYXx
         enWK7NNO+z4KeO6tGAh70/MMonVYsKehNreJak/U1sDsSw2/XY37qsCHch/zAjeP6LEV
         CGy1ui8bHhEqFZUFW9x8ukL+eYxR0GfQGYXHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KVZe+JdIXEOq53OVAEyR9i83a9gBMP1LhsWNd9YK638=;
        b=VZEqVnSvPKr3+D4ofXesrf3v+MYQQ1Nykd4VKvIA3OsdRDmqNcE12BaV+pemWFzFW7
         6xYJsCBFB/y0qa1DhbAL5suZcbJ+5go/O12UaPTysHS8akYPN0nj+A0zNkoZk07yizeu
         Zd0554CPrypF4+tJ/lezQdpqGEnZUO+u0MaY+iGbyfEYZmLGchqCLhmmRj4qmhmzIGNw
         KQvWb/oUxF1PD/NdpgGPrxY+M7r4gFd1A6k8Y50ls3ywAer7ADvytULeINdXTNDUZ9Yn
         DnVD/sjRaflt4NKENjhK3zCV4thVi0uOJxBQqmzt06QSAXfyR1w5kmKzk5/GpXkmFr6D
         zW+Q==
X-Gm-Message-State: AJcUukcsa/8LeQ745HZwELBislF6s48RPJc92I0A8Oai4PUQ1uf525Pb
        mVqWlRa6r02ftETPzfwJ9ewfqA==
X-Google-Smtp-Source: ALg8bN70J2rK0ct9ynM+tDCxdfFWPaj3IonQUPAizzbbXqYdJ+HPL5IZPHtdtIOVQnW76F/P/QAdMw==
X-Received: by 2002:a62:8949:: with SMTP id v70mr28459427pfd.85.1548063007852;
        Mon, 21 Jan 2019 01:30:07 -0800 (PST)
Received: from localhost.localdomain ([117.252.65.115])
        by smtp.gmail.com with ESMTPSA id h9sm16182777pgd.53.2019.01.21.01.30.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 21 Jan 2019 01:30:07 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v4 2/4] tee: add supp_nowait flag in tee_context struct
Date:   Mon, 21 Jan 2019 14:59:17 +0530
Message-Id: <1548062959-31860-3-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
References: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
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
index 55370d5..56222ea 100644
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
index ba985d8..a44374a 100644
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

