Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010009.outbound.protection.outlook.com [52.101.84.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE65C4E50C4;
	Thu, 15 Oct 2026 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062444; cv=fail; b=gEz4/EWwyma7plgzLf0aShGwQCZJ2SDe+ubLdcvG9G19mbGVRclDZ35srVf9Yebvd9eeN51B0fr3+8GLjg2Yinxy6iKWZrbPWaK6zTmAT0D4NRLWRYEUfYg+Ps/UaWz90K6WUT0tuQBcVccg/hCrQ0J2edFiI1olYNEf+f4QOTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062444; c=relaxed/simple;
	bh=aB20SwSh4ne4hjZqbSHFudq2uXJAF7Pj7JLfBWNcU2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MQTVSmBEkU0Prlz8fGuIrxb3EW8/IOy1+0qMVt5OEcI3hvvbHoZQP7q5Eq3sqZrkw+aIC4XWypXb5L1s7V9+Gsktjc0p/bwxfEucl40kkbySpF9xBZf8laK5Q4EFDZvf+FOVUN41ProwyHlOVIKAXr6mgy4VJTgWRDuCvPMTboU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Rw8LIPNR; arc=fail smtp.client-ip=52.101.84.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Rw8LIPNR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlIUkk5YzHUejxr6BFXSN4vhAeL1b8HBYK4UHAoHcY3KD9ZC/vzAIXfxOI5L5gexhxJuCsjbHqfwqsEy/gPky5vTxRpp5vSW+O73yyn/6+1i5Bj5Gb2vMjUHRwGGGT/F77QtqXIzDH5sKoTeaE2D/Aq1RnkOGyz3t5o9EL8r6T7H3cD7e/tE/yQ+0cQRAZfNqp2ll9sjfjzllpsrOCwSlDlZe35dS4Zr3H/us/jsylQqjPURNZw0lASn2PjqUaW7A3Xb+OWHJxGwhLdNJODOCsDCLd65QJfoftiYqQWDQOdrd7e2ZtpddLieiCtUE7MF+FqDaADtksDdqYc/3ipoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB20SwSh4ne4hjZqbSHFudq2uXJAF7Pj7JLfBWNcU2M=;
 b=q2goqy4ZmXVAUd/eCodHUEmjUWXjzASSE7xdVMc8ZoOyJrPDuRZkfD//9jxZ5AO9AHgmIMOhy1tOA9TBrM66ZiKrKmfPa1MdxtKX+9/O/GTlMsj9G7HfHqTU446Rw7e6reEvPXunzdxhhBoPyYGN5KF5OvR3ouDLOIzY8sXY0+mv3OVI63QgfNnnnwE0jg7DR+/J+YlF7w02beB4oDNanhFGPsH4lw32lmrydbfA9s5LQdTlkVYRtHmGfERNS5r5bhXWNh0c4FtO2LG47faFP/gS8nhv0NGAzhpcKCohmQFRenn/oFJdugK9GwdpeTvZX/oArjygG8PA1en/DcSjag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB20SwSh4ne4hjZqbSHFudq2uXJAF7Pj7JLfBWNcU2M=;
 b=Rw8LIPNR73n0MRXWXLa6F2zCeJfu03HvGKtqCLlxKnpOvMvq8ylp0F/fFBSfWgkckPkspneSxAXrQIiuYcKG9826zB/jVMfyLRcgJwtgUTBlwfw3PaTXdVoGSPlCiCLRMhEZKWXgWej9JgeIP1mN1P2ICVL1B3CAdBm1JWHoYNbcyfSd05G96QLl7plfCjj/czit8MyA9/dGbJks7xkD6RWeM4yeCt3LS2zbd58QLR6N+CnpkACXz8OKqXIbYJONfsk8Lq5FMYlP85xCz6nA4UKuC5TDJXnvLZ7g6muqfs7BKRHhb9jSY7+roWmh8D8pDivmlcWCSnnXNIUaZ0UCZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DB9PR04MB9818.eurprd04.prod.outlook.com (2603:10a6:10:4ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 11:07:15 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 11:07:15 +0000
Date: Thu, 15 Oct 2026 19:11:51 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 4/6] async_tx: convert to dmaengine_is_*_aligned() helpers
Message-ID: <atC09xjJne5gcgRv@shlinux89>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
 <20261014-async_tx_dma-v1-4-35790d01e190@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-async_tx_dma-v1-4-35790d01e190@nxp.com>
X-ClientProxiedBy: MA5PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::12) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DB9PR04MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 852a6dc7-9aec-4fc0-6132-08df2aac7861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|19092799006|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BhXDlCe4l3opJ44a/xasHKf42/anO+ZbImVSW31p72MT8pT47HwRF0an9tD5Q/EAqeacev7IqEdDUnSUYuW+pkw3JKqYxo+Sp/VBEVgNFOqmroZCJ+RuzBqv+yOasLsKHQotGjOUgEILfe5ZW/UXuN1u6h9uUqAdMMUXrQAOEdMDQOmqfbwuJF3Z/Hnmi5D7p05GlgGTAmyRs+CJZ4UtR/Z+FKkNtq2bliNPp4OnpeS6L6Xwutv7x4ZmQiKlrgDQoTZJxSyUVYLwwUEcX4Pf3dVApbnC2HAvJRFg1cC7Rzkpb74mQ5H7xF5ckwDSCrMyly+0ky9+uvFPbwNe5rlr3h2k04sNSyJTs4U/ZEfa05CGIBwYJR3PRRPb30XZdZ7OCAqxKUEmE8YKESbsuMnqgopNV+COMv55hvbngXWRfurUk5UriQ25qlg4bPU5ZkLnnCkfYHIk5Exx5+z2FXkA70ry+pBgqlLWqQDNrR3g4kc2uHEKKLTL2N1MAu4sNjhz3NS/LIFAoA4rhPUNOgYElA+zGVMBhTtFEesCkLnSSOQxi48LNYDJ3GEw0/t6SE/W5BYLCLSgRF86nqhojui2dSxjvsfrWj0Yke+J/8YivNx1svFa1t67z5KplTk2yWhXHqa3zUym6uNVKpxc7eiB+U39GtuHBHcx1hiq1tO+1tI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(19092799006)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Auj3d3H0btHlfo1NO2p1NovW03eRsy3XV3+AprRSM05ZHnhwdBtB8SwS0J/Z?=
 =?us-ascii?Q?z602qyE6NGvk+eiCTaUySlBXs8RJIGB5toTQKITwRUWD4QbRI3ww8UphwkkS?=
 =?us-ascii?Q?iJUPlBx5eKAbL/3Kimf6qYfccxuyFisOR+Hc637C31yaNIKUaYmZRnsm/4yW?=
 =?us-ascii?Q?kg2TEGsfWGwGUne+uTuD/u/WfNMRarytCMfKNF9bdQlVkuyDoadJvSeNL4mD?=
 =?us-ascii?Q?lYWa/cn/1OMeWRgN19+5ggbfS0bRTz6BKloKecvxZno6+f5ZpQ2TtCun9+1Q?=
 =?us-ascii?Q?47LWggsEGlFdNH61fNH2dl6X1Cn5gwTtJL55j6fI6DhJnpv2gGwzsWRVoH+S?=
 =?us-ascii?Q?ULWC1g1Z54vLWafFbz5iEUZY9C41DvS/Zv/aISQ9CAXjYLNDojJkE5+83VUM?=
 =?us-ascii?Q?vYJr2/MY3VqKnNB4jbbXX7oig/L7w5TLaRA2IiDneO+Y9xGhOgYW2YNkHbG0?=
 =?us-ascii?Q?qUaA3Gx/3COf6Z596AYjqqI0kADXzzOXqs6+kS01X3dR4FBCc4u0Bkt6fB9m?=
 =?us-ascii?Q?ac/mYQGl6azqZrJpWLHKQQT/fXsPcBBVuV38TK4PnIgDCX6cLdb9KR7B2P9Q?=
 =?us-ascii?Q?XWE8ikP0StERrm88DdC48IQIm04ecWqCanpQiheZRDZZmKo+sjXFOOckazVJ?=
 =?us-ascii?Q?fUc58wK+IxHr+Pq4Tt+wXiHziEC86uHzdnj2YDM3T4+HgS0Ag625x0AP4PrV?=
 =?us-ascii?Q?Y0nELGEAW/z+FdV6hwT16uy+KK3VaUTjy7o5oL//r3ZcQhk3aQV2r1rZLupy?=
 =?us-ascii?Q?LINla1cwJMcLYGSD7OBPxN5mS8nwKN2Smw1h0wpviCq43ActFD0pfhCAGXqh?=
 =?us-ascii?Q?32cO60MBKTtsZaJUrluz9NXasEuX1POHY0t5hRjNwb/NRTnq27l/EZ/H9R2r?=
 =?us-ascii?Q?yiBLRw5GD7/Lf4j7PANYGlvzuk8GjMMvqqo2KPt7r192prl6OIT66XkU3WyX?=
 =?us-ascii?Q?VJ9Fquk0E4+ymof4WRLoDjJ1oPzSjYqVZPNJ2bbEWC1f4ruz3nb4PI4h58YV?=
 =?us-ascii?Q?wV0Y/0iO5NN1rJP+l3lL04VM5+nrdFMKqEsJpzKVAa5hYpfAhAOaxy1nmga1?=
 =?us-ascii?Q?9gmVM6XMiZsmOLCXSjOvLyUhD/vFnOfRvbC/kMpjddKQ8vKByJdYwEH11uSJ?=
 =?us-ascii?Q?L8FDkOyBfrVewfLWw2zLv2rvpu/mfg1yorX4cqBPNqN78MUwMV+wBrMNoFwq?=
 =?us-ascii?Q?vSyQ8v8bX+uOEpIUM+zEgJWFkUCVYd/rh1NE0t8GVaOUVq3VbibRmPZqYBv3?=
 =?us-ascii?Q?6u60yqxLWR5zaFaV4WkDcElclvuvvjFcd8eFA6vb8FONxi5LWR1ctdZC9cje?=
 =?us-ascii?Q?v2ZRvxYJuDrESYd684S02f09P7uK1McgJKrfH73e3xmMGP1Ytm370mD8MWHy?=
 =?us-ascii?Q?9tyvacTAMpMEIv0y5/G9Kzh/euDlcUfha7bE762t/kmYxomoGv7iBInVzXP9?=
 =?us-ascii?Q?81b9U3fOzOn28Ed2ADfDeKiO4ss+FDjVnBRm2IeO+7fZDI0GTUSi8VLl+AQB?=
 =?us-ascii?Q?0aF2apw3MrthTI2qOTwUum7NgaujPZFmKQ7ON3cgAyyzrWDM5dxUTQVOtlZP?=
 =?us-ascii?Q?HHRWcVMon0AlRBF2LcIhrb0egfs0+BWzrZLUFPpbrNQLWwhjwp3Zmlwjh2iO?=
 =?us-ascii?Q?v4Vnzo8/4Z5LcJzVtj9QVX5Qtfd/V7Z8PGoBDE8ufXE8LqjKEvoE86dHAiZa?=
 =?us-ascii?Q?JfD1kSl110wMrnnuuu5rcgRIha/NeB76hkFZ5po+XBrVqoGS+vRbO34ilfFr?=
 =?us-ascii?Q?Pus530LKW4gul15aq4sPvSZRDNI8WlMkz+97OU8Q+wvM15HuiKND?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852a6dc7-9aec-4fc0-6132-08df2aac7861
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:07:15.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1cMTnej7ti3htVwIoTQ/hnYuhCqbAi1NwHKv6f9EXA8Hn138wVhCcFG4zcZv0P8nd+LZghg+Miox82h/cF1FphC1f6k8Xz98q23oYkv8ZY6slP1LFmcWsLuJMktttaX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9818

On Wed, Oct 14, 2026 at 03:43:48PM -0400, Frank.Li@oss.nxp.com wrote:
>From: Frank Li <Frank.Li@nxp.com>
>
>Replace is_dma_{copy,xor,pq}_aligned() calls with the new
>dmaengine_is_{copy,xor,pq}_aligned() helpers that take a struct
>dma_chan * instead of struct dma_device *. Also update the internal
>helpers dma_xor_aligned_offsets() and is_dma_pq_aligned_offs() to
>take struct dma_chan * accordingly.
>
>Also use dmaengine_get_max_xor() to get max_xor.
>
>Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>
