Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFD6C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 22:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07B1C2084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 22:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbfIMWJ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 18:09:27 -0400
Received: from muru.com ([72.249.23.125]:60686 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfIMWJ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 18:09:27 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 67AF88043;
        Fri, 13 Sep 2019 22:09:57 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, devicetree@vger.kernel.org
Subject: [PATCH 0/6] Non-urgent fixes and improvments for omap3-rom-rng
Date:   Fri, 13 Sep 2019 15:09:16 -0700
Message-Id: <20190913220922.29501-1-tony@atomide.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

Here are fixes and improvments for omap3-rom-rng that's been broken for
a while.

The first four patches get it working, and then the last two patches add
support for runtime PM.

Regards,

Tony


Tony Lindgren (6):
  ARM: OMAP2+: Check omap3-rom-rng for GP device instead of HS device
  hwrng: omap3-rom - Fix missing clock by probing with device tree
  hwrng: omap3-rom - Call clk_prepare() on init and exit only
  hwrng: omap3-rom - Initialize default quality to get data
  hwrng: omap3-rom - Update to use standard driver data
  hwrng: omap3-rom - Use runtime PM instead of custom functions

 .../devicetree/bindings/rng/omap3_rom_rng.txt |  27 +++
 arch/arm/boot/dts/omap3-n900.dts              |   6 +
 arch/arm/mach-omap2/pdata-quirks.c            |  14 +-
 drivers/char/hw_random/omap3-rom-rng.c        | 186 ++++++++++++------
 4 files changed, 162 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt

-- 
2.23.0
