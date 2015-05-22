From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 12/16] crypto: marvell/CESA: update DT bindings documentation
Date: Fri, 22 May 2015 15:33:58 +0200
Message-ID: <1432301642-11470-13-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add DT bindings documentation for the new marvell-cesa driver.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 .../devicetree/bindings/crypto/marvell-cesa.txt    | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt

diff --git a/Documentation/devicetree/bindings/crypto/marvell-cesa.txt b/Documentation/devicetree/bindings/crypto/marvell-cesa.txt
new file mode 100644
index 0000000..4ce9bc5
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/marvell-cesa.txt
@@ -0,0 +1,46 @@
+Marvell Cryptographic Engines And Security Accelerator
+
+Required properties:
+- compatible: should be one of the following string
+	      "marvell,orion-crypto"
+	      "marvell,kirkwood-crypto"
+	      "marvell,armada-370-crypto"
+	      "marvell,armada-xp-crypto"
+	      "marvell,armada-375-crypto"
+	      "marvell,armada-38x-crypto"
+- reg: base physical address of the engine and length of memory mapped
+       region
+- reg-names: "regs"
+- interrupts: interrupt number
+- clocks: reference to the crypto engines clocks. This property is not
+	  required for orion and kirkwood platforms
+- clock-names: "cesaX" and "cesazX", X should be replaced by the crypto engine
+	       id.
+	       This property is not required for the orion and kirkwoord
+	       platforms.
+	       "cesazX" clocks are not required on armada-370 platforms
+- marvell,crypto-srams: phandle to crypto SRAM definitions
+
+Optional properties:
+- marvell,crypto-sram-size: SRAM size reserved for crypto operations, if not
+			    specified the whole SRAM is used (2KB)
+
+Deprecated properties:
+- reg: base physical address of the engine and length of memory mapped
+       region, followed by base physical address of sram and its memory
+       length
+- reg-names: "regs" , "sram"
+
+Examples:
+
+	crypto@90000 {
+		compatible = "marvell,armada-xp-crypto";
+		reg = <0x90000 0x10000>;
+		reg-names = "regs";
+		interrupts = <48>, <49>;
+		clocks = <&gateclk 23>, <&gateclk 23>;
+		clock-names = "cesa0", "cesa1";
+		marvell,crypto-srams = <&crypto_sram0>, <&crypto_sram1>;
+		marvell,crypto-sram-size = <0x600>;
+		status = "okay";
+	};
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
