Return-Path: <SRS0=wcu2=DU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469F7C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 12:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC9822247
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602591336;
	bh=6jY6pADWd4LdcEnG1rOTq/8tMFI7N/XzmAw3LP7tTK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ytsnLgEOB0d22GKsUfvcsZQl2/o9rekBgcPT8zZdXUh7GAIGXcgCr7gEE335LF/gD
	 hGo7+OK3QpxCuLYvicg8BDwPdgjpr6sG7hsuOEldIdK/EhTj/Lx0pNIU0GfHdmrjKJ
	 sIAbFIMtiJY/wRFypydxuO0ElU5yFZ25k5rlpBfc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgJMMPf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Oct 2020 08:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgJMMO5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Oct 2020 08:14:57 -0400
Received: from mail.kernel.org (ip5f5ad5b2.dynamic.kabel-deutschland.de [95.90.213.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 585F122384;
        Tue, 13 Oct 2020 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602591295;
        bh=6jY6pADWd4LdcEnG1rOTq/8tMFI7N/XzmAw3LP7tTK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLKLRGcHw+Jhgg8LShujgoam4S9h+R4TwFSFdIFJ7DcuJcnUGoQZwcgdFUtqFO9FA
         ei5qhg5SRXErlQbzrLOrpe4SfY/9G1f7Fvo28tbrIL4yj9V5hggiCJU7K/kCDNFlLG
         i8ncBRqdGaJjbQJRqCVohbtIl1YB9mniaOPRZRCU=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kSJCf-006Cof-9R; Tue, 13 Oct 2020 14:14:53 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>, Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/24] crypto: sun8x-ce*: update entries to its documentation
Date:   Tue, 13 Oct 2020 14:14:48 +0200
Message-Id: <f8e8feef7e17cf66a2587139386d951a0265adcf.1602590106.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1602590106.git.mchehab+huawei@kernel.org>
References: <cover.1602590106.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The README file was converted to ReST format. Update the
references for it accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index fa2f1b4fad7b..a94bf28f858a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -7,7 +7,7 @@
  *
  * This file add support for MD5 and SHA1/SHA224/SHA256/SHA384/SHA512.
  *
- * You could find the datasheet in Documentation/arm/sunxi/README
+ * You could find the datasheet in Documentation/arm/sunxi.rst
  */
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
index 78503006949c..cfde9ee4356b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -7,7 +7,7 @@
  *
  * This file handle the PRNG
  *
- * You could find a link for the datasheet in Documentation/arm/sunxi/README
+ * You could find a link for the datasheet in Documentation/arm/sunxi.rst
  */
 #include "sun8i-ce.h"
 #include <linux/dma-mapping.h>
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
index 654328160d19..5b7af4498bd5 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
@@ -7,7 +7,7 @@
  *
  * This file handle the TRNG
  *
- * You could find a link for the datasheet in Documentation/arm/sunxi/README
+ * You could find a link for the datasheet in Documentation/arm/sunxi.rst
  */
 #include "sun8i-ce.h"
 #include <linux/dma-mapping.h>
-- 
2.26.2

