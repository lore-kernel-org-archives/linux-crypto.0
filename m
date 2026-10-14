Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010009.outbound.protection.outlook.com [52.101.84.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956B45FFA7;
	Wed, 14 Oct 2026 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007045; cv=fail; b=k9egQ2Ptp0Fq1LJUJUYys3ytylPpKvOqVBZTj5CepN4nR60mXWQnZyQ+e/iEHTcNfLM0qIur0bddf67ShvxcH1pY/irZcrGkacDDUG1lvxpIU+XHAp8vPH3CrxT8gE2sbN0cD51l7IVxfACY1UFrCvtfjV4AGpCpk4bYdFehTqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007045; c=relaxed/simple;
	bh=y49ywawOtke30/9JfIRWacfNCuN4m6948xLqZb9/Y4E=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=WzpT2SYaL1QiNCYjFNJNQrXnlB6wVt+SiX2QEU99z3u0lwQqw3HrBC6rHrVs2IMX/1AsZPLOO+d1svLgCGitQ92JvkP4acW8enFK/ItQ2nvwvJAYRQ6RA2WGAu0v0iOep5lkDZJBLT0gUD7iyOgUSY3hbqdowhy4qrWrvp1Eq1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=M4JXahGl; arc=fail smtp.client-ip=52.101.84.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="M4JXahGl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9VNJNlelWSuHVGzLj784tZTbn5H1gGambCHFwaBSWlK6RI004DqaeNAsMe0yyYnzemUgOiZHcAbjQYB08wGM/I4Fzfun2YFwPSTBVMYZvyTtDwo2P3m759HQ5cgdf7vLJXXepw7PCHWKdkNL6u5vcwSsGwtHqqkJKOyaQBobiu7+vFVDUp+5un7l/8sQAYMuZlZZLeOp9ye5dYT0jS4grUhB1Qf5dfvyKnZ12UJZT3J2gObOXb2k6Bv+cJ5r3jKf9hWLgqn2KerRbYXiVbm0Zn0SXH83JoqHjMiljH9UsOGmFi5Tk1anltiU4zVwZWa1QFiZL/aQmWXCz6S83sRyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LyPYdsMTErn4PdT749/FZyug+7INTVlDM2vFS9ch7A=;
 b=hOWY3qqnPYhgMPepwGthbwaf6Mq7FjxB0qbNvyTMFrHA2kPNLakh3F29bnQyYkhGnp0NYX9MYZcmWgFxKBxYogZAelH13cMDYhdjG/FJNI8ZrFu0aotuZy5gn/+yTgpTBX/X76uiSTcHDWk2c5IPOmusT8thIXi05cCkG9cyu7GJlAB2FuOWd0kO8qPx3GuW/dcS64fuqBNLOGqHkhA5siKsoXzKkLKQj9J30KjSvEcyW/MdoadBMdLDlz6Ia2kdDD+t5FcpTImYa0qondvRCGOHh0lijyzKkBVJQmaSCrgkeiyCikVzZ2KQqlDP6FWl8gMuQ5trslNFkbA4zw9uYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LyPYdsMTErn4PdT749/FZyug+7INTVlDM2vFS9ch7A=;
 b=M4JXahGl4FKLb7XuAjmfhSo9NnsRN2zPB3dKocHZADcT4uz9zNkwcSaI35hhpMT/KhvLCPoQxmhbjOuvbklqFWZ3MU+JMQu0ni1e3y/uBYxJbtD4NZXEB8ge/kRZkxsMJPdlb78tSLYvImP/ErOu4lJxUrWIbHA+XCKQfSxoLF24wNHOATu0QQ4rT62inpoR7oXGS2KwcUVyinAbEE82aLxoJVjoDd0gX/+6dUP3D7vahdCpW/QrSbb9PajlQN2nhsJp9tyVkS11OEvHSSBsmFjes8LrNIHDukM+rJqJ5tuuvse6tuvHF23EUPU/w27KLzXkmws/3hanCmhRAp8RPg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:00 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:00 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH 0/6] async_tx: use DMA Engine APIs
