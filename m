From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH 1/1] cavium: Add firmware for CNN55XX crypto driver.
Date: Fri, 16 Jun 2017 19:52:26 +0530
Message-ID: <20170616142226.3950-2-Jampala.Srikanth@cavium.com>
References: <20170616142226.3950-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-firmware@kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Sreerama.Gadam@cavium.com,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0068.outbound.protection.outlook.com ([104.47.41.68]:11811
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754202AbdFPOXW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 10:23:22 -0400
In-Reply-To: <20170616142226.3950-1-Jampala.Srikanth@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds the firmware for CNN55XX cryto driver,
supports Symmetric crypto operations.

The version of the firmware is v07.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 WHENCE        |   9 +++++++++
 cnn55xx_se.fw | Bin 0 -> 27698 bytes
 2 files changed, 9 insertions(+)
 create mode 100644 cnn55xx_se.fw

diff --git a/WHENCE b/WHENCE
index fafb1ce..a3142f0 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3257,6 +3257,15 @@ Licence: Redistributable. See LICENCE.cavium for details
 
 --------------------------------------------------------------------------
 
+Driver: nitrox -- Cavium CNN55XX crypto driver
+
+File: cnn55xx_se.fw
+Version: v07
+
+Licence: Redistributable. See LICENCE.cavium for details
+
+--------------------------------------------------------------------------
+
 Driver: i915 -- Intel Integrated Graphics driver
 
 File: i915/skl_dmc_ver1_23.bin
diff --git a/cnn55xx_se.fw b/cnn55xx_se.fw
new file mode 100644
index 0000000000000000000000000000000000000000..076e270d383488e7ae67e8f4224a519c4173bedc
GIT binary patch
literal 27698
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

literal 0
HcmV?d00001

-- 
2.9.4
