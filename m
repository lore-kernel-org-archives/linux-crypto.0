From: Simon Baatz <gmbnomis@gmail.com>
Subject: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Sat, 16 Jun 2012 02:20:19 +0200
Message-ID: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: phil.sutter@viprinet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65156 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2FPAVA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2012 20:21:00 -0400
Received: by wgbdr13 with SMTP id dr13so3615073wgb.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jun 2012 17:20:59 -0700 (PDT)
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil,

thanks for providing these patches; it's great to finally see DMA
support for CESA in the kernel. Additionally, the implementation seems
to be fine regarding cache incoherencies (at least my test in [*]
works).

I have two patches for your patchset...

- Fix for mv_init_engine error handling

- My system locked up hard when mv_dma and mv_cesa were built as
  modules. mv_cesa has code to enable the crypto clock in 3.5, but
  mv_dma already accesses the CESA engine before. Thus, we need to
  enable this clock here, too.

[*] http://www.spinics.net/lists/arm-kernel/msg176913.html

Simon Baatz (2):
  mv_dma: fix mv_init_engine() error case
  ARM: Orion: mv_dma: Add support for clk

 arch/arm/mach-kirkwood/common.c |    1 +
 drivers/crypto/mv_dma.c         |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.7.9.5
