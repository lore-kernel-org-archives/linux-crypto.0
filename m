Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013021.outbound.protection.outlook.com [52.101.127.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751152BE62C;
	Thu, 31 Jul 2025 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964268; cv=fail; b=qa/g/Ujy+9vVjOsfFgS2FjkQvYIwlsv05hxBw0kajBbg3me7JjWazpiAt4xfL+7OILF8S7W4Y/BBwgU1ypx4Zx1ykBCLFUbMibVOTHRFKuVCjeGoSoHKxeKMKAvy1jDC2A7OZ3bRflScMYIVeDPGVrkDfSiDXFa3gynCdc9YDiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964268; c=relaxed/simple;
	bh=5w1ICeDTWJO8hUTXQDSYaefRFUewR5E9Mb8QlwUqtdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UDtOsMCuIWnynInSE2DsRihMDM0fa/+YCR7Nl2W5KmXNMEQI3xfuGIU5RN/WQZhO1lkUaNGRhKJH3364JcnRcI9oF7DwBgoAMBCKJ5rA6S58KL2fjT5vm+qHkpu5+7BnoLwer+SGAmkV4SKVOoLmh5bOD1MYbK1Pu0TqIZIW24g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=KuoD+J3z; arc=fail smtp.client-ip=52.101.127.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="KuoD+J3z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/C+4R2h8L2/IXcuJgAjVHXwX3Xq6ldltEBIXtxU8hLZwZ4uaKMnVuBwo4oaPusJsR+FcUP9y15nyi9eBZTP0v3fGqjKvY43opwfq7ZC2l+kSd0Mt5HVZJEV/SOwVJ861Q0vno94n345SYElBKNL1XXgEviPvjMB7HOKV+xI1wadJF8S8y2jXiXt8xW8ghyuOF5MExQlIVGRezzwSgPlH8+DfeeoGhUV/xQ2AzI0MfGloeTY3N8Yom5LXDIbrkAxUS3wucxOw0zmVX4Hz0FIMQtnmkkWrjadCcGtwy3zrq/7r3RpAF0UH9l8K5Nrnh22abxMbpRAVhoD5MdLIcmowQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9vHy6rBSgQlkhb5L9s8EWI1tey2k7HSyibXMm6FrPU=;
 b=Jjoi5plf1/cn+UhA898x7ihI9YhGbPANqvafcrfmWilFmrNCu1eBaaVkXFzyI73Yhz4oq3oHgR8pm3pGpFKHuh9Q0YSJ2XqfM/8/L2zgS5KcrTEGh34G1HeujjFfWwcmCQ4FzlfNVy84HLia4aCi6y3wG3Fd4oNrgaYIxW6kOxb7KpNCln8Ijt0svjiRrUyl8pa+BL/4EkoKF0zdclaD6eTFhmFjiBlO75xrrIH14AHUJjtCim0HS6ehKV3gi2InNR8c1tv0cDi2m5ebzDUfWGs46btbV6pqEcDQUUHfj9gTRDKgEUsx21EQHyhb5uj1niLk5kiUDtnemrYVZR+efw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9vHy6rBSgQlkhb5L9s8EWI1tey2k7HSyibXMm6FrPU=;
 b=KuoD+J3zMDtXMaR4vI6ja+7Fj/c+x9puREMhYh7Z5nJDq7OqkzoW5pB2d26zaxcKyrjwQCH0WR270PY64kk9fGLbaOLbiDyLTtsoPVrWZulzjGZNoKoi+0rPwdqU1xpIxflI16x+z6Bs6VZFMU+z9tVNP0BAKBMYRYSx8jL+dzssasrMwy79P94YRG56Tso1MNilaAZv1Z0bfg0DAXGPvz6TZ8//GyXX2cbErQyb2rUOxfmYRbY8os5OOSRwBYodR9HLKjDbpaFDsLHtJLaB0/2kTLTggAUSjaG2hulacVnqd4EQca5js8dhL1hUazkW4H6jUDtQyTNCQMAURJh6dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB7008.apcprd06.prod.outlook.com (2603:1096:400:469::8)
 by JH0PR06MB7328.apcprd06.prod.outlook.com (2603:1096:990:a2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 12:17:38 +0000
Received: from TYSPR06MB7008.apcprd06.prod.outlook.com
 ([fe80::41f3:1597:2953:65f2]) by TYSPR06MB7008.apcprd06.prod.outlook.com
 ([fe80::41f3:1597:2953:65f2%4]) with mapi id 15.20.8989.015; Thu, 31 Jul 2025
 12:17:38 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] hwrng: Use us_to_ktime() where appropriate
Date: Thu, 31 Jul 2025 20:17:27 +0800
Message-Id: <20250731121727.136128-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0026.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::12) To TYSPR06MB7008.apcprd06.prod.outlook.com
 (2603:1096:400:469::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB7008:EE_|JH0PR06MB7328:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c09d8da-2c21-4a6f-18b5-08ddd02c3d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9nV/D29snrgDPMjpiU8iV81lMnJnZbjVex1D3rDyOrVht1liW9A97e+k5iPy?=
 =?us-ascii?Q?BZhS1L3cQK1uMqX1p7wTXBnhGKqvtaDlM4JOfziCk1YqJSJCbekSSVSUDXYK?=
 =?us-ascii?Q?qQr7bkhAuOtzn6mMZrvkYMctTUcBKxQ6UNNqQUK3bG8ZMBt/Ycu553Ac8aCw?=
 =?us-ascii?Q?wTopvE7JyN7cR/ry2econ0fCcmtSWldGh319P2rIJhhzleTd9MKN64GpbJ82?=
 =?us-ascii?Q?Ad6VR3EbhPRjHl5CujUHRMThtBG/+8iROFlA02VTfjxAN7CPPjhWGbjltDfZ?=
 =?us-ascii?Q?kud5Ciz6wrIuWRxRQoXUSjX1W1olg/lkbaz42KE3PX8c7YwQZS6iSrnmpthS?=
 =?us-ascii?Q?ew2ukVIvDee+daI7TBSFrClUv8yfnSla77RaM1McwPKn8TH/066KjzFsYFoB?=
 =?us-ascii?Q?2Hgo512gIncTJbgb+SJJWeHHNInzU6qEBcN7seTtU0X1qOBAZcoDYs1yv3w9?=
 =?us-ascii?Q?NYb8BMFRkGcizxHyAIeOGqKlyrPp8Vtq1ZX86SCwvDCWsoHYAb5d587M+FAI?=
 =?us-ascii?Q?VMtEcX67jeb5ROQQQdypIalv9sgsPcOlHPhUAbTeo0oGBGztkeYZ6CxcIEH0?=
 =?us-ascii?Q?eGAiJD3RU/GwDzK6bIOe/ZrohPsEvsD2VHcmSFnsCf6Ubok357FFg8z+50Am?=
 =?us-ascii?Q?z1Xn4arTXy6h1hvb07H438sGqJ00rZTCZlxLOU543FfJwpXChKYZgnfwCepp?=
 =?us-ascii?Q?+UDsu5pe21Fg0R3zFTHBGqFipr/aLOKFXvYPx0iwIDTw6PmFkuUoIPLFKzMn?=
 =?us-ascii?Q?7WKIOJuqnlTQkiehSOfLhJVMgtTgtJlR220AIyQ0QJcZeRWpPXAkVkm/kfFI?=
 =?us-ascii?Q?6VETRGkyu5LYgKp9EApjd1FQqCAVYOzvROKVAVhMfzvHymGbIPJ2v35yZTIT?=
 =?us-ascii?Q?b7kN1+Dr/5HKXbQxcqDVux/vgl8F9cDETZFJsgKtb3j6HBE7GDtD39b2g8Fa?=
 =?us-ascii?Q?lxU5zl8NTO7gsYWxsjXwpvf5ziijqYvXL7gUycvKcgoPkACLZ6FndczsrMRl?=
 =?us-ascii?Q?U1+MwHzQ3aBuMk+N+tX7GilvhJMa25jOmfV+b19W2TN+hyfcTlTMr4TMT7Wm?=
 =?us-ascii?Q?4NnBDtSjY566/iuPrV4IjIraFIETtUDIrh82a4GGUIdgft19zgRYIEQ8y5Zy?=
 =?us-ascii?Q?M9MSpaPJI/7pifsbpo3EUklD+fZeMbWu0IG5gej2MmTGVR2XsAPSK8YIWKnJ?=
 =?us-ascii?Q?MY9DUQ9O+x/cKiy720gcWwcGXf3NNFI8PwDhnJNFHXI1AcS3Bw7WU39BSDZQ?=
 =?us-ascii?Q?Ug//AGTFQuikRrv1OH2hoTyOQa8dYnjWCzCpSq2htZUzJicXxSJiMSKPUB6h?=
 =?us-ascii?Q?87yy0wghvvcM4zcP+dyDTrnAjfdR/TwVPU0t+cLNru7Bp4yRYuykAZgx4X7i?=
 =?us-ascii?Q?3LAaD7y5AQB2O7ny6Uq/bYWYJYGX9vF1YcWDCg+PSIrrMExqGDuahpC0x7wO?=
 =?us-ascii?Q?z7CNNes2bblPiL0P66ctGkbx4hOm6ZvvJYpHgLaPW+IWDXQywU+c5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB7008.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sMHdgs+PGoXNXgN0VMuDdPClvL+IzKPG3rRgaeaRi7owGlQ2c/V0j01TCqmK?=
 =?us-ascii?Q?VQ+h739+SmIeyJYEd1RMKbHiPnOLpGp1uLfwNoihbSqf9R39+CZXcmI22NIK?=
 =?us-ascii?Q?MMf83J9DtZd1ERxkoPbUW5WIDWBHTq/avD6laultRpn/lDdGx7IO7Xy3PSUX?=
 =?us-ascii?Q?9GpwM3aTb5ByUFCApO6nZ3YS0XQ14zNNO1/S9VKnVTNg7xLSMfzyKF9VIpB4?=
 =?us-ascii?Q?2z7rf2HrNWJJYB728GmxwsUxokRujzko4eyetaZPa9Apzw9LyFzQhMd9H8B0?=
 =?us-ascii?Q?4dVL8P/cQxqHJcSepnVUUxfgsP1ouYyr/9EfLK8VjFqQuovXqPfuzxn52B2Z?=
 =?us-ascii?Q?W9Nu5PEn67gPRQaIcC4zfi3qx+4auLHF8YDEr4gD5445YnFVzZfBOko07U7I?=
 =?us-ascii?Q?N+/YHIjXBhh99ssxYvJjjl0lpetC4W7z08SbspZ5v0To2Sztb4y3I7b1bsVq?=
 =?us-ascii?Q?UFz3IQUkaw7zHDuW2R4BZMFDoI/Y4QT9ZAUWZYFeXgri+qocn+BiOu2Jk0TZ?=
 =?us-ascii?Q?bN1YEVLVqafb2Y9gD9Z2KLIE8IPMkjKmuaYsXCfUH8Hz3Rs6FZI78r1pfpsJ?=
 =?us-ascii?Q?FyOeJa759TntUW7myXFaz6Mv2+Ef9aEX3UZCDPNflvzQxAgMHnvNDfLsgXj6?=
 =?us-ascii?Q?cDEx9oAIu/ihLMN2FKbG5Y1uEzkqaA7F1LRA/Cp37USSCK2qfDDVTkRbeExW?=
 =?us-ascii?Q?XHzac6hC91bbHgjHw1uKJP8zNuoXy9vwH6wjYh8SL/8PFmBChprKzbLWi+s7?=
 =?us-ascii?Q?D3YQsqpQfwPJuaU2rKxOTt6vOtqI+rFySr31FvRM3F/EUhNdiCa9j+/jkwvp?=
 =?us-ascii?Q?UWOLx+KOK5rrfsOH1Y7kJEVZaKIbRgrTVrUj/2x6I3mr+KX8ZVC64GflvXkr?=
 =?us-ascii?Q?wxDTK80gFpOMqcW2svL7a76NI2B0AK5IgLDhp9ZCPG93q4ayXdbLsoUtOY4R?=
 =?us-ascii?Q?iXOAfPzNUzPvxkm/pjfh2LP+Anf37uJb+DwgDz7DHra770ub+7aqTtzDAAp3?=
 =?us-ascii?Q?aedTqUNFRblAT+o6d/72bSr7CG3Rd0CQdfSa5CsSMV2fE3XM12cZnoEvm0fM?=
 =?us-ascii?Q?tVeYRVyiPLqnomUBDISy1aSZX4Jdsen+diktEUbU7DxdllBwfWhD5usvc6Xs?=
 =?us-ascii?Q?ouV1lVsBYddDdSjW8MDzXfEtiiVY8ryvuODsauw/Iyg3xrg8ICtmaFUOAr/d?=
 =?us-ascii?Q?sJtaxkvQdtYbm/7UnkjEW2znvxs5jmS9lRAzCfYN8dakSWETn1W5SVg+V5Qi?=
 =?us-ascii?Q?dtbqaXoP2KzphpT7SCaEyBY7b7sL0nUdb96EXPCwuDN/LHPpZ3b8s0i5MpIT?=
 =?us-ascii?Q?vsAfQocuX42Vazx3nrwJ3I3lsUk1J/NrqTr6uidrmnOYtNJNb+HXpih9l0Gk?=
 =?us-ascii?Q?eQDqs3F/rj/jfiRfafs6Da65SDwLCr3WWBhafyBjHhApcfznhBjeDLGbdV8b?=
 =?us-ascii?Q?hKpjsuvb0whP0fxFKdZg3Bq6DXDyPdgUY2YOGgMHNjKeTprbyiSZbN4Ut7ev?=
 =?us-ascii?Q?CYi8GchBMeU3nH8S4X0QopTmMPl6jmJlM4eTaGjeUkaPFdUOhcWbrHn8+lP8?=
 =?us-ascii?Q?lOY4QQyF2ktulUFted84GdIkDLSAEPZzPQEu6bxv?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c09d8da-2c21-4a6f-18b5-08ddd02c3d51
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB7008.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 12:17:38.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEcKPdk3gzCC7+0A5wMcnFF/wE05kjW3Y8AK/zA7mf/XGHWkvGiKmJBVDvNhyucjpWF+19S7ZFyTydxU1X1eaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7328

It is better to replace ns_to_ktime() with us_to_ktime(),
which can make the code clearer.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/char/hw_random/timeriomem-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index b95f6d0f17ed..e61f06393209 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -150,7 +150,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		priv->rng_ops.quality = pdata->quality;
 	}
 
-	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
+	priv->period = us_to_ktime(period);
 	init_completion(&priv->completion);
 	hrtimer_setup(&priv->timer, timeriomem_rng_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
-- 
2.34.1

