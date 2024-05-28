Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED4816F28D;
	Tue, 28 May 2024 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716905237; cv=none; b=tq2xhTGtBum5ZnJbXUiS56UCSscomubNWJkwMK0x3pg+gsLkYpbCN1ZvC+iBdEaQYlsNUQR2dJQPpJWB7YIWRAHZM8grhw1vYtnkGABZZtOXJ3Rf6K94WA8YJqTQPkQR96OZTZtkQ+1SRIrf+N64eFS/sP6lFYi8VN2XTWTQoUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716905237; c=relaxed/simple;
	bh=2KQho0MSXXo8Qqio41uhvk+df27zWuggaBH+1Gi23zk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N0Sy/7vmRepUY24bPK79dDZzj3T0cjw8SlKbOySdlr4gmJ/gM0SEc29+drcCSHnVbHKhWYY5Go9WB5/E3rznh8991PoM2ffTBzGxbaI40SxiapQbh7c67FlmqWcxbTGPl0feQxR8PnpIB8kGjiHGAU7Iw6jAkJpkUKHlznqGdiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ziBpEmvr; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ziBpEmvr"
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SDR8wI010710;
	Tue, 28 May 2024 16:06:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=selector1; bh=TBFeaRVOwuBL7TVI4j/ZaW
	iGYwaVC/tbXpkAWdf9bPE=; b=ziBpEmvrFGtLYCAW9omokSfNYI19n7bX+cEdn7
	YEKS4p4/e4uhugDPPzE1ujj9T/k1YTL0+PpvTKZKkyNl2bbVbdNd7VAOhEHlU7rQ
	umPo475zPwDUNYyZFuBwPGv6sUPfjz06aqViiYOjAIlAcuS9qfPKIEyPEA+C4yDb
	TqebbY8I25yIaZvU2hd26huTcVYfP5K0H7XqtWrDwLWlfS/Dg91uMkUH/CgYtG8n
	EOHHry/S2RL3PZ0zXcD5yfzT52HvFgjn6Twd4Mo1GINxxCwlbIaJxr+dKTqknfO9
	kq6D5f6SYNCIfBRaiR5PBMbGwBm9NFSRfhA95rY324fyXkgQ==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3ybsj0jdd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 16:06:51 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id BD71D40045;
	Tue, 28 May 2024 16:06:47 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id ADC2A21B53C;
	Tue, 28 May 2024 16:06:10 +0200 (CEST)
Received: from localhost (10.48.86.103) by SHFDAG1NODE3.st.com (10.75.129.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:06:10 +0200
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
Subject: [PATCH v3 0/4] crypto: stm32/cryp - Improve stm32-cryp driver
Date: Tue, 28 May 2024 16:05:44 +0200
Message-ID: <20240528140548.1632562-1-maxime.mere@foss.st.com>
X-Mailer: git-send-email 2.25.1
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

This series of patches mainly aims to improve the usage of DMA with the
CRYP peripheral of the STM32 MPU series. The other two patches are
needed to enhance the driver's visibility for ST platforms.

This patchset version 3 addresses the issues identified by Herbert.
The code that raised a warning was in fact useless as there is already
an overflow check in the "stm32_cryp_dma_check" function so I removed
it.

I've also added a new patch that correct a spinlock recursion warning.

Maxime Méré (4):
  crypto: stm32/cryp - use dma when possible.
  crypto: stm32/cryp - increase priority
  crypto: stm32/cryp - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
  crypto: stm32/cryp - call finalize with bh disabled

 drivers/crypto/stm32/stm32-cryp.c | 719 ++++++++++++++++++++++++++++--
 1 file changed, 674 insertions(+), 45 deletions(-)

-- 
2.25.1

