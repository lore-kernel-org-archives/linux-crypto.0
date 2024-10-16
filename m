Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B821D27B7;
	Wed, 16 Oct 2024 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066008; cv=none; b=pVuqHAVPzTDLtVUUWOWf7VoorpOYnqEPc6BZK5FU+jIrDD2ciSIWbZgflOvbo63r6mqpXsNCu+7O7lU5u6R9k+BgSo2cZF8G2EkFMHrAw0yTBBLEWO0w6UZicZTmZLEk5yVNyPHKaGDLUcowfA8Q7Sif2dgsBsnXLbC5rIKdmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066008; c=relaxed/simple;
	bh=ClFwqko2ceVIAX+sK8Vlz5k7zAuyGHrDL8DnwHmeI00=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=PDHw2TiK2jXtD8y7vT0mSKv7wI/mBrne5vP4JrlgH14whBolxMgiQR+S4+9h/EQyoUXib6JNASHBYMGNgPLitd0qn5cIE0supFIDv33a8PWwSm/RA2M1HAd+1s4Rtfv0RlCgtItWRMcs4oakH3v4Ot2bBNMgpCDhpQLknqOd2e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=mQeKyna6; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="mQeKyna6"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G6sjRV018447;
	Wed, 16 Oct 2024 10:06:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	yqoe5xAomf7D/YUG6xkzdLNqV/te8d+Mhnck8LtooPk=; b=mQeKyna6V5hkpT1h
	q4A2QHJTCut0kZq76aBtGOCidtQfFeBQ9BAJWvxC4Zy75BmmlM+u1CfL83rPTnSN
	qKcn8OXlhXQcddMflDJ9AdMZiy8Fw6uDrFm8gyoysfwyFC9Q+//4VTJxZd4rkTcl
	5ggcZ6jBRBvEgLlfqBByqR+vtYY5Co4XNUZIq4t3ZtnHjojkGX+Ub34bNQndTPjr
	NTUa5hqQBQBbYV1amvkNtE5tMw+A1LhDtW9tmcRYrn2t5E+KlxTbiXdJXentDJsZ
	QNzufXznJpCbBOPRTH0o0WbS2EJZJnVwu54kr8dscD7UCu/sbmCEpqftHRMMYoA2
	nC9Q2g==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 42a8mv8c9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:06:26 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 370F540046;
	Wed, 16 Oct 2024 10:05:17 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id D66E423CB4B;
	Wed, 16 Oct 2024 10:04:32 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Wed, 16 Oct
 2024 10:04:32 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Wed, 16 Oct 2024 10:04:18 +0200
Subject: [PATCH v4 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241016-rng-mp25-v2-v4-1-5dca590cb092@foss.st.com>
References: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
In-Reply-To: <20241016-rng-mp25-v2-v4-0-5dca590cb092@foss.st.com>
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
Changes in V4:
	- Changed the restrictions on clock-names per compatible
	- Removed a useless constraint on clocks Items

Changes in V3:
	- Add constraint on clock-names for st,stm32mp25-rng compatible

Changes in V2
	-Fix missing min/maxItems
	-Removed MP25 RNG example
	-Renamed RNG clocks for mp25 to "core" and "bus"
---
 .../devicetree/bindings/rng/st,stm32-rng.yaml      | 28 +++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 340d01d481d12ce8664a60db42182ddaf0d1385b..7db65f49773b5b9b1b6193fec495c752327a149a 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -18,12 +18,19 @@ properties:
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
+    items:
+      - const: core
+      - const: bus
 
   resets:
     maxItems: 1
@@ -57,6 +64,25 @@ allOf:
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
+      required:
+        - clock-names
+
 additionalProperties: false
 
 examples:

-- 
2.25.1

