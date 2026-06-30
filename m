Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011005.outbound.protection.outlook.com [52.101.65.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48379409DF0
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jun 2026 12:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821219; cv=fail; b=U8E53bb3oLxkfJr+28f5LGZgO5xnMXSSmXJuryvH+Wti3TpuGy/kVO8LlaSRSxevTQbXI5SvGWTxaIFHQ76Q0pOzJlBuBGl+1KKrm9i8Pz6gZolRuhefzdprxG254hnasw6sI0iMOjuDajJsPqRWtDEYGyAmfYBt3o+NxXbnRnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821219; c=relaxed/simple;
	bh=Ch/7+p1DI9KFhjnXY+ye8Hz7xpSxj3eQLWroY5bpCvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ELj/xi2OczV7+1+t9YmWSM9e+YERygmjf3J1Uq4cG3g87vHruTljRq0zQMjV3RZm8tcnKBvT0mUiDp22RtplBJ7d7XteR2c3YN+p+BFTw+HCMzZYDB/Q6X+4nT5aOut51I5QVtfqEaKIdMFQc+p2QqdtWTExUy6JtmzLMtm80og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=MCSHlAj+; arc=fail smtp.client-ip=52.101.65.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="MCSHlAj+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fB1kiU8WkDJhOADuARa3rHD0lLDQTIhLkrAL+FjbDJrlyaI62JWTwNwPIQkOXc38wOZ517h1eNhSIvvmXtxqwfUD4VwdfcP86Dz8gdUEM41StHbPbtSKGNA87ZOMGSJjxn64RC3iFKuj+qe+lAqrJh52f/v4UNbotMK1vPOLJQ1A8/rn2AMg5DukkW6OcdHAY/3/h1fWYeXKT9fexumc+orA+dxEUTIbl5t/B+5YMgabVB7dTuHl1RYSWa6ZoFuVH22MmtWnHST0ChW5CE+NNIeCVGZ9W1Sm/+iRMlXMrO2oPcn3lvFamVLxl0gf1fXGLNJHrhaICi3MEMxyqkToWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ch/7+p1DI9KFhjnXY+ye8Hz7xpSxj3eQLWroY5bpCvQ=;
 b=gnXeLyDQkE4wgQtgtMcB4LnFg/E8LeYmaMJTifP37/KbUKQBd/w3pUCNQ7fjJpAS+9nitiSRwC3dLECzfozCBwAmvMmQf7C7sGnvZJcaV8bzsnhowRSOkD+KVYA+eNwIa+xojPDtSCYWYWuH7OnPqZ8vRSCpUi5+pSizcXoh9YDsRZjlQKwDfE5CwAM9yimFo+hNDxGc66zVPA5Pn1p0kbJsK3LepeGmtc0a7m0pMroMw9JalPNUXcMt0mTxXJG/JKwQ1jVQ+3CDH+eRsETrz0BLrhtntZR21DwBDu/eS9IaRMm9ckK28GgPhQcKj4rML4BVbcXsATNJN+KH6xW32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch/7+p1DI9KFhjnXY+ye8Hz7xpSxj3eQLWroY5bpCvQ=;
 b=MCSHlAj+qgB+BD50kelZ6/RE979+FP5yTDpa2fF8DyDBv54aa6wc1vilgLkJdHRH/BFbIoZaj91L3SQgtcIIlxa51ggcL+GuOEVaI+VdxtNFiIQ7jOrOV8PVFHlund9Y9cC4QGEsMbPEfbK2Hw/342KptkJldu4NviRUauSk99rX960/nG4K2C/SUC5Lm/L1O50OqGfpE9Cs/Q5FaOXVpfjzeuXjxHsQeyU1P0eHjF8nwTX4503xnDqmEwgC4tbprw0+YIqhI4njiA6tJNgqnHs9Dn1kGsfhtmyqxoqKmnM3Y5DvHzjHFXqAzcWkuwsH9XMEue5fFDA4UZT1cTeosA==
Received: from VI0PR04MB12262.eurprd04.prod.outlook.com
 (2603:10a6:800:326::13) by VI0PR04MB10832.eurprd04.prod.outlook.com
 (2603:10a6:800:267::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 12:06:43 +0000
Received: from VI0PR04MB12262.eurprd04.prod.outlook.com
 ([fe80::66ea:7fc2:5d39:e826]) by VI0PR04MB12262.eurprd04.prod.outlook.com
 ([fe80::66ea:7fc2:5d39:e826%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 12:06:42 +0000
From: Pankaj Gupta <pankaj.gupta@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Schrempf Frieder <frieder.schrempf@kontron.de>, "moderated
 list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
	<linux-arm-kernel@lists.infradead.org>, "open list:HARDWARE RANDOM NUMBER
 GENERATOR CORE" <linux-crypto@vger.kernel.org>, Peng Fan <peng.fan@nxp.com>,
	Stefano Babic <sbabic@nabladev.com>, Frank Li <frank.li@nxp.com>
Subject: RE: [EXT] i.MX95: EdgeLock Enclave secure storage
Thread-Topic: [EXT] i.MX95: EdgeLock Enclave secure storage
Thread-Index: AQHc+zzDY8yWOoAB4E2egJWXS3pUJbZWq9rg
Date: Tue, 30 Jun 2026 12:06:42 +0000
Message-ID:
 <VI0PR04MB122628C9AF157A9732C27068795F72@VI0PR04MB12262.eurprd04.prod.outlook.com>
References:
 <CAOMZO5DgENq8RU6s2CPnKsf53i=7zoBeO38m_BtV=w54hr2hgQ@mail.gmail.com>
In-Reply-To:
 <CAOMZO5DgENq8RU6s2CPnKsf53i=7zoBeO38m_BtV=w54hr2hgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI0PR04MB12262:EE_|VI0PR04MB10832:EE_
x-ms-office365-filtering-correlation-id: 147920b5-8317-4a5b-e82f-08ded6a00cb0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|38070700021|22082099003|18002099003|11063799006|56012099006|6133799003;
x-microsoft-antispam-message-info:
 tOzJ8gQ8fvu5I6KFGYRcppOr5PmYXID2wHODpqsIdgsX4bi8mYF2n8kcDFhjtqhx7actAltt6SmWASK/Wj4NusnGK/7m6mBJbwrrtuZfzWsC/SGLQkM7zAAYRuhdSZb4Q/PX2Kak5YVYkrl0acj/lDI7C1/c83Zig76312V95WWtZgGlHJvg7QHmRECPZkpHAnMynjJXjkVnXRGErNwNHe4KNew8inV7GIoxbO34N2ETSMa53gnE4X6jzblNfff0x0pbVEJq/tFErmKSN1CUH/J9WteedujWQxsNNwF4NhJC+AV0hGvrg2poxR2kUBV6L43hx5tKU5aeZCpNZFzQEKhCbO3eSLxhvGFhHu/ZcLQU4Fs6RjE5OUeLHgLtEMQ//awXvjzeMuYwfi9wAa5CDGXMsI5gTBctlpsJLsXUHauhQB/kDaz3mRW630OlUUXUkdxUGKzOzr3vYJn7bJU091H71VDw95YcyJlqoETUTvKFZChQJMOkTZyTqeBY9mbpV6ZqeKnsMXqK4BXsyJCuTO1oVp5ukR2fa4XnDXLwHOXvPLP6A10lbleybYuH+Y2/Kx9jGAXHI5JXFS17xklrP60LezlEOKTfOQ+c+D0iwI7z6eLZjw8ShgmCffwoAZkdXlRtdnw1PosTKTcXe+zXFYD/aZkPWpGaWO8QdeYmSpfCgeDAg3AX1WDztxrv+iPtN6WiMfc3JmigZedgmZzfjA9j8eWfCWZJL0+OGE/uJNk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0PR04MB12262.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(38070700021)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WEFnZU56MHl3eWRIdkZCM1dIODFDdU1xR0d5QVlRbHRXN2U5L1FScThwWjhV?=
 =?utf-8?B?MU5GNGdyK0RhTW56bzl5MWhDTVgveGZsYStKQnZ0Q05KTnB4ZGdzVjFTQVlv?=
 =?utf-8?B?bU5xWXZJTXRlYysxT3l1TnYvZDRnTXZrNXYrVVBOTVVuOHY0Nisxa0h2Vm9k?=
 =?utf-8?B?MEk1aldoUGxBbkdZdmw2MkYzZTZHbW5ObWh2d21NaERIVHRacEtSSmJva2lt?=
 =?utf-8?B?TnhQUFBhcVpBdXBhSE9QUHF3TUg5TFZhZEFaR21WREtDMEtQd2xNWENXelpU?=
 =?utf-8?B?ZXhHdzVvM1dFTTN0dVBRc0lOUzZrOS9XeCtKcEZLY1FoNk9aSmtYVTJHMGNY?=
 =?utf-8?B?aTF1VUhDZ1p0b05rbXZtOGx0TEpKZzlmSHo5dmhKTml0R042SWhiR3VldHRO?=
 =?utf-8?B?SUdwVjQrWUZHdmEvemxUcGh5Mzk0MGthMWFsTmN6QW96OFlaMk83RlkxUXpG?=
 =?utf-8?B?VFR6NmhrKzVqMW5FSHFFUFR2aWF1VjV0dnl2S01pbTVmY1Z3RFZYczNaMTBW?=
 =?utf-8?B?QWRmaDU3NFZEbVhYSzkyYkYzMHJIUXArYmpJTjN5cHFoUTlOczNycHZDQlJZ?=
 =?utf-8?B?NndHcDM3Y1BBMmx3Snl0dmNxR3dKczN1ZXE1ck8raTJjVGkzZlgrYzEvalY3?=
 =?utf-8?B?LzZIQ1QreGpkMGlyaTU2OGdlbzVpbTZXb25rV21VYW5NdmRxd0pGL1E1Tm84?=
 =?utf-8?B?cTJlYTE1RmcwdGxycnNIcmlCVUN2RXZ6WkxYQzladlMycWdsT0xnL09KcDZI?=
 =?utf-8?B?NWdxK1kyTkcxTXRqZXN2RlF4YnphZ2JXaGVXM2ZwYjA2VzVnRGd6ZDVTRHNr?=
 =?utf-8?B?Ym1td0FIcjF5ZkZESEtUZ09qZ05QdjhOU0gvRUZNWXdGTHJFYmszODJyMjlY?=
 =?utf-8?B?L1MzazJUOTRPU0RyUWRlQW1KczNqU29aMWxSNWFMNjF2RnF5VkdRc28rTG14?=
 =?utf-8?B?Rit5eDQ4cldvZHRyS1JnK09DY0NrYTR1ejFNKzFHdHVEcjZ5dWJsZnlxNUtx?=
 =?utf-8?B?SkttUDVwVE5pRlVVKzFLS1lQY3duWUlUOERkS0Q3MzJJdFNxTTdXWVJIOWRV?=
 =?utf-8?B?RVJQZEc1d0E0elN3S1R5VXhTQVdObXJyUXhCVm92SnBickZQRXpLdmNpdENV?=
 =?utf-8?B?MkI3ZG9Xck55WFdEc20vU0NiSWxZamJHT2pYM3lYYlpYU29CSjdlTGNzT3JU?=
 =?utf-8?B?UTF4bGdxNmFUamZocE5QNVlDajhBNUw0c3ViZFZyNmpZb0dlSjhOZmJVVkY4?=
 =?utf-8?B?NW91S3lMaE53MG9wTGNoVTZ4MU9sMC81aTVHQURrMG5Zck1INDZXd3hCTFJp?=
 =?utf-8?B?aC9TVDBabnFZbDVmaThtVTlLZ1JmU3BCMU1SeXZSQ2wwYWhtbDh1YjlTeU45?=
 =?utf-8?B?OU0vUGZlbENwZGo5MmwvaG81TjBJcWY5aThNdDlxL2QyNHUrc0tIS1VNNkcz?=
 =?utf-8?B?V1pVRkE2WVFPcUk3RDIvY0c3ZVlPNnNIRnNHeHlMeTVTSEJPbktlWkRUa3hy?=
 =?utf-8?B?QllqK09OTFJ0SkNBbGxNMWptZTRnaVN5WE5YSFZybkZOMDQ3RkVnMnlWVGU5?=
 =?utf-8?B?NGJDeXFUYmdLa0cyelBOdFFrV2ZxMmlZRThtWURNTXdrS2QvbmkwSHJaRGt6?=
 =?utf-8?B?V0ZtZ25ibVBLaFN0Wnc1azFjbFVIdTRtZ2ZlTXZWRjkrZE9YNGlmbTZpZUFY?=
 =?utf-8?B?TFhIODVtVkFUK3Q2a0RaUHpEODkvQ3hDL1dmS0xTQlZ5Snc2bGdyZG5IS29Y?=
 =?utf-8?B?WEJPTWs4ZFhYUllhMzlhSXArckVRSGo2eVRzK1NjTHV1ZGFGUFVrQlRBNytD?=
 =?utf-8?B?akNHTWJzemxsYk9YdFFSMllRc3lKOFhHcXhrdU9xZjVvZjVEQ01zenIrOFdG?=
 =?utf-8?B?NE1RcFJDSGhVUWsybEI3c2hkcy9CVyt5OTFvL3BPajRXYTNraGdZd3U3d00w?=
 =?utf-8?B?ZFZWZlg1VnAyS1VPUWpPdGZiV21xUlN1TUlSMm1Hdy8zaHRBdm1RNGNrMUh0?=
 =?utf-8?B?QnMrLzFRN0VxbFdOUEdYYzRRcGc4ZTJZZWhodW9LN2o4TjIxVTFMUlZFMnlp?=
 =?utf-8?B?T2Nla0pic0xvWmpGRThJaWZQcXh4NExpMVVkdVMzcmJMOVluQUpjdWJLbThs?=
 =?utf-8?B?M3NSdGhHR0VVYW9Ha1ZzNENNQjZtTFFPSzZwZnBZT2NKK3RFTmRZMmFEMUl1?=
 =?utf-8?B?K3BjTWIyMVRRenVxR0hHOER5ZFJvbjR4SUpTTFYyMG4zcXJuUm4rSG9rT3VF?=
 =?utf-8?B?TndzQ2FjTytxOW9WVnhvWnZtL2VHTXNLUWJEZktyYjR0bEdRN0tiaXZ0LzlH?=
 =?utf-8?Q?oIdLvXElE5scTcJaet?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI0PR04MB12262.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147920b5-8317-4a5b-e82f-08ded6a00cb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2026 12:06:42.9210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njK2vEb9zXJcgP5yftbUOJ055i1gwp9MoS+iEfQT/dTUCiH/MBTPTXGKoY27z0hypQ8an+JKjyrI/CZAH21/nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10832

SGkgRmFiaW8sDQoNClRoYW5rIHlvdSBmb3IgeW91ciBraW5kIHdvcmRzIGFuZCBmb3IgeW91ciBp
bnRlcmVzdCBpbiB0aGUgdXBzdHJlYW0gRWRnZUxvY2sgRW5jbGF2ZSAoRUxFKSB3b3JrLg0KDQpS
ZWdhcmRpbmcgdGhlIHNwZWNpZmljIGFyZWFzIHlvdSBtZW50aW9uZWQsIHBsZWFzZSBmaW5kIG15
IGNvbW1lbnRzIGlubGluZSBiZWxvdy4NCg0KUmVnYXJkcywNClBhbmthaiBHdXB0YQ0KTlhQIFNl
bWljb25kdWN0b3INCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGYWJp
byBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+IFNlbnQ6IDEzIEp1bmUgMjAyNiAxOToy
OQ0KPiBUbzogUGFua2FqIEd1cHRhIDxwYW5rYWouZ3VwdGFAbnhwLmNvbT4NCj4gQ2M6IFNjaHJl
bXBmIEZyaWVkZXIgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT47IG1vZGVyYXRlZA0KPiBs
aXN0OkFSTS9GUkVFU0NBTEUgSU1YIC8gTVhDIEFSTSBBUkNISVRFQ1RVUkUgPGxpbnV4LWFybS0N
Cj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+OyBvcGVuIGxpc3Q6SEFSRFdBUkUgUkFORE9N
IE5VTUJFUg0KPiBHRU5FUkFUT1IgQ09SRSA8bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47
IFBlbmcgRmFuDQo+IDxwZW5nLmZhbkBueHAuY29tPjsgU3RlZmFubyBCYWJpYyA8c2JhYmljQG5h
YmxhZGV2LmNvbT47IEZyYW5rIExpDQo+IDxmcmFuay5saUBueHAuY29tPg0KPiBTdWJqZWN0OiBb
RVhUXSBpLk1YOTU6IEVkZ2VMb2NrIEVuY2xhdmUgc2VjdXJlIHN0b3JhZ2UNCj4gDQo+IENhdXRp
b246IFRoaXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSB0YWtlIGNhcmUgd2hlbiBjbGlj
a2luZyBsaW5rcyBvcg0KPiBvcGVuaW5nIGF0dGFjaG1lbnRzLiBXaGVuIGluIGRvdWJ0LCByZXBv
cnQgdGhlIG1lc3NhZ2UgdXNpbmcgdGhlICdSZXBvcnQNCj4gdGhpcyBlbWFpbCcgYnV0dG9uDQo+
IA0KPiANCj4gSGkgUGFua2FqLA0KPiANCj4gRmlyc3Qgb2YgYWxsLCB0aGFuayB5b3UgZm9yIHlv
dXIgd29yayBvbiB1cHN0cmVhbWluZyB0aGUgRWRnZUxvY2sgRW5jbGF2ZSAoRUxFKQ0KPiBzdXBw
b3J0LiBJdCBpcyBncmVhdCB0byBmaW5hbGx5IHNlZSB0aGUgRUxFIGZyYW1ld29yayBsYW5kaW5n
IHVwc3RyZWFtIGFmdGVyIGENCj4gbG9uZyBkZXZlbG9wbWVudCBlZmZvcnQuDQo+IA0KPiBJIGFt
IGN1cnJlbnRseSBldmFsdWF0aW5nIHRoZSBzdGF0ZSBvZiBpLk1YOTUgc2VjdXJlLWJvb3QgYW5k
IHN0b3JhZ2Utc2VjdXJpdHkNCj4gc3VwcG9ydCBiYXNlZCBvbiBjdXJyZW50IGxpbnV4LW5leHQs
IHdpdGggdGhlIGdvYWwgb2YgdW5kZXJzdGFuZGluZyB3aGF0IGNhbg0KPiBhbHJlYWR5IGJlIGFj
aGlldmVkIHVzaW5nIHVwc3RyZWFtIHNvZnR3YXJlIGFuZCB3aGF0IHBpZWNlcyBhcmUgc3RpbGwg
dW5kZXINCj4gZGV2ZWxvcG1lbnQuDQo+IA0KPiBGcm9tIG15IHJldmlldywgaXQgYXBwZWFycyB0
aGF0IHRoZSBmb2xsb3dpbmcgaW5mcmFzdHJ1Y3R1cmUgaXMgYWxyZWFkeSBhdmFpbGFibGUNCj4g
dXBzdHJlYW06DQo+IA0KPiAtIEVMRS9WMlggbWFpbGJveCBzdXBwb3J0IGZvciBpLk1YOTUuDQpU
aGUgY3VycmVudCB1cHN0cmVhbSBkcml2ZXIgb25seSBzdXBwb3J0cyBpLk1YOFVMUC4gSG93ZXZl
ciwgaXQgZXN0YWJsaXNoZXMgdGhlIGZvdW5kYXRpb24gZm9yIEVMRS9WMlggbWFpbGJveCBzdXBw
b3J0IG9uIGkuTVg5NS4NCg0KPiAtIE9DT1RQL0VMRSBudm1lbSBzdXBwb3J0IGZvciBmdXNlIGFj
Y2Vzcy4NClRoZSB1cHN0cmVhbSBPQ09UUC9FTEUgbnZtZW0gc3VwcG9ydCBpcyBpbmRlcGVuZGVu
dCBvZiB0aGUgcmVjZW50bHkgYWNjZXB0ZWQgU2VjdXJlIEVuY2xhdmUgZHJpdmVyIGZvciBpLk1Y
OFVMUC4NCg0KPiAtIFNlY3VyZS1lbmNsYXZlIGJpbmRpbmdzIGRvY3VtZW50aW5nIHRoZSBpLk1Y
OTUgRUxFIEhTTS4NCj4gDQo+IEhvd2V2ZXIsIEkgY291bGQgbm90IGZpbmQgdXBzdHJlYW0gc3Vw
cG9ydCBmb3Igc2V2ZXJhbCBjYXBhYmlsaXRpZXMgdGhhdCB3b3VsZA0KPiBiZSB1c2VmdWwgZm9y
IHNlY3VyZSBzdG9yYWdlIGRlcGxveW1lbnRzIG9uIGkuTVg5NSwgaW5jbHVkaW5nOg0KPiANCj4g
LSBBbiBFTEUtYmFja2VkIHRydXN0ZWQta2V5IHByb3ZpZGVyIGZvciB0aGUgTGludXggdHJ1c3Rl
ZCBrZXkgZnJhbWV3b3JrLg0KV29yayBpbiB0aGlzIGFyZWEgaXMgY3VycmVudGx5IG9uZ29pbmcu
IFRoZSBpbnRlbnRpb24gaXMgdG8gcHJvdmlkZSBhbiBFTEUtYmFja2VkIHRydXN0ZWQga2V5IGlt
cGxlbWVudGF0aW9uIHRoYXQgY2FuIGludGVncmF0ZSB3aXRoIHRoZSBMaW51eCB0cnVzdGVkIGtl
eSBmcmFtZXdvcmsuDQoNCj4gLSBJbnRlZ3JhdGlvbiBhbGxvd2luZyBMaW51eCB0byB1c2UgRUxF
IGFzIGEga2V5LXNlYWxpbmcvIHVuc2VhbGluZyBiYWNrZW5kLg0KU3VwcG9ydCBmb3IgdXNpbmcg
RUxFIGFzIGEgYmFja2VuZCBmb3Iga2V5IHNlYWxpbmcgYW5kIHVuc2VhbGluZyBpcyBhbHNvIHVu
ZGVyIGRldmVsb3BtZW50IGFuZCBpcyBwbGFubmVkIHRvIGJ1aWxkIG9uIHRvcCBvZiB0aGUgdHJ1
c3RlZCBrZXkgc3VwcG9ydC4NCg0KPiAtIGkuTVg5NS1zcGVjaWZpYyBjcnlwdG8gYWNjZWxlcmF0
aW9uIGV4cG9zZWQgdGhyb3VnaCB0aGUgTGludXggY3J5cHRvIEFQSSBmb3INCj4gZG0tY3J5cHQg
dXNlIGNhc2VzLg0KDQpFTEUgaXRzZWxmIGlzIG5vdCBkZXNpZ25lZCB0byBhY3QgYXMgYSBnZW5l
cmFsLXB1cnBvc2UgY3J5cHRvZ3JhcGhpYyBhY2NlbGVyYXRvci4NCkZvciBkbS1jcnlwdCB1c2Ug
Y2FzZXMsIHRoZSBjdXJyZW50IGRpcmVjdGlvbiBpcyB0byBwZXJmb3JtIHRoZSBjcnlwdG9ncmFw
aGljIG9wZXJhdGlvbnMgdGhyb3VnaCBPUC1URUUgdXNpbmcgQXJtIENyeXB0b2dyYXBoeSBFeHRl
bnNpb25zIChBcm0tQ0UpLA0Kd2hpbGUgZW5zdXJpbmcgdGhhdCBwbGFpbnRleHQga2V5cyBhcmUg
b25seSBwcmVzZW50IGluIG9uLWNoaXAgT0NSQU0gYW5kIG5ldmVyIGxlYXZlIHRoZSBTb0MuDQpV
cHN0cmVhbSBkaXNjdXNzaW9ucyBhbmQgY29ycmVzcG9uZGluZyBSRkMgcGF0Y2hlcyBhcmUgZXhw
ZWN0ZWQgb25jZSB0aGUgcmVsYXRlZCBPUC1URUUgUFRBIHN1cHBvcnQgaXMgYXZhaWxhYmxlIGZv
ciByZXZpZXcgaW4gT1AtVEVFIE9TLg0KDQo+IA0KPiBBcmUgeW91IGF3YXJlIG9mIGFueSBvbmdv
aW5nIHVwc3RyZWFtIG9yIHBsYW5uZWQgZGV2ZWxvcG1lbnQgYWN0aXZpdGllcyBpbg0KPiB0aGVz
ZSBhcmVhcywgcGFydGljdWxhcmx5IGZvciBpLk1YOTU/DQoNCg0KVGhlIGFjdGl2aXRpZXMgbWVu
dGlvbmVkIGFib3ZlIGFyZSB0aGUgcHJpbWFyeSBvbmdvaW5nIGVmZm9ydHMgcmVsYXRlZCB0byBz
ZWN1cmUgc3RvcmFnZSBhbmQga2V5IG1hbmFnZW1lbnQgb24gaS5NWDk1Lg0KQXMgdGhlc2UgZGV2
ZWxvcG1lbnRzIHByb2dyZXNzLCB0aGV5IHdpbGwgYmUgcHJvcG9zZWQgYW5kIGRpc2N1c3NlZCB0
aHJvdWdoIHRoZSByZWxldmFudCB1cHN0cmVhbSBtYWlsaW5nIGxpc3RzLg0KDQo+IA0KPiBBbnkg
aW5mb3JtYXRpb24gYWJvdXQgdGhlIHVwc3RyZWFtIHJvYWRtYXAsIG9uZ29pbmcgZGV2ZWxvcG1l
bnQsIG9yDQo+IGV4cGVjdGVkIGRpcmVjdGlvbiBmb3IgdGhlc2UgZmVhdHVyZXMgd291bGQgYmUg
Z3JlYXRseSBhcHByZWNpYXRlZC4NCj4gDQo+IFRoYW5rcyBhZ2FpbiBmb3IgeW91ciB3b3JrIGFu
ZCBmb3IgYW55IGluc2lnaHRzIHlvdSBjYW4gc2hhcmUuDQo+IA0KPiBSZWdhcmRzLA0KPiANCj4g
RmFiaW8gRXN0ZXZhbQ0K
