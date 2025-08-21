Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012052.outbound.protection.outlook.com [52.101.126.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4246B2DF711;
	Thu, 21 Aug 2025 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786471; cv=fail; b=NoFAeD7QQWZzIBDlUt1eixrVxKczKteu39DOIzp3Aerm7aDVa5K6sNgrOB5bTwww+OXpGJfK+VLgcN4XdVki0H6T3K9YaDgROm9R20V2L1aoWK3PgIphpVYilfasvH0LxdyGD+sNTvoLL/ggybxzq9W1QvRuqu2VFCBw+woHwRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786471; c=relaxed/simple;
	bh=NmFs7SdLyw7lxrxGWkmC2gV1lw+NI0r5IO8jARFy6Ew=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=rg0cuYsWiU0Vl3+wGf/oK6gSffbJDKOTMI+9JOQYJifOVheCaMokBeokcPtZnOfUerN/dDKp6txC0JP0/WWnm+l0aLnfrhP7h2/zx4xw5Wkclxy7kuh93qtL7DIoCQ+r73ii6auGUkwc6Xjhs8wPOA4YS2F8AWBlwkBMCSJOJM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Wfyx5gv3; arc=fail smtp.client-ip=52.101.126.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Wfyx5gv3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GW1GCDDBMr1etnj1TXPCLwZsXAUdTAu+k6tV03m7AWkjMhBzawEah7EufaBZAvs1DsqP7SYr52KIZZA6hfKXMtcvQljAKBNAxlgDqLiRjvBd/v7QHcASl7BWW/XWsrRNSWy/SGsX8MmIgbROATS1iTeS1/yxiBV9+YkOE9m1JnAUy6utxElQgB46vM+scADtPwwWJW+bsghFSSWwD1YFeyzbtJSuPSH2BHGTNemSDCTjR4XJgJhNI0GJP79CrovKUKwbqGCAu9vJ3A/SCR/HGq4A8z4fUi7ekaDpTu/3XW6OOhK7ec8aplNQaiOcMLVBFMW1FfcIB8H8LblgZ/aAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POnZ016mOo1gHHwxq2sTIiaggmzRKcI74Yks2PNkZCs=;
 b=azMFBmwFLEsnSnHRPXWVPoDCXpLuM7ZxDbapMNgcViVFT3h2ChO958bOyFnBDHIdiO96ef7T5qL822buXQjA0pZWXLI0hI8tT6e8s2Toj66bMG1C/gpyodEPxFzl27Nh5TzuDUPoK/3jck5Zngvi5KW8IKbWP/wzXhetEU0dploZWdecK5R4QqjiPgCIC23vElRI5VwfVcmjM56g9Dl7OziKMBOshDHmt4XXgzL5Zx+r9W25Y7V58RGQ3rTGoYXQhk8NoCLCrceXXl0W6azbKVXjpMU6asPHXpabu2NurMGhc2STqgJex+bqVFd0TZDbTvtD5ZwouE2Z7u0EPPaGvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POnZ016mOo1gHHwxq2sTIiaggmzRKcI74Yks2PNkZCs=;
 b=Wfyx5gv35TonNGoOR5pUPIeBqjyG3W/DSUOmufEtuxb/ogcymldArgV0By4xURznZuZm/6pqUDEyFLdryuwVCtr3R4rOWZmoLZMJlAkbhq/NIEhiRlnVn9PmecMETtjfiM00lYrKYn7KrOCPavD0OLgSIQTMwl6d5MJy+Hj/zJimX5rQocbDucbXcNc3EMNAIMTAKoQ2MwtMQu3WfVugz3HNtzjXW+3N/rI8uxFWusm1ldaBcKHZcH6GFD8L7dYQH5OBVFJ1Jrf65w4AljL5dh0rgiBnU4GSlvYcXtvRJKL1hAHsXTJlD+F0wxtLrwizxDZJcKOsi1MR3mMSYetIXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEZPR06MB5574.apcprd06.prod.outlook.com (2603:1096:101:cb::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.13; Thu, 21 Aug 2025 14:27:45 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 14:27:45 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Shen <shenyang39@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] crypto: hisilicon - use kcalloc() instead of kzalloc()
Date: Thu, 21 Aug 2025 22:27:31 +0800
Message-Id: <20250821142732.34952-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0012.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::10) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEZPR06MB5574:EE_
X-MS-Office365-Filtering-Correlation-Id: 2825e614-7126-4a95-d15f-08dde0bee516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jq0QpfQTDnE696qVu0GTyDXhzUCTgFyKbRwcOgjHK/4GEv6d/6rsLtd3axEo?=
 =?us-ascii?Q?+G7ZDylEmwDptyqDpdZAT93lRTO2u51h5LRzxmdiDLDGKOpvqx6mTeG9k3lC?=
 =?us-ascii?Q?Ea8EAn6MEwvNdoSZAdWZKLxdoZ/21O+14eyvUOWH3SebFPlToAeFIWf1i8ZG?=
 =?us-ascii?Q?NCaXvJJb+KgVaa++cc6RzmTFtwcSfMvryADDnB2+zptLb14O9G768GtW3vxa?=
 =?us-ascii?Q?qRhP/LGMFOb4v7JIt15lYTiPdckUXZE++fiCPxoOYvdkM1gphqv0SVP5S+X5?=
 =?us-ascii?Q?Qcatv0WXmPEYsQ+5HKN9Bbe6Mm/XsbcrfbxgctmqKIji3h2wS0RCHk+606Ng?=
 =?us-ascii?Q?8A7I9yDZ8NYoEcHmrB1/VpgQ5pxgg6lQL1152xvD73u5gYwj2iqMjhvANOwN?=
 =?us-ascii?Q?7j34Zt4Iqb/fx/djEMHvhBmzuymAV83sUjI5/6D2HWPoJ1Myjj0enRcZYfkV?=
 =?us-ascii?Q?PO/nx3kwZJgCjJCxnaRWqA0xVUjG2ZgiTHi7Dud1L+vSWHEwDWp9x8e72BXV?=
 =?us-ascii?Q?S6TNIHTWATbgcdh4SJWHtwu+mUt0R6S9Q1BQg2YLt+x8rnknbOJyjPWoiQCt?=
 =?us-ascii?Q?jYsg1wSXbvnTFmtIu/tYUUMWXz+1y23HetVriiHucyYgeBKqGoCmsRDBo4ZS?=
 =?us-ascii?Q?xnnEIicyz9zvtn6O1r7XK1yNWWcazg3KLOYtLOh+atRAVri/LLRUiEdeDbUx?=
 =?us-ascii?Q?aHLTaK/Yxx12fufuZ5PsHquVXyos7k18tzr1z4HkJls/QaYVTjYqkjNmKQwl?=
 =?us-ascii?Q?OFndANxgWl9RCDPQgXDnQbY+KkE7lFiKCF89YuN+pphO1ONSBLc39bGynEa8?=
 =?us-ascii?Q?LBC4yTPnlbKgP19YBo/bDbITyiSslwf3S2TUL801QTzHC/7rLw4+rAcfHvfY?=
 =?us-ascii?Q?GkbOkRSMzPTwM1tNVDtQe4CzaM4ijpsUNS6kILo1xRcGyxBmx3TAnM7BSgQR?=
 =?us-ascii?Q?xxg82I3udWvORoGy8hAbZsYE4RaCFoQwFTRaFsxV/+42ues1u7WP1uT+FhNF?=
 =?us-ascii?Q?MaLWorwdvOLgVNHDP0YTEKdlWAJd0npB6SoZItCKOMLTK+vbtwo8HYr9Cjwf?=
 =?us-ascii?Q?GNFRPY6leDB4jVBApvviRo38+6YJIMndldntbHOW0R2dDU9YxcHaIdV2r4no?=
 =?us-ascii?Q?fiuCewYmQBkAlTWqAsF7hhkVamHDLUTPLkqeKlIlmN9udoeenu/fsoNFz0PW?=
 =?us-ascii?Q?/8j/nGxdIi2HM6KJDXIDdCTTiE0etr0mf5VkFH9o2ZrqnINdQSi5KPwz+X/X?=
 =?us-ascii?Q?LXwZvGWC/ABkcSt9lR/duV2JqOa0XXJH9ABGc3KMsMWtBHkJwKwdFz3kbouV?=
 =?us-ascii?Q?48nBXT8qo/F8+da7yf675ktweCsophHEXOwvyBO/KHwEFonEopDkU/q6vx32?=
 =?us-ascii?Q?qYMwGwyIvHZRxBE3PCAJ5PyPwh6QOAmJKx0EDiPfnumVyxDpAy6FdQk++slG?=
 =?us-ascii?Q?DJJ0b4jsQDfUXfzpjeO7GVvBeFATBsCM6/CvxUCWFHyQKucx1bEYXElIcDsQ?=
 =?us-ascii?Q?hhvRPhEvGOLYOF8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Q+Ofsvg0wli8bcGBKyR/pPOE24AcfCdazczKg7eVBq/m43QqRX3L8s5FKGj?=
 =?us-ascii?Q?DOlB9bbD381iHwHWZ9/RPLc6OwbG497hXbr0bJ5rxnncmRgqp1E1w0xEjKIN?=
 =?us-ascii?Q?n4Xdmjlk7BEw8kwLPKxJQCt+s4iFhq+VzLvdl++z6NeJ7jr4gBLJlb8sSLx9?=
 =?us-ascii?Q?WV+qS4LsV8/sbSWpE3EI8/lcYT5k6I6z0BW7XayzowmbdqzDI/Fs7Mh1uTeS?=
 =?us-ascii?Q?qv686nJjPq4+B7gK4xtqiM0W9Bpg/x0ifi9AKAczzpZ110wBLTJjbTP7/q8A?=
 =?us-ascii?Q?+xMEiBgkb0kcn0bWDWpr1XLIR+WB9haDiR+h2tphar8wCfdWcwdvSeIzjAbP?=
 =?us-ascii?Q?ixuulCtshbYln4igZ8XiCEEVdNKGcIfVwkGV7mP/pcMqi4rEuXk1+Jb3cwbA?=
 =?us-ascii?Q?iE94fFZfdKPNb/eJh/FBuOwqhZikxUPCwZ+3QsLvsuZlM3v6VjPX2kUQ/SL2?=
 =?us-ascii?Q?wqJDBk8Y+/L3gb2a0VtVseKJhIjzk9+hT+Yn8m+vpwEEt7X0AU9HxzFrGt8S?=
 =?us-ascii?Q?T4HytHPtQHqvXVNjhOxgvkcGODr/Ug9ldke5hYNhCoRe6Qst3hXzi73coG8U?=
 =?us-ascii?Q?F3gZSQmAGYrI+T6/8ohdawHElrpfCE0IfNgeP/smWgBXdrHFzoUHTmQCAGOh?=
 =?us-ascii?Q?QpnPM14X3PCCEGpHULwSbaCd1mTwR2eUOu5k69ZbZJh8vkM/DRo5NZ1ghKH+?=
 =?us-ascii?Q?Unq9z9oFs95I/VfRSp+Rwn79CoyTo38LNRdOf9bVu1vlpVGzZrcKvOImp/wj?=
 =?us-ascii?Q?iDyNdgScjXFMWIG630Cp9XJJRYTeVB4o21Qudsris/0iMCXCC89yzG+LZ1Od?=
 =?us-ascii?Q?fjZFhFmAWySbNaZoLzjUye9GbxWWbxxvdmKgHOb/8O0KdRPN4QDiDHn7tyT1?=
 =?us-ascii?Q?5MXUuuSb2k5XQU3T6O9OjJuY8O1UWgxHoss1C1OfDuYA+0rM8fFNZWeyuuFt?=
 =?us-ascii?Q?KMnmgTS3kttW8Gi2WSFd0Xun9mZeXR4TCAj+6TSKP+LL4Y00BD0W+f3cqp/E?=
 =?us-ascii?Q?uq9FJOXKAmNHbUuuJwyYpdpWUV7ixonCZbVSsqLVnsGov8dGu3OQBBPxA7hS?=
 =?us-ascii?Q?XyCDQiCuz7qU/9a1JRkLxpu3JNA/fNlZe08+OXG1CoqlOm4LdotQc8pOI3QE?=
 =?us-ascii?Q?1I0/nRxp2aXDydY1wN5OkfG7h2/YoYk2EhE4KWGIJxCU6JHp85+gu6gsfEo5?=
 =?us-ascii?Q?vAk+S27okLMQBTLRzPLa1FdX+F4d7nzVzGHt7F8G2e9gtLRj9ByhPo7D7soL?=
 =?us-ascii?Q?sZVq0L5rP35Acm9j0IOPnXTUW/+DGuv5TT+7ildIhDIlNcNMtJnb7enzNKeH?=
 =?us-ascii?Q?bo2BRcxz8PCjVFOH9wwhcp3amUvJJ5xaG6xraBs/7tMBrWQPn3CMNGkwckbU?=
 =?us-ascii?Q?OuVAsDAjCFBAWigcQCh6TefC2KT8qqz+LBtaM6kwxixc4NswJwfI1qAK4nU+?=
 =?us-ascii?Q?UhitFJweBNuHVTiGg5kcjTrZcP43tn2MwpAqvf9rMHGuk6Ss6ImVTpt+B89v?=
 =?us-ascii?Q?FX26iRDmLeXgCo+mIY4xHRaDIn+Vu2M9ABoyOrC1V8tCezq8V/jnoy6+Ue6e?=
 =?us-ascii?Q?qL60SXL8scZjEm5jC87/eaMxvf1wA0gZZC9MxSqs?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2825e614-7126-4a95-d15f-08dde0bee516
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:27:45.0450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nflh5kFVhld7MMwphHLuhxc9KJtoyRYC4T6ucQfLPnry475dg1NCRrrKUKEeKf2RSZWpnxXUpEIFi9zrOtD/IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5574

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use devm_kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index f5b47e5ff48a..e1e428bdcf8f 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1171,7 +1171,7 @@ static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
 	size_t i, size;
 
 	size = ARRAY_SIZE(hpre_cap_query_info);
