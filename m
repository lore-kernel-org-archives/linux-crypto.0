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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94742C4CEC8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 608A320830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWNZNq8w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfIMSn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 14:43:56 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:37194 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfIMSnz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 14:43:55 -0400
Received: by mail-ed1-f41.google.com with SMTP id i1so27933520edv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YWhv/GYp7+pgiOC3FdmOYcWNjzfsucRCnlTD8L3LiYA=;
        b=YWNZNq8wna6X0mBTVBmiuu+/RMyYaVVu7WGRs3folgQ6DmzCs8mKgT0Oh52Wx0NVME
         vRGcRbJQwmkN4xDPXqngpkjRj4g2NV8qQlfaOQvarusX1umtG2kxG6IKaICocmj0ALal
         NFZHw8SclljoYaJo9yNV1rhiJZZFGAl6LBN0U0UB16HAWaKiPnK2hpdbqPyUCKbopBFS
         +3nW7CMSst5fo9dLIN3fBEvr/056GN+dHhOmn4+7Uqg8X0iwjNcgUYknP+LMyb6kOm/z
         eTJ1uLxgWdzZqtd9lyh4dcnUdMP7PA/3nhlX611gLU/Rcy3VZLRawQ/3HreSBludrhXw
         2xyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YWhv/GYp7+pgiOC3FdmOYcWNjzfsucRCnlTD8L3LiYA=;
        b=lrkv1aDJY50hqNPzGmU3ZLjn6G9gf4WR2d1OMzx3zkBv05vlP2tvfL3NneYb49Gy27
         xi2zi3TawStFId4fs4eLLW56a7ZzCF0be1Eav6DLPP0CfSOpSLzfgzDcEmeJcvdGvE/v
         I5f0N2C99i7aL+WShBRlnbUKDCWDd7zDXIfwYs7MpFdsdkhTqCYcyZsFG3gknbXE+l5t
         xFVOuCN0/yKYamJycC7HBJ3kTxsNjRFpnLnEhKQqmsKzngqCTr3orlKteC3QyCV2R+ra
         GFs972hPYEyBNgoylYu5QoW9NFK09DE2GyLAL0yeWlpS+0ybGiRP7D3FxEpHt3FXM6Lp
         A6DA==
X-Gm-Message-State: APjAAAV8dkvFnCNv7r2ouWjpa5oOvyiCSO3E+6g04ltP0zgKMdI0vcZq
        brnO5zh33QpNdst/dTPo3ep7gELi
X-Google-Smtp-Source: APXvYqzjmsdJksvR+dWYEWmH7mrwSmXfRDwiCtvLWUZiqblMmpLq3+mRoXCqWxbyWr5NU4LAeXPpyw==
X-Received: by 2002:a17:907:2065:: with SMTP id qp5mr39969029ejb.151.1568400233620;
        Fri, 13 Sep 2019 11:43:53 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 16sm2416225ejz.52.2019.09.13.11.43.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 11:43:53 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/3] crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL
Date:   Fri, 13 Sep 2019 19:41:02 +0200
Message-Id: <1568396462-20245-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568396462-20245-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568396462-20245-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the addition of Chacha20-Poly1305 support to the inside-secure
driver, it now depends on CRYPTO_CHACHA20POLY1305. Added reference.

changes since v1:
- added missing dependency to crypto/Kconfig

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

