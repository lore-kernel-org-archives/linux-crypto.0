Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11012053.outbound.protection.outlook.com [52.101.71.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF562DCC07;
	Fri, 23 May 2025 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748008418; cv=fail; b=Ug9Qpk4pKreNysBZ7wo8nuhPzVSOKwn3SS5i/IjixQceeINYrlKnVyL9XoqSyH+b0A+6ekXM/O+JFZESPoagd0+Na4TIsg8LjQfzGeGnrQrY4Rl/OrxciUgsDQUFrVuNOxTqYpbYMNGuB4oAGUi9NvzGYa6L/5uWbMbpHfZwGt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748008418; c=relaxed/simple;
	bh=F6JXcSi2D16i3FEL+EkM8aHdfilRKdsIOAGi5eRGNoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=So6aP8uSd37HgzihI+bqTU3h2mxK8Kzdai5pbCxQLIlBvMF2HmC22SB+W2ZL0noVB43yMiU1axwPJ5M2nsw8e6DU4bqYR0bnCP2Cj5yeTbt7mkZ7N6Jux6aYY8SIxxXoW+iHeGcfKAzzEHt3fNbmu8tSzg38egdBhqFu1MCg9Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=hcovCrEi; arc=fail smtp.client-ip=52.101.71.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="hcovCrEi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v57OzWaieJ4FK1vzLz8L25a9tHH2ATVbMcznhvOmwayD8wdTlEuUaASwwWFWWsYynDY0MceAiPLS1Zh4nbMpgBvFyFEo2q1Eu1wTR2BRPBfJS1IR15nspMJgXmDtdk/DRLOSZlFHLJvqGOFJJKG2wufevqIaBzVUucoIFtVdxaufMPeqomj1gGIjno8fEZ66zGd2iUyniGlmr4NU7UIKeNbXdenAQ8ihJ14Zg3S5EVZKcL/SU0Lf/tUD7XHxRJYlWnJ7XjYkRRKdpKCo2qZYEhIF8Zg0eZuAQ+/mVhNMLl0aMysyh3PVxYjY4imbDqLVtq/ClNoS/Kf3IbZDF2wp2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+dGRT7Sjg4Ud4SjDnsM54RjAUjKrfhouc3iLiG7soo=;
 b=FnLkjv2CsmRjGbApTFCZEreeh9Brg6n+iYrsCENoA7uLA4DQUtj2+zCt/gZhtDg01Nw6iVyEdW+h+en/PQcNz6rLOR+4UVLwyrnp9VtSECMZeJjrfbJsczXgdwRnYiILKIZRNt40O5pucU+bJnu2IwQzNfMqvWvdKyAwzWvXwPabt2GyCYVsxDjK5LDT/vb4RqENmAKMaSCk+rKrAy1SCdH67/Q1KSnfkO9bLLRsJhhLg9zl361s2njgXxe6qns4l7Q6lricRqpmKD6v9FuaS/r+wORw/EJp88qdEmE85xT1BW7FivztwIcWGXYy6UiM+JZQUGaeJcLRGXyfYo+VmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+dGRT7Sjg4Ud4SjDnsM54RjAUjKrfhouc3iLiG7soo=;
 b=hcovCrEikxGv2WXxv3iwWVZMBOT0GkS2lSWxwclmKbFeK/hVVBCjYO7nUmYLBsRKuTIDZj8W5eAcoXHKyBA4J9XPacuOM2VLgH40ejoKbHXxU4no5NpD3HUdyJt4AQ9LGl6Il0t08tdlVSiaI7oWqbw106oZbmKmELKDL/ly1F9xNhS2TcW0yfCpdlIpnSuHHTp37VHx1l9XnuvJgKSGM6E53ailif6jbpV4+P5kQYkGbHeFueD4HxzVevfQJ5MLTS8E+z3aebtxWI7VkgLk7YYdHsprjzrvwbOJTkbJ1zllayIxlTE9l4HvccyO1fP+JEv9AdnzCxnQRFb8dTdZOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by GVXPR04MB9949.eurprd04.prod.outlook.com (2603:10a6:150:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Fri, 23 May
 2025 13:53:32 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 13:53:32 +0000
Date: Fri, 23 May 2025 09:53:23 -0400
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
Subject: Re: [PATCH 1/4] crypto: caam - Prevent crash on suspend with iMX8QM
 / iMX8ULP
Message-ID: <aDB909HDzfUaA3hv@lizhi-Precision-Tower-5810>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
 <20250523131814.1047662-2-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523131814.1047662-2-john.ernberg@actia.se>
X-ClientProxiedBy: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|GVXPR04MB9949:EE_
X-MS-Office365-Filtering-Correlation-Id: df097a1c-c2a2-421d-dde8-08dd9a01347d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7oKf5dNkfyWcCFDWqB4tcZKWizyVsD+Z/O9i0kU4gGn6gbM8m44RQZvbuzJA?=
 =?us-ascii?Q?+qt3LAemttJVwGyFl9C/aGRr8m3jEzdfXNsDTx98KK4lyoMi3iNvyXPhkDaT?=
 =?us-ascii?Q?N7pkFIgrZs0zYHJo0xqr2LEHwz9PCHk0tLo9MLX7IcV9Z2VjmbN7ivdx/mfK?=
 =?us-ascii?Q?0e/yveESnkYoDxCFinbsAAGkN8RMA0rNJDuZaVthZgL5SdxMOfNqL220keva?=
 =?us-ascii?Q?65U/82FIzdGS5CT91l/c8WOKCWCyRiAJANB4SJ0UvuPvmJp8FHOsyrTe8F3D?=
 =?us-ascii?Q?DqDKExN5UrEELK63znlL+8VoQY5Wh4muSxLThiA6ezLTjMphWC/hsH3YmMJ1?=
 =?us-ascii?Q?UFKj0OepwLzPkDzhZTDCIy8O+CSMdnV3wvwcKAiosL3FTmWVUXWhJPT3l2t+?=
 =?us-ascii?Q?O8yndLdbBDWc8G/afJuK/jAJ8pK8Y2Ua3sku+PZP5Ap7OEk9OGdGnUBTSHkQ?=
 =?us-ascii?Q?SKvGnk4Q2FTWVKUvAevItaYq/aT/rO4BUBhQxQ28BOQ2G6nEEMIGP5zBDfag?=
 =?us-ascii?Q?xLn6a4FG+3tt+ZjnNQ+2CAdbu81AAN3ZEpqUtG2TIhRzddwE5DmnuaBCGVz8?=
 =?us-ascii?Q?nzllDZYPHJTB1StisEalB3U0xitnVuOU7uxEyKxmYQh76ZWEKZ70g8RjEqg7?=
 =?us-ascii?Q?MjCdox56jM7riqzM6v3Ic08kZokY7Jd24JUsYqJY0Btd9PqPsWKDvZv35aLT?=
 =?us-ascii?Q?fdNSd1gr3GyrkJoBsdPbtec0vp4hY2KKscExa76OWrdxUInkJUZV1n7Opj+a?=
 =?us-ascii?Q?+sl57xOlmYpwiOjrz6eYak7vlIT50jFJaVEY9C1MeHC9w9Ol6oY9qMieNg3g?=
 =?us-ascii?Q?qAhSABzPFz6B02GPEEFQaIC9hC5nHwuMLWmG/35glBvGalXDs2V8c+oEH0Pu?=
 =?us-ascii?Q?pje0a2gtE62HqUpvAqjD+AXjBXi+TFR90MsvdG6ZZ9lfqOqBH8ExnwrMBYoZ?=
 =?us-ascii?Q?Uu4YmX70mg1ZuTd3SzIP9BkqISRYYR1l1brjR0GoCDU2GDj4hOo8B1t4+VgK?=
 =?us-ascii?Q?DfoL9YvBRAq8wF2gy4xMmTxes2Eo0RHZZRk+BVBWtyLjDjUuuTwtDaW68Fom?=
 =?us-ascii?Q?T3S2gWxBm6zOkLVRWGL7Ob7V8zIpzMwZ66NgMesio5JErB80GYk/pYWYXPHz?=
 =?us-ascii?Q?OLoVTUP7N+Apsu065EyNlwPd9lGefCijwtkDzhUgMf5xg5D8WUztkX4fNAJz?=
 =?us-ascii?Q?IsLp55wV82QoM2v/njHsKHwdMJHoJ6q1Pyemw6G7di3ZrhP0DUjCADkLitwy?=
 =?us-ascii?Q?jx8Gd9KHaHFNZSnOd0UtjuyKmXHQQD3MHcB7bu4LuiVLiciq9WL64OKM829m?=
 =?us-ascii?Q?uslES951iCJnWpUdEMXKa10869eRF1i4/YDOsZvElt7wc9QpgpkjROaC0vML?=
 =?us-ascii?Q?gXSiZ0JHqnYiLJK1f//EVGh7pQu2Tz9ZFdXpavHKNTsUq8oh+LEKkDAIOZwv?=
 =?us-ascii?Q?kHflbMP2X74j1geI0+gh/4fe++z1FlLvQYwulWaM2Aja5h7JysPDpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LiTqb017/GP9Yd9x8JNCor7jAwD68E8QSR1G4GfY958fpuV6N1d9Ilgs7soT?=
 =?us-ascii?Q?pOiv3Ij+W4tF9ZA3hBDm/vE8Gt2/L7MlEN3lnQ8V6AWAW4UK0BWPS/WdYzFx?=
 =?us-ascii?Q?fJrfVwRRkBpVmaQhUIhqVQ8ek7BmJ7FzoOBJ7XQvgaKkwmdOqgN2EybYFLNq?=
 =?us-ascii?Q?6pvMgELPbZXUmc5+NvrQiXjhTci4o46ukDkRsvniTsuXRRRI6Des9CwIBAFq?=
 =?us-ascii?Q?rYPag8NSAREIXDnnx+eKDLdAt7HdkN1MMX3j/+vtcHueLOyiLI+OGQ3n64Es?=
 =?us-ascii?Q?CJ0pDAR/bUS1MzhrolKgnyik627b/3+h8zkRpOycI9OdZEPZw89sbajoUcv3?=
 =?us-ascii?Q?tIpmdL3NS2wxnnDCC/19FmwYk+V/vZe0pgG4147Z6PVV0ie6CFQos6kxhMpf?=
 =?us-ascii?Q?1M6AQXPuRp3EiQYrc74u/mXL2jBBp+jfeRn+SEZyYpkrK6jmWuGQl9OIaTky?=
 =?us-ascii?Q?cCDYjq9AI3xMXsSuYsRL4XEhPd7cCXNGHUYHKI4I/W9Olhvgr1v0d7TkIr96?=
 =?us-ascii?Q?HSRIutcUwYk3GSrq3Kn4RB1v4fHgYhFriArCRKrwFEmJbK047DN2mGXOuWib?=
 =?us-ascii?Q?/I8XLqMmXRJsAY8ZSVX3kCzOt9FFg0yuTZgK6cBtlYMbsl7DTT3aygNe2BTc?=
 =?us-ascii?Q?OwdhcnaRa7amTD6AVcYwIDDfGMbbBVdVQZ7gPIKVq3rTovg/WqWwDgSKbwfr?=
 =?us-ascii?Q?PYRWnCBo3jzXpql2KQFfv47BCIPWTuoxrE9/Xj+E4tQkcVBK6hBxETQ2dAql?=
 =?us-ascii?Q?+fkKHpN9+dkgMGi+J9FC4dWP+e/X+kVHVNKrRhpOdr7O8govoPpdMDvrd+j5?=
 =?us-ascii?Q?QtPbVyTCw/5jBDSkf3ayfGEKKHigGuEhyESypgOZ2wZr5A0mzkhWpDxZSr3N?=
 =?us-ascii?Q?59YhPjzqp1gXBUlMS1ZktOgpKoe1x0wxQmil2HyBma+C/GokincL5XhbrIQ0?=
 =?us-ascii?Q?Nn3AE3aJ0mW1pla4oLx+PxhINCL/6Pg+k2sR4PitVoOigWTZba35ktcThoZJ?=
 =?us-ascii?Q?vdAnoTW0HC6/9cPNSbRpZ5eleUYI2XXuJLfeRUAfxNCHJcuJ5kRdicBt0MrN?=
 =?us-ascii?Q?rnWbvY4M83LxrCio7Iwc3EN6+vJ+HpgbB4AXZKJGukJMtklIiKtwCRe5uOSo?=
 =?us-ascii?Q?he0lTevkJPffxjRrXCpFSt+0aLMQLfRr/ULJFJtDfwXOduzmebiD+5mW+cpB?=
 =?us-ascii?Q?DGvZ96TlH9pPPZiWTbVNFuppxaBl5McWnNI/aTHe+Y+NTtYYIOM5mR/KG61G?=
 =?us-ascii?Q?PrYGGG2CWVGRTfr0dy8Oi1Oj9f5DGilwgIZNkH5xl1PYSc87YMoE1WpuLJM8?=
 =?us-ascii?Q?nGm6eg7gOlaVZUUeRzWaOsyep0KsfWjfBjmAQO3/Nev/P9QZgnzUn0RAR87E?=
 =?us-ascii?Q?Alba/a0oS1D/E0wJBcRVhLCn7NfXkIuJUvz5ZyVi0Hw1jBuzK/4WJrdweSCq?=
 =?us-ascii?Q?10Nbe3QbVVZE/RWLHXY+Dx9YQM932y2Z7BUz3x2uakSuUJFgX0AO4yfDJPUW?=
 =?us-ascii?Q?i/h5RHm93YfvE+PdYATj8GfAIFASkcDbbH/OO1emCzx6HtRaVzkwG+h21Cs1?=
 =?us-ascii?Q?XrmMEEpgEX+W+HKb058=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df097a1c-c2a2-421d-dde8-08dd9a01347d
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 13:53:32.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erhOrY97vZwetQe7VD6h0qfosJmbMwAntEwn4w5+pU4+GgLpASZOMIWl2Z4cHYEauSJGCH7CoMofs6lUl2P4ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9949

On Fri, May 23, 2025 at 01:18:32PM +0000, John Ernberg wrote:
> Since the CAAM on these SoCs is managed by another ARM core, called the
> SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, which
> also reserves access to register page 0 suspend operations cannot touch
> this page.
>
> Introduce a variable to track this situation. Since this is synonymous
> with the optee case in suspend/resume the optee check is replaced with
> this new check.
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

If you want to use no_page0 to control if call caam_state_save(), you'd
better set ctrlpriv->no_page0 also after ctrlpriv->optee_en = !!np;

Frank

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
