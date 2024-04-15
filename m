Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD93771C;
	Mon, 15 Apr 2024 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713170126; cv=fail; b=LCxG0/fwgG9HduOcTGNruhW4ZvvM9Bil+W0kFKu7UwLsO2zqytms4bQemNdcAGuvSdica9JQAjlMyeQz4qnsB5vqb4Ea8sGkQUQVwkBOALRoqP/QXHpxNFJyY8NT3UWr8BAIB3AGVakpZaS5ztcVW920G7SoGsv+mUVLPy60rBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713170126; c=relaxed/simple;
	bh=raVo5++E6vmu88w0cCji0DQ6G2WMN30CJoupiVDHHJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S30PgY4ySWjV5Zugkd25WDQrvkn3T+XYSOXdWk7aHfHL8JdxCJXai3zeb0fSjPUQhhJBuNcSiWYvEIRTo/h3rzYiL5IaPoYyOPzjX7XBjc40bMzlSTVSasIIlfcFdG49M/WJAPc/j/2HeIZ8ZaZlqBz5/tuUjN3/jjyH0ndqT3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xcylr/UY; arc=fail smtp.client-ip=40.107.100.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xcylr/UY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXhEEkJ/OLcVxM5nRpE6hkqhBliPlA2XTezymDGS9+Ry8Pn6Op3Yf7VcZ/ZmXbnRgbiMwnEADwbZHPrwDUlV8AAhQYvdjVqljG6RidC/7k/tOs1TraMWuwq3cBOSoGmKi3Vah8tDERJGyFXWm0A5QhhDQUKLH9VygHOS18weoBI/J4WhtYE03Ak5EqjIeoFWGj3QopqUPb88Ds3Z7XkeM8BPkFp1ZxEJqzNpuJ0kRjwDXz30gdMSSaONhFzkzMiuWGZweDem6eLVbxDI93EdfSvOUbsF1LRuO+ZO3RzgKdf5uM/IhOpyU/LRjt7i9QuKky23OQn5ZK8XhHlrHVxJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=raVo5++E6vmu88w0cCji0DQ6G2WMN30CJoupiVDHHJA=;
 b=Cj5gW5fv1ARPE7noHHUDLcLDPDdZ7FpMxyHK0SZCp2FlqE7HYIeS6vp1NIUYjmzBFsBNRKhW7HnFL0JtTCDa0jXKrbqbTV8hztKRPbHy2tDPWlJUVeF92NttT0OHN6qzcPaYhaMjwn/3u/dKFzq7z4yfpzkwH14xfhg10aF4hK6qcpNIKZkfqlLpzzQy6hVRrQ+5d9WXxxU4a2oO1q5GkC5/JnlkHgNcluh94eU73eEUE+qdCOhHCvpCK3Vfb7pkqBNEHbQpSd7UjHY+ioO4reYX7+5P7STaDwjwanqZkRjE15Vs0q9nsxQIvPFExm3Os2fFD/J4TjZJlp4z1Nu1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raVo5++E6vmu88w0cCji0DQ6G2WMN30CJoupiVDHHJA=;
 b=Xcylr/UYmx934y9UZ53P/4LqsV3dCSLXXOrlfbo1eJSrUE5ThapBpwy7tQ9k6o+rIMKk1eZGSPzz1fp3jnHKMsa5tC96E/4MQxBAHhBdlOcgpBzybh572NaXVwZDG2cWSwRClSjW1N1zG+H1YygjY8hLtBmrvocc8miDL7cPTH4E75pjrcPI1ja4EvNNvq0Ok1vLUi+K49UsKrtFNIO9dQEQy7HkXkwDXEDmuTcjgzPBlweLtj/Myy6DR9tZ9cbRJtQ+P/164LlTZSPoJIk0Tb2yDjl4wq579jAuFugMB7iBa/Iufci7JlZF818dP8zLInvMqjiCVLNbj6ae9RmSJA==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by BL1PR12MB5754.namprd12.prod.outlook.com (2603:10b6:208:391::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Mon, 15 Apr
 2024 08:35:21 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%4]) with mapi id 15.20.7452.046; Mon, 15 Apr 2024
 08:35:20 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: Thierry Reding <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>, "kernel@pengutronix.de"
	<kernel@pengutronix.de>
