Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2133.outbound.protection.partner.outlook.cn [139.219.17.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657A736C9D5;
	Wed,  3 Jun 2026 05:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780464562; cv=fail; b=QLbN/FdGm4OBN7ha4M4CBuqQb6SUNgmautlM+BZB03XPPi9cqISXRcFTGZ+tzxy9msN8bJuBCbU0wdzwTHy2WwRFOIkRo0AqQsxAOT4cKDN8e3OYULpa1oeIkKy046uxSdMm0zWb8Yp9becWcWdvaATEt/KbpTyAZKyJNo8+MgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780464562; c=relaxed/simple;
	bh=5AvX3l0WnlMohfA6HrlR/Vge3sZU9ZibKectqPKem4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qb8wZ7wKNIwD5dsxGPVgKcVuqh7jXSDffm1pWbZsbdvYEFQcKk+tKqGeA4vgvdzrNjc0I4/YiFJOLOzO5hqOf35i6WGwEgUPSafl52ZN5BzaAAASDakpf5GB3CK810Kgf0fpG7OcL7KdEoNygP8vDCrZTI8RsbGnw7P4tPxE9+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrsPJOTPcxPd9fuQQfyCv+Mg7A+9yrCMgQCgmSTZ1GGeCuHuGhQlj2VALwgQ8oODkxL+Whgowx8I7HwZgK3NRHAkJtZsxWIsQNJ53Pi/Sf+tOPyGFiGoz/YSaVdjx5O2HwYxIjGP35P21RtK1+KODvG0JWXPgGSTtv5JnwF4eGZCq5PO0gxiDrg+sdNNb2o9c1qBegWAVR8K6sZ2PFzP9nlKWy4M492XYNz/tqG/t69pjhPKFRWAWq7KKtm3ALU4Slv+K+WQeITHqkPiV3iTNlWdo/RORjDng62jiu34SCFGTgOybXj/StCDkd5KNeRvly6T8whzXijmdE9wVb0gLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AvX3l0WnlMohfA6HrlR/Vge3sZU9ZibKectqPKem4w=;
 b=a/ac/1gbdY1TQOSlDcxQ5oV46v3OY7RD8UNy/YcCO51nbGuhqQYNNo0XWw1JxlyzqS54WvbHPggrMVVrDIvpCfx+imqhtvUPGenDtxQGbh+kMlfEhQjYbJk7j9zV+FlFz2dGUSIl3rA4GmDCi66sY1asrSUKHW5judlOzHM31YUD6+Q2vgYNH2Z7PuhLpljpn8uxUIVbGn+zXaPyHZuPvHjQcKFMY+F0YTYia+2kkfHG3yBsMal6SYy6iK6PL+V5eDeOwoD0gf8VhJFacJiZTsbw7LU7cJcaQnvHLjPEA/8HnDcomaZziPOA/ZRB7KeQMnkqp4Jc+DI5Gg+rVUit8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1287.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 05:29:06 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 05:29:06 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: Conor Dooley <conor@kernel.org>
CC: Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Philipp
 Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHYzIDEvMl0gZHQtYmluZGluZ3M6IHJuZzogc3RhcmZp?=
 =?gb2312?Q?ve,jh7110-trng:_add_jhb100,_drop_jh8100?=
Thread-Topic: [PATCH v3 1/2] dt-bindings: rng: starfive,jh7110-trng: add
 jhb100, drop jh8100
Thread-Index: AQHc8apR25yMbntko0ylbJ+iwZE4/rYrfvAAgADREFA=
Date: Wed, 3 Jun 2026 05:29:05 +0000
Message-ID:
 <ZQ0PR01MB126933738933C2EB379FB10282132@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20260601093744.84210-1-lianfeng.ouyang@starfivetech.com>
 <20260601093744.84210-2-lianfeng.ouyang@starfivetech.com>
 <20260602-staple-rehire-00045d4cb667@spud>
In-Reply-To: <20260602-staple-rehire-00045d4cb667@spud>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1287:EE_
x-ms-office365-filtering-correlation-id: f3ceca3f-e2dd-4ca3-d4f9-08dec13107a7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|4143699003|18002099003|22082099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 1zq3KwJAoBmA+OCeWjLuwEk5wMV/ylOmByML5bhn1Ddp33bV5qA3lBtDuXE13oZv8Z0vsSKq0hqEDzrNamYg0KqOq1sOIPuRQ8Yv6xsJhiXSr42pHrJKp6H/+MgISTJQDfrihkayfG5I1TMUiOymI6MRuTy7Jlep+g6My6d65H21RJ4wcAoqWvOn91jKDerJ4BaiOfNLD35pQDTykTWGsDMH6dFxJpTMGXkALkwPz9xB5CkWvpORwS/3q6z2usxa6+rvtAOqC4oRxZNlPWlqm6ZoCYcxfTfGRnxdYU8Vnn8Arqech6LjRY4GnCzzFqCVL/9aJ+TrJIPuWxGR+4uwawyA7vLfAqBFqwYa01b9000tB014whVMObFzoAMWCOkqbtWzvdd2UsIQP2Y6/XR5jR9HHiVgJuahyDHMS+XQBTlo2MvO4v7/LYey09mWFezkiw9oumWZGdKznqMl9+sV76K/B47hNpsU+LbZR9RWqqiXKELo93VTjgMpeyr4vKxUUt7LEScUOMUlWwWoHN23RJf1XCKwyCu7YROxO/CJ/pO1Iq2FaQ7oCSA8yxCoFhUZ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(4143699003)(18002099003)(22082099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?d1FZTHp5OVFwL1E1VUtaYithV20wMUxMUjhLQ214S3NHMlE2TVliZXNSRWNE?=
 =?gb2312?B?UXhmVmRqSzV0UG1sYTI5K1lCNElsQkhGdUlTMVhOaDNYSTFRTU1JZG9xTnpw?=
 =?gb2312?B?V2RTQWhEb1JGQ25VdVhrN2dvWUhhRy91Z0dUUGlpNG10TU8xU2x0NUlTQ0tI?=
 =?gb2312?B?d0xSOG9pMFYzR3dwN0JTNk16T21HZCt1VW05bUdlWVk5NUdQTldWVVIydTlh?=
 =?gb2312?B?a2RyWHd4NDM1SDkrVm1MaENYTkZvckhVdHREK1lGT3Azam1JVGROZFpqdTla?=
 =?gb2312?B?YndqZEcyVmY1cmpxK1dVdWpxYXAyWCs3QkI0cGp2UVN0cnhmWG43RDRDclY4?=
 =?gb2312?B?dzJVZ1J3KzBrR21Pc1dZYUM3NkdpYzhUbXdSbVZYYzQ0OS8zWGdUN1JvZDlZ?=
 =?gb2312?B?bG1HNWx3UTJ6WTRyTHA4SVFJcmkxektRRElKbFJwSE5ZUXpVU0JCVlpZYnVt?=
 =?gb2312?B?WmJwbk1ENm5sSTRSdWswbkdwSTIrMS9LV25CQmR3cEFIalpTd1lCcW5xUjBO?=
 =?gb2312?B?Tm5RTnZUTzNya2RyMjFEa01qL2wxZG0xV1FORzlPZFluL0V4Z0NtaDhIb2JZ?=
 =?gb2312?B?OTRDaW5NckZFMytTVVlPUk9SMkRRREk1Vm1zMUZaV05XVU5CV2F5SGc4Q1Bj?=
 =?gb2312?B?UGMyYjA5aS9DUjJJdmo2MytsbWhpb3g5NnFYdlo0d25zSis3VlJBc2VqM2Fx?=
 =?gb2312?B?bkE0ajIrL1ZIZ0pJTUV1T1Q3cWlnbnBIYzhHemdUVWMxMitWazFUVDZPdjNT?=
 =?gb2312?B?TW56cktlY2x1d29vZzZURmVBOVpMbjFBOEg5L0ZIN045WktRbTdpcDZXVElI?=
 =?gb2312?B?QlBTWTNxWXJDY0hBQjJLNUxFUjllOWhsaSt5MU1CS1pmbGQrb0VzTXNkcFZu?=
 =?gb2312?B?RmhoL2NIZGVYYlF0cnNRL2VGcEkreTNmdUJXcUc3dlh0ejNtZ09ac3RXNTVI?=
 =?gb2312?B?cUhMVlBneVZTWkJaMGk3ejhnL00xeHlZWjlwcjd5THhtY3lKUmhKTTdicEhy?=
 =?gb2312?B?OVY4Y0xXUCs5d21idU01Q0lkdm0zUjV5V1VNSkovRXRXQ1BqWnF6cldYaU9P?=
 =?gb2312?B?bTJ4WmhuYzFnbFhTYUdSd0IxVzBBdWFJTlJrVko4ZnFDNk1VV2N1T1lBamIz?=
 =?gb2312?B?UldJcGtrR3BUYzlFZjRwT1paZ0NtbEcrYlFRT3J2RHpDKzdMcnVFZWZaTkNs?=
 =?gb2312?B?OXlid0NHQ3lSdjZQQTJWT2lZR1VCSjFSS1NYcFMyYlFWcTdMYm8waFB3OTVy?=
 =?gb2312?B?NHV0YmFjdlliTmxqeTNBQllPcWZiNGRqZU5MWVpvc3pPSHB6RmpWK25LSEF2?=
 =?gb2312?B?eS9yWU9JSkovSStzcytJQlFNZ0puSmFWdWRZcHJTd1lFVTRFVmdtdmtGREMr?=
 =?gb2312?B?Y1EyNmpTVDZwQ3VoczF3NUErQzBWVnVOYm9VeExvMkdJSmtXaDF1dEdrWkZG?=
 =?gb2312?B?MU1OU01zWHVVU0xwMGtNVTdKUGwyQ1RxVElHdWlraGgvS214bmc0Z1h1MFZF?=
 =?gb2312?B?VEhoQnVNR20yMXlWMVZBem1rZGxMV1hCYWJmTlFDTDZBaGJHdm1oaXlwMXEw?=
 =?gb2312?B?TGxjeGFTdS9kUkxLY1dTR1Fvd0NiRWFWYzVHbEdJOTBabi94OFByclpzZG11?=
 =?gb2312?B?alVSOW1JMHEwZWZaR0IxVjFydktmUG1iemx3Y0NFcWZOeS9GcktLK2hZdFdn?=
 =?gb2312?B?bGdTd3oveFFoZko5L3RqMVFDREUwajVJNUs3eTJzczJEeGVGOVFrdkEvYjR3?=
 =?gb2312?B?djYxWkQ5aWdORWFpeVY5eDUvMkZDcVY1ZTNoKzBzS1VhL0h5cEl6Vm95L3NZ?=
 =?gb2312?B?K3JEb3VSWEt5d2c0U05lamFvMWRxWmtYQUQ2dE91M2gwZFdPTTVUUDBHKzNE?=
 =?gb2312?B?SnVBKzVLN29wZG9ySytsa1FNcUVpUzBzaWpFY3J5Q0MvTnQzOUdtaTFOQzVu?=
 =?gb2312?B?eTRHUnRzV3Q3VmRvVjNKcUdtYlN1eEtlVmtxSEtzQUIvTXRGZlZHL2ZUTExD?=
 =?gb2312?B?MWFuNDVOUVFCZW9uNEZ5M1h6SzZIWXQ0Wmd5NGdkYnBOUmFpNHBpUTAxUGJu?=
 =?gb2312?B?SUtTbHBvZDRHVXZJUEExSDVNOFVFU3ZIZ0pOWTY3K0loNStZZ3o5ajlBRXln?=
 =?gb2312?B?S0pVWVhvU1Rtb09ucGk4RmNSeE9hbVNaRnJ4UFIxakZTcnVEOStGR3ByWkRs?=
 =?gb2312?B?QzYvWkJEb1ZFMWVpUTF5Qzg2NHRSTzg0S2JqZTk1dUwzaXhXcnIrbTdKWU9B?=
 =?gb2312?B?NkZEUXNISERlQ0E3MXp4c29WbjEyRFh4OEx5bzlrWFlmSWJYM3BaWmEwYllW?=
 =?gb2312?B?NVlwTHVxS1hJTkFOR0ZkS0NrczRVcjZ4bjZibTNDQkF6UmR0Qkl4NHhRSjB1?=
 =?gb2312?Q?m54141dMS9dabFzY=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ceca3f-e2dd-4ca3-d4f9-08dec13107a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2026 05:29:05.8801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HMv4GifnoG+I8RMrRNI2dPYlfqTtjht4Q9gF8aat8vDfFOLEy+jvGN5fX4M9DxYwd9DNYRYNTDdeIgXPewGL3tJecPn+wbnffCwshhV/QSfvYlD6a+uNeOEF7WhOpzdU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1287

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogQ29ub3IgRG9vbGV5IDxjb25vckBr
ZXJuZWwub3JnPg0KPiC3osvNyrG85DogMjAyNsTqNtTCM8jVIDA6NTkNCj4gytW8/sjLOiBMaWFu
ZmVuZyBPdXlhbmcgPGxpYW5mZW5nLm91eWFuZ0BzdGFyZml2ZXRlY2guY29tPg0KPiCzrcvNOiBP
bGl2aWEgTWFja2FsbCA8b2xpdmlhQHNlbGVuaWMuY29tPjsgSGVyYmVydCBYdQ0KPiA8aGVyYmVy
dEBnb25kb3IuYXBhbmEub3JnLmF1PjsgUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz47IEty
enlzenRvZg0KPiBLb3psb3dza2kgPGtyemsrZHRAa2VybmVsLm9yZz47IENvbm9yIERvb2xleSA8
Y29ub3IrZHRAa2VybmVsLm9yZz47IFBoaWxpcHANCj4gWmFiZWwgPHAuemFiZWxAcGVuZ3V0cm9u
aXguZGU+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiDW98ziOiBSZTogW1BB
VENIIHYzIDEvMl0gZHQtYmluZGluZ3M6IHJuZzogc3RhcmZpdmUsamg3MTEwLXRybmc6IGFkZCBq
aGIxMDAsIGRyb3ANCj4gamg4MTAwDQo+IA0KPiBPbiBNb24sIEp1biAwMSwgMjAyNiBhdCAwNToz
Nzo0M1BNICswODAwLCBsaWFuZmVuZy5vdXlhbmcgd3JvdGU6DQo+ID4gRnJvbTogTGlhbmZlbmcg
T3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gPg0KPiA+IC0gRHJv
cCAic3RhcmZpdmUsamg4MTAwLXRybmciIHNpbmNlIEpIODEwMCBTb0MgaXMgbm8gbG9uZ2VyDQo+
ID4gICBzdXBwb3J0ZWQNCj4gPiAtIEFkZCAic3RhcmZpdmUsamhiMTAwLXRybmciIGZvciB0aGUg
SkhCMTAwIFNvQyBUUk5HLg0KPiA+IC0gVXBkYXRlIG1haW50YWluZXIgdG8gY3VycmVudCBvd25l
cg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlh
bmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gDQo+IEFja2VkLWJ5OiBDb25vciBEb29sZXkgPGNvbm9y
LmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPiBwdy1ib3Q6IG5vdC1hcHBsaWNhYmxlDQo+IA0KPiBB
bHRob3VnaCwgY29tbWl0IG1lc3NhZ2VzIHJlYWxseSBzaG91bGQgbm90IGJlIGJ1bGxldCBwb2lu
dCBsaXN0cywNCj4gcGxlYXNlIGtlZXAgdGhhdCBpbiBtaW5kIGZvciB0aGUgZnV0dXJlLg0KDQoN
ClRoYW5rcyBmb3IgdGhlIHJldmlldy4gSSdsbCBtYWtlIHNvbWUgY2hhbmdlcw0KDQpCZXN0IFJl
Z2FyZHMsDQpMaWFuZmVuZyBPdXlhbmcNCg==
