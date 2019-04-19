Return-Path: <SRS0=LFue=SV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5678C282E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC91222AF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Apr 2019 18:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="lSFfb/RZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfDSSWR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:22:17 -0400
Received: from condef-02.nifty.com ([202.248.20.67]:38432 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfDSSWP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Apr 2019 14:22:15 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2019 14:22:14 EDT
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-02.nifty.com with ESMTP id x3J5cTLN026773;
        Fri, 19 Apr 2019 14:38:29 +0900
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x3J5c2KL005336;
        Fri, 19 Apr 2019 14:38:02 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x3J5c2KL005336
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1555652282;
        bh=4axk+3JnSBy9Cf8hJ+npE8SJ402DCu6CYUJePL/QaIw=;
        h=From:To:Cc:Subject:Date:From;
        b=lSFfb/RZHkaH0OzT20hVQ2I9k+Wwxa4E/aXYBTQ0JAk4OZ/WmMAIsjW8BsyxmdM8z
         OUgGD6alglyPj3LEUfYYFPi4LojLt3KaD7QnJ3OSEibvYXUcQ3f1FAWtS4xVrX7+VY
         iZFqkbgG9RQa4EBYsd7Z3uwjRnza48fTmXZlTeis76wMTPdbDYOt9q+FE+3ecPBtsN
         TaQKDosL3uxdlCXvK+i2B7G+HPcG0U4VsCBIfXUy88j8bqq+pbSqt9y7J9k+gZ43Dw
         fdhDnM9k7hmimvvJWQ6RIZfwkRmzj1vxEsCmqUlJ8Rfobxqcfw7N9Cqgfrcf+KCPbx
         uJ7a3+PTQtxiQ==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ux500 - use ccflags-y instead of CFLAGS_<basename>.o
Date:   Fri, 19 Apr 2019 14:37:57 +0900
Message-Id: <20190419053757.18892-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of adding CFLAGS_<basename>.o to every file, let's use
ccflags-y, which is effective for all C files in the directory.

No behavior change.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/crypto/ux500/cryp/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/Makefile b/drivers/crypto/ux500/cryp/Makefile
index b497ae3dde07..dc8fff29c4b3 100644
--- a/drivers/crypto/ux500/cryp/Makefile
+++ b/drivers/crypto/ux500/cryp/Makefile
@@ -3,11 +3,7 @@
 # * Author: shujuan.chen@stericsson.com for ST-Ericsson.
 # * License terms: GNU General Public License (GPL) version 2  */
 
-ifdef CONFIG_CRYPTO_DEV_UX500_DEBUG
-CFLAGS_cryp_core.o := -DDEBUG
-CFLAGS_cryp.o := -DDEBUG
-CFLAGS_cryp_irq.o := -DDEBUG
-endif
+ccflags-$(CONFIG_CRYPTO_DEV_UX500_DEBUG) += -DDEBUG
 
 obj-$(CONFIG_CRYPTO_DEV_UX500_CRYP) += ux500_cryp.o
 ux500_cryp-objs :=  cryp.o cryp_irq.o cryp_core.o
-- 
2.17.1

