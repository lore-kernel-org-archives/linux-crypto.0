Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2134.outbound.protection.partner.outlook.cn [139.219.146.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27784176238;
	Tue, 19 May 2026 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779153688; cv=fail; b=Ke+M+uAzwBNuhFcNiZzcADw7GfFkrypht62adsN4cTiTEfnWu20TJcKGmVpZsQcoWyK1D9xEfuiN8ROm5Dwno+9nD76yye/dJwAaf/Zvm3dGd2fzEYMlfQ7r+q75TyqNLim36ZNuczUgl0/1IxJAdItz5KxeRmmY0ocvrD2pC64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779153688; c=relaxed/simple;
	bh=6zoQ+aZ+xkPM2RRm+9qN20h4bhVnYeygGkKD3wjOvFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DNZK89WbVm2yJ1BydjppWw1lLil/HoSxZygH1lONrurmzaWFUTECjUQE+wuO6cikzmKTo5klrrW1/FAjeSpqMYp4QQMhFElwxpWGM8BvP4zLJOqEGsVEIdFpE7KffpZl1rAn7clhXjIhaHJzr7Dt9FHS38hEk5/aBThSng4OIbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mh1N3M/PuN4bX8zws4dvSqoa28S8GBOf5MuJEhPxEQOCtMIsVjjeTcOVmW9OTyLnFnPIXLHz5mj/oSHKLd12PwjVkzj0bwIXQX4bhKxzWnNZoA4f/DYP41CYb0b1zHP+81WiuTq2qyBDC6ZWs7Y9QOMhDVR3w31CnZ+8+4t/QuBCytKpwAoGqS9AHccAgOWj/3HL+SeaILc73pkPNH04SvxMlQDeciWKDCF6I2JZ2Pjl8cYfBRnEv80cKD9LHI7U7vFa/pGwuqzN7lcBzwsVuI+1RUOi4J5ZLC0SvoanqG/zRzZdC06C+rOKbIcYaBWHwiK00hdDpLOrcdC/04G3KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zoQ+aZ+xkPM2RRm+9qN20h4bhVnYeygGkKD3wjOvFo=;
 b=NBn771BCXx8IJ8fpOIE7qeqSvtf1B+awzRjtanVKRUuT7KXPzfk4iXftLM3f8pobArUX7i2puROr8+k6Wwt0YTzogCRJj5ILVxb9qC+YZwHeJlKEsNJzSyv9Uesl7c7p4g2jSf+XmU0b9CfwnZgGcQZzaYlX39gzodD2F78zjqTUgyro7V3G+rTCB6P3RQNUhWhusAiU7Hxp5kdQfkxKYVRN+ZdP5jpveYW2fdU4r2KOL3qajDGu2maiCkVQUXdxZFJ9w2Vfh+C0s77Obv3+e9B0ITZd24QQZDVl0vgGYhzGcrN+cBqj8aqRoE4C0V0sneCLYD12BPlSgINGwlBKQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0965.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Tue, 19 May
 2026 01:21:12 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%6]) with mapi id 15.20.9913.017; Tue, 19 May 2026
 01:21:12 +0000
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
 =?gb2312?B?u9i4tDogW1BBVENIIHYyIDEvMl0gZHQtYmluZGluZ3M6IEFkZCBiaW5kaW5n?=
 =?gb2312?Q?s_for_StarFive_JHB100_SoC_trng_controller?=
