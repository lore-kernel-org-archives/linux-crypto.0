From: Varun Wadekar <vwadekar@nvidia.com>
Subject: [PATCH v5 1/2] arm: tegra: export tegra_chip_uid
Date: Wed, 16 Nov 2011 13:54:09 +0530
Message-ID: <1321431850-21906-2-git-send-email-vwadekar@nvidia.com>
References: <1321431850-21906-1-git-send-email-vwadekar@nvidia.com>
Cc: linux-tegra@vger.kernel.org, olof@lixom.net, ccross@android.com,
	Henning Heinold <heinold@inf.fu-berlin.de>,
	Varun Wadekar <vwadekar@nvidia.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1315 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1KPIYz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 03:24:55 -0500
In-Reply-To: <1321431850-21906-1-git-send-email-vwadekar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Henning Heinold <heinold@inf.fu-berlin.de>

The crypto driver will need this api to use
it in the RNG calculations. In order to build
the crypto driver as a module, tegra_chip_uid
has to be exported.

Change-Id: I1372c06b8cfef74699ea9cd5cfca92648bcd982b
Signed-off-by: Henning Heinold <heinold@inf.fu-berlin.de>
Signed-off-by: Varun Wadekar <vwadekar@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 1fa26d9..ea49bd9 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/module.h>
 
 #include <mach/iomap.h>
 
@@ -58,6 +59,7 @@ unsigned long long tegra_chip_uid(void)
 	hi = fuse_readl(FUSE_UID_HIGH);
 	return (hi << 32ull) | lo;
 }
+EXPORT_SYMBOL(tegra_chip_uid);
 
 int tegra_sku_id(void)
 {
-- 
1.7.1
