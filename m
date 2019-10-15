Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490AEECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 216D121925
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 12:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfJOM17 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 08:27:59 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:45942 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfJOM17 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 08:27:59 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKLvg-0001bK-0Q; Tue, 15 Oct 2019 13:27:56 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKLvf-0003qC-JQ; Tue, 15 Oct 2019 13:27:55 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: omap3-rom fix pointer warning for omap3_rom_rng_idle
Date:   Tue, 15 Oct 2019 13:27:54 +0100
Message-Id: <20191015122754.14721-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The omap3_rom_rng_idle function takes a pointer, so give
it a pointer instead of a plain 0. This fixes the following
sparse warning:

drivers/char/hw_random/omap3-rom-rng.c:115:28: warning: Using plain integer as NULL pointer

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/hw_random/omap3-rom-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 38b719017186..75fe3dc83d28 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -112,7 +112,7 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(rng_clk);
 	if (ret)
 		return ret;
-	omap3_rom_rng_idle(0);
+	omap3_rom_rng_idle(NULL);
 
 	return hwrng_register(&omap3_rom_rng_ops);
 }
-- 
2.23.0

