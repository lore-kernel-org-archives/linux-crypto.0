Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011003.outbound.protection.outlook.com [40.107.130.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7F219B3CB;
	Thu, 15 Oct 2026 02:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032656; cv=fail; b=o/f0RbCry5dg0jgQcZ7Z9YReeHqsOpIPr+pqxnFGBm2bLj1bZJcbN+Ig63+hVXGmKsXnyFkogvMzERzEKeU8EuYXDFaxEzh8cmbVv2QXUBGrIpkpP+XIPAB8RSwCtyONlF1ABDkMBxDhStRBLlrq1ao/IK1XYpdc1HnXUaeAa7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032656; c=relaxed/simple;
	bh=Jrlwbn/WJj/bjBtURyT12iGD1CJcPGPbQB9rTMv9Iw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fB2Zqx86EnGjbOMkCjw+C05+DBqHcOj+2RNqrKOB/2XVDMSl/MuXKQyyh43I3JuPEfdmKCg/fOn5EVSAwiDZt/fI//QrnBWthNKwnBw4AXx4k3yS2SBqdwxsziyZ/K7cMKV7t7uuc9e917inXUbkWsL/n+1By/R/3z4MLMr2baE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=AZH5MTvD; arc=fail smtp.client-ip=40.107.130.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="AZH5MTvD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtrO4hWACq6t1SFGl+z3lpXZN0vDfJSttWm/bCZcI23pmm4fTYaNZDJpHoIljKghI5QK20HNzyWvuByfju+v4Nts8cX8n2oN2u5DPOfXar2CBNWPWfte+ErRFJOFWZ34LeipUuQWCLjzM8LxyxdTxUigHdtWYihaw6qvU6iRfuFhqiUn9p8F4RTouU61Vg1KZeFsYuDKuIEQwAsuuD3ntuOUjPfdG9lK+5FuH3qB6JOzWaLkoQTmQo61nciQiib+Nav3wq3QYEKkT0oGSiQ2TRJmMXtWu/n/XUuLwXsP42XngmsWWd2mAKsmQzMzVbFwz1z0+XrTbsj95Mb/R29KZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48fSqzBh6k8SdUvaZJRDMQ5j7EeYs6MxfBoN7Ej7QaI=;
 b=g6nNaKrG7r6HebSDQp1Hz9JYmYm1t2SLXUScll0/O8knqWm3hHg9Ye1Vcl9ePYxu+YyuRWBeE/lDrz7q+Yz3ZUXYZAoLZ85hsBAU5cyiOBd1CugWR/hTjZ1455SclvODmhAsmEfGgOVLBRu5JW+aMh7Nvfv1xNnyZrKkjf12V65QvMBumo7Ozp8aBS3cCDaMHFiA04ydMgnI4ekzKBTD5qKqHwS36WzBUHvf3HJx5uqd0vKrGi1cVQJreBnzUg5H2liSyAQjJrDBWAzUFqi4itYpGCk7hEfhrH6Lj4F52a5xEknqMO89PeLlapNj26v3trI/QZvmXr3g4wjSwUGPsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48fSqzBh6k8SdUvaZJRDMQ5j7EeYs6MxfBoN7Ej7QaI=;
 b=AZH5MTvDe6zVpmROgWS9ceE1mTA1MWNTDvBSC9viq206rCoghAHtU3LY5yO9ers9TUsC+c1q/FWsW/JmVvO8Jy59PAZWUWubLywgqA/PGCwz5XcKqjFrkaoU6o3eHFZUV1CXYBut852usib+TvO5RVIOw2wdGqDwTvXKNRfDdZ6v9jVFvbJc/DlN2NpfTngHkxXZVRnai5gHtunCLzFFGnOdz6VXLqw2fO1oayUyyPNQHqHK2Zp5cyY1C+Cmn69ybhUo6QIp08bwen7VqaANvctenXgGiT7HOysgYIcpqKTtPvsdVpFVebJZGGILto744JKMnXkFQNxZxLUaBXn2Dw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by PAXPR04MB9007.eurprd04.prod.outlook.com (2603:10a6:102:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:50:51 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 02:50:51 +0000
Date: Thu, 15 Oct 2026 10:55:24 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>,
	Jon Mason <jdmason@kudzu.us>, Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" <dmaengine@vger.kernel.org>,
	"open list:NTB DRIVER CORE" <ntb@lists.linux.dev>,
	imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v3 1/2] dmaengine: change dmaengine_get_unmap_data()
 first arg to dma_chan
Message-ID: <atBAnIzA3X6PgB+6@shlinux89>
References: <20261014190337.1718622-1-Frank.Li@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014190337.1718622-1-Frank.Li@oss.nxp.com>
X-ClientProxiedBy: MA5P287CA0108.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b5::16) To DBBPR04MB7883.eurprd04.prod.outlook.com
 (2603:10a6:10:1e9::23)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|PAXPR04MB9007:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf76b5c-d46c-4439-9a03-08df2a671dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|19092799006|7416014|11063799006|56012099006|10067099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bTgjaLCG+PHyMRCJpWxYT6uUmN9vud1dK0Sks8zmFlEbVYOpAWAZMCSVWvuGT4U7pHHeWKrAcJOTgOOXiCKi/ZNWZ+26ZzeyKbhXYwvJa/fJ40k5Yc9FSPYOPx8mfpHHkTsND2cFqwhhRZdfEJaEBGM3ONE1MpI1CCw/lBi76SYXd0F7no0qEy1+0klJAt90mFyeB5zScgI/yMGxgheDX/RecGZdk6n2R0bPZI3lvE5XEoAHAeUe3smxQ2y6N1P9OGqbrMWvJtK2DMNkQkg8jq3yzF1ZOzzyZwLLIRaDuuuXO/lcWc3Rd7AGOwN+ELTgWzzIIr5yX8nI+7LhYaG/zA+erejXVzufkaALPKzGTMdIoXEcbKQ6HNNBBCX3WVbKiFxXzNnbIwetKiTbOy6TutIsvLdXGh5b6bovBdTwsjQSTmClkGP12RzUrBcHgfvC0IOC9VssGYRyIvi6gglub8YP/M1p4B8il1ObS1FmLmJli55Ff846JHKbdPA2aAUw9OsCM4mr1mDg+iHS1VB8xd48Y9fDFR4MdFh4xV2T0TyaE1FpEVJWXoNtbYu6VaDQIZID51gdvQJW/stYcHbl4skq+8ocw3zMNvbNCgSRfeKmpaP9j/9L8PUpMZA3Jm2I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(19092799006)(7416014)(11063799006)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GFeiX1wx3IsfZOTdpabcFwOBY7jeo/p8f3NV46yTpXEc5fGPOYjwGfhwb+Ti?=
 =?us-ascii?Q?M+AdhA8XWVA6OqoW792ni7dDxFbU4JiRvchlm0mV0TEJWJiy2xsnKEptJjLv?=
 =?us-ascii?Q?MhmjatyOhbypgwZLTPEZsLq6WzGiDbz7iAPMmfoqBQj0yrKKd9Lildd1wncm?=
 =?us-ascii?Q?xg/75qSwvCoRoAA0tlSEdYvaZ7NiIaVEt7P4LVGs2TYmJJbhCqQI3ttfx9hH?=
 =?us-ascii?Q?O93Ft51g7gG9yk+O5ZxZtalg7Y52+7WC6XRnF07Jd9hVQ4E0HZ7iQ9etezT2?=
 =?us-ascii?Q?IxUdJ5bOUdxmenMherLcQzN2A53BSUOaNlq9VlIfJNRAV2Js9kfMDGNXGi1c?=
 =?us-ascii?Q?kzMBb/EJPDP4KOv74dr+IK9FJ9aOoN9nB+jdAHpdzqD6eB/P4XWMlIQs0o9L?=
 =?us-ascii?Q?8EOA4HMBpinrX3reIHodaBDXiclDTuQAK6MwHr3a0ggkyTjrd1RbKEUKUhRj?=
 =?us-ascii?Q?CxSYX4s1UiXM4h+LCw1HSGBcVsZPlv/Kk4C/rSpdseq6AFNq1VaqYPdN6fjy?=
 =?us-ascii?Q?j+D5RPHxmNTo03QQlR1UK1WRxzEwuy9lx0Lb3yp5WBRDhdNeWhsCvHDygYO6?=
 =?us-ascii?Q?ZJcZVtV3B8mQY+IFOdfLBTcOUxZQ4kPofK1/yrNS/8roTXPUPWEOeOKG1RXJ?=
 =?us-ascii?Q?l0jYdAuXzXdCDuQLRoBbxc3fTIXCF3Nf1KpwMnNW0aHao2RMob0Fa1zdfIdj?=
 =?us-ascii?Q?RR5n/6QJvyES6gHB4NE9/VNVeDAwqSrInqt3wAOX92X8rrzprx5EIHclXeZH?=
 =?us-ascii?Q?N1Kz482dGDmE2MV6j9/Hr3FaiWdh31rhhvDrVZmzTarbzT+2TNFRcDT9YwRp?=
 =?us-ascii?Q?a3Rmq+qEtdH+ZflFUpszp+htWNAXjgeP5A+tze0TToAYahKnM1VP2DbVnTex?=
 =?us-ascii?Q?T6OrOhRhkdPJD1uOSqJiO9Ea9GTIffbFb4v24FKk4JnqSfIcDNVdHIAsPuvr?=
 =?us-ascii?Q?RG5J45CU8+FlAIdKRLBspaqPrCk1ARieeR0WtU6r6UqNvuqLR+aDiSqQaFpb?=
 =?us-ascii?Q?fa72rPgENQPU9yJq/bYgN1NRaMvQ7XpzYqngrngu+HKIfpO8TBWkEY2RHkeU?=
 =?us-ascii?Q?igeZgYF6i/9t1ytWuUmG+7firaX2poi06L/w+1kLmjjUxVjNae28LnYpJp0i?=
 =?us-ascii?Q?mlnHdOSRbEatduybT1HVpAzuObg5f5SIBkSiMldFUJY2qS3lbOe/t3L2F7Sd?=
 =?us-ascii?Q?AhdkwwKagPpgASIub9Pn5XVTQDKEcNaeUGjDEe8LkecUjUSl/5spDMMHTZUb?=
 =?us-ascii?Q?YF3+1lvz16HIQR4mTScofPWXJmxmevmorZaHutEWfV2vh6wRtezWUfWD5OHA?=
 =?us-ascii?Q?jL+PtBZhatMQayAuRYyotpi2nbiOsK3PzchXamXEBOvJr69yKJFoSJfpM8Nt?=
 =?us-ascii?Q?WbfIJO7VWTUkQ+y8lxdQkINYEls5GJMWsVY9PYzBtVC53+r8jiU8K+iO6q7M?=
 =?us-ascii?Q?fnZueZbJLJT9XyhyX/6NsE413NiAX6RDIh21WN4BROjO6siN9exFMTvbdVXm?=
 =?us-ascii?Q?/baKFLz5eJ6SabuCbriIU4WCGZxFewdGnjgs5CbLgtBhZbhIejmLSFm3RcVU?=
 =?us-ascii?Q?9jQ8s1kgkXXTofqfgROuXoMCFiYWiDlkxaTttULPKL6/2oc2mAtrHbbwbKkr?=
 =?us-ascii?Q?IvjGzYaQDXGzRyczGAxvQEE2G59Sr3IjxXESLo/lWvN4+L4bWJehsfSxLVRG?=
 =?us-ascii?Q?5bpU2ruV2gtXxJocCzewC28A612ONkN3gA2AFSoWmRjJANDIf1xvxWroMCyp?=
 =?us-ascii?Q?ddyogrXZ3HCMfmcVJMrIbVWXLABUgVU9SG7vOw6y5C9i/PEflBws?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf76b5c-d46c-4439-9a03-08df2a671dd4
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7883.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:50:51.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yulFTnXWPohs8xlnmdPrEuS+lwpw2H9BrscHvdokwuxHPlsd1yPm1+ST8PMP+SbKPBwDOkLp6Ti934nforsLjpUfiHgufEuwuSKmzqXSbLz6cL2KrrSgpG0J8IqqVrvM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9007