Subject: RE: [PATCH] crypto: tegra-se - Convert to platform remove callback
 returning void
Thread-Topic: [PATCH] crypto: tegra-se - Convert to platform remove callback
 returning void
Thread-Index: AQHajwdiuUfO6OmHjkyU/ibIZre/VrFpAWpw
Date: Mon, 15 Apr 2024 08:35:20 +0000
Message-ID:
 <SJ1PR12MB633956D7D500000ECE65887CC0092@SJ1PR12MB6339.namprd12.prod.outlook.com>
References: <20240415073422.8274-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20240415073422.8274-2-u.kleine-koenig@pengutronix.de>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|BL1PR12MB5754:EE_
x-ms-office365-filtering-correlation-id: 1150c06c-557e-4aa5-5b43-08dc5d26fc92
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 XF7Ga1ysFl5CGVv4N64ZZlnDiNAInUBrzU3s7YWPifLZlUbFFMV+Z2Sgm/RRUpurO7vAX9jXz01DPzBSxi0muBIMCD28IctUnb9QL2bhRp7Eg/m58Q6W2lYI/yTAcN01L0lWmmEKqOYMp5VhMlzQc0Dt1yYP6hwUVSEivd6rRd5MqaVXU7x+4abLOaz1Nh5gqMgqmlWdPUQsN5N4TuBz/P1s0KBiC/54IARidVBHgw7l1FZWJANdN7jt147d+HC0tU8zypP7b8/vMdPcwzX1iQG1b3jOqfJr6IXH1PJY3/Zewb5uPu0KUQHZb3qAsNowA83mZcBcjii78w6Ef/mON9KkX9Ckg7ubh5TxGHUDWZ4hXgcHzopn6xGko8EmrNovBnsmxBr9cuqSvEdmEer3TynEeDKjwDfzuLJxzqE/dBqdnkC/Wa/lA4ZIiAO2GHSWX63FbytmYNopyUUdCirWdGWLun3jWXamXPu2yCmlDE9zkuRNY35OJgxq83CWjcjUvfCx2wATcSZcZZMJm+9drywrrYe+ZezTQw6dNa8G+9E08rRYLEc6bNxmwlxuoHB//SewAfbxVHQ0OZXESJrfMPODsj7KcbeEv8qm0X/AWh+x1L+/PIWvYWpnoEXMn1gMv/yIl7To138sDXSGpgk5/AFrm/6Rxtrb99kkizg9TBYqBfhVXSbz+v1lIiEuTsVl/7en1Lzus5OvTJ7OasgNPyW/4Nht/6fOOsa+U9hx+JA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aGlwNzlNcENtcGxqT1VSOXczVFdRQTJVTElmazRldGg4OGsrUGVRRGIrTk05?=
 =?utf-8?B?VzlMVWVZL21DOGNyc2o4NTFqTzZCbm43VVBiWTU3eTk1N3gwSFJSbTI4blgw?=
 =?utf-8?B?M3NicHZ4dHRRUWFGUk5CWkhLUVc4cngzL0dDRGVCS3NtdlpqL3FvaXE0ZVNk?=
 =?utf-8?B?cmZ0OEI0bzhCNnB4YnVlR0VCZnRZcFFUZjFMcjJJeFFPOEwvb3VjZWUzS2hS?=
 =?utf-8?B?elcvOUlLL2dad252NSt0S3ZEOG9hMmlLclJzbzVsWlMyd3FvSWE1cE85TlF5?=
 =?utf-8?B?cHltZDNhbVh6anZKSFhyRDF5S1paejkrS2NEcmkySzVBeGE4dnBINEpBTkdn?=
 =?utf-8?B?eVl6cVBRRGgwRWZxdmtCK3dSakdjamFscU9oaGd2TVJFSEhJR2FSOTJnM1Vj?=
 =?utf-8?B?RjlqcEozbTBpMXQrZm1WSlUwS3dTZ2FTVUJtNyt3QkFaWTM2ejVndkZzUTVQ?=
 =?utf-8?B?NHV3MEdicVk0MmpFNUFwYytDWU5BL1FOZUNUb0ZmdXBIcE93UElhS0RkajBZ?=
 =?utf-8?B?UXE0TWpSS2Vta2xaRlBXNWM5NElZZDd6cEtYVlN6N3Nud0wxaUYwVU5pc0J6?=
 =?utf-8?B?YzRmQnQyaEJWM1Y1VUo2ZktTZzhCYXNzUS9BQ0M0SWJkYlZ4Y1BZS3hlbjBD?=
 =?utf-8?B?dW1BZzFYSkRoYjhVUThabjlWV3JSRlBnbW51bFBLMFpXOVpDSkplT1dRVXZ3?=
 =?utf-8?B?YzQ2dVJVVU1HdFVMZWxXbGR2NWtoWFlUY0FNcjZ6MW10ZHJzTkVLMUVNazEv?=
 =?utf-8?B?NG5mOURBbzVVbWZ3bnd4TGNCQnI4QmN5Z1lqWkgzaElvbjJlZlJtMXlHZTZD?=
 =?utf-8?B?b09MS2l4MjdVYVlkdk1YMzR5SVZtbU9OK2J1RmdmSHUrMklJZFhBZFBGTEl5?=
 =?utf-8?B?R2J4SDJ3NHh0c3JhQUJ2SFM3SmVLemZvU09JZzBMS0lZTjgzL2dMTGtMUnRV?=
 =?utf-8?B?MW44MmdCRWJnMlcrQThhakl2a0Q5b0dIejA2L1FmNXhqWW1DeWdVT1ZYT3Z1?=
 =?utf-8?B?N2xFb0JzT2Y5YlQyQ1pXQjQzNFhpMGdqSk9kU01SVzUxR1FXd2djdFdXeWpP?=
 =?utf-8?B?WTNFNnNDNlVwN3U2SHVvSlpvVDEzSk9MT2NYTVNuMm81VU1xN0tsc3dmWDNy?=
 =?utf-8?B?NkRua2FoN0NkYkNob29lVW1IeEc1TXZsREIxUWFvOEQySjg1UzRpWnU0Vk9S?=
 =?utf-8?B?b3JnTC84MG5QQkkwZS90RHlKejR6U01ZaGtIQXBBZDdENW1nNmF1QS9BWTBX?=
 =?utf-8?B?Y0l4NENvK3FVTkRqWXhjc0JLb1JLVEFiYktVbWR4RGlIMWJvN2NlQkcyMHVp?=
 =?utf-8?B?dXNWcDBFYndhbmtDOFNVTzdvSC9yTTV0dXV6TWNsWXZlMEtlbVlzSDA3YU1p?=
 =?utf-8?B?REo5QmF3WDZ6VmRuNDFoS081M0NRS2lrOWM1SEE2alJMY0pKS3VkTWgzMEtG?=
 =?utf-8?B?SzczcEh5TUhndGsyenV3Tm5lM1dGUWR5eXc5K2xRSGFNYTJVVC82bzcycUdP?=
 =?utf-8?B?YnNOVFl2UEdHYlFjcGJwRHBKRCszVHlONzBoR0VkNXRBQUVBZVlXNDVZNE5u?=
 =?utf-8?B?UDF6MXlXVFNQUEg0eUlvOGN0OE1JWUlWREs5SGlZRDdvU3hORm1xZS9peDk3?=
 =?utf-8?B?WEtUL25MWEJRaFg4Ym05c0pCcnA2U1NRcTFuaU1BdzF3Z3YyTjJSVXBXTjVm?=
 =?utf-8?B?WUtNTk9neGFTSTZxbGdWT042bFpOMFIrZCtTZTJoK0NxYzZqS2FGcWRKbm5X?=
 =?utf-8?B?clZxMTRGNnlnZi8rcWtNV0Y4TG5Fc3p0T2VZUStOcXJKalVnVGhEdHFKc2RG?=
 =?utf-8?B?dWdaMlJQazNSQTBDeDF2MVBLNkt3WTloM3RMNlYvekFVaHRaUDNqY0owZEpj?=
 =?utf-8?B?YWV1QmZLbk9HK2VOMlBHanF2Tmo1SzRrTVFldytKZGdaL1dxMVQvMWRGdUR1?=
 =?utf-8?B?cjZhQTVrVlI3T2dtd2RBQlNyalNXYjBUenNFWW11VUQ2cUJaQmdkOWt6QUpk?=
 =?utf-8?B?SWZUWktQOGdoakFDMjZ6aVhLeUcrY3psbkpTMGZyOUd0UHRyVS9LaHRHaks0?=
 =?utf-8?B?U3hQZmFaSWFtcjUyVjJtTnVQSkcvajA5Q3pkL2lkWDFlYktSRjB2NW1mYWww?=
 =?utf-8?Q?s8/nG0YUUQFfuEXc+hrPYDNKb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6339.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1150c06c-557e-4aa5-5b43-08dc5d26fc92
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 08:35:20.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cx8x35Cblgcw9vRY1R1NRHDebVe6f98y4VLGx8L87ppbrRY32iQH73hUwU82n4AuIs8ZBeFBEK/TVMYcqSkfLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5754

