Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D45145B25;
	Tue, 13 May 2025 18:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161640; cv=none; b=p3O7Y7EHdc59y+AZZYUIwKCvIhTQ/MjMCy1aeHtBdnz1u2CPi2eRlZ/9NAj5JZ4lrO77rKxp5D2at2+tZljN0NMuN08c+TkCEV5D1r/e2QM/DcJD46U0R+4Oq0eN61ryEey4uA3grlZfvXUXo/y1CztlnK8l2BMibZZkF7nfq64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161640; c=relaxed/simple;
	bh=Vs2C3qOUbRBwvYmS5MjM0iD2wHG0dHWNUgMPIk3Zu70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIO4opJzJJJu/F63C1Ywdc6hUoZLLgkf0OpjkOfbsuhBM2F3SGtfxsNw0YFNVXgOJg+U4mwPzP5auBBOgfQR7MqwjU5ZmhrefUfl7A5Ig/Tgq8SvOde+8wuAtl7li50rr/INnHBKTfrc34El49NVzYtxFMvB7AXNvRrR5uIm0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTnW/qEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTnW/qEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A031C4CEE4;
	Tue, 13 May 2025 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747161639;
	bh=Vs2C3qOUbRBwvYmS5MjM0iD2wHG0dHWNUgMPIk3Zu70=;
	h=From:To:Cc:Subject:Date:From;
	b=gTnW/qErJnYV2LqRR/j1WWPpDFFgRA7vs3cghFfNzBNW0gC6ZFKzFSOiDm+nu4grW
	 k4T8x0z9QU4QnQuff554CZ9pFPD67bSgrOKGwHnI0d+CjtwzCGEjEr0J6C8hSdOudY
	 dMNgpeL0eElx304doApj2bv4PFPNL2y3redG4TCA4oBhUPLPIZKDtc3PTIvNq5zVw5
	 iozHg5R82YzLFc0euhDXsgnfvOx61KAKN3rTp7fPpjY2Q7SR0/yAKZRhND58ux93DQ
	 eSCuFVH0H/eECADZ6cNITL15shchx7sB3yve6euwIaTSWlMNEiIbeTgFNIyYJ95DB8
	 b9pvBL1JcE3nA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: fsl,sec-v4.0: Add fsl,sec-v6.0
Date: Tue, 13 May 2025 13:40:28 -0500
Message-ID: <20250513184030.3051100-1-robh@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fsl,sec-v6.0 binding is the same as the fsl,sec-v4.0 binding, so add
it to the existing schema and drop the old .txt binding.

The compatibles in the .txt binding don't match the 1 user. Follow the
user for the schema.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/fsl,sec-v4.0.yaml         |  10 +-
 .../devicetree/bindings/crypto/fsl-sec6.txt   | 157 ------------------
 2 files changed, 9 insertions(+), 158 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec6.txt

diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
index f0c4a7c83568..75afa441e019 100644
--- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
@@ -38,7 +38,9 @@ properties:
   compatible:
     oneOf:
       - items:
-          - const: fsl,sec-v5.4
+          - enum:
+              - fsl,sec-v5.4
+              - fsl,sec-v6.0
           - const: fsl,sec-v5.0
           - const: fsl,sec-v4.0
       - items:
@@ -93,6 +95,12 @@ patternProperties:
     properties:
       compatible:
         oneOf:
+          - items:
+              - const: fsl,sec-v6.0-job-ring
+              - const: fsl,sec-v5.2-job-ring
+              - const: fsl,sec-v5.0-job-ring
+              - const: fsl,sec-v4.4-job-ring
+              - const: fsl,sec-v4.0-job-ring
           - items:
               - const: fsl,sec-v5.4-job-ring
               - const: fsl,sec-v5.0-job-ring
diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec6.txt b/Documentation/devicetree/bindings/crypto/fsl-sec6.txt
deleted file mode 100644
index 73b0eb950bb3..000000000000
--- a/Documentation/devicetree/bindings/crypto/fsl-sec6.txt
+++ /dev/null
@@ -1,157 +0,0 @@
-SEC 6 is as Freescale's Cryptographic Accelerator and Assurance Module (CAAM).
-Currently Freescale powerpc chip C29X is embedded with SEC 6.
-SEC 6 device tree binding include:
-   -SEC 6 Node
-   -Job Ring Node
-   -Full Example
-
-=====================================================================
-SEC 6 Node
-
-Description
-
-    Node defines the base address of the SEC 6 block.
-    This block specifies the address range of all global
-    configuration registers for the SEC 6 block.
-    For example, In C293, we could see three SEC 6 node.
-
-PROPERTIES
-
-   - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,sec-v6.0".
-
-   - fsl,sec-era
-      Usage: optional
-      Value type: <u32>
-      Definition: A standard property. Define the 'ERA' of the SEC
-          device.
-
-   - #address-cells
-       Usage: required
-       Value type: <u32>
-       Definition: A standard property.  Defines the number of cells
-           for representing physical addresses in child nodes.
-
-   - #size-cells
-       Usage: required
-       Value type: <u32>
-       Definition: A standard property.  Defines the number of cells
-           for representing the size of physical addresses in
-           child nodes.
-
-   - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: A standard property.  Specifies the physical
-          address and length of the SEC 6 configuration registers.
-
-   - ranges
-       Usage: required
-       Value type: <prop-encoded-array>
-       Definition: A standard property.  Specifies the physical address
-           range of the SEC 6.0 register space (-SNVS not included).  A
-           triplet that includes the child address, parent address, &
-           length.
-
-   Note: All other standard properties (see the Devicetree Specification)
-   are allowed but are optional.
-
-EXAMPLE
-	crypto@a0000 {
-		compatible = "fsl,sec-v6.0";
-		fsl,sec-era = <6>;
-		#address-cells = <1>;
-		#size-cells = <1>;
-		reg = <0xa0000 0x20000>;
-		ranges = <0 0xa0000 0x20000>;
-	};
-
-=====================================================================
-Job Ring (JR) Node
-
-    Child of the crypto node defines data processing interface to SEC 6
-    across the peripheral bus for purposes of processing
-    cryptographic descriptors. The specified address
-    range can be made visible to one (or more) cores.
-    The interrupt defined for this node is controlled within
-    the address range of this node.
-
-  - compatible
-      Usage: required
-      Value type: <string>
-      Definition: Must include "fsl,sec-v6.0-job-ring".
-
-  - reg
-      Usage: required
-      Value type: <prop-encoded-array>
-      Definition: Specifies a two JR parameters:  an offset from
-           the parent physical address and the length the JR registers.
-
-   - interrupts
-      Usage: required
-      Value type: <prop_encoded-array>
-      Definition:  Specifies the interrupts generated by this
-           device.  The value of the interrupts property
-           consists of one interrupt specifier. The format
-           of the specifier is defined by the binding document
-           describing the node's interrupt parent.
-
-EXAMPLE
-	jr@1000 {
-		compatible = "fsl,sec-v6.0-job-ring";
-		reg = <0x1000 0x1000>;
-		interrupts = <49 2 0 0>;
-	};
-
-===================================================================
-Full Example
-
-Since some chips may contain more than one SEC, the dtsi contains
-only the node contents, not the node itself.  A chip using the SEC
-should include the dtsi inside each SEC node.  Example:
-
-In qoriq-sec6.0.dtsi:
-
-	compatible = "fsl,sec-v6.0";
-	fsl,sec-era = <6>;
-	#address-cells = <1>;
-	#size-cells = <1>;
-
-	jr@1000 {
-		compatible = "fsl,sec-v6.0-job-ring",
-			     "fsl,sec-v5.2-job-ring",
-			     "fsl,sec-v5.0-job-ring",
-			     "fsl,sec-v4.4-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg	   = <0x1000 0x1000>;
-	};
-
-	jr@2000 {
-		compatible = "fsl,sec-v6.0-job-ring",
-			     "fsl,sec-v5.2-job-ring",
-			     "fsl,sec-v5.0-job-ring",
-			     "fsl,sec-v4.4-job-ring",
-			     "fsl,sec-v4.0-job-ring";
-		reg	   = <0x2000 0x1000>;
-	};
-
-In the C293 device tree, we add the include of public property:
-
-	crypto@a0000 {
-		/include/ "qoriq-sec6.0.dtsi"
-	}
-
-	crypto@a0000 {
-		reg = <0xa0000 0x20000>;
-		ranges = <0 0xa0000 0x20000>;
-
-		jr@1000 {
-			interrupts = <49 2 0 0>;
-		};
-
-		jr@2000 {
-			interrupts = <50 2 0 0>;
-		};
-	};
-- 
2.47.2

