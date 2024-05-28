Received: from mx08-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F41B16DEA5;
	Tue, 28 May 2024 14:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716905250; cv=none; b=mRxG+u08WlCWbcOh9lRmtL660Y3CSQsz8bOVQaIjLmsAMAPAle+QM9Lotzpp8+ZWu1wmQVzAyDNtgZehPkAmgDMXKflPgs11BSXDmSZACAmZ926wV/qLjtesyt80iUAXamIXYlkendg8q1TWnszGAwKCDowwiGlXyPrOmNEW9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716905250; c=relaxed/simple;
	bh=/pmIzqRCgqdcsOaY0lfG+AaZ//v04fCu+2Pig2TmEdQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5utOFHqI1QaQ2KFxpeyZMEhEUalT7va4Iye49BkJqvu8+WDDyI73y0hJhSuAkr95Ck7f9g0oFTBu/CG1HSffprOQiE6YPeH5173O1gEzYuEPsoz5OluDTP1FxnhPKFP76FDALDAWpmDfTCFL3niHCUkVt9/m8xwqzKA4mC+ugM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=Q0RpS+kZ; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="Q0RpS+kZ"
Received: from pps.filterd (m0369457.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SDdJcv027618;
	Tue, 28 May 2024 16:06:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	8n0GJ/XFAXd2SFr/onBk6IKoD6835GbEWCwWWD5BI2I=; b=Q0RpS+kZhla7z+Jf
	VvuDivhOWH2VzYXj3suOFWB/gR4lqD2Z1p/pqvCdsSNdWR4kE2WiHFhr8DVruJ4U
	LXq6pbLprglpFpTl5kwvzcooEfll4f3VQAZZ6k8fSNj2e3hb0OnTGPSV2hHVJ4R+
	BmpkQC4XRrRu/GipQA9J9gQsG6WjB+tC7bWBdBGAtPG5sQ14DtHpfiJ86ehORhOu
	9FaDWgTuVQQKG02jhUOerCuKIffmBokYvfE3Mb3yoA+YTIx6MFPn9emXa+G+o5+L
	652JdftdorCod/guuR/2BQQ+Jn6v+FM6/JFBQ4svtIcm57vW7lr9MtTx7lFD56YA
	4hBWdQ==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3ybtxh9v9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 16:06:54 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 1DD2D40046;
	Tue, 28 May 2024 16:06:50 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4E08A21BF41;
	Tue, 28 May 2024 16:06:12 +0200 (CEST)
Received: from localhost (10.48.86.103) by SHFDAG1NODE3.st.com (10.75.129.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:06:12 +0200
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
        =?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
        Nicolas
 Toromanoff <nicolas.toromanoff@foss.st.com>
Subject: [PATCH v3 2/4] crypto: stm32/cryp - increase priority
Date: Tue, 28 May 2024 16:05:46 +0200
Message-ID: <20240528140548.1632562-3-maxime.mere@foss.st.com>
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

Increase STM32 CRYP priority, to be greater than the ARM-NEON
accelerated version.

Signed-of-by: Maxime Méré <maxime.mere@foss.st.com>
Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 8b74c45a4f39..b0d278421461 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2282,7 +2282,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "ecb(aes)",
 		.base.cra_driver_name	= "stm32-ecb-aes",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2304,7 +2304,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "stm32-cbc-aes",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2327,7 +2327,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "ctr(aes)",
 		.base.cra_driver_name	= "stm32-ctr-aes",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2350,7 +2350,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "ecb(des)",
 		.base.cra_driver_name	= "stm32-ecb-des",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2372,7 +2372,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "cbc(des)",
 		.base.cra_driver_name	= "stm32-cbc-des",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2395,7 +2395,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "ecb(des3_ede)",
 		.base.cra_driver_name	= "stm32-ecb-des3",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2417,7 +2417,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 	.base = {
 		.base.cra_name		= "cbc(des3_ede)",
 		.base.cra_driver_name	= "stm32-cbc-des3",
-		.base.cra_priority	= 200,
+		.base.cra_priority	= 300,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
@@ -2451,7 +2451,7 @@ static struct aead_engine_alg aead_algs[] = {
 	.base.base = {
 		.cra_name		= "gcm(aes)",
 		.cra_driver_name	= "stm32-gcm-aes",
-		.cra_priority		= 200,
+		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
@@ -2474,7 +2474,7 @@ static struct aead_engine_alg aead_algs[] = {
 	.base.base = {
 		.cra_name		= "ccm(aes)",
 		.cra_driver_name	= "stm32-ccm-aes",
-		.cra_priority		= 200,
+		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
-- 
2.25.1

