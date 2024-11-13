Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A00189BBD;
	Wed, 13 Nov 2024 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731538588; cv=none; b=MsO4ZzynT9NQ1jRzAWbpUkwNijnsCZqC+qv8zASh+ThFRgwKiYl1iCjapwDNIZFh4DcyobjZa54kfYAxAZjg5xZnMeShpRY8hGoZmjLrOKJaqz14fYsEHACA6DGG7rILT7mid7wc1xnhWGt5dkoksw/Y/iGuDxLrO6poVcBb1Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731538588; c=relaxed/simple;
	bh=ppARoxV/BKuqM26l7GbAb1n0J5UopQIlgnjP2VYDPIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W74hEm/SWOUfefp+dBX+z3bFaqK7GKRFSTL8ucbUk7TkoLznqto5YcVzNzR1dJYFMoAb3TpBdeC0fyzOg9mztKOUlfb8LuiI2PJizQzFhFWf/mStVMRs6ajk9HJ13Wyk41MSnEitUdqf8lVr7BxBt7uiDYQVaY+TejNpCNfHm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyNmEpTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyNmEpTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD47C4CEC3;
	Wed, 13 Nov 2024 22:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731538588;
	bh=ppARoxV/BKuqM26l7GbAb1n0J5UopQIlgnjP2VYDPIc=;
	h=From:To:Cc:Subject:Date:From;
	b=nyNmEpTj99rigb0YjXknMOHR8svcWnsRjs1FchKtnDLUt6QDByAdr85hMX6/0npKq
	 HdVtlOxC211m6YH3DbKs888Vqt2bd39uSqkG8Kai1NdMMYbDXGSHzcrPOEKM3bs3eE
	 3n7UPexzl3tFD6lJBH2EK9Z7UyqSt0Qc7504Jd3aUWsCJsSILSOVHEeChrUp7WV4pv
	 +jO45a0vJ2q2pDXynL0BaJhaHrMoiDcAvmRhZt7NefwnZi+hqDBBWt+n8en4Yxi2eu
	 TyoCmNo3EdFVy7g7mz1nmZU762ku2DsIF69s3uHm6dJyRYkmYptg4U+NFSRpHoJDKL
	 +3cKBbPlJc2mw==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Frank Li <Frank.Li@nxp.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dt-bindings: Unify "fsl,liodn" type definitions
Date: Wed, 13 Nov 2024 16:56:13 -0600
Message-ID: <20241113225614.1782862-1-robh@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The type definition of "fsl,liodn" is defined as uint32 in
crypto/fsl,sec-v4.0.yaml and uint32-array in soc/fsl/fsl,bman.yaml,
soc/fsl/fsl,qman-portal.yaml, and soc/fsl/fsl,qman.yaml. Unify the type to
be uint32-array and constraint the single entry cases.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/fsl,sec-v4.0.yaml       | 10 ++++++----
 .../devicetree/bindings/soc/fsl/fsl,qman-portal.yaml   |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
index 9c8c9991f29a..f0c4a7c83568 100644
--- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
@@ -114,8 +114,9 @@ patternProperties:
           table that specifies the PPID to LIODN mapping. Needed if the PAMU is
           used.  Value is a 12 bit value where value is a LIODN ID for this JR.
           This property is normally set by boot firmware.
-        $ref: /schemas/types.yaml#/definitions/uint32
-        maximum: 0xfff
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        items:
+          - maximum: 0xfff
 
   '^rtic@[0-9a-f]+$':
     type: object
@@ -186,8 +187,9 @@ patternProperties:
               Needed if the PAMU is used.  Value is a 12 bit value where value
               is a LIODN ID for this JR. This property is normally set by boot
               firmware.
-            $ref: /schemas/types.yaml#/definitions/uint32
-            maximum: 0xfff
+            $ref: /schemas/types.yaml#/definitions/uint32-array
+            items:
+              - maximum: 0xfff
 
           fsl,rtic-region:
             description:
diff --git a/Documentation/devicetree/bindings/soc/fsl/fsl,qman-portal.yaml b/Documentation/devicetree/bindings/soc/fsl/fsl,qman-portal.yaml
index 17016184143f..e459fec02ba8 100644
--- a/Documentation/devicetree/bindings/soc/fsl/fsl,qman-portal.yaml
+++ b/Documentation/devicetree/bindings/soc/fsl/fsl,qman-portal.yaml
@@ -35,6 +35,7 @@ properties:
 
   fsl,liodn:
     $ref: /schemas/types.yaml#/definitions/uint32-array
+    maxItems: 2
     description: See pamu.txt. Two LIODN(s). DQRR LIODN (DLIODN) and Frame LIODN
       (FLIODN)
 
@@ -69,6 +70,7 @@ patternProperties:
     type: object
     properties:
       fsl,liodn:
+        $ref: /schemas/types.yaml#/definitions/uint32-array
         description: See pamu.txt, PAMU property used for static LIODN assignment
 
       fsl,iommu-parent:
-- 
2.45.2

