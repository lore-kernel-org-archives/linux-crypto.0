Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013049.outbound.protection.outlook.com [52.101.72.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133314ED19C;
	Fri, 18 Sep 2026 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789744118; cv=fail; b=KxNV6CcuHk8foeArdvnvNbNGDPtMS/wt0P5VjThMW+MD8aTVz6TZf+3x37WINOmZGIiTkg6xrvQiYLuZn7yIoKfahdCU7g8BmO81Xk1mFStuf7eowRRTYtXv2cFXee+TwQpDOOHYdv6sAOuCu7p+SS4y/9hkDWkvFDzFIbszg4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789744118; c=relaxed/simple;
	bh=O/a2xs6YBeQ3ezhaR1uP73ab//bCo204zYXcTZR8W28=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WQUjLeLqbb5gNjytpurixAQN79rXIdzjKNkA6mVEn2S10pIlTRTzVpl8IhTKphy15efsOwT8nb4r64YuWSbziJk8WqtXFpVfgLX32Bj/koNNoQNUXr63ldYIJgAsQGG5PAG6snNSPXnT7VqsZA1ml7l5vB5XbO9L21jvQLjre0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=nknXwsbi; arc=fail smtp.client-ip=52.101.72.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="nknXwsbi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C21kT5IM4pNF+CQLpJ9f5EwyhfzxM6Lj7okFdMz3sAWAGCNZ5ah3oV2KYjtyXnsv6odB/ZMoPEVSSCSx4nMHhp73eb4QSNh1o6Ssifj0h/ABp7gAJn0M8jNdUE86hBbxUT7kzeqiJ1u2umD61BWzyMWuGo8MaNih/Aaq6MXR29OzCImvPW29G97EXBV5fEFI6xMAbPMT2OBjovmEJYumyDbRl6u0lqjCx67np1n6BMGgizU6veNapYLH2dvccWUinUE/rX0+nPeLrgUL/5+BbeW+4/gE6qzQOE63ZnbhlidbpFbIeYj4y/bIVCyeLVglPz4BANn+Zz2Xt6VocjQhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/a2xs6YBeQ3ezhaR1uP73ab//bCo204zYXcTZR8W28=;
 b=RZ8/8SKhOdn5oy8p0VahaNO/AstX4Utgw+Rh4JGVz2r+F9cYXAycgDg1aIYX4V+N1KzNFINFNL0Fb6QNEFTS/+Hpmbh37gAtAJsKGm1S1wpIGaVnBp9ZHcH685F5ZHgd8x23w4tfMmWyRT4hxzLO2IZcwPVAJy84bxSTUkNjU8HdtNc8fv0J/ryiDEXhVyAwUFUAmjlYlP1YktqG+r5Q75uzdiZUVFFoPCtgpEY07a+dLdAIZB4oyz9I6OR+fU/GN6XAvAor+lq7epS51FehD/D2C5yHL7/Q9TNyc3FFZ+9/mLPAnSknDXaYZ8KDH20LvVRIqgghK8mA64oaQfENzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/a2xs6YBeQ3ezhaR1uP73ab//bCo204zYXcTZR8W28=;
 b=nknXwsbizwHDdgHSVc+bVrdq+yYWHYw36vZdTf2fVm7h8QechvEoVCjh0mIzv+wt1XGK7l6VgjmzIUoItN9shUWRKXeNMnlK4b41nWGnxFXcIXp+qcNgCoTRYLPtbwY0ANw8f1w4qFQ8uNSaIIWSA6yOEunSJSojRa4kOO2nCvOVcptmwH1ujBtnRZaSwgykQwvHvWnsMFbZg6Yzqozio2D/Fo2fYO2dQZa4livNsFBf8T8YBbWLZNlOP02Kp3cbE0uYIDbWQAOQ7bqwWgjZiTs9S7GByydDTKaMOgxbOh3L9d8LYAGVkUX2Uez/QMpSrtda6cemcaHc4epSK1tWnw==
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com (2603:10a6:10:248::17)
 by AM9PR04MB7716.eurprd04.prod.outlook.com (2603:10a6:20b:280::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.13; Fri, 18 Sep
 2026 15:08:29 +0000
Received: from DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43]) by DB9PR04MB8139.eurprd04.prod.outlook.com
 ([fe80::97c8:7d82:e34b:3d43%5]) with mapi id 15.21.0406.007; Fri, 18 Sep 2026
 15:08:28 +0000
