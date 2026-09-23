Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011002.outbound.protection.outlook.com [52.101.70.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99061544D63;
	Wed, 23 Sep 2026 16:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180411; cv=fail; b=X+FkyPTtN+kwk0Aakhhv7vltEcZWm1zbT3i8+RM0ij8Hs9Fl2D4yOQ3o0xiOBRQAgLtzPIpVaNgauB9PZxvCsDFKzPAuFr7ybyBu6W7asO3DYtPLhFPPQSAIr/M+utK0V5WCkW4pdBEQ3Ec8RMAyYGPIvlPfr8BN7zxyEyTJF/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180411; c=relaxed/simple;
	bh=SQLNuFHw/zpAETUGpHSpY6G3pmWUvsgc4Uzlxk0XO0U=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=XCHcb1Tfjx5B6DJepQ1sjI1J86KUuSzsegVHT9pKmhJHvK/V6DWrcN2584DDIqLhLUndE3ZM7yoClR/hAvs8OQ88jUGD32JGcYyJOLSpPO4Unt/G7Z81bIvlqiDWOU/CVfiAMbnF0XdudHX5JIbFdSpYxv2SBCXdOyT4GAorjyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pyR97giH; arc=fail smtp.client-ip=52.101.70.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pyR97giH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EyakZkW+h3ocJyZPtzEtcBSnPDEi8DnJiaNkD8NNJ0W8+aFGr6AyjWe8cA+Sle9tkceIpnaaGRgp7mP0VdR2ZaAGmnbIys9GL0xuBvXbiSvVaiQ02IKWBrAtgJKQcutAlOtwxJkTU8CxeGuZf6SZiQKTNA0zcEnMHOgubVltm7hPLsXQn2lItZdnFURJ6L8nGBSigA3vMMwty/hx8eURhziFfz3s29cfywcaBtGE5LPTWJzB3kE7LziS7+VC46nax1Y1NgxrS2Ws70QNEGX4KqQQbwy7/4SAe/7HuGiBHQCcGJRhTUa2Sjc22ImYhUdEDhIGwSrha1iT4I89/JP8QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Zs+A3N+H4OIvo1dDhBdyyEbjtuWQj/VrfEajEwtm1k=;
 b=eOsTGzjNSR4tvH1lEc+G1IqVudkpNEU6d69z4iGTvspqtIFGdggAIvsq1sUInLNYyzGOxbw7k9Kq8jxpL7q+YkZZ5lC5Rr4/suPfMExJ/BruQJYAjhWA3EK6C+H9fD1oc73d3d9BXyXPxQ2khtZkjEA0z3B2XVXR9flqqHwCwac/ELgg+6M+PSh4ohaT9bljVKZsPFZFxOGXF8DEl3P8Z/ACCeMExMsIHbsPy4Ny6VIlodiKLhuF3bjIWq4DQseRzUHKBwemUoipSRc/skQdWwqMUpv/HOVjL/HzVlwNiNWk4xhlcs61FA1fxkJPU6bQXegdLLhVIOBhZQ3LJmJffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Zs+A3N+H4OIvo1dDhBdyyEbjtuWQj/VrfEajEwtm1k=;
 b=pyR97giHDUIXKltWGfxVTXbavglmplUTq30Gs+eP3zh8TTYrfilEg9Ar7xpENtUjZMCBZZ4BrLpnJapgYfBXdTA0lA30tM50cL8rzY+n4WU9TRh3i0GHsSAbcRou51/ok9EkFxJVMQ2D0TVJofV76Oku5UBR/6DWsXc+KEkjl3lIFjdaKK3JQYk87dVHSUhsj90gRRCnmmf0LU3XPU6XzhhPD6/hKq9qvzpSYFR3GJ4ydYY7dafhuHuXIUXhi/BYS9L1ydhQSxlRGh9+smG2cZK2oLopwjri3rdA7pG5sH04uwK3dQ+rvMH3UN5JOQ+TWP9kUd0irXI3KWPwo/7VUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:06 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:06 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:34 -0400
Subject: [PATCH v2 05/12] dmaengine: add dmaengine_get_copy_align() and
 related alignment getter helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-5-32ed65b8a9b4@nxp.com>
References: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
In-Reply-To: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=2372;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=lXp5Ebsxc0CGIQcgDZ0XzZpIYG7TQxy9TOdVgUs//Ko=;
 b=49heUt1pcyZxpalPPddc9ilC2L+biGmpOVRd4wq6JiFEkXXkolkVK8Iz99dJEPl8wbKuGKfMi
 eHBO2Wdz2l1B0uIwf5AceN6JldrX9uLyNRSRLzcKkGg+uKlZ/Pbzs9b
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CYZPR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:930:8a::15) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: bef30e0e-9132-4042-bec6-08df198e877d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	DP6OFtXCHovIIO3Fnlv7jNwtlKYrBxqEPxB1Ejv3UlqZe+ZdA2tn3cPj5/OQfJLj58ahBxQ1c99DpO7u3T76PL8Vh0JyuHJwEVEFmh8zr5U0fntFjg5UO28ksRv1arSi1/B4XhrNBK9fdiSVzGialEEErQQubandFxW85O7tKGBsG7uTgb3ewzPbPw1XhZT8K7jcERt4V8st+AdImqGzNErN8BU6Cyn46n4U2biRi73xB3cWHWmIjyr5HVlTxckRNOQzG1zVJSys+HYaFkZtjtVs6vfki/Tt2GYUI4rQXijcx2YSFLZ6IxmMwZGDlbeDoRfqHaHCcdv74kOBz+Lr+8b14dsCsi3QsZBXhcy8ckFMCHgKEduAWFVaLgZx55W7LYi3WgeVm625/A80zKmAWxyIOcGF0T7KaLYToX5Afz0XYikQchszCxmVTQcN64tyNwAw4dmpXO+zlKARIcd8pH8yqogOovO7pCvArq2r4rnuzH0HUmuXmDOCAYKmvlS0Tpj997+XJSiuQTVZQu45YG41lSwHPaLUe8uskl2FGQEj27vWU0ap1LevPnjjRacDoppVgmlFnso0jyZIF2nZrWqr7lfteWH/MVlZsDCanjNSXTiMmvaJarWZmn1jmpZNfOZs1Mqc/qWdY0JXvPGAtHxW1QuIZhXbVQmduem6+Bk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0IzcnlvSXRrU1c1MC9INTBiZ2R3NlIrZmRFcXpmZGxzdVFodzUvak9TRWx6?=
 =?utf-8?B?V2t2Q3RqK2NydDQ4OW0zcjhYWUpJd1EwUjZTZHFlL3I1UEdqY2luS0ZNQVlh?=
 =?utf-8?B?R0Z2d0JURm5sb1FSa2hkWUcyQU5IS0NzOWtWeTBFc0pIRVVzUzdpbU56eWRi?=
 =?utf-8?B?UGd2ZU5ESVdUYlJhd1NrTUJrak1SRHFXL2VjWlovNThRb3VGVXFVRDhhemEx?=
 =?utf-8?B?d04xZkxwaVJhMXRodWNwQUtkSy9EMU1QSTJIMGJPUWVjL25FR1FMSTBBSWNH?=
 =?utf-8?B?ZU56Q1JPcjdpQit6MXNCMTlwQXl3NHZ0b3IvMUdoWGxhR2RPZ25yaUxjVFNt?=
 =?utf-8?B?TXVQMHkrM0VpWDMwbUxmRVYyUTBaVWFvS3oyNjljU1JmU3hVOUo1dXBHaVV0?=
 =?utf-8?B?M2c5MWF6aEYvSDVSSnBnK1BnUThWQjkyYlEycHphNW0vTVJlZllmbHRKYmU1?=
 =?utf-8?B?bSt0c2tYa2J2U09RYThacXQ0T1VOMmZBcW9UNUxDbG5PdEhkUFFRSndaek1t?=
 =?utf-8?B?Zms5d2R1L1pFbnZEekpOZUxpNXRyNFI3T2drZU1WY3BUT2tpem1MMjloV1pX?=
 =?utf-8?B?OFlQaUxQR2FEMUhvOTFJemhVSmd3L00wVGNVYjY3N1ZDL0k1OC9ncm56YVk2?=
 =?utf-8?B?ZkVQSkY2MWJjb1diaXUrWkgzR0pSMWh6Y09PYTNPeDBCZGJsMlVIUnNTd01i?=
 =?utf-8?B?WENETU5jd1JndU1IeVpGZHlQSnV0aG5XQitZYjkrQ2VPdS9Cdi9KSHIwNXh1?=
 =?utf-8?B?YmpnQ0h4VXJYVWlhb3NhVGRqWVNGZjk1OXhtWEFPd1NOdVgrOWpDbE4xQkhH?=
 =?utf-8?B?NCtkdi96V0NrcDh1OUR2RHArTzkvL1FXcVFiZGJpUXdLTFY1Y3JuQ2ZzUGNP?=
 =?utf-8?B?bGlzaEFHVjJheUYwM0c2WWVYdE4zRGJDVEU5U1FicXcwR2M4K21HYVpBUWlX?=
 =?utf-8?B?cEU0NmVPbi9SNGlOQzhxWTVNQzBsWWg3M1JBU0hKWFBUa2N2NEVubTU4YSty?=
 =?utf-8?B?NkxyTkh3YTNKSjBiUnB5RHR5LzNqNlRtVmhjS20vQitnOWRTTFprVnBiTXlM?=
 =?utf-8?B?V255ZEFsT0xSY3VONHJCdWRIVVFQZk9EOFVNZXNoQVBGVS84WXk4Nm15V2Rh?=
 =?utf-8?B?MWkzQ2JjL2tKbFZqNUkxSm11VEJtMk12VGlILysxMUlWdEo1L2hkQXp6dUt6?=
 =?utf-8?B?bmlUN3UrTXU3VW1nYk8rK3VEMk9vRjlRZlVJRVpzT0xUZHBBUkYwQnM4cU9P?=
 =?utf-8?B?ZDkvam5rUCs4ZFRZcDR1SmpCU3lBdTVRVktDc3dJM1pESTlKbG53OVBYOWNQ?=
 =?utf-8?B?aEVKbjVhQ0pJNU5DOXEzYkJ2clVDV3VHOVpvcnh2TVlWcWVnM1hUWUhFSWF3?=
 =?utf-8?B?N2E3SUFLWkxYTFI1M00xblF4S25XS1F4ZEx1NWFtcWJwK2tXRjRPRGJXa1Aw?=
 =?utf-8?B?TzAxZGZNWUg5NEptOEQ1eUlzbGNSVUVsQzllaUJtdzhyN3Fobk5ZUHpTZ2M2?=
 =?utf-8?B?dlc2MXhXZGY3UVByaE9nOHdtNFJLSTNjajdnREZUeG5ydmZWcHp0VzM0OHdO?=
 =?utf-8?B?V2xDZHduR244VjFISTlRNGFvd24weVVHUU9UUUhib29QOUFKaUtLODR6TElz?=
 =?utf-8?B?aEFuV0RBdXllMm94SDRPU2JMd3haWDR2MzJzNno4MndYTVZhbW5QejVUZWdP?=
 =?utf-8?B?cjhTdlY5ZFJTaUNKU2pKVU1Lc2QxKytRMlNnK1VRK0EwMWNQMG5ySTNCaDdD?=
 =?utf-8?B?TEw3L1RUcmV3TlIrS3BwM04rdkp1ZndXTURrWmI3VjNtRFFld3pzZlB3Yk15?=
 =?utf-8?B?aXlQMXNtTkh2dXpSTFk0TmNzUThpZFlnclFqcm8xOGJaOW8yOVJ1NHBUTjVu?=
 =?utf-8?B?UG1IaUQ3UVdISUtnbUhpR2NobUlFL1N2bUMxVjR4ZlRmekZmeC80UGhqL1RB?=
 =?utf-8?B?ZC8rZzgrcjRQWWxjV3hoWUZpOGN6N2J1eXlIVkg0RUVQQ3dMV1RmU1N0cDVY?=
 =?utf-8?B?dWJjQ2hQVTAvanA1ZVJUcEZqQ3NqRzJlTW40eGVvYUUvUUFocWVUZFI1TUJo?=
 =?utf-8?B?Y004UU05cEc2cHQ5cFc1YnJoVTVJTEJhWWZjZU9DRHhlbFVZVkdoRDdPMUs5?=
 =?utf-8?B?bmhVTEVGY3lMQVZ2YjE0aGxUWE03YWVzZE01Uk5va1Irc1lESVArNFc2UFBa?=
 =?utf-8?B?eVh0TEltMUc1Q3o3Zk9GTnVjVy9IbFFKdTFBT1QrQVdHVUM3UzhtY2lOb3pJ?=
 =?utf-8?B?THJVQk9USFhQOW5BYWVFLzA1eTdMaVd0V1lucElQdU9rS2o1VHgxdjdYdm80?=
 =?utf-8?B?Uk0rc1ppT3ZLcW5vUnpvU0NtWWNFbzdaY2NiNEl0MFA1bXpDU3Qra2ZZbnM1?=
 =?utf-8?Q?oxZympUXgF9tWYTC8leKN7OsWEjQzbvztp6n5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef30e0e-9132-4042-bec6-08df198e877d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:06.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEKFjnH1K+faUz+MatVpsy1fCKl4cj++hw0ybx+ekW3d0RaBygIOwGEsC9RixD2ingTUnoev1g1mx12PyEQAzZD5vwSsHJK/o7wIMs2yNRuUAUvljKlIPQm+QXIJou5/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Add dmaengine_get_copy_align(), dmaengine_get_xor_align(),
