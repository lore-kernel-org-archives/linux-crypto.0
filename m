Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012000.outbound.protection.outlook.com [52.101.126.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50339410D37;
	Fri, 10 Jul 2026 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783680844; cv=fail; b=nos1C8p6Ada51x6AVwUt6S2cBGjbL0z2p9e5xiI7Dr9tSASVr/Svk0+vNaqckBzoZpwBmONVVb3EcRGxCM/tQhhY5JA3ATfySc7VkdxzCWODnVxvt7WyLyM8Qux6gtnLsN/zibXB1sGca2LHyhY6AmZo6TsoAMYBaJRJxWMGKCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783680844; c=relaxed/simple;
	bh=dV7MyjrNaymEZQk91wVHQ62HWa+XNTNsmPcMyNny42w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RA88YB/llwwZ+16yv2Wa0Cpx30PCIbPU5wyXCOc9Ju16w6mlzaqEvGgQyvhpO0QRPvwwNpV29GC4mXq11m2mm6GBrGSO/sJPhQVV+jzAsbENb0kMx+6wk5r/e+FJZwFn/hRPKQzsTDqezhWH8a6BGtGU28yN0madzAz5GtrtK3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=LI6Zi3xh; arc=fail smtp.client-ip=52.101.126.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LI6Zi3xh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RoZL5Z9ToRx/f8kviD9CyKaiC5FVV0S6HJv5HVsNVGS9SMyS/LqnFdICPsZHpud+BEMkGJPBlOfdi1I0+dHxI/ZGaUrJbBn0zCEs0j4qTZ5DzfmbDjyqJeApTwBXk76N9O7gD2spw+iLfW1h4zuNRQXTTOrdNqyAAsi7euudiLzmFquyU/BIAlde+Qahg0NlvZ95PbtffbPJYwcEqpwhU/kBKPRAyOj/GoLfTth01XQK4qgNjL+9WIua8og2EbDnmeDiavLDfyBWeHgzdrDxL1i2jMI9CnK2xe4u50afLBKJQ/h/qvEvkyB69NTNqrLEJENTXxGjKFAM7rNB1rm44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acT5XmYocSZ19UIykLwYP24NTpZzoE7fRl0T7yJJVm4=;
 b=AmFZMjPP8uzbxoOzupTD/1c7sg+ORQow7dxpseCc9zjGw+cuiNxvPkAUtyY4ldHlmfCehVGeAad77tYzYK5rfqf2xO2o+PZtlohbFoyIZPRD7CM6tpmj9BQh4wikkMFZHY0gs47kToN8zYT//s3lJAHu0XAxFL5FCGFaFHvTL1WdKUJmWek81CgEkZYa2yHgFm79jIo08TsZf5JqasEyksC1RXoj5lOHZT0LJ+zx86dCm3cl5Is2DNqVnhLEj1DTDeZTwdUIs6xXxTzK23FyFoHSd+b8ywLFNPniW8JJW03ZJiRgBrmRX2yfnGd26eosw6pInK3R56+fWb4z81aoGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acT5XmYocSZ19UIykLwYP24NTpZzoE7fRl0T7yJJVm4=;
 b=LI6Zi3xho7J7F1PXdKE1Lp4HEIJtsm2Xpb86kNmUG29lNvrEOAsccEnnDtAQgjwDS05lkyCHdohKe2jKVp6J5Gxtjgzj80cRyBlZBJkpOkfOEQAgX+rdMHo01gGnxztOc+yKApTr55I3FziEKqOK8LZCJ+5l/o3f0IvP73yKTAJAyS0jqRseXP6/nTPpj9iXPVq1L8MpGuNgKbiroitYdpYCD2NUNc2Kcs87wJZDMD3uYXGrf+GU+P2luLBRtm/kLVHiDfQxxc8rcK9kN/IvHBDEOLK5pEG8rkZoDKaln1ibbSYoha6lgMA7igcQmjrjKNJhl7fiTIYUNXgKWWIjwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by KU4PR06MB8388.apcprd06.prod.outlook.com (2603:1096:d10:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Fri, 10 Jul
 2026 10:53:55 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 10:53:54 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hadar Gat <hadar.gat@arm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Deepak Saxena <dsaxena@plexity.net>,
	Pan Chuang <panchuang@vivo.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	linux-crypto@vger.kernel.org (open list:HARDWARE RANDOM NUMBER GENERATOR CORE),
	linux-kernel@vger.kernel.org (open list),
	imx@lists.linux.dev (open list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE)
Subject: [PATCH 1/3] hwrng: drivers - Remove redundant dev_err()/dev_err_probe()
Date: Fri, 10 Jul 2026 18:53:06 +0800
Message-Id: <20260710105318.376496-2-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260710105318.376496-1-panchuang@vivo.com>
References: <20260710105318.376496-1-panchuang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0021.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::12) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|KU4PR06MB8388:EE_
X-MS-Office365-Filtering-Correlation-Id: 18eb0684-099b-485e-7771-08dede71892e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|52116014|1800799024|366016|38350700014|921020|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d1tBzrkNJ45/yKtXut+HoMebFWBA6BxkyK2/WfD2bXFlizGM8HssHs4WRsyBdaeFvqJXybEYTQvr1ihfFf58zURQhJ1WEtZ0XL0KoQcs2EnYR6YadwVf/YufTV0d5aYaSNfx+WijwGBMaDFXuv+h5Wo5x4N+Xa/UkgBdLXMNlTpGxWaLSQ1xieWDkIpsOacE5p3aXUnbVYvNujjjLcxDrSLlsEqHHL3Digib0llFxRjQZpPvLc4uKJE8uSmvov3MBPQCemS0WnDX3ts6zG56yCnUpbsIsec/nRjJV0tLoFEwMnXAur4qK3ZenzpiCtrzJSRn2elA+D+fa4JFgC93m62/zFBNFw0vBaLRRsB5hVbPDdF2JpllA3ceaIi3E8q2NbObaTMcphEgDl10G/hJXNy4sfBlE1tozhPkWtoxPCzftxlF6PuIBwGAORdp3TwcnKhvUhYJnyNi7JwnlNXJAoORiizbxgCpmaV1g5td1ebI/rDJNv7BdKAlaQkTAfFcvP65DgY7Mij6NDiQ99Piz/vdWuL6pT5hV4j66GvoA3+k/HrNLQ6U1iCdsWsEQbRfPUnuftKMv5PD9xy9N+zSKm6c/Wb7o7KmtlLV48Ys3UsnUDZr4tH5M4OMIKaIABXsbsDFv+uWByDWyg5vEGrb7F5VWN3ZnK/sEGJPs2DmmBc0d9KAiy1uTVcKRRylxDH0dS4A+/3agyFB1EeCfgc59YUQWAyzfopS2nf7pJ6cuxGsAWnwH7BO8BAy6V+5UOAx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(52116014)(1800799024)(366016)(38350700014)(921020)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DtZ46Kgo9hv0SEQ4OwcIJ52Uc4p4icVuU1Wl2IdjsmkHPvBtUdGaK964LCnC?=
 =?us-ascii?Q?xLAhpy8+3tGE3dAXUHLuPcX7z1/KRSWu0jLfHUsQIBnFkIEEKsbmkIoa6B17?=
 =?us-ascii?Q?jmwLs+ZTa4koR4je4E7+V3b99gK1e7quFqFfozDiglRv5x2io9riztmC+Tpm?=
 =?us-ascii?Q?JlOuokEtxj37xhPTd2C3odZmXxsBmB7kXyLC5LraX3d+lpx8rDPz/048ykxM?=
 =?us-ascii?Q?AEnSRptIBQttlFP11GWiaBfMfxSDa3WpNIBuY3ST5gY+G2Fp9rGLPtHx8PLh?=
 =?us-ascii?Q?69gO54EgoYjCl9/iQA0q1DFIZYi6qhSlzd26fp1Zl9/ZpcCP90f0rw+GFh19?=
 =?us-ascii?Q?iLEhsWMb4M0c+abGNAldbZsU20jv6eiciew2P3TuELm/en5xAv+v+Bjb6LSB?=
 =?us-ascii?Q?Lm0qjKsGqA0W0bmggYCjcHkwFsvY51NAVSHmnwtIa1nhF3pVVZjBuQZqrQSu?=
 =?us-ascii?Q?4ZJAXDov5qevbjLPZ/kVt2PUfMUSaHEBsLX4EarQrzH8ULXuNUymFbD+dlkC?=
 =?us-ascii?Q?RYl05BjGwrUtVEoKvpL/vTbGduWItrfZxJ5QhSEDQ9/ezNKOKGuVQbXMCrsj?=
 =?us-ascii?Q?YKnJY0rqG9Tshoi8vHra4Z8Q/DrzRBZ07xhlBUGJGrxBJY5tYcCgPCU7sw1U?=
 =?us-ascii?Q?xE5aX+XIzcP3Yvflt7AQOLXvaaFUHL0c5wzCriA9tLdhTvmLHR+eQ4tLOq4C?=
 =?us-ascii?Q?aBNnXLxL/IX3NcF9WHIte8UyrFbZ12S2AgcEWXgSvixq7sZzPDNm8AzlhrqM?=
 =?us-ascii?Q?8pGg3kESVaYxImxzodgrwmH9EL98Lok/35qdgUvt8CsIp+HsqElGNcirUG1t?=
 =?us-ascii?Q?FMvFPEMTkpP0SyzXoktMMOxja02T76sP7zICN5zGcN46pAG3aoJRovV3kux8?=
 =?us-ascii?Q?F6qrEORu/4HkT99AbOKPhcgYA94OaS0fW+5bu+cQZs0ybgYZ+7NofnwJHv6W?=
 =?us-ascii?Q?xyD1JqE8SK/1/MWGYiRjIZl6Kdq5F0Z7E23mpz7Y/H8t8Waq/DbkCLPsjup+?=
 =?us-ascii?Q?rUJ9xzNCXxjHFpCQ+DIkxugsjNqwIe8dR0iVt4itNt0+8P4Ty3mTskoMQLCq?=
 =?us-ascii?Q?ZZQBKndk8YVI9onhoqJRoPKPsr+WTjS6UciwFWIQiwbQbyDnXgx3gbNtX4At?=
 =?us-ascii?Q?IGuzX8M/Lp0Q8X6YsOL6sKm4gwfZTFiv+gF4MpamMpUgYQAjzn+41Q/djWTz?=
 =?us-ascii?Q?NXeoQwQ2rqq9LWNlN6nOBVJXjk6lxv4+cdIV6zgK6LWYiia7ZxCWuF76QP6Q?=
 =?us-ascii?Q?qS1dQHrjXhECLFrbB2s+1MXF3kEglj82iH45e1/wgCslQ7X/KcAPzcYd9ob/?=
 =?us-ascii?Q?plCa0x9lRnQzPiqKzi/27r+6nBIpKZhvZaBlbafhhKZa7LFi/w62nW2/+l7K?=
 =?us-ascii?Q?AXXfPUOFP/oD64kq+tDhpIYFEhBQ6146czwJ6G13vABsxKODzaaj1jMAmhqr?=
 =?us-ascii?Q?gcE/C/AiTsEYfexkbg3COqTB8LviL5z1JFl+9Z5Q1qn2hgV2BAeoRoVE1IZr?=
 =?us-ascii?Q?9xkoXAmBoVTHcg9Oapda5nfp+V4LrH2d6VfwLPxg4g/68ggwc/PclD9AWmiv?=
 =?us-ascii?Q?N0GwotO/lmXl4miQG7p8G2zAAIvrWaUFyv6ahRdNOgu20j6TagKXoO/ysWvV?=
 =?us-ascii?Q?LWtLtXB1a03/ARBDRXpceMDNlOBcIvp7U9+GKteDlNHFaMUzyR1jVzdDf5eI?=
 =?us-ascii?Q?wu+CEBa7eqrMhbhECnStZdWoGdpSqCB2D355CIMirRZWnO8Uik3Ag/HcL4pB?=
 =?us-ascii?Q?8kwPIYkkKA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18eb0684-099b-485e-7771-08dede71892e
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 10:53:54.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYAF9rw1aranB6LDSTlIeX0ASHZBG3a8QHepiwSef7H09Viz6taMW/5FnwCyAewgU9XbQoNFP1Q4JbfOn/EZCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU4PR06MB8388

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() and dev_err_probe() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/char/hw_random/airoha-trng.c | 4 +---
 drivers/char/hw_random/cctrng.c      | 2 +-
 drivers/char/hw_random/imx-rngc.c    | 2 +-
 drivers/char/hw_random/jh7110-trng.c | 3 +--
 drivers/char/hw_random/omap-rng.c    | 5 +----
 drivers/char/hw_random/xgene-rng.c   | 2 +-
 6 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
index 076519a2f100..98c131ee9891 100644
--- a/drivers/char/hw_random/airoha-trng.c
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -186,10 +186,8 @@ static int airoha_trng_probe(struct platform_device *pdev)
 	airoha_trng_irq_mask(trng);
 	ret = devm_request_irq(&pdev->dev, irq, airoha_trng_irq, 0,
 			       pdev->name, (void *)trng);
-	if (ret) {
-		dev_err(dev, "Can't get interrupt working.\n");
+	if (ret)
 		return ret;
-	}
 
 	init_completion(&trng->rng_op_done);
 
diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a5be9258037f..a6925211c3b5 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -509,7 +509,7 @@ static int cctrng_probe(struct platform_device *pdev)
 	/* register the driver isr function */
 	rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "cctrng", drvdata);
 	if (rc)
