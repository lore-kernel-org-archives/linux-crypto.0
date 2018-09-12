From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 1/2] dt-bindings: crypto: hip07-sec, drop incorrect commas
Date: Wed, 12 Sep 2018 17:07:17 +0100
Message-ID: <20180912160718.3324-2-Jonathan.Cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 xuwei <xuwei5@huawei.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-crypto@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

There should not be a comma in the address used for the instance
so drop them.

This is a left over from a review of the final version before
Herbert Xu picked the series up.

Reported-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 8f026dc887fe ("dt-bindings: Add bidnings for Hisilicon SEC crypto accelerators")
---
 .../devicetree/bindings/crypto/hisilicon,hip07-sec.txt          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
index 78d2db9d4de5..d28fd1af01b4 100644
--- a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
+++ b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
@@ -24,7 +24,7 @@ Optional properties:
 
 Example:
 
-p1_sec_a: crypto@400,d2000000 {
+p1_sec_a: crypto@400d2000000 {
 	compatible = "hisilicon,hip07-sec";
 	reg = <0x400 0xd0000000 0x0 0x10000
 	       0x400 0xd2000000 0x0 0x10000
-- 
2.18.0
