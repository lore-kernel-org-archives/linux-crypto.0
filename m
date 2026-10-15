Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013056.outbound.protection.outlook.com [52.101.72.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E53EDE6E;
	Thu, 15 Oct 2026 11:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062299; cv=fail; b=ZVDb/7w4DQWWRfKqiHrfDP45yc+3ADijBxLBXqdZrallaCHEc+NJkvpelI8qZ1k9nTXkaPukcP6Ut9/k+xIVefmOXndMcxoRTsr7oZduWFwG9ZpKZ5uYVbezDjkycpKfbX2Nnz+wLNoleXLyevg9V25jVTfacbCWR0ndWvAxRmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062299; c=relaxed/simple;
	bh=G7hpuDvunNQ14JOqmowR4ik2aseBeaIZLBS7H6ntUbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kDnxXfC1Ncwv+N4AqIxWBZOHV72PDVi12D9Ptrz2W5KATbsLIHipN+bI8py1XjHd8V/afyuxfc8bU9UnUwQRP/FETZ7KVxIMojoT723KPsfVrUbx30LmiDkjREBkiv7dvRakXpSs953ZuKJmCNR9Di507EL3BNf/3j3zZ/QQYZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rR2ZCRgD; arc=fail smtp.client-ip=52.101.72.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rR2ZCRgD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSx9OCJDxIMxdC+GSO1Ei5pTn/gXIEwujHgITC7YqRAd+ig/ALU7TardVzXtsUXR6R1dGICCQl4M5SDiUa7/S9m6uqYOenL6r/7nThWR/rmo/GKZpnts/nSAX+g6dCb4fHn/Hnnf8bI2vOzndKu7fCrLW6SdTlXqfEBmAYJA/61Aalu46e/eRBOy2gFm8zNyn9BYvCaTJz2itIAv7+xdDMvz7Rj96iNHRnqLqXZIy52oN93gqzSeZxTyhxPDEWc05n5v3ZIEI1Af5v4oTGP/wntlMCZtRBKyz/nVt5vb9ZDoO9SBQqKg23RwGm15TU8EGuYTHj2eCfePGhiK/bMNJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7hpuDvunNQ14JOqmowR4ik2aseBeaIZLBS7H6ntUbE=;
 b=SAteaKkaNQtsd1zQj6SoE/w7jwwKalaK1i1g5U8ry0gEKXWJVh0jX1tERFFyWSKsk/lX7VtMoogPX6GI0jPtRYiF7t5soG+CKJ6IFy7pt230PXrgaSTZvyozjrM6Y9FrhLtmJaUBnp9pEWukHsSVGXhwuxfFtQyNjGC7MAR6RjQFKCueq8ntG3jt/92BloqGaNPcz6e4prCf+LoQ7eL6mEM742nSRauW9TlZSf1veBz1SW/WZuBy8vMC2SZA/A9Xtzrkq4pyJnXxYR6JZJCEi4cO06pdYpIlt2udzdNcLCwVXaYErMcK83SM3Ntcfs2IbNo74no+aVjpL1juYm0MGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7hpuDvunNQ14JOqmowR4ik2aseBeaIZLBS7H6ntUbE=;
 b=rR2ZCRgDWWCVWGZIvvoKX5HbCK8vIHozHZqUIqr2yDLvPM+kufVgppfqeQqUm616VDwCGpTyKuVQofq46j5MftSr1Uljg8kaCXHJRsjQo7Xg3kMmvXmEiPC701YJQCJdRau2OgmpZPX6HjbWktvMCP5yhPzCvhDLmxcSuTDkNsl1M2A1VQbkbl3bAdZem+asbIy2b99fcOCAWE5bdR4Ac+X9y80GLOjtIfcNfUAaS4obxdAhp835Q9nz0t1PEcaNql5lkw88EP8SjbWjQ+dEJBuX/RQBRMO1XNRDMZYtQ/ncyrvHPrLFjpZ9ERNITMlqWeFXYuXwPVVbIsY3dai9/w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by ZR6PR04MB543146.eurprd04.prod.outlook.com (2603:10a6:910:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 11:04:55 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 11:04:54 +0000
Date: Thu, 15 Oct 2026 19:09:32 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 1/6] async_tx: replace direct ->device_prep*() calls with
 standard DMA engine API
Message-ID: <atC0bPrGgvqgsZxS@shlinux89>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-1-35790d01e190@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-1-35790d01e190@nxp.com>
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|ZR6PR04MB543146:EE_
X-MS-Office365-Filtering-Correlation-Id: e669b9e8-efa5-4836-601f-08df2aac247e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|19092799006|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	k5SkYZtwkM4F5MG0VsYwMZ0IZy1TEEd2UvL0+XLLbK7oOe8PC7byp+v2C36JoUt7ozxxEwNcr+l9y1JjpkPmJObnqPAd1avJ3f9XW+R7MUgZLSmYdClHyMwSTgKipVMKLAU9UhWlvDEJKRbVxCOMIs6Tk4g5yNu1MVoxo3t3FE2d5Kl1dyBY9WdsTCWcNLrH60cBT5+1U8HU2zt7Jb1JBnkUyiGNjh2jenyREmZawaHBN3WFg9C0Jwz2S7UM89jSAjeoyofccsLfP/z1JJwzOGMzg64tOF13rYLJMWr97eIOQ63eRH+gvEQVmjwyAnKxMbphIAYeQtBX35X5CPvte85rjkTF8CnrlQ3m+iVly9boG2l4a77WU8OyOyk9vzC6JSDqCgJWuo22apZFXBciqsBp2+iII8kZzxTQOTQSQ9P64ObHET/lBAppwcZ+XEp0doAikna09c3QdaX/JEubmUY4b0iCQj+Vnn2w94F7ajapcrOtvyon/WcSoZ6jMi2Z+fOPeH3JQ6Ts6UPxR+QHiJPfHSTIYgbU8Azb4iRSxnPzzwbqILqmQdI2kRbFhhzn/hxBEuRc7kg7CU5KRY7PGQgs7ee+mVdPHkb4yZXBxMxaPvUPD+rtySHud9SGNpaTKlNB6tDzzpepsumNmBYhKTe8ZIY9RpzmtsdkROL1IoA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(19092799006)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BVz0zzTGMWH8nH+ggG0IGqNDi0tOCXCdYnb443V7hRRJvxbDMpEzhxBWDRBI?=
 =?us-ascii?Q?GMuRBtbrxdrTBsL/UyaltnwooW8GNuGON9yOLWUsqD8ses9H24saoEy9BTC4?=
 =?us-ascii?Q?tv+jJuUG0QQl+fYvTtzwSGdwZheyI3BBarZRSLRmdFdeYohSXi76lNUtpZPl?=
 =?us-ascii?Q?/AF5tEwITrIPP/lOf8XNu2q2DJmjp897CWjb/70XqFUKL5sr1eQ0ZxtgmOGL?=
 =?us-ascii?Q?1uL8Mas1CxukpNIcvGsX+pjOYiOs6Ud+0Sw/ydp9+g6XitDLzYGXVIuOquTf?=
 =?us-ascii?Q?JIIEp2x7NSbv8Uygeib6eJTMDvHu6m3cl5hSROFt4HfnA4tl/7DOt0MjL1/x?=
 =?us-ascii?Q?BMxjCyUZ7gUpyFyBNvEndD3uytfl1w+r5kCQ4M+RrbMKlKJ4Tw3Cqnwt8FsX?=
 =?us-ascii?Q?6wGG53ZF3hQPgMjKlmq3c/EAmVb9jUi8JhxkSLckicfGrXsjgodsxuVuPtos?=
 =?us-ascii?Q?PTo7VtO5tMAWfm8hXiM++jJpPhs7WLYIHkN/1aPHrnoTkORrgOFzd/UDwvJi?=
 =?us-ascii?Q?FhGdF8cXobUqwfS4jCKRat/l1A0IAXSUnxHcTTu6rtW8KOZ9fd6or4q7ALCA?=
 =?us-ascii?Q?mpizaidiQ3tUT21J4Ygf0AubPrmlMX6K6MGLz2OghFHWpKPczuMioukSjuXa?=
 =?us-ascii?Q?Uq+yNDGdmFD6hlyTEcIGcVqiUKVrAfYdDzmNMBrDakj/VK8n3Rx+xk1ppCNa?=
 =?us-ascii?Q?a/NqpBMLMvmeYzq4mEKcE9JGcn7KEhndFxxMqB9pcyKftRnKVVrdPpk+32z0?=
 =?us-ascii?Q?S/UtSAx6d2QvBjxV2lLfl+MUVoVy/tglOtqJH2VS8DqoZql0rh3NYWmMsv0q?=
 =?us-ascii?Q?PGg5WnbIAelMhGqWp193aXtn5SPlbOTZXhrMcZpJWiuiBGALHUlcnc5za+Uz?=
 =?us-ascii?Q?YAKILJQaUPZ3+BtzZm6YgZxV5DeW5wF5R8o/d1CSIa63qRWgB6RE6hr+0ro5?=
 =?us-ascii?Q?cqmHgePtXVoEBtfqgJOeteiAJvK3B9SilYl9vVYYnW0fIM/1JmvSyUWzy0wM?=
 =?us-ascii?Q?FPAjqFencB+oGPJRlocTHoP6YSKmFuQK3vjSBVsVE68HAavsG9GGoCPZ1J5Y?=
 =?us-ascii?Q?Gb5+SCmhAloEtrlKYlGFaKlNSx4peME4AxE/vyUTplDz6zO30N4aM/uXAGQk?=
 =?us-ascii?Q?jUZ20RcNowQo7H1LDMtBS1pQ1tFufopHZlcPIqp0dCOkrdSD9DadVybUCpuz?=
 =?us-ascii?Q?Ge4ElDubE2IKC+eK5zX2//sWWiVfIDMixPGPOU6WfwEo1Bt1MFXCYMELKWX4?=
 =?us-ascii?Q?cfeH0ol1sT2cpw2Yp6dedgsuwBxzO+UlHrGuTDEUfVLsF2KPuQzIArY8ck5s?=
 =?us-ascii?Q?3wUERIf0QioGY/WW84SyL1bg1YxhK9dGkFn6aWF93vQ2ueYHYVi1/vpVjSAF?=
 =?us-ascii?Q?MKPxYKRgbp8zTYZtjdmQX6qKkvHv7QuuXLcv2XlwG6FHYnStXncN0Rjw1+hN?=
 =?us-ascii?Q?yK+2/MMCj7lSFDiMuzbJyHSuhVWUjvJBP4muF/SakUl+/69rc0CnCN2cW4k8?=
 =?us-ascii?Q?GHowKqgWhWK4BkJcUZ1tAW23LhkTtu4OUSRBVSYQ45FPfOnQVbEPNX0byyOf?=
 =?us-ascii?Q?Pa1bxXLRxizEckL+0AcUC0BJCN+JE2H8dO8hwaS9B7GTgNpD2U/3zAmyiuvV?=
 =?us-ascii?Q?aNmRyqjmr6X6sMUB+D8JKXdjyoyLPpO7czQrKgN1xVu90lXJV/Pqg2nsAVul?=
 =?us-ascii?Q?zNesVVQc3I92eiy4AXbeRsP+eZpbqtr/BTpZpjptO/ksO5o1nPf7HoLO5InP?=
 =?us-ascii?Q?hkTM8YvL5ZYKDvH4TE+94v7aYa1N0RklMRsoKPw/DHG5ZgEw/s2Q?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e669b9e8-efa5-4836-601f-08df2aac247e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:04:54.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0aL2fkn39NLu3gKISpsMF+p1JvGJL1sVr5lRp1IzyTt32CcoBBZkbeRN2pkD+dXjwUHTdcuFDdEEvBt8BmbabRXGNxXYI7cL6XIgf1b5w75zyWOcU4j9amIpM7XG/I9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB543146

On Wed, Oct 14, 2026 at 03:43:45PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>DMA engine consumers must not call the channel's device_prep_*() function
>pointers directly. Use the standard dmaengine wrapper APIs instead.
>
>Assisted-by: LLM
>Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
