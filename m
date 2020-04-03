Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A34C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A5E22082F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="ReFT24KF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgDCTvI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:51:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39698 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgDCTu4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id e9so9020798wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zbWZNn58CxQj7h2ixDLwgL3Il53yxUmdYNx8Vuq/xbw=;
        b=ReFT24KFxx3+rBNs81WNFyrO/ShJA2uT8xwRBW1ckdOXDHNpddTX/wMIahu2lP0jOu
         pfJxth0BX6a4CiMP6+Iv2BRyhvKcNyQyIqu8ofC8jCXYd0WPFDwP06cOhIINjqtPcwoy
         KN243yWQtl7IQ7DYMq7DzdA58m/Ey5lNV0bRKLES3iDAWYjtxLQYnwtL7Yl10fxILlb/
         u1RuGIdX855OIF8XlrgeU7aQfW6uh+qasdtHFwxaRawBkOyxghbn/1ZwWM4MCasBLjuq
         +uTBpvRVkgr3y3Gt2KynA9bRL71XWFhdzPhtHW6BC2ptKP0hLF+emgBzrYOQTBjv4oNN
         xx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zbWZNn58CxQj7h2ixDLwgL3Il53yxUmdYNx8Vuq/xbw=;
        b=Pdj34PJv12mNkycvO6M+CA5h0hIDvGHHjaeSaN6M50zKHGVIIllhgFWzo2zhHgSQ+k
         AAy0DRRndMmfL/bWOF6IBTeIUKZ9sLJOpwY+fE/10gF1bwISgISXTEhvXF/RX8ajdf82
         Om4TLdx+c1i8BUwftjUt+E6WnOWUpi4hdS5eLDCgHWwyY3I7yS4dnMfsNF6wybS1f8nE
         gkFKeDZrQ70tbS5CVfzW0cKLtHYMX44VI5ifgoEMjbhX0gLcM4n819+LGPGsVdazZz0B
         0GRjyVjc5r2+dLKuJjRkY4YBQk63/0GclyZOMGWuQPnrZuULTQ0zRBKeG2Tu8ibdrcwU
         5mLA==
X-Gm-Message-State: AGi0PuZR+J0h8R7vYLqGO9JBWriYdjOgJSokxnWAcnbEV+RClbuf7hPG
        QEWZTT7gS9WOFKBgBSL9fEdWlg==
X-Google-Smtp-Source: APiQypKlif9uMZrWD7G6ny0AnyaN8NAOhQhfgQr+jvdpHgOBTA5EF51ye1FGhSt7SltWg7Imc54OVA==
X-Received: by 2002:a1c:8149:: with SMTP id c70mr10259245wmd.123.1585943453184;
        Fri, 03 Apr 2020 12:50:53 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:52 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 6/7] crypto: sun8i-ss: Add more comment on some structures
Date:   Fri,  3 Apr 2020 19:50:37 +0000
Message-Id: <1585943438-862-7-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds some comment on structures used by sun8i-ss.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 056fcdd14201..b2668e5b612f 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -171,6 +171,8 @@ struct sun8i_ss_dev {
  * @ivlen:	size of biv
  * @keylen:	keylen for this request
  * @biv:	buffer which contain the IV
+ *
+ * t_src, t_dst, p_key, p_iv op_mode, op_dir and method must be in LE32
  */
 struct sun8i_cipher_req_ctx {
 	struct sginfo t_src[MAX_SG];
@@ -193,6 +195,8 @@ struct sun8i_cipher_req_ctx {
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
 	struct crypto_engine_ctx enginectx;
-- 
2.24.1

