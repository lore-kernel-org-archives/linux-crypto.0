Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2909CC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 10:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3B22251F
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 10:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbhAEKCI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 05:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbhAEKCH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 05:02:07 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C58C061574;
        Tue,  5 Jan 2021 02:01:27 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w17so28022119ilj.8;
        Tue, 05 Jan 2021 02:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a+YIO4SqsJOMsreFxnQg6aNJ/TQ1cD1PYTP7J+66kxY=;
        b=EdCWoYreIIPP48lPVCOtCBBJteDAWlPOoytMHPYSolemn0JXQDVyv+XvCGm+eRqf8A
         aSAJIHg0QKgwZtEZG4PevHQmz4/sWgMoSYaoDHbjKFQw+maKgiIad808izswjZsMScpP
         IOzAJXLdtVRCpdCQQ+xbPhpIwGqDQ+RJxcam6Ml7PbQvUr1O1PNvXdSv1SOweJilG66D
         U7hasc3h6oYEZrAsSGv2PhF9MkE8aYuudjJ4qhXC5mVZie0U7Am1NnBxLq8w3/SnR2yI
         BDN7t637r1lHqBkJ3d2KzhHDLiLGVUHR2yEjFp+UCwMfVUfgNiQr2I29MdGFrmZEuLdj
         1b1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a+YIO4SqsJOMsreFxnQg6aNJ/TQ1cD1PYTP7J+66kxY=;
        b=ff4ZLTUH/XgJp69jsL3j/815mCboqMZwI/EiV8ZJCqbz7bxVAsZRrqSE6Mk00oKpoy
         eSwrd3QyZTaSZB3o42QXnHMHSk6V0XVXWIinU6A3CsNS6ZIfFThnNoMyWtGcMZhp3Dr5
         jWI2iDRUGyHwiejvqgxRf9nqL01v9pHX8Y/bdqEm5zJ43ahUd52d5cYNhvb5tZCIWb62
         F5jGrRKwJEmQ9QlRA2MkyXdQI03Uxtf3t+me/REviSuRDP5Nxd3cipHUYP3Sw58wX7vO
         RAlXcFpVJ687Tx+PwrZWj409i66NDpR+NSf5b4DCSNgpE9YW2vFfvrzReH6l9XL9BjR8
         /kjw==
X-Gm-Message-State: AOAM530PTYmcv4clVpc1AcgC7XGFKygL1z8E8gJqpdBmeyM3K92HV0rw
        Jie6OFq8vqXftEuVJEpyx0k=
X-Google-Smtp-Source: ABdhPJxQrMydf1TlDyAj1V01J/O0bI/OUfD4p3DE9seESIFB46J/rQnJY/hGRzF/8WWq1aupqlK+fw==
X-Received: by 2002:a92:ce47:: with SMTP id a7mr76367323ilr.261.1609840886959;
        Tue, 05 Jan 2021 02:01:26 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id e1sm43616932iod.17.2021.01.05.02.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:01:26 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: crypto: marvell: Fix a spelling s/fautly/faultly/ in comment
Date:   Tue,  5 Jan 2021 15:31:08 +0530
Message-Id: <20210105100108.3375-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/fautly/faulty/p


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/crypto/marvell/cesa/tdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 5d9c48fb72b2..0e0d63359798 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -177,7 +177,7 @@ int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)

 	/*
 	 * Save the last request in error to engine->req, so that the core
-	 * knows which request was fautly
+	 * knows which request was faulty
 	 */
 	if (res) {
 		spin_lock_bh(&engine->lock);
--
2.26.2

