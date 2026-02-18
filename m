Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022093.outbound.protection.outlook.com [52.101.66.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AAC32863F;
	Wed, 18 Feb 2026 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771422817; cv=fail; b=DvxLoMmOeMEzsTiSABbTKYH7s9uWRxwEhWs7vnXTf7+pKGY3cv+5E3p3yfoGmRsFCPG0YL066Me8nTAnJP7Ld/fXUMON98qR2tTRqCNhqIIEEWf4pPmTVWVFv5HRqApDd3A+Lf1/kotgolSNIq6Yi8XMZl/buO+oKdOHmSYFSkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771422817; c=relaxed/simple;
	bh=L4vgWEuhWoQSpc9kGP2JKxmDb7mMxhQ+msfydHi7jUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LZEhyYT3IqWesLpevYAV5JicbRghJR9Vv7M4XzXnW08ibswiT6b1nbP5c7CrgDkxdhjMYL6+DWM2UWdGV0xkgZLXjW6/rELK3VCZokFB89idIgdJque6LFjOQn69h8xVNGXNZaHgCo09s20qnnFmZcsfxomPNEgfsHsWW4QxT8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=14uoTJXw; arc=fail smtp.client-ip=52.101.66.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="14uoTJXw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnD5uljlos2Ex5L+1b+HPe2e5whcl9leasvO96IfYZiS50MI/I8nEEXVejHlvB504xD7dUURCvHWezv98Ul/ftKNa16Vq6MZhTeUFq88YGOdZ4EsgQOUUOZX+kTXxW7YPVrNR3OLhmjqoD2JHaC590dtN4SiItcTQ7Y+tejcVUhjTwihOLXTrtDYd80cEJdX/CqWg62JCfQAcTYsIlR5tEKGEnCBlFBpwAw+O1nrQwnlSfb079TEiEfWPxBSvNeO2h6k1qOjnT0DM9/dcOctbCISdtqAvxOt2N7RttASwQB+b7qta4a/PDSj/jcvAEKMuVShirk2jSU3mQDtS6sAsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4vgWEuhWoQSpc9kGP2JKxmDb7mMxhQ+msfydHi7jUQ=;
 b=Rmw6gcjbCkynRvYrTuUVAmqTmFvB8nQ6GbF3siZp11mssgfvGlULYtZIfVb3HJXPT3/lcg4DQ6nd9ZlnR7Q7q/qrBe5uQB+D8AMslF1e4j8H7FIS2yvy5YoeNzfX+8iWABd3emdbx49gAEINzHGL3zxN8yBOwOGtZrmnun+kfts75XStpWFXPYxdlrDj/6q1smiUIvvJHhCHYcxwLXtUeh/SBaq69aYdz2PRz2mb5Ztf8RCs1fh8UZvdWYlwES7M6qpo+rzRxmphQMtpPxqTAQhjBO5KamOAYLCV6AAxWS0lFHUX0WWlMeLybU2JSlLIi31YDF3bSONYwGpRt7z52A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=cloudflare.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4vgWEuhWoQSpc9kGP2JKxmDb7mMxhQ+msfydHi7jUQ=;
 b=14uoTJXw0gs7iDtcPxdnvHFp+CMN9Wz/aFQ+EKc0w+/9NJawDdK9UMhBfD2Ambo6y9mi1cflbfqpsw3NeXEkCC61jTg1/CGqN0niyakJxHBSblSBv3Jq7EkXreW76SoxTK/GOjnFnNPzGFQY07C2Zlh6kNRPu4C33p8+g+s+Zn9vAfQ5Yhy29Gb1lMoKz1PZin6LZnxZy2JmtbHWeZwgkod8Mik1NklREQncDvxYxvKEKlnvqDViZo/L5+Ahti4R4s8c4sxg2mBLIRanSo9itFjGa/4CrSGxscKrGjBglir/4uMeivO2lVfWmrcQ+KFebMCN6WfPu264ZDaKZaTsfg==
Received: from DU6P191CA0048.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::7) by
 AM8PR06MB6882.eurprd06.prod.outlook.com (2603:10a6:20b:1de::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 18 Feb 2026 13:53:29 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::d7) by DU6P191CA0048.outlook.office365.com
 (2603:10a6:10:53f::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 13:53:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 13:53:28 +0000
Received: from GV1PR07CU001.outbound.protection.outlook.com (40.93.214.96) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 18 Feb 2026 13:53:27 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by AS5PR06MB10103.eurprd06.prod.outlook.com (2603:10a6:20b:6c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 13:53:25 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 13:53:25 +0000
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
Thread-Index: AQHcnAvkIbtDqneDG0+UC7zie+MHU7V+6bUAgAlBhQCAAAhggIAABG+AgAAFpgCAAEYfAA==
Date: Wed, 18 Feb 2026 13:53:25 +0000
Message-ID: <0b27d03d6b950d0fc6f2c19c40b792bf3cf2a677.camel@ginzinger.com>
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
			 <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
			 <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
			 <CALrw=nFCizuZ3Cko3LnAGb8A=4KB+=HdgoZDjqPgU=ssAK0hJg@mail.gmail.com>
		 <957c4cebc0c479532c8ce793ad093235e30acc77.camel@ginzinger.com>
	 <2545c85aa50e7aaac503ed076fdb47ee9c15791f.camel@ginzinger.com>
In-Reply-To: <2545c85aa50e7aaac503ed076fdb47ee9c15791f.camel@ginzinger.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|AS5PR06MB10103:EE_|DB1PEPF000509E5:EE_|AM8PR06MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a41d0e-9ff3-42a6-342b-08de6ef51861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7142099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TWZRdDFXZm5tV1FVVUhwWitDTUZtdGJ1Y1hGaXFQcExHTUt6QW9GbnRiTnpI?=
 =?utf-8?B?M1ZxRGFBSHVYaHViaXRJZnVhV2hGbFlra3JYd0U0eVRVT0dCNG9wN0c3dSs2?=
 =?utf-8?B?VkRma0xaMXc1eFI5TUtqLzN0cXZzL0xQajdVODB5bWR4NHFkMDNJZWxGaGNk?=
 =?utf-8?B?cVVzSDFSNDQ2MmNmemNCTENhVTlScHUwdG83clB0dUhUeFVBdi9hSUo2NTAw?=
 =?utf-8?B?Yjd0SktKVjVHajdhRm1aSndWdXlNNkJEYXZ3MkVrK2tQUHUrU0hzQXpFMDRu?=
 =?utf-8?B?aUlwWkhkbThYR1dOQ2h1bW5PUm1mL0VnWEhuSTBldjZrdXJUWENyMlRSYUs1?=
 =?utf-8?B?K2toMFlOS09VMVpWM3o4dDhFcm9YQmkwa0wrNVZhNHkvWHJITDVnYUNEWmtJ?=
 =?utf-8?B?RGlaMy9ucDgxcUdQQW5LY1dlNVBSWW9nbE9YTzN6SUxXRWJkWFp0ZHBudDVh?=
 =?utf-8?B?bk90L2k4NS9FUFNmaS9FUXgvZWtyWmlLT0wxY0l0ZGlnYVRNNmZCajhoeUUz?=
 =?utf-8?B?emVoazdOZU05ZjhhaUhhWUtmNnRWWkRiaVNCNkZNcExzRENxc3JBbU5JVTc4?=
 =?utf-8?B?b25WNHoxaC9xN2JkL2U1Mmh2RVl0eFRBcUJmckJQcE5YTGY1TDU2aFBoeVNi?=
 =?utf-8?B?dWx4a1lVTVptd0hzWEVqS09HRXRBZjVWN0NsZUdFSlJTVEdscU5HMmZCTmRk?=
 =?utf-8?B?dmJzWHQ3c0twL0ZXQ1hUMW1Yd21FenZJQ3RvY0NCdXY0aFo1UzdXZ25pQjFJ?=
 =?utf-8?B?VzRVSlFVZjhwczkvUWQ4NkNNdFZuMFlBTFJkZ1QxOW5MYWdQaTdkK3pKVjN4?=
 =?utf-8?B?bExrNlJSTE9YRWdTVjFUMUlVL09lbGN5ZUZEbm1adzd2Q1VvRXBYYXA4U3Zq?=
 =?utf-8?B?WnVFK1NQbW5wRHVBMHNPVlYrVlR1bDJNUDFhSlo5WG10MUw1akwzKy8vV0JF?=
 =?utf-8?B?cWdJSVJmNUl6V1h6UTZMLzFpTlRZVVdUc0xobjJHZGlPMk9Cby9CUERNSjF2?=
 =?utf-8?B?L1prUVN6T2tablc1TG14S1ViOUNEbXNWcytiUlRLRCt4b2tsaC9oNWZMTVQ4?=
 =?utf-8?B?M1U1d0hZblBPbUpBYk05QXg2alh2b0NBcURoOEJTR1Q2bnVGWTBINzVJS0ZL?=
 =?utf-8?B?ekI0TURTUk9oTHczVXk1R1FuR2RmaUk0azdLWWxmRE1BcC9GL3BKL1BPeTJ3?=
 =?utf-8?B?SXIzWDJKeG9uRDRYS1hXUjVHdzFVRFd5NHBGZmp1T0FlZzBHRWZmcExMUkJr?=
 =?utf-8?B?NStqTUllMTRicTExWTN5M0xRVUo5cmVlR2dGR2J1MEIxN0FzNVpOcGl0ZTBE?=
 =?utf-8?B?dVorbFVjRk9JZHBVZkVhTlQrMmE3OXRYZ251Q1h4YTFUZDJEdGNJQko4dHlP?=
 =?utf-8?B?RjI5VnNraHFXbWROb0liQ09qcjR6SURRVHh5bHB5djdveXJ1UGt2dHZBL0Rl?=
 =?utf-8?B?SkVBNWpScUcxYWRZZ202bWwzZmRLZ092QVJGVERyNjc3YlN0ZnZ2VTErczFa?=
 =?utf-8?B?eEFGWFJZNTEwQXJXNFl1YThZQVpjaUkwLzlvaW9ST1FCb3RRa2VJeEFTVnYv?=
 =?utf-8?B?SEV1YlF4U0p5U3YvYmVzU2I5Wjg3MUJWakFaWXhGTStRbTF0MWx4WUdQa21l?=
 =?utf-8?B?UTRIZnhXY2REMnA1bnQ4Qjd0K0R6dEh4VXZCcWZrTUw3OWlQTzVyNlZyeW5m?=
 =?utf-8?B?ZlNkaUY2NDVhRFo2aXplRW5ob2Rjald1bmZ1MXcxNk0wQmlOaDVlN0xRNjll?=
 =?utf-8?B?MzkwUklGandqVWVPMUJsMm1PdDQyZ1JYcTh2NXRQdjFVUkVFR21aWWs0YmlV?=
 =?utf-8?B?c2pXM3JEek95S3dXZWVucC9iQTlKbmIrcmdLdnFpdFBsazYvZGRsaE4yZDN3?=
 =?utf-8?B?SlJmbVNZUUx2S3hOcHJuNzJOZmtyaVZ3R0lCbFpmZDA3U1BxZTFmV1MrUzll?=
 =?utf-8?B?cXRUUjNaQ3R1cU01d3dWeGs4RzFFUG1RTXJ5RHk2OU52TzdUR3dUOVZvaDJ0?=
 =?utf-8?B?QmZLaHRieUdhM3pEaUtpbGhVWjE3NXZtMitSeitsU1FDMWVPc0RkTElxTGVy?=
 =?utf-8?B?R3haYzVVaDNrNUJWVzNVN1BtTkM3eDIzL3ZtMkJ2OXpNelNBaGNnamp6eDRU?=
 =?utf-8?B?eEtDNnVXMXIzS2hTa2o1S3RmMHRyZ2tsWHZBTUhRZkVrcHBqQll0WUUyODlU?=
 =?utf-8?Q?NtmO9HDaAI0UVQnYDeFMgdY=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7142099003)(38070700021);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A3A9CB3AADA6940BC3937BDE3E73E1B@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR06MB10103
X-CodeTwo-MessageID: defe6eb9-2f88-4adc-abff-bd07bc5e66ce.20260218135327@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d8df7760-25a5-4dcd-eaef-08de6ef5165c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|14060799003|376014|7416014|35042699022|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFdvWnY5NjdEMU1TZHA3Sm1FVjVRbXdjZExvQ24wY0R6VldnYTBrVXJMaURO?=
 =?utf-8?B?MkI1ZW5FNUFrME1ZQTl5bXVNUWNtbzcxNnpRL0ZXd2RqSWhONEdKZ09yS09Q?=
 =?utf-8?B?WDE3U25DQ1JSTE5EeitvVnpXekYxVmpzQ3VRT0tJZGYwa00vSFRjWGhNS1FP?=
 =?utf-8?B?L3ljU0ZnQ2RQczlrcnVDZHJEN05aNzBHanNJbzFkbG1pZUlPdHVTZi9lNXJ5?=
 =?utf-8?B?VzV0bjRxclhaMXhuU1JCblpTTGFYNmw5K0EySDk5MW9HZDA3TzJUeXJydXFN?=
 =?utf-8?B?eUFCNWtLRzBPY0JmejlGYnA5V2cwT0xkcnNCUENGdmdsYkM4NGJ2RlhPdFVj?=
 =?utf-8?B?by9FM3BiRVB0THZQeWFmeUdET3ArYlJVak9neFhHa2RWYXNWSjVUbnVjYlVj?=
 =?utf-8?B?SlcwaVZXWDFES1RLeGd3M2J0cTZzeVloZ2tSelR1c1A2S2hIdXU2VDhVVVpX?=
 =?utf-8?B?YlJRZms0bThUNis4bkRiL1N2KzB2aGhGYTE2eDJCdkttTWRpVHZCbWM4NW1F?=
 =?utf-8?B?Y051VXcxMzFESWVyRm5QWlNSK0srVklJSGg1VFlqM3RNNmdMeVYrQUFDN3Q3?=
 =?utf-8?B?eHpTeExhWHlvK2lNKzd3bVJWa2d1blBESGlKYXFwcjRJSG84Umo5WSsxbllh?=
 =?utf-8?B?amlLSmNqNlpWZC9ydm5yTDFyQXArbk16QUFDOWppZXd5VWtwcTVmZUtjbE5k?=
 =?utf-8?B?V3lWQnNIblkyQUxFY2k0ektON1QvZGpJWnhLSFdXMlZXWXZkN2E2cjlPQUJG?=
 =?utf-8?B?VVprRHZ3cEYxc0E1T2g4U3ZQTWJ6SDdLQUNzYlB2d09FMnBaN2ZscDV5YTEv?=
 =?utf-8?B?TUJsQW9SK3hnOWlpODExZmR6NmJadHZSbk5TRTRmT2VpWXE5LzRlcVhSWjNF?=
 =?utf-8?B?L1RwcWlBR0tCWlhtcEJhRlFxZGp2c2krMzBJTSs5enU5eXcxY01YbnZKWjFX?=
 =?utf-8?B?VFFRcWIxS3h6RWdQRDBRaS9ROXJmMzM4MDByWVVIZnhrZnpucGNqR3JXem93?=
 =?utf-8?B?VnA2aGhuQkZxK0UzdUZ6dUlWU0ErZjcvcnNRR2xwY1Y3SDFYc2RKNkUxZ2t3?=
 =?utf-8?B?N3NQQ2V1SzhGODIvbFo4cmxSUk5yNkNKSDlZMGdBN21Jc3c3eExQWTU0bnRZ?=
 =?utf-8?B?NHVFUU1jS0NzQUdhRXVWcFJGL3g1MWh4MC92cmM5bm1oTHpyMFV4dzMvVUhG?=
 =?utf-8?B?U3dJNjBoM3RLQmVPZnRqckNBYjRzUzhmUUtLcTVKMGtMekp0VTk4aThhTElL?=
 =?utf-8?B?YVpKcnlHTXZENzZDK3pPeFI5ZzlDMFJVTng2MUk4K0IxUEdDQit1aENsQTlq?=
 =?utf-8?B?RWlkemgyVjl1bkVwUXNkdGJhZVZDZ0dHTFlhd3dtenBZN2tJTlhBdlREdy9L?=
 =?utf-8?B?Z1JTSGN0aHA3dmtBaDJ3WUNOZEpEVi9MbThDY2ZkYkgxRHdZSFBtUlh6dmI1?=
 =?utf-8?B?RmNpVTV5eUFHV1ZLZlp3ZUtZeUFiUm5ZR0xQb1pNc0FWakRqa3pPcC9vd1Ey?=
 =?utf-8?B?eFZhM2IxdXF6dWlNNmhaajdTK1RhczVDR3F3VmExYXlVazloQXgrSStYaURG?=
 =?utf-8?B?djZtdEF0UzY3eGNQVG41TlVlN2kraWdUbE1ZaFV5ZG5SY08rK25sVnI5a3Fk?=
 =?utf-8?B?ampxeENPMWJMaTFWK2N5d0NRNEJGRnErd0N5M3ZNTXVJdUR0UjBYOFVsekFN?=
 =?utf-8?B?Q1hWb3d4blN6WHNLM0s0S0wwSzl4bi9UVjdiSDJLZW4wZVE2MVlUSGdreEJO?=
 =?utf-8?B?NldUejY2QUY3Zk5ZTkhFbDVWbE5HcVJ6aDJZTFpsZ1FvNVRCTHJ0M1g3QXNC?=
 =?utf-8?B?N3VPN0QvZlVNcHo3b3dVL1Z1V2N4M2hCOFpTRWFvT3VzbHVKZTJOUjEvOXYv?=
 =?utf-8?B?QmR1Zkd4VlpGdW5MU0NhVTNGSGpwODJkeE8xdEZFQi9NQkVpU2ZjQkUvSFR4?=
 =?utf-8?B?UUlXUXZqQXZQR1JGanhkdG01dXNlcFp1QlJ1Nk5PTGtGT2FnR0Q2UmwxYWRB?=
 =?utf-8?B?cFZueUFVMXRySlpOV213MUFkWjlJc05CWE81cndWakQ0cCt3Yllta1FaVGN5?=
 =?utf-8?B?QkxOVnVXb1lqRlMxcjVuWDRFLzJZUURyRDh1KzRVSFBRR2EzNDVTNUQ3Q1Ro?=
 =?utf-8?B?TmdiTXBHekFYYTBEbHoxd0JkWXFnRHBjVWRKYUNMTG16aGx2UHVnS2dUbDRu?=
 =?utf-8?B?dWtVQmVrU3U3UCtqWWI2QUpob3NTV1ZzMllkQVpEWWtwUlV5MjB4WmcreGFn?=
 =?utf-8?B?amxKSVBLQkpFL1hUWTZ4UFR3elZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(14060799003)(376014)(7416014)(35042699022)(1800799024)(7142099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MK68kGbocG0f5WOlXvUYju/ItjgvoD6KM+r0aLOEscpI4+TJ6coFomTahVxP6ryPZEjAU8RJBP+bcXfLFKiP27sFjoPjpg7RQfD9cMhtm82o8KL8HtD0bzIikz5ckaRQm8VULr6kB8n+OiJK5AWtwH63eEVpl5XIH1RLqLLzHmetYJvmSAwN0VeJ74yQmvFs7FulpT25OWHp/HwmIbxETXdQlxfMYYp3KVT22UX7pB9IZkgWFvLCTXpI+fxqOqHSrBE37L+xrzZl/LuQMYuY6GL8Yo7T14fQb+yH+bdX9/s8ikUuq2CLxOaSdF76FEsyXpo+xzAD52U1dJ7ixbJmlORchfDVjl1WY82rA94SeF+5cALIJxg0ce/qqZv2BnSTGvfj63GJG2c5sg3RK1wFhEWYClXWvOd8PZrCJlG3EoqqFpa73sSdFxDQvTJe0vvb
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 13:53:28.6506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a41d0e-9ff3-42a6-342b-08de6ef51861
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR06MB6882

QW0gTWl0dHdvY2gsIGRlbSAxOC4wMi4yMDI2IHVtIDA5OjQyICswMDAwIHNjaHJpZWIgS2VwcGxp
bmdlci1Ob3Zha292aWMKTWFydGluOgo+IEFtIE1pdHR3b2NoLCBkZW0gMTguMDIuMjAyNiB1bSAw
OToyMiArMDAwMCBzY2hyaWViIEtlcHBsaW5nZXItCj4gTm92YWtvdmljCj4gTWFydGluOgo+ID4g
QW0gTWl0dHdvY2gsIGRlbSAxOC4wMi4yMDI2IHVtIDEwOjA2ICswMTAwIHNjaHJpZWIgSWduYXQg
S29yY2hhZ2luOgo+ID4gPiBPbiBXZWQsIEZlYiAxOCwgMjAyNiBhdCA5OjM24oCvQU0gS2VwcGxp
bmdlci1Ob3Zha292aWMgTWFydGluCj4gPiA+IDxNYXJ0aW4uS2VwcGxpbmdlci1Ob3Zha292aWNA
Z2luemluZ2VyLmNvbT4gd3JvdGU6Cj4gPiA+ID4gCj4gPiA+ID4gQW0gRG9ubmVyc3RhZywgZGVt
IDEyLjAyLjIwMjYgdW0gMTE6MTUgKzAwMDAgc2NocmllYiBJZ25hdAo+ID4gPiA+IEtvcmNoYWdp
bjoKPiA+ID4gPiA+IEhpLAo+ID4gPiA+ID4gCj4gPiA+ID4gPiBPbiBUaHUsIEZlYiAxMiwgMjAy
NiBhdCAxMDozOeKAr0FNIE1hcnRpbiBLZXBwbGluZ2VyLU5vdmFrb3ZpYwo+ID4gPiA+ID4gPG1h
cnRpbi5rZXBwbGluZ2VyLW5vdmFrb3ZpY0BnaW56aW5nZXIuY29tPiB3cm90ZToKPiA+ID4gPiA+
ID4gCj4gPiA+ID4gPiA+IFdoZW4gZGVidWdnaW5nIFJTQSBjZXJ0aWZpY2F0ZSB2YWxpZGF0aW9u
IGl0IGNhbiBiZQo+ID4gPiA+ID4gPiB2YWx1YWJsZQo+ID4gPiA+ID4gPiB0bwo+ID4gPiA+ID4g
PiBzZWUKPiA+ID4gPiA+ID4gd2h5IHRoZSBSU0EgdmVyaWZ5KCkgY2FsbGJhY2sgcmV0dXJucyAt
RUlOVkFMLgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBOb3Qgc3VyZSBpZiB0aGlzIHdvdWxkIGJlIHNv
bWUga2luZCBvZiBhbiBpbmZvcm1hdGlvbiBsZWFrCj4gPiA+ID4gPiAoZGVwZW5kaW5nCj4gPiA+
ID4gPiBvbiBhIHN1YnN5c3RlbSB1c2luZyBSU0EpLiBBbHNvIHdoYXQgbWFrZXMgdGhpcyBjYXNl
IHNvCj4gPiA+ID4gPiBzcGVjaWFsPwo+ID4gPiA+ID4gU2hvdWxkIHdlIHRoZW4gYW5ub3RhdGUg
ZXZlcnkgb3RoZXIgdmFsaWRhdGlvbiBjaGVjayBpbiB0aGUKPiA+ID4gPiA+IGNvZGU/Cj4gPiA+
ID4gPiAKPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFydGluIEtlcHBsaW5nZXItTm92YWtv
dmljCj4gPiA+ID4gPiA+IDxtYXJ0aW4ua2VwcGxpbmdlci1ub3Zha292aWNAZ2luemluZ2VyLmNv
bT4KPiA+ID4gPiA+ID4gLS0tCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBoaSwKPiA+ID4gPiA+
ID4gCj4gPiA+ID4gPiA+IG15IHJlYWwgaXNzdWUgaXM6IFdoZW4gdXNpbmcgYSBjZXJ0aWZpY2F0
ZSBiYXNlZCBvbiBhbiBSU0EtCj4gPiA+ID4gPiA+IGtleSwKPiA+ID4gPiA+ID4gSSBzb21ldGlt
ZXMgc2VlIHNpZ25hdHVyZS12ZXJpZnkgZXJyb3JzIGFuZCAodmlhIGRtLXZlcml0eSkKPiA+ID4g
PiA+ID4gcm9vdGZzIHNpZ25hdHVyZS12ZXJpZnkgZXJyb3JzLCBhbGwgdHJpZ2dlcmVkIGJ5ICJu
bwo+ID4gPiA+ID4gPiBsZWFkaW5nCj4gPiA+ID4gPiA+IDAKPiA+ID4gPiA+ID4gYnl0ZSIuCj4g
PiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBrZXkvY2VydCBnZW5lcmF0aW9uOgo+ID4gPiA+ID4gPiBv
cGVuc3NsIHJlcSAteDUwOSAtbmV3a2V5IHJzYTo0MDk2IC1rZXlvdXQgY2Ffa2V5LnBlbSAtb3V0
Cj4gPiA+ID4gPiA+IGNhLnBlbSAtCj4gPiA+ID4gPiA+IG5vZGVzIC1kYXlzIDM2NSAtc2V0X3Nl
cmlhbCAwMSAtc3ViaiAvQ049Z2luemluZ2VyLmNvbQo+ID4gPiA+ID4gPiBhbmQgc2ltcGx5IHVz
ZWQgYXMgdHJ1c3RlZCBidWlsdC1pbiBrZXkgYW5kIHJvb3RmcyBoYXNoCj4gPiA+ID4gPiA+IHNp
Z24KPiA+ID4gPiA+ID4gYXBwZW5kZWQKPiA+ID4gPiA+ID4gdG8gcm9vdGZzIChzcXVhc2hmcyku
Cj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBJJ20gb24gaW14NnVsLiBUaGUgdGhpbmcgaXM6IFVz
aW5nIHRoZSBzYW1lCj4gPiA+ID4gPiA+IGNlcnRpZmljYXRlL2tleSwKPiA+ID4gPiA+ID4gd29y
a3MKPiA+ID4gPiA+ID4gb24KPiA+ID4gPiA+ID4gb2xkIHY1LjQtYmFzZWQga2VybmVscywgdXAg
dG8gdjYuNiEKPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+IFN0YXJ0aW5nIHdpdGggY29tbWl0IDJm
MWYzNGMxYmY3YjMwOSAoImNyeXB0bzogYWhhc2ggLQo+ID4gPiA+ID4gPiBvcHRpbWl6ZQo+ID4g
PiA+ID4gPiBwZXJmb3JtYW5jZQo+ID4gPiA+ID4gPiB3aGVuIHdyYXBwaW5nIHNoYXNoIikgaXQg
c3RhcnRzIHRvIGJyZWFrLiBpdCBpcyBub3QgYQo+ID4gPiA+ID4gPiBjb21taXQKPiA+ID4gPiA+
ID4gb24KPiA+ID4gPiA+ID4gaXQncyBvd24gSQo+ID4gPiA+ID4gPiBjYW4gcmV2ZXJ0IGFuZCBt
b3ZlIG9uLgo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gV2hhdCBoYXBwZW5kZWQgc2luY2UgdjYu
NiA/IE9uIHY2LjcgSSBzZWUKPiA+ID4gPiA+ID4gW8KgwqDCoCAyLjk3ODcyMl0gY2FhbV9qciAy
MTQyMDAwLmpyOiA0MDAwMDAxMzogREVDTzogZGVzYyBpZHgKPiA+ID4gPiA+ID4gMDoKPiA+ID4g
PiA+ID4gSGVhZGVyIEVycm9yLiBJbnZhbGlkIGxlbmd0aCBvciBwYXJpdHksIG9yIGNlcnRhaW4g
b3RoZXIKPiA+ID4gPiA+ID4gcHJvYmxlbXMuCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBhbmQg
bGF0ZXIgdGhlIGFib3ZlIC1FSU5WQUwgZnJvbSB0aGUgUlNBIHZlcmlmeSBjYWxsYmFjaywKPiA+
ID4gPiA+ID4gd2hlcmUKPiA+ID4gPiA+ID4gSQo+ID4gPiA+ID4gPiBhZGQKPiA+ID4gPiA+ID4g
dGhlIGRlYnVnIHByaW50aW5nIEkgc2VlLgo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gV2hhdCdz
IHRoZSBkZWFsIHdpdGggdGhpcyAibGVhZGluZyAwIGJ5dGUiPwo+ID4gPiA+ID4gCj4gPiA+ID4g
PiBTZWUgUkZDIDIzMTMsIHAgOC4xCj4gPiA+ID4gCj4gPiA+ID4gaGkgSWduYXQsCj4gPiA+ID4g
Cj4gPiA+ID4gdGhhbmtzIGZvciB5b3VyIHRpbWUsIHRoZSBwcm9ibGVtIGlzICpzb21ldGltZXMq
IHJzYSB2ZXJpZnkKPiA+ID4gPiBmYWlscy4KPiA+ID4gPiB0aGVyZSBzZWVtcyB0byBiZSBhIHJh
Y2UgY29uZGl0aW9uOgo+ID4gPiAKPiA+ID4gQ2FuIHlvdSBjbGFyaWZ5IHRoZSBmYWlsdXJlIGNh
c2UgYSBiaXQ/IElzIHRoaXMgdGhlIHNhbWUKPiA+ID4gc2lnbmF0dXJlCj4gPiA+IHRoYXQgZmFp
bHM/IChUaGF0IGlzLCB5b3UganVzdCB2ZXJpZnkgYSBmaXhlZCBzaWduYXR1cmUgaW4gYQo+ID4g
PiBsb29wKQo+ID4gPiBPcgo+ID4gPiBhcmUgdGhlc2UgZGlmZmVyZW50IHNpZ25hdHVyZXM/IChz
b21lIHJlbGlhYmx5IHZlcmlmeSBhbmQgc29tZQo+ID4gPiByZWxpYWJseSBmYWlsKQo+ID4gPiAK
PiA+IAo+ID4gZGlmZmVyZW50IHNpZ251YXR1cmVzIGJ1dCBub3RoaW5nIHNwZWNpYWw6IEkgYWRk
IGNhLnBlbSAob3V0cHV0IG9mCj4gPiAib3BlbnNzbCByZXEgLXg1MDkgLW5ld2tleSByc2E6NDA5
NiAta2V5b3V0IGNhX2tleS5wZW0gLW91dCBjYS5wZW0KPiA+IC0KPiA+IG5vZGVzIC1kYXlzIDM2
NSAtc2V0X3NlcmlhbCAwMSAtc3ViaiAvQ049Z2luemluZ2VyLmNvbSIpIHRvCj4gPiBDT05GSUdf
U1lTVEVNX1RSVVNURURfS0VZUwo+ID4gCj4gPiBkdXJpbmcgYm9vdCwgYXN5bW1ldHJpY19rZXlf
cHJlcGFyc2UoKSBpcyBjYWxsZWQsIGZpcnN0IG9uIHRoaXMsCj4gPiBhbmQKPiA+IGFmdGVyIHRo
YXQsICJjZmc4MDIxMTogTG9hZGluZyBjb21waWxlZC1pbiBYLjUwOSBjZXJ0aWZpY2F0ZXMgZm9y
Cj4gPiByZWd1bGF0b3J5IGRhdGFiYXNlIiBkb2VzIHRoZSBzYW1lIHRoaW5nIGZvciBDaGVuLVl1
LCBTZXRoJ3Mga2V5cwo+ID4gaW4KPiA+IG1haW5saW5lIG5ldC93aXJlbGVzcy9jZXJ0cyB3aGVy
ZSBJIGFsc28gYWRkZWQgQmVuJ3MgRGViaWFuCj4gPiBjZXJ0aWZpY2F0ZS4KPiA+IAo+ID4gVGhl
IGFib3ZlIHZlcmlmaWNhdGlvbnMgb2YgNSBrZXlzIGZhaWwgcmFuZG9tbHkuCj4gPiAKPiAKPiB0
byBjbGFyaWZ5OiBubyB2ZXJpZmljYXRpb24gcmVsaWFibHkgZmFpbHMgb3Igc3VjY2VlZHMuIHRo
ZSBmaXJzdAo+IG9uZSwKPiBteSBvd24gY2VydCwgbW9zdGx5IChhbHdheXM/KSBzdWNjZWVkcywg
Zm9yIHRoZSA0IHJlZ2RiIGNlcnRzIEkgc2VlCj4gbm8KPiBwYXR0ZXJuIGF0IGFsbC4gQ2hlbi1Z
dSdzICJ3ZW5zIiBjZXJ0IGtpbmQgb2YgZmFpbHMgbW9yZSBvZnRlbiB0aGF0Cj4gdGhhbiB0aGUg
b3RoZXJzIG1heWJlLgo+IAo+IFRoZXJlIGlzIGFsbW9zdCBuZXZlciBhIGJvb3Qgd2hlcmUgYWxs
IGNlcnRzIHZlcmlmaWNhdGlvbnMgc3VjY2VlZCwKPiBhbHRob3VnaCBJJ3ZlIHNlZW4gYXQgbGVh
c3Qgb25lIGFscmVhZHkuCj4gCj4gCj4gPiBJbiB0aGUgZW5kIEkgKHdhbnQgdG8pIHVzZSBteSBv
d24gY2VydCBmb3IgZG0tdmVyaXR5IHJvb3RmcyBsb2FkaW5nCj4gPiAod2hpY2ggYWxzbyByYW5k
b21seSBmYWlscykuCj4gPiAKPiA+IG9uIG9sZCBrZXJuZWxzLCBtb3N0IGxpa2VseSB1cCB0byB2
Ni42LCB0aGVyZSB3YXMgbm8gcHJvYmxlbS4KPiA+IAo+ID4gdGhhbmsgeW91IGZvciBhc2tpbmcs
Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1hcnRpbgo+ID4gCj4gPiAKPiA+ID4gPiBpbiB0aGUgZmFpbHVyZS1j
YXNlIGFmdGVyIGNyeXB0b19ha2NpcGhlcl9lbmNyeXB0KCkgYW5kCj4gPiA+ID4gY3J5cHRvX3dh
aXRfcmVxKCkgdGhlICpzYW1lKiBkYXRhIGFzIGJlZm9yZSBpcyBzdGlsbCBhdAo+ID4gPiA+IG91
dF9idWYhCj4gPiA+ID4gdGhhdAo+ID4gPiA+IGhhcyBub3QgeWV0IGJlZW4gd3JpdHRlbiB0by4K
PiA+ID4gPiAKPiA+ID4gPiBJdCdzIG5vdCB0aGF0IG9idmlvdXMgdG8gYmUgeWV0IGJlY2F1c2Ug
bXNsZWVwKDEwMDApIGRvZXNuJ3QKPiA+ID4gPiBjaGFuZ2UKPiA+ID4gPiBtdWNoIGFuZCAwMCwg
MDEsIGZmLCBmZi4uLiBpcyAqc3RpbGwqIG5vdCB5ZXQgd3JpdHRlbiB0bwo+ID4gPiA+IG91dF9i
dWYhCgpvaCwgSSBtaWdodCBoYXZlIGJlZW4gb24gYSBzbGlnaHRseSB3cm9uZyBwYXRoOiBJJ20g
b24gaW14NnVsIGFuZApkaXNhYmxpbmcgQ09ORklHX0NSWVBUT19ERVZfRlNMX0NBQU0gaW5kZWVk
IGlzIGEgd29ya2Fyb3VuZCwgc28gaXQncwpwcm9iYWJseSBkcml2ZXJzL2NyeXB0by9jYWFtLyB3
aGVyZSBlbnF1ZXVlICsgZGVxdWV1ZSBwcm9wZXJseSBydW4sIGJ1dApzdGlsbCB0aGUgQ1BVIGRv
ZXNuJ3Qgc2VlIHVwZGF0ZWQgZGF0YS4KCkkgYWRkZWQgSG9yaWEsIFBhbmthaiBhbmQgR2F1cmF2
IGFuZCB3aXRoIGx1Y2sgdGhleSBzZWUgd2hhdCBjb3VsZCBnbwp3cm9uZyBoZXJlIHdpdGggQ0FB
TS1ETUEvQ1BVIHN5bmNpbmcuCgo+ID4gPiA+IAo+ID4gPiA+IGlzIHRoZXJlIGEgcmVhc29uIHdo
eSBjcnlwdG9fYWtjaXBoZXJfc3luY197ZW4sZGV9Y3J5cHQoKSBpcwo+ID4gPiA+IG5vdAo+ID4g
PiA+IHVzZWQ/Cj4gPiA+ID4gQ2FuIHlvdSBpbWFnaW5lIHdoYXQgY291bGQgZ28gd3JvbmcgaGVy
ZT8KPiA+ID4gPiAKPiA+ID4gPiAqbWF5YmUqIGNvbW1pdCAxZTU2MmRlYWNlY2NhMWYxYmVjN2Qy
M2RhNTI2OTA0YTFlODc1MjVlIHRoYXQKPiA+ID4gPiBkaWQKPiA+ID4gPiBhCj4gPiA+ID4gbG90
Cj4gPiA+ID4gb2YgdGhpbmdzIGluIHBhcmFsbGVsIChpbiBvcmRlciB0byBrZWVwIGZ1bmN0aW9u
YWxpdHkgc2ltaWxhcikKPiA+ID4gPiBnb3QKPiA+ID4gPiBzb21ldGhpbmcgd3Jvbmc/Cj4gPiA+
ID4gCj4gPiA+ID4gc2lkZW5vdGU6IHdoZW4gSSB1c2UgYW4gZWxsaXB0aWMgY3VydmUga2V5IGlu
c3RlYWQgb2YgcnNhLAo+ID4gPiA+IGV2ZXJ5dGhpbmcKPiA+ID4gPiB3b3Jrcy4KPiA+ID4gPiAK
PiA+ID4gPiBhbHNvLCB0aGUgYXV0by1mcmVlIGZvciBjaGlsZF9yZXEgbG9va3MgYSBiaXQgZGFu
Z2Vyb3VzIHdoZW4KPiA+ID4gPiB1c2luZwo+ID4gPiA+IG91dF9idWYsIGJ1dCBvayA6KQo+ID4g
PiA+IAo+ID4gPiA+IG1heWJlIHRoaXMgcmluZ3MgYSBiZWxsLCBJJ2xsIGtlZXAgZGVidWdnaW5n
LAo+ID4gPiA+IAo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBtYXJ0aW4KPiA+ID4gPiAKPiA+ID4gPiAKPiA+ID4gPiA+IAo+ID4g
PiA+ID4gPiAKPiA+ID4gPiA+ID4gdGhhbmsgeW91IQo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBtYXJ0aW4KPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4g
PiAKPiA+ID4gPiA+ID4gwqBjcnlwdG8vcnNhLXBrY3MxcGFkLmMgfCA1ICsrKy0tCj4gPiA+ID4g
PiA+IMKgY3J5cHRvL3JzYXNzYS1wa2NzMS5jIHwgNSArKystLQo+ID4gPiA+ID4gPiDCoDIgZmls
ZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQo+ID4gPiA+ID4gPiAK
PiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2NyeXB0by9yc2EtcGtjczFwYWQuYyBiL2NyeXB0by9y
c2EtcGtjczFwYWQuYwo+ID4gPiA+ID4gPiBpbmRleCA1MGJkYjE4ZTdiNDgzLi42NWE0ODIxZTk3
NThiIDEwMDY0NAo+ID4gPiA+ID4gPiAtLS0gYS9jcnlwdG8vcnNhLXBrY3MxcGFkLmMKPiA+ID4g
PiA+ID4gKysrIGIvY3J5cHRvL3JzYS1wa2NzMXBhZC5jCj4gPiA+ID4gPiA+IEBAIC0xOTEsOSAr
MTkxLDEwIEBAIHN0YXRpYyBpbnQKPiA+ID4gPiA+ID4gcGtjczFwYWRfZGVjcnlwdF9jb21wbGV0
ZShzdHJ1Y3QKPiA+ID4gPiA+ID4gYWtjaXBoZXJfcmVxdWVzdCAqcmVxLCBpbnQgZXJyKQo+ID4g
PiA+ID4gPiAKPiA+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqAgb3V0X2J1ZiA9IHJlcV9jdHgtPm91
dF9idWY7Cj4gPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgIGlmIChkc3RfbGVuID09IGN0eC0+a2V5
X3NpemUpIHsKPiA+ID4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG91
dF9idWZbMF0gIT0gMHgwMCkKPiA+ID4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIC8qIERlY3J5cHRlZCB2YWx1ZSBoYWQgbm8gbGVhZGluZyAwCj4g
PiA+ID4gPiA+IGJ5dGUgKi8KPiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKG91dF9idWZbMF0gIT0gMHgwMCkgewo+ID4gPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJfZGVidWcoIkRlY3J5cHRlZCB2YWx1ZSBo
YWQgbm8KPiA+ID4gPiA+ID4gbGVhZGluZyAwCj4gPiA+ID4gPiA+IGJ5dGVcbiIpOwo+ID4gPiA+
ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8g
ZG9uZTsKPiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+ID4gPiA+
ID4gPiAKPiA+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRzdF9sZW4t
LTsKPiA+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG91dF9idWYrKzsK
PiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2NyeXB0by9yc2Fzc2EtcGtjczEuYyBiL2NyeXB0by9y
c2Fzc2EtcGtjczEuYwo+ID4gPiA+ID4gPiBpbmRleCA5NGZhNWU5NjAwZTc5Li4yMjkxOTcyOGVh
MWM4IDEwMDY0NAo+ID4gPiA+ID4gPiAtLS0gYS9jcnlwdG8vcnNhc3NhLXBrY3MxLmMKPiA+ID4g
PiA+ID4gKysrIGIvY3J5cHRvL3JzYXNzYS1wa2NzMS5jCj4gPiA+ID4gPiA+IEBAIC0yNjMsOSAr
MjYzLDEwIEBAIHN0YXRpYyBpbnQgcnNhc3NhX3BrY3MxX3ZlcmlmeShzdHJ1Y3QKPiA+ID4gPiA+
ID4gY3J5cHRvX3NpZyAqdGZtLAo+ID4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoCBpZiAoZHN0X2xlbiA9PSBjdHgtPmtleV9zaXplKSB7Cj4gPiA+ID4gPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChvdXRfYnVmWzBdICE9IDB4MDApCj4gPiA+ID4gPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBFbmNyeXB0
ZWQgdmFsdWUgaGFkIG5vIGxlYWRpbmcgMAo+ID4gPiA+ID4gPiBieXRlICovCj4gPiA+ID4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChvdXRfYnVmWzBdICE9IDB4MDApIHsK
PiA+ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHByX2RlYnVnKCJFbmNyeXB0ZWQgdmFsdWUgaGFkIG5vCj4gPiA+ID4gPiA+IGxlYWRpbmcgMAo+
ID4gPiA+ID4gPiBieXRlXG4iKTsKPiA+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiA+ID4gPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRzdF9sZW4tLTsKPiA+ID4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG91dF9idWYrKzsKPiA+ID4gPiA+ID4gLS0KPiA+ID4gPiA+
ID4gMi40Ny4zCj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gCj4gPiA+ID4gPiBJZ25hdAo=
