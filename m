Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9161D16F287;
	Tue, 28 May 2024 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716905314; cv=none; b=IeZN2rTtCYIDW7L1gzd5W/eJLWkLjXFrBDDwvJ2KC3act7Py8Q+55c3DCwioGwkpiq8Tm18bFMoQcMz1SI+w+8si6NeXOcOk7rZ+ZrCSuEnzey29wYE77ye3QlVzcKEC7sE+sY3W9urUYN0fyhccPuy1bFt/DNyxZ+T6bdFI/BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716905314; c=relaxed/simple;
	bh=0kYRkuoifz238hYaa7+VBTksrIRPb0Qrje3MA74G5/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEOy97NY6KGIVwo1rh83q8pS1xtw5LxIzfFWTcta28Zylh12wT85ECcRXchSQgckHZSkuWkqpS0RnaPuEiRDJW74Y2oGMyqXhP2a3sS/6IvolWoXR2fyyv0MJYwMKzwR1qSNMIVvsfRzl09pEOmzKMTCIvMO/7J+JnBCSZjQO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=iMdtq39P; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="iMdtq39P"
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SDhLnC025707;
	Tue, 28 May 2024 16:08:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	WID1Xn8lAVeZgvgjfAvIZ5toir+39YNbyOYV1Sn5tIE=; b=iMdtq39PTNMpN5q0
	qF5bJ4MgHOGVhw1mZ69E37DDykQPYq78VRyRC8xOcDTIiHo8t1p5l7oZahTlfk0f
	62z7DDATzMDcsBvM9BD7OGFShvez3iYvQr5XabiKWFIxf1f0351qZxdZyFDmvnxd
	GoPFlJ3hA3qQASc8S351Qr8UAwzmTx6IN8L35oG2mTJ8HBYVxzGT1rhCD04nT8Q3
	Un5yiNA+05t0WBvnKJiWdURvtWfMNoYRiQhfDHpDPnRX1HTJLWWgH8tk29MRAEMF
	ZUoMTJzQW5S2qMI0c3XwQT+lqG3Z0Ree23XiH4o8uAVgvMLxRZfRL4i2crNBTggv
	eKlDiQ==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3yb9yjuyq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 16:08:05 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 9A0824004B;
	Tue, 28 May 2024 16:08:01 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id D470621BF47;
	Tue, 28 May 2024 16:07:23 +0200 (CEST)
Received: from localhost (10.48.86.103) by SHFDAG1NODE3.st.com (10.75.129.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:23 +0200
From: Maxime MERE <maxime.mere@foss.st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre
 Torgue <alexandre.torgue@foss.st.com>
CC: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Rob
 Herring <robh@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>
Subject: [PATCH v3 4/4] crypto: stm32/cryp - call finalize with bh disabled
Date: Tue, 28 May 2024 16:05:48 +0200
Message-ID: <20240528140548.1632562-5-maxime.mere@foss.st.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240528140548.1632562-1-maxime.mere@foss.st.com>
References: <20240528140548.1632562-1-maxime.mere@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_10,2024-05-28_01,2024-05-17_01

From: Maxime Méré <maxime.mere@foss.st.com>

The finalize operation in interrupt mode produce a produces a spinlock
recursion warning. The reason is the fact that BH must be disabled
during this process.

Signed-off-by: Maxime Méré <maxime.mere@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 445276b848ed..937f6dab8955 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <linux/bottom_half.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -2203,8 +2204,11 @@ static irqreturn_t stm32_cryp_irq_thread(int irq, void *arg)
 		it_mask &= ~IMSCR_OUT;
 	stm32_cryp_write(cryp, cryp->caps->imsc, it_mask);
 
-	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out)
+	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out) {
+		local_bh_disable();
 		stm32_cryp_finish_req(cryp, 0);
+		local_bh_enable();
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

