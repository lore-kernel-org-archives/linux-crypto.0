Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E83A2957AD;
	Fri, 23 May 2025 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748011746; cv=fail; b=ZJMoGaKSpeLDRvgvZKkSajrMtZb4ftXlkn6P8IkQhcu3kxsGgbBoQ31kpNjStmgVK88P+tT+pYfLwfxdZPnZjhX5R5PVyTNXRFmZZ0xStOB2k0Vw0o3CQL86g6sFG+37+1+JgZR3IT8UcFsQO1kwBbem7yQPVYhEzkszgiRMpQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748011746; c=relaxed/simple;
	bh=UTlPSlM4RjvwdeRIbyHq1jJ8181gTbMRI1iUNyJYWy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RB93eRxMCF4uICLZTf7ZRy70ITrTbH/oIaTYguIMCxw22Ihv0K85OVoPN8sMq9F6xS/ZlYM7JaADwvrQIeKDTphFEH5G6puhnNHdFI7dTfWeO7axr2CEyABqDqAptQ7S11oDP4Mzq5tp3ayFhzFwikhiBFcanW/Q0GYGqWxi1ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=m87LjAt8; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="m87LjAt8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AELyHlR2qmxMc16htDYFN1l6aUTmWvMajsQjwarKkRrD+F2JlOqvvz2fpuU34zbNGJ7RvPWcVXopIA86bIqPxTWE2lYquPs3pl9QYvJpgfCopvz3nBv+Qzm6xQfx65GjsIK+K3rONvOO7kIIlGyVRgPoLzV2D6/5P1BkiHOnp0B8Rg8nysO6Eco4C4SKeGRhm6W4QyZgqPq5CSUAz2XcVvGNCZmqIjqlSw23fmkIYLNpcguMsJr72aDwKSJ2fe8bNlXpgelqw97uWgPeaA2SCAWYiqHQ50bM3iWPwyk+zKNgQ8yxh96hz3SU0MEV8+hWuuQfQbH5vmp3GrFEujoFKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ls2WvzjG2z46F+v86sR+RdYs2NvQzRVBdWbBalsazpU=;
 b=xoJszPopNb1P2T1zzYPArJWb+vxc6GEC/P9kZvGkVTDxcabfs7a/Mi/ZBH+ozzwm7gbWfk9tR5OzhOZGqcKAymflQOYG0nSGj7aznIuBq0AeFGiV2M84ylOqAN4mT0mKgPLIdSbda7SJtnBgio7WEezFfnaVpaQnNtqFKgDZYA9rnGLwF79Ieey0ElIv6DdfDLw+ZEMphabRGsiuOkFxlPF+n98im4sT6RD0gaI3GitxtJXYLWOEsxJbAv4eUyzirT13W6noUBmhEofotBR00tW00psBKGCadKalZPVLV2761DeTNigR4O679K1zSVBLMDXYLnFc6Y+KtkI524qlSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls2WvzjG2z46F+v86sR+RdYs2NvQzRVBdWbBalsazpU=;
 b=m87LjAt8qaTy8ZD5WUdALa/kOuJtq4LgDrkH10y4JAA3pS8rAzMmaqdHi+eJXby07V7iCfFf+giNQ8cyGrRS6HnfC4W7/seYhNXJq1vNgyImfnjpkUjywhA37XgZT3pVO+0KyjhM3ivolMr9IK1DwQxeQ4vHZCkLTRA1QnOiFTjtH2OmhZ/nQenHf8buzWfn1yYyR4W2+NXisVXc05UxUvdmOsB3Teg17OTednwGQDSxYDLmNaA6OkZ6X9dDXhAt5vbBBJiFYcpFz6BAvdFZbctveFXB4OpZ/L5gZPYFZTHGyJdEyGR2H/3JE6ZBscFVYB2jWcYqcgWbfyk/MyXlWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by DU4PR04MB10695.eurprd04.prod.outlook.com (2603:10a6:10:580::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Fri, 23 May
 2025 14:49:00 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%2]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 14:49:00 +0000
