Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE14CA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 15:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C63420873
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 15:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oeVq2ySh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfJ0Prw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 11:47:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53897 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbfJ0Prw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 11:47:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id n7so6910112wmc.3
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 08:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTB8X/w2KY+l1TCb6s/yD4foiPw9P4b3gYHXiS08cVU=;
        b=oeVq2yShahD4QH58ywx+10/u5RCGfr/XhLqWdx2d28VWyNnDE7HvBgNwJBXGNvyDvj
         8mjkJXaJZAfgOflx+WGL1v2b/fmr2N+1Pi1T1cR8H6NvCY0odvoAeJd8cs6LRxOXGdJ9
         BiuFcMZ5DO2BJ7MsbWwzQkLBAZHCJEuKBf1+rCVy9VlAq08NHeQc5yjqrYnza/p5/VCb
         w2534WNDvT0y977sG3fmhFBl4qI2Vln8nVI8vT4nfIEJ35dRZNotX8nqQQIedCq+vC5F
         7oZMvQea3eYDDXTWl5nQBWcT6dYgpfyz2iJG+0JFM6hWZzkLaaBNgswabrb/ugj9iRvw
         qkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTB8X/w2KY+l1TCb6s/yD4foiPw9P4b3gYHXiS08cVU=;
        b=Q7LZnixhrw9H8nPOq7o4AT6S0FAyhhQIDxa29sZVxDLiMkatwLaX1bK3JH7aGQcog8
         6h69f6RBWAIH1G2Xij2Ssn9ZnPNyQiD+gePxBNQUqAdOGd9mzMPT0h+ClItHXRc4xIf6
         5ryGo5bwklvL0lN8J9n9VBftUq3GKoomHFPYt8eJet7A3EjIE/9By7QvYjrbdUhCGzuR
         zt7JQ00lZ52ODGsqbWR6RN5eA2JHjoBo0JsO5+gzoyYWXYep4Nb/kkIZvbWs659DV011
         F6M/HarHXwtKSmCEf1i448KcaGWGsDbWnMmXyt/0iuSMwaoBtWn9bwEFVD0nW3uvOtjD
         EBkw==
X-Gm-Message-State: APjAAAVhqu6z2ZlxWFnSAvsu5Jr/tSYwfOHwF2666L0E3XZGMH24Ema8
        WeVvv0zwuKJfaxnYGDFxmfbu0RMT
X-Google-Smtp-Source: APXvYqwmX1DqhbRzmCKOU6C2JrWaYoOynLy/dAAkBjeI22aW6cexWYU0Wixl4ZBaWt9UBOk7xlZfyw==
X-Received: by 2002:a1c:730e:: with SMTP id d14mr12440748wmb.165.1572191269331;
        Sun, 27 Oct 2019 08:47:49 -0700 (PDT)
Received: from debian64.daheim (p5B0D7E0E.dip0.t-ipconnect.de. [91.13.126.14])
        by smtp.gmail.com with ESMTPSA id u1sm8046311wrp.56.2019.10.27.08.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 08:47:48 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92.3)
        (envelope-from <chunkeey@gmail.com>)
        id 1iOklf-0003sB-T5; Sun, 27 Oct 2019 16:47:47 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: amcc - restore CRYPTO_AES dependency
Date:   Sun, 27 Oct 2019 16:47:47 +0100
Message-Id: <20191027154747.14844-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch restores the CRYPTO_AES dependency. This is
necessary since some of the crypto4xx driver provided
modes need functioning software fallbacks for
AES-CTR/CCM and GCM.

Fixes: da3e7a9715ea ("crypto: amcc - switch to AES library for GCM key derivation")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 23d3fd97f678..06c8e3e1c48a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -332,6 +332,7 @@ config CRYPTO_DEV_PPC4XX
 	depends on PPC && 4xx
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_CCM
 	select CRYPTO_CTR
-- 
2.24.0.rc1

