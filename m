Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012011.outbound.protection.outlook.com [40.107.75.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2532823D283;
	Fri, 17 Jul 2026 08:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275302; cv=fail; b=jmMl4l2aLzoT0G3jfgB9EDbtbRWaNYYqJSFNylDHRIbYPNk8kbHIFAw5grc0/Zv4Z8F/uoPtdFPhNysyV6UJAKyDXdX8Z6zfp5JGyXzZig2TZzFEOO3J9YfJuO9E6YlvUA5qksGoz8KlHFdhuI6HfrvTQYlEIm+PkZ1vys2Iz0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275302; c=relaxed/simple;
	bh=h58MRY5rsmRwaQrVOtmyrPjCbHX7KuDrIedgNZSXiaw=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dtzB/OaguywJRkbI/Hr1oA2kdjaQ9AWSvj/I0NivzL5Z3T7qDAASQm14ap7qgY9qvWgWPEiq+LaO/GULQ2lVEii7oN32WfQXRcUyCpipSAQLr7+ZSDiUGeeOIpAjwqotkG6CCmuir9b/Dzjo47fte0Vq6x80edptcB9po5EFyWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=R6CTc1Ae; arc=fail smtp.client-ip=40.107.75.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="R6CTc1Ae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUNsu7v3dNmEGdRmrCIH961da77AklCaqAFfopFfRmvTPS/uVUIK6vyrEDFhvmXXsN6lynZ7vWcJVOtgh6BE8Hh2SZig4YIxpLm3mcJfOr0GZ/f564t0+ligmqxW627XEeSZkkdpR/MKsdJLoU0OC9HkRj/veKeOLhO9ybAoUFf/Az9kgCL3dhZX9jhH2BqdJFcj2P32o5tz0tEWkIqgMTKi8weIrCuw6i5TAQe/uLsXoll6bl4ZBVMKnIEzvetx5Mm1W+iLLmOHj4Zpx/V1+Tl6JaXIFEoqt+J5Zq++VIJak3z/2BvK2LrN9VytP17AjdVCpn1zTx/86GfpYNWk8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MCo8v2+T6if2n6tsHrJXX5FivAvS8l2QmhjT4NCrog=;
 b=oR+uLRbsF94MBwv+OVP1EGaaFOhY0HmiOEtR3+gP8dJGivhlqzKShrPBjfa87DMOXvQSD+0ajhCxSI/IOhkjq1IavBk2p18zXd3tQMrvUSaqraHwUVrEKc4/GH64xrZLuyvEXSk2p8kp1dsfCLNlbPFSRPj4EiQ2oXCwXxky4M4rv1pC+UR0axdEV3Sa3TvtfgJk10dH6vEaYz+Gkmy6HlP9BBf9QpurQF8MiTJG00AlkRWV3ppcFokiLTqCR45ssahgbpl+w5Ksyz6z+gyvUOIcmdDVGLHiaU83g/w2HEmhIY7kN2VxDgXkgQiVQqIHRKYREwaDtXBakflcgdddOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MCo8v2+T6if2n6tsHrJXX5FivAvS8l2QmhjT4NCrog=;
 b=R6CTc1AesVBSJsD6zMZ/8mmxenXq1OeWk0+rT1qbidxOOS7h4zMu/Ght541fjgGk8yDo0hSvu6osRYV2NDrLUxaDsKWZLUEMYWK+Ntn6bBx7/DFyrVzOESvBRVhdsERJr5FWU8ZnEKAsjQdKv5Vw14fJvAMF9TmyWaaLalYq0cqe1Jkc1vxxem/5dWXSTjdIBCaErQVZBR5QsR4bafvwCvncU8HXZYOBoDvz1Ux/zxftaMUF5J1S+hAv4TKguIO4bx9pNVyKLnJD6gQqPbLnozBf15fdgnagOoIr81tncdxpNjZjPlcNJflMjzHpU2ISMpvjM9aERNNDVMDNhd2amw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:35 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:35 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Neal Liu <neal_liu@aspeedtech.com>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Pan Chuang <panchuang@vivo.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org (open list:ALLWINNER CRYPTO DRIVERS),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner sunXi SoC support),
	linux-sunxi@lists.linux.dev (open list:ARM/Allwinner sunXi SoC support),
	linux-kernel@vger.kernel.org (open list),
	linux-amlogic@lists.infradead.org (open list:ARM/Amlogic Meson SoC Crypto Drivers),
	linux-aspeed@lists.ozlabs.org (moderated list:ASPEED CRYPTO DRIVER),
	imx@lists.linux.dev (open list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE),
	linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC support),
	linux-stm32@st-md-mailman.stormreply.com (moderated list:ARM/STM32 ARCHITECTURE)