-		return dev_err_probe(dev, rc, "Could not register to interrupt %d\n", irq);
+		return rc;
 	dev_dbg(dev, "Registered to IRQ: %d\n", irq);
 
 	/* Clear all pending interrupts */
diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 28c56c2d1bf6..bae8cdca13fe 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -296,7 +296,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
 	if (ret) {
 		clk_disable_unprepare(rngc->clk);
-		return dev_err_probe(&pdev->dev, ret, "Can't get interrupt working.\n");
+		return ret;
 	}
 
 	if (self_test) {
diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 4712c3c530e4..aee12caab578 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -303,8 +303,7 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "Failed to register interrupt handler\n");
+		return ret;
 
 	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
 	if (IS_ERR(trng->hclk))
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5e8b50f15db7..327643ba971c 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -391,11 +391,8 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 
 		err = devm_request_irq(dev, irq, omap4_rng_irq,
 				       IRQF_TRIGGER_NONE, dev_name(dev), priv);
-		if (err) {
-			dev_err(dev, "unable to request irq %d, err = %d\n",
-				irq, err);
+		if (err)
 			return err;
-		}
 
 		/*
 		 * On OMAP4, enabling the shutdown_oflo interrupt is
diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 1f4b95341c2e..629dc85c3741 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -336,7 +336,7 @@ static int xgene_rng_probe(struct platform_device *pdev)
 	rc = devm_request_irq(&pdev->dev, ctx->irq, xgene_rng_irq_handler, 0,
 				dev_name(&pdev->dev), ctx);
 	if (rc)
-		return dev_err_probe(&pdev->dev, rc, "Could not request RNG alarm IRQ\n");
+		return rc;
 
 	/* Enable IP clock */
 	clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
-- 
2.34.1

