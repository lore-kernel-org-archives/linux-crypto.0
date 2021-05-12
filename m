Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B1EC43460
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 14:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F78861413
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 14:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhELOGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 10:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhELOGh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 10:06:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE3C06174A;
        Wed, 12 May 2021 07:05:28 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x188so18575759pfd.7;
        Wed, 12 May 2021 07:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0iTHD8zuIlPTE898HuuCtTAOQQCCVuFMCLG1W0mYvD8=;
        b=fQS5AExTbuQNLhj5Cx/AIC9784YYkzdGI0uou8BuAomrNO+mhHRES/de/4eEJLLaNR
         DbF8AisIAFEFqlah3QPAhcgLDUuro3A4adCxqOTAqDu+inexgsNhcqj5CbjYk3G7GwNN
         +FGebi3HrqfzrVdnICVtsxdjH6E4IfY0L7J5y/tTgsOK0xtGlLMzGZOVW2Eqyo1ZbPsy
         3vXNExGq/7UolhNRagCJGo6fBe/b/ybtgMscYZ4l2WJOiRzuYyVxE91O/edzLDOkn+H+
         5+/+6N3HNa5L42j8phHDXRqWddUfAXirLfBIbwd8dD302JvHPmgzRWUoR1tjfmdJPzpP
         ZaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0iTHD8zuIlPTE898HuuCtTAOQQCCVuFMCLG1W0mYvD8=;
        b=chfjOo4xfFZpKU9rqPbFjPLwpgKSRuKRpxxSiEt8vlgpHthgkW5VUqtwRHetOlY2K4
         WzSF4XEk7UJucui7Lk860np474VgRr7l7sfogaQHaV0eRPOfwqQ34dnM9dKevaC5RBzS
         tK5D4NX2Mj3NHi8P/MIko0Ytkf9aTX4PJP6K5+cUCoekN1E+WwuIiMXPTDqiMBRJZjME
         3sH0Zj8uVKWAsLKsbBeLqRaa1+nvRtGmEPiFGrQYDCtqN6FOQHmL5gqbqXLon6Ms+Dsu
         Xb8z5jnhGxnro3kEb6BBm0U9fIighpwRmgX7/u3DdOjRxK9IawiOtoW3+4PbOmJB7lKw
         ME9Q==
X-Gm-Message-State: AOAM531hVQYEAM6JYpokIS8Zb6/eKW/gO0wNPoZkhKLxy6ZghwrXWR4c
        sRMPkCi5HqENSTVfpO3BcC1BvB8HM9Q=
X-Google-Smtp-Source: ABdhPJxbxCq4PZGLHMRFPuMvC1mk3p/3Qr/urbAvLOFFCYL7Igg3vhDM20P+NgdBipiMz5v5qHmUQw==
X-Received: by 2002:aa7:90d5:0:b029:28e:df57:47ff with SMTP id k21-20020aa790d50000b029028edf5747ffmr36520615pfk.74.1620828327769;
        Wed, 12 May 2021 07:05:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id in16sm28546pjb.14.2021.05.12.07.05.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 May 2021 07:05:27 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, dhowells@redhat.com,
        jarkko@kernel.org, tianjia.zhang@linux.alibaba.com,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] lib/mpi: export some common function
Date:   Wed, 12 May 2021 22:04:10 +0800
Message-Id: <1620828254-25545-4-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
References: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

Export mpi_add_ui() and mpi_sub() that are used by the following
eddsa patch.

Signed-off-by: Hongbo Li <herberthbli@tencent.com>
---
 lib/mpi/mpi-add.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/mpi/mpi-add.c b/lib/mpi/mpi-add.c
index 2cdae54..d34c6c1 100644
--- a/lib/mpi/mpi-add.c
+++ b/lib/mpi/mpi-add.c
@@ -62,7 +62,7 @@ void mpi_add_ui(MPI w, MPI u, unsigned long v)
 	w->nlimbs = wsize;
 	w->sign   = wsign;
 }
-
+EXPORT_SYMBOL_GPL(mpi_add_ui);
 
 void mpi_add(MPI w, MPI u, MPI v)
 {
@@ -138,7 +138,7 @@ void mpi_sub(MPI w, MPI u, MPI v)
 	mpi_add(w, u, vv);
 	mpi_free(vv);
 }
-
+EXPORT_SYMBOL_GPL(mpi_sub);
 
 void mpi_addm(MPI w, MPI u, MPI v, MPI m)
 {
-- 
1.8.3.1

