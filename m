Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506B61D26E0;
	Wed, 16 Oct 2024 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729066009; cv=none; b=EtSXiOLSgIG43lr36kOwMAIzQUVVKZ7xLW0iT1GoMcV8pAZs7HAjwDskfANU2/wMp5qG/AAra+XONmH/xd6R+KaG4EYg1+6RQeuOii5uMl5hBRrHsypyyK1+CQY1mkAkhLbp7LrjvU8p44xWA6B3gX+G8wl9YcEq7S7Waetfy+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729066009; c=relaxed/simple;
	bh=I4iWyFgFIpIpyNQzJqLRDERhYBCEmkQ41tqVFqd2kk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=iQWoBq7zEdUMMPF6Wyi+Iqub5V7JY75oZA/2TTRqXcgmgY1+7OudA4B8jOY71EhRzZ3sXeYfTQo3EuSTl6fa/GtQJE+llSRvEaASEBADnpRkn8Fv1A7CBuqeJo1C8/Y0/e64Q4TBEgAKruXBMTOvE+rl5WtI6Ewhpj54frfKBRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=tY+4DGXF; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="tY+4DGXF"
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G3SgLE011399;
	Wed, 16 Oct 2024 10:06:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	QYf7I5bZM+g/zbxxwONC8wmKlEdNvZg+vARUi+5HicI=; b=tY+4DGXFGVQN7z+3
	7G/HdKmFOCq1mtJoKRlPdY5CyHRprLFsgcWUirLNBnKEb1lLdG+vBNrclGsNdlhh
	4/Q1DGod6MtC5unDD3bYONam8k8PeAtCvQRhSTRUjorN4uBkWUtXrHz59tCnlU0A
	IU2VrNsS95CoeVdVdhrnHD3Zo0JpPcA72bXoGGjZsGBe9IBgWwpGLD6S+hZS/KqM
	B8UZjIVpB1775y8ix7jZxvAu8DBfkwwYRZpXRTdQX6Fqbm8vQYR42knGhddaQDIE
	iNrcP0+fV4V0Th+ykhpN9aTYEwT0hK5S65JdVNqdWFi0/Depo4iWnBXoVrx0HjFc
	m/aF3A==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 429qybc30u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:06:26 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 0CC664004A;
	Wed, 16 Oct 2024 10:05:18 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6071323CB55;
	Wed, 16 Oct 2024 10:04:34 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Wed, 16 Oct
 2024 10:04:34 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Wed, 16 Oct 2024 10:04:20 +0200
Subject: [PATCH v4 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241016-rng-mp25-v2-v4-3-5dca590cb092@foss.st.com>
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

RNG max clock frequency can be updated to 48MHz for stm32mp1x
platforms according to the latest specifications.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
---

Changes in V3:
	- Added Marek's tag
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 279328902bf89af15b8ca9df9a061bf2a1ddcf55..5b4fb35bcb5cf7faa257286660b88c5840f0d07d 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -508,7 +508,7 @@ static const struct stm32_rng_data stm32mp13_rng_data = {
 
 static const struct stm32_rng_data stm32_rng_data = {
 	.has_cond_reset = false,
-	.max_clock_rate = 3000000,
+	.max_clock_rate = 48000000,
 	.nb_clock = 1,
 };
 

-- 
2.25.1

