Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013043.outbound.protection.outlook.com [40.107.44.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BBC3DEFF7;
	Fri, 17 Jul 2026 08:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275316; cv=fail; b=Mbmwwhqr2LbLcgTKGo1+QcW6xt75WATFMlSIodSZO3CI8mNC2HczBVJtPeODYQE2tE2flopKYBjjihP2E48SQOpVi+bThQ705KfbcmQ7pTJAcHZolxo228ARcIe37Hl+RbEZO2POn4jiNV0P2iWUjf49UIAWP4/QRY1Mm16y0Ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275316; c=relaxed/simple;
	bh=TsRpyqLHrPjPcn/B+DCtWxQq3MNPi8bWFZgdBhybqgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UfZm2CxwhoMdUE+8CSKEJ4UkQxZ8H88zaIq0/Wkn8bUK65IAyUdARqn+SdR94XKtpNoA0rMt4UxrkDUYIevLTOarvUoVz3CTqOprS6sjHzSYGpM/EDbm1V2muhiaohkLIzI1YG1Cc67OADrhD9GDnPaTt/vYGLc+47TvwceSRQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Zo8fuOnz; arc=fail smtp.client-ip=40.107.44.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Zo8fuOnz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcUZ8xvwpImov5GgFnp3soMYtWfH4+gR+DOBM1Dob6P83dDkoqk/7so1QhUPQpx53FkNmKSG6FmM0SvpN6XmR/bZ/8htAnPSA6DWnD60QHOULAEgx02l/j+9x+T9zNjUy6NhX3sPMqplZvpUjrQIhR7w5/dswXcJu3KuNZlHfD8ZUZP5p02dUo6SggIiRqX3t1EPOZdywPC1S+jh04cgfO9hocgG9FSqZeuukP6mSNTKrMraVfRfofp9P6hvI8Gw9EelPq+Siyc+wdYl0b4oIXFlAcx4plMnsl8QLqj/ld3fgHs06OSnyBBYArN9l0kFo/SrmuW3GBHOud0ga9UIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACko2jIklcEFLtPjiqT0xhlckaB5B7kVy6Xt9x8cUms=;
 b=Y0mWPBXv2o4n4Bo2xCmwVE2IwzcWRFhFKWCbNlnFVzv/ncNw6HR+oPxrl7lKtoV+/pqqzUzWovD+dlVw8L86SCInwMQWeU44P9cQ5ySqVuBJioaOcf3N7f/yEn7bAa+XORNdVrdAH8KoA6kDKRuYNG0dmVgO6biRp2G4bIPmS3PbNdn+ErHp3auOc+RjDeMjTktuhW0Gqb4VOHg+h8MZF1lrhNtNkuAKvFsNZYy94xsGoBplk3JPVXUM3FtcCyciDuy/zQwUrKMTrrnnGhCYn9mCCz6TAIIDsmpWV8lzprYjs9QjDB93SeOMCliFrRkWPoYFP7i5hXWzw9B+FDw2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACko2jIklcEFLtPjiqT0xhlckaB5B7kVy6Xt9x8cUms=;
 b=Zo8fuOnzBq5dUTDbEAnJvbtHiuxDDfKU3nLMHR2+x1vzxp6iZza+Uo2XTS2zx6euLMNhu6jCwqzuj5jd+NSy5SdeRETWPNmXNGZu9KHUJG+rWLPTm+sDhh0jfVu9fW95TlHJVCTARTdMvfbNwpJuSirdS5LsOS+Cc9gtcW0P6gO1oQ/59+mMECqTUF+AnLUQcTviwev//2icWVb64I9Q6Fv0hQIthyOy4rArHi5cdLEjY5gr3YLbNZgS8UjdtcxTQWfFAN6sxwl1lU2jY67731ojSThxltmcISsuh3dS2FschDiCOmzMVK3AV95PhQdAir4mzsaAMCMFvkRFtNploA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:51 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:51 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Microchip (AT91) SoC support),
	linux-kernel@vger.kernel.org (open list),
	imx@lists.linux.dev (open list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 04/12] crypto: Remove redundant dev_err()/dev_err_probe()
Date: Fri, 17 Jul 2026 16:00:18 +0800
Message-Id: <20260717080045.191538-5-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717080045.191538-1-panchuang@vivo.com>
References: <20260717080045.191538-1-panchuang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0054.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::18) To SEZPR06MB5832.apcprd06.prod.outlook.com
 (2603:1096:101:c8::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|TY0PR06MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b7a9b7a-1334-42ef-fdf2-08dee3d9a8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|52116014|1800799024|921020|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	W94MYB1Vdz6yEJ01V0QZ49LJ82bjuDS55gLCNYUzK/ix4+o7jLDT8w8xdtZX/eusYXlMYHF82ZgVrUSPdSSCKgSIf4jmrwgkKP0V2570QFaom177zx+9m3bu7Nss/Ce5s7gvu5obFE0tIckG3pMf8jto3jagHQCvyyzKDlVDJ6xEdA+z7oCFqqCJXRXULgn/fuUuU7LqM3FDumZMWsnPHwAIINzSqVrq5xg90Cr/f1urAvpx1a/8ui335CZVlBfr4CoIJpDBcz8fU5mruBVRFvv+x4e4ueUkBk+lLB/rfyENjMqpv27yq6asVL1Am7GNnjj5uv4brogxeWssxOMf32jnRaoW9r/CVomODMauKaQYKzxNKbPrq0bIF1EPHQUUHpHbGIjE67+ZUbtU75D6ueuY5lgnsHdJRwGqkMBuELASLbFdBHujSsrSMkwG4rO0UQedswzCvTctRb/cPL8rUE/bvgAkyPNkyJSXxRP6pz3cBiT6zOLuRuxCsf+cK+7jgeYK5MT27beJbuEMt9UwXQvrzL09SO+n5YMA/aFMur90B3Cjh4BEGoxXIBHVJlQRL9tIyxXhFz695G8lTjiEUOEGnpY2woMDKfi7DwPtV/2jwkSICNyTz/NV87J6We6LhYfIQBFWV/iqEBiqCRDizRO3bAYEB5droy7Cu61L6sRaQfghl0n+YR3R+DtAHksFzn1ByFDn+NZxVkmO2wWHEni9AY4ny8L/xYh7y3jLKwHpLbWfV02c6nZeyHdUT1oj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(52116014)(1800799024)(921020)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LbVJxforEz4ARKNHD4u/8WEcnYYIBhHGnD4bV4eeNGyaj88p67Vqdxu92yy8?=
 =?us-ascii?Q?Rn6QZ0PC6GLVlKlTFVJ653/FWf8ictE5ZjA7IuTud6gom4kzIoSUsBrHeYmE?=
 =?us-ascii?Q?/VOo+dNJ53VgFpirA8HiLnyr+17ukPzbjd1TAunklNWL/nzpP57b2UvTv1Is?=
 =?us-ascii?Q?rKwTOyioIXZFZje6j+O2hfhYDkZNib3hmPaNKK3niata3TZZlN6QJJfBebDs?=
 =?us-ascii?Q?sRau/VPLE1VdfsphxGhMQmcnT2gkZEtBrXcox1ZrSOVUOAwPvSNQmA5Uua1H?=
 =?us-ascii?Q?Mq7Gphs0gVQv2pqFbiq8fZkuDm1EPdJrBhtium8mSt2X57cFl0Uv3wjAi+LA?=
 =?us-ascii?Q?bHbuSZWnY0KV+f4ng978jfBJCEaS/5Uo+mSPeUbfoaV3bSgVd1o0+dH4P7pA?=
 =?us-ascii?Q?7oGAoTs8n4SgDMFfgEC9fNMdJlC6hdjIisrt/jR+u7/g2l7sD/7F3lA0YWCZ?=
 =?us-ascii?Q?3J/OGDDhDg0ZVRn6QLDRMtNIJDVdqiKxwYdA1+YLHW+16sIRBjRGDcTa3eCj?=
 =?us-ascii?Q?HV1WFlHxYbEa+cMORDeYx06l8EuWtknv8vGAU21lYj+wcZhJ11p/n83kga7V?=
 =?us-ascii?Q?bhrwWCOFs22U8E0AT5SJHaIMPYToA87PRvbXpzeguGSjtKcb3z2Dj9J6zKDb?=
 =?us-ascii?Q?AB9ahfQjvjfqY1uskHt1/Gdas5e4Xu8DVhH32kuvmZYhz3QeGaqfLAKugVrr?=
 =?us-ascii?Q?zFu6zgrBB2cARATvw/KMFzz3TyBhBhHVSDRQiSms1KV6GiFGd4QKYzmxBDQO?=
 =?us-ascii?Q?IQEqmNgdQI5hI1LFSJeGW+LEZZmSYWAXf+FON6f57Cnl7RBChP9LFdrGfBv/?=
 =?us-ascii?Q?Xwj4bF3HGKokyOTGBzC/KVUptfF9G2xlcUKg1vOXActEwsSMSG8NbaIEs2VO?=
 =?us-ascii?Q?TqpHXhqRC56eGjfy/VpOvgNuqOZGY8lJGthwU1e9LSU1xk6dikW4wNPOnCOJ?=
 =?us-ascii?Q?lSeZrl+UxcGVX2WnPnBnTv0ecstgO6WI+EOLk5XOfcDJu3R2KHiBFQKpil6l?=
 =?us-ascii?Q?KEodLz4dOLU+J6mntkCxw5/O4qoM9mXTUneprebf1bbNzQvmbA8XNuLTO8QA?=
 =?us-ascii?Q?oytRo71bvVpPDlE6i0pRflxadYBfNEYisXMSUZCWoEVigor71YFb55sjddzg?=
 =?us-ascii?Q?nCNM3b2G3h1ip9q8kaOtHczXZzz8rFkFE53Fr0rtFyOzoHoTS/VBYDqV+mHN?=
 =?us-ascii?Q?GOswDXpGW0r3vq4bOVyTDAZC454Jp3zZ0fk+4srcc7jd29rfPL+3vkIpeJin?=
 =?us-ascii?Q?KSc9100weJLyTlSDGeLJjKuwUZYTDjTNdpDYiyklLlkcspp0tVt9xdpa9D5f?=
 =?us-ascii?Q?1nEJnHWBM2RUz7EKu2vSOSujs8in3YLRvPg7AASf8qkBRKlCRw6j+rEXkm8H?=
 =?us-ascii?Q?kMCcD7u07OmwB/R3Fg55JiC1wAYgRgNwVU6Kq6RNorX8D4GOHHm1D8gEqgvr?=
 =?us-ascii?Q?0DeXuqy+ileku2mlXQ27TeGC8hbTeZ3gphYrg6DipBrCH73/R5ZpgP9jtVEJ?=
 =?us-ascii?Q?hZS3ShbN+z5yTsdiuenSuU/w/iGTfyV6Cc3seC3kMlWGFEY8Te4jP1/sO8wc?=
 =?us-ascii?Q?PdoNlp/t9DrSl88r6vEtYOfO5lX4XS1HiggZ/YbgMKaxfsVeKYPwo6kp7vxF?=
 =?us-ascii?Q?AEMOxArZJm8Lppq/9VOvtUJXaR+IZEZBREZ4vkit3Z3DFe6QfE980XGR7kZs?=
 =?us-ascii?Q?aRC6LrSBNg5oHvVpbynv8FZEWmIcBrb7cohdPUwzXFgnGx45AaykSOkEcSI2?=
 =?us-ascii?Q?ZLJpIkeS5A=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7a9b7a-1334-42ef-fdf2-08dee3d9a8ce
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:51.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCtefbXODrXzqKrQjyPIvozNuMxJ6FSHQRcjTdC30Zg37z7us22XcUA+HY2w0lEXrQobrnjUizSjnIkA6zM3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() and dev_err_probe() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/atmel-aes.c  | 4 +---
 drivers/crypto/atmel-sha.c  | 4 +---
 drivers/crypto/atmel-tdes.c | 4 +---
 drivers/crypto/img-hash.c   | 4 +---
 drivers/crypto/mxs-dcp.c    | 8 ++------
 drivers/crypto/omap-aes.c   | 4 +---
 drivers/crypto/omap-des.c   | 4 +---
 drivers/crypto/omap-sham.c  | 5 +----
 drivers/crypto/sahara.c     | 3 +--
 9 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 30acfd937d54..50d97cef75b8 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2364,10 +2364,8 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, aes_dd->irq, atmel_aes_irq,
 			       IRQF_SHARED, "atmel-aes", aes_dd);
