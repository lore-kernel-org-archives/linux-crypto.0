Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3584C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED622070E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 10:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnFcIlbK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfKNKt0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:49:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38023 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNKt0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 05:49:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so5345427wmk.3;
        Thu, 14 Nov 2019 02:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NwAeLrKvbbZMMrwnv1eozuX4/GetsOmlDvz+Gto4i+k=;
        b=gnFcIlbK+7rOK1QioyvQsJIa/QTWL2hkKkzE7GJZbWrUS7WHynwr3Ip67bsIsKiuUf
         /ZmIr/rM3wyntOQXhvbaUNK94VGUqQ8ltx0wfGiCgVFdll09HDwLZFqsp2QZ9o97IWtN
         DR5yz1J0s3S5NL6VkMS/jLwmefaM7oUlCI8JbQtfMEVe7I0c9ePaZ4Nhu92BY+3uvZ4i
         z6dkhcZT2LpvZEEIu8zQRqJtEseC8YuSPbnRRZDw5+EwyyqrMMs0ZAB33SzWiVQiJ8Hu
         et7fBdtOqMvrfmo4kJKQdgjcyz8CSK8hb4GZNgNZ1UybUgotG9JWv6xMEvRT6uWd0Ppj
         Aw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NwAeLrKvbbZMMrwnv1eozuX4/GetsOmlDvz+Gto4i+k=;
        b=B7arG6CDZBmprqUAxdoct7uPZLlBl5J7lkX2fpKZez7nEutAxSbOvPoDSk/mJJfJzU
         uJURI4+oZ7Gd46T+schniyHDwZJ1x7jn+unoyDYEB1XEMZKLY495GUWOQRzBPSlNchmj
         PrHnYmQKgAZJQYKLm5nTfBwwwHCcjUdqmlptR2WGp9exUmcKy0W+Xqqr5546JS49rU49
         DO2/U7kiJ6Vb6BvtH7sIyWEoUKca2sTT4XRDcE3MMsCMkNRlFOaBIKbnXLMUavux8gk0
         jxaQfdSmeHq5Ma1nebVybi8BkP4P/ESJBjlNyf4keocstHV4ZJfCJAHPDiV45UbIh0W5
         5gDQ==
X-Gm-Message-State: APjAAAWIk4aejz6RHCU5bHwhM7Waz6bGckVNytrtzVVLoOms+pjb6ONZ
        JXki3BGlel7RhWQPdWEeDRI=
X-Google-Smtp-Source: APXvYqz0PO/gUjWxdhePfi47Eljly0FCq+XLQE5Tvm4jyTpgfS8z6n7vRDQBxoW13zSWJU/D0T5RLg==
X-Received: by 2002:a1c:dc09:: with SMTP id t9mr7014332wmg.65.1573728564499;
        Thu, 14 Nov 2019 02:49:24 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id k14sm7229301wrw.46.2019.11.14.02.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:49:24 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: sun4i-ss: remove dependency on not 64BIT
Date:   Thu, 14 Nov 2019 11:49:07 +0100
Message-Id: <20191114104907.10645-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114104907.10645-1-clabbe.montjoie@gmail.com>
References: <20191114104907.10645-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver now compile without warnings on 64bits, we can remove the
!64BIT condition.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index b3c9c34a30de..b0a5a0827483 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -7,7 +7,7 @@ config CRYPTO_DEV_ALLWINNER
 
 config CRYPTO_DEV_SUN4I_SS
 	tristate "Support for Allwinner Security System cryptographic accelerator"
-	depends on ARCH_SUNXI && !64BIT
+	depends on ARCH_SUNXI
 	depends on PM
 	depends on CRYPTO_DEV_ALLWINNER
 	select CRYPTO_MD5
-- 
2.23.0

