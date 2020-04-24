Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D919CC55191
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5047215A4
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="XDD8OZHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgDXOCy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728504AbgDXOCx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49C6C09B047
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z6so10877108wml.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xLoFk+SNurZVpCfpASFCu44pZDZ5n7kdegjD0roxl1w=;
        b=XDD8OZHHcykHrfUF/QkzvETaDtj44B8/0Jm+jzhCvL01F9xFv75Iw/AZDYvhkR2aAY
         fqLKfFlIPtHr4ZBYCdCKsN7mlNYhNlgzvgahbdv+YzKl1VrPgLKRRWp/Bfh8w3Zz2uuc
         Go48vUxDOatcDiQCnod+/D3tn2bIN4xAioMhSp6svDaYFTWXTkMKt8vwF8kGggrBD8Qd
         aRMEcUqgpFH2j2ld6VWghGzUqgA6HnruHWZtf3QU+lFDD5I6dKoYbbEhWRx5pWRYY6SW
         ysCO5CDtyh1iQYLQvM/hoxPI0cOmYHGPkudYfbQ3u6SY2uIqCJNAy3OhjTVaC+HjTe00
         bF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xLoFk+SNurZVpCfpASFCu44pZDZ5n7kdegjD0roxl1w=;
        b=on3ek7/lUWxsIC0EWQtb6ZCql10x5klgsr+Rbw7NT2XzvpXqTfA6sBFyheeAlW/a16
         dE68tpA6BZb67n+gm2bsdDpprHdO+5ZGLFD7MujcjEGhvxt3O2eBMYPRZp4HJSrscno2
         v1QT8i8xLEmhd02VY9xwXRgYm6sxd3eTuYim4Vhk1cip0yCCUtp/fnI4fQ6nMkgfhaz7
         2M5EyJkQZB05sBrx6/sjbJQ4MOOo2n3EqiWgiS3d5D1IAHKN4ze4oEXAtr1gsAFF2AVl
         rKuZoyk749qHtw+uUxpyOPSYwJIhGMm2KIuhaglf8DPUYMAHsn6yovhtuxQOIw6Zuaq/
         seAg==
X-Gm-Message-State: AGi0PualVdcMVrR2t4Ehf+qLKH6nXhzagwwG6MTH6XNLUajdHYre5TDl
        CTHQ787DyXN197cXtckkm1+FlQ==
X-Google-Smtp-Source: APiQypJZqMoKZGbxnLiQQrnY+QzhmpGhrUpbzcw4lzCNd/MsrSf3w20Z41MJEi5tbGVTVC5wztnOXw==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr10092915wmc.142.1587736971357;
        Fri, 24 Apr 2020 07:02:51 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 12/14] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Fri, 24 Apr 2020 14:02:12 +0000
Message-Id: <1587736934-22801-13-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new stat_bytes counter in the sun8i-ce debugfs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 19ced8b1cd89..ef2f1e5aa23a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -274,6 +274,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -287,6 +288,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.26.2