-	hpre_cap = devm_kzalloc(dev, sizeof(*hpre_cap) * size, GFP_KERNEL);
+	hpre_cap = devm_kcalloc(dev, size, sizeof(*hpre_cap), GFP_KERNEL);
 	if (!hpre_cap)
 		return -ENOMEM;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 72cf48d1f3ab..10171bc6c05d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1169,7 +1169,7 @@ static int sec_pre_store_cap_reg(struct hisi_qm *qm)
 	size_t i, size;
 
 	size = ARRAY_SIZE(sec_cap_query_info);
-	sec_cap = devm_kzalloc(&pdev->dev, sizeof(*sec_cap) * size, GFP_KERNEL);
+	sec_cap = devm_kcalloc(&pdev->dev, size, sizeof(*sec_cap), GFP_KERNEL);
 	if (!sec_cap)
 		return -ENOMEM;
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index d8ba23b7cc7d..f0aecb8bc1c9 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1273,7 +1273,7 @@ static int zip_pre_store_cap_reg(struct hisi_qm *qm)
 	size_t i, size;
 
 	size = ARRAY_SIZE(zip_cap_query_info);
-	zip_cap = devm_kzalloc(&pdev->dev, sizeof(*zip_cap) * size, GFP_KERNEL);
+	zip_cap = devm_kcalloc(&pdev->dev, size, sizeof(*zip_cap), GFP_KERNEL);
 	if (!zip_cap)
 		return -ENOMEM;
 
-- 
2.34.1