Thread-Topic: [PATCH v2 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC
 trng controller
Thread-Index: AQHc5pLxuNF3D5YyNEasv0ElWni9tbYT/W+AgACQjjA=
Date: Tue, 19 May 2026 01:21:12 +0000
Message-ID:
 <ZQ0PR01MB12693499ACEE206BBBDAEE8D82002@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
 <20260518065243.20865-2-lianfeng.ouyang@starfivetech.com>
 <20260518-sixteen-moaning-7e741628c20f@spud>
In-Reply-To: <20260518-sixteen-moaning-7e741628c20f@spud>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0965:EE_
x-ms-office365-filtering-correlation-id: 393af077-fc8b-4d29-1ce2-08deb544ea41
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|4143699003|3023799003|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 y3xhX8O4HIh6l60A5MxsOzfXlAbCaEdTX+K2LOaNfQKxxa1uU2sL4mSlOFOu49xy5iaK1p9qMCSQVz56scs1M5sezw4lqnfTcAaqheoct/IThsMFOoFUNymY7RkW18cUPAQinMCxlJZZGiiaukr5o4viN2cZj9FjxU0sfdyfZbA591oAS7grXaTLQ0p+9vSIiWnZf+WRGcDguB3xbB57tnxXmhgNeW6PND8zzhWwIISbt7JQMFOD/MJKaNVoLkfmckCNLH5zB1VEzKFYo8XI5OTc0BU8ruM+jRX1kny+uHISFhTHsUxerSIH7hmDgzMmpHWMPUZXDoK2UR3Xr97AwGX6n4JhNi/VfrYXnP2DGQzrJAUooQFUw94CRsjrQZu9DrcG5JAyTmTAAcFVIlUSaYS4nf+kjtq9w8DEqt7EO6wJKIWG7PRDP1jsG/fge3INEOZsnH/zMA4T8aZ3qopA3WR9gQM0eHx4A/Pz0q8WW3eQdYKFRNRi9Mo1V2Blq1lE4UFquwolh1eyykEGEF6B+dYbR4M6cwOlJVNzGv8QsRsQmXhr8Pmc+sgO8+sNhHlw
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(4143699003)(3023799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?Q28rU3FvS1JzN3FnVmxwQkZvK1NBUENJUXRLQ0V3aURLMHlHUC81ZXRSTmtE?=
 =?gb2312?B?aUNIUzJ0QnZiUVRsM2JTK2tLNlVzUHU4L21rQXpWTHZFcHlsS0RTeFJzbEoy?=
 =?gb2312?B?bC9RMlhMV0ZrNk9GZXl6VUZib0ZESFdSR0hZK2J6djZZbGdJNkpVTDBOSmkr?=
 =?gb2312?B?eVlkOFoxMnhzNDVFTXVQcE9DOWliWHUwcmIwOXRmNFNmWmczb3hqVXFVazgz?=
 =?gb2312?B?SVJLaDB4Vk5CU0t6eDF0MGVFSFM1VUx6M3NrdjZGNDJRZE5aTVgvNS9GeGh5?=
 =?gb2312?B?L2c2VkFqTEdJWEpaK0JmYldTOUEwb0s3YWdLLzM5dks3RStDN05rTUpKYngx?=
 =?gb2312?B?SVhGbjdEWnVaS2xQcG1HL09HcHJYTGg3NXNnQmRCVlo4aUZ2L0xxTU8rL3U1?=
 =?gb2312?B?RTVjS0krOGh3N3pHY0hPRmhPZWNwUEdTd0xqdFcrbDM5WHQ1bU11WE1RN2tq?=
 =?gb2312?B?YkU3VER6QUtReno2YXR3VE1QbUtoN0dnUElHYi95MUhuUC9TdVBsdWkxeXQ1?=
 =?gb2312?B?VDNkLzd1UzFhSjJ2cHJUVjdyeEZiTm1teDZwTGc5aVZHenFkaStuTWFiRGZL?=
 =?gb2312?B?UkJKa2lGNTM5akM3NkNsSUplWFJDRWF3K2dZeCtLVE9naHVkcU9OeWV4MVli?=
 =?gb2312?B?QVFVR0ZkQW1tK05zOUNtVyt3eXgwVHp0Y2t5UnV0VDRiNVozbERqTWpqaUN1?=
 =?gb2312?B?SENmY2pJRThHR1p4ck5ud3Uwb1l3VEl1dGxaN2djUngwMDNYZllyOFNMTnFh?=
 =?gb2312?B?T3M1UGNCWFcxNHhlM3VuYVNDMGwxNmx5VncyUjdubGZMT1ZOd1VrNWZEWkVZ?=
 =?gb2312?B?ZjJ6OGdTZlRUWHBBMkNUS2R5WElYUytXdzBVdlFIS2RTNStCdnk3ZUUxamRx?=
 =?gb2312?B?aUo5Vld4NEpUSnh0U0tIL1p4MVczam1zN245Q1h6N0NHbmFiMGVaSjF1dG1l?=
 =?gb2312?B?NzY2bnp6cDY2ZkRGRS9uTnBGN2RsOStBNlhSYjkzakFqZGp0RzA0MFY3TWJs?=
 =?gb2312?B?cjVVZDhEdUU1NTRQMlEyTEpGTXNac0VscE5nZlFEL2g0c3JTSXBaUEgwZTk2?=
 =?gb2312?B?Z1hrN0JxNnJjeWNUdlc4Mkt4cXp3SWpBUEE4cFRoWWtjbjlYVks5Um1kdk5p?=
 =?gb2312?B?eC9xZ2tzaTZuYVVvSTc0MDRHSDJNNHpNWnA2eXNtdmZaV2R3aDFjaU5vQnNU?=
 =?gb2312?B?cUJTSm5xL2thZlBYdERucjQ2UXJQV1RBVVF1R3JFY0VsVkVOY1FQNUJJL1FH?=
 =?gb2312?B?dWZDS2o1WFZPazVxdGI2SmdNYkkxeGxWSm5qUDlVc1FHMmZTNlpIRkU3S0VE?=
 =?gb2312?B?azRXWUV1a01hOEdhdng0VnBUaWdNWWVVVVl1cVRrU0M5REFBRXorelpnNGRY?=
 =?gb2312?B?cktEMTdqZnF0ZWQxOE1nQitEQ2xZZUJKUWNDaDhUYzRVZTNJWGcwNHBIN25H?=
 =?gb2312?B?V0l2TGx2Q0pyTmJzUG83RHN1bWI2THJ6dWxVRlE5YXlNNGk2WVNSb0VVdTc2?=
 =?gb2312?B?ZHptdXlFWXJUOW1ZN3pld2ZVUWZvUWRZQUhiSGk5Ty8zcGUwNDBaN3VVM3hG?=
 =?gb2312?B?eDcvWFBiNDVVVlg3U3plWHBXQ1dJUFhXSG5WZHErZm9SZFljbEFaSXRHYUFm?=
 =?gb2312?B?SHFJbDJGays4V0JHaWU4NlN4WVNKdDR4N3AyMkFGaDJKUVpLY08yU0xPUnZi?=
 =?gb2312?B?cGN5aEVlV1RseldENUdLK1lsb0FoMDJOY3pjaVkyeUdEc095SEdmNWJRWXJp?=
 =?gb2312?B?b0FLYm01Qk56MmxER1pNQUZ3cDZ4ZVNTUVVRODRZOEJUbVJnNU02VTlmdzNF?=
 =?gb2312?B?VzFvZG1GcFBJRE05WEtHMlBLZWlibVpTUy94QVFzRURBSGpoTHBZWStVVHJz?=
 =?gb2312?B?dDQ2TTk5cmI2NHVaTXViMjJSV1huaE1SNTltN0lrN1BTTmFZa2RiN2MxSGhS?=
 =?gb2312?B?aUFmYzlvT3Q4amRPblFYVjEwV3ZIaVFRbEpBanBtTHhLRHJVKzhVaVNtd0lo?=
 =?gb2312?B?bkM0NzJXL1RibUkvQVFaZmRFUm1ueVU0bmNzKzhLYVQ3SWxGTmZhTUU4cXB0?=
 =?gb2312?B?ZWJrNit1MTV1YkpHOTFGU09kOHFXeE85VXMxdTNDem44Y2VoMzFNVW0vSkU5?=
 =?gb2312?B?dVV6WmZqcXV4Nm5Idy8vTksxckhZelMrdjMwbDdyZkNsTUgxUmFVQVNKWHFF?=
 =?gb2312?B?MytUL2ZtbUYyZUZmaXlESnBHL0FBVEpwOG95d3FuUVUvR3hhOVZQOUtZdFRP?=
 =?gb2312?B?T3F3dnBNbTRtblhyUlBQaTdidUlKajBBV2VWNTlxMnBqK3MyTlcrTGFsQWJw?=
 =?gb2312?B?Ym5pQWo0akVnVFNpRUhmTG9nL20xY0FERVRGdnRsWmxjbmpIdTl3MHZybmhP?=
 =?gb2312?Q?qUWxRBiSoTFFCdkk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 393af077-fc8b-4d29-1ce2-08deb544ea41
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2026 01:21:12.5112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nTzIX1sFTrd3e0U7FMZNrqXJth9omAws8yVfFeTbjwrhrmaw6eJXdza9L3PkNUhJfHTUnN81NwZ2q9vsPD3i0Nzd0e7OYjUGxi3g/PBOAAOB2Zzv6l/UGby6TyS6tJ4v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0965

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogQ29ub3IgRG9vbGV5IDxjb25vckBr
ZXJuZWwub3JnPg0KPiC3osvNyrG85DogMjAyNsTqNdTCMTnI1SAwOjQyDQo+IMrVvP7IyzogTGlh
bmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gs63LzTog
T2xpdmlhIE1hY2thbGwgPG9saXZpYUBzZWxlbmljLmNvbT47IEhlcmJlcnQgWHUNCj4gPGhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+OyBL
cnp5c3p0b2YNCj4gS296bG93c2tpIDxrcnprK2R0QGtlcm5lbC5vcmc+OyBDb25vciBEb29sZXkg
PGNvbm9yK2R0QGtlcm5lbC5vcmc+OyBQaGlsaXBwDQo+IFphYmVsIDxwLnphYmVsQHBlbmd1dHJv
bml4LmRlPjsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g1vfM4jogUmU6IFtQ
QVRDSCB2MiAxLzJdIGR0LWJpbmRpbmdzOiBBZGQgYmluZGluZ3MgZm9yIFN0YXJGaXZlIEpIQjEw
MCBTb0MgdHJuZw0KPiBjb250cm9sbGVyDQo+IA0KPiBPbiBNb24sIE1heSAxOCwgMjAyNiBhdCAw
Mjo1Mjo0MlBNICswODAwLCBsaWFuZmVuZy5vdXlhbmcgd3JvdGU6DQo+ID4gRnJvbTogTGlhbmZl
bmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gPg0KPiA+IGpo
ODEwMCBpcyBubyBsb25nZXIgc3VwcG9ydGVkDQo+ID4gSmlhIEppZSBIbyBoYXMgcmVzaWduZWQN
Cj4gDQo+IFBsZWFzZSBwdXQgc29tZSBlZmZvcnQgaW50byB5b3VyIGNvbW1pdCBtZXNzYWdlcy4g
TG9vayBhcm91bmQgb24gTEtNTCwNCj4gd2hlcmUgZG8geW91IGV2ZXIgc2VlbiBjb21taXQgbWVz
c2FnZXMgYXMgcGVyZnVuY3RvcnkgYXMgdGhpcz8NCj4gUGxlYXNlIHNwZWFrIHRvIHRoZSBvdGhl
ciBkZXZlbG9wZXJzIGF0IFN0YXJmaXZlIGFib3V0IHdoYXQgdGhlIGNvbW1pdA0KPiBtZXNzYWdl
cyBzaG91bGQgbG9vayBsaWtlLg0KPiANCj4gVGhlIGZpcnN0ICJzZW50ZW5jZSIgaGVyZSBpc24n
dCBldmVuIHJlYWxseSBhY2N1cmF0ZSwgaXMgaXQ/DQo+IFRoZSBqaDgxMDAgd2FzIG5ldmVyIGV2
ZW4gcmVsZWFzZWQgdG8gY3VzdG9tZXJzLCByaWdodD8NCj4gDQo+IHB3LWJvdDogY2hhbmdlcy1y
ZXF1ZXN0ZWQNCj4gDQo+IFRoYW5rcywNCj4gQ29ub3IuDQoNCkknbSB2ZXJ5IHNvcnJ5LCBJIHdp
bGwgcHJvdmlkZSBtb3JlIGluZm9ybWF0aW9uIGZvciBjb21taXQgbWVzc2FnZXMNClRoYW5rcywN
CkxpYW5mZW5nLg0KDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGlhbmZlbmcgT3V5YW5n
IDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2Rl
dmljZXRyZWUvYmluZGluZ3Mvcm5nL3N0YXJmaXZlLGpoNzExMC10cm5nLnlhbWwgIHwgMTANCj4g
PiArKysrLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0DQo+ID4gYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3Mvcm5nL3N0YXJmaXZlLGpoNzExMC10cm5nLnlhbWwNCj4gPiBiL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvc3RhcmZpdmUsamg3MTEwLXRybmcueWFt
bA0KPiA+IGluZGV4IDQ2MzkyNDdlOWU1MS4uZDIxNzY5YjdkNTRlIDEwMDY0NA0KPiA+IC0tLSBh
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcvc3RhcmZpdmUsamg3MTEwLXRy
bmcueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9ybmcv
c3RhcmZpdmUsamg3MTEwLXRybmcueWFtbA0KPiA+IEBAIC03LDE1ICs3LDEzIEBAICRzY2hlbWE6
DQo+ID4gaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+ID4g
IHRpdGxlOiBTdGFyRml2ZSBTb0MgVFJORyBNb2R1bGUNCj4gPg0KPiA+ICBtYWludGFpbmVyczoN
Cj4gPiAtICAtIEppYSBKaWUgSG8gPGppYWppZS5ob0BzdGFyZml2ZXRlY2guY29tPg0KPiA+ICsg
IC0gTGlhbmZlbmcgT3V5YW5nIDxsaWFuZmVuZy5vdXlhbmdAc3RhcmZpdmV0ZWNoLmNvbT4NCj4g
Pg0KPiA+ICBwcm9wZXJ0aWVzOg0KPiA+ICAgIGNvbXBhdGlibGU6DQo+ID4gLSAgICBvbmVPZjoN
Cj4gPiAtICAgICAgLSBpdGVtczoNCj4gPiAtICAgICAgICAgIC0gY29uc3Q6IHN0YXJmaXZlLGpo
ODEwMC10cm5nDQo+ID4gLSAgICAgICAgICAtIGNvbnN0OiBzdGFyZml2ZSxqaDcxMTAtdHJuZw0K
PiA+IC0gICAgICAtIGNvbnN0OiBzdGFyZml2ZSxqaDcxMTAtdHJuZw0KPiA+ICsgICAgZW51bToN
Cj4gPiArICAgICAgLSBzdGFyZml2ZSxqaDcxMTAtdHJuZw0KPiA+ICsgICAgICAtIHN0YXJmaXZl
LGpoYjEwMC10cm5nDQo+ID4NCj4gPiAgICByZWc6DQo+ID4gICAgICBtYXhJdGVtczogMQ0KPiA+
IC0tDQo+ID4gMi40My4wDQo+ID4NCj4gPg0K
