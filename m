Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBF1C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 13:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B479206B6
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 13:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfBWN6s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 08:58:48 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17528 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbfBWN6s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 08:58:48 -0500
X-IronPort-AV: E=Sophos;i="5.58,403,1544482800"; 
   d="scan'208";a="370609499"
Received: from palace.lip6.fr ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES128-SHA256; 23 Feb 2019 14:58:43 +0100
From:   Julia Lawall <Julia.Lawall@lip6.fr>
To:     linux-amlogic@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 00/12] add missing of_node_put after of_device_is_available
Date:   Sat, 23 Feb 2019 14:20:31 +0100
Message-Id: <1550928043-14889-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.9.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Failure of of_device_is_available implies that the device node
should be put, if it is not used otherwise.

---

 arch/arm/mach-omap2/display.c                            |    4 +++-
 arch/powerpc/platforms/83xx/usb.c                        |    4 +++-
 drivers/bus/arm-cci.c                                    |    4 +++-
 drivers/cpufreq/armada-8k-cpufreq.c                      |    4 +++-
 drivers/crypto/amcc/crypto4xx_trng.c                     |    4 +++-
 drivers/firmware/psci.c                                  |    4 +++-
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c          |    4 +++-
 drivers/gpu/drm/tegra/rgb.c                              |    4 +++-
 drivers/phy/tegra/xusb.c                                 |    4 +++-
 drivers/soc/amlogic/meson-gx-socinfo.c                   |    4 +++-
 drivers/tee/optee/core.c                                 |    4 +++-
 drivers/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c |    4 +++-
 12 files changed, 36 insertions(+), 12 deletions(-)
