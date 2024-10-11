Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5D18EFC1;
	Fri, 11 Oct 2024 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728661680; cv=none; b=QfrACwUDnjWbDwhRxkeMZ9IBAKXHJIwzXTmTDT0tIkEiI5kj7cu4742JaXur761M0dTdPnDiCckojjBclpz6rG9Vn5hSA6JlVMTWeOHtt6dFCrMfQZ+tOnZvrCtQxl9tO0z3r0vEkKchW66iWFoTXQi1gWJukXKF9n9+oblV8CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728661680; c=relaxed/simple;
	bh=0RwzkCShxixzquuFPmLNwqODb5GGHOx3BH/dIfUsYTU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=OFIyHYZ7i7JzIMTlZmVkyh77XcTjPZtrB+vdWa+suohodGMWwI0D2I3asjWdC7i43Puv180+MnpZmxstFGwoXCd6THrRlS6gZSg+2n//P+XJ1vyXnUW9gg8tYveKuqQz/RbnPLk6FXG8znzyINebvJV51J9YDta0OABQDjGMnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=mPnPzU7O; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="mPnPzU7O"
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCmEYT029283;
	Fri, 11 Oct 2024 17:47:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	vQsFEfKGHVxqMjB9A0r/ahU4vbVBNlphLxlklfsARqY=; b=mPnPzU7OQKjHnr1d
	OPVIu1y8TxLbdb+Speh7SRO/ltVb1+8zi18Y13kzcqFnAMIvWdMcvghAVf9lJPff
	RHt53OQzJBgP0W/UcJUWoxY21DsMCHaNZNaVfIlfFp6Vtccjn85Swu1Q0y7VkHB6
	GU/3HvMIJGMR34jyZM0z1JTm9p9iOdnAXH9SUCLPbfo3NGD+mqFGOu/bFLmHiLPB
	5ZgKfn+9aDz6cWXvxXAu0fY2zSVwDCrgynAcwMk0d0x4xjcyefwcTiK8iVCzivVu
	nGdOpTu1vACQNpceqM3qiLH4RKKtQ5Zx1Nvmrp3Ax08VdvaVoikbcrOjsyOsW3Rc
	7nlTPw==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 4263439ty6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 17:47:31 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id A7A3B4005D;
	Fri, 11 Oct 2024 17:46:15 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7907A29E028;
	Fri, 11 Oct 2024 17:43:17 +0200 (CEST)
Received: from localhost (10.252.28.117) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Fri, 11 Oct
 2024 17:43:17 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Fri, 11 Oct 2024 17:41:43 +0200
Subject: [PATCH v2 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241011-rng-mp25-v2-v2-3-76fd6170280c@foss.st.com>
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

RNG max clock frequency can be updated to 48MHz for stm32mp1x
platforms according to the latest specifications.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 62aa9f87415d2518b0c1cb5fb51b0b646422ed35..ef8324b914fc2de2e7a6bd9eb69c081c26cd1ecd 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -507,7 +507,7 @@ static const struct stm32_rng_data stm32mp13_rng_data = {
 
 static const struct stm32_rng_data stm32_rng_data = {
 	.has_cond_reset = false,
-	.max_clock_rate = 3000000,
+	.max_clock_rate = 48000000,
 	.nb_clock = 1,
 };
 

-- 
2.25.1