Subject: [PATCH 00/12] crypto: Remove redundant error messages on IRQ request failure
Date: Fri, 17 Jul 2026 16:00:14 +0800
Message-Id: <20260717080045.191538-1-panchuang@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 81ccfe5f-a030-4375-dba6-08dee3d99f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|52116014|1800799024|921020|6133799003|38350700014|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	34dtc/qzKmODa2mZIzKVxc8EPzpyepLCrxe6387w4z3Zo9xVSc+lnG5PD+695FCCNVuFKvs+MUBKMLDVwMJV7w8HhT6MAXFPZ1MsDt1soiSAZ5tDo+Lmjj/j4hom5KmznByxBCcAjK0R/utcZkzw7Dd9a5fNakoXwB/26YwhlqHaSkh64kRitSZUWqhBiizoZC9x7zBm/ICRMo5zgV0KBJNl4MsJ9uvDhHQaUhspyDLpYIhzRTmPnaPmOAZqq1XfpwXdN8qUFy/2Iz0DbQ8+BWI5NJ+7f0w5ub/nxzKOh+dJ9sIYWfnA/8yxbtgg40a0XTa7sR8Opd0Ihxu0EliovffLN1Lfw/XyO3shItw/DoAh7VHuQEX3S7v4+r3eUNKFx7fuKk+Q1pVKnmc1rpboTtjJmc36uKwzRyscoND/qp3OuAP1ohCF74iGqEdEQxgnFM4lipEUJwOQob60lYGbLX8RJ+24qSKoicWfoR9HYjmz9TRnxkRj5oZVaFfLeyQDMpVpPmnwkyufv7wd0tyjQSoEdve4AFwr+B6fyF1rYoV27V0bB7+GrRLweHSoK1VkKFw5+nDb289bnhltj7NxLmOiacgXqzg60MpgmpJEMQNFRr7Ljz8M+vl8cutuSMbalbbx5qU6shjFscyIFaUXxHULYYk3QbuCv/ksfNCq5ARLy1t8lghmeuFaMiY2nTnEcg9XfG/4AQNA+yUlpicFO5/XwhsTgj1HrlzRNUfc6ghklceXdh0PVnG2vSOqlB4o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(52116014)(1800799024)(921020)(6133799003)(38350700014)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n6TQh2/SOT+FoAdpro+aNdpoy+yyCp/6A4aiOy7Sc9u8Zg6Pc9nSOHhwnlNO?=
 =?us-ascii?Q?2Y6ii6kYH4zSBgg0QwQpLB72gU85gxsoNNbyYVqK75cM1RoNmCWQ+vfB3Pd3?=
 =?us-ascii?Q?W5sVe35aqhk80IG5TrxAZq7elb/wJ6h9E8IPr6Ka1GpoGbcILkzmHkkLF8xS?=
 =?us-ascii?Q?lV3/BfImXulmc7iylm3t3IB4ib+2e7hT8cOR7cjZ5h3E8RdwUlc4yb0PhVqL?=
 =?us-ascii?Q?vFYs41vvE6ii2ySQG9e5GlbslqqX/ukEWppNDo5VK+R40tG8VDH4kOkqsW57?=
 =?us-ascii?Q?dADLjVYmS6K5neE9kmos9W1H0uCsbNxrD3MKDRRuYHhKiX7QvUfzhlZA86xD?=
 =?us-ascii?Q?+YnEVIGwNcZ59pfO85AuorAbb2qZCCvPDRFmd3DTr7AqTka4wkhCnTrw3wwN?=
 =?us-ascii?Q?mArm2eOJ1j3wAELnzlurvTUrZdA/wQ9zOhhIyMeNeg8yDwItbm9C8GtWL5dc?=
 =?us-ascii?Q?T85LizYlkmN54QBS7FQYjqx/GWSkaC5SfR/0WS9UWyDSjEwVkWYx+5Stm2Th?=
 =?us-ascii?Q?XIciTETf/N/08+8TMmoC/yO+0Y2fYpk95DGK1k0jx7irJkUcznqhUPkVk2W5?=
 =?us-ascii?Q?XWCcSGSYnZu8BEAJ5e+v2R+McTSmpzMOnPQ1r7E771vloum9QBaGTuwEELf/?=
 =?us-ascii?Q?nfewV7u4GcaTyGgbkVkc/rowZqqBVzBnOJjFPdjSqSsmRZa/4oVRNn/QjH29?=
 =?us-ascii?Q?1r69rNTQxsXwL4EhjiHiGFUkXvOu4er3+O5/6DJN0T3CiwCDaDGqdvIRnWi3?=
 =?us-ascii?Q?8rOgqGwgEEffcbLdY9CsKL3bn8yn7rbAztUVg9MLmDA+/XyJhV2Q7VQ27OtH?=
 =?us-ascii?Q?8djBA4AdTzxKcDL0nvkCPD1lOES2R+dYUSsiTQnKJkjc8/tEMlMdW+cefpiV?=
 =?us-ascii?Q?V2B/9oJhntoQTVTsmC/Lo1JkrJXPjd8qtajk9m9yzleLTK121YC/T/tbX4Pd?=
 =?us-ascii?Q?nVkjaOPVeuGwaJ5cQpNCRf8m3KezNQdyy7E2/izP7fYqmplxZYIrmfIBuwyf?=
 =?us-ascii?Q?STP3vJ5E6JvJPDGPEaepaWrBQM88AG0/JOsZSpLyK3nR7q0TCgHWOwJ6zoI8?=
 =?us-ascii?Q?sN6f5xPOwG1HiOh94HngXc4rx3myTlsfOx7zqxrLGz3tn7EYwvgyU2SNSTI+?=
 =?us-ascii?Q?VxRjGcURZ4uYTVKi9Z8vBjjDoFDaAjRYgUXQ8RooEKmQZrKfHkjE3mxwLhOb?=
 =?us-ascii?Q?BgBe4e5DAhybIZRtKfttQZ7WQ6YkNz721BFYCMLXH+NHsJuVWTkfAbTofvGc?=
 =?us-ascii?Q?TfxxKI3hG70xcjd1Qkr+pFRbl3cNkWgxD3GO7/nKwdiGiZDy3ryzYXgtALEC?=
 =?us-ascii?Q?ySJGK33z6feMZ62njRmJqR/UEwyoDx+KsofdiS9clELHo6IX9GgRKhqlXFhT?=
 =?us-ascii?Q?jfNYMSMNh2iy88sosLfAJgoahSEXtABiqOtGs17LDNfz+rpYcPEF9mS/LUxC?=
 =?us-ascii?Q?nmVL6dmIy/fBhmshx8CxDnESNIgla7slHx3Sm9tsbqe1wFOPFPll/CGxWXa8?=
 =?us-ascii?Q?L2UNA0cXLrQaOjY/8PMRy+ueu9bTc4nMxkDJOlKe/r2iA1Ytj3vgwDpQZsii?=
 =?us-ascii?Q?89kyQOdjOU+3k/mUQlHsusNGuMijvPnzXewtZMcRlllFxTK+uTNqhern0GIh?=
 =?us-ascii?Q?//ynYVtEhaD9aqzwpIhZ37qrtyyjm/F+z/FjHrbObLrmY75W0dH2ZbzabLBF?=
 =?us-ascii?Q?VBdgsS6noAIqH0Tz8pGEMMAsSPKu/8ZAduFxtNGw0KOC3CPH9CWQd3y8xcYL?=
 =?us-ascii?Q?J3wZm6ZBYQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ccfe5f-a030-4375-dba6-08dee3d99f3b
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:35.4525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BscJEqqE/kOVHY9RaaBKm3rOHs8KQOcBMLOW1ZCpNVm9nd3wtICwdGsB6DFxbb3/mtswHwwRuqKZm06sHU/OpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()") added automatic error logging to
devm_request_threaded_irq() and devm_request_any_context_irq()
via the new devm_request_result() helper, which prints device
name, IRQ number, handler functions, and error code on failure.

