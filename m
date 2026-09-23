Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013001.outbound.protection.outlook.com [52.101.83.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E22542EC8;
	Wed, 23 Sep 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180397; cv=fail; b=R3mwmCOrEkQST4tZ5IOI1+TabjDraAHc9LI4FF/WjVFPdhnCwIDv3LZYgoPosgBCofKoGYPSHa0I0IV7Gv0ApiLQNLpkCVe1+gCczTFQ6QojDPCowUOugAYkflTXaODSd8oBCvkulAPpObtq3bT5CGNd+Sy/CS44YZGzfupUXnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180397; c=relaxed/simple;
	bh=P6c1RUpXT4+RoUCl1VJ1lnGbFJop9LZTyBWi3pfu5t0=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=UZtcU+cH1hBKKCd6UepqJuxdRWhFpxc4ambYhTOj3gb7t2QDNvDwVMD4z5jmiz7bG/Jv+/bYy1eueCmRN8kKfIPD3iLzDfbcaEacESYbODr+Qc0QZbhwb3mQCyRgOPfUPjYtSg5C2hDy3TLdT+9QjJml0dQfMuMQOmVG3d6SkfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=XmmqrCo8; arc=fail smtp.client-ip=52.101.83.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="XmmqrCo8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UbbUkHuD8zicDpqTUdkmIDbQJlJwxTWCxTqJSmtzCJHj9U/fqXtwFYW6bJT6/8nEw0j4VhyDSZ6b09TZsHKoHGmIpgVqOVsu9QuT4mIacx1jNo7K4iwu5XdvhKIc6RBrAAFXfNeftLP/ihmEK6nDfgsme9McfrnOQdMLIBIT1tPr4ZLxu7YUxLcOr6o2FhGPbwp7XAHX8jaXKMXa638Rxxd6YPecWh3Snp/4D10BDhCUw+MZ5tweacx55VfhSZySXcCB71/VdoEvti9YnaEgmWAI0QKSje68bt/4eHJ+vIHVSYGjHJGbmX+Mt4UHDDW7PkOkJsstJ4yII44EB4xktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8B1wOvohocoreNSrxw5SbrOsU8puxLVizxVdqHrxe4=;
 b=RkuX6c8Q3ehb3CAsBVjoYJ5MUCoA7cI0MEeFlhK1H+tB3QDj4ynQ0mmHXHDwHZgnI4qVrS7VNBEhyQO7HXF2YPDYBYPwDnWQekSd6JcIRkoaWFb61dCJexOPMqva7hArRbQdeizzNv+lZAEFyDwOw4fC7B8L/18ITTm6Vgo64rWGohdyZ0vP68ZY2tYU466Xaz291V68DYdTJ6U8RjFQhBaLXVN1q8KTUckxIolyImQAbhTHGVjCOoaSMq2vil2WBugqFwusUq30XZMOyvuow0wJEuByUmiwWD6EucK820SkCISxgD5ywbnmBsjqn5uojt43o+l/ysA6ZLq+Qb69dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8B1wOvohocoreNSrxw5SbrOsU8puxLVizxVdqHrxe4=;
 b=XmmqrCo85JnSsuzXJ4TjHhyp8+YPd/F7fvzOY2kPmSBRCIdb9sB2Toar96rNWLuuDMyappjZxj+g75vOwqDpjuAlewcU1z4/BvkQFQwD1nb003+gaoy5CuoYuf8+vhy73cuCsC8Uvl/IBwly7evu3fTiIUlalA3Ah3FLir95/U+9eltJQ6fMv//IGtGdsL+ezQDOBH5z8yUHFzCU9wTIB/Jw35mdUwnfh0/H/L4Gg/oDYzwZMyCAjt4+f64gIbW5Ji0m1tOR5RSUjW6lTMlvnGsNGViuUgAazR+6/0ySuVRW2N5bj2cgFHMM1ha7WABDft9vx6ZzoV3YpcogZsqzog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB961718.eurprd04.prod.outlook.com (2603:10a6:290:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 16:19:51 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:19:51 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:31 -0400
Subject: [PATCH v2 02/12] async_tx: use dmaengine_get_dma_device() instead
 of chan->device->dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-2-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180375; l=6656;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=eyHFKVxdxpq/RkaKnR8lc3wr9tdpIQnJTylaOSZ/O9U=;
 b=BNNf8HwFXSt5iqS9sZCj0HKOPAtihbgqcrCrpSuqXQTEmfjyJh/kPJTtNYMMSgpVG26YXvuvu
 0wg160sHnxFDJmofrNvEtdeY2a19EiO6S+v4kyZo2G0xJHY+Olfm+2B
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CYXP220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:ee::11) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB961718:EE_
X-MS-Office365-Filtering-Correlation-Id: 17410700-fa13-4ecc-3b88-08df198e7eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|19092799006|1800799024|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BnlxlZHAO0PS/W7FqxG4lZK7o1BF3CeyobEfwJbynvVWaeeU1ybB+4SdKcGEpZOJShVlh+vnoD/0xpByhKtxZgUpwdd7NvVDhv/IXZxE3QGsIjOImKsR7uw22pckdz1kcHpwRGnaxEC4RRzj3uisTyVPNN2II1SaLVQSpgGx9Wj2Y1ku5quNINUBV4CuN5vdxhgBmfyI7yT44RrAki7LbdX8c4odKnjEkzlR7Varq6nexshK2lKW6lYdIl2R59szV2nzR/BfaAk//cnhp2d7pkiwIe1tfz8vtpv0WotmMOji4wuE6GS14+ZQEIHDahzmTeHNd9kRzGYewTUloPQvbOS0eeOtYsaaBOdM6jc0vBkKOnVGwicmcI/RPEtnL6w3A6ixGPCzHKmYNCZADwvrO5CVu3gZkBCx1ddPeN0MtXXbDvhyC1Tw/RSLa/U+Qo0d3Lp3BgR1sg7EZ0qBQBwIdoScaPAM0iCuULXWlNDT5Vih8sX4hLeS7+wt0ebd588Np3K64DrH+leMqN+/zzOSfHlSXObKvqznBfgOztQpjz+0A8ZTefH63FJkRPq7zAzmHwVyg/3NmYHBF4tM1eP0zikyUoCACTYrv5xiwb0lTarGHU4S5poRHO8aZeGUyPEZPFDIX3EYtqEkGuF25+PZvhJK7YkqGOCvL7Jd8rgNOh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(19092799006)(1800799024)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0JTYmhrMjVIS0N6Um1pdUhSZnJQZjVRNnZWOXlTdFN0aEFJOTNnL0s3OHM5?=
 =?utf-8?B?R05CVTFqTHRCYW96cFNwdXB6Rk5vbVN1QUxQSW5kUmFla3JjQzNUYUJtNkRS?=
 =?utf-8?B?Rm1CcUl4eUl0OSs2bWw3dUJzTkZiajlNNlBjY3dydDVRemtRNUliUjN6Qi9n?=
 =?utf-8?B?bEJ4djFxeDBkT2R0MFBRTnNjYmdacVNObDlwS0p0UG02VFhWcVJlM0xQVUZa?=
 =?utf-8?B?cDloQVhRUFg2cjBKZk05VURlcTcyVVpqVGJ6anNkaVd1UisyQmpwR0V0TlJz?=
 =?utf-8?B?ZElwNU1aY05wbHJMUGx3VE9kMHZLMkl4SnBKNnJzRnlHY2JiRzg4aFdPbnA5?=
 =?utf-8?B?RVlYdGZ6R1cvNmtZU2ZHTnF4TG5TN2tCY21XYjQ2NXpod1diWEp1cUlYbDl0?=
 =?utf-8?B?dHlZU2xqYWhLWjJQTXA4dGNTem5NUmhXeXQrV2poVm5qN0xxVXJ4M0ZBSnpn?=
 =?utf-8?B?SWlaekx3YUtva2Y2WDZlclBZT01XbjJudlhoNHJUTVlPZzR1V3M5NmlMZlQ5?=
 =?utf-8?B?NGJET0ZteXl6dmFXU1l0Q0pZVnlSeG9xUlgydjV5d2wvaUNjbGJMTmRDdXNZ?=
 =?utf-8?B?cFZVbXR0M1NkeUo3SVB0K1VBcnpkY05kQnJVbm9Cb1BpUytPRXRjOWhoOHdT?=
 =?utf-8?B?OFB2NURta2ZSU3RDK3pjd0xTZkJxTExyYStQU3h1eUhZd2Z1eW1LaktGV0pj?=
 =?utf-8?B?eldUR0FNMHQ0NWV4SHpua3cxYWowbUMyWHVuZlFQb0F2bldVMzRiR2FUVURi?=
 =?utf-8?B?aEVqWURVcVVWNTNWeWVsL3FWNm1lUGpydXJUdVBMTm9KNW9SZGxOWWIvc1lS?=
 =?utf-8?B?ZVBlUzRPd0NRbi9aK093N2JicXRkSERvSFltSTlWay9KTlc0Q2pHWHg3WlNL?=
 =?utf-8?B?YjczbkcwSWxmQlloMnRnUmNkSzJWVzkxZDZpa0lMQ3pmTTJ0UWo2eURUbkpC?=
 =?utf-8?B?b3d4a250aTJFZTgrWlBKRFVqN3RkdXRlUXJyV3dxZm5NcDN4T1FWQ1dTTFRT?=
 =?utf-8?B?TGN3ZndIMytWUkRpK0lLeFZTbWU3dnFRck1LcmdIYlBIQjB3c1FQNWFIZkpq?=
 =?utf-8?B?aVA4enJxTDFQMGlabkVkT1V1aENyVG9iMVd1SnBHU0FQYlRTVmxZbHZFZS96?=
 =?utf-8?B?K2NZYURQSDBCSVlzbm1vWnVFN0dkNU9iT0N0L0NUcGczYjY4OTV4c2trdm9i?=
 =?utf-8?B?Nk03R2xXTU5LVnlwcllaQ21LUmZMZGxmM003TE9aQ3pmeU45dytwRW9STVpu?=
 =?utf-8?B?ZjlBcEJQV0tNTFJPVEpsNlJkbHFBdmdlZHU1Y3BjY2lGbkRLRmVYUGRHa0pJ?=
 =?utf-8?B?OUVnanZ2ZGNIc2ROVUZkNXlac3IyU0tkS0VQalcrbUJOZ29Ba3NaWU0zTXpT?=
 =?utf-8?B?aHhHQ3RjN29HZm4xQUJZQmcxci9jcVJkRzdtKzlyalpyOE9KajNCZlZQWTRI?=
 =?utf-8?B?K1lPcWxHVmFlQ0cyNnVPTlpCenlrNmlJVk1DczhTWkNnM0h2QTFyZ0xGQUhY?=
 =?utf-8?B?OVhYM1ZoUzZLdkVuOXlXMUxXaEJ4UlBueDhuMlJNMWViV1RiSXNtTm9IdTRq?=
 =?utf-8?B?QS9rMG9aOFJGeElsUzJtUGZjWDMzNnRCL0l5bzNFM3lCRlVUeGxnajZGL3BC?=
 =?utf-8?B?NEd0NU5xTnpsMkorblRDOTYzSEhZNlRsYkViendUWWRVUlI5b1Z0cnkxdFBD?=
 =?utf-8?B?WFJ1d2xaWGd0TmMrUUkvMU5ieUpteDRYSFVpRnFXb0Y3cW81RzJrampoSkpv?=
 =?utf-8?B?bmJjbDhjYzFmMEYvdDRyVEpDOEdRYXVyVEh2R1BTdENCZjZYL05NOVMwZDdk?=
 =?utf-8?B?YVhqWFVCLzcyWUJrcXhPWnFlQkhsT0VDQVByYmNDa0cvUXc3aG1qU1R4UnFN?=
 =?utf-8?B?dE5uNmNyVVVlZnRrTHY4dm5SeFluckQyUm8vek8rV0s2SkJLRC9oR1lQTUoy?=
 =?utf-8?B?RzNDdzZTS2lLTURneU9BV3QvRmV5OGVSWEVkVW55SElpcUhZZzJGQjZmUEZQ?=
 =?utf-8?B?NVdpaWJybXd0SkhjQkg5MUlhOW9XcitVWEErOHgrTlNnNXhpNDFEbTZaRVhp?=
 =?utf-8?B?anBHeDRKK0VZTTJjOGVRZEhpM3Y5L01jTFkydFpwQWtLNC9sdktVWEw2cmdP?=
 =?utf-8?B?cFN0SDBMalFvRHJQQVB5bHZMVEpDY2FaT1l1MFFQY1pwRXBDNmVhbzJKNFF2?=
 =?utf-8?B?UHZLd0pnTkV1d2JxeGo3Wm93TFFjOUlXc3MvczREazdOZWdkek01N0wvSUM3?=
 =?utf-8?B?dTdDNjFVL0NveG9KQWFqa0R3bk9XWWhXSnAzbVcxYUVpaTdrVkdWK0VraXpO?=
 =?utf-8?B?MVFSU0J2MG1QSnM5dFJxSE9aY0IzOHJDVUtNb2xrM0tDRklnWmlzOUN5UERp?=
 =?utf-8?Q?xrBimZMekozFWQMqdqwgS56xycyDVrF3YiI9j?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17410700-fa13-4ecc-3b88-08df198e7eb4
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:19:51.3605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwsauGwnGkpi7x5yl2rxv3a9Ghsrz6/2DzhCZXpKTMXQeANZsCXxqwi9uOOlb1nxdaqNiUk6MF7zfZ12FeeE3lnu3LDFDCBC+N4TF2+/EEJIP85hhlbsMATxtAAtdE9w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB961718

