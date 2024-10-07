Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9B41D27A5;
	Mon,  7 Oct 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728307971; cv=none; b=Htx/7iqf2NDUyaN0vtnatavmchAoKpTFBem6NwzF198VGm7k8k0Hfm/aQvBVWVROGh194/div+WY/bichG4PSDpTYNrdJCEJYtAlTn946336NfW2L/ROWLS2fCLoeje9qCkdygnB4RdDnsdSKAnrWMhXOyqCIv6iv1fNkmEBKy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728307971; c=relaxed/simple;
	bh=uNE635MurB0pF4mfKSEeqVoO1HzSWyf/+Ne4tUmOmCY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n3OCMUXmHXj1bkiHByAFo3+FUkth8bqO6Nyjk2zfUYJ1X5/akeoJMeSF0qY1vVXJQrd/kMevXhc1Px/OhMj/5KA5JXST+FImKMweAaUf58j7guzXijQbYfuitZxkVsFQ/+9c0HTy+sJRN7ABl9vQiedtBGmXYk2/ILaNGR88gdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=FQYoFP41; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="FQYoFP41"
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 497CkqjW013725;
	Mon, 7 Oct 2024 15:32:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=selector1; bh=0Uy4D/ioMUiMzIiIOi6IbE
	9dbO4iOUOot3KiGq4Gkrk=; b=FQYoFP41RtoIJO90BLw2X/Grf321yhfVuPrZTl
	cHp0TUNwE9zJYVsJ5oStKFPUGTSCDijVj1Ayt07KLKoZspChvZL6Kjv1IQA86oX2
	79dkxzFDu+//TCgJK4KoDQLr6aL6yvfOkHkRk5DrbWexAqs41/VjQZxe+zqdJQS9
	nPJiwVT1cEv8Bm9qmCXVcTpw0dElnibnWLPSog9ujhNgjpV1UzPG7tqNDJHh7QLs
	JgIew7YTxpO42uye0pZbjtOyy02yXOqTKDjsMA3A4JRaUtVZP/v5w1GaDMbW6v2Z
	UUW6ZqysHBUlVFt8v9RFjC0DI8+mVQqoiEWondGsSeiZ0mCA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 422xs194nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 15:32:17 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id AED624004A;
	Mon,  7 Oct 2024 15:30:38 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7B74C279E77;
	Mon,  7 Oct 2024 15:27:45 +0200 (CEST)
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
Subject: [PATCH 0/4] Add support for stm32mp25x RNG
Date: Mon, 7 Oct 2024 15:27:17 +0200
Message-ID: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.25.1
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

Gatien Chevallier (4):
  dt-bindings: rng: add st,stm32mp25-rng support
  hwrng: stm32 - implement support for STM32MP25x platforms
  hwrng: stm32 - update STM32MP15 RNG max clock frequency
  arm64: dts: st: add RNG node on stm32mp251

 .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 ++++++++-
 arch/arm64/boot/dts/st/stm32mp251.dtsi        | 10 +++
 drivers/char/hw_random/stm32-rng.c            | 83 +++++++++++++++++--
 3 files changed, 126 insertions(+), 8 deletions(-)

-- 
2.25.1

