Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013004.outbound.protection.outlook.com [52.101.83.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBC9542EC5;
	Thu, 15 Oct 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092187; cv=fail; b=AvNtP4wG7L3g0+E3SCoiGy6NF5WyKRseV+GY0gm6GKyCHodtj546kCKmTwVufIYiRKQYyWkT+FmR2HyGjK2xhDyewidXka0Z/8m+qXiSEaIVbH4tYac3/sRpkJnCfNI2OTKezAAZN2ZLUFzNznCys0kPN5j9IMYMtKAoN5DYHVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092187; c=relaxed/simple;
	bh=QTlwEA1sDf7KELWQjIhg3yDBEKLK+YNJrSV6DHMYm0A=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=RRW1pipFqi+gpkYKdSwn3OoQV9PQunGpjU3in9+HTDpi+ZpqX5aNvG2Y9kIxflXoJOMMLZoCGyi2tkGKo4NiVYO+dJTlc/DAAoLC9VOvYRv+62lH8G8BPGwgbrdBRo2Bnm1aR/QtQUp7gDSqT8TzaaXZxCtsUDWaBe5i6s9Xtlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=K2waKi2m; arc=fail smtp.client-ip=52.101.83.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="K2waKi2m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJqo/UVuPM619pHFfkD6AkGZ+I4mq5VvfM6gGrJ6ymLHhSE+SKYFlo0W9GvX5xHfgK1u8AuzUKkp5YNaBpi0EQo0jnY0siQw9JIvud/gEaN6ieT5OupE963chAONLYGKtm1EOqnp+tcr/NPEVeLbCMtQQG06MW7dqYVilApnz5AV1sYmT0P6BdVEreiYmSQDaCJ2yHoWMQpqwv3TdD2tSQyze+/ZYBVvL8wxmaE/EcZROVwM46cJ+udnirLx+kagUJRf0xHvEWCR4+gB2HKFFHaNVLClJTMofYj839Yx9iQNl0ZSmMqKgBuRUOgXDwnDKGLpxvDB0U1nmNWP9bKOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGDR7/9+fYtlXxP+mlcHdyuFn+h7DBVkQRROeFfbxtc=;
 b=THeTaByjHKfP0BtJHvTsT0XVSSw+fGckMfWxVNWEfOuhEJ83Im3Mmi9kzyClwiQa+75LlA6JopMVSXf2FpJ2mgBYdU2n7vss6Gjv/KrXrXOqnv4yMRSzJ+yK9rRqpzCA7WtyOk62R/Y56ULXFVIZAlrXvxXTIhujDKAdHK/6YILUmKHQEsbIID62+ByGyr1JKaz2FUz9SHl8HRP+clcdlRrvY4+P3IWPEjEo5eTBYw40oQGjjCpNkvUbi3X2ftExNfnHH69mrY/QG0CQ1+uLjybu6tESL2jnrqUvc9nlDHykyJwG3rdfJKCpyVRLpweeB6PYmg+73TholFkgHepd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGDR7/9+fYtlXxP+mlcHdyuFn+h7DBVkQRROeFfbxtc=;
 b=K2waKi2mxtI6ug5vx10PjG5Be6IyxnKGA6n5ZOj5aJitE9yxK268QFaMGRSW5+A4PX42KzaDccn+mng+e0bm5D5EdLrCqAHXK+Gy6Po7Nef6g6vS/8s+TOd4g2k/UVrQ7Dj6Le7UB/CNobJDakU0qdPG0PrUPWvvElGE+S4tSJPUQbcqFv4dtgIOvEXHNNEzaFTzPBi5bHpnEcxW2hhB3FB2GBOZvWDULjZ60LEO93mNBVqOGtPsldIWHxOQsBdy50IHa7WOZ2ZoWzlSWJs/TmUK6oiQtd43BG3PeMOr6aV2ikXrWeSpB+ExvLJh2begi7RtIlHZEFOeOEZ73uyneg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB358405.eurprd04.prod.outlook.com (2603:10a6:290:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 19:23:02 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 19:23:02 +0000
From: Frank.Li@oss.nxp.com
Date: Thu, 15 Oct 2026 15:22:26 -0400
Subject: [PATCH RFC 2/4] md/raid5-ppl: replace async_tx with synchronous
 xor
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-asycn_tx_remove-v1-2-056a7085e0a1@nxp.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
In-Reply-To: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
 Xiao Ni <xiao@kernel.org>, Dan Williams <djbw@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-doc@vger.kernel.org, Anatolij Gustschin <agust@denx.de>, 
 Saeed Bishara <saeed@marvell.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, 
 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, 
 Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792092167; l=3024;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=W7my1YlNaXtibhFai49iTowIOuh2zbKGxjHkHr2snGI=;
 b=352slSGw88aA+vdjeIU0E8cBX8GqXOxydXmuchlumm/mdDump2bQNjEZdbLizIQrn5sG46Txx
 XqliAZHehl8AOOpddH/TAQgx3muaUQurdgFzJdfmh1RETZ07oQpEQNJ
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::14) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB358405:EE_
X-MS-Office365-Filtering-Correlation-Id: 55055ef8-3219-441d-0682-08df2af1bad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|18002099003|22082099003|10067099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	lCFU3bhgA9Yx+LT6CsI1t5x/r4l62VbpW1GKECPasqJ1JKik+uaBCmWszqTJnGCFFhZVofmZiOMqovvfYQu2ZOMKbtduCSc/QVIPh6O7F9Vj4v/sLUkyp8UVSrtPiq7CWs3CJveN/n7FUhKQ+H00aQfg0ECL4p4cdOezD45L8V4jtNQF7LZUdtB9fbN243aqE499kOR8WuJgKtx5phsD0z+x6/gD92JQqyo71nIRPcnCyhKG4HP8yR444ES96yItcskuhKSlJmlNDhJXIADYaajSs9aeRMi+/t9KUdw2SBaDxVfDsAYre9++lqwc409y9u3mXcuwSBuCLfZTOGBYgS3zfmrAW8Xa6Tk7hnWh4BEhvOUGDh4Ri0VCoHOZHVwUrf/mBoFtyLY3IJsyUyiWpnAx7vuUJU13nZH5YM35kXiYrGCWQTjVp1rFXb6KhIuyL2M80P1RrEGagODxmRrehHS/2hwhjZYfQBCD+Vxx0WeSN67lHxOS8kqnx1OAFcg0fZgHoXIcFrqyaN4PlCKiWDh8DDvNBPofyr3u+/Tr4dSwYhjqzFBsxKo0oUuDcXfuq+KACP/zJ+ytBY01/N5amqnLpdeFjlNiRJiwP7AEM++3by8NJR5rOWXEea4rdY3z1jCGvmjOMoL0TsNFP5DL6gdRSNoQueCWdyEEqbCMOZ+zDqGLFdTCZbOUbpG1RiHIwMgmFhmhNKPWuk1Dd/2C9g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjVKRkVpRDRBQ2tZUE1KUlVSR3RlWHlnR0llYXZIak5aSXROazZJaFVUWlFu?=
 =?utf-8?B?YzUxTzhkTGQxTkJnUlA1UUFJTkRUdzlqUFprUTZCbEdmazBBcWdGeFhpc25v?=
 =?utf-8?B?OXZGSGtQMys2d2dmTDBrZUExTzlLYUZnYndlK3l4bUxsdXhLUEVaRXZicnl4?=
 =?utf-8?B?NDVzZHNyeisxemVkZUF3VkVoaHplTUVDblZVN0M2aitFd1ZzUXVhWmdiYjhF?=
 =?utf-8?B?ZWk4Z0JKb3NJVDRZSXpibFIxTytMazBDR0gxeUlzd0dqVzJ2aU0zNzYxQjcv?=
 =?utf-8?B?Q2d6MSs2dXprZVA3VE5UM2Q0RkE2dTJrcHJ3ZTRmTndhdGlEOFRzYkdkc29L?=
 =?utf-8?B?VnhMRkNIUm5aYVMrODlyTzdlaGkzM1FySmlodXFJYWYxcW81WlFQUmJ2NkZl?=
 =?utf-8?B?SE1QSTA5LzVrWkQ5NjJ3aktoU3Q4QnE4SmFiYnBsMmZsZ29pVXJZMDJ3eVJX?=
 =?utf-8?B?Z0NKNTVHQ0ZnUkJUSHo1M0hscXc0SnF1VmU2YVlEd1NadW9GeXNxVUoyNWpr?=
 =?utf-8?B?Rnc5NXBrL1FyTDJ3WE1Va2ZMbVhENW5HSGFYUkN1b1FUd29rVS8xN2ZHQmFa?=
 =?utf-8?B?a3FPS0I1ZVh5SzVzbS8wU1kvSVJibFBram5mK0xHSHRXVVBWeDdkdTg4WTg0?=
 =?utf-8?B?V1Z3dnd4K3puKzlRV0JIZHNWbVNuS3V3MnljNFE2SEtmZmNRKzdWamt0cElm?=
 =?utf-8?B?c2tJcEQ3NUFnalo0T0w1bVpFcW1WcjhTNjlmMit4Z2FpeWJSZlhROW55bC9J?=
 =?utf-8?B?MmdwKzF2cHB1OWJrNE1oTlFLbXcvalFJMlltRm0rdmJsa0wrZmVKbWV5QytH?=
 =?utf-8?B?cWxQdjhwY1hNMDNwMERtNWZneWhwRUlVMEo1T1RSMjgyOWN3ZTk0UFY0NU52?=
 =?utf-8?B?TzlpbEF3TVhyQnI3cElScDd3UWhMempRK0hHYlUzbXlTUFU5alpwU2JSWW5o?=
 =?utf-8?B?ZlNOTEYreFhQaWFiYjZSZmFMTDU1MUNKK2ViajlMbWFSeXNodk9INTZSSUdm?=
 =?utf-8?B?ZVBlUzlPSGovRyt4aHJFamM0Vm9oaExwSEtKckZoSkt5aDgwbzZxdGJ6WmRI?=
 =?utf-8?B?YWgzdWJKeUFXSXBWVnVPWEoxaThJVG5zam84dm5xbFFXUFBjVnh3YXhBSkcz?=
 =?utf-8?B?S1ZtYkcvYm83UldpNVIvVVo4TFBLMG15ZkNyWjJCZzFHbGdHYWF2bDlTeCtN?=
 =?utf-8?B?QWNBVlBXZ3BMdkVZOXFhb2xZdktMYXhyODBDTU1TVUdxQURscUxnMUZDVW8r?=
 =?utf-8?B?TS9EdU40Tnk0ZU1rNXBHZVlhMDNmdm9DNlhQU1Z4bWxxN1RtTGgrUmpReUE1?=
 =?utf-8?B?Y0RjRDZ1Q1V2ZG5GNXFjRzRTL1Zua05MTmh4Z2U3ckt3aFc1UU11a3BISW5Y?=
 =?utf-8?B?ckdNVVhZWEtDMXpQQ0VQV1FVZ21TaXRWNGFpbDRKTVpxVDRGeWtSTUR6ZlFJ?=
 =?utf-8?B?ckp3ZzNWR0YyQWc2cFo2UGJrdTRHZUtQUDJCMEkrazh4UjYvM1VZTGNJQi9a?=
 =?utf-8?B?bVNQVmhrMDAwdjBYUnBkN2tPT0o3U3pMaHVSY0xOMzRYRXJodW5CVXlQNk9k?=
 =?utf-8?B?SExDZlBnLzV5YTdSdUlLeVE1dGxnRHhIbEMzYUVXWTZEbEpMbXpSS1BadDJV?=
 =?utf-8?B?ekl0VThjeWY5cWVvT1d0TkVjb1lZUjZyeFZ3cy84eHpsMmMvdkFES2lyWTh5?=
 =?utf-8?B?Y1gwb2hrNnFTdEVDU09xN2MrZDZDeldzK2htZjZKZ09SZ0xnZnBSTUFoZXdI?=
 =?utf-8?B?VGRxTG4ra0doNXZ4d0RlNWgxVStIREtYQUJwN0cwcWNiSDdvZjNnZ3B3MStN?=
 =?utf-8?B?ZUVQbWFLTnBFaTdvR3NJemtKbmZBNEp5WG1YM0V5R0d0RU5zUkFqTFlWd1VN?=
 =?utf-8?B?aktzM3ZaYTZ3Z1BvTVlmYmMvL2lYU0JyQnJTN000RExGcEdNSVduRlNWV0dG?=
 =?utf-8?B?YlVQWEREZDVtZXdXbCsxM2hOeU5qcUdIekxSOUFBbU1HQWNFTFA3cC92bVJw?=
 =?utf-8?B?cVVBT2U3VTlwNGdRa1ZxdklGc0U3am1ERXJhNjYwdlVHTjRxTmM3RUJMeG9E?=
 =?utf-8?B?T080blMzUDRDN0FzSjIxQkN3dWdCV1A0elZnRlpqRDgyRWYwb2FXcWR2cHFN?=
 =?utf-8?B?WEhWMkY0YlFnTDZGNWtyTnE2Q0tLejJNa2lhc1FWVDcweUxlNEF6ekZLVkh3?=
 =?utf-8?B?QTNvWlJjOHRBSXQzeFpNdTZHRWdjSFhNU0lxQWVyTktESlZHN3lFNXpTY29l?=
 =?utf-8?B?NjA1WHI0cytQemk0YUxGWW90U0dRTWRYemJxTlQ2WVVPeEdSQTYrS3QzRThX?=
 =?utf-8?B?Zmo2QThaNS9LblZxMlFITHViZUoxVkhUZFFQa0x6U3U4b0JsaXJ5UEJDaTA4?=
 =?utf-8?Q?xcFLIo/y+rN6YBSp7zEhPdsW4LpzCmOFYef73?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55055ef8-3219-441d-0682-08df2af1bad7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 19:23:02.1476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUFy0iTE66J0D7fiQJ+GqvPRgpGCoRu2SWrxTXdVLE5w1FzKLPQerhEl5uWkaqiE3oT1d22LRArTmJ8xTH10qWzhMbkUv7u/EFtp6aCW5g3KmpxP8fb+vQwsnoP3bjBx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB358405

From: Frank Li <Frank.Li@nxp.com>

Remove the async_tx dependency from ops_run_partial_parity() and
ppl_xor().  The function now returns void and operates synchronously:

- count==1: copy_page() replaces async_memcpy
- count>1:  memcpy + xor_blocks() replaces async_xor
- ppl_xor(): xor_blocks() replaces async_xor + async_tx_quiesce

Drop #include <linux/async_tx.h> and add #include <linux/xor.h>.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/md/raid5-ppl.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 7f8a9d3fd578d..bd844b4e8b372 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -8,7 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/crc32c.h>
-#include <linux/async_tx.h>
+#include <linux/raid/xor.h>
 #include <linux/raid/md_p.h>
 #include "md.h"
 #include "raid5.h"
@@ -154,14 +154,11 @@ struct ppl_io_unit {
 	struct bio_vec biovec[PPL_IO_INLINE_BVECS];
 };
 
-struct dma_async_tx_descriptor *
-ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
-		       struct dma_async_tx_descriptor *tx)
+void ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **srcs = percpu->scribble;
 	int count = 0, pd_idx = sh->pd_idx, i;
