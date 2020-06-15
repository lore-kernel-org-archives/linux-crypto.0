Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEAFC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 03:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39864207CD
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 03:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nqYVnyLc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgFODi5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Jun 2020 23:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgFODiz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Jun 2020 23:38:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0DC05BD43
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2020 20:38:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d6so6480487pjs.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2020 20:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HnHM3J+bDKwkRPdfs7jfYoRrpz30LWs87Ov1z3GBhfI=;
        b=nqYVnyLcncpBshp6K/Vh4ubGWmRgbjeBzNIWcgdqhvxVuCfSzUubHKnd1AeWrD6IwI
         NbLFVuDtT1gldAQxH8PTxYB0lVjscrK6dzdOohWawXEK6m1k+wAjV9NHoER0mO1YHeyd
         8vrughnfDJI/BRDULro0zcZkJOBR/6wGnktIbEY6QDVwJRjHMYcAlMfQveeaJcvfb2Bu
         gn1lTCYrMKd5GxS7OQL7ABQd+RD+AJDny4rh464bk4ZvYBLLHs5ajMLzEbbUmrkDBdxz
         0k/3EfBQ3KfJc6Q2uMViaJMaC9mRxYrsUSVrvewAVxZpj2VuNWJvVQIlznMoz6pGhraH
         TfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HnHM3J+bDKwkRPdfs7jfYoRrpz30LWs87Ov1z3GBhfI=;
        b=ZBVUee/X+gyoVj/y4km2/BmUnKl9xi0UEeetxkyYIib8hAK1uNIgFsmNObd6mB1ulb
         KFoRh2U5JNYsTI+dcbLfzsW/Y/egWIUmqytW2450W2nZNWpTDr+ALLORAUhGkjNJ3SZu
         FADHdxri2todhyWxd/oOn5OS9sJ0zx8kFUfJ1TXectsRxKX8mSax5hLKWRBAFti31dab
         7z+FFxCoWZ9PnoEps7weJt+OrfUjj+wycSfihAB+PRk/P6x++t0ENnDnPTQqLfWWuwJY
         C0FqFAeZQ2Q8QkpXhXs4/XGfEgsGSJrAwbHFp607N8VF+MSXnlPbhQuAfsr3GaKX3ILL
         0i8Q==
X-Gm-Message-State: AOAM532Qj7c7dGuFgCaOBp8M3ZwuiDHxAmcsjva9C49YFL6OEQNZl6Ho
        lbyJSNXsUF3DvD8FCXau9gQmyg==
X-Google-Smtp-Source: ABdhPJws8kio/IQYrgtW19iY6BHncEWZZ8efAcrBTbgKgXwVguHQzV64s8XBZ9WCIMB53r0SSS2giw==
X-Received: by 2002:a17:90a:c257:: with SMTP id d23mr10008520pjx.103.1592192333625;
        Sun, 14 Jun 2020 20:38:53 -0700 (PDT)
Received: from localhost.localdomain ([36.5.193.138])
        by smtp.gmail.com with ESMTPSA id o22sm7525194pfd.114.2020.06.14.20.38.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 20:38:53 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     =?UTF-8?q?Herbert=20Xu=C2=A0?= <herbert@gondor.apana.org.au>,
        =?UTF-8?q?=C2=A0Greg=20Kroah-Hartman=C2=A0?= 
        <gregkh@linuxfoundation.org>,
        =?UTF-8?q?=C2=A0Eric=20Biggers?= <ebiggers@kernel.org>,
        =?UTF-8?q?Jonathan=20Cameron=C2=A0?= <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?=C2=A0wangzhou1=C2=A0?= <wangzhou1@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v2] crypto: hisilicon - fix strncpy warning with strscpy
Date:   Mon, 15 Jun 2020 11:38:37 +0800
Message-Id: <1592192317-10566-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
References: <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use strscpy to fix the warning
warning: 'strncpy' specified bound 64 equals destination size

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
v2: Use strscpy instead of strlcpy since better truncation handling
    suggested by Herbert
    Rebase to 5.8-rc1

 drivers/crypto/hisilicon/qm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9bb263cec6c3..8ac293afa8ab 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2179,8 +2179,12 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		.flags = UACCE_DEV_SVA,
 		.ops = &uacce_qm_ops,
 	};
+	int ret;
 
-	strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
+	ret = strscpy(interface.name, pdev->driver->name,
+		      sizeof(interface.name));
+	if (ret < 0)
+		return -ENAMETOOLONG;
 
 	uacce = uacce_alloc(&pdev->dev, &interface);
 	if (IS_ERR(uacce))
-- 
2.23.0

