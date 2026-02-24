Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022129.outbound.protection.outlook.com [52.101.66.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB7839E6EE;
	Tue, 24 Feb 2026 14:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771942830; cv=fail; b=CSL2xiS6zncfQ2lMDCHCOs49qsLDuZxV8QiwZRbTv794Ru8ICZk0hHfgdrbZ7zmZsrGLHsI0OhsWnoHo1piFaYdrTxAb5yCzigdBQwfpcLtRc+pzkXlQcULp/WPU1q1SoHquA7DwLRnQzX4FUb11Gp28V4tzikvvbPM6loFs47A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771942830; c=relaxed/simple;
	bh=zSry0o1BdVzBia1SAQgw9fwczhUCYfaP5FvYcStWoIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tcQ1rQcuB7oRybYphmAYRFlbkLPk65Vy+vSDYQbNPGJdggosxLXrFb1pVtswmMOy6HLGrFbglOagMFvNgWRbxF0j8WR+rVYKDHyB8IGF/S6G++YYY13jz3ycAtm1G8UZGOgE1skvCrsDF3W5uPuRlPTsjykYfrBLsbxONyUqYWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=Wevr1wAI; arc=fail smtp.client-ip=52.101.66.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="Wevr1wAI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSB+TlJwIWhbKfzlGt4doqTlZsPZDBYgYu8Ia7ydJjhSRoSiwBSA3v00THtp1DqA3jaxNLzAyMvEkLVjU72Cw24KmLgc5kPEVY/W56i4zm3TnVvCIOCUGFwyY3J1qeIKtZhgsKUZqd4k0Am6AngYpnzZWCP2rTJ9VaX3Fltn32kMieLZC1Wh436FnOk+hWdpxwNAFURDH8iZoxP7bAdjdGJ3GLF6HaRIFTmMqIk37hz4Qsy8puPo/XpByEpXJb/aECNxMainnmXCjaQxhG7eHTOBTk+VFONvWOhc+XiYh1LEJD9FuV6Q+c0fbKvjq1kqYguxBu+9vysZQBosynEfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSry0o1BdVzBia1SAQgw9fwczhUCYfaP5FvYcStWoIk=;
 b=SgVa2d52JwVQOePC4YHyd30u1h1J/GWMG9qHk42GTBoAxxlD9aboUG1MR3JQfpny4Qd9Hqb/lbxQHdLPJJDZFRVeCRT+XeKMvzdfYJzLY9XuEAgkGltaCbRgoh4x1szvksOOPoC1iBf+iCcOWbiobpJzFotxye2SY2aCDUOU8InidqfwebVDty6eJNs2Tx2/uSS9TsxlI/NtHxv4OYnT13pq2+Th3/FXn+p1xQJ8t8QXc70AxDTQ/U5k/NLiio0QT8g7n30Q9OUGxGi1mppchTLNhJ72UiTDzuLJAnsDv8t/nK5GtdFYVok0AklCJiWoNymrxbpxvuD6IgN22vpPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=cloudflare.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSry0o1BdVzBia1SAQgw9fwczhUCYfaP5FvYcStWoIk=;
 b=Wevr1wAI9CQCKaxd2PDvJczopwmSmlwWFizadngQ5WdTZAAxtZoSt/mwvMokmgY558UdekLeeZqVQvfpG/w1iyyg3rqXQGdkj5/N8sYMG1GEx5IdhL+hvW+B1qEupeQLiB+ay2UYMVNF5gj0zICx4qU8Yh3FvCiWF3Ef0ffpKi2IjvUti8Pk5Wu77178VRVmDx0Thn86mxxumSC9r1ET4T6opIR0MT1lfumy4Q2kx87FJVYtFXzpvzQ8FyYWGCGVB+QkA11b1xI6gHOwg9LL/uVbkl2fe+8uEcA30ItAOyICx6i+BUZJ5qe/E6rcUB8MfcVb67GVBjRpT/YONjXWEw==
Received: from DUZPR01CA0037.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::15) by DBAPR06MB6903.eurprd06.prod.outlook.com
 (2603:10a6:10:1ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 24 Feb
 2026 14:20:21 +0000
Received: from DU2PEPF0001E9C0.eurprd03.prod.outlook.com
 (2603:10a6:10:468:cafe::a1) by DUZPR01CA0037.outlook.office365.com
 (2603:10a6:10:468::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 14:20:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 DU2PEPF0001E9C0.mail.protection.outlook.com (10.167.8.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 14:20:20 +0000
Received: from AM0PR07CU002.outbound.protection.outlook.com (40.93.65.64) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Tue, 24 Feb 2026 14:20:20 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by GV1PR06MB10150.eurprd06.prod.outlook.com (2603:10a6:150:281::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 14:20:17 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 14:20:17 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Ignat Korchagin <ignat@cloudflare.com>, "horia.geanta@nxp.com"
	<horia.geanta@nxp.com>, "pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "lukas@wunner.de"
	<lukas@wunner.de>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rsa: add debug message if leading zero byte is
 missing
Thread-Index: AQHcnAvkIbtDqneDG0+UC7zie+MHU7V+6bUAgAlBhQCAAAhggIAABG+AgAAFpgCAAEYfAIAJdX4A
Date: Tue, 24 Feb 2026 14:20:17 +0000
Message-ID: <ba272f0550e0eb7760c7a07b4cb8e8d4307cee81.camel@ginzinger.com>
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
				 <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
				 <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
				 <CALrw=nFCizuZ3Cko3LnAGb8A=4KB+=HdgoZDjqPgU=ssAK0hJg@mail.gmail.com>
			 <957c4cebc0c479532c8ce793ad093235e30acc77.camel@ginzinger.com>
		 <2545c85aa50e7aaac503ed076fdb47ee9c15791f.camel@ginzinger.com>
	 <0b27d03d6b950d0fc6f2c19c40b792bf3cf2a677.camel@ginzinger.com>
In-Reply-To: <0b27d03d6b950d0fc6f2c19c40b792bf3cf2a677.camel@ginzinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|GV1PR06MB10150:EE_|DU2PEPF0001E9C0:EE_|DBAPR06MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa09203-d66a-4579-7762-08de73afd7da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7142099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?ZWtlVElWblBVaHpEOUZESkRQbW5zSzBLZGJZaHlFMmJpczJ3WmZrdnJnYVBo?=
 =?utf-8?B?Y0w5dUVreTFHYThzSEtpZU1YVzFhd2FyT2tJSFF2LytIa1lyVHRhRjRsS21w?=
 =?utf-8?B?TGZ0TDVJY3ZEQ21zUTdZMndBV1JWcndlemIzUEdsY0lyaHZkczBtaFQyQzFp?=
 =?utf-8?B?YVBaK253SmI2RlBJN293S2NyMG11TlRWeE9MRjZpSVNENFMzYXBBcWxKUDNk?=
 =?utf-8?B?bnNnTTMzRzV3c2doTU1kUm05blZzVnFWRCs4NHpvNGllYXVla0NRWGJicnhZ?=
 =?utf-8?B?aVlJampXQisrazgvemlGTUhkczVkK2kycklORGlOaXo1QWJPZmhCU01CZmQ5?=
 =?utf-8?B?V2Z5VTUyc1JmRFIxc0U3TFhFTEpla21PbDVuY0xYNmFlUmtMblh1Tk9NU0Vt?=
 =?utf-8?B?QnhTck1HYWVscUUwTUliTS9CdUc1TjdTbVpIUkJRVHo0Z09SMThFWXVnamRS?=
 =?utf-8?B?c0I3NlNuS1hhZGRsbEFtaURGMmQ1S1dlU2RGQVZaQjNTeUZEMktabzB4c0tm?=
 =?utf-8?B?TmpiRjVtU25CWkJWRk5uREt4MWtrOUMxQnBQRE9qVUF0ZnRrVG9kajZWb3ZU?=
 =?utf-8?B?MFZvMDAyU3pPa2RCSTFybmNtRUU3VHhFM1J2ald4Ly9XMmFpOVYwVFdiSDhV?=
 =?utf-8?B?QWtFZ0grTHBTdmgzNlJOdnNCVWJ5aW0xdWN1dGNkakF2a3Y1TCtySC9MVy9X?=
 =?utf-8?B?RFRTYnFlRmtzVTBUWGVDczhSNDFxU094cWpubjFzM2NoRXMrVHZxbFV6UXRi?=
 =?utf-8?B?Q3NXNjhlVTV3UW5XV3VZakNFbDk4d1lIWjJUaFI0dGE5YlZhSmp3Ry90b0Fs?=
 =?utf-8?B?WnRaTWRESkFPU29lRjlUbllNZnl1SlhtZVBnWGZGQnB6aWhtYzNhOFNzZHdw?=
 =?utf-8?B?UTFQQ0lNZjIyVjVtTWZUQ01hbS9STXlQR21oTXhIWVdDVHJ5bnRRcHpqZ283?=
 =?utf-8?B?Umg3cFBoRmtSQ3kzOTg0c3dudVk3S1FGb3JlQWNuUis5czJLN2doRnZKOWpi?=
 =?utf-8?B?TjBHTlNINkRYTHZmSTFYUk8vSTliTGl5TU4yV3oxaXBOam1EWnlaNWtrazhC?=
 =?utf-8?B?Y1c0MGlQWFpGZ2JxbHY5V1cyeW5DZVV4RitORWtKNXZRVEtEVFFYSFhWYW04?=
 =?utf-8?B?eG5VWjNxOEFFRCsvdGhubGFIQ28wK1d3eFJ4ZFVmbktiZ3NiZk9VZldoUFNN?=
 =?utf-8?B?ODVqd05Qa0xlNHpzZjFQVjdXUVJ2NlM5dm9XaXlzcXZoMU5HV0lZSTNSeVRq?=
 =?utf-8?B?RC8zSHhVdithNGxrYUNMSHV5ZytxaWQ3ZHlDOTNTWm9ScGZPeGRJN2wybkRX?=
 =?utf-8?B?VnBVUzlZemR6aVFyMUdEUFM2OGZ2M2NBblhFZkUvNWEzdTlOVzFaM2NESXFM?=
 =?utf-8?B?a2x3SHpWeUZOODFPVlR5aFB2MGY4Z1RFbDN3SDZyS0c4RytibHViMFhvYWg5?=
 =?utf-8?B?NjZUbnRlaEZKckZJcHV6Y01SZ0srNUNkN0c3RTR0OGdqVUZqckxMREprSExj?=
 =?utf-8?B?ZEtLL3VzSGxHM1hxcjFrWTV2cC9lUTFkQWFJVkM1bENPSzR0SFZrUyt4ejFF?=
 =?utf-8?B?Q1Q5NDFkNDBMYUxtVW14MElFMm5YbDAvb0tZU2JkWFAwVUp4RUJLc2krTXNT?=
 =?utf-8?B?TDhLcW9XcVpzOXYyMDFwenB0ZVRIN1BOTWpoNy9BOGcyU0VVRy9MNG1LeWk4?=
 =?utf-8?B?dlhGbW1KQUl1c0hHMkVHcVo3Ynl2KytiOTFoWnFPNDJlL1lXRGpzSXRDZjR6?=
 =?utf-8?B?Qk1FbmVYVllEMUFCRnhjZ25zaXdjbzNRZG5ONkp6eDd4V2NjR2lMYXV6VURl?=
 =?utf-8?B?UkNRZDdwZHRlcnJhN1RhYWx3QzdyUW9ZUFlCWnkzSC83TVAvazJVSGNUWFVn?=
 =?utf-8?B?YVdLRU1mK2R4Rm5iV3ZjVGlrYWhIT1RtYjR3QTN4ZnRFSmxCbzhnN0V0cGlT?=
 =?utf-8?B?dGFXbVB2NWk5ZWVhWXZLZTAvTW40LzN1dE5aVGJNUjI0SysydW9xUzN5UEJs?=
 =?utf-8?B?Q3c1ZW85SHhNRFdYcHBtcXlBenVZM3UzNy9rNFV0RXVJSTJuYlQ2eUpFT1B6?=
 =?utf-8?B?bFFHUkkrZDhCUVUrRkN1MlhNT1pyT2dpbkRxU0ViTTVHeGp5Q3lsQ3R1NzVX?=
 =?utf-8?Q?6OTQuyllPmmitjYb7/9AUSd1p?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7142099003)(38070700021);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDA2A59F2667C4459586FFDD45171C74@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR06MB10150
X-CodeTwo-MessageID: c760d143-4eaa-480b-90d5-7144db35ff32.20260224142020@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2c9db499-3649-4db8-266b-08de73afd57b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|7416014|1800799024|36860700013|82310400026|14060799003|13003099007|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejZYVXhsVVpMcVRZSjltaEcyTGRHSDVkT09yeVdyaDNZbDNKUFMvdFcyMVJF?=
 =?utf-8?B?ck5iRU5RWlNWYWpNejdlUlF3Yk1naG5RcXpOR1hSUDBRM01BcFI0MU1jZ1Ur?=
 =?utf-8?B?L3ZJMUd2blZ0UmFNUlQxSXlQczl4MVRRMEhXNEJ2UmladkJTNTZCM0REeHRQ?=
 =?utf-8?B?UERPUTF3OEZseXZ0ZmZnUk03L0swRklGSGp2MTR6L0VuL21CT3prN1NkbW9F?=
 =?utf-8?B?Rjg1ZEtkV0cwclRCaTEyYXBpUlpkM3E3b1dxd3ZMOXRqVFpKMDZxb0RUVVps?=
 =?utf-8?B?dFhMYUMvKzlEVnZnOFl6ZndOWU0xQVNpKzh4clF1dUFUbjhHeWVvcU1MTUNL?=
 =?utf-8?B?bE5UR1U0OFhVUW4vKyt1R0JMdzJPbTZZSHN1ODZ4MnArck8wOHdQQ2pyb0sz?=
 =?utf-8?B?UG9hblV6UWx4RVZ6ckg0TW1tUGJXQ2Z6Y3BLSk4vZU1pd1FZUmh5R2N0Z0JP?=
 =?utf-8?B?K0E2bUhFMTZTcjJuR3ZFRnp1Uy9YRWpwVlJLL0YvaUNTSktrdkNxZThVZ1pR?=
 =?utf-8?B?Z1cxUFQ5MmppVFUzbVFGTEhHbS9QNVMydkVLdUU0OVdRc2Ixc0wxZjhxelZI?=
 =?utf-8?B?RFBDcElTRkI4WjdTdzNnQXRhdlJsaWV6RW9MbXlPcXNCaVR6TWJnNWdoOXo2?=
 =?utf-8?B?MUpKWkx4R281SnhnRldGTjRPb1U3TUhFb3VpN2NTVG1KVDZFT0hYeVhweEk3?=
 =?utf-8?B?ZUJ6eW5tNnVYcDdaY0x5YzAvdHFpTDVRQkFCb3Mzd21SY01pR1VMLzBkZUY5?=
 =?utf-8?B?dFFLMmN2UXdHYWpOMHZEd1VKWXJXNUoraVFIeWhScmRkNlQ4dEtUbVc2VHcr?=
 =?utf-8?B?d09RTCtmWlMyQVFVcXN1RWtWallKemw1V0ZqNit2WHFzYUJzR0MxQW4xS1Ri?=
 =?utf-8?B?TnBqNUNSempuWGRnVGVSbTZvd0I1Qi8vTXgrOEl6eVRUbzVVYTJFTVVBNGI2?=
 =?utf-8?B?TTI1b20xakZHUTZIcmwxcFppdVNjUzdCUW1ZZ21lOHlmejc2dzY5cDVYVTNI?=
 =?utf-8?B?T01YaW9qSVI4bTBJWUFPUWx1QWkreURVek5LSmRSaklMUkhjMUVjNURyeWdQ?=
 =?utf-8?B?Uko1bmNFc0JjZ1BLc0d5S1hlajVyZ3RPd1JPN0llaFp1YTlyK1dVVWx6eEZv?=
 =?utf-8?B?NjRSVDZBRWMwejlUYlJkNEtFVHNKZ3gxNUdkdUI0emEvOW55S3JQSWJwYSs0?=
 =?utf-8?B?UTdxUVJMMTVsaTNFalQ5cDd6eWhMKzlqR0UwNDFmL0gvbTJhRGFTN0hYQm9k?=
 =?utf-8?B?S2d0djFQRVcxQkI4Vkk3TjFiWVE3em54Tmh4S2x1aDArekxZSWE1M1RIZytC?=
 =?utf-8?B?MzI1VjlEbi9yQkNXUXdPRmxhbXIxR0JyUHVreUhiOUhDNXB4VTRiVmpQcTZR?=
 =?utf-8?B?T3ZuN3UycnhBOVEzbktXTm1tTUo1VVpubHl5dy9yMW93TVFyWTFvQStlNXJ6?=
 =?utf-8?B?Y0NNTUVXSmJmY0hkQUhVQjZ4Q0NyL2s3SDJqS2NpTFJsOElacnVGR0pMRnUv?=
 =?utf-8?B?dld6R1NNUWhTdmRrOGJCNXlhSGR1K3R3WGUyTTZmcFpncll0MDNMaU9yZDZv?=
 =?utf-8?B?RTBxSjd6NitTZHA4cFJCLzZmSFo2dnlyWXUwTTRzSkJqalhnL2RFczZLV2wr?=
 =?utf-8?B?SEZ2THBVZGtMdHUrUHlnWGpzT1ZYa3dqOTZPQ2txR01WM0YxWTRkR0hraThX?=
 =?utf-8?B?UGc3ZHU5b2xNdHczMDNtdnpEaU9jRzk0dVUyVTdFWGNaTGpPK29oei9IWm5y?=
 =?utf-8?B?dEVPQnZiVzFyRFk2WTZ4SHE3TGRUSU5pZkJrVkNaMUgyeXJiZTA0eFErYlZK?=
 =?utf-8?B?ZjRadXJ4ZytPdzcwL2diOTgrRDJ6dHVsQ3poNmxWd3FXZ01UVzlpSkRJM0Na?=
 =?utf-8?B?dytuTTBGNFJKRStGMjhtWmYxckwxT2REYW0wa3huOFBIYzR1RHhxei9ZazZt?=
 =?utf-8?B?MnJ5QU1VT3JiWnBodHFWNFZOcE1pdG44WUNoMDgyVHkrSm9iMFdKUVBScFBQ?=
 =?utf-8?B?ZEJWbVE4T2lOWXQxYlNndlNxN1k5V3h4TDlESlhiM1dSZjgxYmEvZFRjd0FD?=
 =?utf-8?B?N1NURjFNVms4cFNLMUtIejN2VmZvMGNtbG5PemE3WVZmejlJalRWT09CUnVq?=
 =?utf-8?B?cjIwcXRRNUlnOUxPMDRkaEN1emowOHpUaWhwS3I4b20rT1QzTzI2aklSSk5a?=
 =?utf-8?Q?+x5sp2lvMUSigCpkIxluk74=3D?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(35042699022)(376014)(7416014)(1800799024)(36860700013)(82310400026)(14060799003)(13003099007)(7142099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5GpOWDe2ueVHpMc79nFedUZQjMkxOfHKDFDawkAf57jUh8G0zuje6Ug3YzJSv64sumks5PakN8R+zWfk1GuniVYJkIn6BodTbsiGzQI0Dcpqz+godMVR1sMoDtVP4bmVYnOgNoPVSESTPFJi8l0fiK91NbPLiaFlx4sa5b71v59Y3HI4l7+tjk58+wzxj9ekZJcfsP+ma9x1+bAAZCLmlnxVL6LHxe55jH4JjiX9s9GQ1XwSGShjbFzjEKU8+qmRYjTsvv0Zr8UrLDJQ9gH/4vFfQJzIAgqXFllvBOaR6aNPUCCCuPfUdSWg5UMuhhwJVhtMYcAvgauwBqEXHno2uLISPptdoM+qyo5hmJJBzFGI7N7SWyQgF0ft/LPqA3Q6d/qv3eFwimtaSZqrScAbAW8v2ku4ZoTkFo21WaJHYzCm+GlnKl5E5phFxdNosAF4
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 14:20:20.7694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa09203-d66a-4579-7762-08de73afd7da
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR06MB6903

QW0gTWl0dHdvY2gsIGRlbSAxOC4wMi4yMDI2IHVtIDEzOjUzICswMDAwIHNjaHJpZWIgS2VwcGxp
bmdlci1Ob3Zha292aWMgTWFydGluOgo+IEFtIE1pdHR3b2NoLCBkZW0gMTguMDIuMjAyNiB1bSAw
OTo0MiArMDAwMCBzY2hyaWViIEtlcHBsaW5nZXItTm92YWtvdmljCj4gTWFydGluOgo+ID4gQW0g
TWl0dHdvY2gsIGRlbSAxOC4wMi4yMDI2IHVtIDA5OjIyICswMDAwIHNjaHJpZWIgS2VwcGxpbmdl
ci0KPiA+IE5vdmFrb3ZpYwo+ID4gTWFydGluOgo+ID4gPiBBbSBNaXR0d29jaCwgZGVtIDE4LjAy
LjIwMjYgdW0gMTA6MDYgKzAxMDAgc2NocmllYiBJZ25hdCBLb3JjaGFnaW46Cj4gPiA+ID4gT24g
V2VkLCBGZWIgMTgsIDIwMjYgYXQgOTozNuKAr0FNIEtlcHBsaW5nZXItTm92YWtvdmljIE1hcnRp
bgo+ID4gPiA+IDxNYXJ0aW4uS2VwcGxpbmdlci1Ob3Zha292aWNAZ2luemluZ2VyLmNvbT4gd3Jv
dGU6Cj4gPiA+ID4gPiAKPiA+ID4gPiA+IEFtIERvbm5lcnN0YWcsIGRlbSAxMi4wMi4yMDI2IHVt
IDExOjE1ICswMDAwIHNjaHJpZWIgSWduYXQKPiA+ID4gPiA+IEtvcmNoYWdpbjoKPiA+ID4gPiA+
ID4gSGksCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBPbiBUaHUsIEZlYiAxMiwgMjAyNiBhdCAx
MDozOeKAr0FNIE1hcnRpbiBLZXBwbGluZ2VyLU5vdmFrb3ZpYwo+ID4gPiA+ID4gPiA8bWFydGlu
LmtlcHBsaW5nZXItbm92YWtvdmljQGdpbnppbmdlci5jb20+IHdyb3RlOgo+ID4gPiA+ID4gPiA+
IAo+ID4gPiA+ID4gPiA+IFdoZW4gZGVidWdnaW5nIFJTQSBjZXJ0aWZpY2F0ZSB2YWxpZGF0aW9u
IGl0IGNhbiBiZQo+ID4gPiA+ID4gPiA+IHZhbHVhYmxlCj4gPiA+ID4gPiA+ID4gdG8KPiA+ID4g
PiA+ID4gPiBzZWUKPiA+ID4gPiA+ID4gPiB3aHkgdGhlIFJTQSB2ZXJpZnkoKSBjYWxsYmFjayBy
ZXR1cm5zIC1FSU5WQUwuCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBOb3Qgc3VyZSBpZiB0aGlz
IHdvdWxkIGJlIHNvbWUga2luZCBvZiBhbiBpbmZvcm1hdGlvbiBsZWFrCj4gPiA+ID4gPiA+IChk
ZXBlbmRpbmcKPiA+ID4gPiA+ID4gb24gYSBzdWJzeXN0ZW0gdXNpbmcgUlNBKS4gQWxzbyB3aGF0
IG1ha2VzIHRoaXMgY2FzZSBzbwo+ID4gPiA+ID4gPiBzcGVjaWFsPwo+ID4gPiA+ID4gPiBTaG91
bGQgd2UgdGhlbiBhbm5vdGF0ZSBldmVyeSBvdGhlciB2YWxpZGF0aW9uIGNoZWNrIGluIHRoZQo+
ID4gPiA+ID4gPiBjb2RlPwo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBNYXJ0aW4gS2VwcGxpbmdlci1Ob3Zha292aWMKPiA+ID4gPiA+ID4gPiA8bWFydGluLmtlcHBs
aW5nZXItbm92YWtvdmljQGdpbnppbmdlci5jb20+Cj4gPiA+ID4gPiA+ID4gLS0tCj4gPiA+ID4g
PiA+ID4gCj4gPiA+ID4gPiA+ID4gaGksCj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gbXkg
cmVhbCBpc3N1ZSBpczogV2hlbiB1c2luZyBhIGNlcnRpZmljYXRlIGJhc2VkIG9uIGFuIFJTQS0K
PiA+ID4gPiA+ID4gPiBrZXksCj4gPiA+ID4gPiA+ID4gSSBzb21ldGltZXMgc2VlIHNpZ25hdHVy
ZS12ZXJpZnkgZXJyb3JzIGFuZCAodmlhIGRtLXZlcml0eSkKPiA+ID4gPiA+ID4gPiByb290ZnMg
c2lnbmF0dXJlLXZlcmlmeSBlcnJvcnMsIGFsbCB0cmlnZ2VyZWQgYnkgIm5vCj4gPiA+ID4gPiA+
ID4gbGVhZGluZwo+ID4gPiA+ID4gPiA+IDAKPiA+ID4gPiA+ID4gPiBieXRlIi4KPiA+ID4gPiA+
ID4gPiAKPiA+ID4gPiA+ID4gPiBrZXkvY2VydCBnZW5lcmF0aW9uOgo+ID4gPiA+ID4gPiA+IG9w
ZW5zc2wgcmVxIC14NTA5IC1uZXdrZXkgcnNhOjQwOTYgLWtleW91dCBjYV9rZXkucGVtIC1vdXQK
PiA+ID4gPiA+ID4gPiBjYS5wZW0gLQo+ID4gPiA+ID4gPiA+IG5vZGVzIC1kYXlzIDM2NSAtc2V0
X3NlcmlhbCAwMSAtc3ViaiAvQ049Z2luemluZ2VyLmNvbQo+ID4gPiA+ID4gPiA+IGFuZCBzaW1w
bHkgdXNlZCBhcyB0cnVzdGVkIGJ1aWx0LWluIGtleSBhbmQgcm9vdGZzIGhhc2gKPiA+ID4gPiA+
ID4gPiBzaWduCj4gPiA+ID4gPiA+ID4gYXBwZW5kZWQKPiA+ID4gPiA+ID4gPiB0byByb290ZnMg
KHNxdWFzaGZzKS4KPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBJJ20gb24gaW14NnVsLiBU
aGUgdGhpbmcgaXM6IFVzaW5nIHRoZSBzYW1lCj4gPiA+ID4gPiA+ID4gY2VydGlmaWNhdGUva2V5
LAo+ID4gPiA+ID4gPiA+IHdvcmtzCj4gPiA+ID4gPiA+ID4gb24KPiA+ID4gPiA+ID4gPiBvbGQg
djUuNC1iYXNlZCBrZXJuZWxzLCB1cCB0byB2Ni42IQo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4g
PiA+IFN0YXJ0aW5nIHdpdGggY29tbWl0IDJmMWYzNGMxYmY3YjMwOSAoImNyeXB0bzogYWhhc2gg
LQo+ID4gPiA+ID4gPiA+IG9wdGltaXplCj4gPiA+ID4gPiA+ID4gcGVyZm9ybWFuY2UKPiA+ID4g
PiA+ID4gPiB3aGVuIHdyYXBwaW5nIHNoYXNoIikgaXQgc3RhcnRzIHRvIGJyZWFrLiBpdCBpcyBu
b3QgYQo+ID4gPiA+ID4gPiA+IGNvbW1pdAo+ID4gPiA+ID4gPiA+IG9uCj4gPiA+ID4gPiA+ID4g
aXQncyBvd24gSQo+ID4gPiA+ID4gPiA+IGNhbiByZXZlcnQgYW5kIG1vdmUgb24uCj4gPiA+ID4g
PiA+ID4gCj4gPiA+ID4gPiA+ID4gV2hhdCBoYXBwZW5kZWQgc2luY2UgdjYuNiA/IE9uIHY2Ljcg
SSBzZWUKPiA+ID4gPiA+ID4gPiBbwqDCoMKgIDIuOTc4NzIyXSBjYWFtX2pyIDIxNDIwMDAuanI6
IDQwMDAwMDEzOiBERUNPOiBkZXNjIGlkeAo+ID4gPiA+ID4gPiA+IDA6Cj4gPiA+ID4gPiA+ID4g
SGVhZGVyIEVycm9yLiBJbnZhbGlkIGxlbmd0aCBvciBwYXJpdHksIG9yIGNlcnRhaW4gb3RoZXIK
PiA+ID4gPiA+ID4gPiBwcm9ibGVtcy4KPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBhbmQg
bGF0ZXIgdGhlIGFib3ZlIC1FSU5WQUwgZnJvbSB0aGUgUlNBIHZlcmlmeSBjYWxsYmFjaywKPiA+
ID4gPiA+ID4gPiB3aGVyZQo+ID4gPiA+ID4gPiA+IEkKPiA+ID4gPiA+ID4gPiBhZGQKPiA+ID4g
PiA+ID4gPiB0aGUgZGVidWcgcHJpbnRpbmcgSSBzZWUuCj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4g
PiA+ID4gV2hhdCdzIHRoZSBkZWFsIHdpdGggdGhpcyAibGVhZGluZyAwIGJ5dGUiPwo+ID4gPiA+
ID4gPiAKPiA+ID4gPiA+ID4gU2VlIFJGQyAyMzEzLCBwIDguMQo+ID4gPiA+ID4gCj4gPiA+ID4g
PiBoaSBJZ25hdCwKPiA+ID4gPiA+IAo+ID4gPiA+ID4gdGhhbmtzIGZvciB5b3VyIHRpbWUsIHRo
ZSBwcm9ibGVtIGlzICpzb21ldGltZXMqIHJzYSB2ZXJpZnkKPiA+ID4gPiA+IGZhaWxzLgo+ID4g
PiA+ID4gdGhlcmUgc2VlbXMgdG8gYmUgYSByYWNlIGNvbmRpdGlvbjoKPiA+ID4gPiAKPiA+ID4g
PiBDYW4geW91IGNsYXJpZnkgdGhlIGZhaWx1cmUgY2FzZSBhIGJpdD8gSXMgdGhpcyB0aGUgc2Ft
ZQo+ID4gPiA+IHNpZ25hdHVyZQo+ID4gPiA+IHRoYXQgZmFpbHM/IChUaGF0IGlzLCB5b3UganVz
dCB2ZXJpZnkgYSBmaXhlZCBzaWduYXR1cmUgaW4gYQo+ID4gPiA+IGxvb3ApCj4gPiA+ID4gT3IK
PiA+ID4gPiBhcmUgdGhlc2UgZGlmZmVyZW50IHNpZ25hdHVyZXM/IChzb21lIHJlbGlhYmx5IHZl
cmlmeSBhbmQgc29tZQo+ID4gPiA+IHJlbGlhYmx5IGZhaWwpCj4gPiA+ID4gCj4gPiA+IAo+ID4g
PiBkaWZmZXJlbnQgc2lnbnVhdHVyZXMgYnV0IG5vdGhpbmcgc3BlY2lhbDogSSBhZGQgY2EucGVt
IChvdXRwdXQgb2YKPiA+ID4gIm9wZW5zc2wgcmVxIC14NTA5IC1uZXdrZXkgcnNhOjQwOTYgLWtl
eW91dCBjYV9rZXkucGVtIC1vdXQgY2EucGVtCj4gPiA+IC0KPiA+ID4gbm9kZXMgLWRheXMgMzY1
IC1zZXRfc2VyaWFsIDAxIC1zdWJqIC9DTj1naW56aW5nZXIuY29tIikgdG8KPiA+ID4gQ09ORklH
X1NZU1RFTV9UUlVTVEVEX0tFWVMKPiA+ID4gCj4gPiA+IGR1cmluZyBib290LCBhc3ltbWV0cmlj
X2tleV9wcmVwYXJzZSgpIGlzIGNhbGxlZCwgZmlyc3Qgb24gdGhpcywKPiA+ID4gYW5kCj4gPiA+
IGFmdGVyIHRoYXQsICJjZmc4MDIxMTogTG9hZGluZyBjb21waWxlZC1pbiBYLjUwOSBjZXJ0aWZp
Y2F0ZXMgZm9yCj4gPiA+IHJlZ3VsYXRvcnkgZGF0YWJhc2UiIGRvZXMgdGhlIHNhbWUgdGhpbmcg
Zm9yIENoZW4tWXUsIFNldGgncyBrZXlzCj4gPiA+IGluCj4gPiA+IG1haW5saW5lIG5ldC93aXJl
bGVzcy9jZXJ0cyB3aGVyZSBJIGFsc28gYWRkZWQgQmVuJ3MgRGViaWFuCj4gPiA+IGNlcnRpZmlj
YXRlLgo+ID4gPiAKPiA+ID4gVGhlIGFib3ZlIHZlcmlmaWNhdGlvbnMgb2YgNSBrZXlzIGZhaWwg
cmFuZG9tbHkuCj4gPiA+IAo+ID4gCj4gPiB0byBjbGFyaWZ5OiBubyB2ZXJpZmljYXRpb24gcmVs
aWFibHkgZmFpbHMgb3Igc3VjY2VlZHMuIHRoZSBmaXJzdAo+ID4gb25lLAo+ID4gbXkgb3duIGNl
cnQsIG1vc3RseSAoYWx3YXlzPykgc3VjY2VlZHMsIGZvciB0aGUgNCByZWdkYiBjZXJ0cyBJIHNl
ZQo+ID4gbm8KPiA+IHBhdHRlcm4gYXQgYWxsLiBDaGVuLVl1J3MgIndlbnMiIGNlcnQga2luZCBv
ZiBmYWlscyBtb3JlIG9mdGVuIHRoYXQKPiA+IHRoYW4gdGhlIG90aGVycyBtYXliZS4KPiA+IAo+
ID4gVGhlcmUgaXMgYWxtb3N0IG5ldmVyIGEgYm9vdCB3aGVyZSBhbGwgY2VydHMgdmVyaWZpY2F0
aW9ucyBzdWNjZWVkLAo+ID4gYWx0aG91Z2ggSSd2ZSBzZWVuIGF0IGxlYXN0IG9uZSBhbHJlYWR5
Lgo+ID4gCj4gPiAKPiA+ID4gSW4gdGhlIGVuZCBJICh3YW50IHRvKSB1c2UgbXkgb3duIGNlcnQg
Zm9yIGRtLXZlcml0eSByb290ZnMgbG9hZGluZwo+ID4gPiAod2hpY2ggYWxzbyByYW5kb21seSBm
YWlscykuCj4gPiA+IAo+ID4gPiBvbiBvbGQga2VybmVscywgbW9zdCBsaWtlbHkgdXAgdG8gdjYu
NiwgdGhlcmUgd2FzIG5vIHByb2JsZW0uCj4gPiA+IAo+ID4gPiB0aGFuayB5b3UgZm9yIGFza2lu
ZywKPiA+ID4gCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1hcnRpbgo+ID4gPiAKPiA+ID4gCj4gPiA+ID4gPiBpbiB0
aGUgZmFpbHVyZS1jYXNlIGFmdGVyIGNyeXB0b19ha2NpcGhlcl9lbmNyeXB0KCkgYW5kCj4gPiA+
ID4gPiBjcnlwdG9fd2FpdF9yZXEoKSB0aGUgKnNhbWUqIGRhdGEgYXMgYmVmb3JlIGlzIHN0aWxs
IGF0Cj4gPiA+ID4gPiBvdXRfYnVmIQo+ID4gPiA+ID4gdGhhdAo+ID4gPiA+ID4gaGFzIG5vdCB5
ZXQgYmVlbiB3cml0dGVuIHRvLgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBJdCdzIG5vdCB0aGF0IG9i
dmlvdXMgdG8gYmUgeWV0IGJlY2F1c2UgbXNsZWVwKDEwMDApIGRvZXNuJ3QKPiA+ID4gPiA+IGNo
YW5nZQo+ID4gPiA+ID4gbXVjaCBhbmQgMDAsIDAxLCBmZiwgZmYuLi4gaXMgKnN0aWxsKiBub3Qg
eWV0IHdyaXR0ZW4gdG8KPiA+ID4gPiA+IG91dF9idWYhCj4gCj4gb2gsIEkgbWlnaHQgaGF2ZSBi
ZWVuIG9uIGEgc2xpZ2h0bHkgd3JvbmcgcGF0aDogSSdtIG9uIGlteDZ1bCBhbmQKPiBkaXNhYmxp
bmcgQ09ORklHX0NSWVBUT19ERVZfRlNMX0NBQU0gaW5kZWVkIGlzIGEgd29ya2Fyb3VuZCwgc28g
aXQncwo+IHByb2JhYmx5IGRyaXZlcnMvY3J5cHRvL2NhYW0vIHdoZXJlIGVucXVldWUgKyBkZXF1
ZXVlIHByb3Blcmx5IHJ1biwgYnV0Cj4gc3RpbGwgdGhlIENQVSBkb2Vzbid0IHNlZSB1cGRhdGVk
IGRhdGEuCj4gCj4gSSBhZGRlZCBIb3JpYSwgUGFua2FqIGFuZCBHYXVyYXYgYW5kIHdpdGggbHVj
ayB0aGV5IHNlZSB3aGF0IGNvdWxkIGdvCj4gd3JvbmcgaGVyZSB3aXRoIENBQU0tRE1BL0NQVSBz
eW5jaW5nLgoKCkkgd3JvdGUgYSBtb3JlIGFjY3VyYXRlIGFuZCBkZXRhaWxlZCBidWdyZXBvcnQg
Zm9yIHRoaXMsIHNlZQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vNjAyOWFj
YzBmMGRkZmUyNWUyNTM3YzI4NjZkNTRmZDdmNTRiYzE4Mi5jYW1lbEBnaW56aW5nZXIuY29tL1Qv
I3UKCnRoYW5rcywKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWFydGluCg==