Since devm_request_irq() is a static inline wrapper around
devm_request_threaded_irq(), it also benefits from this
automatic logging.

Remove the now-redundant dev_err() and dev_err_probe() calls
in crypto drivers that follow these devm_request_*_irq()
functions, as the core now provides more detailed diagnostic
information on failure.

Pan Chuang (12):
  crypto: allwinner - Remove redundant dev_err()
  crypto: amlogic - Remove redundant dev_err()
  crypto: aspeed - Remove redundant dev_err()
  crypto: Remove redundant dev_err()/dev_err_probe()
  crypto: caam - Remove redundant dev_err()
  crypto: ccree - Remove redundant dev_err()
  crypto: sl3516 - Remove redundant dev_err()
  crypto: safexcel - Remove redundant dev_err()
  crypto: keembay - Remove redundant dev_err()
  crypto: octeontx2 - Remove redundant dev_err()
  crypto: rockchip - Remove redundant dev_err()
  crypto: stm32 - Remove redundant dev_err()

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 4 +---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 4 +---
 drivers/crypto/amlogic/amlogic-gxl-core.c           | 4 +---
 drivers/crypto/aspeed/aspeed-acry.c                 | 4 +---
 drivers/crypto/aspeed/aspeed-hace.c                 | 4 +---
 drivers/crypto/atmel-aes.c                          | 4 +---
 drivers/crypto/atmel-sha.c                          | 4 +---
 drivers/crypto/atmel-tdes.c                         | 4 +---
 drivers/crypto/caam/jr.c                            | 2 --
 drivers/crypto/ccree/cc_driver.c                    | 4 +---
 drivers/crypto/gemini/sl3516-ce-core.c              | 4 +---
 drivers/crypto/img-hash.c                           | 4 +---
 drivers/crypto/inside-secure/safexcel.c             | 4 +---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 +---
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      | 4 +---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 4 +---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c  | 5 +----
 drivers/crypto/mxs-dcp.c                            | 8 ++------
 drivers/crypto/omap-aes.c                           | 4 +---
 drivers/crypto/omap-des.c                           | 4 +---
 drivers/crypto/omap-sham.c                          | 5 +----
 drivers/crypto/rockchip/rk3288_crypto.c             | 4 +---
 drivers/crypto/sahara.c                             | 3 +--
 drivers/crypto/stm32/stm32-cryp.c                   | 4 +---
 drivers/crypto/stm32/stm32-hash.c                   | 4 +---
 25 files changed, 25 insertions(+), 78 deletions(-)

-- 
2.34.1