From: Frank Li <Frank.Li@nxp.com>

Replace direct dma_chan::device::dev access with the proper
dmaengine_get_dma_device() for consumer API.

chan->device->dev is not always the device used for DMA mapping. Some DMA
engines support per-channel IOMMU mappings, so different channels may use
different DMA devices.  dmaengine_get_dma_device() returns the correct
device for each channel.

Prepare for making the DMA engine provider data structures private. DMA
consumers should not access DMA engine internals directly.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c      | 5 +++--
 crypto/async_tx/async_pq.c          | 9 +++++----
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 crypto/async_tx/async_xor.c         | 8 +++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 627b6ad9313e0..53277271f063a 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -44,6 +44,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
@@ -51,10 +52,10 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		unmap->to_cnt = 1;
-		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
+		unmap->addr[0] = dma_map_page(dma_dev, src, src_offset, len,
 					      DMA_TO_DEVICE);
 		unmap->from_cnt = 1;
-		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
+		unmap->addr[1] = dma_map_page(dma_dev, dest, dest_offset, len,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 27f99349e310b..3a7fd90556501 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -196,6 +196,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
 		unsigned char coefs[MAX_DISKS];
 		int i, j;
@@ -211,7 +212,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		for (i = 0, j = 0; i < src_cnt; i++) {
 			if (blocks[i] == NULL)
 				continue;
-			unmap->addr[j] = dma_map_page(device->dev, blocks[i],
+			unmap->addr[j] = dma_map_page(dma_dev, blocks[i],
 						offsets[i], len, DMA_TO_DEVICE);
 			coefs[j] = raid6_gfexp[i];
 			unmap->to_cnt++;
@@ -224,7 +225,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		 */
 		unmap->bidi_cnt++;
 		if (P(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, P(blocks, disks),
 							P(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -234,7 +235,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 		unmap->bidi_cnt++;
 		if (Q(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, Q(blocks, disks),
 							Q(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -314,7 +315,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 
 	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
-		struct device *dev = device->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index e53870d84bc55..ed5c5eb126990 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -32,7 +32,7 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
 
 	if (unmap) {
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
@@ -101,7 +101,7 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 
 	if (unmap) {
 		dma_addr_t dma_dest[2];
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 84458375b202b..06c48e8cce834 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -183,6 +183,7 @@ async_xor_offs(struct page *dest, unsigned int offset,
 
 	if (unmap && dma_xor_aligned_offsets(device, offset,
 				src_offs, src_cnt, len)) {
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
 
@@ -194,13 +195,13 @@ async_xor_offs(struct page *dest, unsigned int offset,
 			if (!src_list[i])
 				continue;
 			unmap->to_cnt++;
-			unmap->addr[j++] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[j++] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 		}
 
 		/* map it bidirectional as it may be re-used as a source */
-		unmap->addr[j] = dma_map_page(device->dev, dest, offset, len,
+		unmap->addr[j] = dma_map_page(dma_dev, dest, offset, len,
 					      DMA_BIDIRECTIONAL);
 		unmap->bidi_cnt = 1;
 
@@ -316,6 +317,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -326,7 +328,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		for (i = 0; i < src_cnt; i++) {
-			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[i] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 			unmap->to_cnt++;

-- 
2.43.0

