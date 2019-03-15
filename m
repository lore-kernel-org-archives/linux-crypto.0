Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2ECC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 07:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 887E921872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 07:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfCOHri (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 03:47:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45592 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfCOHrh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 03:47:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id h99so8451682wrh.12
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2019 00:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O9PowNUX6KD3889sVYHL4M2CPwvpvsdJh+RBFoVGee8=;
        b=Cd9+N5mBjwu+3JL/yOfkl4brE/0C5gwyNl4EZTnGen78AOY3bFAJXpfUdjCihCmuGj
         9j72yO4Ev6buEzEubCGBRHPHWJldsZXKQZeNLqthCiwyn+uzcjMIz86Hn/Fw2CEMeJvD
         MiUpJQ5LmMT0p+u3PGz7P0AXSq0nyIma+m3uc2PmCPAw6hhiePJXG/xiDMWp+pOb+APg
         HWHUW6aN0mtvaMryNaRml36RbRfA3JtMli0Gs0jpmxuFFCws14xYSH8i3euQlrdvB5sK
         8CNrtogSL3yi07mf1jsUMbI8K8e8rNRzfVldJEDjfiuOsj7osfYsdQ3dN3wkl76OXS78
         2IwA==
X-Gm-Message-State: APjAAAV+SWQa3nFFhpInWimrbtLbyE3Zu89IftBDrP94kd406XjR5Sci
        Tx6WeGDyFpLIlURYnRuQpHo/ig==
X-Google-Smtp-Source: APXvYqxpX9m/xl41TLTvXMCr3DkLhVKgZxAoZRZpGfjEYGiDUCVpPn+OIlKRe2ocGy/b2wlZxrpK9Q==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr1009575wrx.291.1552636056009;
        Fri, 15 Mar 2019 00:47:36 -0700 (PDT)
Received: from localhost.localdomain.com (bband-dyn196.178-41-14.t-com.sk. [178.41.14.196])
        by smtp.gmail.com with ESMTPSA id f13sm1175152wmj.29.2019.03.15.00.47.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 00:47:35 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH] crypto: Kconfig - fix typos AEGSI -> AEGIS
Date:   Fri, 15 Mar 2019 08:47:25 +0100
Message-Id: <20190315074725.31253-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Spotted while reviewind patches from Eric Biggers.

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbab6bf33519..93270797e04a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -312,7 +312,7 @@ config CRYPTO_AEGIS128_AESNI_SSE2
 	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 	help
-	 AESNI+SSE2 implementation of the AEGSI-128 dedicated AEAD algorithm.
+	 AESNI+SSE2 implementation of the AEGIS-128 dedicated AEAD algorithm.
 
 config CRYPTO_AEGIS128L_AESNI_SSE2
 	tristate "AEGIS-128L AEAD algorithm (x86_64 AESNI+SSE2 implementation)"
@@ -320,7 +320,7 @@ config CRYPTO_AEGIS128L_AESNI_SSE2
 	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 	help
-	 AESNI+SSE2 implementation of the AEGSI-128L dedicated AEAD algorithm.
+	 AESNI+SSE2 implementation of the AEGIS-128L dedicated AEAD algorithm.
 
 config CRYPTO_AEGIS256_AESNI_SSE2
 	tristate "AEGIS-256 AEAD algorithm (x86_64 AESNI+SSE2 implementation)"
@@ -328,7 +328,7 @@ config CRYPTO_AEGIS256_AESNI_SSE2
 	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 	help
-	 AESNI+SSE2 implementation of the AEGSI-256 dedicated AEAD algorithm.
+	 AESNI+SSE2 implementation of the AEGIS-256 dedicated AEAD algorithm.
 
 config CRYPTO_MORUS640
 	tristate "MORUS-640 AEAD algorithm"
-- 
2.20.1

