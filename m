Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012034.outbound.protection.outlook.com [52.101.66.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F384317165;
	Mon, 27 Apr 2026 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303491; cv=fail; b=bv9CRIVzB2HHgWL6z1AAzTuppNus+P87o11V1S+hcpEizZLKXSXIFLMwkTen/Ut61ecxrQvRNVQUuDiJg+NDCUNtaaY/C3C4c0jEjqaIJPIDVedj3trkqdDmBuoq5/izvXcUlPQ1HDxEbIcN5xblgpipQALIhNkVUPONZyfaz+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303491; c=relaxed/simple;
	bh=6gXCnJ2mg+ZK/kJYzaf93KLzNf05qJguPl7CXK8gfPM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=joTx6tyxgL7/AJ8yoWAAtgzIacJVTxJr/fkMqvNG0kVniq6BC74qJPfJQ7jExhQ9kt8R2FbkpwgX35V8cyP7pO6Qbh4O4tPZsiXQcSZhGbUzSwSH6otqV+8KFY0KJQkByxBix1hDcHgpURG2jav76tGC1t1eOPE9TBFZcyBun+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=TSSZOsKN; arc=fail smtp.client-ip=52.101.66.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="TSSZOsKN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auW5rXKwNWOEc0JppXc0WnlcabgPf/gIgVdVTDqeMHHPbNMmhnTlkAup3F7774tA2wQESg8URrZOxGwl1I8/34j4I6GyfbLSYi76cJidd3vmmKGKQvVHmrBCSov2sInTLddUZd8zAXsymkr0NnAcPxmVySHEFFMsx9fvL5yDBDghG7HKu9AcQwzLuLJiu8AfkgL+tTlHGF723OEE95SvoB9Y5D/7g9VRfMtuyQtaZni1EqzKqzYX1FlpEqRIBOwLD7TfIHFrWKXtUIAEK9PksAB9BR+2bl4wF6or666gN5a2zcosN5o0hUJKqu7FetkPG7IAFjU3iMkGafGJCEaKGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gXCnJ2mg+ZK/kJYzaf93KLzNf05qJguPl7CXK8gfPM=;
 b=fsos8n09r2PKo///axqwi8OQfVjuyDrvNdBTRXobkMaclOiEnuFVjuToCtnVC7+sPgH1xVHSELmZVOy4tT1zM1KTjK51ARr6FsBrohR4dIeGWSqJiUBn881k360Y19LsR5oqcUh7wwYXQA9LbmdabFHDz07qKCNOgc3FEvXpERcXWWg0k5B/Sy0s/AAQmlzCtQqDbFlApIBKCA8/HQlq7d8AG+qeXO4IizLqQIGaGzqud91ZePLDDfqq2SCdNoR9PneV+SvKQgkXUFGv5U43fR7qXpcB0cHfev/XJwMf+PqeJn8hTDm34/yy9oRDOxKOhiIBXH47Nj+SKzhYkeqt9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gXCnJ2mg+ZK/kJYzaf93KLzNf05qJguPl7CXK8gfPM=;
 b=TSSZOsKNfrNMkeIuK4mw7feQOgIy5mpJJEo4wzpIGDuJOR5zT1MEsTNc2wdBPTThAIU2mpXGLZlxfXI+qVavsiBRVQvCVEoZbf+6V8YJYkLQbfwp5qltl7t5NUI81cyPiRdEnKrLje5ALY6S7Va+VH0r+WpAGC/5mnpRi8hyPcwGRDMgOM6FoeV9skTdnWKNsAc6ijqwis2WqUu1o9x3KiR7jcEwl5Lwy3XjGCfJinF4/Rh7qQIPzgY0ZtfYWJ6Ubxw17ikD4vGl1jfCZAH7cofmxtqmZ93XPfcniyO1BEZcvEhGyanCuY8FbGbdj6JgIqICkOY+QB7GLKySV3rx+Q==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI0P189MB3233.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 15:24:46 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 15:24:46 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Mario Limonciello <mario.limonciello@amd.com>,
	John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>
CC: Yunseong Kim <ysk@kzalloc.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
Thread-Topic: [PATCH v2] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
Thread-Index: AQHc1cNCTQyGDSI7hkuv6OZ/rM6PSrXy+icAgAAORoA=
Date: Mon, 27 Apr 2026 15:24:46 +0000
Message-ID: <1478b96e-7186-4cac-971d-255caeda65e2@est.tech>
References: <20260426-master-v2-1-dac9d1d99cfa@est.tech>
 <9ed7d3ad-62e2-4d60-97d9-ee454d9ef2d6@amd.com>
In-Reply-To: <9ed7d3ad-62e2-4d60-97d9-ee454d9ef2d6@amd.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8P189MB1752:EE_|VI0P189MB3233:EE_
x-ms-office365-filtering-correlation-id: 55dd53a3-c2cb-4f0e-d13a-08dea4711d2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 yTg74+eOrStweMO9CBc+ao29enLaeLxm30X0Ap6t8ts2niEwrO5jSAg8ysh3k6nZ1XkSi9NrLTSWPj1Q58FjFOk/g+lVkxJzE3cRuVqA33dj22kJZsPdaPEOGXVhPYIlxvHVvD+N0pOj4ALKg/2kJXvbLf0ywEx/ngQAXr7ougQOaq8mh+O3Uu/IPta+r7TJ3UYmkUW8NaKlnvaVMwL4oEJVT7Ib5ip2fhJh+1GC1a/BRVz4lwukROW4DrtrRGWgz6sknxE0PVGPeTWiuypLmNKSI5Nd9BGKD5oJoJwhR8TAK1lZ77pc/lVSZKHcoypvFImmtMj0NDt/cMaD28IUyLoOsYFamOSWgL3cpnCuG/X5nBQ0kI5hUVB6cWsKvW9YqjQy4N0OLmRfqGzbv1Uoo3jrRhctHlQ2Dawf9zdvFeqPslzloYnRXinLa0c4TPGNffpZNIuIGC7QD8hXsXDrTH6fXGoLZN18uCnYj9BSL14ctQPLo27n17dz1GOl2f3Y7Wbd90dsoT5cresk1y5R1W+4hlBfuC21Yi2XomYsk3W9hgRzBoQ6mkQRZub/W7XloRv8Q5GH63m6VeRwk06cPr2cx7otAxWUg3xH9CFUP7Zwhn+uKb+BnsBsQ650GXWxsyq0ZGWAr2+wTlXU0tRV1kEYnPINjvcCkyvXC9k95HLgJDvxY8+40iO227FOMmZstI7nG8Vy2uG9BZdNn/XaME78Oq/Fi14MS6lZ+XcFzVkrhequFvFcWjhhddxVlw6XtUKqISx5pGQlJy/sAWrDYsXVET7pIrVamIm2iFdF5Qg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c1pMSkZLQWhNbmlDODhRSW85RGVibERWVHcwWEIvT1NpT20wYjUwYkJoZG9k?=
 =?utf-8?B?S0oxTER2V21tUEEyWUR3dkRCUGJQcVdmV3FLb0NsR3BEazlBTTRzNEVybDFT?=
 =?utf-8?B?MnZLMEw0bHNlRm5IditQWWFRd2NaUVpRVU83QUNEUXBZTHlnL0xJb0xERDF3?=
 =?utf-8?B?MUUxeW0vVDhPMHIyeDJoMUdqSUFvMDA5TmZTYUQ5Uk1kRko0N05TOWZLd1V6?=
 =?utf-8?B?TElEYlU4aWhwWWVMR0lPa3ZHdmszY1pFME9ncUU1ODhHQUdqZlF6SWRMckdI?=
 =?utf-8?B?aW5RV3dBc0RUZlJweTdMZkwzVVFoczdSbmRlQ3E1SjZGNTVFOEZVa0cvYTEr?=
 =?utf-8?B?RDFvMnhlZjFrTVJJZlBFSDFsT1puUGRZTlBVYXR6V1ZUSjE0b1NUUGNYYmto?=
 =?utf-8?B?OXZTRHlIK0dYRXNaSVc0ZzUveEpkNTc1VWNjR3hGRnRXTENGbDBOSmljeUFy?=
 =?utf-8?B?WTlFSzI3MmpzTGhQMHd6a1ROM3RGU08vTUQ3bDZjYjVrMGNmbkczSUFHcEcw?=
 =?utf-8?B?YTZQeXZHTTdCdTZxOTVFQlhnUEtMcE9HbUJabVJoQnZYaWJvY2wrWUFtTVdF?=
 =?utf-8?B?UFdIK0cxcUNwdzQrYUVIZlQ5RDJjbkRqZElkYnJuN3hEeDRRSitzcnZyaFRj?=
 =?utf-8?B?L2w2amRJTU94R0VraTJwcHVtM0NqeGt5c2lITXRKdWJMNmExUnh4UVpwcitv?=
 =?utf-8?B?RWVVZGI0VHVDaFl2ZktZSFNlRnRvaWhlcG1LWjU5cFVEc1R5WW41d3lkamRa?=
 =?utf-8?B?eFV2dkZtUkdidnhZRzlFR3NxdUxkZG51d0orb1RRbS9wWmJYbzhYU2gyZzNM?=
 =?utf-8?B?RmsvdXZsZUk4dGFRL1dyUWZYOGQya1JVbGYyTVZpWk9FMnByd2RIOWl5QUFM?=
 =?utf-8?B?UVVocUZYQnFWR0pCS3NDME92UnJCQ3lkSno5U0ZjMmhmZzArZURUbkRDL2Jv?=
 =?utf-8?B?OWladnB6OW1SQ3pWTGExaGd2d3R2Y294M01lSFR5SFJqYVZyV2JtMERTWEpI?=
 =?utf-8?B?eWdiSzN5dy9vT2VGZHpxS2pjQm5VZXhNZW12THgxaTNSMmRRSE85eTBMdEE5?=
 =?utf-8?B?NnduRHF2M3hBak5aVjZESUErYnNlSm84bVBqYVI0NUhzRUZGbThOdWVVTVox?=
 =?utf-8?B?L2RadXgyK2l5WS9uclVkM2dRMFBUUEtHOGQ0azJwS0hsTjdBZGN4Ri9uYUl0?=
 =?utf-8?B?azNCcERJS3dxVXUwL2VvNWZPTlpnTkVOTUhhVzdJMzFEQVo1NEl3NURyb2x5?=
 =?utf-8?B?VzV1RXBMRnd4bk9iNUp4ODhJVm5YZXZQd3pMZVZhNkY2OEJPa1diZHpCcE52?=
 =?utf-8?B?UisyVXlnY3JYMEFIQVVOMWZKWTRaODB0MythcnkwVFNxVzF4cGE2N05DNUtI?=
 =?utf-8?B?RHVYS1crNzhFYlFLc0ptSk9NZkFjUVgxZk1GTVpIcVg0QkhrMWpldUN3WFQz?=
 =?utf-8?B?RVVpOXFudjRJOHFlSHdQb1VNTnVMUCtYYUVXMUxpdjI4ak91c1NRUjBrT1Jq?=
 =?utf-8?B?aVlibEF0OGs1eXp6VFpiZzlxSGVkalRYQ1Jwb0tQKy9xaGlWeHZtcWhUNDc3?=
 =?utf-8?B?L0Z3U0xXSi84QVZLSlU3dEZHdUxLc0NzQlBqMzYzQ1dNeFNxV1JTRjI4dnBv?=
 =?utf-8?B?NFpsaks3VkNMY0lVWWkwQTc4bTBQdktUTFd3dmNjKzM2UFpPM2UrR3UzMnVo?=
 =?utf-8?B?N0FuNkFxNThuczExTnpxajBoL2gvblVqS0xmTmRmMFljOE1uWTBDVFNHc0po?=
 =?utf-8?B?bXdsSUNIOGI3anJCQytqWThyckZIRzZWNFV0ZE0raSs5QzhCTnVONnhpQWV5?=
 =?utf-8?B?Yi9mNGFXT0pGK1FZZ2U1eElOYnFzNWhsMWcra2F4TEZ0NzBFbEN1YmhVNWFK?=
 =?utf-8?B?SUM3REFHVDV0ZDdDVXVxaUpmdU0rVDMrZG5pcWE4Q21iNFRuUXpSQW84L0VE?=
 =?utf-8?B?bzlpNDU1Q09YNEF1T3pwbVFOSG15M3Qxa2FBQ050MXlmYnlvRlNGYjIrODVw?=
 =?utf-8?B?bzkyemVWK0NDeTdtMHBDVWtJS1FJR0NRNStpTE9EVmJCSExLbDgzNXV1WkFa?=
 =?utf-8?B?OHhtVGV1TS9PWEhtdHRDOE9iSGxDV0FKNWI2bkdnZE9DZVNTUTJGdkEwWkJp?=
 =?utf-8?B?YTM3UHdveHptdnZqTm85MFVHTXp1eklXWlZwKy9uVHJNNnJNSUVxdUpaUlJu?=
 =?utf-8?B?VlUzbUxveFN3c0M3c3ZMcTJsOVVhRjdHMkgwcGdPK0VkVmFLV1lLRUc2STBH?=
 =?utf-8?B?QnlJcHV4dXRVdEJHQk11ckEvV3N4RHpXUlpYbzQyVFlIQ0RDWGhvOUxvM3Rx?=
 =?utf-8?Q?Pis60hnk4eTEwgWkci?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <206BEC0E837E3248B695B2DDBE2F5A1E@EURP189.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 55dd53a3-c2cb-4f0e-d13a-08dea4711d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2026 15:24:46.0984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TNBuX3i7NSRaPzdkUqqE6MGnoU5qXhr8nhubl/vrlDu3Yn9uZGkVHy823073hDq0/TKZfuXUoZZ2mnm/ALKCqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0P189MB3233

SGkgVG9tLA0KDQpPbiA0LzI3LzI2IDE2OjMzLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+IE9uIDQv
MjYvMjYgMTY6MjUsIFl1bnNlb25nIEtpbSB3cm90ZToNCj4+IFtTb21lIHBlb3BsZSB3aG8gcmVj
ZWl2ZWQgdGhpcyBtZXNzYWdlIGRvbid0IG9mdGVuIGdldCBlbWFpbCBmcm9tIHl1bnNlb25nLmtp
bUBlc3QudGVjaC4gTGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0YW50IGF0IGh0dHBzOi8vYWthLm1z
L0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+Pg0KPj4gcHNwX2dldF9jYXBhYmls
aXR5KCkgaXMgZGVjbGFyZWQgYXMgcmV0dXJuaW5nIGFuICd1bnNpZ25lZCBpbnQnLiBIb3dldmVy
LA0KPj4gaXQgcmV0dXJucyAtRU5PREVWIG9uIGZhaWx1cmUgd2hlbiBpdCBjYW5ub3QgYWNjZXNz
IHRoZSBkZXZpY2UgcmVnaXN0ZXJzDQo+PiAoaS5lLiwgd2hlbiBpb3JlYWQzMiByZXR1cm5zIDB4
ZmZmZmZmZmYpLg0KPj4NCj4+IFNpbmNlIC1FTk9ERVYgaXMgYSBuZWdhdGl2ZSB2YWx1ZSwgcmV0
dXJuaW5nIGl0IGZyb20gYSBmdW5jdGlvbiBkZWNsYXJlZCBhcw0KPj4gJ3Vuc2lnbmVkIGludCcg
cmVzdWx0cyBpbiBhbiBpbXBsaWNpdCBjYXN0IHRvIGEgbGFyZ2UgcG9zaXRpdmUgaW50ZWdlci4N
Cj4+IFRoaXMgcHJldmVudHMgdGhlIGNhbGxlciBwc3BfZGV2X2luaXQoKSBmcm9tIGNvcnJlY3Rs
eSBkZXRlY3RpbmcgdGhlDQo+PiBlcnJvciBjb25kaXRpb24sIGxlYWRpbmcgdG8gaW1wcm9wZXIg
ZXJyb3IgaGFuZGxpbmcuDQo+IA0KPiBOb3QgdHJ1ZS4gVGhlIHBzcF9kZXZfaW5pdCgpIGZ1bmN0
aW9uIHdpbGwgYXNzaWduIHRoZSByZXR1cm4gdmFsdWUgdG8gYW4NCj4gaW50IGFuZCBzbyBpdCBl
bmRzIHVwIGdldHRpbmcgdGhlIC1FTk9ERVYgdmFsdWUgaW4gdGhlIGVuZC4gQWxzbywgc2luY2UN
Cj4gcHNwX2Rldl9pbml0KCkgaXMgb25seSBjaGVja2luZyBmb3IgYSBub24temVybyB2YWx1ZSBv
biBlcnJvciBhbmQgdGhlDQo+IHJldHVybiB2YWx1ZSBvZiBwc3BfZGV2X2luaXQoKSBpcyBub3Qg
Y2hlY2tlZCwgdGhpcyBkb2Vzbid0IGhhdmUgYW55DQo+IGltcGFjdCBvbiB0aGUgcHJvY2Vzc2lu
ZyBvciBoYW5kbGluZyBvZiBlcnJvcnMuDQo+IA0KPiBJIGFncmVlIHRoYXQgcHNwX2dldF9jYXBh
YmlsaXR5KCkgc2hvdWxkIHJldHVybiBhbiBpbnQgaW5zdGVhZCBvZiBhbg0KPiB1bnNpZ25lZCBp
bnQsIHNvIHRoZSBwYXRjaCBpcyBmaW5lLCBidXQgeW91IG5lZWQgdG8gcmV3b3JrIHRoZSBjb21t
aXQNCj4gbWVzc2FnZSB0byBiZSBhY2N1cmF0ZS4NCj4gDQo+IFRoYW5rcywNCj4gVG9tDQoNCk9o
LCBJIHNlZS4gVGhhbmtzIGZvciB0aGUgY29tbWVudCEgSeKAmWxsIGZpeCB0aGlzIGluIHYzLCBh
bmQgc29ycnkgZm9yDQpiZWluZyBhIGJpdCBsYXRlIHdpdGggdGhlIHYyIHBhdGNoLg0KDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogWXVuc2VvbmcgS2ltIDx5dW5zZW9uZy5raW1AZXN0LnRlY2g+DQo+
PiAtLS0NCj4+IENoYW5nZXMgaW4gdjI6DQo+PiAtIEFkZHJlc3MgZmVlZGJhY2sgZnJvbSBUb20g
TGVuZGFja3kuDQo+PiAtLS0NCj4+ICBkcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jIHwgMiAr
LQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jIGIvZHJpdmVycy9j
cnlwdG8vY2NwL3BzcC1kZXYuYw0KPj4gaW5kZXggNWM3ZjdlMDJhN2Q4Li42NjRjZDUxYmJmMGQg
MTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+PiArKysgYi9k
cml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+PiBAQCAtMTQxLDcgKzE0MSw3IEBAIHN0YXRp
YyBpcnFyZXR1cm5fdCBwc3BfaXJxX2hhbmRsZXIoaW50IGlycSwgdm9pZCAqZGF0YSkNCj4+ICAg
ICAgICAgcmV0dXJuIElSUV9IQU5ETEVEOw0KPj4gIH0NCj4+DQo+PiAtc3RhdGljIHVuc2lnbmVk
IGludCBwc3BfZ2V0X2NhcGFiaWxpdHkoc3RydWN0IHBzcF9kZXZpY2UgKnBzcCkNCj4+ICtzdGF0
aWMgaW50IHBzcF9nZXRfY2FwYWJpbGl0eShzdHJ1Y3QgcHNwX2RldmljZSAqcHNwKQ0KPj4gIHsN
Cj4+ICAgICAgICAgdW5zaWduZWQgaW50IHZhbCA9IGlvcmVhZDMyKHBzcC0+aW9fcmVncyArIHBz
cC0+dmRhdGEtPmZlYXR1cmVfcmVnKTsNCj4+DQo+Pg0KPj4gLS0tDQo+PiBiYXNlLWNvbW1pdDog
NzA4MGUzMmQzZjA5ZDg2ODhjNGE4N2Q4MWJkY2M3MWY3ZjYwNmIxNg0KPj4gY2hhbmdlLWlkOiAy
MDI2MDQyNi1tYXN0ZXItZWJhOGQ2ODA0MmFiDQo+Pg0KPj4gQmVzdCByZWdhcmRzLA0KPj4gLS0N
Cj4+IFl1bnNlb25nIEtpbSA8eXVuc2Vvbmcua2ltQGVzdC50ZWNoPg0KPj4NClRoYW5rIHlvdSwN
Cll1bnNlb25nDQoNCg==