Date: Wed, 14 Oct 2026 15:43:44 -0400
Message-Id: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHHbz2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0MT3cTiyrzk+JKK+JTcRF2TNDPLpDQLA0NzszQloJaCotS0zAqwcdG
 xEH5xaVJWanIJyAyl2loA34y40XAAAAA=
X-Change-ID: 20261014-async_tx_dma-4f69bf80176f
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=1445;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=y49ywawOtke30/9JfIRWacfNCuN4m6948xLqZb9/Y4E=;
 b=3jQzewPtnD7Hz7HovWPF8+GqFlCyESb57FCMp7LmL1haltZjWf9XNdThKgULQjH98CtTQ+P9p
 NsOO8A50FSUCLQDOgRvN5k/6UfnMXsv4oGmOpwB+9tbThoOZ0hh0Yd4
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0052.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::34) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b32ab30-f35d-424b-fa46-08df2a2b7e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|11063799006|6133799003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	0RpyvvZnwiBnl2vNff3/IhuTn94MtL9HCKov5ZJpG7+r2ytoKy1/APR1QVTgZiQMquPzI4GEUE/aS82EGxHPmQZRP3xjBZWgUX6GJyFj1ox1Qpo/LNO91dy3b/eONPFahT1tPBAUxh2JUWckjel21EqQ775ZAMbo0uAH3rzoEFzLtHG++fMqeP17vVmhnAPWMfFuVDss6bRBrU32yX+O+pm35mFWRjLPRMfXNtg381UYr1LZnH8MuVgrqgkOu1l0akI3+mPQZzscc7z5wbPtrf/q9J0Vmnm4+dDt3aOmKUNAmeKbHrqosLEKlkgffVCcs6vwKslQf45LU3qTxX8KGZbflLHCM0rbFKK8WFY3I0ePazi1NhFNSg9EWczlM8F5jqZcvBznZk3a+t/BOWkyTWnANfCF4fFEY2jX7j5zDhpH8PY+giskV6C87B9xQl9x7GJSN5Tx0/LKU5wpoeXgWEuEf23cVe+nIrYOpTZtX2Qjw0aUXPVqiU4jQkWPjrg6WSZAR9j9yFeARTQgdbY9juvTAOxV91vCrhMQ8U+Jky4lBw8fIfuwr8J1khnnbomwz8NrNyXwn7tl66sTf0WfBKizGRRsEs1hknAFQOPSUzTKkf20Ie6dc9yPeL7LJKC5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(11063799006)(6133799003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RENQajE2aFd2RXhXZ282a25PVk9iSlhsN2JuSzYxNXBwRmsvTlZ0eDl2OC9U?=
 =?utf-8?B?MFl2WElKUGdtcXdNZVZmUGx0Y1FpL1E4azFteHN5Y1JYRGo4Q1V0c05IOGhS?=
 =?utf-8?B?NTNQeEVoRDJCQkdKUWJRbk5DSFRIWHZlelY2NlBhcEh5dS9ya2pBSVF1cDUr?=
 =?utf-8?B?dVpBY3l0Vk5RcmFhWmx2RSttbTdzZDVndy8xT0dFN0pnY2tDdjNWY29vYmIy?=
 =?utf-8?B?V1kwTVFYUHlkTjR5bzJ2QmRoY1lDUytVSHJPQW96WWpqbDBZZENFOU8wdk1W?=
 =?utf-8?B?QXNhL21Yamw3Qms0aW5xWWY2djRmY3ZOY0NjN1BJckVGVUs0R25VRFlOejFj?=
 =?utf-8?B?T0ZYNXVpT1U1cS9lU0FrU1czWTdSVjRNQ2luVDY5MDRseGg5cTFMcUtYR0pt?=
 =?utf-8?B?T2pkeFYwTnpBaU0yaGFIQVY0cmtZVGRDSDRWOUJzUy9URExMYTVRaWw4cnlk?=
 =?utf-8?B?bE9hdklnYnBDd0lGbm5TbzlYeVozYitxbklFODdNRnJYRDBDWCt2S3VMVXY3?=
 =?utf-8?B?dUVJcXRyVkRvelFUcjhlTlFqL2llWDdoY2wwWlVPOUJLQ1QxUjZFZVVraHpr?=
 =?utf-8?B?cG1uU1lQOHBJMTRUY0lWRTQ3L0hCeVlSMlZwWTZPYXh3aDVvQnQ4bkV2VCtO?=
 =?utf-8?B?S2o3RStIbzBPeWtsdnZoeCt3TnJ5ZGZGQURqcnY0VmRPVlhSeFByVFZ1TmdD?=
 =?utf-8?B?OXFrTmpQTkxiV0dJb0ZiS09RVkc3d0NIMUJ0TmxBckNWd2dscE5TNnVNR05F?=
 =?utf-8?B?Y1AvbjR5QTNNaktNY3l2V3g0TUR4TWlyMUdaYnFMZkVYa1FSUmo4Uk1mWlIx?=
 =?utf-8?B?bkNyMkpEa0MwNXpaWmxUUFNVeHh2L1NBc2k1SURpa2hQMEw0UytzVWUxTFk5?=
 =?utf-8?B?WXVnUmNLTEhQS3MxZlVDTzZJRDJqLzNTTFZycGpPRWpBemxpSndzTXRTd1Jo?=
 =?utf-8?B?dWk2ZitucG5sc3l1WDlYeDVaNTBYQ0ZWUzAxZkM1TFkwbXlTOHd3eFI3Z1Ni?=
 =?utf-8?B?azhPNzQwVGI3VG1yaERleEY0Tmd5NkttNHVXS2hDc0F5TzJnQVJuRFFIeGI5?=
 =?utf-8?B?L3IyV3E3R1pXTEFYSHdKbGd4L0RtbGNtclF2UXQ2MmRwWnJ3d1N0eEt3bEo4?=
 =?utf-8?B?OTJMV3hVd2J6cmVnRlNVM20xbmZXUGtyMkRqRmVuUzA4eTJFS0plTmIwakt1?=
 =?utf-8?B?RTVBV1pqcThLTWZDQ0tZZnpUVTMzcWRJNjM2dS81RG1hVllGeE8wTC9yeWtD?=
 =?utf-8?B?clUycFVJZzlQZXMxdXVLLzgwZVhFbzY0S0R0VE83N1NIWURtSXJVbW1jN3A3?=
 =?utf-8?B?akRjNmdKckxlM0N3NzJJMmV5WStNd2p3S3FrYmwzNFRPVldHZU1HNk5SdUd1?=
 =?utf-8?B?UHBGYjdOalBqSStkZVpYNEtSMjd5RjFKajFEc01QdG03L1R0WmVROTFOdWc1?=
 =?utf-8?B?a1VGL0VSUW5uNHN6QWpIOFU3cy9kdjB4ZmZoQUh0a0FqRXNGNTJDYm1OWmN3?=
 =?utf-8?B?aTVGcjNySnpRZVlhSDV0QzBSWGtNYUwwVGV6dTE2aXpsb0ExQVNNWWcwbXRK?=
 =?utf-8?B?QzBpTUQyMTJ0SGJUNTNUZEZUTHVwQ21ZK0tKVXV0S0JhNnl0eGxBcDJZY3E4?=
 =?utf-8?B?aVUxcWdUNE4rWEJNSTRSWW9kSEJveXErUGNsSHhpKy91dTBISDVhdmVBRjVH?=
 =?utf-8?B?S052Q3FZVHBmSUxYdmpEejc3b3I1SzIyMkFnajlHZE1pM1JmOGxUKzAvRzRk?=
 =?utf-8?B?ZHhEWnpXVktUamVUZjgycTR3YkRrbFdkOTZ4cGh3UnRHbERMTnlFeEpvV3lS?=
 =?utf-8?B?MTh6NEZPWnZUWHM0bEV1SjM0VzdHa25JODZySEM0ZzNsRkhhazJ1T0t2clB5?=
 =?utf-8?B?c2tsZXMycHRhbVYzNVZJZGtNNEIyUGRSZEJ3b0RuYVpvNlJEcjZ6L21LS0ZP?=
 =?utf-8?B?M0xkOFdMKzBPUDlDOGhVZzlyamZETWcyY2c5b2wzRTBLbDNoL3dRc2tTN01G?=
 =?utf-8?B?K2JON2VrVVVKQThiK0c4dDdEcWdBNWVROEttQ1QyLzkwQ2RJQXFlT1k5cGJn?=
 =?utf-8?B?bmlTTHN1RnlncWIzd2w5SXV1bGdJM0UwNVdhUHlzREVlcUNSSGpxUXFPN2Mw?=
 =?utf-8?B?aUZaNTFpNG5DeksrbnJaUno4bmhlWVViUEV6M3l6L2Q3dlZ4MUJOejltM3Fv?=
 =?utf-8?B?R0JvSzBxL0cva3VETXg3TXpHMkdVNTljRFZ1Tk5qZkRCRkxjNm5hUHUwTXh4?=
 =?utf-8?B?NmdpV0I3WkpCSWp2WHdnY0U2dVp1SllBa2xaNHJHaGQ4YndGL0JRUE1CRkFD?=
 =?utf-8?B?WHFIcG5RRTNKcElvOEZEdG83VFRPd1RSc2g4UWlkYnRkYWdKOWNJUFUxekhi?=
 =?utf-8?Q?Alewyh4KGSDSXs8QoVlllJze4YlkGLVtyclHn?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b32ab30-f35d-424b-fa46-08df2a2b7e75
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:00.6267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6v0LWThzzcMeGdudd3qV+bTxEQGl2rQYiiBJkN/FoTjA7nbouimoG/Ge8YPpoDx71lNjY4vcdG3oe0JHcGlq2gd4qEUh/GqBLvWXk+w115+JV+nblStRsRsE2F54Qzf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

Use DMA Engine APIs to prepare make dma_device private.
Last patch mark async_tx as deprecated.

Depend on below two patches
https://lore.kernel.org/imx/20261014190337.1718622-1-Frank.Li@oss.nxp.com/T/#u

base on https://git.kernel.org/pub/scm/linux/kernel/git/vkoul/dmaengine.git/
branch: next

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Frank Li (6):
      async_tx: replace direct ->device_prep*() calls with standard DMA engine API
      async_tx: use dmaengine_get_dma_device() instead of chan->device->dev
      async_tx: use dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
      async_tx: convert to dmaengine_is_*_aligned() helpers
      async_tx: replace open-coded cap_mask accesses with dmaengine_has_cap()
      async_tx: Mark as Deprecated in Kconfig

 crypto/async_tx/Kconfig             |  2 +-
 crypto/async_tx/async_memcpy.c      | 14 +++++------
 crypto/async_tx/async_pq.c          | 44 ++++++++++++++++----------------
 crypto/async_tx/async_raid6_recov.c | 14 +++++------
 crypto/async_tx/async_tx.c          | 19 ++++----------
 crypto/async_tx/async_xor.c         | 50 +++++++++++++++++--------------------
 include/linux/async_tx.h            |  8 ++----
 7 files changed, 65 insertions(+), 86 deletions(-)
---
base-commit: 547cb54c6fd39a610130c0beb2d85489bc914ea7
change-id: 20261014-async_tx_dma-4f69bf80176f

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