From: "Sahil Malhotra (OSS)" <sahil.malhotra@oss.nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Varun Sethi
	<V.Sethi@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, "Sahil Malhotra
 (OSS)" <sahil.malhotra@oss.nxp.com>, Horia Geanta <horia.geanta@nxp.com>
Subject: RE: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Thread-Topic: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Thread-Index: AQHdQ/+UqssosstpOEWeSKJiOJ5AEbbNtsCAgAa6oIA=
Date: Fri, 18 Sep 2026 15:08:28 +0000
Message-ID:
 <DB9PR04MB813998F9D213CA1E1242488C82872@DB9PR04MB8139.eurprd04.prod.outlook.com>
References: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>
 <2a3bc894-886b-4557-9051-f9d3afec6ab5@nxp.com>
In-Reply-To: <2a3bc894-886b-4557-9051-f9d3afec6ab5@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-18T14:47:53.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8139:EE_|AM9PR04MB7716:EE_
x-ms-office365-filtering-correlation-id: 295d1b61-14c3-4756-f9e8-08df1596b1c5
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|23010399003|19092799006|376014|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 IpRHNXgo9KBWtg+dAdAXX4ai/xc3DgfP3Z/D07AfWSpZCp0zT/YXJtlZW7ZVVq3Tq7of5cdMvOGlVusQX1c416p5Jie6uZX/C7RP3q6EK3LCF+iBbPhhbBbGAj5VQdJ0pD7buCPk7rmRIPEmpNpodDs/U39+mx7xRjDkAruuz3tFKCCzo5Pgl0gmCgTM+ZfbrxZELQQ0z5Oij7A+IzRbsqqnhb45eBVdAHoGSaQSzUmyvaw8Eo+0/WtcpFTmnUoqg3wA5EnixyAWHGSksOYDImADtAdFS1pDojc+gnIiMAR2Pg8eVyrCvmBbwfFT854rH09Nsw9TgqbJosPVnmw5Cz3RT1DeRWLnoFOcZDBA4/Ira0wlzQykwA2t7x83PP3sWE0zXI/ylmSUwrgf+TCvEkBCUNaAsnE9Sz6tXalx1AAWWGPegwKE5eBq9TH4HESFWHO10fu4a+bcaXqWvBjaUdnb9RU/KyAjDpQ7sEiyyLdTky8975Y6jQoej0PFSrHPug69B5c18azHnw48bLp2FyH+1vEtHFQcAj55qxGEumGoCqbKPjVmzjE9BL8pjKrki4gxfv7iqhcskW2zqeNXzqyaYBf2vSchH6//BjN/5cvqs2+dVG0G9NFB3YPrSVoMJP4u2QEuWaY+8P+dUE8D+lv7JXhRWlIOzk3EhqEbdNAPKM0JuqSzG9Os7OlD1Zx2QthYwEVJ9meTdJlU8clSgvDPJGf+tdxvQAG/BRQsMb4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(23010399003)(19092799006)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkdSYUprdFJsUDZrNXZlU2tHaWkzSDEvV0svdzFkdGFpKzcxaERlQk51WFFP?=
 =?utf-8?B?SjhOMHJJcWtlUW81TkVNTHhLMFNMMmVMVDZCUzZsSmdiYWZsaE10amVRdnRY?=
 =?utf-8?B?c2hHRHUybWhKRkdtaXEvc0pZeGtxY1huTHFHcU16Mk80K0hRMjI1VHJjRHYv?=
 =?utf-8?B?cmtHalQ1NU9pcTM3czgzQ3hRd2RaS1RTRzl0OWVZd3p3UnlFVUQ0S3ZjL3dV?=
 =?utf-8?B?RFhuMGFKL2w1UnpFaGJIOGNtblhkMzhOd1hMMk9MVWM4ejloaXR5OWNiSWNB?=
 =?utf-8?B?NjlYZDdLeldvSDMvbDR6cGhPQUJ4VmF0eTNJWlhjZlRkbTg5anN5L2N0dXhn?=
 =?utf-8?B?aDJTY3VzckxXU3pnUlIzOVhxSUZsY1VkM2NXMG1mdkFZME9aUW9qUk9BaDFU?=
 =?utf-8?B?cFArMEZGZzdmdDlBL3F5S2lyU0VGeG1GQnl5UWlWckNpTFVMNEpZT3ZBMWJE?=
 =?utf-8?B?bndUZ090Z1YvNTYvWjAzd09oTHRKd1pIS1R0Q3pySVhkRWpRTTJtT3ZjZ0FB?=
 =?utf-8?B?S2xWUGEyc0F5b1ZsU21sYWNCUW13aUE3U1JTY1ptUkFRMkE4akVESFp5M0w4?=
 =?utf-8?B?YkNUNnQ2OUZqQ1RicCtEQTZkanlkYXhPempuWk9jNEtsY3pDMkdReXhSblBL?=
 =?utf-8?B?b1dLaWpHVTJPeVF2NFdDWENKbDVqVjNaVjNYMGxxRU5saXk2SEJ2NnQ5eklY?=
 =?utf-8?B?aXBkUTRZaCtQSXAxckdWQ1BTTm42a1JXS2R1c256ek10K1Z4dWU1aVdNSFVL?=
 =?utf-8?B?NFY5dXZKSlk1VXN5RSsxdHdvaDVURzYrbUtLTGxpYVJHSU9yMDR5UlVXalox?=
 =?utf-8?B?blU2ck10V2tzcEtaUmVkZUZGMzZKNnB2elE1c1lIbG9CWEgrV0dqZURLVUJH?=
 =?utf-8?B?MGowQnJTNE5oU29mS1pUb2hhNE1rNU9wZWxUSlp4bEpTaFBEWHpmMVRYVVJI?=
 =?utf-8?B?Z2t2eWVuV3JGRUN4aytEZHJWSFdzSzRlUlBIclk5ajFhdFN5Vkp6eER3YkRQ?=
 =?utf-8?B?cEI1SEVRaVY2WlNBR3VHNHBZWS9PSEpZVzY4d1hWMGcxNEF6bU8yTHB5a2ZX?=
 =?utf-8?B?VFpjNVdUOVZieXJPWlhBVUxSV05vaFF2MzJ0N3NhQzFXUjBLWjJBWXZNcUZy?=
 =?utf-8?B?ZzI4T2swcUNYNWFpZmFXZXdBeS9BWkNnQ1VVdU9EWkhkSW5qQ3hudkJLSWty?=
 =?utf-8?B?RWtsOFRNRHhFN2ZEL2NKOW5Sb2wrUWJHZkVmZHp3TUZwZ3YyUzhDTVl3aTJz?=
 =?utf-8?B?emh5cjhCcVlxQ2hEaDcvQmZKQ2h4SGtoakxrT2tQWHJHUEVMdlJ4VXExSDNS?=
 =?utf-8?B?TmVVTnFCa3ZyS2NpYm1pcGhjbEpOMlRUUlhmUkRyL3pteHoyVy9IRytoOXNP?=
 =?utf-8?B?S0svTGlwdW5sSllQZkFwWlV6MVBuUWkwQ1FaYWQvMUZTT05wV3VydVJMVi9V?=
 =?utf-8?B?cVpvdE9yZVVJUnBmVENoellzaTRlbGZGaDhJT1VEOTFPVUFVZWkyOWpZbmRv?=
 =?utf-8?B?d2hKeGlsaWZkTC9ET0trREtwNm12QWhoMzJ3TjhQWFBYdDBxaGtEbURIRWY5?=
 =?utf-8?B?TEM3YXpjdlh1SUxLNVYrZ2JmbXR1Z0FiYjhucjUwRXowVFJjalZ1UEV4azdE?=
 =?utf-8?B?dmVxbEtvK1o3VGNXaTRMemx1Ty9zREJ2Ukh6V1MwTGgyczMxQS81T2w2cHhz?=
 =?utf-8?B?NCtEZzlFWkp2NThNRVJKbkhGNUVUWjFWYjF0ancreEExUG5KTUVBdWVJRTlY?=
 =?utf-8?B?VUQyKzJtTUpXVU54ZEFnUzNrSlM3NHJtekFJTU1mRTI3ZU1Sc3laeFdadmEy?=
 =?utf-8?B?d2ZEWC9ta0tVVVVrVGZsZkJVZFJQbWRSYTMrYjRRdGdCVkYzdnJQdVFFOEc3?=
 =?utf-8?B?bTdEM09LMzFVUzF6UDB2TWpBWlc5WlZrU0I0SW9yNVNyZVZvN1RFWFNMYlRM?=
 =?utf-8?B?WE9rNkNQSVg3SjNyRGxncHkrOVpwTXgzUm5ZdUZWNTBFbkNsOG9mai9CbmpR?=
 =?utf-8?B?MXRHb0hPc1U2WFQrd1VITGthZ3lCWFN2WTQ0L29lVVd1eFh2Y3VRd0w1MUtR?=
 =?utf-8?B?OWFJOXdTNFN3K1luSGpuRzJFNUxpSjdOWGRJdWpsenFVMDRzL0N6ckVJTDcv?=
 =?utf-8?B?S240bERoM1NJdURmSDFuWkR1eW5GcW45cHQyc0NDMm55disvTlFXY0NvMzhz?=
 =?utf-8?B?bmhUZVlYbWlGbjZGaXVZam9QR0xhaXF4QTZ1Skc3RDNtZEJFNndVeW1BaFp2?=
 =?utf-8?B?SmI1Zm83YlgvZGJPVXVURkFDN1dncTRhUWtMcXNOejN3bjAwTlhRM2t5WGxx?=
 =?utf-8?B?UFVPUHRjRVMzVUdRU3M3eHJEamM2Q0wwY0F0Y2R1MHBKSitKWGJpbnRmdFll?=
 =?utf-8?Q?bkQYS5sRSQYIguVPCzXbwIcCGxhCb+ZoLJiAb0W6QPRr/?=