Date: Fri, 23 May 2025 10:48:51 -0400
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
Message-ID: <aDCK00bzc6RDKu5s@lizhi-Precision-Tower-5810>
References: <20250523131814.1047662-1-john.ernberg@actia.se>
 <20250523131814.1047662-2-john.ernberg@actia.se>
 <aDB909HDzfUaA3hv@lizhi-Precision-Tower-5810>
 <b62d6620-4c31-41e4-b510-130f0af66c79@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b62d6620-4c31-41e4-b510-130f0af66c79@actia.se>
X-ClientProxiedBy: BYAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::45) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|DU4PR04MB10695:EE_
X-MS-Office365-Filtering-Correlation-Id: 34fc6ace-5f89-4f35-98f0-08dd9a08f41c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CDbB14rvOisjiX+fw6PEuLlfTjRN/jzsdOKkK9/mXf+6mCC+1FkXfSc+bR7w?=
 =?us-ascii?Q?nHmfRml8Nu/vz5SejXjyT5xHggO/+RUaB46H+sn6TJInMXn9JFGmrCVQ8Kwn?=
 =?us-ascii?Q?W4Cxl2Mv8dWUysVYjbmUDLv/QTXmE6YJ7yQvpAwYTYD2VSrLmRsJdtmkLIQj?=
 =?us-ascii?Q?HKkmbRL8fW2wL4ES5aq2h1UTqz5tSTQkuDaHtyvPwAnLMJ7SopORs/lLJ1Ha?=
 =?us-ascii?Q?p6bCo7PBi258358y2X6b1QUhC4TCTUatqP6Wggqp6FLynwMTrwBHeVVUtc9B?=
 =?us-ascii?Q?nt9oC1FpRja0FG6X5FMA/dmk/sqtxwzrMAtHNi5N19P6xZ0QBOWr5xtuCtiU?=
 =?us-ascii?Q?27ji2tDIaqmwf5FbS0moMs4elgZr+w4L5ls7ZACFj6qXPvj3j1eZ5soqWLgg?=
 =?us-ascii?Q?An+pyXColrLS9Gqo250i7UmPc4u+5QTrt0oh+KXk0G1jdoJKFrTDq5hR63yk?=
 =?us-ascii?Q?qikgcukfCxglIMYyN83W0/iouu3EfAcqgZtNdFhseg+26J6RGyjL1+pZCHn4?=
 =?us-ascii?Q?3aMnAEcCvfaxfWmB+JIWFPOv4fR754L/HuVNa3iSo5uXFkfblxzkwnCRrJAL?=
 =?us-ascii?Q?zBNUrTDewPAvGyznOHEbpLCSVjR2QHZKuIWgm+sQsaZ8b7Q3C41rOiEKkZa/?=
 =?us-ascii?Q?gZrISP6uxiVC6Pvl6WIQ96rlGiTo4lzIlcZz7SQ9CPr5VnxnJrn4SPFigVK7?=
 =?us-ascii?Q?Z8HKDgTOLkTobfz8Hf34L3zWK8lL+tw4y7car8zG4BL7bROsRhpCidTPqxJl?=
 =?us-ascii?Q?O+MTOiIrb2rh1HTRapWzFcPbrDUwDxuSHGpMyFi4RkJ6ZSvIgT1YJ/fLqrpo?=
 =?us-ascii?Q?emXJczm7KGkaeZnU/zuXMINpT4TNatSZ+oCn2+I6dNTJK3GCm1u5HSk3y7MD?=
 =?us-ascii?Q?ct/hnp7mezs+ly/7rtuu4FcHzEisVSvWHCiNIemikBns9D5BeAMYd4HiZ1k2?=
 =?us-ascii?Q?ngGFBJd3STd/lRIaBDo9XTBII5Zf97QS3I68uLK7BZDwzVLfJNhP+28FXBBI?=
 =?us-ascii?Q?SpfJ+Wc8iwbGy44c7KnrmDKP4r8yVvhXfWKPkJ/d35w3N4OBVFf7+MgWH4xn?=
 =?us-ascii?Q?cdV8xXsj4c3H5kEIYg2SWSKJFslfKKOpa0fNcmHhuTA/qtKvaXmTHyUmNG5T?=
 =?us-ascii?Q?RwJ1dYB5WC+Fth7kJ2yBfsn+fojbp/w5em1Z2ViWttxwXeboSKj79wRtpU0Y?=
 =?us-ascii?Q?gZ9MkQ+qfY0NIudZlSPbfRh9HjxHAuri5JqGcUvUnwa50i4cuINCgcp48F5j?=
 =?us-ascii?Q?/dxnBBibmrAMiOm+w40GM7sOpu0fWOM5ooWZlWyODR0KYAJ8phhYA+bwqdtS?=
 =?us-ascii?Q?3FDlgeR9/QjHyhFQu7a5EvcBBPIhZQqRT0eEBa6TSeuSzejlilqoOhCnlKL/?=
 =?us-ascii?Q?gDHQAv0xsc5IwWu3Lotu5pv1rby/tPzbj47s8VppZGTLCXyNBk22BFx+XpSt?=
 =?us-ascii?Q?34UbWBjz5/QsXH/N8MEIHMdjc4CmxiJ7nFkS3cA3NYpz1U1CbtvazwAHOP6d?=
 =?us-ascii?Q?N2rvSwhSkHX+Jvw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hqjvoge+2vWTZvO0oVJqVPS1e6g2tokOaHH7PVB9Gsuk5+EiOszVGaK2dS6U?=
 =?us-ascii?Q?F3AcWNVq4RRD9KzYy2bDL88xcsw4tTh8sBPfTk6m/55khTSa21U2dZ1I6YAz?=
 =?us-ascii?Q?9H7//8fYNEVFDeYtPADJ88l4CD4eoC5S8Feo8PDV12wH1ql39p9y5EAm0GW6?=
 =?us-ascii?Q?+OUKkAtc2Q/H0R3r09wL/JSGOCxNrmxhwj/d72B4UdW+r3NyCNscILl39NLH?=
 =?us-ascii?Q?Fp9jMHO0v01Q5HUODdbXF67oolypO6BvUIsfDLlbUeN2ZkUXtsaSsa116AFQ?=
 =?us-ascii?Q?rwCANNHAOyw1xx7ZG1nIa+0Hvliirfrh2zEYmNMQ4JH9E5CbnSQqRc7vqglg?=
 =?us-ascii?Q?COndYUFErTrZlAUUJ+nQMfStUkzxOgur8yb14sK7LS+03jRiT0MlpFZGiY1u?=
 =?us-ascii?Q?D+L9Yz/1COucd7/C2LM6A+hMYC3IilJA3yT8A7XpNxowD83WiTFwwSff4Xsn?=
 =?us-ascii?Q?owEmHyxZsGZBeuZRqnyMgOTm31HvS6LXrLEw8cuRomDRLjUqwdbzsbSE/oT+?=
 =?us-ascii?Q?k6VL2MNM35dMV2/uFdzOj7YATI3KqnXAL3UUoD5wPa2/+ZOZbsQHCGAb716b?=
 =?us-ascii?Q?Tc3GYaU3JhEg8WP+MP2rvssm0qDdhcfeIDWRZZLnWr3zKq7pIfTBApdqFbns?=
 =?us-ascii?Q?cwJ5NSvHyzVlTzUMpAjiQOlCPUTbVRzCGELVV0GTV3nwHuXfgvDithqZpiE1?=
 =?us-ascii?Q?x1iBv4GxLYacPkI6eVAZbJx2UP3ipE0tCIFPWPdNlqUKWAxV4RdkraQyOYaS?=
 =?us-ascii?Q?eDjkzTmvUD4BuN88Grhtv0SUmD7CmBJuvgnVZIKAR+bClka9f/Ktjojg6395?=
 =?us-ascii?Q?3oFUmLG079GHiPp3WpS0paLamPsQeWr4Zop+K6Y8AHx0p5ij5yraYyg3q5Jm?=
 =?us-ascii?Q?f1U3M+6mYiJQ5YyXLmHo4zCIXKbH+iOWSSiJ6xaMAguF33WFsxM0oeRttmOp?=
 =?us-ascii?Q?4nk10C4+UNgdxs6UwZB7inRwnV2M7Dcr1IFNmrYjqHoP+izDdywNb2xLdVTc?=
 =?us-ascii?Q?sx+ggn26P8sHiVPSxEt53ULfd4z6lh6kEYMx1EXiYQ+idSvMLCKOh/yebJui?=
 =?us-ascii?Q?LCjy/xm0CLVv2ZKSnnXqIMwwqm+wpTJ5LNTVwaBaV6f8KLfbsj1VzXfdAwTt?=
 =?us-ascii?Q?fS2KfYpAkkHR8NVV5BxPD2CE11L5oVHU4SGHB30VquRAAB+nZXWEkBdp+t4Z?=
 =?us-ascii?Q?r1Yxhem9E4ZX2SC1HtRb4bhG3QatJXHJjsi9EZpXHeCJK5HNi8kSpg+ZxmuN?=
 =?us-ascii?Q?rhos63vvvavXU7C9RSk+yDvdjbRX3smNhuqqMq2v1c42+wO2U1Ry+c80c7TK?=
 =?us-ascii?Q?H2gPHPZt33HbhPEIW+YsuReRH2IkpjqTkFIHKVU++UZNeUS8Pq6bqej5mkoU?=
 =?us-ascii?Q?cfsTwjmwTVh5D6Z26HKV2Vhn/xY8KDCZfaKxINcJoIAYtVGiharAXMh2wzc3?=
 =?us-ascii?Q?ntE+oS19nibDM5nnmi7gCYXob92F6h+T3stdg5IPJg7MleAP04RNJp9wjcc5?=
 =?us-ascii?Q?BYU++BblG9fYH8ozfI36aJxRjMbsaOoXaQT+vd1qvH/L6qs/8H4XFdqIPizS?=
 =?us-ascii?Q?Ui5PqxVPg/t1lOxVMy0i11U6IQogZ/fJ3fVny9OP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fc6ace-5f89-4f35-98f0-08dd9a08f41c
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 14:49:00.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5btQ/FoqEVY8RXCflsrUyTEYMA/P3CxBwNiZIE8dp+o7G3B1qCBD/VVWHHH+/W/BGaLcBbm7FpYbv6lvq5kOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10695

