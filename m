Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9541B9831;
	Mon,  7 Oct 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728307971; cv=none; b=c8eKfzQfULM6D4vpp9swrnB/dVCE55DghkgDj0Byxt5g7tM278iiqqOMJDcn/91y2eb1QlOo8Jv4wvWKqTqUeThDAK4TvoIEyL5menvNZvMnlsCCgpZHCEZPQh1p9oOUTqDLYQJSU8yPgYuafBIafFO29MaMk+bGYRzlM/8j1Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728307971; c=relaxed/simple;
	bh=KoXBc4t3bg4UfivhjTYJkdHDpgUtKaI0eYpbucFFwrY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqV+DgL7cjIzJzS1RyT7x9HL8xmyYFDT/5HpdJ9bASA8V5mZJlpoJtpLlUzhOasjLFoqWLTizpvQihXyjPdClyDOrs4uU1Z4hkIVcdsiPLdeFjGiXWViZQ8WwYrNaOXHIdjG7rQGIZ+0aAOPPdN033cuhLRTjKfWQmq8fLndNXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=dBsatN6y; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="dBsatN6y"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497B4G5b021715;
	Mon, 7 Oct 2024 15:32:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	Kb/Wv4RQ9boMDu8e4FgyKdarjG40Bi/qBXrF2ODld5E=; b=dBsatN6yjAkVg+uC
	enJ5nDH/TG9y4/QizZ/vCg4mIWhDfmxOqQ9R/gapsLMNFWla8t80cck+RHqogTQZ
	QYsiurOdR63xCB8FpftVy/JrOA+JKNxCMBcWCyfnaVWQguQOC4EjBf9sMvm//UW7
	rxw0IxuLDBWToP3+bZKg6RqlCPkc6DI6GbETwpGEihCEsyu8oVn3g1xmwtnpHlNq
	rGaQLpDnhBGKMidXFycC24GMXdXTOqSZWbdFYea1ec3NMSCKgVcDF0moeHkq0usz
	ncm5s7iNRBtGI/wUoJtULxjhSg7mqt8u5jGKdH1mcJCafY+6NRyAxpXsTxsZA76T
	bkdvyA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 423f10pdkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 15:32:14 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id AEDD44004B;
	Mon,  7 Oct 2024 15:30:37 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 3C338279E8C;
	Mon,  7 Oct 2024 15:27:46 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 15:27:45 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley
	<conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>
CC: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yang
 Yingliang <yangyingliang@huawei.com>,
        Gatien Chevallier
	<gatien.chevallier@foss.st.com>
Subject: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
Date: Mon, 7 Oct 2024 15:27:18 +0200
Message-ID: <20241007132721.168428-2-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

Add RNG STM32MP25x platforms compatible. Update the clock
properties management to support all versions.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
 .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 +++++++++++++++++--
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 340d01d481d1..c92ce92b6ac9 100644
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
+      - const: rng_clk
+      - const: rng_hclk
 
   resets:
     maxItems: 1
@@ -57,15 +64,43 @@ allOf:
       properties:
         st,rng-lock-conf: false
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - st,stm32mp25-rng
+    then:
+      properties:
+        clocks:
+          description: >
+            RNG bus clock must be named "rng_hclk". The RNG kernel clock
+            must be named "rng_clk".
+          maxItems: 2
+      required:
+        - clock-names
+    else:
+      properties:
+        clocks:
+          maxItems: 1
+
 additionalProperties: false
 
 examples:
   - |
-    #include <dt-bindings/clock/stm32mp1-clks.h>
     rng@54003000 {
       compatible = "st,stm32-rng";
       reg = <0x54003000 0x400>;
-      clocks = <&rcc RNG1_K>;
+      clocks = <&rcc 124>;
     };
 
+  - |
+    rng: rng@42020000 {
+      compatible = "st,stm32mp25-rng";
+      reg = <0x42020000 0x400>;
+      clocks = <&clk_rcbsec>, <&rcc 110>;
+      clock-names = "rng_clk", "rng_hclk";
+      resets = <&rcc 97>;
+      access-controllers = <&rifsc 92>;
+    };
 ...
-- 
2.25.1

