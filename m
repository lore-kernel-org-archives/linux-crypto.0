Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FB4C4CECA
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02358208C2
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fka1dBCx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbfIMTEr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:04:47 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:40105 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388483AbfIMTEr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 15:04:47 -0400
Received: by mail-ed1-f47.google.com with SMTP id v38so27935687edm.7
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 12:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JI31Rbjiw59ZLec4JDfXW6Y6kHz8vxCKDTLDz7kCTiI=;
        b=Fka1dBCx3j0YMjEBU6Zt+09NNO1v22TyYE2Skunq4cptzCSkYyzRdjK+6HVYBUIKNP
         OzUIq61+CJ7OybbvWnsLsAP+nOJpvjKgPez1qQ5YHJHZe9HsNIpx9CQxJKlWF2do3b0a
         VpklASaervRxwoiX7bJZZaE7KmYsI3nqVJcUv6poLgrOMdaYpuTeXt8/aCm3h6IgNLWz
         FPgNopCJQsO6Hd+At/p+AEfTiim0nnEQVPC/XbPMVfbKS8AHkzejCo4XCcw/8f3t3+0u
         2kTnGFCFG/kkMAF8hAhZG9rX+W+JmyKIgJCjTtuFlouR0rV0yDYezFpKVJBa+6IQyacd
         uG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JI31Rbjiw59ZLec4JDfXW6Y6kHz8vxCKDTLDz7kCTiI=;
        b=r1XbWkh6nGwMnQSE/q7jLDgIlLgkC0IBLn5W/tXWeA/wZD70XV3kXKU80GyUziFMaj
         4afHwyumyG3lvsBY6xHUz5CMa9jLgsVoNe+zgP3PXMt5NLz5NUds6ehDjOc2coFP4Dq6
         PLnkQ+Tkpd1OUHGdlGUNaOGDkhh+XPFgxWGfobl/JjO3rVGKL2XCcmAgGY5zyfn6apbw
         UwBJxQ7zeANZL4wbqENwbCudcRc0zerfmc8tg2CBJZ55h8RriORnTcvkCJRPY+AHmNeM
         1S7DGhk7vpY22J+e12mX6rvdxk/nVZzuZjsXUkFsxXP3ChJ/XrZ+HVy47i/vW8DcGf/z
         UhZw==
X-Gm-Message-State: APjAAAWltPRQ+SBC/3V+9u+a4iLUXtQtd5jcRsmMKP8RjmUqB+ch76bm
        6bXTHnXK2khUIiOoippyX3V614gB
X-Google-Smtp-Source: APXvYqxQc0lVLLxa9Ld/VVyGjQQlCyfkY5ZlQVE/vMQomDk2paQbWbqnk8Qg1WkHkuuLbwyzw9vvEQ==
X-Received: by 2002:a50:935d:: with SMTP id n29mr49329246eda.294.1568401485779;
        Fri, 13 Sep 2019 12:04:45 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id ba28sm49099edb.4.2019.09.13.12.04.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:04:45 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 3/3] crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL
Date:   Fri, 13 Sep 2019 20:01:55 +0200
Message-Id: <1568397715-2535-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568397715-2535-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568397715-2535-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the addition of Chacha20-Poly1305 support to the inside-secure
driver, it now depends on CRYPTO_CHACHA20POLY1305. Added reference.

changes since v1:
- added missing dependency to crypto/Kconfig

changes since v2:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 83271d9..2ed1a2b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -19,7 +19,7 @@ config CRYPTO_DEV_PADLOCK
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
 	  that provides instructions for very fast cryptographic
 	  operations with supported algorithms.
-	  
+
 	  The instructions are used only when the CPU supports them.
 	  Otherwise software encryption is used.
 
@@ -728,6 +728,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_CHACHA20POLY1305
 	help
 	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
 	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
-- 
1.8.3.1

