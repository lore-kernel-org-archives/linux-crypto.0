Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023132.outbound.protection.outlook.com [52.101.83.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EBE324B1C;
	Wed, 25 Feb 2026 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772009237; cv=fail; b=UwafKbg6uVTZbQQzu19sR6l4c8bkT0E5T798LyYmWkxFYR3+2Vxnel8BCsRJUpw/ihJItDKZ9M2DC4rgYbo2ZnTno81lvB4bKm3DmUKiwg3qAc21GdIKg3hgBGlk0pqygqbFNceh1GmCBcI+XdcnadAUWI1r0N8ftzN/7NDaiac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772009237; c=relaxed/simple;
	bh=mks7Sk5ZC3twtKR9adModZmKvp5ZvBPJv50AoFgozic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eTX/822lYLlnlZ6cKIdbe4U/UFooSSacjeYKlNnH2ePkZ6ZSZ90DZC7yVSL+P0lVXfD8C0iyOsTLQ/tR3G9w8W5SJmoaVI6iPnxmskPCCHuvG7fu7V8RbdfB8+1ToAsLPyL6EoNxyvWjm+5q1u4/YU7QdMyFFWxkit1f0HPCfLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=CwUBuXlS; arc=fail smtp.client-ip=52.101.83.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="CwUBuXlS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqDJdyfsHuR3ToAkiLcdQX02htEuAluHRYYYSu0z8AfZ+JJbzjHdcT26i0KX9cG50fr1uD2u+QQrKp7fxPoPMUknC2Ma6WhcQZ/1nQ1vZHB6e4HxQcJvhyjcmCkE2wArHcuLp/eIkzRfL+0PXftp5ay9dlNl2PgK6Tp/Dpy/NReyc9bADWy5l06/lNhNkdqFKq7la2n7iczgeJYG1SjofY4+m+eLFtGettyv7yMen8VBew8pkUyTeZzmQkC3XzVhuoCwcoSuHp/vIA/t02v27j8V5SS5mIRFlRZEMUY+zGg7EE4e6ndEuAUJ7t9geK/+ZEntZPrF9YlTQYNUZDoifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mks7Sk5ZC3twtKR9adModZmKvp5ZvBPJv50AoFgozic=;
 b=sYMEGaLvUVjo9unXFonXTrFxZkHXh7VA5cWniadmuon5H7qU9mZHi7lpQ0QxTTUoQwpPZP9gWRnBgllNX/yHhzdX//DqthpFb+VJpnkV6vbcocr4EncjrHr3sbwcqyYhDgGRNKYDLQxjbCt8ZkkjGdMJacwq6U7RuaNKpnI4YnV+WJEgERie4xZOKypyX8QvKuvK8xHmKbgRMTmlXCdMBRc3jtVFoyATnFYeTIoJJ0XP09qbfW4jLPAQraNN3LOEoaaeY6tSZeYHRVi6kair19XV+Yh4N5ivONtl4ynNJosEbYV4UDB7SCI3UlejJuzRAP/6aJftTqA1elD1jOLWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=wunner.de smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mks7Sk5ZC3twtKR9adModZmKvp5ZvBPJv50AoFgozic=;
 b=CwUBuXlSgM5/lmbsuj8eRXFnOSLdHqcnJBUI73ifKYd49/QPu84DNTaj5bkA3f4qYp2Oz1DOIjvZJtijVlgcLV5FzpdmK2R7EQ4i7wFubCcpw+XxIgSLpO/3mOUhN7QRm8I8Y1GkEMntlux5ngGh5xqHMnzOLBEqAZsdU9AsfuCCNhEo8pEKX9fqRhRadzHVE88H0G9YF20cg4qbhk9X5BcuXKTN6twAtdmxiGK6uJLj4zsMXUWg0fIhXTpGmZ0elRnwQtddoT9avQRixMWjC0qSUtaoEc4/hJkZxakwRRQXZB4BzQZa+vMhlE1+aOyFWEXaex6Q9eQhGcsTqmSVgg==
Received: from AM8P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::29)
 by AS8PR06MB7400.eurprd06.prod.outlook.com (2603:10a6:20b:332::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 08:47:11 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::5c) by AM8P191CA0024.outlook.office365.com
 (2603:10a6:20b:21a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 08:47:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 08:47:11 +0000
Received: from AM0PR07CU002.outbound.protection.outlook.com (40.93.65.68) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 25 Feb 2026 08:47:09 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by DU4PR06MB9720.eurprd06.prod.outlook.com (2603:10a6:10:55b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 08:47:07 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 08:47:07 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Lukas Wunner <lukas@wunner.de>
CC: "ebiggers@google.com" <ebiggers@google.com>, "horia.geanta@nxp.com"
	<horia.geanta@nxp.com>, "pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Thread-Index: AQHcpZhLhQf6tsYBZky80qwgD1KH9rWR8nmAgAASVwCAAAjFgIABAUyAgAADGICAAAl5AA==
Date: Wed, 25 Feb 2026 08:47:07 +0000
Message-ID: <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
	 <aZ296wd7fLE6X3-U@wunner.de>
	 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
	 <aZ3Uqaec79TUrP2I@wunner.de>
	 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
	 <aZ6vF1CHpcp5d5qk@wunner.de>
In-Reply-To: <aZ6vF1CHpcp5d5qk@wunner.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|DU4PR06MB9720:EE_|AM3PEPF0000A79A:EE_|AS8PR06MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: df346eda-119e-4735-fa8a-08de744a7795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Qm9pSy9JSUdmc254cDNmM0dEdjFGeWU3UnpUK2pZR0NzdkJ3R0RjT0lzemZK?=
 =?utf-8?B?KytaS2JaSStYc0lhank4QStCQmNWTVV6YzRyb2xiYkdNVkhnSHN1aUI1T0pt?=
 =?utf-8?B?SzB6R0tscll6b0N3R0ZFa2ZBMXIxOEpNTk1jdHlkMUVYWEZSMXRqQW5scVNr?=
 =?utf-8?B?ajNxZGZSVXRYRzMyMjY2aVptRFdaSDVwUDlhSFdVU1QzZHM3TDF5NVF3USt6?=
 =?utf-8?B?OHplWkdXSXE1SEF1SUdyVzJuWXFnUThEZTRiYzdtYXlGWHdVZ0ZJdTBGS2ZW?=
 =?utf-8?B?TldNRm4vU3EyV2Z1enhzbWt4UlVGemJxTm5Kell5RTFUbXFlNFdOamdtUWlE?=
 =?utf-8?B?WlBselE3T2o3WVo0S01LM3QxNS9ENW9ab2taN3YzY2RqVmRsb05GK0FHWHpK?=
 =?utf-8?B?bVJoNEltTDZJTVYzSW9reUJlMUFFWS9RZVRjaFc4L0J4OFhaUE1IdWNCZ3ZD?=
 =?utf-8?B?TnpPRnlSdlE0bnk4Q0VacFljVjA5Smp5bWM0VGs0SVU0MDBReTNsN3pHczZK?=
 =?utf-8?B?S09rMXNVZ2hLWmo3OWQ5cEZidUxOVFpGS1lwemlkWlFzelRNcDUrSXYybDkw?=
 =?utf-8?B?WnFBWW8wbXB4RUFXc2d5YUoyL1VpMHF2MTdWODRjcEY0TUtjMTFTTUJSVGlG?=
 =?utf-8?B?ZEllWjBYcVJWRmg2eEVPOS9uNFRmZW5DQm55bUxvZ2VKWVdUK3JRbHBDQ0ZX?=
 =?utf-8?B?WUZpL09nUXBrS1RzTGtyNW56Zy96K1ZwZTdDejVQZG1SU21CZ05uVjcvb2d5?=
 =?utf-8?B?UG9BcCtMV2EyMlFuZ0hPUE1Xc2JNeVJEc0UwOTVSTTBjUE5mUDhVWVRCWFky?=
 =?utf-8?B?clpKUzM0Q2lUNXoxamN3YSsvQU0yWE0vYVA4MUZ3SzhOd0c5bDI3L3BIbGRT?=
 =?utf-8?B?ekJvSVN2MTFIRkFUQWVWTlNwNFlCZVhiSVE0bncySjN5ZzliTVhzY0syTCtS?=
 =?utf-8?B?V0h0RkFOK1VMZ1hQMkdyQktVNktqdW1vWmdIYms2VGNvUGowaTFocnpVcUM1?=
 =?utf-8?B?cFBBMUhaQXIrQ2VZOEVkTlRkd3paMlYvSVRYVXhsUU42VkQ5NnhEZzFLYzdk?=
 =?utf-8?B?WThhWWNpeDVid3hnWndVcHh4VTZnUVBNRXpVcERYdHZMYjljTHU5MjZ1akdz?=
 =?utf-8?B?NmIrc3lWbmxrNU5TT2RhK1lUOHRvejBWN0tNRVdiekdhWms4eXI3alJ5VUNr?=
 =?utf-8?B?WFp2bm1pM1pEQXpXMWdLOHA5REdsY0hsWXlYMXhFaXhldENYelBZTDNtcTh6?=
 =?utf-8?B?K2ZlVlowS1BrNk1vUmdXZC9vM3FtT05VcnVoeWpWc1NYazQrbE02eWZHL3Vu?=
 =?utf-8?B?c2pFOC9VQ0ZldktVQVBVZ1d1bitQN25DdHhFTVQwaHA4Q2x1MjZVSlJrNmw0?=
 =?utf-8?B?aDBsdWRrTldsNVF3L0VwdVRtVDZ6V3grYi9RbXUvWW1RV2w0RGVUMVB6UFk3?=
 =?utf-8?B?YWtEeEZuKy81bUg2dDM5MDZ3Wi9QMm10Ni9RdDdGYUY2OEZxTzhnRDZNNVc3?=
 =?utf-8?B?em9HTXlKQUovRVpjMmJVT29QZVdsRjI0SWxyTkZjUlpWYmJNMFBVZlk2Nmxj?=
 =?utf-8?B?bUI0c2ZvUUhuSGZJZnhJZFJKdlJuckRhZDNDWFRDWUw2UlFFVnR5dUdYUE1L?=
 =?utf-8?B?R3ZxeElKZTIrT24yRm9GV2liMzBIMERsYmJUUm0rODJxNkYzRXFMRnErWkN2?=
 =?utf-8?B?Z2VkM1ZERlJ5YTA4dGFudXFlMDgvMm9zbjhoZURYbUkxUGhlSmJ1OG9uL2Fy?=
 =?utf-8?B?ZU1xc3R2cmNJVzR2Vmx3QXNqd0xqcWw3KzdMbWlkbU9JTHE0ZkZJR0txN3Iw?=
 =?utf-8?B?YzFhSEUwakRXYlZJblVtM0JxZWVEdFdSTDNqamp3L1RncDc2U3pDQ0ZNRWFy?=
 =?utf-8?B?ZWNUYU9QK3g3cUFlOTBXWFRNZVJOaDJRazVSS3BJU05wRkk5SkJkRTlzdS82?=
 =?utf-8?B?Tytpa0JPUDBacEJLU3BQTFJiVmdWNVhsbE92RWdXazQzUTVOVHE2M0llK3lZ?=
 =?utf-8?B?K1EweTNuRFF2UkYrTnRGbVVtRDBNajZjaUh5b0Nmcjd6blpCamZNdTBSbUEr?=
 =?utf-8?B?Z3RZanNlUm03alV2dVdYbDVIRG9DZng1Skc4Sis1YjcwTTVpZktkaHlsR05u?=
 =?utf-8?B?Z0pyRDA3cGhZTG5TeGw3UjA0eU5FNkpCdTBHU2VsWmlRWCt1RHRVVE9TSy91?=
 =?utf-8?Q?Rw4oFvLU7zqWBVG63bEqHrs=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A22DD368272F44D9572CE1A1BD5C536@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR06MB9720
X-CodeTwo-MessageID: 5907e74a-8f72-4d39-934c-753f7eddc619.20260225084709@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5e6fd5ea-13b7-4ff6-073a-08de744a74f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|7416014|376014|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0N0ZXlpSXFtYkFxU1ZXWnNsRjJQeFNRcmtDRldJUEZWTFI0TVZSTm4raDF5?=
 =?utf-8?B?eVJ0ckZDR1RoT2lJSGNtS2dOWkJaZlozcVNNTWJYYXJkWUFJOVpUZ3luVUda?=
 =?utf-8?B?RWRKMXE2Q3Z1OUlZU2hlbWYzQW5hazQ3NXgvL3ZsdmZSWnNQaXBiQzlwUDRJ?=
 =?utf-8?B?RHU4NDVodTBDR083TndNYnRhVjVuWFpaSkt3azF1d3JvYnM0OXkxQUZFd0dl?=
 =?utf-8?B?QmtDcTNSMHBqU3QzZ0VieTdrVzRZRzBKZFYzSCtDN0RFdU1uRUxnOXdiYlB3?=
 =?utf-8?B?TDdoK0ZYU0NjTGJzT3V3bytWazFxaXY2ai85VU1IOHVRMEJKcUp1TEk2U0VN?=
 =?utf-8?B?bG02ZkYzbmVEK3VZNGZPS2V0RWJRdXozL21IaU9HU2lTZWIyMnc2Tm5WcjZ5?=
 =?utf-8?B?NlBIaW4xamN5bTlUbGVDZU9ZNmJpWUppKyt4Zm1uM2NPY3haRGtNYXA3Y2Ez?=
 =?utf-8?B?MkFwUkdqMjBZemRTbXc2bGxpaVBoWWtPN3JRVmhDV3pHRE10T2dMSm9GTjdt?=
 =?utf-8?B?cHNQOEtTalp0cjRwQkd6OWc3ZjAzZmJxMHRQOWl4STJqZXMyVzVVZmxGeTZU?=
 =?utf-8?B?RVJSNms3enJpYldVTkVGNHhpWUI0aU45S3VMeXBPR3k5YnJqNHlsMnE2NUp0?=
 =?utf-8?B?WTJLWTRGQTN6UGdqby8rNzNSZWVEd01UUkR3NmRkZEdycFR1ZFJWK2I3SHBi?=
 =?utf-8?B?WlhQbHBoNEFLdUxDK3hCa2V0QjZ2QTlPSUwrc2NkUWRvZDNnQ2wrNlJzNDQr?=
 =?utf-8?B?d0xvNE5DcGFjOUUvSnZiNmhWSGFBenFYWjRsTXhLRGNPUElDRGVud29jZmVL?=
 =?utf-8?B?UFExcW5EZHY5akdMVCtyb2h4cStyWXp4WWYrTzRkeGNEUXhZSzVhRkZ3WFJC?=
 =?utf-8?B?N3N6Z0JaOW1yZ3NVNEpGMFRGK0FxZmhlUmUxTVBiVXN4TXBLcjRCSldQd25s?=
 =?utf-8?B?bzBtWWJqejVtTjRvb3EvL3ZvbkJoeGdjSTFJYU5CVXpsNnptM0NIRTFmK1F2?=
 =?utf-8?B?dHlxYzIveko1Rk1EL0hJa1R1cmVzeFQvM2lNTXpPUHNRS3dacjV0ZCs3RWpS?=
 =?utf-8?B?NDBIV1pqR2JsQ2Y5SUtva1NZcXJ4SlNVeWI4REJwa3JKb0hFbVY1ejBlMFBw?=
 =?utf-8?B?ZGhJT21lWk10Mk1QNk41MFdOczNtK2lVMlc4K1AxdnptOURBWHpKdndRZjZM?=
 =?utf-8?B?eUxUaG9COUFoM3ZKMlJvT09WbnBhRnZuSzg5ekR0M28xK29Ia1hpL29OVmtY?=
 =?utf-8?B?RXBUTkYxbXUyeWdPb3Y3eW5yektmQ2RqT0duNDVSZWZQVHVRWm1MZ01DZDlt?=
 =?utf-8?B?MlhSNXRmZlhKcG9xR2dRRWdnNVVsbW4vaFRQODdLWmViNjFvb29EcXRPTXE5?=
 =?utf-8?B?azNjVmJDYjAvRFhiQ0U3K1JtbHpoNEVPTXRDVHA2b2gyR3pWMjE4RnVlS081?=
 =?utf-8?B?ME4yNFhLcWJUVWN4ZjJMQjFSeCttY2FmVC9ZbjJRQkx1S1JqK2dhdkVqZm8v?=
 =?utf-8?B?K2hLbWN0bHAyWFRCa2xoNWNFV2RGNkEvNWo2SUdjSmY5SnlWTDRBL1pxbXdo?=
 =?utf-8?B?aFNsRW9GU293M01UTmVBWUJ1YkQwNXlRQVBFNDFYNUpXdEExTHg1UEJtN1I2?=
 =?utf-8?B?ZWp1czVmWGZaNXMyY2U2OFIvbGRpMml0a2NSQ1BPemJFSmJ2dWFSU3J1allt?=
 =?utf-8?B?dkZjMHZDSTNiT0d2cVZzZGRHejN2S3VNMlZPTVZsQjBObEx2cE82T0lVYmNv?=
 =?utf-8?B?UHVXZDllODhNMXVlMlRCeWVnV2dGbmtnL0hvMHpZQXdmUnFLZDZUWXVLRGdQ?=
 =?utf-8?B?UE1wSnFJWi9YcHhVMEM1MkVEbVpnM3VFUFBRdGo3VndCZ0xrNWdhTklucHVs?=
 =?utf-8?B?d0Q3TEMwbnpaTnVhSW02KzArQTZsa1pzQXNMcGFlRFVicUJNM3hpdFZPS1p0?=
 =?utf-8?B?bFI1Y0hvamVEWEdqYTU1ZEZlbWtoV1JLMml5REhVemdtSWJQMnJSRjdVdWE1?=
 =?utf-8?B?cERUUlR2Tkh1OExNNmE0NUVmeXNJQXhXWEZLWjNrZlBlaWlnT0NVMXVtT3VN?=
 =?utf-8?B?OVBpVUllYStCYitWMHJINENlNTBnWFI5MGd4ZUU3S29haFJMVGtDTGN6NXZ6?=
 =?utf-8?B?OFFoSm9uQjNBR0xFZWUwcllkVDM1Yjl4TjlpbHkrN24wUXZhR2RyWGg4OTZm?=
 =?utf-8?B?Rm1kU3JBL3NneGhYUmprMTdSRjZ1d2NoRVhmNUpwZ1R6RTk1OEwvbGIzQ2p1?=
 =?utf-8?B?SmZyNm1EK0QzMGhFMElwQ0cvL2xBPT0=?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(7416014)(376014)(14060799003)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C0FhO9JmpWlvYUK3mAloAe3Kde3IW//7s+wn6qFnK2CQNsrBxy83dKtXm9wbNEq5mpt26H9PorO1nyFpWcwClUHxKoK10geCXZMtkRXkAy8RwT82c4ausw8GxpWYh3X/tVwKKHGdSulD6tYTuZOMbYcXAi1wOt8NzlYTWckcxP7letxPG8wp19bnppZAhf9d0gDuMNFhSDHzWtH6B93S7bWIKtPDUz1KDbp/DvKSvXNgC3HD5et78uSV7rCC0me3+CieKq2ciFmpoXMBwQC/xGvDj2NPNHBvoQM007Lim26eD1ML2tQuLRbN8DdIq7hzUynOYYYp+rmtUto7orVtEpAMeXHQ0zDcGRPZID4I3ebN1eUQSGjFLsQO2U+yN/BEMlLiia7b4ikB+xQC+fYNRovbTh58IV/Xzv7OR6IetIXli2DW1XuESkBrT/TDmJfs
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 08:47:11.5509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df346eda-119e-4735-fa8a-08de744a7795
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR06MB7400

QW0gTWl0dHdvY2gsIGRlbSAyNS4wMi4yMDI2IHVtIDA5OjEzICswMTAwIHNjaHJpZWIgTHVrYXMg
V3VubmVyOgo+IE9uIFdlZCwgRmViIDI1LCAyMDI2IGF0IDA4OjAyOjA4QU0gKzAwMDAsIEtlcHBs
aW5nZXItTm92YWtvdmljIE1hcnRpbiB3cm90ZToKPiA+IG9rIEkgY2FuIGNvbmZpcm06ICJnaXQg
Y2hlY2tvdXQgMmYxZjM0YzFiZjdiXiIgaW5kZWVkIGlzIG9rIGFuZAo+ID4gMmYxZjM0YzFiZjdi
IGlzIGJhZC4KPiA+IAo+ID4gSXQncyBub3QgdGhlIHNhbWUgYmVoYXZpb3VyIEkgZGVzY3JpYmVk
IChmcm9tIHY2LjE4L3Y2LjE5LiB0aGF0IGNvdWxkIGJlCj4gPiBhIGNvbWJpbmF0aW9uIG9mIGJ1
Z3MpIGJlY2F1c2Ugb24gMmYxZjM0YzFiZjdiIHJlZ2RiIGNlcnQgdmVyaWZ5IHN1Y2NlZWRzLAo+
ID4gb25seSBkbS12ZXJpdHkgZmFpbHMKPiAKPiBIbSwgSSBhc3N1bWUgQ09ORklHX0NSWVBUT19E
RVZfRlNMX0NBQU1fQUhBU0hfQVBJPW4gbWFnaWNhbGx5Cj4gbWFrZXMgdGhlIGlzc3VlIGdvIGF3
YXk/Cgpjb3JyZWN0LiB3aGVyZSBJIHNlZSB0aGF0IHNwZWNpZmljIGlzc3VlIChvbiAyZjFmMzRj
MWJmN2IgYW5kIHY2LjcpCiJjYWFtX2pyIDIxNDIwMDAuanI6IDQwMDAwMDEzOiBERUNPOiBkZXNj
IGlkeCAwOiBIZWFkZXIgRXJyb3IuIEludmFsaWQgbGVuZ3RoIG9yIHBhcml0eSwgb3IgY2VydGFp
biBvdGhlciBwcm9ibGVtcy4iCml0IHRoZW4gZ29lcyBhd2F5LgoKb24gdjYuMTggQ09ORklHX0NS
WVBUT19ERVZfRlNMX0NBQU1fQUhBU0hfQVBJPW4gZG9lc24ndCBzZWVtIHRvIGhlbHAgYW5kIEkg
c2VlIHRoZSBidWdyZXBvcnQncyBiZWhhdmlvdXIuCg==
