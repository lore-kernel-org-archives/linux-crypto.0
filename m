Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F2DC33C8C
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3116A2081E
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZ0GQGKU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFTa7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 14:30:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54528 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFTa7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 14:30:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so16194245wmj.4;
        Mon, 06 Jan 2020 11:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+Ho1Pj7J9GuDhhBZpvri/eVbdt/D+i9M0mADHfjbgE=;
        b=AZ0GQGKU8r7d3GoITl6teTa4tNztNUC8EnLvD7dYehXxtRaqWMKEFCyc2QOK7b8OV/
         JDCLA/e0YuLZj1zwJbtI3sUaZhgwrDH/zn+zI9W3WMGlU98PG5DfiA320CBsdOzpis+C
         loP8Gzv4OwMAakU1l2GnbV1a8TStBfX7O2nzxLuOQRCkHutC3PRgjLsFUikxnqWoIxIb
         WgPXZNX+Qrb8F5wM3i7bWwDJ1qnQJMPyACa2C/cop9kNq14Yof4QKwXhImCnKM+NRRo5
         Zn7ELNpEDz+G/5k1Y3JWnzx8dWqXClr4QtdxSVxHf5q+ntbANetmJ86H+UfDDLxUDOJm
         RtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+Ho1Pj7J9GuDhhBZpvri/eVbdt/D+i9M0mADHfjbgE=;
        b=pzOSUxwuzteBgt2xcgVU9hx+ybMb+Ae8N0FiiZzDN94WF54VRLKxKbr0kwO6WoSUGG
         0I+lueX+pK+y8ASBJpvArJ2nawupX3hbpa3zk9gMCY2Tca4hP9sF44PLQvbLGCBfe0Qt
         Z3rjuBfX/eeLiXAGzCcrnfEYuaQTVzp8bG253mcj8jQLBVWjWYTAM0QOVE+eAmNIKOyQ
         Z9Ghc3nWKJffiKuigScsFaqq/ir2UNHG1UfK5SnxyThS7K7W+G6VEV8Rh45xjAZMb3lW
         +o+TQxaMObVZZ5nTRtFiK030aoCf7Pwq2qn4/ubPT1TmS1npYaR4w7iVxhMnFl3o8Ewu
         YLBA==
X-Gm-Message-State: APjAAAW3lnTfwkO7Ui38u4GSnYynYfHgPHsbpeiBr4rACtHW86sl6MUC
        k0J6yhgK3QsMboza+OQz0QI=
X-Google-Smtp-Source: APXvYqyMpnlA1NKMCSBr0d99djCgQuz0ptyKFjmP+kFlJqkUVN0JiliK2oWB0YKkldrABpwGwhHX6g==
X-Received: by 2002:a1c:6a13:: with SMTP id f19mr37837776wmc.20.1578339057153;
        Mon, 06 Jan 2020 11:30:57 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id z83sm24100123wmg.2.2020.01.06.11.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 11:30:56 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun8i-ce: fix removal of module
Date:   Mon,  6 Jan 2020 20:30:53 +0100
Message-Id: <20200106193053.2884-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Removing the driver cause an oops due to the fact we clean an extra
channel.
Let's give the right index to the cleaning function.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 53739507c8c2..f72346a44e69 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -624,7 +624,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 error_irq:
 	sun8i_ce_pm_exit(ce);
 error_pm:
-	sun8i_ce_free_chanlist(ce, MAXFLOW);
+	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 	return err;
 }
 
@@ -638,7 +638,7 @@ static int sun8i_ce_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(ce->dbgfs_dir);
 #endif
 
-	sun8i_ce_free_chanlist(ce, MAXFLOW);
+	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
 
 	sun8i_ce_pm_exit(ce);
 	return 0;
-- 
2.24.1

