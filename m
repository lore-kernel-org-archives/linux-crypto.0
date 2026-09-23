Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011029.outbound.protection.outlook.com [52.101.65.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965854CF5B;
	Wed, 23 Sep 2026 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180420; cv=fail; b=jX6WhZ8i70+SN+OCDtDoCLiWIvQFX8/VBoBHP7RfI3PDTgUMGbDLJoQs+o5srFKLXqCW0YzA0oy/osG+Fmwlt8L+hTDU7zs5ayqkavfJL9PoEuveBM+66OT/jJj56L3X35vcQ5zrQ+12/IeHbBoE3juX71iGl/2GIu5bUvSOxEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180420; c=relaxed/simple;
	bh=ZS5U/4k6NodneT+wW5hlcRXa7c+RqecOtxGstNYglJE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=dts8lZtnar34SQdEUMPPINcI+gmT0kF39Y1liLjNruFI/jZbb1mDDqyENZt9V6GJitzlV9NGqpe9I8C6e17+k01W9ah0PWT7iT4d1JnaJ8CMHH1DOi36ZsJ0RDJ7k6pFsdy7Y55ggndPtChnLCwH+wDL3jTyW0Im8YZWfpDY5CU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=fKRPg7Oy; arc=fail smtp.client-ip=52.101.65.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="fKRPg7Oy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dSAxLCuCeETuS/cr961ta34F8hIP+66bq5Yci+pbaMqs0ht7jkENK2VUl1EZVAD76qcFnV/OOwVMs5rv7ggIicdodAjnOM64HUrAsgjhTNEG6Jwbt/YtZBCHjNVPU5KMzSh5wRaNhHSiv+6YyX3b3QkE/13Mm2Oh4dgrCNHaay9sG3lNf3hEamwStq40pIbEDX9F0yOWBgPfCCCk+UBMyEjTFCdyetxo5H/jgdWqNPU8Mz2mNFR/sf8KdTxYiuZibdaddLtDuKOW81k2lkM6ytoqSzrAnDb48uzDqddOABBfjmU6cOF8vRG6uHxHAax5+arKgwd61u8+rGqHnMMmtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+9xfVgONIsZjfEJTqGA2HL3WCL+KQlLCpYmqvNdR3s=;
 b=kONAUKNN4+A7NYru0p3EC/EffBWUckVqY+qvBYDw5S/jj+XozO5eO3yAad/TMZLtUhLsXCCpsBIa/stLG+IaIphugJ6YTUd69Toalpr7KZqjZHd1YClV+9eRpdZPrMlbqkzzsyA4Pkm+cJv7Y92x6ex5mMLqSlPe1SBTs9i+jszCt8oo+v7fJZb7+d0y1R8wf4IJ4ciBcvl5xRKhzODnHfMQGBYYw4rfilX+tsNFsgMhJOnDVBDGwRnJWrQOwb1KnOZBbFyKTwShtZ2Oaxtq8JTMJDoIbZEHmkaleiKhupLIF3QW3WTop23Fc752r3YAxSJXrwYpsEdjxoIK6rwMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+9xfVgONIsZjfEJTqGA2HL3WCL+KQlLCpYmqvNdR3s=;
 b=fKRPg7Oyq8geCQuImQmSfJBJ1oczmdbl73vZiqihaJ5ERxKz3GfinRU2oF1bcrZWSVx4SmSfuT7Exlu7IyP3Xgvt5tidm1Lanvz9qmWfwNKYcMNqsa1iIMWn41r5oW0Wx1BOF9gRwdRnh/9ALb08KXvtXD4DUetZCtOILG7RTWMkrUdCHZ4NnBV3eK54whw9KUYvBiGuPbKNp14AomWsWnoywbAc0kQWf53N/c6scnpQcEEOQxFqE6I35xV1O4XexwfJugMAChGZxS4L4BI+450kBA5pS9f8mw++toBrH2Z9/WidC7mf8XvfadXJ8Sf/qNj80r2fC40uQGnezpUwlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:15 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:15 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:36 -0400
Subject: [PATCH v2 07/12] dmaengine: add dmaengine_get_max_xor() helper
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-7-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=1223;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=LNNV7Bgrn+0vp2g6IdYTuXEoC8S9OlxLNLCMVkkCNmI=;
 b=iWGtDm0JSPjY7qnT3h+AY50RGFV1unM7mUMHfQgYMBKTjfEWX/iMK21g+5Vn/H6jQloUGI6qS
 e8eSj/ZtoJ3DPXPyLnh9b0R8KXsANZEcBXzKL1y+vkuFq9rHRJlF7ai
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR15CA0229.namprd15.prod.outlook.com
 (2603:10b6:930:88::20) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b96dfd8-f511-44fa-8010-08df198e8d38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IIjHxpKIeiiGktcsz3Q4ioQAhPz6E9jqIVXFGxeTmPnXFer7fF2EMHcXMlOcGeKD4+HLh8I2oxl9kgr9cfi8PJVSMuLMji0YonNX8XGd4B4qmfJUAtZotF8tHYbv/7TOfWb22AVXKH/u9dULx0sS9oFw7YJOhMtYB6m4fFxfK+fP8n9HrMq67oI0zvdcO1XLIJbipadU8Ip+0BOMtt9Dzmpigv7rpHWkaSc7dXfye6h8r5hWMsedIVLBDfvBI0RoIo7eQF6z2o+FLTbOu4a61Ig2dmGF+eHcHEh8zsbVjEJODqDgKM2SJA8CzA22vCdRCYQivDK5uc7UuByRmz3L+T/EzYamyXHpctJZqBQoyG3CIt54EeHlSUOSY5FJR6ftO37s098873lrADH6WC/6YOVMYx+ou2jcdicGGW36h4FuNFgB2gYWCUd94slgauMmZFnA1B5Zrr81vfPuHXDfbJ/AdDrUKDeSBbop4PcXXqc3o+Oa4OZXWg1CooCyr9GuVk9lnSBqYx3odrIJgMzLRaT7Ny9crRJM8FSFxI6pcuLajuynH2obvanL8Kk5aTtu4DliYl8P6CNMCMSIyRYJ7Wq60S/RwmsXxpf9grfTHYTycT7iQPJoxojgS/DhI8gv4DuM1gZ8PGRKCP6qdCM7BBS0P9fG2a2upVU8JoVBTuo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE5CNHE4cDYybGxCQnlTTFk3MGNyVXRXdkZmSzc0a1lpNGx0RzJhRkx6SFBF?=
 =?utf-8?B?SjE3c2JwbXQ3MCt4Vjh2NElEVUtZdE5LZXZMQ2ozVUdqaCtRZHY3VEJsbkpQ?=
 =?utf-8?B?TWNBL1ptK1VVTXh2eU9zZ3h5Y3FNTnZyTHdrMEprQjlpOGI0azFYdzZVSzAw?=
 =?utf-8?B?QzVjTld6bUJCdlRqb1J2cFFKK3VMTTBaeHBrWEUrQlV1YU41KzJtUUpKMWFW?=
 =?utf-8?B?RnJMUSt3aHZBREFJVm84YnhjYUhsMUlicUlGd2x0SE9WVCtuYkE0cityVjgw?=
 =?utf-8?B?SitKUCt1clNxc3IyaUtnanlFVXFmTzNiMGRwY2kxbWRuL2ZtZWdqUitNbkNJ?=
 =?utf-8?B?dVNNb1F0dWlVVFRqbGFQWWdWc0dTRmJtanlxSHNJRFBvTkp3UUEweGpoUnk1?=
 =?utf-8?B?cnZ5aXZqWXhyS1NIdE1BUWtIbTUxMkZ0enpGdWt6Ty9VTy9RcENXMUJKNVM2?=
 =?utf-8?B?UFhQMzVwcFl2M1dWZXVxSkh1bm9sUFkvcHZMR3lmdWZrR3NWSVA3QVhBQlM5?=
 =?utf-8?B?ZFdHTUl1dGxHQUZVQXFhc1R0b3VaL1J3UXpiVW02bThhZHlFZkhlSVpqUjRr?=
 =?utf-8?B?ekVnV1ZhTUpWUjY3Vnc1YkJmbXo0VzdHVmJXUElXd2NwMWVEMm5EOGtWL1ZN?=
 =?utf-8?B?Y1ZLd3dPa1lVOUVmSzZxWWFaS1Z3SDBMaXN2U2NLRXZXRHpONkYxcVAzL3R4?=
 =?utf-8?B?TWpYOUpnRzNvcTNGM01STXZnMDJQVVh3MVo3V0s1eXVoRmJZVmVlRFNTM3Rn?=
 =?utf-8?B?OGhRR0NDT0xoL01zQWxTaE9MSCtnRHhVc2FGcFJZZXU0QWcySmlEQkMzcmdH?=
 =?utf-8?B?QlloVm9ZZlplK0dCNWF5Ni9pc1dJcWlQMmFPazVzdUlXUTNCdXlzcEZjdTQ4?=
 =?utf-8?B?Z1Z0RURVNGpDNGZxMkhEWFo3NHk5d0tCY2Q5TlViQ1FxQ21wLy94MElZMDlI?=
 =?utf-8?B?T1FKbnVaOVRlTnd6OE5KUFBaRVVzb3dIU3dWaUp2b0xPL3c1ZEtHMzdrWFJD?=
 =?utf-8?B?S2EyZnFMNU92b0Y2SUsvK0lYS3Nta21ZYk9iZy92a0JBV00yN2RXU3hjcW9k?=
 =?utf-8?B?dFBsRXlwbWgxSzlIOXBxTjVKVFF4SnowUUJLTzhST3czVmdRV2ozNGJNaVNJ?=
 =?utf-8?B?MjFxakFzVGpNV3hjN0xsajkyT1JkRWV4VEJ0bXROUER1VEl0SXlrYTlhRHFE?=
 =?utf-8?B?dnlmUm1aZGM4R3JXZUFkQjJFeVFBTGtKbTNFUVlmZzI3YW5ielJlZFJLN0dp?=
 =?utf-8?B?SXd3VDJPZWxMakRiblFMVlhDZlMrMEE1a1dPYTRGelUrVE5kMEdBUERXaE5n?=
 =?utf-8?B?djJHdmhNZmlYM0VVbVlRbW9LWnRmekRhc3lIWDlrN0hxUHRqK1VTT3JuOWor?=
 =?utf-8?B?Wnp6QzRZYjJQcnBHTDZDUUxMQWdXaVRqazFSYlFkOFNRSlJhdWdJZDRBQlNr?=
 =?utf-8?B?WHFoRmg2OFRHY2ZXQkd6bytObC8zb1dEZnloUHhDZWIzdllhY2t3K1dEak5a?=
 =?utf-8?B?K0xHUk5aQXJHVTZCais5RWdhNHNkdDdvTVE3MFhiRjc1ZlBSc3VXNm1kb0VI?=
 =?utf-8?B?c1RUUzFzTzUvWEJ5NllXTUxIQ3VRMmtJdFZLdUNQVTc2Q2dqcEcrMDNIeVVW?=
 =?utf-8?B?WnlmbmFFVGlvVGxtNm96Nis1Qk9WTUM3WHEzNHA5akhzeVZHZXAzWUhFb1FF?=
 =?utf-8?B?WjhsRjVMUURtSnkwWXpFRUtwWW9acmMwbjFzaFdDUFBNN3JJVU5DbkRRQ2Ix?=
 =?utf-8?B?bHExc2hYWjVaZXc0bTArTzVVNnBHUXk2V0hQRDcxSC8xSVdsb29zeis2TGFh?=
 =?utf-8?B?MGhWUENPNjhvbUNYVWtPbVA0V1V2a3pFeEp5bnNjTjROU3UweTdGaHI5S0xl?=
 =?utf-8?B?VkdmaFg4a0tnTEQxNzFudXBlcXhHOWlRNFlnWldCZTJSQWl0OEVmRXZESGk4?=
 =?utf-8?B?d3BGN0VLR3lnemM4WTJoWWxVYU4zMkZuK1Vud2ZocmFIN2ppVEFLU1J0d0V5?=
 =?utf-8?B?M2R1aXN6TGdxRCs0R1Q3K2Y2UFJkRVRzUnhrcktqTHJVOEgydEhTK2NiZVFv?=
 =?utf-8?B?ck9EMFg5VG1adFIzTlJZN29oU1E3dW8yeWJ3Z3RwdXZNLy9RWklvVnZsQTJw?=
 =?utf-8?B?WjJTeHJmblhNU21IMHByNXU1dEx2dmdJV0J2Y0JKK01teHZXVUZFcmpjUE9Q?=
 =?utf-8?B?YzNXZy85LzFFemxqVkpmS0tBWnZkRVd2Y21ST0pGVkZHSnJJRC9HdlQwSFY2?=
 =?utf-8?B?eS8ybytZMW9kR3Y4WnV5c0RuZWxXemlUbjRpVkpubE9ud096UUQvUkdhR0Jr?=
 =?utf-8?B?eW8xSFZQSmlRTnBMSzY0MmczSnlma2NKenZLUUgrVUlJSTIvVlgxRHo3Znd6?=
 =?utf-8?Q?mEa5L/XktTrgiOgYZtN59RAmJ+4B8b/ECXu86?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b96dfd8-f511-44fa-8010-08df198e8d38
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:15.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWo1QjS8mrWVL/vG2WDzY1KWFwNTtKFPIls4GK5Gu/bLEBxjbSNqwaDHsJBNi7DAvi8nRWNCcePNWtj9dZMzGf9n1mY1JD7AAvIARDpBGyp+aYil9JmDjBMZNSxa0lDm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Add a new inline helper dmaengine_get_max_xor() that returns the maximum
number of XOR source buffers supported by the DMA channel's device.
Returns 0 if the channel is NULL or does not support XOR operations.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 7fce44bd7c049..a4c9eef369cb4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1232,6 +1232,21 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+/**
+ * dmaengine_get_max_xor - get the maximum number of XOR sources for a channel
+ * @chan: DMA channel
+ *
+ * Returns the maximum number of source buffers supported by the XOR engine
+ * behind @chan, or 0 if the channel does not support XOR operations.
+ */
+static inline unsigned int dmaengine_get_max_xor(struct dma_chan *chan)
+{
+	if (!chan || !chan->device)
+		return 0;
+
+	return chan->device->max_xor;
+}
+
 /**
  * dmaengine_prep_dma_xor - prepare a DMA XOR operation
  * @chan: the channel to use for this operation

-- 
2.43.0

