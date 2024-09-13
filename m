Received: from mxe.seznam.cz (mxe.seznam.cz [77.75.78.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5371D67AB
	for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2024 10:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.75.78.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726225155; cv=none; b=GcO4BpQ9pVksUcn68S1o024REG3PQUiGxhew4Gu9zH9jVCYA/6gSV20Fj/7/Bop2Qq45g+f+HMx/7XDUIlk+BI12sFNS8BrVtUyfkKJztTTGzJr3EfJZE8s3XMNTxAbe9hQyYwcdeBzzn+xew6C5oQ0aKHV2BrtokUgCOch4OiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726225155; c=relaxed/simple;
	bh=LsVl0Voqd1ckeCDn0W+7B7IVZDgwFBAd008MHYFeKtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Mime-Version:Content-Type; b=gLBmGUT1tIPAZ02lfjdTDZ4hjOBj1r4gIbcjkG2UZlZmVA1iRLCXxdMokSZOysG0WYNXFvEVwZeJJwtkPG5DiLU3eFwn5a4gPq9tXLiWjzQp8BlC1iDjqtNPEpQjioMjFQvHt6P3S0ZEJ5YSiWMEbMFRyD61rB6P3s24Ahw0ntU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz; spf=pass smtp.mailfrom=email.cz; dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b=S6g1BsX4; arc=none smtp.client-ip=77.75.78.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=email.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b="S6g1BsX4"
Received: from email.seznam.cz
	by smtpc-mxe-7bdd9d48f6-vf57s
	(smtpc-mxe-7bdd9d48f6-vf57s [2a02:598:64:8a00::1000:aed])
	id 7fb00c968144be3c7f3e828e;
	Fri, 13 Sep 2024 12:58:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz;
	s=szn20221014; t=1726225103;
	bh=Go1Drl7Hc5TRGms6agMq/QAyf40vC00ZWCu62l3/7AM=;
	h=Received:From:To:Cc:Subject:Date:Message-Id:Mime-Version:X-Mailer:
	 Content-Type:Content-Transfer-Encoding;
	b=S6g1BsX4WqcsWQ7TEqI4Q5hinoIJvlK971uJpasNtpyi20KODBcbEHsvzihB/DjqV
	 9nTPqJhQnYYJdOQw8CpofRI/5Syg03jQhm1bU8pmFaQAAB65gkkFQxZLtSPd+8LqmD
	 AvSDLoUXhbM1cvTN7KYpVwew2i3Lkp+4UNmtjeYapY4208NNGswyZwBKDp4pWMs4ui
	 UCyXgwN3f76oAecxC0kh5q48tL8m4qiZSbOClyl/plisSmwjrURuYEnAlq7MWL4Z7O
	 2vj6VopjGvtxY/dR7FI9hz9ISoXP9JFJVFsHUiLc9EpLb7rybM0QjFygLVTLY5oaFv
	 Yg3tPrro7BdxA==
Received: from 184-143.ktuo.cz (184-143.ktuo.cz [82.144.143.184])
	by email.seznam.cz (szn-ebox-5.0.189) with HTTP;
	Fri, 13 Sep 2024 12:58:21 +0200 (CEST)
From: "Tomas Paukrt" <tomaspaukrt@email.cz>
To: <linux-crypto@vger.kernel.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Shawn Guo" <shawnguo@kernel.org>,
	"Sascha Hauer" <s.hauer@pengutronix.de>,
	"Pengutronix Kernel Team" <kernel@pengutronix.de>,
	"Fabio Estevam" <festevam@gmail.com>,
	<imx@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
Subject: =?utf-8?q?=5BPATCH=5D_crypto=3A_mxs-dcp=3A_Enable_user-space_acce?=
	=?utf-8?q?ss_to_AES_with_hardware-bound_keys?=
Date: Fri, 13 Sep 2024 12:58:21 +0200 (CEST)
Message-Id: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (szn-mime-2.1.61)
X-Mailer: szn-ebox-5.0.189
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add an option to enable user-space access to cbc(paes) and ecb(paes)
cipher algorithms via AF_ALG.

Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
---
 drivers/crypto/Kconfig   | 13 +++++++++++++
 drivers/crypto/mxs-dcp.c |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 94f23c6..4637c6f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -460,6 +460,19 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_MXS_DCP_USER_PAES
+	bool "Enable user-space access to AES with hardware-bound keys"
+	depends on CRYPTO_DEV_MXS_DCP && CRYPTO_USER_API_SKCIPHER
+	default n
+	help
+	  Say Y to enable user-space access to cbc(paes) and ecb(paes)
+	  cipher algorithms via AF_ALG.
+
+	  In scenarios with untrustworthy users-pace, this may enable
+	  decryption of sensitive information.
+
+	  If unsure, say N.
+
 source "drivers/crypto/cavium/cpt/Kconfig"
 source "drivers/crypto/cavium/nitrox/Kconfig"
 source "drivers/crypto/marvell/Kconfig"
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index c82775d..84df1cb 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -944,7 +944,11 @@ static struct skcipher_alg dcp_aes_algs[] =3D {
 		.base.cra_driver_name	=3D "ecb-paes-dcp",
 		.base.cra_priority	=3D 401,
 		.base.cra_alignmask	=3D 15,
+#ifdef CONFIG_CRYPTO_DEV_MXS_DCP_USER_PAES
+		.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
+#else
 		.base.cra_flags		=3D CRYPTO_ALG_ASYNC | CRYPTO_ALG_INTERNAL,
+#endif
 		.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 		.base.cra_ctxsize	=3D sizeof(struct dcp_async_ctx),
 		.base.cra_module	=3D THIS_MODULE,
@@ -960,7 +964,11 @@ static struct skcipher_alg dcp_aes_algs[] =3D {
 		.base.cra_driver_name	=3D "cbc-paes-dcp",
 		.base.cra_priority	=3D 401,
 		.base.cra_alignmask	=3D 15,
+#ifdef CONFIG_CRYPTO_DEV_MXS_DCP_USER_PAES
+		.base.cra_flags		=3D CRYPTO_ALG_ASYNC,
+#else
 		.base.cra_flags		=3D CRYPTO_ALG_ASYNC | CRYPTO_ALG_INTERNAL,
+#endif
 		.base.cra_blocksize	=3D AES_BLOCK_SIZE,
 		.base.cra_ctxsize	=3D sizeof(struct dcp_async_ctx),
 		.base.cra_module	=3D THIS_MODULE,
-- 
2.7.4
 