-	if (err) {
-		dev_err(dev, "unable to request aes irq.\n");
+	if (err)
 		goto err_tasklet_kill;
-	}
 
 	/* Initializing the clock */
 	aes_dd->iclk = devm_clk_get_prepared(&pdev->dev, "aes_clk");
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 66323ac63406..48f54b615504 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2604,10 +2604,8 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, sha_dd->irq, atmel_sha_irq,
 			       IRQF_SHARED, "atmel-sha", sha_dd);
-	if (err) {
-		dev_err(dev, "unable to request sha irq.\n");
+	if (err)
 		goto err_tasklet_kill;
-	}
 
 	/* Initializing the clock */
 	sha_dd->iclk = devm_clk_get_prepared(&pdev->dev, "sha_clk");
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 48cd537f001e..4511166fd74d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -978,10 +978,8 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, tdes_dd->irq, atmel_tdes_irq,
 			       IRQF_SHARED, "atmel-tdes", tdes_dd);
-	if (err) {
-		dev_err(dev, "unable to request tdes irq.\n");
+	if (err)
 		goto err_tasklet_kill;
-	}
 
 	/* Initializing the clock */
 	tdes_dd->iclk = devm_clk_get(&pdev->dev, "tdes_clk");
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 0f19dcc2f388..1ccfc0eccc73 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -966,10 +966,8 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(dev, irq, img_irq_handler, 0,
 			       dev_name(dev), hdev);
