From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/10] staging: ccree: remove interim DT docs
Date: Sun,  3 Dec 2017 13:58:17 +0000
Message-ID: <1512309503-29766-7-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

As proper DT bindings doc where submitted and ACKed,
remove the interim one.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 .../devicetree/bindings/crypto/arm-cryptocell.txt  | 27 ----------------------
 1 file changed, 27 deletions(-)
 delete mode 100644 drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt

diff --git a/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
deleted file mode 100644
index 2ea6517..0000000
--- a/drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-Arm TrustZone CryptoCell cryptographic accelerators
-
-Required properties:
-- compatible: must be "arm,cryptocell-712-ree".
-- reg: shall contain base register location and length.
-	Typically length is 0x10000.
-- interrupts: shall contain the interrupt for the device.
-
-Optional properties:
-- interrupt-parent: can designate the interrupt controller the
-	device interrupt is connected to, if needed.
-- clocks: may contain the clock handling the device, if needed.
-- power-domains: may contain a reference to the PM domain, if applicable.
-
-
-Examples:
-
-Zynq FPGA device
-----------------
-
-       arm_cc7x: arm_cc7x@80000000 {
-               compatible = "arm,cryptocell-712-ree";
-               interrupt-parent = <&intc>;
-               interrupts = < 0 30 4 >;
-               reg = < 0x80000000 0x10000 >;
-       };
-
-- 
2.7.4
