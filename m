Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE81CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 14:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDBFD218AE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 14:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfJVO2S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 10:28:18 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:45591 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfJVO2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 10:28:18 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MN5aF-1idDT43P41-00J6G4; Tue, 22 Oct 2019 16:27:47 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: omap3-rom - Fix unused function warnings
Date:   Tue, 22 Oct 2019 16:27:31 +0200
Message-Id: <20191022142741.1794378-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PBfTuEp8ZX4Ra2Ce3a9pZMSs9SwhMX1hftuoj/HSfQ/p0GlQWT4
 wMj8mkLE7kG+8bdty5J1+ElmfuOTIR4PA6vdmHFsFLC0YXcpfucBrpTcccLMbR6YXng5JVu
 zE7vpU4lQC0NFySxsgbnkX4cEG95HGNmQWpd8uRboG0BVC4+FQgUOv15lgD8qAWPhbEnYba
 tNjqA/jWVavi2TrI1wYfg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pKRLuV2+9dI=:6cTjtlK905RHJs9ndFcqmD
 juozbcR0cdC4bMaUv2wwl6wuJrWELOB45PPT6II7Kef6Vub0TSU5FFQk/iKBYuLi88kUDPtK7
 7vaTpiHI3qkJQIUNBziBwkg8xIAeOlU/Ze7GkCT85tdTAF8Z2p+MQaV7Sc5Ie9PIYsMu8dOyP
 /LqJU8oAIJ2h8wnKKVhpoJ20FFmQj2ETCkxFs4EvykGt93Lof1ORVpTH0jd5mrXT4qfoGszXI
 xJk3RPilXcdGBszcps4Uc0xJu48ZgoybpIkvqQdgPAO+7PdhHL3pUkrgrTX5GiHWqfBGlGaAN
 JoKezIHCF5sq/q2fZSLG0Cg/yC6pj/KdBZFl8ntnxBHG6OlZ/LtZjhnuO7wRxRT82rmEWOyWp
 r9Iy+joHgPvnzw6HjnWfqPz0aGidOqjEA1EoDMeNsSgJUf/fMVnh7DxCyBDjdvtHCNezJXdwX
 HyN1jg6bOGbxFbo93wMXApStWS/WTikWUdStKZS5UTgVSbSS2HwPIrK6h5t7KIEYKsY667iNK
 +zKbvb6uc7JS6ZwcsNJhs5i8oyJ5Zbc3dL0yLOGbtfyDSfeGcGe6iavaFuo/kr3ZO4jF/EG2n
 dN4AoZ3H175TBYbr9+YV8B0PCByqpNbVHMvG6XLnKY2kl8vnZnxgXu1zKZ3llRKe2EUY3jhnq
 AMMOCTx04fbukNEpcKqVduYCJu0qXfDLeP24tQDFceNGbTmy7tD9twpmYJSe64+A6Iedtj91/
 Y4DQrY0KpjrLYjZTBvnPBm5EflRX5Kki1hmyk5ScEZQ8hERqOmGEl3bY1jtfZaWL6Xzxjz1Be
 kY25MZEJbHMalz08x1sntIC1dKasN2delAgrDfjKfL4q1mcQn5YT3bV0OOMyGq82+mIXSAWaq
 TqWnK6DBylwqp8GwnGLg==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When runtime-pm is disabled, we get a few harmless warnings:

drivers/char/hw_random/omap3-rom-rng.c:65:12: error: unused function 'omap_rom_rng_runtime_suspend' [-Werror,-Wunused-function]
drivers/char/hw_random/omap3-rom-rng.c:81:12: error: unused function 'omap_rom_rng_runtime_resume' [-Werror,-Wunused-function]

Mark these functions as __maybe_unused so gcc can drop them
silently.

Fixes: 8d9d4bdc495f ("hwrng: omap3-rom - Use runtime PM instead of custom functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hw_random/omap3-rom-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 0b90983c95c8..e08a8887e718 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -62,7 +62,7 @@ static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 	return r;
 }
 
-static int omap_rom_rng_runtime_suspend(struct device *dev)
+static int __maybe_unused omap_rom_rng_runtime_suspend(struct device *dev)
 {
 	struct omap_rom_rng *ddata;
 	int r;
@@ -78,7 +78,7 @@ static int omap_rom_rng_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int omap_rom_rng_runtime_resume(struct device *dev)
+static int __maybe_unused omap_rom_rng_runtime_resume(struct device *dev)
 {
 	struct omap_rom_rng *ddata;
 	int r;
-- 
2.20.0