x-ms-exchange-antispam-messagedata-1: 18Ba5KO/ZhNy4w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295d1b61-14c3-4756-f9e8-08df1596b1c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2026 15:08:28.1383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M+kxuAX3JlX+N6nn+46ssx7dgFWiv2QG7eKBhVe/a8QFj3JoGCPrfjOmh7woB8Z9EDfw3FPa2UlbSdpg+4alLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7716

SGkgSGVyYmVydCwNCg0KR2VudGxlIHBpbmcgb24gdGhpcyBvbmUuIEhvcmlhIGhhcyByZXZpZXdl
ZCBpdC4NCg0KSSBoYXZlIGdvbmUgdGhyb3VnaCB0aGUgbGludXgtY3J5cHRvIGJhY2tsb2cgYW5k
IHRoZSBDQUFNIHNlcmllcyBhbmQgYnVnIHJlcG9ydHMgc3RpbGwgb3BlbiB0aGVyZSwNCmFuZCB0
aGUgUlNBL1BLQyBvbmVzIGhhdmUgbm90IGhhZCBhIHRlY2huaWNhbCByZXNwb25zZSBmcm9tIG91
ciBzaWRlLg0KDQpJIGFtIHdvcmtpbmcgdGhyb3VnaCB0aGF0IGJhY2tsb2cgbm93LCBzdGFydGlu
ZyB3aXRoIHRoZSBSU0EvUEtDIGl0ZW1zDQpzaW5jZSB0aG9zZSBhcmUgdGhlIG9uZXMgeW91ciBy
ZW1vdmFsIHByb3Bvc2FsIGNvbmNlcm5zOg0KICAtIHRoZSBDUlQgcGFyYW1ldGVyIGJvdW5kcyBm
aXggWzFdOw0KICAtIENoYW5nd2VpJ3MgdW5tYXAgcGx1cyBETUEgYWxpZ25tZW50IHNlcmllcyBb
Ml07DQogIC0gdGhlIHR3byBzdGFsZSBSU0EgYnVnIHJlcG9ydHMgWzNdWzRdLCBpbmNsdWRpbmcg
d2hldGhlciB0aGV5IHNoYXJlIGENCiAgICByb290IGNhdXNlIHdpdGggdGhlIGFib3ZlOw0KICAt
IFJpY2hhcmQncyBjYmMocGFlcykgc2VyaWVzIFs1XS4NCg0KSSB3aWxsIHJlcGx5IG9uIGVhY2gg
dGhyZWFkIGFzIEkgd29yayB0aHJvdWdoIGl0Lg0KDQpPbiBjYWFtcGtjLmM6IHRoZSBpbnRlbnQg
aXMgdG8gZml4IHRoZSByZXBvcnRlZCBkZWZlY3RzIHJhdGhlciB0aGFuDQpyZW1vdmUgdGhlIGNv
ZGUsIEkgd2lsbCByZXZpZXcgdGhlbSBhbmQgZ2V0IGJhY2sgdG8geW91IGluIGNvbWluZyB3ZWVr
cy4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI2MDgxMDE1
NDAyNC4zMTc4MTQ1LTEtSmVyZW15LkplYW5Ab3NzLmN5YmVyLmdvdXYuZnIvDQpbMl0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMjYwODIxMDQ1NTU1LjgwNjQ3MS0xLWNo
YW5nd2VpLnpvdUBjYW5vbmljYWwuY29tLw0KWzNdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LWNyeXB0by82MDI5YWNjMGYwZGRmZTI1ZTI1MzdjMjg2NmQ1NGZkN2Y1NGJjMTgyLmNhbWVs
QGdpbnppbmdlci5jb20vDQpbNF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRv
L2IwMTdiNjI2MDA3NWY3YmExMWM1MmU3MWJjYzVjZWJlNDI3ZTAyMGYuY2FtZWxAZ21haWwuY29t
Lw0KWzVdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDI2MDcyNjA4MTUw
NC4yMTgyOTUxLTEtcmljaGFyZEBub2QuYXQvDQoNClRoYW5rcywNClNhaGlsDQoNCg0KTlhQIENv
bmZpZGVudGlhbA0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIb3JpYSBH
ZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KPiBTZW50OiAxNCBTZXB0ZW1iZXIgMjAyNiAx
MzozMg0KPiBUbzogU2FoaWwgTWFsaG90cmEgKE9TUykgPHNhaGlsLm1hbGhvdHJhQG9zcy5ueHAu
Y29tPjsgUGFua2FqIEd1cHRhDQo+IDxwYW5rYWouZ3VwdGFAbnhwLmNvbT47IEhlcmJlcnQgWHUg
PGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IERhdmlkIFMgLg0KPiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBWYXJ1biBTZXRoaQ0KPiA8Vi5TZXRoaUBueHAuY29t
PjsgU2FoaWwgTWFsaG90cmEgPHNhaGlsLm1hbGhvdHJhQG54cC5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0hdIE1BSU5UQUlORVJTOiB1cGRhdGUgY2FhbSBjcnlwdG8gZHJpdmVyIG1haW50YWlu
ZXJzIGxpc3QNCj4NCj4gT24gOS8xNC8yMDI2IDc6MTQgQU0sIHNhaGlsLm1hbGhvdHJhQG9zcy5u
eHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFNhaGlsIE1hbGhvdHJhIDxzYWhpbC5tYWxob3RyYUBu
eHAuY29tPg0KPiA+DQo+ID4gQWRkaW5nIFNhaGlsIE1hbGhvdHJhIGFzIGNhYW0gbWFpbnRhaW5l
ciBhbmQgcmVtb3ZpbmcgR2F1cmF2IEphaW4uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYWhp
bCBNYWxob3RyYSA8c2FoaWwubWFsaG90cmFAbnhwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEhvcmlh
IEdlYW50xIMgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KPg0KPiBUaGFua3MsDQo+IEhvcmlhDQoN
Cg==
