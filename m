Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023124.outbound.protection.outlook.com [52.101.83.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193B31A049;
	Wed, 18 Feb 2026 08:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771403807; cv=fail; b=Vf+ssoyvxM0epAyxGCRIukpYlZiTgx6+ZQLh8Y3ZzjH8WXLxbRLi2kfExBqU+sXNqzveYSUAxH1Lkrp9FIym7JlDy0ZvVxWYMQK8p6gU7J7gu2bhzCyhM+3gfOSidCMR7TrnFxjfBmNPbi+46ozfvi3MkOnCpBkaddOilq2ChQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771403807; c=relaxed/simple;
	bh=wmq17P5wD5RIAxQCHrltU8KALRrHnK9I5/QKAEXa7zo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tH67vprcowhgaw/qOeib9TdLwngsKgaiLAA80CCkrIxf1KsPa5hiDaLlBPfAZrtfxUxFO/nuE+ihWufo/40qh4UF8KXFA2UvBSv7VptLO3AIJJ9tIC6KujClTcHKoDFj87nH8KNqU9XJgvRgc9X1hrSpreTjYVIUwvD52SKcCCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=xtC/eOGW; arc=fail smtp.client-ip=52.101.83.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="xtC/eOGW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNov57bZRBPnfOnxzFRIPZWj//bBwXVkrG76760RwYxJ9w7Oft4dAvF6IG+6rmJzjUEaQExvMzjlSzX40MbqvoXwEkfp3vtih/dnq8jxFti/BujzVuan9750uWgVfAngWIvLnoIt5GPyu8s66gZoxQ3pQbj5iLfazu4o3XSS1PvIt97P8+dCNX7iJinWbRXRsX24T+o6HODyRTBkjnGqBk2DG6zaBt01P8g6faB5qKCi9G+opZ9MqLN7GE+Nx73WZu2Vu9QAkM9tQs/9a03RZMrnTgKFEp8g72juMCU7Ry+9OogiyVFl+EMixH+ZoKpEdIkLz4ZC4WnQzrL0yxGCMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmq17P5wD5RIAxQCHrltU8KALRrHnK9I5/QKAEXa7zo=;
 b=Njvqr0fQsivotuulBaXhAXilWImqvEM/awEEeM99zBL5q91qsJt2042W5wkDyIBxehVbXndEPU0G3SGy25eE+cOBT3GvMij3R6tujb7DR5Q7mAjljwxmQgnY9Ht0OatIrFD3/8OiWfwnupi67EaaxkmBcZ5/uKVLrqD/8xjlsS3a5dZRipbq6vF8W14SdR9/oulHF94rTL/dEKeDuS0BPF6gu5wrRvCCUk2O0HpFHUEEkU43rdQiVVPrD1E5wBofbnkxjRVnTWPcREK0MfOLByOs6FX8SnnXyhSewSw16yvAp/lAe9PV3OCeFMGLMoTnTIWaxHch8kIzskP2VkG9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=cloudflare.com smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmq17P5wD5RIAxQCHrltU8KALRrHnK9I5/QKAEXa7zo=;
 b=xtC/eOGW70CGEe6xoKh0WKK7SNptvKE7sLgMkHVHh+hKiDr8t2oWG+0PMHmSrBR7Z0IfjvnI0jYHDrzTOFP1dsi4oSmJyvu1LR6IXN6Ckt0DN74oNpyQYShWm8lesutIGZA0+uUpEAEqoWErG3GecEg8gpW/l9oyZNMUMqyjLFNgFQ+zcdjfYcf7i3z6ymCxS4PmYy9d5N6HcfeIYkS7ZsKcNN0Rij+6be/iY2B+aacsF3J5QKrx4zQwD/iyriJMg6ZlG93wQ9Fzhfdd3DRUODae2lbtrsd4DMDrXcKExZSzdRHyCnQHwIlYARNPLwe3sVrgrCqlokzeY2VprLZBSw==
Received: from CWLP123CA0210.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::19)
 by AS1PR06MB8465.eurprd06.prod.outlook.com (2603:10a6:20b:4c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 08:36:27 +0000
Received: from AM2PEPF0001C70F.eurprd05.prod.outlook.com
 (2603:10a6:400:19d:cafe::72) by CWLP123CA0210.outlook.office365.com
 (2603:10a6:400:19d::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 08:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 AM2PEPF0001C70F.mail.protection.outlook.com (10.167.16.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:36:26 +0000
Received: from DB3PR08CU002.outbound.protection.outlook.com (40.93.64.86) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Wed, 18 Feb 2026 08:36:26 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by MI3PR06MB10643.eurprd06.prod.outlook.com (2603:10a6:290:71::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 08:36:23 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 08:36:23 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Ignat Korchagin <ignat@cloudflare.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "lukas@wunner.de"
	<lukas@wunner.de>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rsa: add debug message if leading zero byte is
 missing
Thread-Index: AQHcnAvkIbtDqneDG0+UC7zie+MHU7V+6bUAgAlBhQA=
Date: Wed, 18 Feb 2026 08:36:23 +0000
Message-ID: <cb282f9dccb3cea74b99f431bfba8753b9efc114.camel@ginzinger.com>
References: <20260212103915.2375576-1-martin.kepplinger-novakovic@ginzinger.com>
	 <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
In-Reply-To: <CALrw=nFiAfpFYWVZzpLZdrT=Vgn2X8mehgEm9J=yxT3K+X8CcQ@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|MI3PR06MB10643:EE_|AM2PEPF0001C70F:EE_|AS1PR06MB8465:EE_
X-MS-Office365-Filtering-Correlation-Id: d07a306a-ad20-46d7-7819-08de6ec8ce80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|7142099003;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?K1MrTXRBK3pqbnJKa0p2UTMybzQ3Qm9iVjRBVXordTlNWmJDWW5zbFN5QTVS?=
 =?utf-8?B?Zm0zN2NLaktCaTBGYTAxd1h5LzRnN0N5TEVxYVVFRVNaajB4Qm9mSzFpck8x?=
 =?utf-8?B?QXJzWTFiY2w2dFFkeUVNdEFFelpIc0JwTlVrNnZtMk9DcUc4VHJiR04zZU9Q?=
 =?utf-8?B?cEhnVGwwWEJYUktLeVl5TnQwdW9hRzBGcTdrUVYxTUFnaHlGeXFnWWxLdDJH?=
 =?utf-8?B?VkNlY2IzeGd5bTJ5NDYzeUpSWGxkNzM3a0l4U3lnQWtEdEYrRllFaGY5Tlh5?=
 =?utf-8?B?U1EzeGlsRXFpeW91U2wrT3VQU1RNUVhBN0Z3V0hIeUxNV1BFQ2FBOENNRzVU?=
 =?utf-8?B?OC9DWlBkRjlHNmVsZDZQM0NiQUp1dDZPdzZDaG5nL0hmVHdVZHRGQk9JV3B0?=
 =?utf-8?B?WXBmN3NWQlVnNk5rQ2MvaGJZNStqR3hXOGhLVkU4UzhlNjVvYWJpWlBKMzAv?=
 =?utf-8?B?ZzZGV0Y3bTZMVDBUeG81YmR0Y3plbnZ4NU9YMEQxZkxYMVBzVDhzdlRtbFg5?=
 =?utf-8?B?c2xWbFZucmc4RjYxTDNOU1FuVkhsU0E5dGRROUZDS0FIcWExdEtmbEYvKzZl?=
 =?utf-8?B?eEI2VlNiZWtuaXZJNGlSWFBsbVN6REJYUlcrT3dWcWQyTHo2N1NBdWNocXl3?=
 =?utf-8?B?Vno1Zm9FZmY5WTBjWmJ1aTJxZ3BDamJtVDl6OUIyeWRYK3VjdVlKWEdXVVBC?=
 =?utf-8?B?VmxRZXFxR05DUEtjcExSRW80bTJEN0JUQ3Fqd1ZYb1ZlS3pScEdLSVVwOFBp?=
 =?utf-8?B?RU94amxJRzNzeGFsQmVuOEFTTmNManVCajBpQ1JKaDhxTCtiRDZ5RWdidjl3?=
 =?utf-8?B?c3RlYjI4OU1WYnNoMWNFMFNZT2xhblR6YmtTdTdkR010RUdzWlVwaWN6Z1hm?=
 =?utf-8?B?MW5nNXRsOFRCRXdaV2Q0NG5PRUUvdXljaXlqeXZ4TXVFT0hTdEFubkVGTDgy?=
 =?utf-8?B?K3BoTU5oWm1hdDVjNTVuZ2F2Zm55azZ6MjFJVm1OSEY1SGpBMzc4WTdTTFlp?=
 =?utf-8?B?RXpobGJhZXFiaEhXZE5DVXRDQm84aEtSMkJPV2VmS1VyWjBpSFlCQzJyYUdH?=
 =?utf-8?B?dmNURmFiY0pVdEdnRUs2MkJjcmRLenF0Wk1PdkhvOHJBcDYzYXUxOVcvdnJm?=
 =?utf-8?B?RW5waUNySldIVHNhelhwWHZFWlk2QzQyQ2FnKzFGcENZSHhFdEFCQlZxS3RW?=
 =?utf-8?B?djhLUGpCTk1Xam83N0VpUG14MU5KenJFejlsU3hNeFFDUC9KSVg2N0hXa3Vt?=
 =?utf-8?B?bDJjSDBQSXVTU3lNbUN3SGE4VTRwNG02ZjRhRXM3Q0ZqaGhORWY2cmdkZ2p1?=
 =?utf-8?B?S0tLVUZJbVpjZ0ZvYllMaHpwZTcySVd1c1Z1ZzM3UFNEYXZTLzFqS24rSEhP?=
 =?utf-8?B?QWZoMW9PamhNYXI4Y282ZVE2bDFHMzBkV3c2NkplYjdDRWtkc1dDd3EzMm5k?=
 =?utf-8?B?OGpGSERrbGZISTlhcWo1V0hTMmVCUldweEhZM0ZLSWgrUzNJTnlJa2RQQVdV?=
 =?utf-8?B?WTZRNXJFUVRQaGRZeUI1dGl4TEJOQnhKMUx6TFNHMzZzejM1M1NlcVF3SzJX?=
 =?utf-8?B?L2d1c3E5U284cmlaUzlMSXhlQVVNQlVyUUZsa0kxM1gzbm04dDFzZFkwUHo1?=
 =?utf-8?B?VjVLdmxsWHZDQ2NhNFJiT2VkZ2xqRnlYZ3VNMnRodWtsc0pyU0FPUTNMaStU?=
 =?utf-8?B?UVZPVGZ6WnVPMU41bk9CZXJ4Tngyc0ZPMHRybmQ0VUNkczVLZTRHT0dxa09j?=
 =?utf-8?B?VWExd2duMkt3ckw1NWxjczBqcjg2KzZTZ2FuYzYzN3dVQ2RiQUNBMmw0ZzZJ?=
 =?utf-8?B?VlRHaE8rbEwrc09sWnI0b0tHV3BTdFNIc3FEYjlQV3M3YWFKaGtmaVN3WmJK?=
 =?utf-8?B?dzBLN0hROWNNcU0zd1FzY0ZWT3hsK1dHNk81b01kLzNZOS9PWDBrOEVmWFNk?=
 =?utf-8?B?Z2I0NXB3cnRleEIvcGliZ3U1Vm0yenZhN0dmcm8zMENsU1ZxU1dzZFNZNCtN?=
 =?utf-8?B?TmM2K05CSXdoVkUwYUZ4MlJhZFdSa2dLWC9NRW11dXM5bEs1ME9JZ2pndDU5?=
 =?utf-8?B?UkVWYWk4VUVRV2FsODdhdFZMbi9nR0FWRDRFTHNKekh5bE5BR29PcmZ2Zzhz?=
 =?utf-8?B?UHY5WFphbjdaVXJIdGwxRFdwdWpoZDQxWGRzUE9Pb29DMC9iOUhCaVB1a3l1?=
 =?utf-8?Q?f1PykXdXguUuusXKT3HYj34=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(7142099003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9F48A5B844C4E44977BC06FE862336C@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI3PR06MB10643
X-CodeTwo-MessageID: 0dfcabe9-9feb-4b79-8f34-3a0e4f5fe579.20260218083626@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	867a76e6-a7d7-412e-2030-08de6ec8cc57
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|14060799003|82310400026|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDJxb2tqZmpSKzZCaFpwS0Z5RjZBVHFkMmY1Tm5BNkpZVHFJaWQ0LzRES1BG?=
 =?utf-8?B?cnorYXFlWHNDNXdrMFJHN3JKNXdWR3RTVFVkL29rT0VVb01IaHRoVHh5L2g2?=
 =?utf-8?B?OFhPd1FIZXNRTVRSdGc5QmtQN3dlc1Z5RjZ4ZlZmbURRQUpVdG02a20vOStR?=
 =?utf-8?B?L3JxSDhZYTZ0Wjh5OWdxWG9WcFB3bi9vVE5EWFFYNjBKK0kyYUhtQjBFcnF2?=
 =?utf-8?B?WStKVndweUJPa3VCZSt5Wm5vMlgvcEVoTy9BcGY0MTVFRFIyVkZIenFJRzFQ?=
 =?utf-8?B?Z0gxQjV4MTNvMWh3Q29HQktkZHpWVGhhVDJXdnFGYnBNeXpUcjc3NFkyNDBX?=
 =?utf-8?B?a3dLV25rUVRtYzdoQWRxWC85alJTbXlzU0pHckFUaVQ1V1kvaEFEa0V4Yjd0?=
 =?utf-8?B?a1pnYWl5ckp5T2FGYXZwVkc4QkpJU21GamN5aDV5eE5nbEtYcG5EaVdRbURV?=
 =?utf-8?B?UXQ5N0sxamZJemg2cSs2WEY2cEt6c0RKSjhmdS9IelpKWFRabjlzUkVqYlox?=
 =?utf-8?B?emlGUEJIYTg0ODZQMEttUjhTNTZSYjFmZ0FGd2RJUjErQXZsWXRIelMwdG5q?=
 =?utf-8?B?Nll4OThuMkJUWThEWnFVcTF1NVp1bVVJazh2UGE0RWZXNzlZVjlrN0F0VnFN?=
 =?utf-8?B?ZGt0YmUzNVpHYmdLRWFOQlhoQjB5Nm5sTXFRQnFzU0d4RnU3TzUwREdESTZm?=
 =?utf-8?B?bHdxLzcrNEFOcVZIanNyczNFaXpDTWxZbjVDSkRGLzF6clJSU1FjdjMrWkkr?=
 =?utf-8?B?RkJyR1EvbjduVGZCMGNPWTRZNXgrN2g0NmF0OUh4dDJsZkdQUUtmMVROZ0ZO?=
 =?utf-8?B?Vm5jd1JMU1grL3o3bGlkMStRRDBoL3dvc3lKc0tWQW9nNjA0UGVWM2oyTG1B?=
 =?utf-8?B?RkZmK0lieU5yWGphalFjYzZNcStPaTl5UERmNVo5UXYxMmtUVm9RQTlPTUkw?=
 =?utf-8?B?aFYyWHpuUkpHZFB4b1VvVE1HTFdrUWdIYjMyNmtNbFFUWnhRWWUrbWt4WFJl?=
 =?utf-8?B?dENBUDVqNko2aWs5TDVZRWpXRUZtaUtIQzU3UHJzL1VqeGd0QVk3bHRJRnlS?=
 =?utf-8?B?Y016NGo2dUxRSmhpR2pTMmQxYXE1VTRTQkRqam1MUWFza2NncXlGR09HRjVs?=
 =?utf-8?B?L2haV1M2MDZER3dmOEdKc2NnS2RkVmJsc2wyb1dObVM4QTBlL2xxL1k4Rm81?=
 =?utf-8?B?T1Q0ZHJrdWJJL2Z1TGJlYzYvbkdDWmt4S1oxcVNQNGlpTEFtajQwbkxuMGhJ?=
 =?utf-8?B?T1dVUDBPOWs0L01naXhXaC8ySTJzVCtYQnJuZ0w0UzFtK2JRbXlZNFhIa2F5?=
 =?utf-8?B?TzhkREQxdUYwelRjSVRpR2V4N0F2SU9pQlQrd2pQVXlUOGxmdXRuVC9qTXli?=
 =?utf-8?B?bkZiaDc0UkFtWXlub3I0a3ZhYmE5YnBiakFtdHY1QTdpN1ZSOUhTZ1lZenNL?=
 =?utf-8?B?TEpLTVVDenVoK3FkLzhnK0g3QWdwcHhrdGRQc1hjVjFHdytQanZHVVBUK2lZ?=
 =?utf-8?B?TElpdU50bE4yRE5Od2ZiRVYzbW9tTlRhWksreDExSE1QN29IVnp5MjMyWk83?=
 =?utf-8?B?c0FVOU8wK0M0OG5lZ0pBSytFNXpaTXQ0SU5PaGZpRDkvMUh3UWJJMDdGeUtN?=
 =?utf-8?B?dkRzbDFialgyZ01yNHp4aXYzZlBiUGFBdWZVT0h4Y2ZmczB1K1RHYTk2bkxJ?=
 =?utf-8?B?Qlo3S0JGUHl3amRkblZubUNWYTl0cHZRWGVYUCthZ09XS0plaVc3S0xtYm5a?=
 =?utf-8?B?cnVvR1g0NkZqYmtWd2hISHRZVlFDUzhxVUdWeWY4KzNqTVFTRnd4Y1l5Mm5o?=
 =?utf-8?B?RUNxa0RQaEdiUEZFUWl0TFBxaHdXcHhZb3pQTTJCSFlLWkZaRGhhdkRFM2Vm?=
 =?utf-8?B?RnBhZU11ak5IQzlMNFptUDVKbXR6NXBzck5wa0ltVmdzRmdSUjJWYkdsdkFm?=
 =?utf-8?B?TjREd1V5VkQrWUhTL0NGaE91Y0s2NjZMZ2g0WG5TZjRwMEJUb0RRZDNrK1hv?=
 =?utf-8?B?RXhsZEw1QysveWtmeVYvV3dTbVlxMWtyUS91Zmxqa2NSOXJWdUdpM2toWjl0?=
 =?utf-8?B?OXNyTkJGUkFNcFpvY25SMWxtTllVZXlLT3NGSDJWZGZhSTdrRW5mQzd6cG5k?=
 =?utf-8?B?TnNaM0hYemJiNTBENWtVbnpSMHppWjFpRmNOQ0xiUEJma2RHMVEzMFpxVmg4?=
 =?utf-8?B?bFZtYklrSnlsSS9JV2N3MDRwdDZtdTFvS0NzTjJJZ1dEd2I5LzVFemVPbVlq?=
 =?utf-8?B?Vi9OKzdKSVQ0T1MrNHhCU3JMeUlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(14060799003)(82310400026)(376014)(7142099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bf+MQsmGcSn0t2NUt0P1z9H/CkEj7IQh3DVwnq4h7OTPPHirb/mVAXqv4wVEZbHVqUik33Anch3OJf+tjzavXaUWUdARBOy513kmpngDtgZnqoGW99GWVsXND7yd33UJuMRuEhnt2LkpO7MZVrljc+M3Q++YttCS0Ehen5+qL+GV+ZY58mGYrfM1zr0+ev4vPu5FJGGJp12eDAsfxEv1fZq45oXfjHohN6qONq4bBQbnGXrQ3ejsDbgLgFPHzMJM0vE1an852piabDyaBtIwkH3dH2zeNW0g1pxNOZu6qd+zCPnkjRQNKeagDwG9/hgF5ulJNohP/0LbUDamcRxNvDjZgFxmYonbYsKSwAXkDhidIxr22sHJ1TtmuagprqPEdkBfwsrCeH9f65rcW2ALutDWbrQ7uZ3Ec59PoC0I6gimBt1SISMtHE6RHL1xJbqv
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:36:26.9863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d07a306a-ad20-46d7-7819-08de6ec8ce80
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR06MB8465

QW0gRG9ubmVyc3RhZywgZGVtIDEyLjAyLjIwMjYgdW0gMTE6MTUgKzAwMDAgc2NocmllYiBJZ25h
dCBLb3JjaGFnaW46Cj4gSGksCj4gCj4gT24gVGh1LCBGZWIgMTIsIDIwMjYgYXQgMTA6MznigK9B
TSBNYXJ0aW4gS2VwcGxpbmdlci1Ob3Zha292aWMKPiA8bWFydGluLmtlcHBsaW5nZXItbm92YWtv
dmljQGdpbnppbmdlci5jb20+IHdyb3RlOgo+ID4gCj4gPiBXaGVuIGRlYnVnZ2luZyBSU0EgY2Vy
dGlmaWNhdGUgdmFsaWRhdGlvbiBpdCBjYW4gYmUgdmFsdWFibGUgdG8gc2VlCj4gPiB3aHkgdGhl
IFJTQSB2ZXJpZnkoKSBjYWxsYmFjayByZXR1cm5zIC1FSU5WQUwuCj4gCj4gTm90IHN1cmUgaWYg
dGhpcyB3b3VsZCBiZSBzb21lIGtpbmQgb2YgYW4gaW5mb3JtYXRpb24gbGVhayAoZGVwZW5kaW5n
Cj4gb24gYSBzdWJzeXN0ZW0gdXNpbmcgUlNBKS4gQWxzbyB3aGF0IG1ha2VzIHRoaXMgY2FzZSBz
byBzcGVjaWFsPwo+IFNob3VsZCB3ZSB0aGVuIGFubm90YXRlIGV2ZXJ5IG90aGVyIHZhbGlkYXRp
b24gY2hlY2sgaW4gdGhlIGNvZGU/Cj4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gS2VwcGxp
bmdlci1Ob3Zha292aWMKPiA+IDxtYXJ0aW4ua2VwcGxpbmdlci1ub3Zha292aWNAZ2luemluZ2Vy
LmNvbT4KPiA+IC0tLQo+ID4gCj4gPiBoaSwKPiA+IAo+ID4gbXkgcmVhbCBpc3N1ZSBpczogV2hl
biB1c2luZyBhIGNlcnRpZmljYXRlIGJhc2VkIG9uIGFuIFJTQS1rZXksCj4gPiBJIHNvbWV0aW1l
cyBzZWUgc2lnbmF0dXJlLXZlcmlmeSBlcnJvcnMgYW5kICh2aWEgZG0tdmVyaXR5KQo+ID4gcm9v
dGZzIHNpZ25hdHVyZS12ZXJpZnkgZXJyb3JzLCBhbGwgdHJpZ2dlcmVkIGJ5ICJubyBsZWFkaW5n
IDAKPiA+IGJ5dGUiLgo+ID4gCj4gPiBrZXkvY2VydCBnZW5lcmF0aW9uOgo+ID4gb3BlbnNzbCBy
ZXEgLXg1MDkgLW5ld2tleSByc2E6NDA5NiAta2V5b3V0IGNhX2tleS5wZW0gLW91dCBjYS5wZW0g
LQo+ID4gbm9kZXMgLWRheXMgMzY1IC1zZXRfc2VyaWFsIDAxIC1zdWJqIC9DTj1naW56aW5nZXIu
Y29tCj4gPiBhbmQgc2ltcGx5IHVzZWQgYXMgdHJ1c3RlZCBidWlsdC1pbiBrZXkgYW5kIHJvb3Rm
cyBoYXNoIHNpZ24KPiA+IGFwcGVuZGVkCj4gPiB0byByb290ZnMgKHNxdWFzaGZzKS4KPiA+IAo+
ID4gSSdtIG9uIGlteDZ1bC4gVGhlIHRoaW5nIGlzOiBVc2luZyB0aGUgc2FtZSBjZXJ0aWZpY2F0
ZS9rZXksIHdvcmtzCj4gPiBvbgo+ID4gb2xkIHY1LjQtYmFzZWQga2VybmVscywgdXAgdG8gdjYu
NiEKPiA+IAo+ID4gU3RhcnRpbmcgd2l0aCBjb21taXQgMmYxZjM0YzFiZjdiMzA5ICgiY3J5cHRv
OiBhaGFzaCAtIG9wdGltaXplCj4gPiBwZXJmb3JtYW5jZQo+ID4gd2hlbiB3cmFwcGluZyBzaGFz
aCIpIGl0IHN0YXJ0cyB0byBicmVhay4gaXQgaXMgbm90IGEgY29tbWl0IG9uCj4gPiBpdCdzIG93
biBJCj4gPiBjYW4gcmV2ZXJ0IGFuZCBtb3ZlIG9uLgo+ID4gCj4gPiBXaGF0IGhhcHBlbmRlZCBz
aW5jZSB2Ni42ID8gT24gdjYuNyBJIHNlZQo+ID4gW8KgwqDCoCAyLjk3ODcyMl0gY2FhbV9qciAy
MTQyMDAwLmpyOiA0MDAwMDAxMzogREVDTzogZGVzYyBpZHggMDoKPiA+IEhlYWRlciBFcnJvci4g
SW52YWxpZCBsZW5ndGggb3IgcGFyaXR5LCBvciBjZXJ0YWluIG90aGVyIHByb2JsZW1zLgo+ID4g
Cj4gPiBhbmQgbGF0ZXIgdGhlIGFib3ZlIC1FSU5WQUwgZnJvbSB0aGUgUlNBIHZlcmlmeSBjYWxs
YmFjaywgd2hlcmUgSQo+ID4gYWRkCj4gPiB0aGUgZGVidWcgcHJpbnRpbmcgSSBzZWUuCj4gPiAK
PiA+IFdoYXQncyB0aGUgZGVhbCB3aXRoIHRoaXMgImxlYWRpbmcgMCBieXRlIj8KPiAKPiBTZWUg
UkZDIDIzMTMsIHAgOC4xCgpoaSBJZ25hdCwKCnRoYW5rcyBmb3IgeW91ciB0aW1lLCB0aGUgcHJv
YmxlbSBpcyAqc29tZXRpbWVzKiByc2EgdmVyaWZ5IGZhaWxzLgp0aGVyZSBzZWVtcyB0byBiZSBh
IHJhY2UgY29uZGl0aW9uOgoKaW4gdGhlIGZhaWx1cmUtY2FzZSBhZnRlciBjcnlwdG9fYWtjaXBo
ZXJfZW5jcnlwdCgpIGFuZApjcnlwdG9fd2FpdF9yZXEoKSB0aGUgKnNhbWUqIGRhdGEgYXMgYmVm
b3JlIGlzIHN0aWxsIGF0IG91dF9idWYhIHRoYXQKaGFzIG5vdCB5ZXQgYmVlbiB3cml0dGVuIHRv
LgoKSXQncyBub3QgdGhhdCBvYnZpb3VzIHRvIGJlIHlldCBiZWNhdXNlIG1zbGVlcCgxMDAwKSBk
b2Vzbid0IGNoYW5nZQptdWNoIGFuZCAwMCwgMDEsIGZmLCBmZi4uLiBpcyAqc3RpbGwqIG5vdCB5
ZXQgd3JpdHRlbiB0byBvdXRfYnVmIQoKaXMgdGhlcmUgYSByZWFzb24gd2h5IGNyeXB0b19ha2Np
cGhlcl9zeW5jX3tlbixkZX1jcnlwdCgpIGlzIG5vdCB1c2VkPwpDYW4geW91IGltYWdpbmUgd2hh
dCBjb3VsZCBnbyB3cm9uZyBoZXJlPwoKKm1heWJlKiBjb21taXQgMWU1NjJkZWFjZWNjYTFmMWJl
YzdkMjNkYTUyNjkwNGExZTg3NTI1ZSB0aGF0IGRpZCBhIGxvdApvZiB0aGluZ3MgaW4gcGFyYWxs
ZWwgKGluIG9yZGVyIHRvIGtlZXAgZnVuY3Rpb25hbGl0eSBzaW1pbGFyKSBnb3QKc29tZXRoaW5n
IHdyb25nPwoKc2lkZW5vdGU6IHdoZW4gSSB1c2UgYW4gZWxsaXB0aWMgY3VydmUga2V5IGluc3Rl
YWQgb2YgcnNhLCBldmVyeXRoaW5nCndvcmtzLgoKYWxzbywgdGhlIGF1dG8tZnJlZSBmb3IgY2hp
bGRfcmVxIGxvb2tzIGEgYml0IGRhbmdlcm91cyB3aGVuIHVzaW5nCm91dF9idWYsIGJ1dCBvayA6
KQoKbWF5YmUgdGhpcyByaW5ncyBhIGJlbGwsIEknbGwga2VlcCBkZWJ1Z2dpbmcsCgogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgbWFydGluCgoKPiAKPiA+IAo+ID4gdGhhbmsgeW91IQo+ID4g
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIG1hcnRpbgo+ID4gCj4gPiAKPiA+IAo+ID4gwqBjcnlwdG8vcnNh
LXBrY3MxcGFkLmMgfCA1ICsrKy0tCj4gPiDCoGNyeXB0by9yc2Fzc2EtcGtjczEuYyB8IDUgKysr
LS0KPiA+IMKgMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
Cj4gPiAKPiA+IGRpZmYgLS1naXQgYS9jcnlwdG8vcnNhLXBrY3MxcGFkLmMgYi9jcnlwdG8vcnNh
LXBrY3MxcGFkLmMKPiA+IGluZGV4IDUwYmRiMThlN2I0ODMuLjY1YTQ4MjFlOTc1OGIgMTAwNjQ0
Cj4gPiAtLS0gYS9jcnlwdG8vcnNhLXBrY3MxcGFkLmMKPiA+ICsrKyBiL2NyeXB0by9yc2EtcGtj
czFwYWQuYwo+ID4gQEAgLTE5MSw5ICsxOTEsMTAgQEAgc3RhdGljIGludCBwa2NzMXBhZF9kZWNy
eXB0X2NvbXBsZXRlKHN0cnVjdAo+ID4gYWtjaXBoZXJfcmVxdWVzdCAqcmVxLCBpbnQgZXJyKQo+
ID4gCj4gPiDCoMKgwqDCoMKgwqDCoCBvdXRfYnVmID0gcmVxX2N0eC0+b3V0X2J1ZjsKPiA+IMKg
wqDCoMKgwqDCoMKgIGlmIChkc3RfbGVuID09IGN0eC0+a2V5X3NpemUpIHsKPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChvdXRfYnVmWzBdICE9IDB4MDApCj4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogRGVjcnlwdGVkIHZhbHVl
IGhhZCBubyBsZWFkaW5nIDAgYnl0ZSAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKG91dF9idWZbMF0gIT0gMHgwMCkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHByX2RlYnVnKCJEZWNyeXB0ZWQgdmFsdWUgaGFkIG5vIGxl
YWRpbmcgMAo+ID4gYnl0ZVxuIik7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGdvdG8gZG9uZTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIH0KPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRzdF9sZW4tLTsK
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvdXRfYnVmKys7Cj4gPiBkaWZmIC0t
Z2l0IGEvY3J5cHRvL3JzYXNzYS1wa2NzMS5jIGIvY3J5cHRvL3JzYXNzYS1wa2NzMS5jCj4gPiBp
bmRleCA5NGZhNWU5NjAwZTc5Li4yMjkxOTcyOGVhMWM4IDEwMDY0NAo+ID4gLS0tIGEvY3J5cHRv
L3JzYXNzYS1wa2NzMS5jCj4gPiArKysgYi9jcnlwdG8vcnNhc3NhLXBrY3MxLmMKPiA+IEBAIC0y
NjMsOSArMjYzLDEwIEBAIHN0YXRpYyBpbnQgcnNhc3NhX3BrY3MxX3ZlcmlmeShzdHJ1Y3QKPiA+
IGNyeXB0b19zaWcgKnRmbSwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gLUVJTlZBTDsKPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqAgaWYgKGRzdF9sZW4gPT0gY3R4LT5r
ZXlfc2l6ZSkgewo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG91dF9idWZb
MF0gIT0gMHgwMCkKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAvKiBFbmNyeXB0ZWQgdmFsdWUgaGFkIG5vIGxlYWRpbmcgMCBieXRlICovCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAob3V0X2J1ZlswXSAhPSAweDAwKSB7Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJfZGVidWcoIkVu
Y3J5cHRlZCB2YWx1ZSBoYWQgbm8gbGVhZGluZyAwCj4gPiBieXRlXG4iKTsKPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBkc3RfbGVuLS07Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgb3V0X2J1ZisrOwo+ID4gLS0KPiA+IDIuNDcuMwo+ID4gCj4gCj4gSWduYXQK
