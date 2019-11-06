Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2BFC5DF63
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC42E2166E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIX1+9VI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfKFPQT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:16:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41097 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfKFPQT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 10:16:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so26246603wrm.8
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 07:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jpAt2Q47S8ScjdEF9A28sodyGFvR4UTRXT9boTfkgWY=;
        b=gIX1+9VI93Ea58eXiM8Bd9NQTZE0ZyMvN2GNylK61aQVEkw9Ifr7SczXNTY7UqHvgB
         k/PV7C7DfXDSygmCVVD4IaWXJ/WpCoZXD7kiDO+8S/bf4w+8mTukAwASssK0CKg0s8hD
         oUmDVmuO9YGPH7Ou/CgZ7es9/+ON6al8Eqb/yVbcn0EF30PmNzUnClliCEkjaxxhu9pp
         yxm/8UpkubNA/4EEHBTnJhJ0qYh2SRPoaawSQcCvaoyBIUrNA/rJXlPmsYppxl9djRSM
         BVMRXIv1S/vcS1I+xUNWVw0Yf4+OYJqBvQ6YP7CBL68KH0wUyvhx+Watc61YYzEl8dZw
         TVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jpAt2Q47S8ScjdEF9A28sodyGFvR4UTRXT9boTfkgWY=;
        b=qr0HhLAFSHvWqFtj5/G5n18QR6bLEXeb3grElVfTITIFXukikcElqfSL1ppkEOVuUw
         wA2ewWRQCj8OwlOTy8t/TQ1muXxG8PZvN1eDzqC1FRJxGmsZyVoK8JaCEulpUoFITjVv
         SLVRC/3LK+re+8ypbnOmW9lUaFzgv1+f2VPEfN/zFWp8WFuaMmtptF8GORFNT1ZO76rt
         wcwvqZLgVtkhDlM9bGw7/10844m4XZSlOy8FuwYNrNybJKIf/JKp9hykqF9DzxuX6HAk
         sGRvlgYPB/OZCFdWOkJPeT/2SuOhHXU28RWt8myDBklVYCoqKy3CMn0n01yZmwQBBkQ/
         2sMw==
X-Gm-Message-State: APjAAAWQm0HzRh9+8J8u38KXghtsdRIkeogh0+A9hUARAbDYGc0IuuIp
        Qw7DomZL42e4+n+BwTh+chtp35FH
X-Google-Smtp-Source: APXvYqzPhCE0XDho0b7ULLTC7m5+sY60AYc+CVgvuwWXEBBXd+IoqbtKUkztn0OOlvmO/+jnzxsAaQ==
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr3467625wre.232.1573053376693;
        Wed, 06 Nov 2019 07:16:16 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x9sm20384264wru.32.2019.11.06.07.16.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 07:16:15 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fix hangup during probing for EIP97 engine
Date:   Wed,  6 Nov 2019 16:13:07 +0100
Message-Id: <1573053187-8342-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed mask used for CFSIZE and RFSIZE fields of HIA_OPTIONS register,
these were all 1 bit too wide. Which caused the probing of a standard
EIP97 to actually hang due to assume way too large descriptor FIFO's.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index ba03e4d..b4624b5 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -257,13 +257,13 @@
 #define EIP197_CFSIZE_OFFSET			9
 #define EIP197_CFSIZE_ADJUST			4
 #define EIP97_CFSIZE_OFFSET			8
-#define EIP197_CFSIZE_MASK			GENMASK(3, 0)
-#define EIP97_CFSIZE_MASK			GENMASK(4, 0)
+#define EIP197_CFSIZE_MASK			GENMASK(2, 0)
+#define EIP97_CFSIZE_MASK			GENMASK(3, 0)
 #define EIP197_RFSIZE_OFFSET			12
 #define EIP197_RFSIZE_ADJUST			4
 #define EIP97_RFSIZE_OFFSET			12
-#define EIP197_RFSIZE_MASK			GENMASK(3, 0)
-#define EIP97_RFSIZE_MASK			GENMASK(4, 0)
+#define EIP197_RFSIZE_MASK			GENMASK(2, 0)
+#define EIP97_RFSIZE_MASK			GENMASK(3, 0)
 
 /* EIP197_HIA_AIC_R_ENABLE_CTRL */
 #define EIP197_CDR_IRQ(n)			BIT((n) * 2)
-- 
1.8.3.1

