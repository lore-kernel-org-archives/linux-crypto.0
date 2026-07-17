Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012058.outbound.protection.outlook.com [52.101.126.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB01D3E51C6;
	Fri, 17 Jul 2026 08:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275338; cv=fail; b=pE/XGs0SU093ew2hrc14dxjEEMDQylmK9oJPa+7t10jj2vx7plBSFGOqhrxZ3YNtqaCGfHg/1HiWSPO1DujbGwF8Su6IexHmMxOpq2oocQ+VWXhN8GLFFhiZrI7V4voeDzR4A16b/pRFSClNWhxbJVc7YaK9JXRXouyGw4yt9po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275338; c=relaxed/simple;
	bh=sjFUpQV1IH27XgymYtsHCau6rMEgH/7AXnLjm5Lvc/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RzB2xCPnXSPhv6z6CP5ZHDSTE99w5j09JoJvC8BNnG702uIfsLFLEBqPph+guqeWckscoSPtflN/1EnbOzcVGwFSv8gNZRg5sPpD5phDHM9ZlSbpH/C4lL+SmzHlYMmQoBdzrzrv292jDtVr2EpxUoo+bTaOUnJ0P34wNrzL/kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=fpw3wGUI; arc=fail smtp.client-ip=52.101.126.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="fpw3wGUI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7/0MVbE1fMqm/Pa+FqmHupG4aqfkX0lRAzevLPaellG76A6AGRGWWHP6Gfyx3Z3VV1YL/gpZ/PnHrTQiF0cGpRSuu5W+ycwTA6uvsTXrSiKQFjk2H520gqAw/gBJEkeRtE4acM+qIViG6milvAxuCqW2Hc7xhmwAuzQyTA8fq7Pxs+w9OVrJRUK4ErPTmnn1yHxueBMbgiqiRogID5HmRVa4SMLUIfvAydJz0mVah2A4414e1R07bhiwIW2fchxcUVkTwDcAK+U3AfXPpxK0ML+gg1ytZTxsaTlCAnXqOJgRs4EnuyLh/QaLaVhjqg7mXAfwX1+KCY0tU6MZTfpyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ph7XZ5HzyrrdWBRpy0FhcFPZxt5xGUHGxaQsRJCDDj0=;
 b=YnI77vYKNpYe4wosoR4gdEswl6yGyKuxlc8sLJ3Ylui35JpAdKQoT5I5HqeMr8b7eqCyGk/w+lQo3vmxZSvmeaJbyM+taC8X2kFhHJiv2eqAL8xchFR93wpl4GdxB/2Utb75WEpiWBmE2z/qqkx58yc7VvsvqxS7gBxzGdQArrJRBjJtQ+iqTg9g8KGr7n4OSsxsNFobIK7yPjW0U8WaIqlLe4w4dSNuNdI9AJZ6VgNBlU921N0UIAH1hxMmSBACRVLjE3+F3Woeu+75hakIdOnGYJPqU+d5/pdeYOaIFzYQfqGaCzl/ygrR2Lj0MC6XgilQtUcJwOFNFYMZ8GzHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph7XZ5HzyrrdWBRpy0FhcFPZxt5xGUHGxaQsRJCDDj0=;
 b=fpw3wGUIthu395NYJJ1RfRzxGULh8/FrQ7tv51j/X6FnmJZFp4mlG3u5htWbSAgQBdcbxRc3DQVHrcqxTq+QoT9jONEk9vGkT+WHUO0KOuPwK/Q4evxwk5HpHDyBBIWCyTMUURlDgE4PzPDU74rmfHffahASJzJdg6/z+WK29EdnSDbpfjnlTqIOTXT3tdhDn4WIJMxWC6bTvRW3nX23ln6dcdE3go6f9IufznsUEdknEO5mUkKeQfNpCLB6iZdt8j5sXA+aMrEcvICWQqdD46gF/awKrec8+Cp8Ny8TSRe2gwnuQOj4ksdVwQqvqqXgNz+FpMgbGhJkjlWInrWi9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com (2603:1096:101:c8::12)
 by PUZPR06MB5620.apcprd06.prod.outlook.com (2603:1096:301:ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 08:02:14 +0000
Received: from SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b]) by SEZPR06MB5832.apcprd06.prod.outlook.com
 ([fe80::f98:5e32:4ccb:d07b%6]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 08:02:14 +0000
From: Pan Chuang <panchuang@vivo.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org (open list:ROCKCHIP CRYPTO DRIVERS),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip SoC support),
	linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC support),
	linux-kernel@vger.kernel.org (open list)
