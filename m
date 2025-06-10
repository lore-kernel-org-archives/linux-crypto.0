Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010011.outbound.protection.outlook.com [52.101.84.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179CF211A1E;
	Tue, 10 Jun 2025 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749569153; cv=fail; b=dwcGdRgSZwWj/k5iH5H4qRZa9TlpvFulghbWL0Qxp3eJYUyTj0lZwF3YobRVDrxZNIyHRTFpUbAj7mOtn+B8j9HDT5JoxAtfi426E5ykldIJUS27sgX8GHzo5vdb5Zhn0s3yGBb40Nt+kYFIDfEs6547q0n1YpvEizhpArgb0KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749569153; c=relaxed/simple;
	bh=Q9ScORqof8hAocZli/X6cAF3Ffv9HNrLxIJToEFOaoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cVuM3p+dtx6i4Re8aI1M4mf0Ns2OojTSFQCg3/scOwLU6PZf4hqSqMqjYgBp6tBS/PZlfPtVV5iMxhRgjsU1wbMiR9fTgyQ32UD5/UIzwAsuIyKhU29hpcCHiSGMDMFesctjfs5C6cKeEsO5XU+3oDBA4/qBO8fA6J2dL904Jag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=iGNOzugg; arc=fail smtp.client-ip=52.101.84.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="iGNOzugg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l6/W9os5/8boRow5uqf9KHqOW44St+ZDUCfjamNSdO/BnP0HV5cAt/PSifLvRUjQhaN2yvxBP9K5yrant+YqY5DYmFmkYDXXunTYHuhuM/pzd83ehMC4/MUSVOZIWMH+baKasJ+u8CaNjWkM0Q2Tmhy3a9Afy81+7jByxz4PAHLXYke4NYZdhSVihcSc7GAzXd1/Ikj657XpC195Mhr+kwbqdZdTdtq0ouSYOGeqIMOALzpqwajWRyCenE2dxYA671Yo/Zk7Z8VvDK/lAZbqkAtVgYJto9QY/l+K0PHsnbbTRg61OLYcp9w3SN96FNaS5mK9IBLeYVBtl8GpeHiiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD+00qAWz0o5aUfL1bPuHs82pT/kURY+NndFST2/yxg=;
 b=tuN8XivCvAyEvGUz0TTWYPbq/1Ytce+FJR9UDpKviEGhEPO/J/BRbmoInAPXVESlNdwnTaQHhGzJnAkLICRcTolda9yMYvh+5l7RglfiuJiwWb01u+RpSemT21O0iJqumLNcI9/yeyaRD48f6mAKJLEDhJQMZmbqHZvRQtciqx6Uh7PE+GjVFhGybrMrZzdMtJUk14CAGx5bV9lWkx5c5JaVg+ihmoDx05UTiOYMTF6CboQzm94Du4Jq+k95Zq+bnmhN0c69selZQ8z8vll+U3BYiacsH8HfToliFuXFtTPMSR18OJ0nLx8BtHnohfHF4ZFwwmwzwwP8q5KHevUtEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD+00qAWz0o5aUfL1bPuHs82pT/kURY+NndFST2/yxg=;
 b=iGNOzuggM17u4GF8sZLGJJ73DVH2paSPZ3S7P3uOfOdsXLDRwtaJUZtjKq1JOPzXq1H5gSdPAUb6IrheXGNngrQ87AVms6zGwbbQTh0OpRmS1l59qS3TPsUKfvaEGcPUsVOW0oU4srRxOOtX7YtbTTPryKPu+Vf1jekV2+VGw+xK5/8I33mR4bLPa0a+i+ZsOXJ2mjmrWd+QPBAbVY9v9wv4wgtNvHR/Li3EQrw+Ih49x7F8Wg7smOu8f4m+n8g7a/lrmmuJQoZDqDsKceP347BWfIIxfgx3GMQQwZY8u4M6f3VrRpXb2N/wHKEZPZWku8+PQ16uG/YMeEchrPIebg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14)
 by GV2PR04MB11094.eurprd04.prod.outlook.com (2603:10a6:150:279::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Tue, 10 Jun
 2025 15:25:44 +0000
Received: from PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06]) by PAXPR04MB9642.eurprd04.prod.outlook.com
 ([fe80::9126:a61e:341d:4b06%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 15:25:44 +0000
Date: Tue, 10 Jun 2025 11:25:36 -0400
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
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 4/4] arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM
 support
Message-ID: <aEhOcPcsBLmaVS1A@lizhi-Precision-Tower-5810>
References: <20250610085110.2295392-1-john.ernberg@actia.se>
 <20250610085110.2295392-5-john.ernberg@actia.se>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250610085110.2295392-5-john.ernberg@actia.se>
X-ClientProxiedBy: PH8PR22CA0008.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::20) To PAXPR04MB9642.eurprd04.prod.outlook.com
 (2603:10a6:102:240::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9642:EE_|GV2PR04MB11094:EE_
X-MS-Office365-Filtering-Correlation-Id: 125556c6-b295-4347-b2e1-08dda8331170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|7416014|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFVqaVlkRjdheUh4UWUrQTV4YmgzMnMzUHR2bDl4clNGdWtKb0xmeWVOaG1N?=
 =?utf-8?B?OWpZZVg0a2hrMTV0SDVaUmlNMkdNUTROQ1NYMERMKzN0VXVPS0pMc1NoL1k3?=
 =?utf-8?B?MS9oZFhxYmpicStpdGZndUczQ0lqN2tpQnVCL0xFTzdwbWZpU0RDZTR2bTdh?=
 =?utf-8?B?bS9BTmhwQklkdHZNUHBqWEZiUVV3MC9XNWUvVjYxVXJmQlZwaHJ1ZDhiZEtJ?=
 =?utf-8?B?bXhLc2JFNVc5RW1XN3drQXBEKzhWTGpWekxZbHVJNmFLQUV2R0YzOWNoN2ow?=
 =?utf-8?B?dXljTzBmaXMzZEoyZThGZXJuM1hrVGZVUS8xeHlNL0s4L0xkRjgyamFsVWJr?=
 =?utf-8?B?a2dIS1FzMHlNRmJtRkdvNi9LbWNrUzhMUDJiNkR1VHBxeWl4cnFoMm1xQTE2?=
 =?utf-8?B?cVV4bjluN0ZIQUZJbkl5a3pmUzVML2tlS3M3c2N2aEV2VTE3V2szU0FLVFBH?=
 =?utf-8?B?cEwyNXNDQ28rTG5BZTFRZmJhekRmaWNXNThHVkZLRWd2bEplUVd5cU9tdVdX?=
 =?utf-8?B?SzNZYWx0Sk02NFJiZUpMZmMvbUs5SGVQTGRoU25hN0VvQnlJQUE1ZS9sZHVZ?=
 =?utf-8?B?YUtpZDFnUHE3R1V1MmFkdnE1a0VXVi83RnIyRVR1dHRkZjZhdGhsQk1oNDdj?=
 =?utf-8?B?N0FpQyt1eTM2eUl5OWppTVp2bGFSU0F1SEtPV05UTlh1MHRUVThsZENkNElv?=
 =?utf-8?B?VnhOKzJqSlhnU28zaitoUHFaRTNnb1VVN2hmRloxNGdDT2Z3bkRISGFFQmVy?=
 =?utf-8?B?WWJiWm4zT2x1TGFhWnhtSURVSEtZOHhuM3haTVNlVXVvVTJIMFJyazFFdDRD?=
 =?utf-8?B?SlFGenYzcFA1RHhYbWRaRWpUZGZHSTBaaXQxanJ6UnYveFpudHQwNmpKZmVv?=
 =?utf-8?B?TUZVMU9TeWp0UXhKbjZRclFNNFZpSVdjcXI2aDJPaTAvb1ZYdERuMHdZQnFw?=
 =?utf-8?B?VFQrWWprLzVvU3NZWTIyVVpUaTZsZDA4MmhXenIrSFdmanI0WHYrVFRjMFVZ?=
 =?utf-8?B?NFFuQUxzVFRLcHNyeVU5aFZqUTczYTEwcVdrdjJrWjZuNm5DSC94ekJKS0Nv?=
 =?utf-8?B?OFZNK2ZLVFB0WXFqdXhjNHBOVFhuRkE3TzZ5bUtXRG9mSEFycnhyVno2cFVw?=
 =?utf-8?B?Y3hDbzVsZmRqTThzVWliSWlKU0VWVWM1VzVXS1lsUE1hQ3YrTVJ4OVArdmlE?=
 =?utf-8?B?M2lpTTZGNkFQNWNBb2xSbE9OUVNtVzcwbVpPYnRvb09XRysxODNxT0NyRU9Z?=
 =?utf-8?B?bWFXT3FaUlZQQ0l0bWd5bS8wWTk1MS9XUlVFRktoSENnU2lIaUk4Q3FPc1FM?=
 =?utf-8?B?WHdaYmhkWGJzazFnb3o5NGhUU3F6aVRMTzJNMmM3NllZK3RMN0p6UHlXbkJI?=
 =?utf-8?B?dWJ3enVteWgreXVaUGJ5S2NIb09pbWxQWFJmaXNwYzBBeDRNVjdEdnNNL3FC?=
 =?utf-8?B?SjlOVHRkRk9tVnhaOTBxcW5Yb0dBZUQyN1BsMFNmY3p1cjIvUklqYVhUNlQw?=
 =?utf-8?B?MXJmNUtIL292Z0JBdW9jcFU4YmJRRDZ2Z2RsSm5XNStJdlh0Sjhad2ZDRFVl?=
 =?utf-8?B?T2dwOWpXNndRQVl4TGNkVGR5WHExU3JVVHJLUTdsbzlFc01HQVBKYWdySHdU?=
 =?utf-8?B?WTJqUDhRdFdlU0k2ZERxUjFjVjJQam13T1o4NjJZVkNXTThUQXFtWnJ5VXV0?=
 =?utf-8?B?MU91TFo5Z1puT1pacnp1MU9GYnVLRjc5L210NlRjOXJpKytTdW1OMTVZdHB3?=
 =?utf-8?B?dnFWZndkZGk2cnZWZFhDT1J0MC9iVVgzUXdXeHVYL1l0aTNoVld6S09lekFL?=
 =?utf-8?B?SXpWaklPYzBtcStkWC9sQzVOOS9jb01lT21GMEhwTjMvZzN3YnBzSUVwZVBl?=
 =?utf-8?B?bGR5UHR0QjdTeWdZOXdYV0xEaXczamRZUzVsMWFGTXRZMUtoYll0eFFnMGxU?=
 =?utf-8?B?SVYwOWJVbldZRFN2eEhUa3dpc3Zsemh0TWtvdzNRMmtVYVZtSVJ1T3pFRkZY?=
 =?utf-8?Q?UOFQPli/9Wpdm23es+7r2c2J/G2SVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9642.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(7416014)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFBBbDhBek9sdmMwM3hhMXFvQitNcUIwRDBrREJTTXVXd2lkbm53SExISGJt?=
 =?utf-8?B?OUJGdStEVTJyUFk5WVFhNEp0YUdZUHdMUzJFdEhIb1VnUFJ2WjhmTEUydi80?=
 =?utf-8?B?eE41Q0xBMjZnSmpabDFYMlJEcjZUV1JjTTFuWERORU1zU01nQ1J6V2VYKzkv?=
 =?utf-8?B?QVZTRk90OFB2WVdSVGhkK3Q5dGZXYlEyS2gwRmYxSXFhanhGcEFZalJhZ2ha?=
 =?utf-8?B?MXN4ZWx5b2UyenFpblQ4T0RsTC9zSWpqT2NZWVVVWm1saW1vanZrOHZBSG9l?=
 =?utf-8?B?VzRraUd3T0VoS0dtNFVWSjFJMXFiOExJWmY2c3pNR3RpeUsvQkFlZ0hkS1d5?=
 =?utf-8?B?R045bWw4SXZrTmtGSW8zQmMzMWV2aDczbXdzTmlFdjlBZG5WenRXVDh3Q0xU?=
 =?utf-8?B?OWRmVWFxb1I0TDk3L3hGS0ZZd2l6eFk4dGJVRGhHZG9uVnIreEpXZ3Y2Y01w?=
 =?utf-8?B?ZVZkYlExcDB5TmkvVDhYZEg3Mzc5UDJzVlIwMmZzQmVobnkrd3hwWnpwekls?=
 =?utf-8?B?aHpJaVp0YnRPUWQvNmNMK0FqdzB2djlHK1RrUFVOdEc5NUVUMEx5dVI2VUF0?=
 =?utf-8?B?K29GOEJ6Z1J6ak1lOXAwT1V3Nkw5Z3phNWkyZkVlZVQycnJyQjhxL2czNGw4?=
 =?utf-8?B?RHJ0b21PQ0g4b1BSd3orR0dwalRCblhMQ1UyWVhiRFFNbnMrUVpGUlJJa3Z2?=
 =?utf-8?B?OEJrZlpOMFZLaTJsQjFYKzJ4Tmc0bHBDY24wTG9ycUR6Q1lteVBHakFGb0pz?=
 =?utf-8?B?TmpLSjJPS1ZWMVdOeDRqMGc1Y0lOQndra3lvRXZjYmJLWWJtdUVXQUJnWWZ3?=
 =?utf-8?B?NVErWC95b0FJMHp4ZjVSZDl3QVhmSnRwWjBQc004WGRRL0VaTGxsRkNNdnZY?=
 =?utf-8?B?dmtHdFBqRTRZbEF1akpkdGMrWGNQTnhwVXpsa1doSS9pNkFVUzRETXRoVU9m?=
 =?utf-8?B?RGhWVjRBRTk0N2RBODR6YTcrUTdXUWQzOHdRWXpkVWZaN1lvVlVtdzN0ay9Q?=
 =?utf-8?B?R2NYeWtKSUQrdWN0MlFsUzUvZVJoVTJ2L3grWm5uZ2VBbW9maFJWSW5KeUJp?=
 =?utf-8?B?ZlhDbU5UcmQ5bXQvaHFOMkUvbjJHSGJoa1FMV3lxNDFCZ3pSbVpWSFdiVUFk?=
 =?utf-8?B?cjlrWm8wTGdGTjhVREViL1I2V1dHeVlwVjNZZEphOVRqVkQ0VEJOeFBqbE5i?=
 =?utf-8?B?ZnBsbGlsSEVCUE5BMDhDK2xScHFYVlVWYk8yTFlaUno4U3RyWFZ0Zy82UWdx?=
 =?utf-8?B?ZjdUUDd3QW1wY0RhTURSaXZrUC9FV25VbzJSbzdSQXNkOXl6VVlKdnk2VXps?=
 =?utf-8?B?UW5mNjA0VG5yUXg1c2UyRG15YUV4a0M2MHBtQ1BmV0dZY3FWd3VRekxqTDVT?=
 =?utf-8?B?aXpacWlvT1VNOXFmT3hibVpuZUJSeUo4NTdEUFBiNlBLemlNbFVlNUkxWXN4?=
 =?utf-8?B?QkZwNWVON2RiaFN4NDRMMlFZWDRCWUZQRDJIRnd0Q2xPN1lqdFlsQlI3aTRF?=
 =?utf-8?B?emV0cmY3bCtmREp3NWx2NU55azlJbU8va01yV01mdVgrQzVyYkFuclJWak8z?=
 =?utf-8?B?QTFHSjQzQkpKcWtpUi8xOFU5WlFDM0xsSnhjV2VpQzZkZnd4TU5BWDh6ZlFB?=
 =?utf-8?B?d1hVMHV0RWhPMnMzYzhkeG9NQVNIOWdIQ0JWM1JkWHpVVytGeCszUzBubHZU?=
 =?utf-8?B?ekRBMm1JaGRXUFF4TUNDZmNWVld2aURpV1k0SktPdzNHVlRDcWlGY2YrL1h1?=
 =?utf-8?B?UmI0TjUwUWR2cjJXSks1Qyt4cm4wWnNZd1RGclg0UWNsZmwvWUtadWxsc2NL?=
 =?utf-8?B?dFdMSG0wUnJ2MGVMb2EvQ2psemcxVzlLSEhaQlJOZTFhNlp1Tk9nbEJOUnlp?=
 =?utf-8?B?UDdqYWUrbWsxNko2WWhKL2lNd0Nacyt3QTNtV2N0TXM4V0dtMTBoTjBJd2Vq?=
 =?utf-8?B?T2d1dDVwUERZR0ZpNmlranNuaWtTQW9FbnhMMUF3MnhyMW9qTEYyQ2pMalFp?=
 =?utf-8?B?YXFHcW1jRXZsQzRBS3ZYWXZWZm90WXFwSmZISXhIaG1EbU42UUJYSVVJbHU0?=
 =?utf-8?B?UWtLamxOTTczeFFZdC9BSjZxcnhERVNUdS9QM21Hd1NuaElUcVVMVGJrdVZQ?=
 =?utf-8?Q?+T+g93Se65j1hry1HU+Ptli9v?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125556c6-b295-4347-b2e1-08dda8331170
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9642.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 15:25:44.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJdUkrvTLHz0/i70iK0imVmwNCs6/JoTkCIOcsi6HJCG07kQXrxFtostWU4m6x/VGg+Hi4zB6mXISuZP7pX90A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11094

On Tue, Jun 10, 2025 at 08:51:17AM +0000, John Ernberg wrote:
> From: Horia Geantă <horia.geanta@nxp.com>
>
> The iMX8QXP and iMX8QM have a CAAM (Cryptographic Acceleration and
> Assurance Module) like many other iMXs.
>
> Add the definitions for it.
>
> Job Rings 0 and 1 are bound to the SECO (Security Controller) ARM core
> and are not exposed outside it. There's no point to define them in the
> bindings as they cannot be used outside the SECO.
>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> Reviewed-by: Peng Fan <peng.fan@nxp.com>
>
> ---
>
> Imported from NXP tree, trimmed down and fixed the dtbs_check warnings.
> Constrained the ranges to the needed ones.
> Changed the commit message.
> Original here: https://github.com/nxp-imx/linux-imx/commit/699e54b386cb9b53def401798d0a4e646105583d
>
> ---
>
> v5:
>  - Collect tags
>
> v4:
>  - Drop [ ] rework detailing from commit log. (Frank Li)
>  - Add an override dtsi to change the compatibles on QXP due to changes in
>    3/4. (Frank Li)
>
> v3:
>  - no changes
>
> v2:
>  - Use new compatibles introduced in 3/4 (Frank Li)
> ---
>  .../boot/dts/freescale/imx8-ss-security.dtsi  | 38 +++++++++++++++++++
>  arch/arm64/boot/dts/freescale/imx8qm.dtsi     |  1 +
>  .../dts/freescale/imx8qxp-ss-security.dtsi    | 16 ++++++++
>  arch/arm64/boot/dts/freescale/imx8qxp.dtsi    |  2 +
>  4 files changed, 57 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8qxp-ss-security.dtsi
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> new file mode 100644
> index 000000000000..9ecabb2d03e9
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2019 NXP
> + */
> +
> +#include <dt-bindings/firmware/imx/rsrc.h>
> +
> +security_subsys: bus@31400000 {
> +	compatible = "simple-bus";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges = <0x31400000 0x0 0x31400000 0x90000>;
> +
> +	crypto: crypto@31400000 {
> +		compatible = "fsl,imx8qm-caam", "fsl,sec-v4.0";
> +		reg = <0x31400000 0x90000>;
> +		interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0x31400000 0x90000>;
> +		fsl,sec-era = <9>;

vendor spec property should after common property, so fsl,sec-era should
be after power-domains.

after fix this

Reviewed-by: Frank Li <Frank.Li@nxp.com>

> +		power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +
> +		sec_jr2: jr@30000 {
> +			compatible = "fsl,imx8qm-job-ring", "fsl,sec-v4.0-job-ring";
> +			reg = <0x30000 0x10000>;
> +			interrupts = <GIC_SPI 453 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR2>;
> +		};
> +
> +		sec_jr3: jr@40000 {
> +			compatible = "fsl,imx8qm-job-ring", "fsl,sec-v4.0-job-ring";
> +			reg = <0x40000 0x10000>;
> +			interrupts = <GIC_SPI 454 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&pd IMX_SC_R_CAAM_JR3>;
> +		};
> +	};
> +};
> diff --git a/arch/arm64/boot/dts/freescale/imx8qm.dtsi b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> index 6fa31bc9ece8..6df018643f20 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
> @@ -612,6 +612,7 @@ vpu_dsp: dsp@556e8000 {
>  	};
>
>  	/* sorted in register address */
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm41.dtsi"
>  	#include "imx8-ss-audio.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-ss-security.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp-ss-security.dtsi
> new file mode 100644
> index 000000000000..15f1239dab24
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/imx8qxp-ss-security.dtsi
> @@ -0,0 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright 2025 Actia Nordic AB
> + */
> +
> +&crypto {
> +	compatible = "fsl,imx8qxp-caam", "fsl,sec-v4.0";
> +};
> +
> +&sec_jr2 {
> +	compatible = "fsl,imx8qxp-job-ring", "fsl,sec-v4.0-job-ring";
> +};
> +
> +&sec_jr3 {
> +	compatible = "fsl,imx8qxp-job-ring", "fsl,sec-v4.0-job-ring";
> +};
> diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> index 05138326f0a5..e2e799cc294c 100644
> --- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
> @@ -321,6 +321,7 @@ map0 {
>  	/* sorted in register address */
>  	#include "imx8-ss-img.dtsi"
>  	#include "imx8-ss-vpu.dtsi"
> +	#include "imx8-ss-security.dtsi"
>  	#include "imx8-ss-cm40.dtsi"
>  	#include "imx8-ss-gpu0.dtsi"
>  	#include "imx8-ss-adma.dtsi"
> @@ -332,6 +333,7 @@ map0 {
>
>  #include "imx8qxp-ss-img.dtsi"
>  #include "imx8qxp-ss-vpu.dtsi"
> +#include "imx8qxp-ss-security.dtsi"
>  #include "imx8qxp-ss-adma.dtsi"
>  #include "imx8qxp-ss-conn.dtsi"
>  #include "imx8qxp-ss-lsio.dtsi"
> --
> 2.49.0
