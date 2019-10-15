Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166FAECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E80CD205F4
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfJOMgM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 08:36:12 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:46245 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfJOMgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 08:36:12 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKM3a-0001pw-Ti; Tue, 15 Oct 2019 13:36:07 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKM3a-0007Uc-FR; Tue, 15 Oct 2019 13:36:06 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: ka-sa - fix __iomem on registers
Date:   Tue, 15 Oct 2019 13:36:04 +0100
Message-Id: <20191015123604.28749-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add __ioemm attribute to reg_rng to fix the following
sparse warnings:

drivers/char/hw_random/ks-sa-rng.c:102:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:102:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:102:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:104:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:104:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:104:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:113:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:113:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:113:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:116:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:116:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:116:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:119:17: warning: incorrect type in argument 1 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:119:17:    expected void const volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:119:17:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:121:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:121:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:121:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:132:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:132:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:132:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:143:19: warning: incorrect type in argument 1 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:143:19:    expected void const volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:143:19:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:144:19: warning: incorrect type in argument 1 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:144:19:    expected void const volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:144:19:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:146:9: warning: incorrect type in argument 2 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:146:9:    expected void volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:146:9:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:160:25: warning: incorrect type in argument 1 (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:160:25:    expected void const volatile [noderef] <asn:2> *addr
drivers/char/hw_random/ks-sa-rng.c:160:25:    got unsigned int *
drivers/char/hw_random/ks-sa-rng.c:194:28: warning: incorrect type in assignment (different address spaces)
drivers/char/hw_random/ks-sa-rng.c:194:28:    expected struct trng_regs *reg_rng
drivers/char/hw_random/ks-sa-rng.c:194:28:    got void [noderef] <asn:2> *

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/hw_random/ks-sa-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index a67430010aa6..d40bdb829861 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -84,7 +84,7 @@ struct ks_sa_rng {
 	struct hwrng	rng;
 	struct clk	*clk;
 	struct regmap	*regmap_cfg;
-	struct trng_regs *reg_rng;
+	struct trng_regs __iomem *reg_rng;
 };
 
 static int ks_sa_rng_init(struct hwrng *rng)
-- 
2.23.0

