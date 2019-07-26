Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2898EC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06DE21734
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxA0F/3j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387517AbfGZQdg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 12:33:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32980 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387452AbfGZQdg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 12:33:36 -0400
Received: by mail-ed1-f66.google.com with SMTP id i11so53807154edq.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 09:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S6euVoy8QlkvbZ6+lhMwn1mZCaz8K1ZLx31+D9Nmww4=;
        b=LxA0F/3jBlWBqpHNGTvRvtPCpGLo44Gu5RxlUkbaT5Gf1mfgfpgmhMIDX15aidSSHA
         raNSKQ2WjiuAaalj1g2cy+sowLltRnE1iYwDRgyDirUrEY6FvHJ1BPrHfVUW4IbHgkHi
         SWtA2LuYhOq8yQcGlvO0M7IROBzJoxDymNrkc5Y76LdA3ZuS6vAUYo61jVCQP2Lv4Str
         1cc/3CSgTxO6di4AZZfLT+7gRJawsg2aZnBx6wOGNbbcmnIJKqaK5TyZoCNzHCF/Xa/Q
         GIgRFtBYBoL5qHBMeJl7fXmsUbPRhPY9Pr4/ZwkUCkMb6/pVAZYpF5wcDIL6GZFrpm1K
         7gQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S6euVoy8QlkvbZ6+lhMwn1mZCaz8K1ZLx31+D9Nmww4=;
        b=YppeGV7BV+aL/4e1hHWxqYBjnjohxpr1kDOpu5Tjg1oZ9scP15flx1wHSjsJgYbsly
         6IVMNe3toaaNDVp6NQns7UdaKotUZLtqex/4n1RZ1iZiHcqe5KERDv7tPAADa2cWptHu
         rmPWtaLiaMdVsNGCd4PfyKWzJbv+trtYrRd736lkuEOLcaRZtpoBwxadvY4BcQgwx78x
         ZDupQ/C49Mxn4aZLppjvU4rrXWCsWuMih4bMruPhokcFZkCVetMe4MtL7vRupCORH5N8
         OpXiUeiuYQR6Mhch5s9mLbfGcFc8GndiUkV5umUOoXcilWdxBmyUYsq4U8IoP+9PXAi5
         MOTQ==
X-Gm-Message-State: APjAAAX4cmcaxIqoRm/kVJxI7vEoFBprl1RwWNuNkfUXPDaHNCW5/NQ4
        Jk2awrfbPr9o0lZXCaNLiQM6GXo5
X-Google-Smtp-Source: APXvYqx8oNTPbA3TQrQokrBAmm4adUKFUMhrTdFRbIv6SBlAtGP9u7Gn0bgUa/Z13ySOKeo/DyZ6Lw==
X-Received: by 2002:aa7:cf0c:: with SMTP id a12mr83559731edy.146.1564158814942;
        Fri, 26 Jul 2019 09:33:34 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c53sm14414865ede.84.2019.07.26.09.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 09:33:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod for macchiatobin
Date:   Fri, 26 Jul 2019 17:31:09 +0200
Message-Id: <1564155069-18491-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This small patch fixes a null pointer derefence panic that occurred when
unloading the driver (using rmmod) on macchiatobin due to not setting
the platform driver data properly in the probe routine.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 45443bf..423ea2d 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1274,6 +1274,8 @@ static int safexcel_probe(struct platform_device *pdev)
 	priv->dev = dev;
 	priv->version = (enum safexcel_eip_version)of_device_get_match_data(dev);
 
+	platform_set_drvdata(pdev, priv);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->base)) {
-- 
1.8.3.1