Cc: Pan Chuang <panchuang@vivo.com>
Subject: [PATCH 11/12] crypto: rockchip - Remove redundant dev_err()
Date: Fri, 17 Jul 2026 16:00:25 +0800
Message-Id: <20260717080045.191538-12-panchuang@vivo.com>
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
X-MS-TrafficTypeDiagnostic: SEZPR06MB5832:EE_|PUZPR06MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: c3516901-082a-4ec7-5ad8-08dee3d9b69a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|52116014|376014|366016|10067099003|38350700014|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fvgElxIVVIbjZDOmkpl+CZTAMWWA1JW1+mEollRo+FrihmbOChcmPXlaQ+n8Sinhdq9e9HJINSn7nRMqgivEmITsMtgTtXA8NErIv1SLURaIPuWxXo1lWlyDQWrKosEyxrVzQryk8SajPH6lOreBJlKDm0oaKlSEipSst+Etgnbu/pkpos9KQlTgieIxDEfzIFwnfjwaqeeeF21NMZfOpeG89xtg19pPldsxvln950ZezZDoXfhA8FBDLUVUiAN1h63sn2xEBSktNBj60569EaUek8KFdt64bh5z5ByIFUAKm5j5GK3NHq8k11qtwwAAOr2XVoHxf7mAqFa1k/cLVjGfUXP94yHokjRcwlfK9JXINqPH7vIadlqQoyNYXdVHJMkx4V0nGtWJJMHVPTGNYG5P3SezGs9V5XI5kJRi5glIw3tQwG1P5Ac26C6DoGtwwhB2iBD0WJwJPfYOXebyjj9MHQxig55TJ9JQ/MFFAVeaF9CDS/INfRffuWkuwS+kxGgiYh3UH19lgY58QG7X1hpXfioMe32tz03g/T4NjehCHDp5BYN8QwCK5oCrXsDwsH8cBbskqdxUPahBj5ngtJ0myl70dWC6049hRBuZQq/+KgrakiAQy1iKZiX81rYPwGE2i92yzr/kmgKE+82XSMHhlY6m7Xs8SsoIUli7JJhjhRilEswqonyDw3qVCFGBiqUTS4LGrSV11v4KypqTuoJIkx1oLTvVRRCQIaD0QYM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5832.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(52116014)(376014)(366016)(10067099003)(38350700014)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5D1V5sHo0INUXI97KF6CoJWtd7kn/XWma3zNOlEXGIIPB8YKysstDD1NFhhy?=
 =?us-ascii?Q?gXyOd/QRI7SouMUqrMU5Ec8UWtReyEJYHn6uTH9xUmrD8PFEH3wLz4L9tPgD?=
 =?us-ascii?Q?6ijozz42zxFMZq9GxXYpTtu6x3Na24nRn7ssoB+f5g4CuaYMeYyGphxpPoxC?=
 =?us-ascii?Q?FTqH1uBj2ggeZHnSN73P5zRoiVNLIZxnN19abf6xxlDYV60N+sw282wAGyTh?=
 =?us-ascii?Q?YbUZP/F/HMDof8eFvjQqxxPyOcledkBfZVEMhKJkA7V3l8YPkn841WyviuR+?=
 =?us-ascii?Q?QaGEFlKUk1SRySO/iR4mRLXdyhtPPsAfw1XKbbAnAQoe0za9g7CQQsBaIJRL?=
 =?us-ascii?Q?EhobuT8GGttCwZNXdPhiY/ZmEybstWkkHFhMWxIxavuPAeTbTqxFeCrPZYfb?=
 =?us-ascii?Q?UYu7+clnkaVTnr+y112XwMahhZI3DfGglp2qZCt9KmTun43ml8+nX1V7X2pt?=
 =?us-ascii?Q?rdPYHNuDlkeAp2Or7kB8ZvgNNnrBnGQ66XgBDW26KcfJay1TJCJK15NxnxPV?=
 =?us-ascii?Q?cM+mto02q4BYCdy5Pv5TJCFhz/KpaY8eX/wXr7V0ovBQGU5ljqh5KngYrHlv?=
 =?us-ascii?Q?fCObtgPqZrpXnYNwPFa0CCrgvLb5VyBQ+5nkchpPJ5eb/lzrgpAHTLqqpgFI?=
 =?us-ascii?Q?aYnQT9dAKuFcFWVQiDJtjs8bSmz20l0d5yoe8uAcX6HZraSNi8c8aoh7y+v+?=
 =?us-ascii?Q?w//kDvBJSFlEBvV75Bj8YTzfSAmUAVbNqL2C/AFPzx55JnvyWKPvTed+YvF4?=
 =?us-ascii?Q?8RA/urO8fmiDZumHx6INi/+zp/jeNJX1l0ye+OfLQ3AlXLo4sloWULtqV4Ez?=
 =?us-ascii?Q?UAabpNKuvrbU5pAyBmOcgWaRS2D6ingy1NJEkuVmb8313r3XA3RbQOMgKwM2?=
 =?us-ascii?Q?okda5F0whnn0oUzDPR1+jrSHb6uKU7vFMxDOS3x/CSVbG6KVtooXd7r47tyy?=
 =?us-ascii?Q?NvADQIRJ8e8IarGxT6VSx2quJAeSQD0k5XRn0um1ncJK4h41xw+KOk2pZlvB?=
 =?us-ascii?Q?XhoiKUdGLYJ5YoWFqBUZKToqGu9xDcCos9/WXSRB356tuWe7urmM99FgNUMp?=
 =?us-ascii?Q?PnkLXjEJbnV9pgC39z6rNBzp+78DvQYxGwMQ5tEs+WnPSPON3A8D3zalryQP?=
 =?us-ascii?Q?xDJs0aWMN1TwsPW+O2rvRm7icWseNNORXTATQVcEsNgHHpBpiVkGKi01yQ7E?=
 =?us-ascii?Q?o1UL25JRLQ78a2Q6DAs/fdq7L7qkPRp2koCqAO+ueW7qd+q3PcLuiI8uJb4V?=
 =?us-ascii?Q?uqv8Gy2HIuoTWAvbm+33EGnnY4tMJoWqy7lpSGgOBoV3TNE62RnInW0dufyG?=
 =?us-ascii?Q?qbMJdslEAGooIlq/WWBcEvgo4X6T0FSBCSIQaXYq6N3xOGCf2XU7A7Hs+U8w?=
 =?us-ascii?Q?2iSkptlroncIUVOqFVEKLSqbyQbej+cHLBXcXp5dBC6fiSe9KsidixXmSyVc?=
 =?us-ascii?Q?JyC13gl/1ypfVY9Ku6UBNwDwQHKU3Pqgf/Pyro4tsJegjn4BltkGem36meL9?=
 =?us-ascii?Q?012YB+xQwcYNeuO8yqRcAyFFdMd9Z8dhAVsafFhNIw2iRBjzEIC+oFtgYUHD?=
 =?us-ascii?Q?C08yvhG5aFIjAT7dI6hHBaDbI8wUx1qmboNqc5h+dqZQ9YDWbRi2w43xaLI0?=
 =?us-ascii?Q?qi4hsbCm3rabvnJUbmEvPnoNZWXAu6CU5QSjgHtIglcVgLgPTc2Tnpoay2eF?=
 =?us-ascii?Q?PKc/PGPbFJirlhgt1FzgmYRuyASnQEPqRsMUzBq44/r8Ymra/gEPG5VSHm17?=
 =?us-ascii?Q?X3Dny8AAGA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3516901-082a-4ec7-5ad8-08dee3d9b69a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5832.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 08:02:14.5992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqmKCeiqjEitKcULNVz1FNR3/9Bch6ckDBaO3NYpJN/Vmv7Cu2kP/FC9WGv2JdU4WBSNhh8lVup4bdt6i1I7Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5620

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs
detailed error messages on failure. Remove the now-redundant
driver-specific dev_err() calls.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index b77bdce8e7fc..7cb1316b6f18 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -365,10 +365,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
 			       rk_crypto_irq_handle, IRQF_SHARED,
 			       "rk-crypto", pdev);
 
-	if (err) {
-		dev_err(&pdev->dev, "irq request failed.\n");
+	if (err)
 		goto err_crypto;
-	}
 
 	crypto_info->engine = crypto_engine_alloc_init(&pdev->dev, true);
 	if (!crypto_info->engine) {
-- 
2.34.1

