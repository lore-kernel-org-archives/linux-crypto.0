Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011026.outbound.protection.outlook.com [52.101.70.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5D536F419;
	Mon, 21 Sep 2026 23:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032158; cv=fail; b=VCIRo8AaL2TxKX1rCK90IPfcelsQZ3HaZl9b4/6UHpjNAM5nC+ovXd1r3BxxjayPlosqWiug2s/c9WwPdDzJTxv8oBQcsRVcBok+iD6T8NpArJ1EkkaMVcJ5zJ4Ju1bmp3NXNbuMiuLJhGNxxM4IHV0+Y7ego0qj40daBvk/4sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032158; c=relaxed/simple;
	bh=r0sSUJt4OlXfTOyk/JywogtzBblMn1NseZIXfDnAXiI=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=to85wBrNdE04J7iMgKpnqbVTnjdHHf5E6Vw0MVbUDn1GywwoEqlIblssNxBudJTEdy+bLAVXw1Pajz1ImLrZqQy3oR2v//fFkQiwVV6bc+DJCpM/QfEFJnIT9MRnp0Qq0XkZkCn8YNSKZVD4p8h5pztqwspO/6TvT9+6qvujYjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=mDcOFsXF; arc=fail smtp.client-ip=52.101.70.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mDcOFsXF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PK4qDNmTmlKPd2vI6B5K2MEbHw3e/23CIwwgLXLTq4UzGBneqJ8tWDAttT150ksrfG1SXrvQypKzewqDmuB6Tk80TRHdeOrqYVyPoXbx1YSvv7jnKo1TgPqn4U27ynMW6CD+rClF86mSO8J8FJ4Qd7FfDkEoC0JCEn4tjCEFwTKHJgw9XuMBwK9EN+DRD6XzDe8U1tXyAJFbEDEFEbDwr6Nl0FQq4A6SQ2ELonUodQqfaLQ1uwcnKyFkEfQSuasiUO8w0sdSxonV6gocxPJYVdsulfLUi6FpY6Oc/CsY+qUUwVnwbrlY4C8ads9xtB/Ths3373F8Ps4LvBxKeiistQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljHvMh4PWqEoIRuPR6NwxIfGD3sD7WlQnEJzZWrXrgY=;
 b=oaCp5wzMvdnyBLrfcpf5ffpICVF7ZrMVrsUs8ce99XEaAajC1aw6iBxVShsT7Rr2/yWEvIPwYIQ7GIN4kAsbiXjqrc9OmMTu2z1HBlByVgr7Dqu8dVuIf6ezeskGqKefwqevNSnZDROVLx4Ywo1AYrT6pKz3mlf1bMb6k369fQPCNL1riA9IwRSCL46PPYWiy4bCrOK9J1zDoINWKzLN1aHrctccOGKdePylQF1RKTe5OlAsnp3yPdcY8BQJVVsPdkKPABaISZFF5D8znbBPajR5N9gs3HEaHPKYd7oKctCke3C+qJSdK0dEOSexdHgcAr7K74X1zV/PgTfW/YXF3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljHvMh4PWqEoIRuPR6NwxIfGD3sD7WlQnEJzZWrXrgY=;
 b=mDcOFsXFOvkhshXEm+rTB/xUH+4utpQOjaI39VzVAr3IGWDFN+pfz3XNGz8EDJTF/K+G7gSBEpInKAZY+eE7wYysN5FJebJQ9LSeFHwbADoUVk6DDqpkBujMt3kPBr2kR5tusBf2AdvpHuZb7u1fOfc5iay9SmmoO7Of2HbSl4+fPZWrvRl8T9ClL3e4iaHbzfGUZAsF+WEUXQhnj7XGe45al+g3iShOolZ/RkI+xsWxsnYimPY6sJpRosXNi04gvUJC/zfb5m9Ev8yz79NJS6cYnRH+g2kJrbTrcPKQnPFjwAUPpztVSuysDZ2aY8V+TUP1MB5KTBlgLLVy/mv4Bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DBAPR04MB7352.eurprd04.prod.outlook.com (2603:10a6:10:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 23:09:13 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:09:13 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH 0/3] dmaengine: Add dmaengine_prep_dma_pq(_val)() API to
 avoid call DMA Engine callback directly
Date: Mon, 21 Sep 2026 19:09:02 -0400
Message-Id: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA65sWoC/yXMTQqDMBAF4KvIrA2YLBS9ikiI5mlHMI1JWwri3
 Z3a5cf7OSgjMTJ1xUEJH878DAJdFjQ9XFig2IvJVKauWqOV3xzCwgE2JkQrtHFXDUbXaicVeJK
 tZDN/799++Du/xxXT63dG53kBor/rHHkAAAA=
X-Change-ID: 20260921-dmaengine_prep_dma_pq-7eba91a609ed
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, Frank Li <frank.li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790032148; l=939;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=r0sSUJt4OlXfTOyk/JywogtzBblMn1NseZIXfDnAXiI=;
 b=7dkQPQCWsf/ASUHn2KfkLYtHeHTx0u95vZ5ra8cm46dAIgUNJzaxun8+sQE7eYID470q+8/DE
 yO9lRW9WV+ZAt6pvYdLq9jO8vMb/QVVeyGbPtd3ljbHzAR0lW0DaxCU
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CYZPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:930:a3::26) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DBAPR04MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e5461a7-9c36-48f0-c2dd-08df183559e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|11063799006|56012099006|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4aIYmvvI+p8dcEc1iEptJWrpkVYs4Vc117NoJa3Vo+lguhvTSLVcUL4AYxse07G0gWejaMTbBQj6scvJq8nSFfPg/Mz1bURqOQFFs/xOmVD5voqwRnYz/7sMACv9n3qiY7zuSbLtSeizAgNcPktSeKIpAEsn7Gupd2GMAojStVauULVMQo4Vi9lDhsDi3SFcj70d6m/2hzfz4Nr+X45Kr0X/UJsS1BLoK6JC6Z/hohs2Ktx1IXvHIn/oR7MO9o5aSmyV/tQH8/B8+LOSTZ5/m+NRT1uzxaOM8HM9HgTrJB6PRszjFi/nHybjiNmwpw/YJGqR+fe8/pn356UUnFqablknT6BALuxri+YBQHr4IJyiz8WO78nXm72L2APbwqizC+tV553VYOtvTHR583fH7kM0Vyl6w0PDmXfmaeJWOaLV7B8KJOLz2vcwfPPy1yFQU7HeVLyg5XeIY6RUM0tXmIk1M5QdQXDW8X1UK+pirY5QWtLlfBjInCrAQfmTjO2p6UpnP1yO8AEtprMYJksg2EQzsRHn++w9K9Ze9/Y0MnBEtjiAhiJNxcf61fCnJVLS4l5OXfF2ja2cWvvJekqsqW6f+dbhZW3FGkXGOdTf7G+CsR9X6qvpJ2JgGbYGFGdm/oa7xHh85IM3xCyJOOnCKuQkKl46kt2oJzJK4lNSFLE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THpMTWdpRkNtOHRydjJDRlgrL0hrY3FuMVNWMldScE9SYlhWRDZmYXpzSFFu?=
 =?utf-8?B?WDBBODVBbDY4UGRSQTRxVWp6TWU3dXdXUThaVEVrUkVEM2JTSG9rZm5jUjd4?=
 =?utf-8?B?VS9mSy9OSnhaWGhxQjNqZ0xtRG5ZUTd3dkRFeG5ZempJN0MyZWkra3FDUnJO?=
 =?utf-8?B?RUR6b04wRjAwLzR2aG53Z1Z1OUFybzVTbU15VjVkeVJJdWVkdFhqM0tka3dB?=
 =?utf-8?B?VXpiSVhOVXZMejAxVjBRNVJQNlo2NVlZdDNxY1E3Si96SGtFUGQzMUxWTW80?=
 =?utf-8?B?R3cvTk5HbkN2U05nZnQ0a1Q4am5IUnlzOXE4L0F0SmMrVDlrTks3U0s1S0Rr?=
 =?utf-8?B?bElxUDhSSkh2MjhYNjUvb1R3TVpURGUxVFJkSWpjOVViNTEvOEIzU1NTWDhP?=
 =?utf-8?B?dTh6ZUdUaDhkaUVVWjNnUWJmd2cwbGhjbmdScVpzY2NmUFZSRUJaZXdXRXFL?=
 =?utf-8?B?V3FxVDg3V3h3djA3eWxjQ2dJRU0wNFRYRWJCMWxTcDBPSTNzOWZDMHpDeGFS?=
 =?utf-8?B?dzZNdVhXaFdZaFI2bkx6L1QzWXJTOVF2U3VyQ2NoVXhsdlR6WGU5V2ZJOFVW?=
 =?utf-8?B?ZUxpbkhlQWpqQzBGOVBiS3FXM0pUb0F5T25KZlFPcWw0dXRESWxPZHcvWjMw?=
 =?utf-8?B?Q0dOc1JHb3docHUwUTkzNzgzQ2UwM3pKSzY3TmpZNEc5djB4TVE3UUh2QUVZ?=
 =?utf-8?B?WnR1TGI0Z0VJU3A0bmp3dFhGSXNPaXJxZ3l5TFBjYjczeE9rVjAvaVZvUXdR?=
 =?utf-8?B?TDJwUzhEL0lrbE9tQ2RCUUhyMmxhemwwdzk2dUFucnN3SHNFUlMxR0ZwbkNY?=
 =?utf-8?B?TVk4Vm03MTBiTTY0Z3ZKYlBjZHNVeko4dU5yK3BKN2dydXYvRTdhVDZEV2Va?=
 =?utf-8?B?NzRHYXJob0pHZXlZSXQ2dmNPQ0cyNDgxR0ZYQ2lsMnkyV0orZDJmckpWYkpm?=
 =?utf-8?B?S1d4V0U0cS9TN1NzeXBWQy92ZTN1MU40MlVwK1YramlnSEUvb0lzZzdEK21l?=
 =?utf-8?B?Yko1TVA0SnBGb3JaY3FEZUI0Y1V4SnRjei9PSGV3alRhcklrZ01sSnM4Yk9z?=
 =?utf-8?B?QjB3enZEaWwvZjhCK3R5NEJsQ0pjMHRUeTkrNzdZWW1hMGNSakhqZjRJemk0?=
 =?utf-8?B?RjhNSTRtdGJkWVFBR0tjc1Y2WjhHVzhtVks0ayszOWVCSzRDT2pJNmc1ajNY?=
 =?utf-8?B?MVBFN0lDKzRDV0xVK0NhQi94dWExVnY3V2tGZmZCbnlYY2kyQUtMc1VQNWlE?=
 =?utf-8?B?Vi81TkdSK2FMY2t1Wjk0ZVRmL3BGM0VaREphanpBY29LMzVMcGozRDZDN0pv?=
 =?utf-8?B?T3Y1MlQ5UHJOdERzYllMVGVMNUloeE1HRWlCQzRvVzRNMER0cEl1ekl6Mzh4?=
 =?utf-8?B?RlVqQ1NleE5JVXlSTngxZVVoL0lxMCtkd2Vqd1dEOENlWjBkc2xiTXJnYnYy?=
 =?utf-8?B?cHFITXFsVHRmSHVHcUsxWUpWcDU5dk4zWHkwdVJHUEdNOVZBVjB5Vmg4Mm04?=
 =?utf-8?B?bHFMQjZNVEhBNmp6Ymd1OVZGV0R0YThOcVN3WTFDdmoyZ003YlYyTytRZnN3?=
 =?utf-8?B?Rm9uVDVLK1o0U2Y2Wm5VK013VlFkRTlDRHg1YUlvQUQzMXdnTFRFbDY5dFdB?=
 =?utf-8?B?WC94Sk5GNWVxUUNEYmw3SSs2V2F6byt1b2U2YzBPQVhTbnFDaHF5ZGtxQ2x4?=
 =?utf-8?B?cFpqTkdpbTFiemJKajZ2dUNpeWNMN2p2Z2RTcnM5N0RvTEhLNGF5SmpIV1Z6?=
 =?utf-8?B?ZFQ3T0VLSldjamw3U0ZKYjN3ZHMrVjNtMjdxajRsVlNvczVSbzRYZnVIVElS?=
 =?utf-8?B?Q0xWSWRKR2NwN3B0dUlUaU94N05VMFhkQ0p6VUhxZ1lmU0dINGpWUkJMcTk3?=
 =?utf-8?B?cG5VM2NWUW1lSTRDRVRzQmNabk90dE15S2tiUVYzSGltMW02VnpzTE9xeFUr?=
 =?utf-8?B?RzV3ZVVMNE5XRDdpQnFtVVU1NnU4MU1YWXM1MDNFYmMyYWRxV1lCaUhsRE9X?=
 =?utf-8?B?bTF4Vk1HZGp1ckd0dXJFQkFHWDRrQzZvdVlncGduZ0lrT0R0c0syUU5jUGF1?=
 =?utf-8?B?aTB2Wk5md1E0U3ZTNUpWWWVkZ0tNbzJrWWxQaUpIMEZOV0dydUxUMDExc3JL?=
 =?utf-8?B?Z09UYk14aFY1dWlKdGp0WUk0ZjhlaGFnWHVHM2VrM0dMTHdUV1dkOEhmeElj?=
 =?utf-8?B?ZVIxeVczU2VUSkFVUXloOGpQb3phMmpMdC9pVHBMSmpSU3ZFK1B3K21rVVRu?=
 =?utf-8?B?WUdNMk9nNDA4eWZPMU9TbkxIOCs4V1NxZkVyb1Qzd1BDbFVoc1cySXBlRk5Y?=
 =?utf-8?B?ZDZzdUV1cWlMb1FPOU9PMFY1N2FjS2VZVDZGNWhnUE5leEVXNk05QVBqTHdK?=
 =?utf-8?Q?NvInyJldOEx3xCK319YEyzZFKsLRcBBK60NEZ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5461a7-9c36-48f0-c2dd-08df183559e5
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:09:13.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLfdghgXXfgRuZKbcxWqK9+P/20oy+MRsVtCNLCboIVKE9llFXj+h0f5HYQBwiaiTU4HuCXRDbRaQ41EF9Eic5VXPsUW4y6hRgAzhUdGkWJR2t7NHkjpVQ7jAx/xuujn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7352

Add dmaengine_prep_dma_pq(_val)() APIs to avoid call DMA Engine callback
directly. Prepare to make dmaengine provider private.

Use dma_async_issue_pending() replace call callback.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Frank Li (3):
      dmaengine: add dmaengine_prep_dma_pq(_val)() API
      async_tx: use dmaengine_prep_dma_pq(_val)() instead of direct callback
      async_tx: use dma_async_issue_pending() instead of direct callback

 crypto/async_tx/async_pq.c          | 22 +++++++++++-----------
 crypto/async_tx/async_raid6_recov.c |  8 ++++----
 include/linux/async_tx.h            |  8 ++------
 include/linux/dmaengine.h           | 25 +++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 21 deletions(-)
---
base-commit: 5c4d4169604b335c38bbc79bc1fc03042981fc6f
change-id: 20260921-dmaengine_prep_dma_pq-7eba91a609ed

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

