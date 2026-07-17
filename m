Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012023.outbound.protection.outlook.com [40.107.75.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2D3DDB17;
	Fri, 17 Jul 2026 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275309; cv=fail; b=RZLAn94CLFbxEEb1f6q+EbxzPXgBSRbBmljiBpV1TwGFqLxUinHLS8BdGsxB/KLCvk+a/AYfd6MJ9R5x9jmWMNVsFB0+jSdoUkKJF//zIa7RNokmQUMrVDC3Ej/xdNs1RbnzPDIFue7s1jZCxM292ftPXA+dTszahOr6dQ2/0mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275309; c=relaxed/simple;
	bh=z0j4pMpf8AMUEOBdOXlAHGpSejx1PxUu8WZNWRkiPyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qbBrSeboZutbXihy1CW4rjSKZPv8fMKhUd7vNAfEpOl8xirtCysKFiZmwsYKOV6TGxgvfZD3/8ckdkJIJZUjFKy2UCGtqF5YeBuolTGqblBGRBSgexxZ/FZNxLedf0jglh3rvtnpvc4TWuetrorHowBk/yWtVGDu2miu7ioegKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=hGxuNLn0; arc=fail smtp.client-ip=40.107.75.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="hGxuNLn0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWw79ccI5dlmR26+I6VnBMRtKkCXJDiiicjyghnclR1HX7B8kDApB5PvcqxS9vlGERXyXnuRq/0OePTgy7asQT32arQgaYdPdrKywn9E8Mgjv0QwdWbEjAGT8QFG/+ZiRxZE+W7Z2J8GRISX53HWOPn2xtrTU1h7l6KkPge24SMwbbnV61aVqnAo1lxsVW/n0YywDY36H9xiBSMZ7eTV1jasmju0Y+8EfdBNaWFuokpyHuf31psQx/86BJo0ZX7f5ctaoRJOrMv9WG7aksZPO0j8RIHn7/MUylTjYkY0RmuePtdmH2nfzjRL4ioTgySxjxcfd5mPMVyUeRsoW9u9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2ZWx2Qgne/dk1qksuAzWJa/FsaVJcRdjZm9ploq0DI=;
 b=dn2NRUCI6ilA6GqwqdGk8f2H/InYVG12CQgCH72Jre8HtqOaDUlxG0XLKOkEdSOV3iWav7iEVZNcdu7Gd4o4WRvE9gCRnoS3SPnedGR6EVujqD7P0wthe7L/a4DlO5YTW10Qbp1bHGfV1pUiGLjAypM1+Kg+a8SdB8rlHpCiBb6WSwbGXuTGBbi2/mENFBzEQCGaGyrrgNfKjjOhT/xXo9L4HYg71uMoHwWIgNH/wiJbr3/DbBkQIoVJ0KX9SE2NgUjM8xN5XPPZM171rCMldbrEFjz8mz/o4eayZr7EPd8dopjam2hvOSnsLdduILIt7qPpSmsispHh+SZK5hK0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2ZWx2Qgne/dk1qksuAzWJa/FsaVJcRdjZm9ploq0DI=;
 b=hGxuNLn05B76lS2gFUMB5l8hbB3yAhn5UStDnHPicheTBZYeVOhWus7yF3ztXMXLtuhmEqNQfAmSL4UQefhTmeXz8hd3BmmDPmlZqIgiILcKrTbsEnT4b8IVYU0UMS++qA0qUfqw1l6MrwROq4yyz1aHMj0rKVR5HFgxjx18l/xDGlw15Ez1bJDm3UMl6hJXjxbFUI6q1koClGjCqoDRBCNfRWori+d1h6xbMcQUvbgrvfZNex43AxZ9OhBIQIrBQkwRHwLzW1OTlSMjNU06oMsuMp8+DjChPesnu5BlsKJ3XO+gcNlcrvcYJvlqKfyq5LXFVW/MUbdWYKmVSiRhng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by TY0PR06MB5104.apcprd06.prod.outlook.com (2603:1096:400:1b8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:01:45 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:01:45 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:ARM/Amlogic Meson SoC Crypto Drivers),
	linux-amlogic@lists.infradead.org (open list:ARM/Amlogic Meson SoC Crypto Drivers),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 02/12] crypto: amlogic - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:16 +0800
