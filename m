Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003A51F6668;
	Tue, 15 Oct 2024 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011087; cv=none; b=PCkCsjxW7A+JzrJh9Nu2DX3CQjTUA+7guXBmlqH4uFymKWSz9AT7fTt3Z7iuQJX35xof9LfcmMzmy/9XsU1Nhn27d5w1KSGEI5lmsov4Km+ioKnBY/vpNuF+uM1SbzA/dATp63uEl4ebjZgkWrWDmlJ6GX3z1pLTL6SG9ZmZwpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011087; c=relaxed/simple;
	bh=I4iWyFgFIpIpyNQzJqLRDERhYBCEmkQ41tqVFqd2kk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=lnG2VfMBu2vYjzrQFSVe60PPYMtEWP3sNGO0Cqw3YdXhePRfOsytLeqAwAN1JA5C3YfhEimPs1vi1BO3K9gxLEFnblZmzA6q6i76gHBigeF+YEATOAWwfPacoThHB/4LNy7JKRF99SFU03R/FaEko09/5HrsnsB69JDLI6YNH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=wP7JRjKz; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="wP7JRjKz"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FBlZ00021364;
	Tue, 15 Oct 2024 18:51:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	QYf7I5bZM+g/zbxxwONC8wmKlEdNvZg+vARUi+5HicI=; b=wP7JRjKzhxTg7TWJ
	Gdiru6mlOrMDm+vn/qdN7J/ZWWD3vtNCSbJes2RQJptBL7uT1lxT+El+zXt9JzTg
	u2i60muZgAFE+CBtj+xacShoiqf2BLgZZ/TB/1essekdQc9SdLg9tEvUuSaRda6u
	g20lcllg1G/y0CtwiFJ1vyyYDi5owpViRo8a0JJ+1kTV5yUKg3frj6YeBTzilfPB
	RDuc8EypZqmFlC0EX+2M/+6k9cmPrijqtcIhgOoSapFDxnq+aAhXqSZn7vOeeUlF
	pWXNOuMAE0VySOKwKkY2VBxjFo8g6sV8SVcgVZyPlq7uWIjhn1gBHNiW2C9+eMwL
	cNj1yQ==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 427g0bp7sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 18:51:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 4BB3040055;
	Tue, 15 Oct 2024 18:49:49 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id EB3E62216EF;
	Tue, 15 Oct 2024 18:48:59 +0200 (CEST)
Received: from localhost (10.48.86.225) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37; Tue, 15 Oct
 2024 18:48:59 +0200
From: Gatien Chevallier <gatien.chevallier@foss.st.com>
Date: Tue, 15 Oct 2024 18:48:56 +0200
Subject: [PATCH v3 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20241015-rng-mp25-v2-v3-3-87630d73e5eb@foss.st.com>
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

