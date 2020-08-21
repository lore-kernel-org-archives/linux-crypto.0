Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2BFC433E3
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF0F221E2
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="hV3o0kj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgHUNrT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgHUNnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:43:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F53C061799
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:49 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k20so1862508wmi.5
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=hV3o0kj0HJ12dHpuFJoquJNpGg3+3sy+hxVF/dD/9xcPj9hApQV+ahPYV8mQg/M9j7
         atxRTYziUnA/3iruuR4MnArdQrceXrrnEFwJhODaxrVskCDlbwttzd+6iRBSv1NejBQa
         6QWzpGx4xZZCevD6BUi2oqo8ykVherC0M8anbgKV++MZAJCK7SAlnT214ZdPoRyTlYdW
         XUnKBNMnmZ/FzgYV2zVnAan/dbQrblLX3KSrRVZG8qvGmS1MmxkMOriB4yIajaad+iIL
         r8UR56S4xaqNk5jT+AGS6wL/TYLhaup8larIdZdidi+E/ecVrO6dC38mdv0o3DKd14zd
         v60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=kCrBwnElyQTNlz7EVy42uq1R+vM1Rq3GPU0PS982ZGshtPtgKQZPnJGAFDpN2gAqh5
         V6dKNUlxk5WBHsW9L1bdxFg2Rur6WO/JRfcLEsUMDmDFKWBKD+tZDaknJR9mY7Wd309g
         KuZdc9eH/jcnEMhsUJkpFW+dkMwFkgFnEryhzHNc29YBlr4Q2yhTZlxCv3I+ZuyTOGKR
         sLibzq+ngMyxXhyf2EWu3BnXzjlasFK2kfcuUf6jPYJa2SZSSrh/8h/lZZlqtgvWIejA
         0eLQW4Kt3K7iSCUr22Ob5+12olQ1sWZdt3IVBP6Ax+QShVd8GDWB2eCa76HO4Bw/N0U9
         DrWg==
X-Gm-Message-State: AOAM532gYFMKtENDfMgiykin3gw/jwLgzqSE1niRzYakyv12ad9BEc+Y
        k92sDcmuCdV+b4CFIELjZCv5pA==
X-Google-Smtp-Source: ABdhPJydV9E4SuL/qWhGDCKSao2gIyB7i2QLFuFkSFMGHT9xpAoo04U+XfxYXUTiA5cJylb2y4tSkQ==
X-Received: by 2002:a7b:cd12:: with SMTP id f18mr3846266wmj.42.1598017428670;
        Fri, 21 Aug 2020 06:43:48 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 202sm5971179wmb.10.2020.08.21.06.43.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 06:43:48 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 05/18] crypto: sun8i-ss: Add more comment on some structures
Date:   Fri, 21 Aug 2020 13:43:22 +0000
Message-Id: <1598017415-39059-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds some comment on structures used by sun8i-ss.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index da71d8059019..1a66457f4a20 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -195,6 +195,8 @@ struct sun8i_cipher_req_ctx {
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
 	struct crypto_engine_ctx enginectx;
-- 
2.26.2