PiBUaGUgLnJlbW92ZSgpIGNhbGxiYWNrIGZvciBhIHBsYXRmb3JtIGRyaXZlciByZXR1cm5zIGFu
IGludCB3aGljaCBtYWtlcyBtYW55DQo+IGRyaXZlciBhdXRob3JzIHdyb25nbHkgYXNzdW1lIGl0
J3MgcG9zc2libGUgdG8gZG8gZXJyb3IgaGFuZGxpbmcgYnkgcmV0dXJuaW5nIGFuDQo+IGVycm9y
IGNvZGUuIEhvd2V2ZXIgdGhlIHZhbHVlIHJldHVybmVkIGlzIGlnbm9yZWQgKGFwYXJ0IGZyb20g
ZW1pdHRpbmcgYSB3YXJuaW5nKQ0KPiBhbmQgdGhpcyB0eXBpY2FsbHkgcmVzdWx0cyBpbiByZXNv
dXJjZSBsZWFrcy4NCj4gDQo+IFRvIGltcHJvdmUgaGVyZSB0aGVyZSBpcyBhIHF1ZXN0IHRvIG1h
a2UgdGhlIHJlbW92ZSBjYWxsYmFjayByZXR1cm4gdm9pZC4gSW4gdGhlDQo+IGZpcnN0IHN0ZXAg
b2YgdGhpcyBxdWVzdCBhbGwgZHJpdmVycyBhcmUgY29udmVydGVkIHRvIC5yZW1vdmVfbmV3KCks
IHdoaWNoIGFscmVhZHkNCj4gcmV0dXJucyB2b2lkLiBFdmVudHVhbGx5IGFmdGVyIGFsbCBkcml2
ZXJzIGFyZSBjb252ZXJ0ZWQsIC5yZW1vdmVfbmV3KCkgd2lsbCBiZQ0KPiByZW5hbWVkIHRvIC5y
ZW1vdmUoKS4NCj4gDQo+IFRyaXZpYWxseSBjb252ZXJ0IHRoaXMgZHJpdmVyIGZyb20gYWx3YXlz
IHJldHVybmluZyB6ZXJvIGluIHRoZSByZW1vdmUgY2FsbGJhY2sgdG8NCj4gdGhlIHZvaWQgcmV0
dXJuaW5nIHZhcmlhbnQuDQo+IA0KPiBGaXhlczogMDg4MGJiM2IwMGM4ICgiY3J5cHRvOiB0ZWdy
YSAtIEFkZCBUZWdyYSBTZWN1cml0eSBFbmdpbmUgZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTog
VXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5pZ0BwZW5ndXRyb25peC5kZT4NCj4gLS0t
DQo+IEhlbGxvLA0KPiANCj4gdGhpcyBkcml2ZXIgYXBwZWFyZWQgaW4gdG9kYXkncyBuZXh0LiBH
aXZlbiB0aGF0IEkgd2FudCB0byBjaGFuZ2Ugc3RydWN0DQo+IHBsYXRmb3JtX2RyaXZlcjo6cmVt
b3ZlIHNvb24gKHByb2JhYmx5IGluIG5leHQgYWZ0ZXIgdGhlIHVwY29taW5nIG1lcmdlDQo+IHdp
bmRvdyksIGl0IHdvdWxkIGJlIGdyZWF0IGlmIHRoZSBkcml2ZXIgY291bGQgYmUgYWRhcHRlZCBp
bW1lZGlhdGVseS4NCj4gDQo+IEJlc3QgcmVnYXJkcw0KPiBVd2UNCj4gDQo+ICBkcml2ZXJzL2Ny
eXB0by90ZWdyYS90ZWdyYS1zZS1tYWluLmMgfCA2ICsrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL2NyeXB0by90ZWdyYS90ZWdyYS1zZS1tYWluLmMgYi9kcml2ZXJzL2NyeXB0by90ZWdyYS90
ZWdyYS1zZS0NCj4gbWFpbi5jDQo+IGluZGV4IGY0NzU4ZTMyMDYxNS4uOTk1NTg3NGIzZGMzIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by90ZWdyYS90ZWdyYS1zZS1tYWluLmMNCj4gKysr
IGIvZHJpdmVycy9jcnlwdG8vdGVncmEvdGVncmEtc2UtbWFpbi5jDQo+IEBAIC0zMjAsNyArMzIw
LDcgQEAgc3RhdGljIGludCB0ZWdyYV9zZV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpw
ZGV2KQ0KPiAgICAgICAgIHJldHVybiAwOw0KPiAgfQ0KPiANCj4gLXN0YXRpYyBpbnQgdGVncmFf
c2VfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICtzdGF0aWMgdm9pZCB0
ZWdyYV9zZV9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gICAg
ICAgICBzdHJ1Y3QgdGVncmFfc2UgKnNlID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7DQo+
IA0KPiBAQCAtMzI4LDggKzMyOCw2IEBAIHN0YXRpYyBpbnQgdGVncmFfc2VfcmVtb3ZlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ICAgICAgICAgY3J5cHRvX2VuZ2luZV9leGl0
KHNlLT5lbmdpbmUpOw0KPiAgICAgICAgIGlvbW11X2Z3c3BlY19mcmVlKHNlLT5kZXYpOw0KPiAg
ICAgICAgIGhvc3QxeF9jbGllbnRfdW5yZWdpc3Rlcigmc2UtPmNsaWVudCk7DQo+IC0NCj4gLSAg
ICAgICByZXR1cm4gMDsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHRlZ3JhX3Nl
X3JlZ3MgdGVncmEyMzRfYWVzMV9yZWdzID0geyBAQCAtMzkwLDcgKzM4OCw3IEBADQo+IHN0YXRp
YyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIHRlZ3JhX3NlX2RyaXZlciA9IHsNCj4gICAgICAgICAg
ICAgICAgIC5vZl9tYXRjaF90YWJsZSA9IHRlZ3JhX3NlX29mX21hdGNoLA0KPiAgICAgICAgIH0s
DQo+ICAgICAgICAgLnByb2JlICAgICAgICAgID0gdGVncmFfc2VfcHJvYmUsDQo+IC0gICAgICAg
LnJlbW92ZSAgICAgICAgID0gdGVncmFfc2VfcmVtb3ZlLA0KPiArICAgICAgIC5yZW1vdmVfbmV3
ICAgICA9IHRlZ3JhX3NlX3JlbW92ZSwNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCB0ZWdyYV9z
ZV9ob3N0MXhfcHJvYmUoc3RydWN0IGhvc3QxeF9kZXZpY2UgKmRldikNCj4gDQo+IGJhc2UtY29t
bWl0OiA2YmQzNDM1Mzc0NjFiNTdmM2VmZTVkZmM1ZmMxOTNhMjMyZGZlZjFlDQoNCkFja2VkLWJ5
OiBBa2hpbCBSIDxha2hpbHJhamVldkBudmlkaWEuY29tPg0K
