Return-Path: <SRS0=ErXm=O7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:16654 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391187AbeLVXgF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 18:36:05 -0500
From: Zhou Wang <wangzhou1@hisilicon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 1/4] Documentation: Add debugfs doc for hisi_zip
Date: Sat, 22 Dec 2018 15:51:42 +0800
Message-ID: <1545465105-133138-2-git-send-email-wangzhou1@hisilicon.com>
In-Reply-To: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add debugfs descriptions for HiSilicon ZIP and QM driver.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/ABI/testing/debugfs-hisi-zip | 50 ++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip

diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
new file mode 100644
index 0000000..a7c63e6
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -0,0 +1,50 @@
+What:           /sys/kernel/debug/hisi_zip/<bdf>/comp_core[01]/regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of compression cores related debug registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/decomp_core[0-5]/regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of decompression cores related debug registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/clear_enable
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Compression/decompression core debug registers read clear
+		control. 1 means enable register read clear, otherwise 0.
+		Writing to this file has no functional effect, only enable or
+		disable counters clear after reading of these registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/current_qm
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    One ZIP controller has one PF and multiple VFs, each function
+		has a QM. Select the QM which below qm refers to.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/qm_regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of QM related debug registers.
+		Available for PF and VF in host. VF in guest currently only
+		has one debug register.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/current_q
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    One QM may contain multiple queues. Select specific queue to
+		show its debug registers in above qm_regs.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/clear_enable
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    QM debug registers(qm_regs) read clear control. 1 means enable
+		register read clear, otherwise 0.
+		Writing to this file has no functional effect, only enable or
+		disable counters clear after reading of these registers.
+		Only available for PF.
-- 
2.8.1
