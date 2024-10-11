Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D51991C9;
	Fri, 11 Oct 2024 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728661682; cv=none; b=MFDO1x3OTSE6Y9fcilXB9vYQEDxxuvei1r888EpsVBIXyqawYjxuhMn9v4icmjSN9ptxVEbeBm/NQ3qn4zu3AZLZ7qBi7z6vrXprTZUjpK1lnEOShK1lC0Upww6lJIXa01pKTLmgBRXIFke6fjifBRwZGaWwoWWsxe+0FoMxXl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728661682; c=relaxed/simple;
	bh=yLqmVhSHfqTQBGze9c6HZjg8/DSXw+/10tUzsQ8jcYg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=Bxt3JcOOPyeGPl3Mguvvi4WztGVTWyYjvhDF9wrYsmdUXMBpJ5NssnDAi5iWi4P+16/tskm6RmCTTdqJ4mklPHuoAuWTcQ64/hdlfN9y922Q4B/+o6eDpTso8FvXC1LBeI4CVDgcxVMI3UMX/Comz059flHNTlNlmvvVAZ2nIZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=Hc2MNPNh; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="Hc2MNPNh"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCRMtM031378;
	Fri, 11 Oct 2024 17:47:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	UmHwzMEjgGYMyzKc5Pjv1VczBa5oeGehyd30tiANaqM=; b=Hc2MNPNhnu7Qxf9u
	7nDrRYTVpVx0FdR1wYIUoyu3+7LXy0K4T8SpcjpObNX9d02j0lMzvQdoV+KmtcZ7
	7MIp/uyb6oUhwNifuhS23+Xy5KG4ZJ9p+48Qr/IlskCqXKXweqvI22Rtu7pk6xMe
	dn463ACaMnix/EloPXV7fEy1IERJ5A7NZQGa1DdgahhQsEu9uRnCxO7RTP5pJZqi
	4x+0Z9hot4eiTFZgJ1o17ftin6Kcwbzay4tO2WGTB/N5NTcMRsWY7VjOBHyM5qrp
	nAPKtr946ndc781m59Y16emtSKiemVfRNRADDeNGFKFjWAFnrXN7hOO3av9UGPUo
	Siaxyg==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 425q5wd33a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 17:47:30 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id AB43C4005E;
	Fri, 11 Oct 2024 17:46:15 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C3F0D29E024;
	Fri, 11 Oct 2024 17:43:15 +0200 (CEST)
Received: from localhost (10.252.28.117) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 17:43:15 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Fri, 11 Oct 2024 17:41:41 +0200
Subject: [PATCH v2 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241011-rng-mp25-v2-v2-1-76fd6170280c@foss.st.com>
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
In-Reply-To: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
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
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Add RNG STM32MP25x platforms compatible. Update the clock
properties management to support all versions.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
Changes in V2
	-Fix missing min/maxItems
	-Removed MP25 RNG example
	-Renamed RNG clocks for mp25 to "core" and "bus"
---
 .../devicetree/bindings/rng/st,stm32-rng.yaml      | 30 +++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 340d01d481d12ce8664a60db42182ddaf0d1385b..5d553f7f706f8d7c17aea07e4130a34af764a635 100644
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
@@ -57,6 +65,26 @@ allOf:
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
+      required:
+        - clock-names
+
 additionalProperties: false
 
 examples:

-- 
2.25.1

