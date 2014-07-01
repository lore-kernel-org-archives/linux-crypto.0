From: Nitesh Narayan Lal <b44382@freescale.com>
Subject: [PATCH] crypto: dts - Addition of missing SEC compatibile property in c29x device tree
Date: Tue, 1 Jul 2014 19:37:23 +0530
Message-ID: <1404223643-32275-1-git-send-email-b44382@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nitesh Narayan Lal <b44382@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<r66431@freescale.com>, <b16394@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:11979
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753637AbaGAJP2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 05:15:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver is compatible with SEC version 4.0, which was missing from
device tree resulting that the caam driver doesn't gets probed. Since
SEC is backward compatible with older versions, so this patch adds those
missing versions in c29x device tree.

Signed-off-by: Nitesh Narayan Lal <b44382@freescale.com>
Signed-off-by: Vakul Garg <b16394@freescale.com>
---
 arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi
index f75b4f820..7d4a6a2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi
@@ -32,7 +32,8 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-	compatible = "fsl,sec-v6.0";
+	compatible = "fsl,sec-v6.0", "fsl,sec-v5.0",
+		     "fsl,sec-v4.0";
 	fsl,sec-era = <6>;
 	#address-cells = <1>;
 	#size-cells = <1>;
-- 
1.8.3.2