Message-Id: <20260717080045.191538-3-panchuang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 130eea43-21cc-4cf2-8639-08dee3d9a52d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|6133799003|38350700014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Kc7XXPUGXw9EYTawJi/vEglGlCBz2lhgscUKFfaCrqoSwh6A1jNPvVcxL3+ZDO4IQwFdFUkZwGGPfgeR2HEQiBG4xbxfmBi7ttTnzb/4ULSdOvQzZ6H1VmFCfIQQsgrvZu5zMLVXxpBNCgv5LWhG8i6XRVLZSXSNL5HKXYByjig2SVzr3dotwE9ZZ02n+6nXi3IDw4TQIzwGyST6AoNSZo5GWg/vkpumlZb926SBzH0ufwB+qzaZHqmOk4oeyuAycKeL3WtrEII7df+P/ijO5qA4qNI6Ayah6W2a/UoVEIPoj/L25juQxQQkZCTkEY7mflokXdeEJG62AnYSVfqpwMu2ZS60sreD+T17Dg187ly8bkS1LsuyuIvqRyA4eTV0OMAKosSkc8bVTmI1Wd5leRxYPxIQOsQ7cooSiSieFEruu33NIksQgjFr9jeodkse82bs8E1GQsHlCsjEPfaRp53UiWlrqRl4cvU0na/J04MTXC15JhsF+x8Cq6FJ4FsfmSj0tElIEdMjdrpBQExonto87L6u/p7f046sKD3yVhLOmTK+rSONil+ydct4wfLNOBCNEUxlHADQl04kUXlu5s2Fw+9589/r61EHYB/3jH52vD1wugtu2SPbAkQqnaqkrAnvjDj8D/Suo7JGXV7afGe33zkjEAdNlKzkMPGJ5e8r6gbWVNoEIWsdcPgXtgeNDk7+YridsEYz1nrhsNo3i8yy8peCVTJQurMOWnfvEDU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(6133799003)(38350700014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gfi5+6lpP8mB6/OVewfiWz55xBNec/Qr5y/c16FK2MoYMwNAsQKmgLrHVxO9?=
 =?us-ascii?Q?eO1akHkMMSHog9ZqNgKqZEzQ5Yf1jEcIeXMGgfLG6rRm74puQUVVrDGnBbjs?=
 =?us-ascii?Q?YmzWSNez8BF5sv4DAzvPd3qCekXE3pKkAcxpKnrscEPe/k+g3QyRzr0QIMJ/?=
 =?us-ascii?Q?ZqJfosrBhVwGvEVP0yz98BDhbmHNvJR/jW8a4kHh5SEfscDMZvmscOqV5RQ8?=
 =?us-ascii?Q?/TSVyDrqPycLXDmoIurTysQ2uey742FPXFcgk2xiX2dvX8EQ0qTDL4LzELYp?=
 =?us-ascii?Q?eCwAqrqnN2qBotuTKBCZMIcYBlDGiw2mBqjOf/i3CIDApbw7fIjeOasZq3Ty?=
 =?us-ascii?Q?eRtjNtH1D4fExhuE6s8VsgoBTJN8IwXC0hV4hFz+u4vsctnYfV9/QShANqAO?=
 =?us-ascii?Q?evypOkV7n+xlQFOybnEzrcpNTS7seq0lCnHdQvY4daIEFwWMXu87tEcc2Np9?=
 =?us-ascii?Q?/SLVSLqiM3/KP9Ll0oPVBu/SiYVzK7c/Ap/ZkoYRJWBBmg+mAwM8IIRNU7yA?=
 =?us-ascii?Q?fchtujRcg4KBJmewU/Z7qh/Zqkq+l6c3xFkRa1vvx5g3Hstvw/KjLXzzIqK3?=
 =?us-ascii?Q?ieYqnuPt+ZzaFB3TyDq9yuKBetaMTpV2NdYASYoqGTrOUFMwYtc877Meip7V?=
 =?us-ascii?Q?jbKzqyCfvNDkREyDeDwFQVVUkeb7bocz5twtdMSDW5n6zYMVPvBqdu/Y4G3w?=
 =?us-ascii?Q?00CYEygTSHtanUk6u/i5ryeO5J33A/znAXakZqI3FEPDoSRtJtRjZ8732Uzz?=
 =?us-ascii?Q?F8NhiQVbqEPDxKkKy3LXJSLOplQfdTXBLUMhukt1LQMX9YiwoEQWqaXJ000J?=
 =?us-ascii?Q?hb1LmFR1sXre0xmAXiUDanAvSbFM9BaNveB8zy0E4lJBJFvsjo1Q6ZzRukkH?=
 =?us-ascii?Q?RuifapQjgZC/NJ3nW59oh67bAiQbZvq59z1yIBZY7vmy0frF9ZumzLgA9Oqw?=
 =?us-ascii?Q?Wtbtb62SFR8lbkbVRvvW6JNKbj7D9MKxNR+8lZM0k0ZeoxMjOZtYh2vWhOC1?=
 =?us-ascii?Q?y/v1/sVU1wKYnLDhrQZZVvigZV3ayWK1IEHR3sSeUT9aRbtgklNWrmNSaktO?=
 =?us-ascii?Q?d0BJfdHr7KxxEZSqgPZMfdpWYmgADkJ7D5/K7sb30pt5YDTI0q0/IV/ORzPQ?=
 =?us-ascii?Q?fyZ9LcVbPPH3NbBPW0bUh3deefs8qCDuP++Nl/OuvyUs8XSQ7iXS4P0svzDg?=
 =?us-ascii?Q?UR08pOrx5OhJkk5QFkZcBCohkZ0n1nrQt3fcA3t4rSq4yO5VaHaI5VI9RsKk?=
 =?us-ascii?Q?gy7nD0WB57nPGtF1VFgKg+hkl1MDylA/iEW5XgubYqNbQo29CrgEts48jmBd?=
 =?us-ascii?Q?F0t9DhP1/T1wsvMr7UjPDzTcPLwgstHDVrgzXw6EKxGaBvWtgHrIFfFIzPXF?=
 =?us-ascii?Q?8jyWNs1iaL3QY7yeb/D9Z8CBFbMePwuPFoMePUxZiyiTTc+kc/XrnixxFN8b?=
 =?us-ascii?Q?EYbitr7YpqhYmzVGJwQRpnQkX/Y3IM5yWnmekf2oz/BdBpf0scxyNU9hPl1d?=
 =?us-ascii?Q?2nn6wQDlPctClOQ49fl5wtLN/DrohqWDLC0D9xMxm0NAwRi7RB7qPYaTwgKt?=
 =?us-ascii?Q?VOCF2Zow+ALyaHifBu4bjUdq0+m7Ii/xByomvBrGuoew75Ak3PL3B8FDK9ie?=
 =?us-ascii?Q?uTlLQCq2Eaycu3IhjgIGCVaAW5gpnzOoN5N1lThJMZ4B2TLbbHpDXH6z19mK?=
 =?us-ascii?Q?NmiaREnfWZViScFjIXnvj/CnAIbbIzvgZ4vg6JULZnaRD5W0pgGRglDCpu8Q?=
 =?us-ascii?Q?LRS/L602Qw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130eea43-21cc-4cf2-8639-08dee3d9a52d
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:01:45.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GOZveLhApB1NcMWhf7BCYTcYfVmjQqquq/+1Y9Vmv63kucgFdQdTYmp/bqW1dFrOixeL7d3qx40MRN4cuAYqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5104

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6cb33949915f..169c6eeb51e5 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -257,10 +257,8 @@ static int meson_crypto_probe(struct platform_device *pdev)
 
 		err = devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
 				       "gxl-crypto", mc);
-		if (err < 0) {
-			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
+		if (err < 0)
 			return err;
-		}
 	}
 
 	err = clk_prepare_enable(mc->busclk);
-- 
2.34.1

