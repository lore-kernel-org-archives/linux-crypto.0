Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF270C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 12:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FFAD222C4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602245746;
	bh=6jY6pADWd4LdcEnG1rOTq/8tMFI7N/XzmAw3LP7tTK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vKWFI43Q3cqEGXziwrv56xh80g2OZM2BtfJFi63b/M6QTlUsvyMKc3pOOwtOgnKaz
	 HR7YxvbXvwAxyYnneVhEHJMPlbRr2n+8RGf8XlDUBPFawbu//l6vRJU7JmhHrc+HBJ
	 CRCr+ebyRZ3aWSGq+rxjPSY+u3xK2QhFMylWP+9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388486AbgJIMPp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 08:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388460AbgJIMPh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 08:15:37 -0400
Received: from mail.kernel.org (ip5f5ad5d0.dynamic.kabel-deutschland.de [95.90.213.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D120222B9;
        Fri,  9 Oct 2020 12:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602245736;
        bh=6jY6pADWd4LdcEnG1rOTq/8tMFI7N/XzmAw3LP7tTK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AeBMrZ4FC+HlS20YlGTq0hOpIlfLPoMUe7dwcxMv+i4B6MLcrCTsAJ/yKdiGF+0o
         3EIB0NBNDnSDuSjQPU4BDTAt3uFmqZggpsTJvSK0lPkIMKZDxj7YdRRy2mH7P7qGpK
         nNySqgQCgwMzj4SapTVMtZWajXTFi1DJKzAsJLWw=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kQrJ6-003kt3-JY; Fri, 09 Oct 2020 14:15:32 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: sun8x-ce*: update entries to its documentation
Date:   Fri,  9 Oct 2020 14:15:31 +0200
Message-Id: <52bfc99d585587cf4eaeb0b2ba85f7da751f7f33.1602245659.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1602245659.git.mchehab+huawei@kernel.org>
References: <cover.1602245659.git.mchehab+huawei@kernel.org>
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

