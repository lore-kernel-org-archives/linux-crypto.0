Received: from mx08-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A01F76A7;
	Tue, 15 Oct 2024 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011089; cv=none; b=TcO7/8bCH052onT31Q/MY3Gsi2jZTclPrhGZ/xh98gzfxFzHz2EWKEnaJmq2LYNmnaGDdFrJikNDK7HqxahOP+ET3Ef/wWI6srK+cweA0y08j7kx++RzteNeg5IiyBBOpLgSyUFMC+jA1koR4SXNRHh/CPUexOa4pHH9QUpxmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011089; c=relaxed/simple;
	bh=v/6QeGCB9KEaqSkCY1r/Pc+QxcKll8D+vZd4LNxx9yg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=J5lPthuX2+0F1A6WiiF8IHwxZak/6hxbUN4F+VRFW/GAhtfNrq9wNaJUwml4ercSB1+GQ595pVUVhQFM3t6LpFuST8sXub4/vIGyjUOfsAhepmlfAiLhKwTss8MGaqHzkuCN9SHmVVPVtPHZZwxY8pPvuK0eazMGV9HKIPzmX8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=z5OS20Yq; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="z5OS20Yq"
Received: from pps.filterd (m0369457.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FBoALZ018119;
	Tue, 15 Oct 2024 18:51:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	E4C9Hy/+YaVX/UGRCUHNNcIJnfflKscYbkbUCSAIS7c=; b=z5OS20YqO//rZanB
	vjEl6MBZBJloueKwdrncV1mwRCVWUGzLIWnd4qbjX0CQQlvVH6iYsx/OcJVXF7WQ
	vAqVoLvHoSFOEwVqUMzxbYWzdDznbDnfsHBXKsuccFkeT58H0Wm3Gl5w55sy76SZ
	xCiOr2Rqa3OEXmlsMAU7XWIkkbLjWAn1gx6ZlpWrRd3OwCVqxTegQpblHy0Af/Y1
	3JCOYv/6iTj59Hgm26sb1BCbRDOyrSKw+f6g2Bd1j1ocfCV+F+fT/wYx7i9HW1Us
	okK9SqmXSm95A+1UVucASM28KjriyVXYVrc5cT8VfVuqV2VwT2l8K/5JX6in2dIH
	0Zz3Cg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 42842jbhvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 18:51:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id DDDA240045;
	Tue, 15 Oct 2024 18:49:48 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7E45F220F55;
	Tue, 15 Oct 2024 18:48:58 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Tue, 15 Oct
 2024 18:48:58 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Tue, 15 Oct 2024 18:48:54 +0200
Subject: [PATCH v3 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241015-rng-mp25-v2-v3-1-87630d73e5eb@foss.st.com>
References: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
In-Reply-To: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof
 Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime
 Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue
	<alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>, <marex@denx.de>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>
X-Mailer: b4 0.14.2
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Add RNG STM32MP25x platforms compatible. Update the clock
properties management to support all versions.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
Changes in V3:
	- Add constraint on clock-names for st,stm32mp25-rng compatible

Changes in V2
	-Fix missing min/maxItems
	-Removed MP25 RNG example
	-Renamed RNG clocks for mp25 to "core" and "bus"
---
 .../devicetree/bindings/rng/st,stm32-rng.yaml      | 34 +++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 340d01d481d12ce8664a60db42182ddaf0d1385b..c276723d566ce4a0d6deca10c491510644d842f8 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -18,12 +18,20 @@ properties:
     enum:
       - st,stm32-rng
       - st,stm32mp13-rng
+      - st,stm32mp25-rng
 
   reg:
     maxItems: 1
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: bus
 
   resets:
     maxItems: 1
@@ -57,6 +65,30 @@ allOf:
       properties:
         st,rng-lock-conf: false
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - st,stm32-rng
+              - st,stm32mp13-rng
+    then:
+      properties:
+        clocks:
+          maxItems: 1
+        clock-names: false
+    else:
+      properties:
+        clocks:
+          minItems: 2
+          maxItems: 2
+        clock-names:
+          items:
+            - const: core
+            - const: bus
+      required:
+        - clock-names
+
 additionalProperties: false
 
 examples:

-- 
2.25.1

