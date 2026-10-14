Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013069.outbound.protection.outlook.com [52.101.72.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E16475351;
	Wed, 14 Oct 2026 19:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007098; cv=fail; b=nzzMHF46Ue/0S/w4rR1/jP4iLy5W96aIG4ikBDlxGbdyaFz4EHTrxjyiPrdU9Wkzv9hLGyY8QxFRIlNR2ZmuQr2c6hwyeL3n8A9sH3weVs5a1o9VlFGoafqChszS2ArHJvkH1eW0VcYgigqRHAlVJ4RxTq7gbvz5ledJ9l5EPsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007098; c=relaxed/simple;
	bh=6DqAHkfC2Jc7FXdn0SHAEvbeo08sWgBpg3RWbN1p00E=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=pgvNuA1Am71JC5/YGWevQxDDIn3Ir5YhP5mIItD5NENGzt0bEU9fLuiGzuMccndMZnKx9+WR1QgMwqL4yLwUSyBE869FGg7xrXINx1QhRv5wxTJCPcQwus2eTIT+B251SzwR0YUeDLYTXO3onjGseEiFSyASoI2IqejzdpqWv8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SsozPA9j; arc=fail smtp.client-ip=52.101.72.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SsozPA9j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypG/6/IompunuEeT7UMu1iMrZ+U4PrOaucZeRjnxviY0CaAwHvmWMSBqgfRI5W+6XGpQFJx075t1GNajFskBQV0weyDmKqh6fDENcsYt3rShqH/dY39FSw6Dv9iFFh4iBVes4C+MbfFTqqm9XMKZfWjP+I7+TmFLU8NgtnxxWY7dElPPEaxOMbdxv3JDDTFf0XNvq++IbwrzFwMye08J0/z03ImhIZcIQM69+PExKksg07BGzV0F4sPBPFa5p5Bwq/tyizrrN+aI1L8sMuKWnp7d8L2FravXyko9I+nvKME48SQUZpdCDLDVEcLlm9GG5flcf/Cw/w5j2/zldQK5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLg381QfbQ8A483J1I1+e2fDI4paJDYuvlPr3GZ5m9M=;
 b=J43oVjcwt8Jn1N2wN3i9ehu/Z62QLmm2AjjSBgRxFfppBnslvfv7vSyzHPZFckIC5KrLgg44Zrq9L/49Ndnz20uw+zmKwcL05RMBM05OygbYa+VTLa6klbwGLppCvcwy7Pb0KVTHMl0hluI1k2U2AmwZZsZcfWnbZtrl+zk8dlzhvDmnQFYYmfgs59CmzmC62ALYp0LbHHCYzxlmIvipprHsv6mTQspsB/Doksopf0Dv3TOTtsKnuZd67881M9JXSODOVy4Wai1VpAQs7bUWnAPRdhaebEy9NSyOs/VbGU7iJgmf/YDehn1ttycNwv7WWxbsY2NRWDEriDuFRA6PDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLg381QfbQ8A483J1I1+e2fDI4paJDYuvlPr3GZ5m9M=;
 b=SsozPA9jPoptXko47iPbYZH6+wvz8Ea0W8WCEunAt75gMvJOH7nOpH8C6z/KZMPGDkzpJkaie3jq9jtS+bAEan9I1H30PymtK3SblFmUn2vzaQgay7YW5BR0+MNkm9mbtfrMIF/473iyCRX72NUQvKaVzmcQNyfdzcvXJxiM2YcawRPbItVgldCz62MBY6ZGLnDLr5AvWfO46VQj+zYLBvaVKjlNXDOFpqDrqsMbopQzefln69zflFUf7vCs9Dw+36AMJ+MxnhKc29zKkmZLq845ASew5BWQp2yHt6AKDh57odVzIDJYrbK+YsdfoQ22031oBPdRAvsZfmZXWxgvdQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AS8PR04MB9175.eurprd04.prod.outlook.com (2603:10a6:20b:44a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 19:44:39 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:39 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:50 -0400
Subject: [PATCH 6/6] async_tx: Mark as Deprecated in Kconfig
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-6-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=1022;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=PZKrx+eol9Bxuv9/O1L5NcV6UFtha8ydQXN8DjT0CSY=;
 b=S5m5D32Age6ocSqyW3ehbQRBI5GNb4+5qOjwEpvz4cI9PQn9HKOzy08mA4nVCTPt4yQPnDOhd
 whQYK5gWZBQDzWmFO/U6hW229xljyqAWErRo6HtNjnUOuYnJdDdA7v4
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0134.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::34) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AS8PR04MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a9a338-b703-4577-d964-08df2a2b9179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Z+wAa0AUg5Y1Fs7zzV23S2UB1+iLrHIVN/rIMvPObBzqqWuLRUpC9AkLmjgukjXHjwuz5s/jNMOavsAM9LN9EtU42M5aT3MG71gXEqBd0prgC7EBYxlhgZndl377gVLZt3sVJoRVwcye7TAX8lTQ6PV7nh2xOJwhX18QWTm4eBA7Ckx3o85OSNI6OP7SDtJVxss1ZDb0U0hkBhrLKqszgCS2qV3b5MmAf6/FziVihSgGYFLPSfdxyNLNFocUMYQgmr9bkg4bRNsBdQaq+V6x32SQ8xD5I5HlQP7wWq91hgxXiBeY8qHsNrtvixXIJB1x+sx7DaVSeveGetjEtGbeW/AU+ip6Zc6shB0msGyzLSIMsJ9sxJc96oBrLNz2KMzS3ljM41Ai0ltBLfT8d/z5Ta1S7Hg3xELJ26OzZYQktqs1FJbUH2Jm0hh2+4N9a1UD4upOim2yiGvZxOqb65VLed9lmJLX+CW9EUmEt5S9KtgsTINSp4yTe1rKNZDA3OMdR/czZo+6bQiSqaNI/kPEOdAbfsTYv7+hHmKzo/1rXvAoMwR/KFdOyram8clTIR/mC/ErgLQhmegGioONXRToUH9wKk/Sz+6FQXa+WkREu6xztXmxw9dSoY+erSWEsUs3f4LvkvHLaDo4yU+W9YbYvfo8cR/5GTfnWx9AHpA1b1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGNHd0oxZjcveE5PamdVMHpBMWdGUU1DK2NFaVdzQ3JCMlJtZk1oRndXOHRX?=
 =?utf-8?B?OFFyY0d1M0FNcHo5LytBQ0R3TEUveFhyTFVWelgza3R2bGJVakNHbkc4M1hx?=
 =?utf-8?B?RkxrQ3BGQjI4TFFrbFdlb2RiZlphRmgzSTdrUlJHbTZsc1c3WVovNmNmVEs3?=
 =?utf-8?B?b1pkZTdoR3dJUjBES21DbW5XUDhneUZhM0FMRjR2UTZKcFhpQmFjaU1iUUpn?=
 =?utf-8?B?bGZkOU1zRWs2cFpZMVh5V0RQQmRyL2tDa3FnRFg4SGpsT0VPaWh2TnNFTVha?=
 =?utf-8?B?eHIvUUhlNmVQTldNaE5IaHJOdnJ4YjNXaE84Q2NUUTFRU1lTQXJQUjZYRkdq?=
 =?utf-8?B?eUE4NTUrblJIK09vWldLNTZaNlpNMG1GUlhya1ZNajJvWUVqMllHcWFTeUEz?=
 =?utf-8?B?Q2k4aERveStUUjlLUUVuOVZMRElGd3ZSK3dSWUdmOTBqK2NxQlVRS1pIUUFx?=
 =?utf-8?B?RVRuRE5yZzFOU1Z4NHRqYjY5Tlc1U3l1MzhjbzVueTZaY2ZqWnFCazdzbGIw?=
 =?utf-8?B?REhKcVNYVWlEM2MyTmhvcno2WVROdG9kS25nbUdxWVhSZGxGcFFZWjh3TDFF?=
 =?utf-8?B?eGcySTN5dURzcVFiS0RUdHRqREFKdE1QanRMbDRmWlJjZ2JwY0dLNUN0bWlR?=
 =?utf-8?B?cFcwekRlcjJkc2ZZRFpWd2x4cHdaM3g0SlJaY2VycjFVcnZDQ1NvVFBGNUpI?=
 =?utf-8?B?QWIyTll5VlBOMWdWVW9aUk9sQ3ZJWlEyczBnTmFvV0I0VFEzdDU0alZzVkhm?=
 =?utf-8?B?cDkwd1I5cUcrM3pkUVZDRSthTklCbEtwSDNEeWwyNGEyWXFDVmY4UXlnK01D?=
 =?utf-8?B?cm9GV2lid2grQzF2RU5IUU5WWGNlZ2dwRTdSd0orYnZOekQ4L0k1SkVXcEhQ?=
 =?utf-8?B?Z1N1bEg0SFYvZXFaMVZMMzA0SGFickNWa20rdFdmTGYrNGZBSC9XeitKQmFy?=
 =?utf-8?B?NUZoMkhTOXd3cnZZdjNhMS9tN3RJWWpab3BUTjVWdzJyUHplYU5DS3ZPV2wv?=
 =?utf-8?B?WmlwbUdYeU8vWFdHcjFTQ0xKMGFNMGJwUHErNlJXbFZIbjdxLzJqVkllUDlq?=
 =?utf-8?B?R1dWQXlPTnVIZ0xhSHVzWXJ6RTM0UzNHZFMwMzdjZGZaaVJMSHE0YzlKZW0x?=
 =?utf-8?B?cEF3MjF6R2QvNFpYNHpIMEEvNHhrNmlRRkNyQkhxZ2toa25POHRra1htVUow?=
 =?utf-8?B?eGlGUXdjM0dDR1NaWC9abURsenpLQ2xrOWtqdEhiR2o2UUdKVEJwTjd0aXNr?=
 =?utf-8?B?UVl0ZHJNbUJqT25nRjZkaHpTeWoyVUlTQjI1M0habmpDVjNseUo5bVZucFpS?=
 =?utf-8?B?YUo4R2ZSTTlGV2hIWGdxVVl1S1Q1MVEzb1NreG8xK0JoRmoxQkw4MXJHTGtv?=
 =?utf-8?B?SWhlTGZhYit3bVFPYUh6S2pMbTZZZnovcU9aZmRPMmRGN2xQalVDalNKd25E?=
 =?utf-8?B?WW5uWjAzSEZGN3pMcU5nNFYyRUpIM3dSQUJWTVA3VE5XYXZlZ21YZ1lWeklJ?=
 =?utf-8?B?dTdXUWNUdVdSNGZvaW9jbHVXYUNIOEUxODFMMUVjeDZneU5WaWxBTHBITG5Y?=
 =?utf-8?B?clpXcmJMdTIveFpxS21abGpCWWtnMFJuSzNNSzc3dElhVFJoL1pKNU1FdTdB?=
 =?utf-8?B?YXJnNGN0RjMxYXlNRE8rbkI1N3pneTR5cGRTSzgydHBCZ1Z0WEI5a2RxK1A3?=
 =?utf-8?B?aHZOV21rL2tLM0JveU1rME5tbEtkbmFVRkY4YkZ0UXlUdVpMOTRoUkJtWVlp?=
 =?utf-8?B?eTB2cVNtMWZ5YnM4QnN5Q24vK2hHNlRKWGd1ODZOQ3BRb3pNR09sM2VkNnc4?=
 =?utf-8?B?NGx3d2tWWkRHKzB2TmJIT09VaVdBS3RSYy9GeVV1N1JxLy9SN0tvb2FPdGI4?=
 =?utf-8?B?ZlhjdlZVUHREUTNLWG9TSGJjWm5nN21ubnFGd3AxK09YeG14dGdqemYyZVJs?=
 =?utf-8?B?b0V3QXJqaDBvWXhvN0xqRVV1bXRnOUxWYmJqME1mTzlHZFdWN2RjYzJXWUd2?=
 =?utf-8?B?VDlUdDdCQjlYVlhuK21xNFh6b3hJQjNsemw5UFNPT0o1L1d6THNDV3FPK0VP?=
 =?utf-8?B?WFcxdUdjZlRDcGQ5NmdxbzE0OU11V25sMXNjRkZUTXc1WUpLY0NoY29uMy8w?=
 =?utf-8?B?U1VxclBUQ3U1dmpKa0JzbHNaSWQ4dWRNY1d3R0VQTG5LTXF6TTBIQVZqNWtz?=
 =?utf-8?B?cC9IZyszcmU1Z0xkOTEvZ0p6OGhUNEV5SUZBQXNEbUZSaitrZ1ZQRUlUeTIv?=
 =?utf-8?B?YjBRY2N6YmRpbHM5WENqVDhKUWh4QkFqZ3VCenVsR1dtVXZ6WmJBL1FvWnFV?=
 =?utf-8?B?OHJJcXVhV0tzcm5Qd3VDckRrelNOdjZCdm5wMzNvckNRa1NJQUtwY1JXWHVa?=
 =?utf-8?Q?G3w0mC1ZtySxpwiYyBnNyfYNrD6dkUVnXt+9Z?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a9a338-b703-4577-d964-08df2a2b9179
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:32.3869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exjOM+U7t8KjpSBa7aapS0uh5LRzLWImqBy63LopP0NgpNtFJI7dOBQbSf5Isjqn8EX/1/7Qk5H7IqmHkkK97iVbKqIN7jAtPcIKpPmHY4GhbFIR3nPzGdfEf7IZVT5N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9175

From: Frank Li <Frank.Li@nxp.com>

The async_tx framework was introduced to support asynchronous RAID
memory operations and DMA offload engines that were common at the time.
Today, adoption is limited, most clients use DMAEngine interfaces
directly, and the framework's dependency-chaining and software fallback
features provide little value for new users.

Maintaining async_tx adds an extra abstraction layer and ongoing
maintenance burden while serving a shrinking set of users. Deprecate the
framework and discourage new users in favor of direct DMAEngine APIs.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index 89bafa2efc300..02d472fc7a476 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 config ASYNC_CORE
-	tristate
+	tristate "Async tx core (DEPRECATED)"
 
 config ASYNC_MEMCPY
 	tristate

-- 
2.43.0