dmaengine_get_pq_align(), and dmaengine_get_fill_align() inline
helpers to retrieve the alignment requirement of a DMA channel as
a power-of-2 exponent.

These complement the existing dmaengine_is_*_aligned() test helpers
by providing direct access to the alignment value, which is useful
when callers need to propagate or compare alignment constraints.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1efb04e137673..615eeb708dcda 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1537,6 +1537,54 @@ static inline bool is_dma_fill_aligned(struct dma_device *dev, size_t off1,
 	return dmaengine_check_align(dev->fill_align, off1, off2, len);
 }
 
+/**
+ * dmaengine_get_copy_align - get copy alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the copy alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_copy_align(struct dma_chan *chan)
+{
+	return chan->device->copy_align;
+}
+
+/**
+ * dmaengine_get_xor_align - get xor alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the xor alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_xor_align(struct dma_chan *chan)
+{
+	return chan->device->xor_align;
+}
+
+/**
+ * dmaengine_get_pq_align - get pq alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the pq alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_pq_align(struct dma_chan *chan)
+{
+	return chan->device->pq_align;
+}
+
+/**
+ * dmaengine_get_fill_align - get fill alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the fill alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_fill_align(struct dma_chan *chan)
+{
+	return chan->device->fill_align;
+}
+
 /**
  * dmaengine_is_copy_aligned - test copy alignment
  * @chan: DMA channel

-- 
2.43.0

