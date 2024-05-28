Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273EC16F293;
	Tue, 28 May 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716905239; cv=none; b=Vay56XLpePoS/bmY4zMtayJavlCIs0ak3j0CGWtjgtqwj0nYQkA5N+6PZAP7FUToR++XtFiLvywr5WV5lA81MHx5KkpQgojirRTyIAvUIGZfgQnlXqrhdPTMfPal2u2WxnNs2Lbzvpkp2/NCNDfPWz9ZR8CCl+33OQfmGOgo8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716905239; c=relaxed/simple;
	bh=SneKdd7y8z3fUGaVNMnWjH1Q1X33sbSk6/9UWXmudtI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZRITIvTIR0wAZCzxMNjB6XDDbL/+iQLHfRBZ6QZegYqXmWUileBY9Q7Qb8cZdVm5+hPxOf1Bd50Qhc933txI/BubxJViQ/HsHTebjTXxu9UGe9weXfFXaDQmkVT+1OJvjEoo75uvij88HMT5wQKb80Tb+UrCe67E1FkEW9hcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=ebzQdQu2; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="ebzQdQu2"
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SDcOdO029891;
	Tue, 28 May 2024 16:06:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	v7E8OMWYxR1Y6IK0L9YNl8ouxqDGEKTc3SeFud18MwE=; b=ebzQdQu2CehgUyU7
	I6S/9JAO5LGTr9OHe4jtdL+pmGJiYoVdjU9sYsHGSd47FJUDB7xpND8fBtIUIqPi
	98eZemtcvN2KrARhVtZwZYjNylqZIlEGu5phIoF35Lq/YKmLb1OScRgORu2w1bOU
	G6+MpFfSMJq4Eib0cC4JnNXzUuuEhwPDuutMOLg0HN+tQbjAiAfpHFsARSPoxDOx
	kv4gaEpI4/jsdbEseiKLinhpRsVzbXDwTPAPQFSaU7HhN0AAryLJWX7DCsO9lhrz
	rKgy6yqKm4T6CeekMUSUQA3O1yS+k4W4lhBwUpE+BtK6ffW1GAGJUhDwQAoV2aAW
	Pe+WtA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3yb9yjcf3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 16:06:55 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id D84A840048;
	Tue, 28 May 2024 16:06:50 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 1D58D21BF45;
	Tue, 28 May 2024 16:06:13 +0200 (CEST)
Received: from localhost (10.48.86.103) by SHFDAG1NODE3.st.com (10.75.129.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:06:12 +0200
From: Maxime MERE <maxime.mere@foss.st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>
CC: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        "Rob
 Herring" <robh@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
        =?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@st.com>
Subject: [PATCH v3 3/4] crypto: stm32/cryp - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
Date: Tue, 28 May 2024 16:05:47 +0200
Message-ID: <20240528140548.1632562-4-maxime.mere@foss.st.com>
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

This flag is needed to make the driver visible from openssl and cryptodev.

Signed-off-by: Maxime Méré <maxime.mere@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index b0d278421461..445276b848ed 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2283,7 +2283,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "ecb(aes)",
 		.base.cra_driver_name	= "stm32-ecb-aes",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2305,7 +2305,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "stm32-cbc-aes",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2328,7 +2328,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "ctr(aes)",
 		.base.cra_driver_name	= "stm32-ctr-aes",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2351,7 +2351,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "ecb(des)",
 		.base.cra_driver_name	= "stm32-ecb-des",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2373,7 +2373,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "cbc(des)",
 		.base.cra_driver_name	= "stm32-cbc-des",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2396,7 +2396,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "ecb(des3_ede)",
 		.base.cra_driver_name	= "stm32-ecb-des3",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2418,7 +2418,7 @@ static struct skcipher_engine_alg crypto_algs[] = {
 		.base.cra_name		= "cbc(des3_ede)",
 		.base.cra_driver_name	= "stm32-cbc-des3",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 		.base.cra_alignmask	= 0,
@@ -2452,7 +2452,7 @@ static struct aead_engine_alg aead_algs[] = {
 		.cra_name		= "gcm(aes)",
 		.cra_driver_name	= "stm32-gcm-aes",
 		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
 		.cra_alignmask		= 0,
@@ -2475,7 +2475,7 @@ static struct aead_engine_alg aead_algs[] = {
 		.cra_name		= "ccm(aes)",
 		.cra_driver_name	= "stm32-ccm-aes",
 		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
 		.cra_alignmask		= 0,
-- 
2.25.1

