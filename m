From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH v5 4/4] dt-bindings: Add DT bindings document for Broadcom SBA RAID driver
Date: Thu, 16 Feb 2017 12:18:15 +0530
Message-ID: <1487227695-965-5-git-send-email-anup.patel@broadcom.com>
References: <1487227695-965-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-raid@vger.kernel.org, Anup Patel <anup.patel@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487227695-965-1-git-send-email-anup.patel@broadcom.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the DT bindings document for newly added Broadcom
SBA RAID driver.

Signed-off-by: Anup Patel <anup.patel@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
---
 .../devicetree/bindings/dma/brcm,iproc-sba.txt     | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt

diff --git a/Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt b/Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt
new file mode 100644
index 0000000..092913a
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt
@@ -0,0 +1,29 @@
+* Broadcom SBA RAID engine
+
+Required properties:
+- compatible: Should be one of the following
+	      "brcm,iproc-sba"
+	      "brcm,iproc-sba-v2"
+  The "brcm,iproc-sba" has support for only 6 PQ coefficients
+  The "brcm,iproc-sba-v2" has support for only 30 PQ coefficients
+- mboxes: List of phandle and mailbox channel specifiers
+
+Example:
+
+raid_mbox: mbox@67400000 {
+	...
+	#mbox-cells = <3>;
+	...
+};
+
+raid0 {
+	compatible = "brcm,iproc-sba-v2";
+	mboxes = <&raid_mbox 0 0x1 0xffff>,
+		 <&raid_mbox 1 0x1 0xffff>,
+		 <&raid_mbox 2 0x1 0xffff>,
+		 <&raid_mbox 3 0x1 0xffff>,
+		 <&raid_mbox 4 0x1 0xffff>,
+		 <&raid_mbox 5 0x1 0xffff>,
+		 <&raid_mbox 6 0x1 0xffff>,
+		 <&raid_mbox 7 0x1 0xffff>;
+};
-- 
2.7.4