-	struct async_submit_ctl submit;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
@@ -186,20 +183,20 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 				srcs[count++] = dev->page;
 		}
 	} else {
-		return tx;
+		return;
 	}
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
-			  NULL, sh, (void *) (srcs + sh->disks + 2));
-
-	if (count == 1)
-		tx = async_memcpy(sh->ppl_page, srcs[0], 0, 0, PAGE_SIZE,
-				  &submit);
-	else
-		tx = async_xor(sh->ppl_page, srcs, 0, count, PAGE_SIZE,
-			       &submit);
+	if (count == 1) {
+		copy_page(page_address(sh->ppl_page), page_address(srcs[0]));
+	} else {
+		void *dest = page_address(sh->ppl_page);
+		void **ptrs = (void **)srcs;
+		int j;
 
-	return tx;
+		for (j = 0; j < count; j++)
+			ptrs[j] = page_address(srcs[j]);
+		xor_gen(dest, ptrs, count, PAGE_SIZE);
+	}
 }
 
 static void *ppl_io_pool_alloc(gfp_t gfp_mask, void *pool_data)
@@ -706,15 +703,10 @@ void ppl_stripe_write_finished(struct stripe_head *sh)
 
 static void ppl_xor(int size, struct page *page1, struct page *page2)
 {
-	struct async_submit_ctl submit;
-	struct dma_async_tx_descriptor *tx;
-	struct page *xor_srcs[] = { page1, page2 };
-
-	init_async_submit(&submit, ASYNC_TX_ACK|ASYNC_TX_XOR_DROP_DST,
-			  NULL, NULL, NULL, NULL);
-	tx = async_xor(page1, xor_srcs, 0, 2, size, &submit);
+	void *dest = page_address(page1);
+	void *ptrs[2] = { dest, page_address(page2) };
 
-	async_tx_quiesce(&tx);
+	xor_gen(dest, ptrs, 2, size);
 }
 
 /*

-- 
2.43.0

