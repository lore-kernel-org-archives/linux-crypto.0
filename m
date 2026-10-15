Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011010.outbound.protection.outlook.com [52.101.70.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BC04C10FB;
	Thu, 15 Oct 2026 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062371; cv=fail; b=anKUAOYOuc6Juh8BTZei5crBcaAmaI0QTsNlBUndIN0d15dJ9qQ2y3Fmua5kh7GNwQ0nhhTow8iXywTBFVBUYT+G+C12yhFDzmpt+Vtelofqrpqs7AWmrolPKcSKv7pfYN9eN7zOZ1t7jXRx3lRt9gmrJ5bGJiDZUBthw9V37Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062371; c=relaxed/simple;
	bh=qG3+CAyLmZiYrdR86pIjXl6Kinfp9j2xAhmBvuCyiVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kb/DVUcnz2A67u75gvohR7Q2EFvCvZqHAaAvw1dO/2Njz7Wp6U2h/KMtl8T7Mizd7prZm5TWwSuVZ9Z7y3nXSC3z9g0Vw6OKEnyydLUW2Nqp9B3sXDk+9hkav8LtyRJgcqMPITwBTkz6nQsbTLQU22ho7eRLJfid+PZzSvwQqDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=jnc8lR73; arc=fail smtp.client-ip=52.101.70.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="jnc8lR73"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRC6gMjSILJzg4RUZNZvUNo4r8QywRbVEDTyMTcq0xvJBz1lxta2b2BlTi+yl1WlOTdaBmUEeCp8M2O84W8ygeFMPoePCfWwIjjBXksoP4GhwZva0CN5eo5vmobCj2UzuIlJxDuKTlygt/OcjIIJ936Mdq8jE5MMMjywV/guJ8aA067UjUTXHm3xk74pYjvz7VkTG1ZJH9k9McWm/eYjv+fvoXVTbq/VJyrgSedgBrKXJS3wg6x18GY+S3VzkCdfZjLHRZvcrw/SAIaljd/k2i1HDGzz8ogdakSHgZT3nDVNr29Hm2AAFajCqyRxFs2Xl8cjgqpzocTZ5G7vBqHinA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuP/thwflJONLlC0UsyeHIKp6BCblQ8YCo635EzkQdQ=;
 b=a+kwSG3i1HYBByXEV2lN8xb0hw/qsSYMOD+ETjRT6LcuU0gL46JM3TNw2ZU7CY1/mmZDkg1Y0+UmONEPZOWZTXMQ6RC5Bc21NaI7Fu/XuKamP4US79evKvJcFn+WZdtSy2gzq9spRgfTPCRaSEXkPFUB+fNW+rltInx9E6H/Og1J6k7eQOQpYH6FpYmO/KxQpHQW/KlboiWFgGlPuozkmQSP0q7JBmPdtz2vAUwity4IySUXIfLAojvJiNE8Q2F7lBpGIBm6FtYUznk2/JK7lJK2gPXr6ETROzJO1pllRPM1IoolDMCpRhtC9lnFwriWhCEJEUAnp29MGLJbgZ1grg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuP/thwflJONLlC0UsyeHIKp6BCblQ8YCo635EzkQdQ=;
 b=jnc8lR737LljPI2Nd5aFlZjmEJ2EKR7/ioB9Tjj/bEMmh6JXtNAJc4DHL4xlnChjYe9w5cVkPFyn5+cbrGX0ZK7T10ol4D1wcn5hUcQTWWhTMhBBnbJtjD1ukuDOorWkVg+H+WQb0DrGHYHxI5M40TxI9UggaUjFDtLErhN4PVdP28g5ymK8iwxp92SccvpQClOElbLNv7W91F8rii97r4RW7JTpkbj41U0FMFfbv4XcrIf+yFf7W64SoLo/BC8uia1+IFLJpkfN8ELJJ+YgtXrnXgpYZtoDMulJIc3VfRMjCOJKBkiaX3Q1MMm4g06r5BIMOV784yswEv3iwaDtWQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DB9PR04MB9818.eurprd04.prod.outlook.com (2603:10a6:10:4ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 11:06:05 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 11:06:05 +0000
Date: Thu, 15 Oct 2026 19:10:42 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 2/6] async_tx: use dmaengine_get_dma_device() instead of
 chan->device->dev
Message-ID: <atC0si+P094XwMXo@shlinux89>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-2-35790d01e190@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-2-35790d01e190@nxp.com>
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DB9PR04MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 01ab684a-add6-430b-1d85-08df2aac4e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|19092799006|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z/QDLQPcgIXIAY/nYqvWgh9gyqZk95aNDOhCF/gdfFxzfn8uj0zz9gyaN6+G1b+qJS9+aSuaaBqTe9Q981c9hY6OoyIPXS2aR7k/9aVVhcKE7AUvoL1VPYzb+kuXBTXhnwQj4Zqa53sUd82Jc5aNKWwq88cSbI0i1gYyP9SJzmOxakju1oThTa1BKg/RVWVz3o/E5WA3t2i8MAvRE57niJdpfCB30O/NoJfMaq7YAhRqrahVK+jvFk0dsppwxj/PAPsOkjn9MVCR7fIUyruS3YDsOaGOrXGcrFR+oq33emNI4wBtERS5Mury2DFW/iUx9H2zDMCu87DX7dW3t6uV/+j/+o/G7sZUmU9imRybzwESKcN5W5aE+/7BhZHhjSX68hY49StjwFi2F9POes7156P4aogd7s9D7XI9j5TJCBfKpver0P2dzc0Vohxtr9oXyQIO6yVJgKuD1hsDK8y37CuTvqXPS7u67KbW4KPWsQ9IoS1lhI1Xe0qr6t4bjHYRvQN5dwtfgi++qKQPblyX8YHBYx5B2sJESq8cS5GqCWZYa2riexD2xda3GKI2+m3873knlgNJjGydcaA1QnEPgXvxe83sBPqkSzgs95mOJoUoY/OTikogZbCaQcTZzprcauKsMBaZG3UTyiNMxdP/kiAMnbpPx7H97oi3DzRfGsI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(19092799006)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?96DwAb6wT8hwg7FbnKGH3pbB6o9vYpvA24ZfrjTEXbFnvZQItMS+iPC55vow?=
 =?us-ascii?Q?sO8AGKJIVCm5HOrWypwAGBCXRQWZhpy3srN30FiPTz1JiGIluZEqWncMXvJl?=
 =?us-ascii?Q?04To4xa6oMAhXsBCfSyhLIl8NNgln50x3sOyGD/F0WwuY2NZg73SCfrTMT7G?=
 =?us-ascii?Q?xkoMWdJCgvfQnTxRjkdNpKyVfklc+Zza0A0la8t4qzGbJObucdAne01phgYh?=
 =?us-ascii?Q?v8Q2BhXNWESIqc2PuhFXkXraYU6MpM5RTtMg2Dmz8uUGPqWeSBG9RBFuxsVr?=
 =?us-ascii?Q?nVM3W3cT3NaE/os02OkMt9igR2pza2ihHFPuZ9p166lfZA5z/JcTBsRuq0cB?=
 =?us-ascii?Q?sdT6msgQQFaKp7D+PMYj7VoOLAFWwGfRM2wbekiSFNcVJmdzsg/9ZKG0fcb/?=
 =?us-ascii?Q?0jbG54SBjQznKRuhOSG4yBV9RjPsOyUhj2qjtkHYShmyqJ9iq1/SAeZovYFD?=
 =?us-ascii?Q?iHiJ8NOEkVWUfV91rGTbNbKqYuOMm1S+fJTl9nQjP5dcVPfnltyZypD2zIWV?=
 =?us-ascii?Q?YPq4IZxpwZlDXby/JKLQPT/ZX0Y1ThgDXnUqie6WDdI7qTWoSXjmp/kuoJGF?=
 =?us-ascii?Q?wISX7Lc08hVVtPswSYCW7vprqVt6DpBwFARAymr5DpBD9yChaGShwDEt7nOl?=
 =?us-ascii?Q?pYqsDGg1i7hHFtId6EvhSQC8vHKx8j+R1GC1c5fFRyCsRNwlktbYa/AI+yVo?=
 =?us-ascii?Q?ckdPpeopPPtq2LW1fWfZ0mWsBHTU7pX0COAf+wnjgajDlok2wNvW8SjmXdBf?=
 =?us-ascii?Q?ruFjV1h18TekAU341pyI6b6JoVNfYsfw+u+wUbAXrlMdiGJHPYxwuq/+6xZc?=
 =?us-ascii?Q?d1U8godqjUBLJTwzjmk//LG4qJKQ/ftmfmLN+yW5p4i4+lcV575Td9p3fWia?=
 =?us-ascii?Q?f6kJmx0seyuEtnECrTtnNtTs8i+g0w74ug0mwkZ7Fglh0cg3ggrx6i50BewT?=
 =?us-ascii?Q?jsx3gaN14rW/6WYCd1SQalhk/Xew7oqzdZF8zImc2YsIahmWIOv4n6BmyFwD?=
 =?us-ascii?Q?gAnkaIZgovZlRo3n1M1GjrSwPjKTBuxLwujC0ZGUhzfrkTY54KaobCIQh1UU?=
 =?us-ascii?Q?fixErJKcQNln7R7TUhNZN7pZNBmuga5UIEbeWFI7BJ5xVPVcF5nLRJH35+fG?=
 =?us-ascii?Q?S65uE87a+1baCGD27YrlI2ij7RRDSLj0EFYhKacbnO7arEpYbiHM9BVrAwFR?=
 =?us-ascii?Q?DMx0q6CfgMyVOV+1GnZbjCGxOGwAm9CP79NZXOPqxDvpUJJxAmhFrOt4+Z5t?=
 =?us-ascii?Q?hYp8jn0G1PnCOOF0iDCbV7tG/EAvRVOfL/cEca+c9dy6MQe6Ud5e9fdpe5ko?=
 =?us-ascii?Q?i3ZSKDaaaLSBXSmK3VjDJoV9dSgOluxVz2aanltLG2p+B2QOTEHIMOxZ9KVi?=
 =?us-ascii?Q?Jk43a+BhHj6TL2JrIeal6sW3+FAo0L4jf+JuZi/gWkiXVujVl73ZMMBW/zMW?=
 =?us-ascii?Q?MjpG7QrlNm4Vfq5ZYqFvI8Db8ceOLw0JNlU4T9SFA7USIr6ZlRDEp3rZExqz?=
 =?us-ascii?Q?LPw9JsBYtlPDMJltsSCyrf3QcVeKQT/2h1ssG9yzouCqg8KXDxdGzBr22xbe?=
 =?us-ascii?Q?C/Lx/f1CZUEMhqqg8vcO7Ooan22/81W8mFs+BjCzXxNakkqba0WgsDCcJoGO?=
 =?us-ascii?Q?qHharYb7DIbW4MR3HPPuBjSKjCGVJlpH2pVIe/6QG3cnBdIiaLVE1vXFL994?=
 =?us-ascii?Q?xa5vMoDukhrL1enE69iXFat6oNkT04LgtGemhK7GRLmMZW8CWQBhj+g6IJ2b?=
 =?us-ascii?Q?GQBtScTQJd8a0a4AbYeRnj8YZxR+TyacYNmdwPWbahyA2MtHGaWx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ab684a-add6-430b-1d85-08df2aac4e93
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:06:05.2958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAu7DJDEU+yyGxSVHvuS9CmgTN2G7VHU7RQPxoCOOqzOTo08o0Bkj5yleqji6N2SqVWj5/qKgScmau/kMo7gCExUfM0bjB9MEXmGWaUPJZnumS1i6s0Kh1zFwBDkJPvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9818

On Wed, Oct 14, 2026 at 03:43:46PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>Replace direct dma_chan::device::dev access with the proper
>dmaengine_get_dma_device() for consumer API.
>
>chan->device->dev is not always the device used for DMA mapping. Some DMA
>engines support per-channel IOMMU mappings, so different channels may use
>different DMA devices.  dmaengine_get_dma_device() returns the correct
>device for each channel.
>
>Prepare for making the DMA engine provider data structures private. DMA
>consumers should not access DMA engine internals directly.
>
>Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
