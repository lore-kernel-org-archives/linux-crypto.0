Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003F81F669D;
	Tue, 15 Oct 2024 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011088; cv=none; b=PnMrJr7+IdPJ0jHbuzklQ79DLAOhjSk+mykbd+ooCdQ4J5EG1VDxXooz6El3i+X4CMu3scTOtSOd0o5wpxcHJc/ZXUrMbNjVFPTVaxeXo5Zs1HpfFa6dRJ0gPTf4XQq04fLV44GaJ1uEzBkyKN3CZ/wK6f7zFFtkWapqm2SEUP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011088; c=relaxed/simple;
	bh=JryX6b3LVldHmvTQJWdxsA1RA8IMwc+do66RZno+uk0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=ZbFf9gHW44MsIFdHh62SrD7G+o00hD9TnvLV0NtfH8GyNYSDly4bi2YJYD7ceGDAh0YMNO7IpsBu6xM89g66SkFBWTV/0ys0a4Uk49vpwmykJWjb9Hbk9c+N8dDysRzYbLeYUUWW3nuJubacR4Wsy2+lzvZ8ql/akiowGl3+bC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=FUNz7yL7; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="FUNz7yL7"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FCDp8w021367;
	Tue, 15 Oct 2024 18:51:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=selector1; bh=T93sAc/spARN1FDC+Kwa2t
	Z2jrQAQ6WiRfZ/tiID6UU=; b=FUNz7yL7poJsAnRc3ffMBjXHn3pWBmH/jCABMo
	sXbtulDn23XeCT5m2cgtI0jxVjsfpkDNK0pgdPzky5fIhzhhVpXAZbyXExoGPug+
	XhKB5NZYBzbPXX26oul1bdqBK/3JpDXhAnPJXoZBw0KoJnKPjteF/bkyL2zBTXzk
	sEJTA3pI3PoIIhmTprzv1AW5ZDqzN5HwW9cZDSUeBbtNtjBhcVYWYAoZuWnq+E7E
	DdOzgGSLJo+eWXfcc64ssFbMJx1rd5CAb6/6iXbL+LLb9kIttFtvQI8+BHnXRJT2
	L0xzCEaDnhmRovXT5uYBJjyvwvZEWLuIflKQI4y5JOgSfk9Q==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 427g0bp7se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 18:51:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1F3C340069;
	Tue, 15 Oct 2024 18:49:45 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C8840220B59;
	Tue, 15 Oct 2024 18:48:57 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Tue, 15 Oct
 2024 18:48:57 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Subject: [PATCH v3 0/4] Add support for stm32mp25x RNG
Date: Tue, 15 Oct 2024 18:48:53 +0200
Message-ID: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPWcDmcC/22MQQ6CMBBFr0JmbclMxWJceQ/DQssUuqAlHdJoS
 O9uZW3yN+8n7+0gnDwL3JodEmcvPoYK51MDdn6GiZUfK4NG3RESqRQmtaz6orJWL9MZZEfE5KA
 aa2Ln30ftMVSevWwxfY541r/3f6cOVW/caKhHfUV7d1Gkla21cYGhlPIFyem/jqgAAAA=
X-Change-ID: 20241011-rng-mp25-v2-b6460ef11e1f
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

This patchset adds support for the Random Number
Generator(RNG) present on the stm32mp25x platforms.
On these platforms, the clock management and the RNG
parameters are different.

While there, update the RNG max clock frequency on
stm32mp15 platforms according to the latest specs.

Tested on the stm32mp257f-ev1 platform with a deep
power sequence with rngtest before/after the sequence with
satisfying results.

Same was done on stm32mp135f-dk to make sure no regression was added.

On stm32mp157c-dk2, I didn't perform a power sequence but the rngtest
results were satisfying.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
Changes in v3:
- Add restriction on clock-names some compatibles
- Use clk_bulk APIs in the RNG driver to avoid manually handling clocks.
- Link to v2: https://lore.kernel.org/r/20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com

Changes in V2:
	-Fixes in bindings
	-Removed MP25 RNG example
	-Renamed RNG clocks for mp25 to "core" and "bus"

---
Gatien Chevallier (4):
      dt-bindings: rng: add st,stm32mp25-rng support
      hwrng: stm32 - implement support for STM32MP25x platforms
      hwrng: stm32 - update STM32MP15 RNG max clock frequency
      arm64: dts: st: add RNG node on stm32mp251

 .../devicetree/bindings/rng/st,stm32-rng.yaml      | 34 +++++++++-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             | 10 +++
 drivers/char/hw_random/stm32-rng.c                 | 76 ++++++++++++++++------
 3 files changed, 100 insertions(+), 20 deletions(-)
---
base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
change-id: 20241011-rng-mp25-v2-b6460ef11e1f

Best regards,
-- 
Gatien Chevallier <gatien.chevallier@foss.st.com>

