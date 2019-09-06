Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5697C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9138A20842
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwJnIJk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404468AbfIFPeo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46957 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404107AbfIFPen (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:43 -0400
Received: by mail-ed1-f67.google.com with SMTP id i8so6613624edn.13
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BQ/tbFL5AfHCrTZp1kZQ0W5BcggcoXkkhGsgCLGVSkM=;
        b=jwJnIJk06E/j8p+jcflucZnYHBzsUyVx+qT1xiQMVmT2Q270eI98u9GSPAZRnm/AGG
         +35VICH/l8LUp7dU37sj98YRR6JaBCIBvw7ZLK+4M3OmTlnHvD2vGJ5hoWaCcRc4kFBK
         DxWPtrDu4XTjhvn9NPjINYkkG3y1CwnT47khV5IRADgbmJplE7nVcTbJ0jFylLyCT902
         +zkKUNFL2sU/uBRXV58FLNzd8jFpOZN0neUfRy5FiNilcMcYZvwn6iqRkC7O2yTh5ju1
         /7t+idTgdhjX7nDoODxFCpVUBGkG9F5xoW/l6bwtWrALRH5lkRRzplvw2YXNAawjx6fr
         hUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BQ/tbFL5AfHCrTZp1kZQ0W5BcggcoXkkhGsgCLGVSkM=;
        b=cGOczjXWTRuEZqVZTnzoBN6KzDFVb3x4tliqtJzSl8uSjT5YB5KWf8SCpPihA2NBjf
         ls+UMHZ8jG5XpPQ4f/k8QHytSeWOcucy/GzZtTkkllpLJNz5j0GXjt2Kuu3B7VX3Xcb9
         u73g2Nkm9f6xL1WskZx1yVUiqfwfboT0tgtK1HFAlQ36uRpG+Xs2IXJeCA8axeFP17rl
         2RZjDCAV2P9G87R2SurK/MMniOuu8Sk1k62AjbZ6vApcbC90gijnl4n6pNsNSt2sO2oP
         ppuuDlZJt1yqYOJM3kD6/9h9vSqZzS1ak9PXa1CQp+xvT0QOO+cS2eXxsBc5WRnZMSM7
         aB7Q==
X-Gm-Message-State: APjAAAXOYRBKuuK2Aa54Dy5ZKw/e0NMxw8CiylH1kHdOOYcIrIOkXBdd
        g+k40NXdBwTZjnOQnjhyVfOa3S6Y
X-Google-Smtp-Source: APXvYqyKyPEM09Krs+KXjFOBf5uDd63DKvgz4W1YfOpI7MGvN5h4t6/cGtLmRX9+TrXe6/zenUNMjg==
X-Received: by 2002:a05:6402:611:: with SMTP id n17mr10500238edv.33.1567784081523;
        Fri, 06 Sep 2019 08:34:41 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:40 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/6] crypto: inside-secure - Enable extended algorithms on newer HW
Date:   Fri,  6 Sep 2019 16:31:50 +0200
Message-Id: <1567780313-1579-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enables algorithms that did not fit the original 32 bit
FUNCTION_EN register anymore via the FUNCTION2_EN extension reg.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 drivers/crypto/inside-secure/safexcel.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index d699827..d9b927b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -505,6 +505,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		/* H/W capabilities selection: just enable everything */
 		writel(EIP197_FUNCTION_ALL,
 		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION_EN(pe));
+		writel(EIP197_FUNCTION_ALL,
+		       EIP197_PE(priv) + EIP197_PE_EIP96_FUNCTION2_EN(pe));
 	}
 
 	/* Command Descriptor Rings prepare */
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 10a96dc..e9bda97 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -157,6 +157,7 @@
 #define EIP197_PE_EIP96_FUNCTION_EN(n)		(0x1004 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_CTRL(n)		(0x1008 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_STAT(n)		(0x100c + (0x2000 * (n)))
+#define EIP197_PE_EIP96_FUNCTION2_EN(n)		(0x1030 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_OPTIONS(n)		(0x13f8 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_VERSION(n)		(0x13fc + (0x2000 * (n)))
 #define EIP197_PE_OUT_DBUF_THRES(n)		(0x1c00 + (0x2000 * (n)))
-- 
1.8.3.1

