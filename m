Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012019.outbound.protection.outlook.com [52.101.66.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230204A5EC1;
	Thu, 15 Oct 2026 11:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062399; cv=fail; b=Ln3pxYCCLIkdrga9CD6/gpX002UZLz+kulwjWMzTXnnZQf7ROJfdsAzGrFLppCKQkvT/LIPt6NCVCHlwNy9uv7B0w4GGAHcxhumSp2t8EyQfiv0MKNzxbFR2hwOWZLKEkB0zT/zX3FznrejtljAUDagZneRoOMIMin9r1UfMlRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062399; c=relaxed/simple;
	bh=kJnszSoMwkijkCg9c8XrgULPOIU9rIIFn9DMKPYoilc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EBYaRdYUV8tEtuYKPYfoC4n6/glJXhJK9IUg5+wB6+BbjWZPdCRpL+T783UFSE1B5BZGRdHZHcSREOWllGlrB4GjMnDiaO/0X7MYlLwVT5OZS+FsnrwgmjkUP2rJWm7o7NOecHBVo/bCzZj4tqVbyHb+wAzvmfOdmNjHAQz1FDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IuydU3JJ; arc=fail smtp.client-ip=52.101.66.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IuydU3JJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GG9vAUbueqgDRFs3tk1z/Q/1zqcoqmI+W8WfwiUqRcjlavYY9Nzs/PpxU2jfPxBdQJ9NpND5FWDsCNSL7JQd9fe4CBA/JKBsqLU1nTIYWgWI+qDfiKvNAlv/EqA6GUi5SvKjGgeSAeOzBHN4DFX6g05tMP7Ft5UNZDoRtgsCIVFnNy7dEHokp3XvE0/7ytdTSDtzbkzh39oeVKoLYhPkFdLPddNMVyrO1u7xn6JIEo8Gt3X9iC//qHrul8eY/DFkevPc2AITZo3KWwbjBQM77UnKGgzn4ccvHC2dBDyHGVJNTC5I6QZjPT1AuSh3uxO599PH+acWxItwt3HF9dKubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJnszSoMwkijkCg9c8XrgULPOIU9rIIFn9DMKPYoilc=;
 b=H7GAgNCXXUyw5+juAb9FU3XwlWfnLILxAwgbedGg8rZrvPxhUpP3mcq9c/SLLeE2oyAgUrequmA4yif0fp2NzSMy3S4nhTiD1r1Iw8ZXpXXZ4iXcj5D/KyRCo6DtBB67VTx7ZZD+Ks55tJlTFLaZixYNdCECxfftCk7MgRvbgGZXRhCijiwpiZjuPCqab4pXuxl1HIX+E5qFNb+kAIgWdpeqrfHcQ1FJSAKVN1ioggQfd1npP4tC1mff3/8cmDBlBlCwlo7GRlLltzCfKV7Djn/1i0o425H6644w2PvMwdOLXh3d9SLV5KQQpnBplrPxrThZlfPP8qhGszCAel/j0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJnszSoMwkijkCg9c8XrgULPOIU9rIIFn9DMKPYoilc=;
 b=IuydU3JJgzE56alkNSRvoUQUeYaVnDAsq3Q3tLSBr/ugWdBa0jb1U4tFEU8YAPKIS4ND7b14w2u5O6ZOk+XQzsJ7rxVYLCYb5XijyMwcowohPKQoyjXTeLbyEEXkpHuWsTXvTehpnMrSfLcHejnzGQoFLOFk/bW5MLyPIm1vTi94Wxt30VGh2mxLB0klVttYYzd3LCxVY6v3eOgr+EanfpHnGgvKUfpZUzPVyVB0+0viYm3EfPHbpTHmYt2cUTrPa6t71pxzSA0LyttuMCXx3hKjL8LjhhDAIcg4XNCAgHYOQRhkRV/VXmHzokIkhBuNyNCVj+O0vX/C5Vowi42ZEA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DB9PR04MB9818.eurprd04.prod.outlook.com (2603:10a6:10:4ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 11:06:34 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 11:06:34 +0000
Date: Thu, 15 Oct 2026 19:11:11 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 3/6] async_tx: use
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
Message-ID: <atC0z4P7pHrAr43y@shlinux89>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-3-35790d01e190@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-3-35790d01e190@nxp.com>
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DB9PR04MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 834724c5-21cf-4568-0f45-08df2aac5fbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|19092799006|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3+efuQNyChyvaDB4eedtfV8P5FjU9cYQy0nuD9TZdUCfl8qZSdTiJN3E0KvGsda+XH83C2N+e3M3r7FYFIwHYnEluyjIKECc/HpUnHaqZ3RCol3nNTqvk4ig0Y0m698Lc8rTlzF+jMZQmFX02irg5owR8kMrra7wX4uI4pNxDu0/7cPMwxiLUi3eIhKp6SqNPzyhis4EgQ10SjMN5k7XQ+9P2QTZDY670Z8uHMpUCJ25AVa1xGs7e3JiuK4R8+2c6Gw2nIrTaJHCbOru8yvVCUndXNyG9Xez5A1IDdogZK7NIL+WrswLiTziSUBVNKuGZCkcgB5Uw94EDq/1B6hSvCzlrhNTavgPf1rZfye8qwv4dwA5nQVg0VlTdxIbrKf4y4V/5VAPT7/VIkpKdtsOlRMFh9FCUBEvMLIyMhlRXIZzOjcdngEqykmhNg3kOlR5iCKjQN8eVJQBEENyRgHHXRMITJsOiFEqxK/jNyu1r303rYrELLC5le6NDzIpKNLWqQQXqNB0jPZ4llJi5+osx7XCokF1Mq5tdMPwP4B+9NArQKQtg/XpQiZv/3SOQeKrWmNRw4F7Y6VnVW17uQ4/ghgF/OzS0nMOJBp7w2KiDosSyu3eOHSad6mKkwneRo77NEfOT8jJsu9GCbuOSO1oQx9vFD+URTblQdC324idbTk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(19092799006)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3wseOSK+87WgS5qJNR5Pg3O6HBeJ59u3pFyNg9s8t+sVmNaH9jVdDA7Zra7s?=
 =?us-ascii?Q?1sJtpfHzNUi+5MWqEkEVo1J5LmfT7bRXOaFoVseiLd8eZIRZkdxg/vIfdihl?=
 =?us-ascii?Q?KpU2DfdqA7NRis2wzUDk2klu09Dy/Y6OnPOOK+kI2ZizJ40Cp2QtkeoPlI1T?=
 =?us-ascii?Q?Gz8+YXBLXL1ICD72NVOMDjBu8LL0Us+yHaqJIMfm84Qo/DnZ80uv7JgVzlgr?=
 =?us-ascii?Q?baAYs733giOnQMV8Bfk/MJhHWUowqykpptZDk8PfAWIIR838ucwhZ/VCwOjo?=
 =?us-ascii?Q?OD0omsnyvBhgj/TbjzsvqDUak7uyujoD0iy5TmiO3UyGoY3Eo5qKsWy00z2B?=
 =?us-ascii?Q?pddBdHZ2OdiMmY35FozuK77/K4+JCsvgk8FEavj2SPEvBAqEzGSWR0biAGTR?=
 =?us-ascii?Q?8mJEs6/nJy4K5GNAsV0cpuyJWhNdTw9FDEcmjAYXGEQUTv30wnT+CjrAxroZ?=
 =?us-ascii?Q?rKrQ63K40H7zoLpJmjxnU0iC4c1IIZMeOxFDgICDT74whdvSFWiFdwTu6z+X?=
 =?us-ascii?Q?W1PQa0hgCylGWCLAI8H+MpHM30eGIn9mmHGMn4y9U0Jj3zNxM/9S0ybHSfr3?=
 =?us-ascii?Q?MAYoKfO/m7ot0nvOQTHmli1jQPSDH+6WDcE3k3rVmu6eUmuyxm+rCJuAo1nA?=
 =?us-ascii?Q?JeOAqLC+FeECesCgyv9Uk8Hy6OtF6RnHndWpIFYOWRCsrRtB/R++5KqozeXH?=
 =?us-ascii?Q?tfFozvjZleTo0U67Erx9cWY5iSv/t72mq5B5mTt+71GXPhstu6z+BI1KOjF7?=
 =?us-ascii?Q?5bCMkl9rH0el0w3aruvA5lkaUwMv7LPyfB5GS3pm/2bwPyx8JeujlAO0199o?=
 =?us-ascii?Q?SuYqm7tKmTJgiEmujoeo7uA4hqthMTEI/DALyYQu8T3YhycUjyZqLfebeEKh?=
 =?us-ascii?Q?M6nhZ7TWlBPdH5puB/kO8q79VRoy+WW7fv5hpfXcbee/X2JfUSXMeRfgwy8u?=
 =?us-ascii?Q?5lNeMBWDIerk1PNAxYpg9a5VvaQG/2vlqrwYEYMC40nZUCce0N+892gABJAr?=
 =?us-ascii?Q?Gi0YAA2Mx0E2gwd7yF5Iib20U6T/Y+Jr43fqaB0gHE23rZLsiLMTE+w4H6KD?=
 =?us-ascii?Q?gqSq1iNe59Na+KSyEmSTGUUXK0McsPsErtH4mX/VCe71mQkfy0GLhtFFeS3w?=
 =?us-ascii?Q?s+bon+8DJfLQzPfpamUdZ5XlxByBusxrpN8vy2lQvroiQZEDIEAHdiXUeMux?=
 =?us-ascii?Q?IY7Ks9JGVFrhTEfbQwsfGmkr3Rws061W1nTiuJuhLYP58+6KruMraNRsN/kl?=
 =?us-ascii?Q?9MDG3J3DJVFHUGvf0nR+FwmeW/H8qnw9UyTr4eRFCbjzgYGb2ZhTl33RTXZI?=
 =?us-ascii?Q?tQXzbz0mwaVIts46DOSy5dBgDeIZD8OHhkvwN2FfaM2W8Mj8EHUqToJTUpo7?=
 =?us-ascii?Q?nRKakn3fgJObD98GOAJnCdp0XcHJmFtljBfjI7AkEZuAg9N3SFdz14DvCyko?=
 =?us-ascii?Q?VflF6ynpXaSh0ryt7hYEb5VmLuS6mL06nwtehp9Y1FCQByS9f5fk+vplLRQN?=
 =?us-ascii?Q?oMmHpPvxDkv9zMVcOLiIeg+8k0EoguItsUuCkh799zCh+T7s+/LHbMkrX+/y?=
 =?us-ascii?Q?7ICnsDI1SCK5twmBzzrtR56BrgXURpVQQExJqIq3hE+xwwX9wxK10k4B9PIe?=
 =?us-ascii?Q?x11xYkuuYIE2in8U6opywsSxp0TmOXActysP6lHhUCaxcRlk75fh5KQhKL/d?=
 =?us-ascii?Q?vU3S4bW1v6nyhDQmh/wRt7VMCSvSA/0NInQ0oD502qih9PyB6+4GLpP6Km7j?=
 =?us-ascii?Q?RIlHZX0F1VdhmyaBqNeYjOaqjac2LVlKsPzaV5yFMxmNpPqvoKWC?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834724c5-21cf-4568-0f45-08df2aac5fbf
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:06:34.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oipEhiypjf/dP2/Zj6NmU0WSJyxyMmmGRGmykzYzasXrLd95fNugsA+3HItZ5ywtoe79Cj1+tH/433sRkBVEjhSlIHUVHi7TF0iBXkDJ1Yvfuk6fr0VKnDaf+Q1J0UN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9818

On Wed, Oct 14, 2026 at 03:43:47PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>Replace direct device_prep_dma_(pq|pq_val|interrupt|xor) callback
>invocations with dmaengine_prep_dma_(pq|pq_val|interrupt|xor) API,
>consistent with how other dmaengine operations use their API.
>
>Assisted-by: LLM
>Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
