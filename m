Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013018.outbound.protection.outlook.com [40.107.44.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B321F3FC8;
	Wed, 20 Aug 2025 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693580; cv=fail; b=sZIZTupFaL3MczThH3m+0N/g+2Ciw2NSToibMOh5dcOkBSQvIEfKtWLbmhlhWE3dd2nvcfjSyBT/zYX+0Tlub8BtxngawwQoYKQO3AqProMOGFSCQvBYkDbvaewzf77mRxYQAD9S4zXGPCzHEyRQtBjbdT7yrA3/u/OEPYTkrJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693580; c=relaxed/simple;
	bh=EM++jKqVBjQOrTc21NWr+ofqZ3wS5CdxJzV918+ztX0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aNPIgOSCJQGx3NAL4YH9BSK7dE/n+Ik5hpt7EoB7Zih22XB9iLdrD/5hNHLUCTc0sqMIsAD05tCenILFeXZYV74sGmRv+O+z2vZ8vv8cXKfzJ81JxiN1ecQSuBaQf5JJdQCNRKsFiIZ49MtyicdjPFjsN3gLbv2HLxR3JEeoFuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=VOu8rVw+; arc=fail smtp.client-ip=40.107.44.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="VOu8rVw+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thxoggLWYIaPRGrqpBN+4raDthwQB17tubWvqmTwb4ig+iFC3lkyTfIo4EdghfnBXomjY8PrLN1QsYksjs0BQnhgjHlpi9GoBdYdxtm+ITVm9nwo5+Exn/LfaXPCvuQgizffm+bus4GihX3qxNo0Wr5GN0d+gadAbO3xVpnrIu4ijLbnpfYyYfjIsCrjwunPOzLYCp46IwV+tHozER5exBarKxg14n2n+MlXbl07cyDRYyP7JoUhBCYjwUNXwHt5dhe/69mk71m3cQTtY1kDhXPNA5U8q7V+fOIiafVr8tbLPc3Nh4Qn+wRxbEmCijNKHjyc9qj/xuuz2mASPZ318g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SspQT5Y/5Pw5Zi+iO4+ja16ILRMwKbgbaWpOuP6K7vU=;
 b=FvR+M1sDoH3NO3zmk7RJYbnpMuHLSjDC2WbXQQksDqPe9yC3vvcFbLcPx+fKahUCWI1fx+1cpANeIad25bxnvbNBxMkN/MfeTZzxZ4LmuOBJMxWGZx7FMpakSsxkm06fOByRQZQfZH2G56MZIKqGAZUr+4yUY7wPYSkFlIEFyCYPaM4qTI8QamncHRNVgjJ6mP6Ef3aig1Fj019cXYPx6H+0ow4h3pF4FHyMHspqE8Ryl+DRUMT752uqaQ4zX8J8D8DkenZAh//KBWOfgk5lgUIMy6Nz4sMb1C1y+GV0U50oCQZv31HXka/XTKIQOE3DU+41mLnWIqU4l/mWISA8Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SspQT5Y/5Pw5Zi+iO4+ja16ILRMwKbgbaWpOuP6K7vU=;
 b=VOu8rVw+tnbRPguW1yMuiGuPfHaLpxXfyj0AeAcSAihHDe8NloGe0iROADK7WbONVYclHWFNP4JEMm370CO0QCt0SM27LMrk4AHL1aXdNwp+AGO5He6ysdWm4cZPUfZxPzTKyQ5xfxABEIEM4GimJ0pP03bB+VlLVwW58JlB9JqdXm3mxAb1z9Gwk3AwBHzNmkYynOkm91dJ87R8UfDZW6GSZdUY1FX9AczJoUy0Pj2ZLjAgcC6tbevriCRO9h6rx+fmODt7OSQLWLtd1l12PV7QNGPHxg85xa/2dMoJF8iTZZfpIsEuNg364lQopkR5xn53iR+2XWYbQG8JXJ/Npg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6448.apcprd06.prod.outlook.com (2603:1096:820:f2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 12:39:36 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 12:39:36 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org (open list:HARDWARE RANDOM NUMBER GENERATOR CORE),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] hwrng: cn10k - Remove the use of dev_err_probe()
Date: Wed, 20 Aug 2025 20:39:23 +0800
Message-Id: <20250820123926.473600-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0179.apcprd04.prod.outlook.com
 (2603:1096:4:14::17) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9a0f9f-ff7b-48ab-52a1-08dddfe69eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K2Nv0fnyzG6GWzcLV9rX9MoYA0ZVq0D7Hk2ZgaNwJhsqcgUAD0le9uU2Xdyo?=
 =?us-ascii?Q?I6VA9MpqEms5FMbs+Dm/C3kRnpHS/fiou2RtknStjyawSFO77aPAPvXzQEP1?=
 =?us-ascii?Q?ivrjP5o1bqr+24Tcx9c6K+lXfk03XkywR3wYQ9QyCY3EZaZfONJVgKayvEdF?=
 =?us-ascii?Q?+75p6aN3xqy87YmpgAJjdndFGyKmu9WHBayrDGplZLyggAyjEV0V/+VmQJoH?=
 =?us-ascii?Q?XaLYHUlVU+eRExWMfxFmQcBgxgZoHEi4aPA5HYCg5rWGz7N7b9ab2p7rT1oV?=
 =?us-ascii?Q?cN/WrX2y64L2g1AqhU+U4/LHO194TO3ixX+vNRQ4OG6XBfSl0iEodP01jVid?=
 =?us-ascii?Q?VIL0DtW6dPHVIdDlx8kaLWFpqXVbeAsCw9PHWDlhzMADE7tYifIgVfXpeY4L?=
 =?us-ascii?Q?mJVNCsnqoWkqrH0htoFvSuU00g2ScaHItelKn57fgerzE65QEBfWpoaUaRA/?=
 =?us-ascii?Q?b/1xo2FN7/60rzdl48Qj9h9e0KkrGkYnOX65TIM6Y/dUpK4QFJq/wsZIV8iv?=
 =?us-ascii?Q?Z/Aq9DEN0BSQFX+6GYsPXJ8pZN6/6oKC5ZEO9qG517eQLUJZy+vDiPGZMh65?=
 =?us-ascii?Q?O6G8kkWDElTwQD2Bqxc+6G3tzy+dGQn/EDnuvriy+2IojzJoC5QxbWdB2YIV?=
 =?us-ascii?Q?7qJQVcSbWltovRTtp06F5N70LUFtfTbzDVyou2ZlQPjkyNMOZfD/sljuMlWq?=
 =?us-ascii?Q?fGhKzhDcc7LtBc0FImjGRS5nbecmS84jRZ4z1CU7a0Wcb1OPG6XP5Vpj2/DL?=
 =?us-ascii?Q?bP0CUHMDAVImwmg6HMp+5qP92aXktCggdy764iToT6XvPFZL7BfVw/cS/Zat?=
 =?us-ascii?Q?ZnIVqsFpVcrOiz9/KAyJCpeo8ySCifvXJUJarsm9pPYeeF4MDblsfd8mFNM6?=
 =?us-ascii?Q?w3beeJMNoZs+VGN2SvUp0eISroXKtI60Dow7/N7T7mLp+qhGuSDWhcfazv8e?=
 =?us-ascii?Q?RNZoZ7XfgMfKERXZf3IN07UQy3z+0wT5/6QTqL4neLUePdOBLKpUUNUQpzhE?=
 =?us-ascii?Q?p9CmqIbqCX2ASXiwu4parDkZzMBcERUzYjU90ZRrEBhxH0/7XFhZV00YTaCW?=
 =?us-ascii?Q?NTWZmEPfh/XN9NCdABfPCyzmL1s91rtolFwoYCX6I9B4LUdSdpztc1CXHGwq?=
 =?us-ascii?Q?rLH+iPUur7Eu4SswUkORcw/cpa9hUEiRb23bREffKEln+tAzJHe0y4CiT5RG?=
 =?us-ascii?Q?9QATvo/VfcAcrB0CnCsXpqrfNwkj3nYDLB3Ch+36jvk9lK+SSNU5tw0yDTvZ?=
 =?us-ascii?Q?grB9lW0AQXUjXF40BCeaDqZeVOlJBwym1tchC2gzlJ4TJY/dZTDn4DmETgIf?=
 =?us-ascii?Q?F7dRKJFBUp4qVy1Jvy+sCtOQBBWJ6GSv8KoczMmxXLRoTMRJP6RAeqnWchps?=
 =?us-ascii?Q?5BYzftgrXG/uaweFP3OjTsej3xk79uwrSN+tgnPY6YSysQunhMy0VpORaMtR?=
 =?us-ascii?Q?xI6bsav3ex/18EjEYkFSHYreL5UmCxtcRAdOv51umLjjfmydId5hDTcgWV4H?=
 =?us-ascii?Q?dIzjASVy/AprpMA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0oOzStUlcDDGjVOYfjVCMP9P1KINocBGsruLKSIhW/wZ1IiuNTWFu7eedFq5?=
 =?us-ascii?Q?YGQxIc2qchtmiP1rneWvrmf6MDUIlUSFXwNhuA+rkDvcrLktp7yXw4YxkBjc?=
 =?us-ascii?Q?DceKaurPg1gbIk2MmsOxyS6uZ4xtum2MO83xNIwa5kd3T4TJK+rwbCrN2yLy?=
 =?us-ascii?Q?PIZS/HHQgocImSJly/XoNjHo0zhx04A9TQ9mViYWY6kfN6+4Jr3gd1hzgI1Q?=
 =?us-ascii?Q?L79RbWTV6IjsFFSC5WS1LKVowoq6xaqlp59dJhHG28nsnMDAWjzmLXI0IPae?=
 =?us-ascii?Q?WIPXCtsIBDDF1zbW6m+kwxWF/M1C5n7Q1Fzo0pnuXKx1T8eLV61ChJSVtD7s?=
 =?us-ascii?Q?vGuMliImZQEIxWxu2XBgprdvnPhk96Bpd5NZxlcKxu61XdWJ8b3RgA3SjXbi?=
 =?us-ascii?Q?DqqmGHewO6saPmnER/O51+C2/Ia2Jb7Tq6POVeTq46BUgdKof1lecIphftMT?=
 =?us-ascii?Q?DcMm2kx2JPJ0O+GVy3PigoCVJaztiUmjKSgADqS06ok674yT7QiPP8KpmKjm?=
 =?us-ascii?Q?AKgxVvRl7vyg77x2qwVRkbQf/EtSaGhrKP6RwolIgwfK6cDnGvkUrcwtLBAq?=
 =?us-ascii?Q?46P8+UO8x4fMDVcMYkXpUhUrXQWK2SO6E5ryS+aDBlegMpQteHIvoF6sI84c?=
 =?us-ascii?Q?drVFcVzNNhNwuz14LT8zqx8qrTQSaS2FHCMYaqwrn4ETbqJyFh9bNP5K1Hkj?=
 =?us-ascii?Q?dqXW4AAPCAlmyXS+LWlP/+vO6YNF858VafXgkYpI0CtNfHmUfIgoxzX113F9?=
 =?us-ascii?Q?R+WZoorrKFwmQ3vK7bbWPelP+/lEi67Y2kNlF0hS5dWJBhlDZAtioSDYEeYh?=
 =?us-ascii?Q?hY0GdG8miayQDRO2d+NpPz5kmjMhxo+d2AgXlKUeo1yyFjgHBECBiyonRSDI?=
 =?us-ascii?Q?qX7/EaMvZs6UbCurToYUiMN2j7NdEuaW4bEOf0sTc9OjfKuIGNGUv/NsdfJq?=
 =?us-ascii?Q?OjnLn7Af5frVqmufVcWT/uNyfkGv8Tvu7C0LSdTWBpFgzGJmWqGOdIXkryKH?=
 =?us-ascii?Q?/5uZsF+YAeVLAbPTY5+/HANoetc7mdFysQUkWK+KZsaNAMyclXYv79qdJxa/?=
 =?us-ascii?Q?FV9RR70Mu6/kPg4LAvJTLMne4JrIv4ggUySqQ2ceI2wqnN4GRD8/7XZAbUss?=
 =?us-ascii?Q?6U+6mJyYrrNBkOAPk58syIqk7TQ9zFzrq5+3dJ4YevzNBbSgBM3T9XvMsOrY?=
 =?us-ascii?Q?23BfkOt5RaBJ+jL08k/cUo3zxQHR0bbBgj+UKy+u2zEZUf/+vLLvpMZSXImB?=
 =?us-ascii?Q?DsI38siyLO+KpTDWrWzJ9LdHBioIiWOdtPqT1Fl4woHWj7jx/jOZiDV1RTdT?=
 =?us-ascii?Q?HReGIsp7zSejvgCzQi3GliTQgDtXlTHqVM4GwW183GhCTJH+sC9IsbsD577q?=
 =?us-ascii?Q?JWAHjGmLylpqSPK8iT0Kddv+73TIpT9QqLr4fDODKt44c8yjPawTKeSkD68p?=
 =?us-ascii?Q?sxmgWtSiY9CSN1XlRfq+dSEWk9bRr5f9BhWOy8KzwcONJFM4Cna6IZZ2KNRb?=
 =?us-ascii?Q?jORa8NWvkKjXU2XLkPVI4cZ53iLchmp6khyzSe6GikP5xGOuC5Whs/H3TXge?=
 =?us-ascii?Q?T0wKo3HOgqlrouOatpRKhTcuNokJ6bH3vA7zerSs?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9a0f9f-ff7b-48ab-52a1-08dddfe69eeb
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 12:39:36.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tg1pJwSKrO0SgEvPC/2lRVWhs2JOuR29/i9KWvZ59FowaaKpHborT6bS/zfBxgTt0Z/D48oZrNK32dR0WnuObw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6448

Logging messages that show some type of "out of memory" error are generally
unnecessary as there is a generic message and a stack dump done by the
memory subsystem. These messages generally increase kernel size without
much added value[1].

The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
remove the useless call to dev_err_probe(), and just return the value
instead.

[1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/char/hw_random/cn10k-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/cn10k-rng.c b/drivers/char/hw_random/cn10k-rng.c
index 31935316a160..3b4e78182e14 100644
--- a/drivers/char/hw_random/cn10k-rng.c
+++ b/drivers/char/hw_random/cn10k-rng.c
@@ -188,7 +188,7 @@ static int cn10k_rng_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rng->reg_base = pcim_iomap(pdev, 0, 0);
 	if (!rng->reg_base)
-		return dev_err_probe(&pdev->dev, -ENOMEM, "Error while mapping CSRs, exiting\n");
+		return -ENOMEM;
 
 	rng->ops.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 				       "cn10k-rng-%s", dev_name(&pdev->dev));
-- 
2.34.1

