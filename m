Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D73C3B187
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E64820714
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgBKSV2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:21:28 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:60440 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730272AbgBKSTc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:19:32 -0500
Received: from ramsan ([84.195.182.253])
        by albert.telenet-ops.be with bizsmtp
        id 1WKV2200F5USYZQ06WKVNL; Tue, 11 Feb 2020 19:19:30 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a89-0002nd-BP; Tue, 11 Feb 2020 19:19:29 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a89-0003y9-AW; Tue, 11 Feb 2020 19:19:29 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 02/34] crypto: ccree - fix debugfs register access while suspended
Date:   Tue, 11 Feb 2020 19:18:56 +0100
Message-Id: <20200211181928.15178-3-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211181928.15178-1-geert+renesas@glider.be>
References: <20200211181928.15178-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reading the debugfs files under /sys/kernel/debug/ccree/ can be done by
the user at any time.  On R-Car SoCs, the CCREE device is power-managed
using a moduile clock, and if this clock is not running, bogus register
values may be read.

Fix this by filling in the debugfs_regset32.dev field, so debugfs will
make sure the device is resumed while its registers are being read.

This fixes the bogus values (0x00000260) in the register dumps on R-Car
H3 ES1.0:

    -e6601000.crypto/regs:HOST_IRR = 0x00000260
    -e6601000.crypto/regs:HOST_POWER_DOWN_EN = 0x00000260
    +e6601000.crypto/regs:HOST_IRR = 0x00000038
    +e6601000.crypto/regs:HOST_POWER_DOWN_EN = 0x00000038
     e6601000.crypto/regs:AXIM_MON_ERR = 0x00000000
     e6601000.crypto/regs:DSCRPTR_QUEUE_CONTENT = 0x000002aa
    -e6601000.crypto/regs:HOST_IMR = 0x00000260
    +e6601000.crypto/regs:HOST_IMR = 0x017ffeff
     e6601000.crypto/regs:AXIM_CFG = 0x001f0007
     e6601000.crypto/regs:AXIM_CACHE_PARAMS = 0x00000000
    -e6601000.crypto/regs:GPR_HOST = 0x00000260
    +e6601000.crypto/regs:GPR_HOST = 0x017ffeff
     e6601000.crypto/regs:AXIM_MON_COMP = 0x00000000
    -e6601000.crypto/version:SIGNATURE = 0x00000260
    -e6601000.crypto/version:VERSION = 0x00000260
    +e6601000.crypto/version:SIGNATURE = 0xdcc63000
    +e6601000.crypto/version:VERSION = 0xaf400001

Note that this behavior is system-dependent, and the issue does not show
up on all R-Car Gen3 SoCs and boards.  Even when the device is
suspended, the module clock may be left enabled, if configured by the
firmware for Secure Mode, or when controlled by the Real-Time Core.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@ragnatech.se>
---
v2:
  - Add Acked-by, Reviewed-by.
---
 drivers/crypto/ccree/cc_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 5669997386988055..35f3a2137502bd96 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -81,6 +81,7 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	regset->regs = debug_regs;
 	regset->nregs = ARRAY_SIZE(debug_regs);
 	regset->base = drvdata->cc_base;
+	regset->dev = dev;
 
 	ctx->dir = debugfs_create_dir(drvdata->plat_dev->name, cc_debugfs_dir);
 
@@ -102,6 +103,7 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 		verset->nregs = ARRAY_SIZE(pid_cid_regs);
 	}
 	verset->base = drvdata->cc_base;
+	verset->dev = dev;
 
 	debugfs_create_regset32("version", 0400, ctx->dir, verset);
 
-- 
2.17.1