On Fri, May 23, 2025 at 02:19:38PM +0000, John Ernberg wrote:
> Hi Frank,
>
> On 5/23/25 3:53 PM, Frank Li wrote:
> > On Fri, May 23, 2025 at 01:18:32PM +0000, John Ernberg wrote:
> >> Since the CAAM on these SoCs is managed by another ARM core, called the
> >> SECO (Security Controller) on iMX8QM and Secure Enclave on iMX8ULP, which
> >> also reserves access to register page 0 suspend operations cannot touch
> >> this page.
> >>
> >> Introduce a variable to track this situation. Since this is synonymous
> >> with the optee case in suspend/resume the optee check is replaced with
> >> this new check.
> >>
> >> Fixes the following splat at suspend:
> >>
> >>      Internal error: synchronous external abort: 0000000096000010 [#1] SMP
> >>      Hardware name: Freescale i.MX8QXP ACU6C (DT)
> >>      pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >>      pc : readl+0x0/0x18
> >>      lr : rd_reg32+0x18/0x3c
> >>      sp : ffffffc08192ba20
> >>      x29: ffffffc08192ba20 x28: ffffff8025190000 x27: 0000000000000000
> >>      x26: ffffffc0808ae808 x25: ffffffc080922338 x24: ffffff8020e89090
> >>      x23: 0000000000000000 x22: ffffffc080922000 x21: ffffff8020e89010
> >>      x20: ffffffc080387ef8 x19: ffffff8020e89010 x18: 000000005d8000d5
> >>      x17: 0000000030f35963 x16: 000000008f785f3f x15: 000000003b8ef57c
> >>      x14: 00000000c418aef8 x13: 00000000f5fea526 x12: 0000000000000001
> >>      x11: 0000000000000002 x10: 0000000000000001 x9 : 0000000000000000
> >>      x8 : ffffff8025190870 x7 : ffffff8021726880 x6 : 0000000000000002
> >>      x5 : ffffff80217268f0 x4 : ffffff8021726880 x3 : ffffffc081200000
> >>      x2 : 0000000000000001 x1 : ffffff8020e89010 x0 : ffffffc081200004
> >>      Call trace:
> >>       readl+0x0/0x18
> >>       caam_ctrl_suspend+0x30/0xdc
> >>       dpm_run_callback.constprop.0+0x24/0x5c
> >>       device_suspend+0x170/0x2e8
> >>       dpm_suspend+0xa0/0x104
> >>       dpm_suspend_start+0x48/0x50
> >>       suspend_devices_and_enter+0x7c/0x45c
> >>       pm_suspend+0x148/0x160
> >>       state_store+0xb4/0xf8
> >>       kobj_attr_store+0x14/0x24
> >>       sysfs_kf_write+0x38/0x48
> >>       kernfs_fop_write_iter+0xb4/0x178
> >>       vfs_write+0x118/0x178
> >>       ksys_write+0x6c/0xd0
> >>       __arm64_sys_write+0x14/0x1c
> >>       invoke_syscall.constprop.0+0x64/0xb0
> >>       do_el0_svc+0x90/0xb0
> >>       el0_svc+0x18/0x44
> >>       el0t_64_sync_handler+0x88/0x124
> >>       el0t_64_sync+0x150/0x154
> >>      Code: 88dffc21 88dffc21 5ac00800 d65f03c0 (b9400000)
> >>
> >> Fixes: d2835701d93c ("crypto: caam - i.MX8ULP donot have CAAM page0 access")
> >> Fixes: 61bb8db6f682 ("crypto: caam - Add support for i.MX8QM")
> >> Cc: stable@kernel.org # v6.10+
> >> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> >>
> >> ---
> >>
> >> I noticed this when enabling the iMX8QXP support (next patch), hence the
> >> iMX8QXP backtrace, but the iMX8QM CAAM integration works exactly the same
> >> and according to the NXP tree [1] the iMX8ULP suffers the same issue.
> >>
> >> [1]: https://github.com/nxp-imx/linux-imx/commit/653712ffe52dd59f407af1b781ce318f3d9e17bb
> >> ---
> >>   drivers/crypto/caam/ctrl.c   | 5 +++--
> >>   drivers/crypto/caam/intern.h | 1 +
> >>   2 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> >> index 38ff931059b4..766c447c9cfb 100644
> >> --- a/drivers/crypto/caam/ctrl.c
> >> +++ b/drivers/crypto/caam/ctrl.c
> >> @@ -831,7 +831,7 @@ static int caam_ctrl_suspend(struct device *dev)
> >>   {
> >>        const struct caam_drv_private *ctrlpriv = dev_get_drvdata(dev);
> >>
> >> -     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en)
> >> +     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0)
> >>                caam_state_save(dev);
> >>
> >>        return 0;
> >> @@ -842,7 +842,7 @@ static int caam_ctrl_resume(struct device *dev)
> >>        struct caam_drv_private *ctrlpriv = dev_get_drvdata(dev);
> >>        int ret = 0;
> >>
> >> -     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->optee_en) {
> >> +     if (ctrlpriv->caam_off_during_pm && !ctrlpriv->no_page0) {
> >>                caam_state_restore(dev);
> >>
> >>                /* HW and rng will be reset so deinstantiation can be removed */
> >> @@ -908,6 +908,7 @@ static int caam_probe(struct platform_device *pdev)
> >>
> >>                imx_soc_data = imx_soc_match->data;
> >>                reg_access = reg_access && imx_soc_data->page0_access;
> >> +             ctrlpriv->no_page0 = !reg_access;
> >
> > If you want to use no_page0 to control if call caam_state_save(), you'd
> > better set ctrlpriv->no_page0 also after ctrlpriv->optee_en = !!np;
> >
> > Frank
>
> I'm not sure I understand, I cannot see a code path where no_page0 will
> be (un)set incorrectly.
>
> optee disables the page0 access, so reg_access is already the inverse of
> optee_en. reg_access == false when optee_en == true.
>
> Thus, if optee is loaded on a SoC that normally has page0_access the
> `reg_access = reg_access && imx_soc_data->page0_access;` statement on
> the line above setting no_page0 already takes care of it, so:
> reg_access = false && true -> false.
>
> Similarly if both reg_access == false and page0_access == false,
> reg_access will still be false.

Okay, I check original code. You are right. You'd better to add descripton
in commit message about no_page0 is true when optee_en is true.

Frank
>
> Thanks! // John Ernberg