-	if (err) {
-		dev_err(dev, "unable to request irq\n");
+	if (err)
 		goto res_err;
-	}
 	dev_dbg(dev, "using IRQ channel %d\n", irq);
 
 	hdev->hash_clk = devm_clk_get_enabled(&pdev->dev, "hash");
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 595b2fd84667..c75a06999787 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -1085,17 +1085,13 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 
 	ret = devm_request_irq(dev, dcp_vmi_irq, mxs_dcp_irq, 0,
 			       "dcp-vmi-irq", sdcp);
-	if (ret) {
-		dev_err(dev, "Failed to claim DCP VMI IRQ!\n");
+	if (ret)
 		return ret;
-	}
 
 	ret = devm_request_irq(dev, dcp_irq, mxs_dcp_irq, 0,
 			       "dcp-irq", sdcp);
-	if (ret) {
-		dev_err(dev, "Failed to claim DCP IRQ!\n");
+	if (ret)
 		return ret;
-	}
 
 	/* Allocate coherent helper block. */
 	sdcp->coh = devm_kzalloc(dev, sizeof(*sdcp->coh) + DCP_ALIGNMENT,
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index f31555c0d715..711909de2013 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1172,10 +1172,8 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 		err = devm_request_irq(dev, irq, omap_aes_irq, 0,
 				dev_name(dev), dd);
-		if (err) {
-			dev_err(dev, "Unable to grab omap-aes IRQ\n");
+		if (err)
 			goto err_irq;
-		}
 	}
 
 	spin_lock_init(&dd->lock);
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index dfaf831dd8ec..3b7104cb4487 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1017,10 +1017,8 @@ static int omap_des_probe(struct platform_device *pdev)
 
 		err = devm_request_irq(dev, irq, omap_des_irq, 0,
 				dev_name(dev), dd);
-		if (err) {
-			dev_err(dev, "Unable to grab omap-des IRQ\n");
+		if (err)
 			goto err_irq;
-		}
 	}
 
 
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index be1ac640ee59..8f95c381f4c8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2092,11 +2092,8 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(dev, dd->irq, dd->pdata->intr_hdlr,
 			       IRQF_TRIGGER_NONE, dev_name(dev), dd);
-	if (err) {
-		dev_err(dev, "unable to request irq %d, err = %d\n",
-			dd->irq, err);
+	if (err)
 		goto data_err;
-	}
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 533080b0cddc..d586f1315de1 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1305,8 +1305,7 @@ static int sahara_probe(struct platform_device *pdev)
 	err = devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
 			       0, dev_name(&pdev->dev), dev);
 	if (err)
-		return dev_err_probe(&pdev->dev, err,
-				     "failed to request irq\n");
+		return err;
 
 	/* clocks */
 	dev->clk_ipg = devm_clk_get_enabled(&pdev->dev, "ipg");
-- 
2.34.1

