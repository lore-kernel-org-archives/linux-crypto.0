Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792437004;
	b=DcTbEkVM2l9To5HAeXpkBugJyOnMUlBfxaZOyFuzyWxvtONfDG5/t4QUU3NGdjz6T8D0
	 H5sUDLKV0NQZlaG6zIBFzrAkJHs5KdZSSj5zwSCRy6t6PAEfQ6iJ6c3a5h0XoJKKKuxus
	 DXaLNZzo0jbcV9/c7RUapHphyjieZs3uR4YhOJBV3pgain8Mja20MNOYYwtZaAY7LRTIT
	 /YrcFed7SIQJ2U0IvxJ+DZmGIQPJmruB4M0R2Yus3/2wB+54Ebtmriuh639E5j+yNt9i5
	 NtS+Dr+z0K+c5zrjb2pqT3q2gCY++mkYdPCnek4vFRaHRlsziFi3nNhSV6T8/fymeSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437004;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=02rV/1DKjLTt9HQB3IsR2Z4GVgu6TvxkYo3Lm5gpkCs=;
	b=mwyu6emJh7bMyUIcKPiuH0QfmCVtEpHq9QO0GGZYdgFbRef5+zibUCVJqcTRjHiwtC3a
	 0r1ZdkfmDyX59xXJgZPrff+PQq+K1sur61OwyDfpM23zDwaU2nWpU06yVkO0/z0AoV47r
	 e+Fo3RTN99VcuQsibU8zFF2kC//PqHwCL1ebq0Ii5M6lq7oiSM1COH8eckCXKKwNyIq7d
	 qyPurKA/aeoIocIWBTcez1EzOoLR6NT8Rhf0k6rm7c5MaXwAOeOPqD2MZETMdeAvUwOZ+
	 Wh3DkTGoIxUcKe4K1I753koQDivUcaRX/YPnu9xlCKM0q8gfPGHrW7Q6bQBPm93Bicw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=jjIh4Hs3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.31
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010031.outbound.protection.outlook.com [52.101.69.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7B5606A319;
	Mon, 19 Oct 2026 19:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C7B5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=jjIh4Hs3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2H568hUD1ic8WHBxWSv39FCi7oXfROpx5kOQY1cDR+OIlIAQE14RzTMWH4bGHkGGDpuEqZq3n9mb7KghkyHtQdL1stlMJckZMD+x48In5OW3mlOAzHsbqdzOtORwv0ZMMqdu9pRto/f1ojwRiKHU8HtzT4oN5C4NRiVu749AR3l9/7TAfvKJ7WkI8DoX6okEKBM55Q0MStwUBO2fRgp34YX9oWCgbeeglCD2cmZfEiRLrBDf7xnYmYacgLmMCWI2faLBPNTrwt8qIO/zM3TLPqfAwPvyjW3KTBu5Oo0xf/fezO5ds9RqNoWUXaDZaQWie6o4aZwyiTytGPdfGdJZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02rV/1DKjLTt9HQB3IsR2Z4GVgu6TvxkYo3Lm5gpkCs=;
 b=Vl2dcBDlCjVAvYMeeMJAjynTWXsJ6yo/vjYlTMoPLN0intv81g6a9QPmlkKGp9wk18/jcahrFsmCBhgn9ArDTJTWyXeM3SH4zHS5qfhKQA1yRqPxLeLl6iPHU6jwBAmPiz4aFeZ/4oJDxXanCarcYPSPGF6QIjIkcFP45C9N/Vmn3gjtizYVOo45UYGZTH82IBODWs792gF/Xf4JkfUcgKJKl2WuyC0JwBY0ET4P3FFIsEGcnkxlfrqIJo1V7LYY1bSuHwiiFsEIiqnDLbfRCcW6lys7Sl/ehqrY56c6nkkLJD6IZvtN5Ig14+0cGEFzZ31UQKgZT9BoeFVpfOP3sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02rV/1DKjLTt9HQB3IsR2Z4GVgu6TvxkYo3Lm5gpkCs=;
 b=jjIh4Hs303A/44mUBed9fjTTiTJTAnO3RvkTkqxVcFbVSsgKm716GdRCvxo+OCZj9ozMFoo+OWQzq7br/g5W0RiSvQk9Ka9jYKf8x9buRRUc5EKIY/eew9LHEHbjyGIN8BiXJsDDaw2E4PwjDwBnCzCZKcvMJgaxS5hbZ0f7Rlqf/Lo4a+SEgGCF62etKL1JCMav8IhbzNUboq/ywuQbDClOif57xaYqQNAktKJMdX0q/iTzU3xO9LpNVTecpxow/tTyeT/QfmNNSB6ompLDOycVEZwZseGRHVsBImTOLBXxm9qirTEzeGFlDk88ObHjohmvLzHPItUj3bq4tN0E4w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by PA1PR04MB10722.eurprd04.prod.outlook.com (2603:10a6:102:483::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 19:09:59 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 19:09:59 +0000
Date: Mon, 19 Oct 2026 14:09:49 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Daniel Byrne <daniel1.byrne@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>, Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 00/17] [PATCH 00/17] dmaengine: idxd: fixes found by an
 in-kernel polling client
Message-ID: <atZq_eCNCmdlrEU8@SMW015318>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-ClientProxiedBy: PH5P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::14) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|PA1PR04MB10722:EE_
X-MS-Office365-Filtering-Correlation-Id: 23341d42-186a-48f9-342c-08df2e149215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|19092799006|1800799024|23010399003|366016|6133799003|22082099003|18002099003|11063799006|261009223027099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	83+lvo6HLzeN6OtNOo8PNRmSW6+Izt1jPOE861OaIBf1TA1kCgx+uCA1wxoVc2tzx1bwMipbJMV4wP91RmWnsdWhcBgHbva3abDWHXI8qhSi0kYnNiqADh4gTOhW3VAUWB7aSuAoyojidIGt5x3R5NlsfW8idtc6IWGXen7Fynk7HNBl1Ty+CZcNojzOWog696Uyt5e1dERMEXc4WskYADcT7v3yPkR3hZk/hl8rYN7qB0u/wfExEExWMNcLWwfpCCwyx28Ada+aRxKm3LWP2Xux1sYAZ4pRLivo1kQtKQUFy7viVRtX2GR7r/e+0XkByxS+YOdJ7+C5iq0aSXDjRVIUJ9M47JOcfnUyVAxQGv3YXAFZDZkcoDDw7yTzhre4r3j7WfURnYAd6aOjG46mtiB1iJEU14NOk/jLi58yIwgNjpMsTiljfiuyDcebLLoOnyWMaFqShwHnAlYWwlQD1qY18IFTJ7oURWx73E//HYYkmDybQYG4N3YtYtFpZft4zIdTZj7UuO2P9b4S8EiC55TKTrFJPA6plWX0G1N58LgMgcHEvjKHONt2CxMjPjIuunjHh95qraXz+xg1IqthDN+2EDwNNy3uNWFDSCmMfJQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(19092799006)(1800799024)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(11063799006)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n/pxxzjdF01zhUz1dIUwlbsNlVaqtDepDAUqTpYq21no5dMRN2j4xFwqdWUf?=
 =?us-ascii?Q?d+CB5TSb6vZKqPG//4/47IH1mZ/p7xNtY1EO8NjyE8EHPzZfwhP5UEUricZR?=
 =?us-ascii?Q?1lqpWGOjZVo0YGWP6JFJ5okmNHft9yhxIECxxygnayQfJgv7Wf3ojYx3j10H?=
 =?us-ascii?Q?Rll4URBMTGG/PPyVREjeT3eVXZEKdNcMnBjbj9imMC8nCGLl3siZAwaKSDD6?=
 =?us-ascii?Q?aqwYP1yuD3Wv0fAqzPKKGcfUCJjC9O7Fl3Bk2g4rd72cXBD6NKPljZs7yWuc?=
 =?us-ascii?Q?miCIqcaY9x4bez3I3wsBK5uy1OfEOkOt4AkcpTyeyafx3EEhEfc5UjC1pRE4?=
 =?us-ascii?Q?6Gb4RSWhmPuAc+rz5RwlQfXOYH75zXTlHkEsYWsolAGppS8JftgUQHII2jWL?=
 =?us-ascii?Q?siI2r/y8ZlD/olAvKta00xBkqlTL+EPKxGUunovBG9R26KPnpA7hJJGYdKp5?=
 =?us-ascii?Q?d2OlDZZg7LHV0v7mQBo3h0fLlQCvIRjuA/WsQCUpq+KeGdwj8q1+h5vUbmtC?=
 =?us-ascii?Q?TrDY/Cip0hMl+Hok5E1bKNzbM2HMAuPr8+F+9pTeBCAKgjKpy3OOa34cw0of?=
 =?us-ascii?Q?Y9bmsyM+GDdr4llYeBbPw+zHnn96S95dmj6sBrDq53Vxw5H99ROwIRt+s5nB?=
 =?us-ascii?Q?c8gt6eczxtj7DRx+4gtvj+Cm9+ivaMJdI/goONOg0oyYVK03spNhx2kUJvUU?=
 =?us-ascii?Q?CqbPT2euq3pi4fkk4vXlbCgrJZIlRYGMhyL5MsX4tic8tNQ0SEYh6s3A5dCt?=
 =?us-ascii?Q?K1T5ymjVtum9fVowWNV5d7K2w+e+r/B6K1QqDs/GW3bmSzCawjXG50DI43oF?=
 =?us-ascii?Q?j3+tw7iNGYh4FInh21ShMePex0Un66s1qx/JIYNPBtYWZ/zjYcDpDpMuBbud?=
 =?us-ascii?Q?sBgLm/CM4V1YE/XrSzgexVilwx3KyU1yLRfN5FYFK4KVKzDm/JktH683gp1R?=
 =?us-ascii?Q?H6NZWD8rWjmZr8kntLZZE/onSRPaYH3AosMKuMSD1ksiEvZaQpU1+OlTdU74?=
 =?us-ascii?Q?wtvfRLoEY0wZN2KkZGyalPwrRwbI1QuCCbqzvNg1PtqUGKoDhTHf8c3Bxf0o?=
 =?us-ascii?Q?ZzUOrbd5Gzp0fw2EuuZVxiXmdGU9adgL2L3vOOv9dRUszILmA5NSfQhMIdY4?=
 =?us-ascii?Q?7Jnr+37X0415e2I+ZwE+bTy9eDuoiV2rFE8ZCNYocRvlbnJV3uRxDrrAolt7?=
 =?us-ascii?Q?+miF+V6XGiwslZIf5TdfpMJgQk07xdaMpmCNKgphRFU4IdJoF8pZ4AX5TNQW?=
 =?us-ascii?Q?OZMOfeoUBoeIK85h9zgAO3nH/DA+VpQftuy1F/DSoCylptsCajD7dcWfhj6p?=
 =?us-ascii?Q?4BHjLkNDoVGfy7V/qXZDkYd++ieMb5eHjz0ba6wU+fHkcVMPaYRATldE42sh?=
 =?us-ascii?Q?SkPCP56QNG0H4yPF4i6X86oVg/W/MoFj/LJCPHoc0xZqVUB0wsYzCfI7q3SB?=
 =?us-ascii?Q?xXKE55jfJj4Pg3kIyoB412ZC90jvrtB3Pi6jlnL+g1TGOfVIUg6OteacVdSC?=
 =?us-ascii?Q?0a+NMpsHD3SRHu03UwWr7dfoF+ZC6BjS8r3Y8QBajE3h12GrYCuevmH3kMUw?=
 =?us-ascii?Q?3pDUe5HtFMwYaTjlYYJS4KaPG1VmOJ7xSwZDg7Sf8XTbeFosS9aKUn4biObz?=
 =?us-ascii?Q?YjpREO1rOngqhrn//nl44+aR975HcrP1lydSdBZasLVrFf1WAmLseolBu8K3?=
 =?us-ascii?Q?0DCyHuR7OXLoTFFYxlNahBP/LcFk4TpBlvdCCqLKjK/4mictVae4GBRpsm14?=
 =?us-ascii?Q?ysFUWBdeg64CCk+Wij5xNgCTXclKMFFy0bs2nIAoPuIeVGu85UTv?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23341d42-186a-48f9-342c-08df2e149215
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 19:09:59.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zedneNFPqrr816mbq8iI822/8nbZACCLYQAVtiJbOQuseBmxDvmfE9foh3RFxj3xJ7/f8bwWDAVrwv1WKLZouACtZBpvdNWW0WQU46UKbuhZA8JkJuSa/ocKqACet6xH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10722

On Mon, Oct 19, 2026 at 08:06:13AM -0700, Daniel Byrne wrote:
> [You don't often get email from daniel1.byrne@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> These are fixes for bugs in the idxd driver that an in-kernel polling
> client exposed while sharing DSA work queues between many io_uring rings
> (that client is to be posted separately as "io_uring: DMA-engine copy offload
> for buffered file I/O").

where the link, I can't find at

https://lore.kernel.org/all/?q=io_uring%3A+DMA-engine+copy+offload+for+buffered+file+I%2FO

Frank
