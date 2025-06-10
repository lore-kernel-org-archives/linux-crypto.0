Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013012.outbound.protection.outlook.com [40.107.159.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242623535A;
	Tue, 10 Jun 2025 15:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749568944; cv=fail; b=S12nEGqyW/WY168zKGVIbXHm4aVRZfcw2OGg+5QM6oZicrp19TNir4LWD5WTksG3t7Egls3hHXV9h2mRx0KpDokv9JvvTYHR9aUqCrmbD8qW3E5V5tHM80q7Uuf7zJvNt8M+IPtBjz8cU2xoiSOjjus2Grkfioh+cvplRc7+xVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749568944; c=relaxed/simple;
	bh=v2TkEEpVoM0LjbxZKMhM9Ncbrq8qlqMNBqnFJM0nDbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dnEyIt2IaDPxhohS5hwOqtR4qUTe4oGSoeH9ByEjpqHs6Qcz2jBJ76e07IqFjUDJOEET4ehY291O+uJXemLplp7jY46VS8nx5KucYYL2MOfFAYKqWzG6/i3PUkWhouw/RsxA6BVwn03//Yt3YO3icI+VPbE27IGRXmW/XLkwFiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=hKyshZ8R; arc=fail smtp.client-ip=40.107.159.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="hKyshZ8R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSiXP/3LqvC8bVreJsY4b3lXTqt5dJ4ZNup8RJNJD2g9vddFUTdLkjQO3jSARraUGDlWMQS7+42cjT4DSkvTiaG3W+4nRspyExQLCfoX3hb5UDaIZgl5PRV8/XO0T9FUrNOlCiv+qjhZJqCNPZQhaZkH+pJ2aeH4DYKpBR5mJLh/EtcfjYod0Da+H7rIjbrT1aT/mrNqSdzJpLAJBIM3D/Sp0hUCDDz1akEbXVpuYU/ZROoseWGWMmEvJ4yxpJ8Px0lqXSuTqj5NLLprhnu6M/5S71ap+QA/VlMCAC7jUYViAlGc1rgXxZ91w8hl/tAg2D2przExRcZfUgdMb9di4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MT7Bq8V04AWiE0OPE1pYCW+MSWaSagVdqh9g4S4iMCg=;
 b=Uw7p36u9QbxggaiKp7J++C2VHMSgy5IjidhYzaR9+tLwG2NIVdZ4sm3ZwTF1w5L7EMpq+CHE+021B7J2FFgBct1RyPPmTmtny6QKFu0wSleHsjXPZ2aL6YYqS9W+v+Uulg3YXw9j9F2EE4IVoYnkx4i2Q5z8pbi+D8J1+uo0qyHa7gICkHf2jo6F7CNlKFboVEFkeP1e5yAwnzIKUBqFf8MP8yEeFGZiapHMAigW75fOEVbI4Jv0kYKAJZ5wePwRCJL/jp4OxbrW2+zFK+vPGdQZqLMBVAhr/Nmp4gnGYEArNJZJTU0YCHKHSwbN52HXwPt/j3yNrSixoZb6ZIbdXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MT7Bq8V04AWiE0OPE1pYCW+MSWaSagVdqh9g4S4iMCg=;
 b=hKyshZ8RfANg1lyVaH+rRo/z6veA8FREV9V/FKJcynj12hB6tT5NA8JZ/37mPCmudlbCPlR+X/RqOEpSAf6iFXKX183l9SsAznkIMHU3wGf2LznD/tTkpwoeRnQWUGmMab8GMVRH9LbX03AGFZEqlpHYdB8Mripiy5ALfjTLnHiQa3wmcqTBYvhMYv9qc4nOFVBJt7vuydCRSrH1ZccljT93HhXl32R6W8+TH6dOSE9hBHAueVkW2EEYt7g95u0Ey5VBbC9oueyQlFuoACrZhqLc57kbgoaoJpGgtPMefu/SqpEaLp+b2IRNpgjeF8KEfKGH6PC6dby+63P2Wd2YaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by PAXPR04MB8895.eurprd04.prod.outlook.com (2603:10a6:102:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 15:22:19 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 15:22:19 +0000
Date: Tue, 10 Jun 2025 11:22:09 -0400
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
	Sascha Hauer <s.hauer@pengutronix.de>, Peng Fan <peng.fan@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v5 1/4] crypto: caam - Prevent crash on suspend with
 iMX8QM / iMX8ULP
Message-ID: <aEhNoTc36V7Tq3Ag@lizhi-Precision-Tower-5810>
References: <20250610085110.2295392-1-john.ernberg@actia.se>
 <20250610085110.2295392-2-john.ernberg@actia.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610085110.2295392-2-john.ernberg@actia.se>
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|PAXPR04MB8895:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aed7acb-5992-47c9-fe95-08dda83296cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NChpjG2w359Ko5VrsfTjPHRKig/MmH5+FAub0yEn0n78QrS2nHyzjB+tlUqN?=
 =?us-ascii?Q?MWTqOglt6LCsk9rr64wquhoUjIKtHAyGk4WMYW8Ve5pSpOos5eYbEfTQzJAK?=
 =?us-ascii?Q?VZGUZ+KfUDiOSfKdAbQ4EE2xT28n6SGHZC24BIuXZi4WhpkJCl3yF04SMga7?=
 =?us-ascii?Q?TYoRd2UDoV7ils1L+IYnh/JfjuIZS4H9fSMf63zjDImVaLKA5iecT9W50PAC?=
 =?us-ascii?Q?UmgHGWsEcXANBuQn9+fQbKt0hV6H35Cho1w24GTzYvGNIjxn6mOCIxbejKb/?=
 =?us-ascii?Q?YXMdCmXlg2vpNMpZbjr+ESTDiqrNTWA+eJQLNxCYdBy4/gOYIyFcPFsqKJD3?=
 =?us-ascii?Q?C4P84KDG/aXLScERW8u0m7/2MoNdEOWAZ8QKT6uGTPfO8xtmt2FoxU5r855F?=
 =?us-ascii?Q?eAMbgOySYsHe4zE8gzI5AbZAvqyeXRT0O3yYfPvldh94myM3VETIlkrGrn40?=
 =?us-ascii?Q?LXBq5fVEFVM0CfskQHVlGwdqMazORzgCqj+mHlGzBaDSn+UXaL4unypx45WC?=
 =?us-ascii?Q?hUIHT3Tpdk+DK/GpTEYAN404Bx1YUEZmEHxt2CKJIUsIUWr8UpzlpH9igxOK?=
 =?us-ascii?Q?9bFtng+Gsaj0DM5HWn7YR2Stoe/j3bRE8mtQuOKOkLYI0DYC2Sb12h6rA+EY?=
 =?us-ascii?Q?qCRfhPNwh1qWT6cpbjllVQLa8VfYg0aaIFMKGcnz8cFRJ+XWhSb6S9AKsCxb?=
 =?us-ascii?Q?gmIZzl/MAPlWiI4jPPB0/U7nxePbFvC4gLRpAiUEE13vGq5fJYKJo05md2NO?=
 =?us-ascii?Q?1OP7ubF2f/kkDzPtQ8W3jlKnmOvZK/grVjFqU4YeD0WfOSiPKwd3CJdPS8hV?=
 =?us-ascii?Q?CqumiriprNXy/3baELdzKBF2AoimAYr8299fRjTtxVaSeu+ZbqiCzesMZxvI?=
 =?us-ascii?Q?XcWpMQ//10OLUR/QgeAr9bNQr+Vy3ReOfLcJDUh62njSyYNBOPq63/SdfA9a?=
 =?us-ascii?Q?uRkYcaDCjJRXeMxf5AvSRrGUYYSUZoe7X2pI5XopvT6pM5nD4NMl7OGTlb7k?=
 =?us-ascii?Q?Vt7J9LD0DQ+ShpvUyFDy6OSA5oOB0D4dQ7sbEmoGBGXQYCvQgDyU6zezrjCf?=
 =?us-ascii?Q?NKQUXzmOqO2aSXzDl4JpU2Z4il3OO+Qy41kYKJAR+aamstFqOUaVmx4VttsW?=
 =?us-ascii?Q?ceJSTKgZmugzfdMaIHEh6cx6sB7GvlJAQNetNKMc4BklA6EZIaaJ6h5a+cQa?=
 =?us-ascii?Q?d/hbg9eYmZne8AO14GEuDX1it7PBBGNrPoV1aD/z42UHxlim5wixj3WMnuVy?=
 =?us-ascii?Q?JMEMi7cy5hINQZt9uXXVTUue+12GQFi7NJDnDT2Hb5fi1RVkGJFTfnZhipkK?=
 =?us-ascii?Q?g2v9g4SsDziRuCE5N/LFaN4ZyqH2S8yAgjsUJBGWo3Cdj7sWdvChuKSjdG8s?=
 =?us-ascii?Q?Yv8YO/VWlBL8mqFloZ95ZmHTB2qpsrlO828tGBVkkt/pdzKQJNRAEAAIhqMH?=
 =?us-ascii?Q?UzxZYkelSQZi+2DeJNH3T0K9iH3uHmLX/fmNT77HbSk8l+XwFpQyMcmTRCWP?=
 =?us-ascii?Q?aF81RgrCvlQ41iY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eMyPCpk04HluL6CXkK5GG9RoQw3t+mLec267tPBoTsWUj4Dw/+uq+Xl7q+UZ?=
 =?us-ascii?Q?TzaJ4mc/8z2ZKAjdyl0uFjTh2igXiUTmJqn+tnDAKUB4X3T+ABdnEAlYsCgN?=
 =?us-ascii?Q?ZcKXA+TBmiuYSnyDBwmw8rXSuWUJ/itTARdQqe2g/pwQ7ERcSrp8fZUHSPLX?=
 =?us-ascii?Q?YkxAezaNdGCFJnjrsojxLOykNpcbeL10Ez2nhKtNvD4Bk/xw7bHBUVRPDtbP?=
 =?us-ascii?Q?gLTuY7paJcGp9iGsU1qZxREQB4hmt67yGmQ9ZJ+T//E19wOMKG28eRMKtnag?=
 =?us-ascii?Q?7LQkLm6quIVYc6CdR1j3zqyls/moP9d9FA8YEorpfu00OVIcQDFSGs+5tmV9?=
 =?us-ascii?Q?zcOs3gDrPxAUSQ2tSwhncg9yhhPmL8XJtfTshaY7fbF+l6RVrC19TsyfmWJu?=
 =?us-ascii?Q?DOMTe8OZbkaCs2FifRd5LHZUixyFHV48/Z7+MgAmyw72tl9YkTO1+socgDYL?=
 =?us-ascii?Q?3d69vCCNU6Q2L0hVherJZVztuWSVc32GVxQ5UCde1RvN/70LPQTigCTbN+e2?=
 =?us-ascii?Q?+sVclFyOCc1AM1STxFVReqxyh4qD5u4d/jKlGM7ePLUEKM5dOJWUbqUX59ea?=
 =?us-ascii?Q?QhriCXTajn2lzSzSbwSJQ8I+aLiGcScJ+ep6sS0w5zYtq/Q4ny0QQuTe0Bke?=
 =?us-ascii?Q?rL0mYBe2kH4MnPHnQwWkOpk/nvhAAUU2mIU3FW62F530KMaw2nDfYweNwGeO?=
 =?us-ascii?Q?cnXEpEUBJyyNhLFOml92lG11GOm906UVsJobHWm6W05GAUu/HU0o+HTghBlY?=
 =?us-ascii?Q?YVVe/B49g5qxJkzhF3gcbYad2WGqCqMWk8SIK1JCSuPdQcDQH1Dy6wRTXEzK?=
 =?us-ascii?Q?yKQ5lb7myoPNHFASf4hh52jLBJ8uTKmG1iDq3z58vbxU5qv2Lm/QtYA/LzQy?=
 =?us-ascii?Q?l/QysWEbwSHa3EwsEz5NsbbOfwZrmMGnoiy8Af6U0dp+yo30r2yo2aXvE1gn?=
 =?us-ascii?Q?LBMIE4fEjLA5xMoSb3hPXYEovJXCPx/fsraX9b+XO8HXpfvVTpBtOeNIZEQ4?=
 =?us-ascii?Q?2zAJt75n3PFjZSpFg9zbaRRro1lh5E511OwZCiqq+ZlboqUGDQiTcVD0iKtr?=
 =?us-ascii?Q?YqS1Wdq01h/9FfYALCFV2AlHs29fCy7Nj+XI5jt62lGAIqnVkUSGRs0WZ6+u?=
 =?us-ascii?Q?08QB4G5MLxIDPHx2TmMXTtMtAtmiyJrGUy9reUckR2McTAIRoTtuOV5nUK6g?=
 =?us-ascii?Q?8WMb3WFb8BN0ICw1NNFR9JIipOAaEiUfdMcDzZ6DtveD1wokICOKLacVDGeP?=
 =?us-ascii?Q?eySy2ED0LFUIfpjcWcV9jUn2WsARDQ+KLkgYCGjCkApzQJbMnuYPFYPZTnF+?=
 =?us-ascii?Q?ub9etPh3Q+lBONGZF05WVLnSf2+d9a1p8/bSxLcLHM05s8Lf+cVURwbwqOTo?=
 =?us-ascii?Q?RO6loQiE9tgEJDo2rMMKjUz7o4X8/GhtLsgvu82L9oB1pLjRlY4D+PNuvIUq?=
 =?us-ascii?Q?eY1AhOqf99Nbv0SyrpuEFPtpiPLjC16xIFu62mmYRi2xJi8jb1o6JrN0l0mU?=
 =?us-ascii?Q?2n4+ilXbHvLJb3fub721U4K4npnvHSlkFMCCloxVvLeOuXkGNPecosXSWlKm?=
 =?us-ascii?Q?j88kp5bLlFF1rQH4envBKw3Ankgc/NjJclU3HUic?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aed7acb-5992-47c9-fe95-08dda83296cb
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 15:22:19.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nE5aulMzWGCxkNttVHMurdXU2NpzvC1BrNdumc0WOgEaoCkrhHG/elfpyPoyFt67fakBrenty3sk7F7+lxjOAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8895

On Tue, Jun 10, 2025 at 08:51:17AM +0000, John Ernberg wrote:
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
> Cc: stable@kernel.org # v6.10+
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> Reviewed-by: Peng Fan <peng.fan@nxp.com>

Reviewed-by: Frank Li <Frank.Li@nxp.com>
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
> v5:
>  - Collect tags
>
> v4:
>  - Drop 2nd Fixes tag (Frank Li)
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
