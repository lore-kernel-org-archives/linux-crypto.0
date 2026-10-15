Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012012.outbound.protection.outlook.com [52.101.66.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3574D9F91;
	Thu, 15 Oct 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062464; cv=fail; b=D305Y9dOZHjfR+2+NV5XOEcHJpNqYJDoXmqk44xRpT1qvOn4ozXHmY3yHrkwwSbq1KZkgHnIttCpIhV1v4TiMtFN+caezAKT6lHDsYNJCWXdTfFOVjLF2502iGwBYfMlSDYFXaJBm7CcKhHBQ7JLVmmHLPWhfU10HLoflVZwplI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062464; c=relaxed/simple;
	bh=2qVr1ZY2TZGtWoBJg4OIdr69q3OnnyB4jxZbxBYQMP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SeM+rHWdNNJlqn4jEDv1TYYtunS7hf+xucZAMtzAThkP1GlrB99rxHEpaOtq1qv4JqieRBZyhnU+cegK9vcrQVST+WzS7CHZuxiL46dYhJ++XZWY3FeOH6H0u4586csFrtu/jtAJ3ElohY3HExEKN5BA0rPbq+c71HTRzqyE63Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=fEFThcvt; arc=fail smtp.client-ip=52.101.66.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="fEFThcvt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTUZ/v7eO3S3n31DCtYyrU2f7/qT+JdJNEknz4+JomTy+JY68hIu0W2Wb754jmZYaeEuw5UaIcanM+OcgomeV79t3CJk011N8VoTPO4uXgp/ug+3j6TL/CxHCls8Whqj3NVQIhOx1YnQFfrb+tOJnOs+DD47kSu7qcZ3Gos86oZ5nCuec7m17UftPsCz0iNCAGXIsBq8+5pw1bkOEvJlZPBueSlMwDR+10uyZYZ32wtJg8SXw9MmAW7ixAaTlm1aiFfMNsb0CaI6GKnl2pky5JoPukKN21lXB6mLTnzWpbqdvaLWoUzjOcQBr2YtqEvMCDSQ854hl5HFWqCtWEtQWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qVr1ZY2TZGtWoBJg4OIdr69q3OnnyB4jxZbxBYQMP4=;
 b=h3TYxEgDSF197G4K/pWjjKfPyI6TuHR1xksJ/V08i5zCQT9yG94CCyvTKoyseI6zwyLdV5ulzHyf5Nv9IP7mPUr4IZv07NeXCQIAAifksd5cnokGHx60VYz+EZIFeMF/UZYuKkWK8epoX7beSNQY4+pnHVXDExWNp8GUnVKv5EEhJs/6xAnZ5a+UQWS0ZdTcesPqVAGD0Y/uUVDakCyi4jKZdu3S78ldNyy8uP6BMZmtuSwxw2jjUIuvncd42S3TtwaHNvwGwda3n5l1O6a/Kt7t1T5wkSOxcRbCXNu1CFxf8ttL14cpKS02iHRhR2Q32wg72DGtnqnlXiCl/JVG2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qVr1ZY2TZGtWoBJg4OIdr69q3OnnyB4jxZbxBYQMP4=;
 b=fEFThcvtQOn3xuJaFALiTyshjy4v8cTbE4r1xrcxUH+QVTlJsh8bkYEqM0mhHdXsSAxOMk+RyCCpJ636belIDPdxoC/k/3avGwz1h+h7x7oyqxlmtXS0Wdqeb/aW6jGoPKTn1ld3pR3Uis3Uz0DZDpEhE4KtMQTZTKIxS5TzX3iUUBVHc8yWGowR9CdNwn0ER/6Xav02hAe3tGOMdkrNtTBBM7bTFt5xpJa9368DvrmZCM8MONY/NS6sSlAdPRr9EBqSCbF4tPJFrhQ2230t1/tkeOAbqCGXu5sdgpQqZVFyZrebAbLjt1ILVSVeZJx5EGwGxS8fUwgdJD9KmJFWXg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DB9PR04MB9818.eurprd04.prod.outlook.com (2603:10a6:10:4ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 11:07:34 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 11:07:34 +0000
Date: Thu, 15 Oct 2026 19:12:10 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 5/6] async_tx: replace open-coded cap_mask accesses with
 dmaengine_has_cap()
Message-ID: <atC1CqJiwhIqKd89@shlinux89>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-5-35790d01e190@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-5-35790d01e190@nxp.com>
X-ClientProxiedBy: MA5P287CA0234.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b1::8) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DB9PR04MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 426defe0-aa23-4df0-0103-08df2aac83d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|19092799006|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NPSAig6+ftCRv8Y96/lNy32/28Opj4GNOnhWDbqgl7JpaVIVyeeyyRQPZPSvH5N8ONyWUHKb0geblebACnH3xkLIu25Gu7AzdG7OLoX6O32TUO38maXklUUxjDttgbg/yXfuW/mXaEzbnGfs1xlOpIJLSFMLkyigY3y/qLd1xmlgABRp3cC7FPOdSSZ+4yK2FJz2oHZUuDmtoyud7yQzktqyi/Xl/BDSpHwIdUKT/dmajfl3lnKhPKdgfHORn4dDcZr7KQEQ5DKvtJriFUn/M+3NBkzol0fsB7sCEIVYJOkq4Sc457gS29kWedpaHwohGPkTaF96bh/heIlJNEwxs8YoOjogmsWC55zYQcWds6OldyUSU50Pm/PKxU5ejR7wti2R71OBIQehwra8l1FmeKlQ0rXo5PMoRpGaG8uks0X/Hj7otH/DB0cbdo84kD9mmLYiLkHKleokQxDk7Z9qjdqSgesH8DNcRSHXgY0FDcZuJs78PkMDs800r8pX+sFljUy8M/jjwy/qWp3ULVYbELB9GVgoUgs+YHvfF4/dfup7DFR31rIs7Y9/lvakq0YGncNcUJ8J7/wWTeizxVP1jIvw++HA15MhDN9m9f+TtDI1yec8fI1ngpzcakm6cgY1d/05VQI6XQiX83sag8SgJEcaU02cnrssWKYeWnSmGfo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(19092799006)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XP0r/1efFp8P6ovNR8JBFwJb2GEJOKOQYQIFEWDIw6UvtbQU9MchdQPe9Is5?=
 =?us-ascii?Q?bWADOsrUbaojKxIswzz4/IRorQj66Ru6v8sHj2vRpmPC13qwLqdv1fyWL0lD?=
 =?us-ascii?Q?yjcdViCXxFH/NzxKtY7JP7Q9bfx7ir7TzKIF5NlbngyZ1GKXxTkMw4z4ADo0?=
 =?us-ascii?Q?BmMkptDCvE6LxLfZlXlOl5mQQd7DqyVmHnK1X9UJTcrYY3Tub0Ww67gTCU/d?=
 =?us-ascii?Q?SkzeqvqrRO98NOjJ/J9Hp5EqYjuT1DSHeM/L/o2hZ/YXKhf0uo6OShZ4aFXf?=
 =?us-ascii?Q?87Vcm81VRatVewqaSGN1xixwa3YVsL7gUx+urdGmdEvfkAhZN4c7zbnoHbb4?=
 =?us-ascii?Q?Su3ELI5ZQieiftwY2MukX02oLwDdjk0Y80eimaNn2EkR6nt+/Gop0IIM2cVK?=
 =?us-ascii?Q?QmO14r8n7sdsu4n39jDfLxX6SxDOPvCWZs7NxO6/PORF2E031e4ibMqKJGup?=
 =?us-ascii?Q?ArkXzxRx7OA3xRX/i3dlDPp3oC7xG0W+4mJ4j3JBxdAMI/Rm+CVSWy9UOXh6?=
 =?us-ascii?Q?ywDSwenEF+Wb3A8nNq8J20v49yBX36/VDqAARfew3vT7lUZ7Ts1t5qzcEJ4T?=
 =?us-ascii?Q?ay0RpkvHKg0pmDTwyHu0kiyXdbdkSiv8MUNnORAJ3i1B8gdfxAEz4CoY5Hla?=
 =?us-ascii?Q?xbdnem7BZkKqakjvnZPQZtzC63lpFazft4WQKU9Eox3p9w5V+eQaa3iew8oD?=
 =?us-ascii?Q?FALXffFVnxEPaAugzm1mNqE7vy+dJi/ehYzAZ8vC0K1g/0Lbt6rSFaLf5Tdh?=
 =?us-ascii?Q?gxBPZ8t/X9fC8Q/BjwNnKqcd2lnxTOEEHciClMQeKGIplF3pdqab7EmcgWHL?=
 =?us-ascii?Q?aIpQngbpftHZYVB8wolnyYqvOuAVD9GZss0kLTxta4fqktmNQCJiuT+afaIv?=
 =?us-ascii?Q?owB7DDgzYEz/wBVX+/jYT5NiGz7321HIPvhWKOX8OTD3e5fZXUl4Ed8kDTVE?=
 =?us-ascii?Q?6+dLlThJaotAMdUJfrvJbHIavxetGHAbBr74mcMq8j/o9fSQLoh3UqgHro4Y?=
 =?us-ascii?Q?wVeDuPyuTgyKsNr7N8ohMHMMHA3MnaBNOkLs2QFfoBCQJuR6Y++7q2PFc2J0?=
 =?us-ascii?Q?w9wyaYwPseSnFq+LJyX8rL1csIetRZG0Yj35CGZruxvh0II+ncRApb/1qRt9?=
 =?us-ascii?Q?aGqIg55otlRepjWNtvVY3PRepF/2nd7TCWB0MNvgiV66y7XN+xZXOmP9yjnW?=
 =?us-ascii?Q?INsEBdauJgJLQZ6RBs5nx5llfCeDEj7dMqBz3C1b2M8zdSc3sI8Ecq1kriH+?=
 =?us-ascii?Q?xEMumhR8vAqYrADWcBuc9UE2BUYmkI+ebEZzjEnvnbDZxlUcChdwhUxA6BDy?=
 =?us-ascii?Q?cq/cvEwGs7zDx3+vn7UCTvwZ28yg47kjGQfr50eWsDiBsGl8iIlkpOfc8zUj?=
 =?us-ascii?Q?WE6tFJOds2Yj2USoH+Xul/XtkMML1mggxR+72D9SbPHtQuTMQWBiJWjgkPoJ?=
 =?us-ascii?Q?0ldc2FyW2z9br6CsZdW6TGpEHTtaIosTYkKDoEbOaCXp03AShoodQ0OIAr7r?=
 =?us-ascii?Q?jKsJ8Xa9bwLjVe5/Z7Gna938cQ433ETz3w0rLd2/yJU5+nu8duJG+Jbm43iE?=
 =?us-ascii?Q?9xxPQn8Tl1AmIGitkkgCRU4Eag431Z4st+u+QXFffyT97ZhbamYdr4ZvOk2I?=
 =?us-ascii?Q?+fpPhIbbb+bGnqy6DeaRA5tOyyaPJEJa3Xu9BbYcLcgGRTGRCacelna7q3/8?=
 =?us-ascii?Q?lTZNCy+3cLdgkh9gYncaNZWaBg6+XRDxoiMuzY5bnTejVUlv5qT70dS/o4CY?=
 =?us-ascii?Q?ECg56q1UtHWEtONVau/r5SOzPz9O+lL8YO4qpBmgxT9yi6Op7d3i?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426defe0-aa23-4df0-0103-08df2aac83d4
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:07:34.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zggh5ntGPmA2ParuAJahbsl5MqS1VFdEv6jOZUq7q+HO3fvXR+JpBDCs7OuvllHI1oWb0IyfmG6tGNt22yO6THyAmOSpnNGgrtrgyZCpluHmXdevRR23EAYyMkfXCMVR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9818

On Wed, Oct 14, 2026 at 03:43:49PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>Replace remaining direct accesses to chan->device->cap_mask with the
>dmaengine_has_cap() helper which already exists in dmaengine.h.
>
>Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
