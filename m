Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2129.outbound.protection.partner.outlook.cn [139.219.17.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3DC1A6806;
	Sun, 20 Sep 2026 06:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885392; cv=fail; b=s0tH13xnVQwfYtATF2i6wmrUzo3X+3d095mYbwDxQPDQ3MwmnNkjrEI5gm1fELFMSYeHEsRCplzbK4hGyixtEQTS285dEKrkea4M0jodW4kKfkg4z7TXdXuENPDojMFRm1ifHF6pJmKSuv9xA1blYgYJFw5ztWX7tt4yWn18bEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885392; c=relaxed/simple;
	bh=hPj/fjN1Kz75aqhGtGVmzhj3V4RZw9BFSnBBDrruFAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SajGuYGHwR6NyLnS8E7Ix0Dwpl8nzGIP7nAK/cipHtGvbvgnCHB93/DjKPkwrRK2ZZg6KHto9OFH2y7g9RT2j7ARbR7ltb8p3sVbRoPKvHnOly6gZGEN6ftuRhrC53cEDxIXfY71egNb8CI84u6zoqWOI+JuvRrDudNBMkZdFhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvwwji7F3bAkYrlxFet5zfcziG5WhvGnM5MeKWw/4SZMC/54p0YpRzD/TdUOsSGQlDtNV1yRCSFvnAdDV1OsKzG6GlOto8sIwo5ZGyrLvQEJiQm8bJRMHqnyZ6hFTm9IF412fqFhM8/bz8lCj4ldtmztGXdKfsvDwqBdPynIVJ8xDuFdGqwh9EU1+aWmMOanDk0xkjMeVXGZqqXJnMoQ8gTsnQXtPaJXy2JCKzzhJR4NyqcmXJcgr21WhLsYIbX69+SWzQI/IYvwHBz4pYtgLEKERdRGjsJtHU5BhhIj9VUdq75ZS3yurdmfPUXHFOdWoqKjDRK5uEtnk7scvHkkzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPj/fjN1Kz75aqhGtGVmzhj3V4RZw9BFSnBBDrruFAk=;
 b=AYxE+k2lBuQBo2OGJAdJQ7gaFhPpU4ZZ8Qytp/PuMgFDoJskPizKMwGODlpoPSGdLxD29UQDEhXb/5wEmBRnjmTBaRW+SyMXm67MGkSyoOGB4h2HqyeW7WZk0OnvOM8YwFxh33isrYRTFLcnfjK8gw5t31JS5U7TxBbY+0PAh5QxO8VA4Z6wCaoSYIiV8fDV/tkq0fv+jfpV+mifp7IZU9GnX8A5BQ24lB/hc+AkUXonMncIy0NETav3tR6puBWhUF0mcj2uozvzw7bOzqHBiate/NY8i6UovqLW8Gh3ngSCIwY1r4LSz73qCJn7LwGj2Ay7R0IKu4PbSj3H3//sUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1237.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Sun, 20 Sep
 2026 06:22:52 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 06:22:52 +0000
From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHY4IDIvMl0gaHdybmc6IHN0YXJmaXZlOiByZXdvcmsg?=
 =?gb2312?Q?clk/reset_teardown_order_for_JHB100?=
Thread-Topic: [PATCH v8 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Thread-Index: AQHdPnc9LZrr1btr0kuIoVF4D3Ad/LbT00QAgANATxA=
Date: Sun, 20 Sep 2026 06:22:52 +0000
Message-ID:
 <ZQ0PR01MB126919F96070E84987907EE382852@ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn>
References: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
 <20260907031603.188483-3-lianfeng.ouyang@starfivetech.com>
 <aqzBMBaXnIZZMX70@gondor.apana.org.au>
In-Reply-To: <aqzBMBaXnIZZMX70@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1237:EE_
x-ms-office365-filtering-correlation-id: f5abe3a6-2848-4215-fd11-08df16df99dd
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|38070700021|56012099006|6133799003|10067099003|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 E+4WyIxFycMEjL5uJG8e1b6zD7sZgiRoyaXyrJXC+WgiXCWocylyVHdOzxMa5k29j8jMnyfdi5qxwISVGBZmhM80HKyusg4YU4jCtFFFp9JflJOgs4YwXBUisrQe5MRkvoaoREDgSqUZX6VvaCO+/qVDeT6SaQb0LkW4cRc3WHbXq9X2Tk7FT9p+0arICGK5+E+pQbP4qjqIU0MOsKWvOD8lV4S0B6W5IUPQ2Kuab3ugedr6RjykztMgm/XPyerBLRjW19mesi6pn1d4hr13ojgyCMC3JOkkmlLxz2N8ygjvoV7ANxgMXdNNIPvvbJG5C/sWKaIXdSAGfbEeIVDLCGE57QfEjPbOH9wmEjPiqcNOOKED7Ia2YnuSAnggpQJes8jWqMCydlotDuJ+dVsL2EhWRDeo7CPXucV7gawHgcVkLBmGVJxhD3uDDvP8ij6/aes85punOalJLq8Cw7euqWQgFpVUTeXItbxc4TocE0uZBlTf43Uc3LYbbrSCRHwxI7V6NpWkMLIhBJ7vRPvX6hZlhCjPfHJ8qZxPnNibh4xhwoMcocTC6Xwke4bQRhUT
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(38070700021)(56012099006)(6133799003)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?dG9rZU9teE85RE5KOWVxZmxhUldNRFpTaXVPdTVNTzMxSGI1Y3UyOXd5VzRP?=
 =?gb2312?B?WUxLdlBSMlZwdW9qa0hjazVYT04wMlN2U3dFYmNoK1k0R1hXeHZ4b0Q3VEhV?=
 =?gb2312?B?NkNnZWpyRmhPTDNOWHZROWRtREQ2MDJpeUxlcjFiRzMwdTBZUkFmeG03VzBL?=
 =?gb2312?B?VmlvR05hVW1FQzE3Q2JXeGNGVmI5NGlDSFhxRjlZZVlIa0krL0FaZExCMlJQ?=
 =?gb2312?B?OFlQci9LcmorMTBHd2s1UnVHWm5EK1IwQzJjdFdESWxqZGJYNkgvK0IzVUow?=
 =?gb2312?B?K2ZiQ0RtL213Tk1abFB4aHdLNkpsMkFOc3NzOHlvSU9qMzlmeTZqSEMzY3VI?=
 =?gb2312?B?a0ovL0swRVkrVEROSEI5eDd3NzR0eE8ySkFiRWYyOGhRQzFKSlJhcEM1MFBx?=
 =?gb2312?B?ZTNiVHBMb0NZUDNoWkFheTJzakhGMGFoSjdLdGFzTnNZc0lhdGlDL2VkN3pS?=
 =?gb2312?B?VEFzazR6b2E0Y0d3V3NqOWpwSElva09ycWdsakx2QXVEYXdUTGJ1ekRXUlBM?=
 =?gb2312?B?bDNWLzV0QWMwVmNSbCtBK0l6bFUrcGJZQzI3eks3anAvV1NFa2djdmUvWDNO?=
 =?gb2312?B?a00yRW1memxjUGEraDcwNWt5dFJFdWFmZDZiTWVuamxtZmJucWdTMHYreUFB?=
 =?gb2312?B?Z2tHMndzNEFwbkJBSWg5V2ZjU3h0cHVOMHFxbVgrZmovM1lHdFoxSnFaR01m?=
 =?gb2312?B?ZERvWk9tSHEzb2JhblZqTW9xbC92NlNFS1A5WUJ1UkI4Ujlkc0V3cStMQnA4?=
 =?gb2312?B?cjF2eWxuKzQ3dkZVSldSbkRLUHFVQUhrZHB0ZGEwdzJoRGF1c1l1QjNManN5?=
 =?gb2312?B?NkhHMHduTVFaYXJIZUhmeG5qck5pY1U3UktHQ2ZjN2U0a3B3UTFOV1g4MGpR?=
 =?gb2312?B?SlgwWDhkQ2RMZVdRM2tUYk1tOW41REJNUm1Kb3BLRHdNcjl4ZWNnWUxsMTZ3?=
 =?gb2312?B?TnAwUHd4YWhlNU1MQ25BZ2xPN1phUHkraUlscTBqdzk0ZXRtWUltNjF5SHZl?=
 =?gb2312?B?RVpqWkROSytQSzllclNnUmdVMzNFN2pEY3ZKdU1XWU9SUVgxRUlrYjkrOU5j?=
 =?gb2312?B?UCtXODZ4ZUFyMG5sOC84dm1aemRjY2d4SCtxdlhGY0NuYlNQRUh2UWQ4c2lx?=
 =?gb2312?B?Ni9nTVBwRGNwdzFVbVpZREpyNzh3NU1iTmtBUEwrblZmS1FKcDl0b0s4YnlL?=
 =?gb2312?B?emduSEd4enhsbCswb2NqdG54bnc4SVFzdDFLMTNSc3RYRGdtSlBqNERlU3FH?=
 =?gb2312?B?VEgvcWt4aERWNG9tTHdtL3hscUJDMXVxdjVFKzRPZUZLTDMwOWlYZlhHcGhv?=
 =?gb2312?B?SDFTUWZUMkRUMlFpSnhrb0NnNTFwbG5Gbi8rcjBTWmdqa2dHdXp5dVEyMkNj?=
 =?gb2312?B?QkxaQ2lnN0pick9DSUlMUmd1bWxPSWFmQTZVRElsYzZ1TWd4MDJoOUsvWUYx?=
 =?gb2312?B?MmI1T0xYdGtyTnNEeTEzVThpdVRDWXh6U2dNVFhaSmpNZmNJY0ZEUjQwcHdO?=
 =?gb2312?B?SGlmQVJrcWxjMzB6Mlhvclovbm4vMmNwdnQ4RzZVQXNDSkcweUo0dm9LZWpS?=
 =?gb2312?B?TnNpNDNmL2s3YndDUElENlBDTlNMZDJGVHdtbFZEN3hhZ1RjZHZ3K1gzWFBC?=
 =?gb2312?B?UjhxUjRZZGhGcDVBZ3lkeUd0NFZ2VkZqbTZCQlp1THc0ZHF2c1V6RzhEQXVN?=
 =?gb2312?B?V0FDNWlPSVVsVHVlS0FPdWE3Q0RZU1VHR2xTRGRSYkExN3ZUUVo3dGhtWlZB?=
 =?gb2312?B?bnVhTEsydGcySERjc2tyZ0F2dmlMdjhwYVk4SmdNMnpTL3AwNXFYWkRsS2lZ?=
 =?gb2312?B?SGVpMTNUUkZ0TnNCUE1IM0RxdGtaamFKY01XcUk1aERkNnc1a2JqK1ZkMFZu?=
 =?gb2312?B?MFVnbWQrTGkzaUpYbitkeVExN0N0UkZSVEhQUEdNaHg0UTR5U1l0RmwvMDgx?=
 =?gb2312?B?QjZCZUNHQXZNNWdCS2JaRUdJV1hKWTJzZEUzQWZMU3VLbnVrZDNFZEpkYWhs?=
 =?gb2312?B?ZjZZR2FFR2xyLzQyby9wUWVCQjBJVWNCeG9tNVdWaFNaZWpiQmx3UGtCZHFa?=
 =?gb2312?B?U0xhWExhYUpCVEpLbFhTSnhFN1UvcHdtcjRaS0VVK3NFNGxiOVNyN0ZxcGxm?=
 =?gb2312?B?ZjZpVWNGMHg5YnlDYnJab3JNN1VDSHZEYjBtRnNuRGJVSitGUUM4Q3lEdHEx?=
 =?gb2312?B?VnMvdjQyNnhicWVOQWI5SWxHcmdzbzFtL25SV3pmSHNlRVBWU2Z3RUNUOE1L?=
 =?gb2312?B?Q3krQzhDeDdkQlFwcDc3bjJKTi9qdE5wVDhtSDhXeUF0SVJ1UFdQSlF3ZlRY?=
 =?gb2312?B?YkcweTVUTUhCSXpjeFdOMEFickhDVVNVVVBPWXFMVHhuQ1M1Z3BCTWR4MHB5?=
 =?gb2312?Q?OyiqXNt4b6tIkXCQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f5abe3a6-2848-4215-fd11-08df16df99dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2026 06:22:52.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Irx3rEmKszItAQU/owangEJA4EARaSD3rWniABpi6JIICerR6Nrk33pXgqA4rgutDPgKk6e5Az/LCSlb0j2JZL//5iuxLiyj5kyyMx0hnXmPsUfdKSzKz8eKgsoF1xw5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1237

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSGVyYmVydCBYdSA8aGVyYmVydEBn
b25kb3IuYXBhbmEub3JnLmF1Pg0KPiC3osvNyrG85DogMjAyNsTqOdTCMTjI1SAxMjo0Mg0KPiDK
1bz+yMs6IExpYW5mZW5nIE91eWFuZyA8bGlhbmZlbmcub3V5YW5nQHN0YXJmaXZldGVjaC5jb20+
DQo+ILOty806IE9saXZpYSBNYWNrYWxsIDxvbGl2aWFAc2VsZW5pYy5jb20+OyBSb2IgSGVycmlu
ZyA8cm9iaEBrZXJuZWwub3JnPjsNCj4gS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6aytkdEBrZXJu
ZWwub3JnPjsgQ29ub3IgRG9vbGV5DQo+IDxjb25vcitkdEBrZXJuZWwub3JnPjsgUGhpbGlwcCBa
YWJlbCA8cC56YWJlbEBwZW5ndXRyb25peC5kZT47DQo+IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5l
bC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQo+INb3zOI6IFJlOiBbUEFUQ0ggdjggMi8yXSBod3JuZzogc3RhcmZpdmU6IHJl
d29yayBjbGsvcmVzZXQgdGVhcmRvd24gb3JkZXIgZm9yDQo+IEpIQjEwMA0KPiANCj4gT24gTW9u
LCBTZXAgMDcsIDIwMjYgYXQgMTE6MTY6MDNBTSArMDgwMCwgbGlhbmZlbmcub3V5YW5nIHdyb3Rl
Og0KPiA+IEZyb206IExpYW5mZW5nIE91eWFuZyA8bGlhbmZlbmcub3V5YW5nQHN0YXJmaXZldGVj
aC5jb20+DQo+ID4NCj4gPiBSZXdvcmsgdGhlIFN0YXJGaXZlIFRSTkcgZHJpdmVyIHRvIGFkZHJl
c3MgaGFyZHdhcmUtc3BlY2lmaWMgcmVxdWlyZW1lbnRzDQo+ID4gICBmb3IgSkhCMTAwIFNvQy4g
VG8gYXZvaWQgcmVzZXQtZG9tYWluIGNyb3NzaW5nIGdsaXRjaGVzLCB0aGUgZHJpdmVyIG5vdw0K
PiA+ICAgZW5zdXJlcyBjbG9ja3MgYXJlIGdhdGVkIGJlZm9yZSBhc3NlcnRpbmcgcmVzZXQgZHVy
aW5nIHRlYXJkb3duIGZvcg0KPiA+ICAgSkhCMTAwLCB3aGlsZSBKSDcxMTAgcmV0YWlucyB0aGUg
b3JpZ2luYWwgcmVzZXQtZmlyc3Qgc2VxdWVuY2UuDQo+ID4NCj4gPiBBZGQgcGVyLWNvbXBhdGli
bGUgbWF0Y2ggZGF0YSAoc3RydWN0IHN0YXJmaXZlX3RybmdfZGF0YSkgZGVzY3JpYmluZyB0aGUN
Cj4gPiAgIGNsb2NrL3Jlc2V0IHRlYXJkb3duIG9yZGVyLCBhIG5ldyAic3RhcmZpdmUsamhiMTAw
LXRybmciIGNvbXBhdGlibGUsIGFuZA0KPiA+ICAgc2VsZWN0IHRoZSBvcmRlcmluZyBmcm9tIGl0
Lg0KPiA+DQo+ID4gRml4IHRoZSBydW50aW1lLVBNIGdldC9wdXQgYmFsYW5jaW5nIGFjcm9zcyB0
aGUgaW5pdC9yZWFkL3Jlc2VlZC9jbGVhbnVwDQo+ID4gICBwYXRocywgbWFuYWdlIFBNIGFuZCB0
aGUgY2xrL3Jlc2V0IHRlYXJkb3duIHZpYSBkZXZtIHNvIGFsbCBlcnJvciBwYXRocw0KPiA+ICAg
dW53aW5kIGNvcnJlY3RseSwgcnVuIHRoZSBTRVUtdHJpZ2dlcmVkIHJlc2VlZCBmcm9tIGEgd29y
a3F1ZXVlIGluc3RlYWQNCj4gPiAgIG9mIGhhcmQgSVJRLCBhbmQgc2VyaWFsaXNlIHRoZSBjb21t
YW5kIHNlcXVlbmNlcyB3aXRoIGEgbXV0ZXguDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaWFu
ZmVuZyBPdXlhbmcgPGxpYW5mZW5nLm91eWFuZ0BzdGFyZml2ZXRlY2guY29tPg0KPiA+IC0tLQ0K
PiA+ICBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKy0NCj4gPiAg
ZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9qaDcxMTAtdHJuZy5jIHwgMjk3DQo+ICsrKysrKysrKysr
KysrKysrKysrKy0tLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDIzOSBpbnNlcnRpb25zKCsp
LCA2MCBkZWxldGlvbnMoLSkNCj4gDQo+IFBsZWFzZSB0YWtlIGEgbG9vayBhdA0KPiANCj4gaHR0
cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwOTA3MDMxNjAzLjE4ODQ4My0xLWxpYW5m
ZW5nLm91eWFuZyU0DQo+IDBzdGFyZml2ZXRlY2guY29tDQo+IA0KPiBUaGFua3MsDQoNClRoYW5r
IHlvdSBmb3IgZm9sbG93aW5nIHVwLiBJIGFtIGN1cnJlbnRseSBtYWtpbmcgcmV2aXNpb25zIGJh
c2VkIG9uIFNhc2hpa28ncyBzdWdnZXN0aW9ucy4NCg0KQmVzdCBSZWdhcmRzLA0KTGlhbmZlbmcg
T3V5YW5nDQoNCj4gLS0NCj4gRW1haWw6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdT4NCj4gSG9tZSBQYWdlOiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+aGVyYmVy
dC8NCj4gUEdQIEtleTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJlcnQvcHVia2V5
LnR4dA0K