Hi Frank,

Seems Patch 2/2 is not sent out?

On Wed, Oct 14, 2026 at 03:03:24PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>Replace the struct device *dev argument with struct dma_chan *chan so
>callers do not need to reach into the dma_device internals to obtain
>the device pointer.  The implementation now derives the device via
>dmaengine_get_dma_device(chan), which correctly handles the per-channel
>IOMMU mapping case.
>
>Prepare to make dma_device private and make dmaengine API consistent.
>
>Acked-by: Dave Jiang <dave.jiang@intel.com>
>Signed-off-by: Frank Li <Frank.Li@nxp.com>
>---
>V3 split from origianl thread
>https://lore.kernel.org/dmaengine/20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com/
>V2 change collect Dave Jiang ack tags
>v1 version at
>https://lore.kernel.org/imx/b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com/T/#t
>---
> crypto/async_tx/async_memcpy.c      | 4 ++--
> crypto/async_tx/async_pq.c          | 8 ++++----
> crypto/async_tx/async_raid6_recov.c | 8 ++++----
> crypto/async_tx/async_xor.c         | 8 ++++----
> drivers/dma/dmaengine.c             | 4 ++--
> drivers/dma/dmatest.c               | 2 +-
> drivers/dma/mv_xor.c                | 4 ++--
> drivers/ntb/ntb_transport.c         | 4 ++--
> drivers/ntb/test/ntb_perf.c         | 2 +-
> include/linux/dmaengine.h           | 4 ++--
> 10 files changed, 24 insertions(+), 24 deletions(-)
>


Reviewed-by: Peng Fan <peng.fan@nxp.com>
