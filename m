Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D461D1F5A;
	Mon,  7 Oct 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728307972; cv=none; b=UGIvMFiJNNTZk1KbMS8BCF7RAoxO9AzgCxx4Kexcz69sa+X5RdAQevQKI5bsXosfQGNQd2aFMe1Na/DdUJ7ROwu8k+lrBzPVvMy/Ck1VdKyyocB3+wQnJ0V/bfEIjHtZmqofyQ8ZfviAZoabonx1GZNPB6HEWcSS7x+ZCFntpuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728307972; c=relaxed/simple;
	bh=rgzOPtb+8Y7nLdLgZ3t7vquvJq3BTWxEvp+C4nvrxPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KAY7ASmuOY7z0UHRzTZRxMHTKNEVuVfhn4myGtHhoDlWiDge9rd3pEGDuYiWC7P4dyqQ/tAfAuFyNwIKFEuERRU1y6cmRz6rsB8yIVJB1VeMRmJl/JW7NmfCEwn4Awax2xAQjbRHlpCE3pel6zMq+AVeLzh0IEHpbLpPr01JDcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=fPo4Im+R; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="fPo4Im+R"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4978wkwM023351;
	Mon, 7 Oct 2024 15:32:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	u7NukRJuVqIxIvFeEgDqcmResbhaXgq3ShhJIAUsN48=; b=fPo4Im+RjVokk4oZ
	zMvdHlchU1YMM27ZiFUUvs5Nf88vBIqCdqu05km05i4eCFzGs4zH2GbbiywjsI9v
	+I5U5c0jxa3e9JOiCdD2ZG/52GY5njGnJaYCxF7TYhiqRFFynfoiHP0tguE5Geo0
	mEDiIDYcSVSHj9OD2Vnnh+XZLs/3T3ZdPiRCbSdjjd7xHe01ATlJp3PJxKo/xBRG
	kBiQ9qG26W+0D0V35qftGWNuoLWXCQqxpEOY9zr7aYWGCuvUi05gliMxxbe4+Sfh
	aDNiV13zUuARL8TjCGCkA0+dp+ZKcJpbswW1sB6v9x4icaZiXlMjV4cGAsWVE9Au
	zbat+w==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 423f10pdkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Oct 2024 15:32:15 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id AFEE34004D;
	Mon,  7 Oct 2024 15:30:37 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B32A027A507;
	Mon,  7 Oct 2024 15:27:47 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Mon, 7 Oct
 2024 15:27:47 +0200
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
Subject: [PATCH 3/4] hwrng: stm32 - update STM32MP15 RNG max clock frequency
Date: Mon, 7 Oct 2024 15:27:20 +0200
Message-ID: <20241007132721.168428-4-gatien.chevallier@foss.st.com>
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

RNG max clock frequency can be updated to 48MHz for stm32mp1x
platforms according to the latest specifications.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index e7051005768d..9f1c95218a5b 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -552,7 +552,7 @@ static const struct stm32_rng_data stm32mp13_rng_data = {
 
 static const struct stm32_rng_data stm32_rng_data = {
 	.has_cond_reset = false,
-	.max_clock_rate = 3000000,
+	.max_clock_rate = 48000000,
 	.nb_clock = 1,
 };
 
-- 
2.25.1

