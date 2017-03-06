From: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 4/4] dt-bindings: Add DT bindings document for Broadcom SBA RAID driver
Date: Mon,  6 Mar 2017 15:13:28 +0530
Message-ID: <1488793408-25592-5-git-send-email-anup.patel@broadcom.com>
References: <1488793408-25592-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488793408-25592-1-git-send-email-anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the DT bindings document for newly added Broadcom
SBA RAID driver.

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Ray Jui <ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Scott Branden <scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
