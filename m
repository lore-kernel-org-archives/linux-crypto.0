Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013011.outbound.protection.outlook.com [52.101.72.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA5F1A5B91;
	Wed, 28 May 2025 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443998; cv=fail; b=kOFqmqC0HX+9xZqNSUg8UPOJTpaMY1Q/52VUR/MTp2lpsrj6j3qw/3aZYZpkvV8RMj/nCB8ryFt+D+SyRZ3mWwDbEitYZXevZqbUk7LAwvmJ2TQtOsZO7Y7msqbJGn9ERphUGE+8Xc1+DhfrdyhcRXudpZ9dY03KAsZ0R3nt0ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443998; c=relaxed/simple;
	bh=hLDMip9V6PbsIHoAIUo7Gt/Pxz03Lr+N/DhvY5iJuis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U3gdQvbSyA+65jCn0v6u42X4+donESEGGtBDloj9qNuJp9Xx8pf+fGub6ydrjwVcHogdKZdF7AVPzQZZvJ4Zoj2IxQjkLYthlhxelAqGlq8n22bS30GZcfUlHkm0SY8zDmmrPTBHJniHrWS//EcOH40SsL9m6rB6/5/z7gcWFbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=Cm+PPFKu; arc=fail smtp.client-ip=52.101.72.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="Cm+PPFKu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xP6HBerSHDozpOEDjxVsQPFr0x+cAVqv8XyTKXex02OfHNXNzw5zG0/eCihJ1nvHEM2JKBrRlXNJS605t6bcYNkAXElC9I40Klw+qnfRoegn0z8qfSbY3pJQt16GjcyjIbAi11XhUg0jQPn/l8jzS8UnuX3aoDW0URIthZQMAbUdx9usR9VQFj2k1QtpIEYhbNBx/nYq5AEkOFvIAEriO3NlGBF18K1BIh92kW/RXE6/DFe8e6LuTxDazQdjXSyTXSv/EI0/XxcA6jUbG6O1K3SttGt4ACXBVvFbwe7E9cyjaKfAdtLpxhRp5oQ1vNnkx1zuPQMtrSUeWXsdZpD2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MupEJWREZvbcHKp7jpQ8OBtDeqAIcIZP+PK/a2E6OqU=;
 b=PWgdpOQV3/dovWYo7mJ/IT15nVTmZJ4j2jhvl5XusAZSMGEYfAwLFpQxYJd3U4rAn68tuvQrn4KlK9Losg52HHfYL+eYi18BK4BrxgLS5ZQ2RLyKzMELIxFjFiSItTNohRVAJk1yymSEOrKOyONjflr7sVdqWgAiCoOeMuvfob2+UpkTEqrqNBw8ZxILk5LIbW8hgt/tKodqQQS36xQHc15mFnzHt+slBq9n5M3hzJeK2VlTIiEGDDXQwUzhD3aQDd36clU3021jkS+IOFJAXAHL3rkC3AdyD8jpufSQRnoXTb5nyPa7Syhtc1tQ3Cxx6I1ncCs8wp/pGPLFz8ELug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MupEJWREZvbcHKp7jpQ8OBtDeqAIcIZP+PK/a2E6OqU=;
 b=Cm+PPFKuLChrz1sRyCH6HokoHDMVcOCoqFy89aljaw5lfqwVSMCTIC8KJo4rY/zEZKevdwByTW+Y8Pz9fnCRYM6qmWI1axrk4/jUEQi89n7oW7/QP93Y2uIXmd7SWOxtTMFD3XxrfbiaxggohT6I72LK7xfsxRobp6R2TXebV88V3l+kN91hX9/qUfjlatKO07fwJJONRKtUcIJt5TYu2w72OSIEz1N8++ww3gcF80M+VKPSkbvsr+A87iVCqzR98zOMl8WHcteXAVcArBhYKBnSlf8vD2zeevSUObNlJ3rkaWuhuW4UVecVn/YtQHznSql/Tv1uGa2HnUKCPwGSQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by DB9PR04MB9282.eurprd04.prod.outlook.com (2603:10a6:10:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 28 May
 2025 14:53:12 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Wed, 28 May 2025
 14:53:11 +0000
Date: Wed, 28 May 2025 10:52:59 -0400
From: Frank Li <Frank.li@nxp.com>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v3 1/4] crypto: caam - Prevent crash on suspend with
 iMX8QM / iMX8ULP
Message-ID: <aDcjS+3ing1W81QY@lizhi-Precision-Tower-5810>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-2-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528144259.2603914-2-john.ernberg@actia.se>
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|DB9PR04MB9282:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b993a7a-d818-4c1f-5ca9-08dd9df75dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EiAgRc3wy3psKXSaTNSVqo4bWMdk//qq9hISV9OwKVmcz8MQQVyBPAwgMIik?=
 =?us-ascii?Q?UeQs0aMuxvrS/1575VcEIaLRpVhMNRf7QJhORybkyL55EMnC8QJ3BujdsRtg?=
 =?us-ascii?Q?lxby8KP4jHKpC2Icwg2GkQXqcEd/PHv8YZPk/p8fWNSEoc77AGeVtEleZC6m?=
 =?us-ascii?Q?IHexlHhHpC8AyXZ0NqyqIbKtHLqx20fVzdeDaaPLndf94AQ/nxn11RZPdiLY?=
 =?us-ascii?Q?5nOt+lKc4YzvzuLZghMK/53/Wzat66PPifUp1DBalRmsk6extXaNCvC663UZ?=
 =?us-ascii?Q?Hcc7r3VQH+YzsjxLCwQJJVU7FIbPValvdZRhq3YTTJNv/X9RemksGWZb0NVB?=
 =?us-ascii?Q?YQ3FArOZrYq12Fgrr1wlAG528ss2XEMy9PHzfs1bIkITpIytdetisrTovt3g?=
 =?us-ascii?Q?XquhD1mjaSOdOkyk4Pr7w4b+PhBlJu9BeNJRw81v+bQ2Xx0If6Oo6u7lPJ2O?=
 =?us-ascii?Q?5dnlvUBmUVkqcca6QYNomX5gkFLhnfBb1+nMTREZkM8IcSrQJpI7i3GjaBrx?=
 =?us-ascii?Q?4ZEZnONMWh70VyvgcHBqthgeydegMHXjeBLZKWAF02GJSh5c48BARcakLHGb?=
 =?us-ascii?Q?+cvE8Pn122YbbG9EnNNNvrmhr4w11oCV3vCnKjTBacqbevtqcJRYHBEQV/up?=
 =?us-ascii?Q?W/IwrOWBwwwSjRTDoLbsR71EwM1s54bfgQYNnnmMPoFWdlng4j8p0v+TP1np?=
 =?us-ascii?Q?NaBgRuFP234SgeJypBBpPqwOWBa32iuCMwBdhN0QrHr2CCmhQoNg0a8WeJk/?=
 =?us-ascii?Q?njWrFdq7GfFXdqjdrivraJj/Xyu/enBqd/8iP82RsAuh83HcPKjEldBZZExB?=
 =?us-ascii?Q?6xCov1Hgbw8PNsXvV+Lt8Q5EJsvE6pMHqMzvoDVCxlt8T9IvvhNIlDGLsigD?=
 =?us-ascii?Q?7BMstqqJbda+ILmSFSzLfzh3te6Yt4xXg0yVklq0v3qT3JaC3Uv9LV6iYYYt?=
 =?us-ascii?Q?tzpRBjMh0q8ZiPHZLzHtSjzwCXCHZdnSLVoXKbmql6nNkUziCxlwKN8dZbgu?=
 =?us-ascii?Q?9XHaJNAnDV138SMvZtvLzjTB8q8SPZ0ojdhqZLXHflU3Lnv7wu1BmFVSKmbU?=
 =?us-ascii?Q?iH/GYyELlkLGGigOGDkgc6f6U/0hYnbcs3HhKfOc/ud1nYtTQAmtTWn8MShg?=
 =?us-ascii?Q?IXqENZG6LsEc8pNeiSnkO5GSplv2RWjNEiOihw+9IaumMRgSMOMSh7kPrvUu?=
 =?us-ascii?Q?Y7P7d3Mx4B8iYtpqxubDqlVKpa4TgpCQLdqI0mIxtVND/7G1ObiKHepIPpk6?=
 =?us-ascii?Q?4anFxU89l6c3V0k2QO9a+qzvzUf2XzOvMQcFavh4OkhtB1HlxKYXowHkZ9/8?=
 =?us-ascii?Q?Oyqha6HBNCeD/afS5VhaPeze9j1H4HnN0KQT6oeoPr20jf9T163ymILoUd4J?=
 =?us-ascii?Q?fxkxc0rh7d2qBQxZctYYRhNQPJcKeDPM9s6JKJmYnsxD6evMkFTuEhwiOZw9?=
 =?us-ascii?Q?v6pTPKgUjSGdJ4FJrw52dmtiwsoUW1GT3vbDHh4wYf0O5T0bFZhlicjEJEJ9?=
 =?us-ascii?Q?5riA4w4Oq1e7jlM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?puOXVFwSvwUc5IjvaAKlxzki+sL7lVU8N8gI3zBJReDl0ldRvx/NtBLWgJd+?=
 =?us-ascii?Q?yWEqkqXeXe2M8fSJPAZ+WixHU5wKCd/YTXI1DaEU/9/+YYBWH2MdQ1kP7pzi?=
 =?us-ascii?Q?IvkDh23pKKvq0n3amO+6FqS4nnmOfcdU5Jvi86BKsYtE4TG/yW8VXKU4vbqo?=
 =?us-ascii?Q?A8Z3SK9aut37PiUbcFn9kr11aUYeh+akqI49GuZOSmdpCvOagZbiE8LPJFfS?=
 =?us-ascii?Q?ZGATD4yJFW2KI5QBfIKePagqDj17kTeeBPKjZHx9nCg0gG1QDHo7LV3xzLO6?=
 =?us-ascii?Q?Dgs/kXS5Dn1kZHZxA6SRqe0L4z04qo8Lp008CqcbLR1mzsENqRkQNKO3Vfb2?=
 =?us-ascii?Q?MViSuHpUUoCOe4r6LhSOfj/gDjovNFITEW2C7AYXYu61/gsw0wJhm+COXMOz?=
 =?us-ascii?Q?u4otZB0ZlGSqs47yN4XXyxWcFkkE1ZYj2HRWoCZSDYvJ75k8xwYmEhnoaMot?=
 =?us-ascii?Q?KiLYTalgysknScOZtxs13mfczUKal/fN4dGIZtnuqudHcOwmnKkWoZ+0VbB7?=
 =?us-ascii?Q?e7jJtNpxCHicmFzVGKo8bZwlVN6R0cwBdkbPSuJ52yQ3K5QOwCn3rynjnwlq?=
 =?us-ascii?Q?qIQb1l46pSAKzVGt1vrGWbBsAxcoU3ch5QVjQ+l1IdsCMsvMG51a0asOYoji?=
 =?us-ascii?Q?e7RuNsCc4Iiygf3qXPrlrSrzxlv5i1NN/evvVZeqQDGxUU7W5/jRD4r5v46p?=
 =?us-ascii?Q?Xerb6jLxBkjEAEAjQskeV9/eU40R7h8+BKYc+dP5lOW8KoRxf2uLQMI/yFss?=
 =?us-ascii?Q?IwFHRKZZeTypz4ferZQsUd0FHYZC0JBjoeXkQmXCyikUYmfPm4lUazPCHrlD?=
 =?us-ascii?Q?PHDHeFq6Rl9/3lnKQ4vQbpKTera+nVCNTXfp9o7+cGSfr3bfsPm4M/GgmnbF?=
 =?us-ascii?Q?BnLtEYjqHqVt6IBlaBJqHvIMTvzQdIAERqVa8+gccfjTKLG2ivTB4PpBGWSx?=
 =?us-ascii?Q?mHozmNq0TWHEJ8N1A68B1RtHzmrJGs9yMIoYJ9eBqQWxGAwUWiu38kI88cG7?=
 =?us-ascii?Q?HvtGq9pqSm6Rt0MC2wspoT8JGmatjOwfAf5U6wf5JyLFo6KIiRUrLcf5O2aF?=
 =?us-ascii?Q?ZAk0zGftdyVYr3dQzHo7NhIgflqv1UaSrNPzhHH/1VeKjHYPX4RRtadw2KKe?=
 =?us-ascii?Q?F090yKuQl7RDZgkr0T3WvX3U2fgnqFDCuhRAxDhPCui1SGv/1moMIk10+ZZ2?=
 =?us-ascii?Q?sHHv2RTkvVKFBTDGRi5EKnaWImXc01PmI/lBtXHK307r2rAyZaUaWNHRZ3mE?=
 =?us-ascii?Q?bCXoVhZpGaCGvOowD8yqENNhiJ2TDa/DpuuKt2xk/fhx3ULp0OBbXwVQvFxH?=
 =?us-ascii?Q?wgPgOYTrk2k7Od/iNiU8+PUmnJsfr3cd0ZSZz+mgedVpzd6wzmt+ZSNTxHLW?=
 =?us-ascii?Q?VYjK0zTE+G9+2WPMPofp8cEXKT5pilIUDBT6SWOSH8hMiUXzpJDBE0A0edW6?=
 =?us-ascii?Q?8UMleJsEVb9+jhWg5VJsKKCwqyYSEvwdUYzFIsV1PfVOG+2mUZpIyAvVHFr8?=
 =?us-ascii?Q?KK9qqN5cck6jmCwmPR81dU7kIR1FnrHLLjJYYre53Gn1Zn17tWzw7pyL9ggf?=
 =?us-ascii?Q?Ak5Q/cwl3LDgPy7zmEHiurk5pY+Kq9fJ143P7Pms?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b993a7a-d818-4c1f-5ca9-08dd9df75dd9
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 14:53:11.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iXKeO6+fSLsJ1YGzi7buNoujaGlNN+04VGNwR4DrZx/8DBRGTwlzYRm/emrvzQrgRCQSOsPnBQFAnzLnxLOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9282

On Wed, May 28, 2025 at 02:43:07PM +0000, John Ernberg wrote:
> Since the CAAM on these SoCs is managed by another ARM core, called the
> SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, which
> also reserves access to register page 0 suspend operations cannot touch
> this page.
>
> This is similar to when running OPTEE, where OPTEE will reserve page 0.
>
> Track this situation using a new state variable no_page0, reflecting if
> page 0 is reserved elsewhere, either by other management cores in SoC or
> by OPTEE.
>
> Replace the optee_en check in suspend/resume with the new check.
>
> optee_en cannot go away as it's needed elsewhere to gate OPTEE specific
> situations.
>
> Fixes the following splat at suspend:
>
>     Internal error: synchronous external abort: 0000000096000010 [#1] SMP
>     Hardware name: Freescale i.MX8QXP ACU6C (DT)
>     pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>     pc : readl+0x0/0x18
>     lr : rd_reg32+0x18/0x3c
>     sp : ffffffc08192ba20
>     x29: ffffffc08192ba20 x28: ffffff8025190000 x27: 0000000000000000
>     x26: ffffffc0808ae808 x25: ffffffc080922338 x24: ffffff8020e89090
>     x23: 0000000000000000 x22: ffffffc080922000 x21: ffffff8020e89010
>     x20: ffffffc080387ef8 x19: ffffff8020e89010 x18: 000000005d8000d5
>     x17: 0000000030f35963 x16: 000000008f785f3f x15: 000000003b8ef57c
>     x14: 00000000c418aef8 x13: 00000000f5fea526 x12: 0000000000000001
>     x11: 0000000000000002 x10: 0000000000000001 x9 : 0000000000000000
>     x8 : ffffff8025190870 x7 : ffffff8021726880 x6 : 0000000000000002
>     x5 : ffffff80217268f0 x4 : ffffff8021726880 x3 : ffffffc081200000
>     x2 : 0000000000000001 x1 : ffffff8020e89010 x0 : ffffffc081200004
>     Call trace:
>      readl+0x0/0x18
>      caam_ctrl_suspend+0x30/0xdc
>      dpm_run_callback.constprop.0+0x24/0x5c
>      device_suspend+0x170/0x2e8
>      dpm_suspend+0xa0/0x104
>      dpm_suspend_start+0x48/0x50
>      suspend_devices_and_enter+0x7c/0x45c
>      pm_suspend+0x148/0x160
>      state_store+0xb4/0xf8
>      kobj_attr_store+0x14/0x24
>      sysfs_kf_write+0x38/0x48
>      kernfs_fop_write_iter+0xb4/0x178
>      vfs_write+0x118/0x178
>      ksys_write+0x6c/0xd0
>      __arm64_sys_write+0x14/0x1c
>      invoke_syscall.constprop.0+0x64/0xb0
>      do_el0_svc+0x90/0xb0
>      el0_svc+0x18/0x44
>      el0t_64_sync_handler+0x88/0x124
>      el0t_64_sync+0x150/0x154
>     Code: 88dffc21 88dffc21 5ac00800 d65f03c0 (b9400000)
>
> Fixes: d2835701d93c ("crypto: caam - i.MX8ULP donot have CAAM page0 access")
> Fixes: 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")

Why need two fixes tags? It should be enough to keep oldest one.

Frank

> Cc: stable@kernel.org # v6.10+
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
>
> ---
>
> I noticed this when enabling the iMX8QXP support (next patch), hence the
> iMX8QXP backtrace, but the iMX8QM CAAM integration works exactly the same
> and according to the NXP tree [1] the iMX8ULP suffers the same issue.
>
> [1]: https://github.com/nxp-imx/linux-imx/commit/653712ffe52dd59f407af1b781ce318f3d9e17bb
>
> ---
>
> v3:
>  - no changes
>
> v2:
>  - Adjust commit message to make it clearer what is happening around no_page0 (Frank Li)
> ---
>  drivers/crypto/caam/ctrl.c   | 5 +++--
>  drivers/crypto/caam/intern.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 38ff931059b4..766c447c9cfb 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -831,7 +831,7 @@ static int caam_ctrl_suspend(struct device *dev)
>  {
>  	const struct caam_drv_private *ctrlpriv = dev_get_drvdata(dev);
>
> -	if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en)
> +	if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0)
>  		caam_state_save(dev);
>
>  	return 0;
> @@ -842,7 +842,7 @@ static int caam_ctrl_resume(struct device *dev)
>  	struct caam_drv_private *ctrlpriv = dev_get_drvdata(dev);
>  	int ret = 0;
>
> -	if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en) {
> +	if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0) {
>  		caam_state_restore(dev);
>
>  		/* HW and rng will be reset so deinstantiation can be removed */
> @@ -908,6 +908,7 @@ static int caam_probe(struct platform_device *pdev)
>
>  		imx_soc_data = imx_soc_match->data;
>  		reg_access = reg_access && imx_soc_data->page0_access;
> +		ctrlpriv->no_page0 = !reg_access;
>  		/*
>  		 * CAAM clocks cannot be controlled from kernel.
>  		 */
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index e51320150872..51c90d17a40d 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -115,6 +115,7 @@ struct caam_drv_private {
>  	u8 blob_present;	/* Nonzero if BLOB support present in device */
>  	u8 mc_en;		/* Nonzero if MC f/w is active */
>  	u8 optee_en;		/* Nonzero if OP-TEE f/w is active */
> +	u8 no_page0;		/* Nonzero if register page 0 is not controlled by Linux */
>  	bool pr_support;        /* RNG prediction resistance available */
>  	int secvio_irq;		/* Security violation interrupt number */
>  	int virt_en;		/* Virtualization enabled in CAAM */
> --
> 2.49.0
