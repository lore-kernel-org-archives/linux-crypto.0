Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A504724503C;
	Thu,  5 Jun 2025 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749130099; cv=none; b=Y8W/QyFHdN9jHvTR4m4z3/Ym0QrDi2FWCGNqXjk/ZCVMQU3v6tyNPr+BUcvbLkjUf01I1rNA9HoqzL6kfa56eH7T9C/aAeiIRuJnhRHMzCq8yDtl+2oeT2ZzVL8tUDeW+B+otbyLuiLAKHtFEqDYQyx9sj3qIXqCy9T1IdO+RZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749130099; c=relaxed/simple;
	bh=cMf4IvswtrJysRpI222aZBga78g0ROKP/Nd036IwvDE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CvRGEfIy39uqem9BTExlCArflHrjdAypxxUHyxpqnYBeDIcVKjcMEXFb7y8a17fT8FQh1buepJdiaMEJ0HyDdAdkfxLJPKdMD3DYvxqOv1d4TzA6tqP2XIEe9FZ1zFHHAzMjs1hV2JOCk16K2WsLgZX7eidyThkDMePBlMK0Thc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 5 Jun
 2025 15:28:02 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Thu, 5 Jun 2025 15:28:02 +0200
From: John Ernberg <john.ernberg@actia.se>
To: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>
CC: Frank Li <Frank.li@nxp.com>, Pengutronix Kernel Team
	<kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, John Ernberg <john.ernberg@actia.se>
Subject: [PATCH v4 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power domains
 for iMX8QM and iMX8QXP
Thread-Topic: [PATCH v4 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Thread-Index: AQHb1h2p186darlQmUK22qpyzH8BCg==
Date: Thu, 5 Jun 2025 13:28:02 +0000
Message-ID: <20250605132754.1771368-4-john.ernberg@actia.se>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
In-Reply-To: <20250605132754.1771368-1-john.ernberg@actia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.49.0
x-esetresult: clean, is OK
x-esetid: 37303A2956B1445363726A
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
resource management.

Add compatible strings for these SoCs (QXP and DXP gets to share as their
only difference is a core-count, Q=3DQuad core and D=3DDual core), and allo=
w
power-domains for them only. Keep the old restriction for others.

Signed-off-by: John Ernberg <john.ernberg@actia.se>

---

v4:
 - Reword commit message (Frank Li)
 - Add explicit imx8qxp compatible (Frank Li)
 - Move the job-ring constraints back to the job-ring section under an
   'allOf:' to avoid the warning from v2 (Rob Herring)

v3:
 - Fix warnings discovered by Rob Herring's bot
 - Declare the compatibles correctly (Krzysztof Kozlowski)

v2:
 - Adjust commit message (Frank Li)
 - Only allow power-domains when compatible with imx8qm (Frank Li)
---
 .../bindings/crypto/fsl,sec-v4.0.yaml         | 41 ++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/D=
ocumentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
index 75afa441e019..eab43e7a354c 100644
--- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
@@ -46,6 +46,8 @@ properties:
       - items:
           - enum:
               - fsl,imx6ul-caam
+              - fsl,imx8qm-caam
+              - fsl,imx8qxp-caam
               - fsl,sec-v5.0
           - const: fsl,sec-v4.0
       - const: fsl,sec-v4.0
@@ -77,6 +79,9 @@ properties:
   interrupts:
     maxItems: 1
=20
+  power-domains:
+    maxItems: 1
+
   fsl,sec-era:
     description: Defines the 'ERA' of the SEC device.
     $ref: /schemas/types.yaml#/definitions/uint32
@@ -106,7 +111,10 @@ patternProperties:
               - const: fsl,sec-v5.0-job-ring
               - const: fsl,sec-v4.0-job-ring
           - items:
-              - const: fsl,sec-v5.0-job-ring
+              - enum:
+                - fsl,imx8qm-job-ring
+                - fsl,imx8qxp-job-ring
+                - fsl,sec-v5.0-job-ring
               - const: fsl,sec-v4.0-job-ring
           - const: fsl,sec-v4.0-job-ring
=20
@@ -116,6 +124,9 @@ patternProperties:
       interrupts:
         maxItems: 1
=20
+      power-domains:
+        maxItems: 1
+
       fsl,liodn:
         description:
           Specifies the LIODN to be used in conjunction with the ppid-to-l=
iodn
@@ -125,6 +136,20 @@ patternProperties:
         $ref: /schemas/types.yaml#/definitions/uint32-array
         items:
           - maximum: 0xfff
+    allOf:
+      - if:
+          properties:
+            compatible:
+              contains:
+                enum:
+                  - fsl,imx8qm-job-ring
+                  - fsl,imx8qxp-job-ring
+        then:
+          required:
+            - power-domains
+        else:
+          properties:
+            power-domains: false
=20
   '^rtic@[0-9a-f]+$':
     type: object
@@ -212,6 +237,20 @@ required:
   - reg
   - ranges
=20
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - fsl,imx8qm-caam
+          - fsl,imx8qxp-caam
+then:
+  required:
+    - power-domains
+else:
+  properties:
+    power-domains: false
+
 additionalProperties: false
=20
 examples:
--=20
2.49.0
