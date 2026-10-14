Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021100.outbound.protection.outlook.com [40.93.194.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BC43F3297;
	Wed, 14 Oct 2026 06:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791961177; cv=fail; b=u84BFXefDvmeGQsAN77Wh4g6eEnJh7wUVW8uqS5mkY8Xgq5r8j6qHhJP0NtZJMZqES6cWA8ehpzd76fq2Hr+55YPXNEn9AzAoqT+kc8bOUEaQmBz7CPSDMDaDKWbx/8oaGOVWcUDKHJZSJsh7iTw9wjietbhEydUTMF7M9Smycg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791961177; c=relaxed/simple;
	bh=/fCR+4VhAXr+BNXH1Gc5pPfiPZC3dACwdP3lS3KDKwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gZUHwsIG67VT5nPeS5igo9mi+raNYqe8+VLTfdmiGrB0qYp+YuSc3RDtKgr3Z7qG23Dslu77j7ZiF0HuX+/AquZlQA956BDwnpbHXRy1rmvdN8rkFTXlGvr01/tprfsle9cnnw0wuCSd9VxpyTbY2jR2sWv19eTs07Cq9Q7tFRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=A+Psn6GH; arc=fail smtp.client-ip=40.93.194.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="A+Psn6GH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxGVEeIQ3o9kITe69tNKxKUn8gr6hnR9U5/tVWBfu9KM9h3Vdr88hNLFMvryaXVRlEndQuMvrRClgUVUzlTTMeO1bGmD1+nqzEXbOKr+dUDDIQ8SSEFAfeGN13AIzft5aCPf5U9amNO4wcfd7zHKN8vYosU5i2qvWtg/Sjfxko+F05Gg/4r1VmwH5Ps5zO1PajdJunIwV6cQQSqPv/J+ZvJopjPZ7xcomaj0kUStbSKXmaifG2e5Lk9ScmtaElPVfw+PRFzpDOHglwjueUAgNxZVywOG7v3kh67L/jcv0uZ4mJFYfrqQ9hL53QW3SsjgzFyPp7coUjuCF6ckN8ySrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fCR+4VhAXr+BNXH1Gc5pPfiPZC3dACwdP3lS3KDKwo=;
 b=iBO8Bq92Rvr0HkyTuQ5N1XTPP3asRGLnCOV+sHrQT7yMdBSvsHKxKyB3cj4msjH5OV088yZkG99A9FxcuiSBI0ljJxTb+zFdqhdw4SJiU5uxciQDeCTnXEVT4D4G6mTXWr8+Wtd/Z0OmaT/Ik3HCUhZx9Kes259U5oDZenz7dEMn+QboqPJASclI1jxxnlFIk44auxhAIPXYUM3di4uyGOIUOixjyZ9hWA0xRMP1nJ4ryzHpvlUKrCR+pLtpSzEMmj9bUNzNdqGP1KaUZr3I7bHKPLsEVj5Vl+Inb5KMvw89xLtj9N2dmhdcX0fWqzwLP4s7/FohlYn1ZYptKGVo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fCR+4VhAXr+BNXH1Gc5pPfiPZC3dACwdP3lS3KDKwo=;
 b=A+Psn6GHolQJzQQrVCuI1VOSlAL8EKHUl7J16SxiTE7pFC+5M+cjOJoR26UT/Co2h5pj1cOQNy3NKlesav+tSBUJaOkhqwo2+zu8hoQZ3C8UHFgnJFWlZBqniR/vUxkQbA6lI82UOzjQDl1NME9XC3tINrynbO36jtymNjQUT/mwJ7aTTSiTSN+wNwuDvU9XcaG+7DgNY1PU9xNCzTXK809Ttj9NKW84hIqjU/YCz7zKvcH6NzYX0NGXspUF7Pt09JEx+GlFfFurV+XjxhdUheanDSDbtg6txv1DBw7EBLEL1OHzP9gqeacP1jJ3UmYd4T5uk7djR15EenOAICJzvQ==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by IA5PR04MB993664.namprd04.prod.outlook.com (2603:10b6:208:607::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 06:59:32 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 06:59:32 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>,
	"Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Wittenauer,
 Joel" <Joel.Wittenauer@cryptography.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Thread-Topic: [PATCH 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Thread-Index: AQHdWztBtMgNcX/6CUCDBfeDZajIgbb8jAaAgAAQYSA=
Date: Wed, 14 Oct 2026 06:59:32 +0000
Message-ID:
 <SJ0PR04MB8406C7BDC9EAF3C747E998AAD79D2@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
 <20261013174847.2192609-2-aousherovitch@rambus.com>
 <2590dca4-70d0-4de9-be9c-d76657dd3239@kernel.org>
In-Reply-To: <2590dca4-70d0-4de9-be9c-d76657dd3239@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.14.0.414
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|IA5PR04MB993664:EE_
x-ms-office365-filtering-correlation-id: 58d45a13-0ea3-4249-8d13-08df29c0b2ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|38070700021|56012099006|4143699003|11063799006|18002099003|22082099003|10067099003;
x-microsoft-antispam-message-info:
 lLW6RT5amDdlCC9EupwiWmyUw6q1pCO5sPMCx7u3kWwtyj0CA04jOILtAhwxrft9WAbpEGpBFATPrADl5H6R+V1eVmJR6pr8j+UWyBelFR+EV4YPdPfiCy4dddPEgNSLhs42rrkCFLQFnUdhtszZ9F0pY5hENjtcya0luPOyYNszHfhhjV5CyKhLfYc+ywVUslDe3ZwjTR/01N2O0u045uHrycyZU5tdZ0kc8988VGa1l3LnwiODW3iW98LczoafVrIU8Nsi04bB5KxHiKwjqUfciZaTi443zqw3cV54/mOkIORYVcz6VbuZqqnIcEPCX0BLLbq9VGn2fCHBtG3beMrP/iQVgVJd5Pm3JZXvIS/W8EawwrdWsbPQ7SfutUnyAZmWjEliHZNp+n19ah4EywX9z2e34kDR8NuCQno3h2VeslcaQFFtXgSx2OTjcB1QaJ/yDpzLAov4l0uGDlWvwTwRYlcbwb4ZSztDgXSLrhbDw/xO7VUC4S623hEihpm+46XDWfZ7j8GljEvFdaJrAkE9BL/kMUVnLQ/DWlFmnedMKcXO/Jrg4i0HV4OUpSVc4S8W+Ze9y3S7ZjHhkcPQSYz8u1tJT1mAw8KkieNWmzyHcmDVh/TtYWZiJkORisuvrPxsSsSzkeARviRMKvQZHCkVKj5QBtMSavZRFreXMK8rD6fT1GiiEO2wjIoDf7jMcMjmn0G66jMDAtGw/LrQNY8p2adVEZbuMfGCotyGJ4c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(38070700021)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c2pyMnZieDlsMzNWcHNLZXY1QUY1QVdlSWVhUUtCQzlRWSs0Sms2TmFsZ2lz?=
 =?utf-8?B?YWtXOU5yZU9DUlR2bFl1NzU0OHVqbWtvTGhuQXA2OVcvYjNna2ltVndDSkI0?=
 =?utf-8?B?Uiswb3A1Qys4T1ZlMzNNOWE2K2hueEpJQmNGRlNBQS9BR3k1NDRMU1N5RWw1?=
 =?utf-8?B?eDZScnhJTzhteWNDWis4ZTgvOVhzRDNqTFMzbm1GTU5adnpWYjVzOXdtRHhU?=
 =?utf-8?B?VHovcVRZREJIZmd6d0Nla1dyK1RXcmlXZFRRdUFpcDM4QXloTjVLV3RpOWNU?=
 =?utf-8?B?aEt5ZW1id1pnYzZVV2lEMFpzQXVyNlpsZjRJb2J0QVF6UDAwOE40WE42OXpr?=
 =?utf-8?B?ZVBOZW5mZnA1cFFyOE9PWURWVlVrQit4azR6S2t5d04vQkdvcmVWMXVUNysz?=
 =?utf-8?B?ZHZJVmR5eTV6KzJXT05TbHlwMnNLSTYya3NqWEUvbkp0UmFNQUx5Ti90Z3pI?=
 =?utf-8?B?M00waS8rVytIcmh4VjBuUklDQ2RJcEpKWHovTHJSbTE2TkZZSzJ1ZWFvVUxR?=
 =?utf-8?B?d21WOFZUOFlnK2lGREhBN0tldDRWZEhjY3dmcGRaMVFuazZ3UzFUYUVqZzB5?=
 =?utf-8?B?U0szV3lSaDJlVi9VeXB6bFBDRndQTkRRcFpJUHZDSmNaalVSc1YvVmNKbkVS?=
 =?utf-8?B?dXMyRHFtQXQ4SHAyeFd6cmo3Q0h0NUh0VlZzTWZQbkRaOHpOSm1XSkdSdndx?=
 =?utf-8?B?YWpRN2c1ODlac2FFMHRkTXVJeE1DWFVrUElOaEF6a3cyWjMxb2x3cW52cXpH?=
 =?utf-8?B?NzBmMHNkdmhwVGNwQlRQY1hEMUVPc2lnZ0RpQ3VuR1Fic3p1NUQ1YzF0NVA1?=
 =?utf-8?B?Z0lTeElHREwwdkdERjAxS1RORTZUWFlYbCt2V0tLeFBPZFZFdzZtRSttaDR3?=
 =?utf-8?B?ZDkxNjNjby9iZU5maDdQYjEwZ2tRbjlPemtsTHhXMzlqdzRDK1N0NTRVM1Fm?=
 =?utf-8?B?TjB0dU80RjRHUUhUN21KR0dCMWdvTzU5bkRpbWYzVDlkRDZ1UmgrRVUzaXVl?=
 =?utf-8?B?WlNlUjFpdVNtakRTdUJpOEZqZGNXS0NXcDBsNUFGOVMrRXcrZG55ODhYdVE0?=
 =?utf-8?B?aDFjUWE0SnovSENqd3ZyVkJEd3JwNHB5UXdhcytVdmh1dkVrSHlVU0hYb1Vk?=
 =?utf-8?B?UnF1TWlUMW5FejVrYm9hVEhRaUdhUGdMTGdSaTRqWEYrY2pxQ2xZaUZROVYr?=
 =?utf-8?B?eWdCOGtjaU44SjJrcW9hNVgyUk96OVBvRnF1S0tBSU02alBuT1JSeUxpbTB2?=
 =?utf-8?B?YkFqWXlyck00OExtL1ZDdFl0K2ZlMTlvbFUwWTBhQjRoY0JmdG9VUUgxY0R2?=
 =?utf-8?B?OG5SK1JwdldUZURxRzBHWEVJdlowWk5FVVp0VXY3S3BLSFhwNGRJemdkcGMv?=
 =?utf-8?B?UkVVck40dzVzcVJZOHdHa3orVVdtQzFLMmhVbU9Kd0xia1lMajRZOFRRbS9y?=
 =?utf-8?B?WUY3SHBOSnNOQkQ1VTdWQWNDTG9EQ0pCV0g0cXN4ZFZMM0FEYjZWR3F4WjYz?=
 =?utf-8?B?cUdvRWdBSDhhMUJuaXpLUlM2VnVkdnRXKyt1MlptU0tGWjg2b2k4akFXSTJM?=
 =?utf-8?B?bTJNNzJqNjR0ZVFYSmhJeitHTy9QNVdFNWZ3a0tPb3RsOUlobldDMDR1Q0Y5?=
 =?utf-8?B?cjJXWXhYRkxiUWVKVFJPSXNXRXpKVEpFbk5MNC9RV1R5VXFIQjZCTGVGWWs3?=
 =?utf-8?B?SThUQk56WWRzb1g4dE9nWStLZ2hTN1NjOXkzQlZOSjVUSi8vc0tZU3V4ejJh?=
 =?utf-8?B?Ukt0N3VzNGJjZUFpcDh1VG15WnVSQ2ljUXU5MzZWazdXcGJybDN2S2V5QnR4?=
 =?utf-8?B?bTl3QWhReG9QNjZoLzFlSjh4VnRxS0F2TXQ2U2JwZ0ZaaTlDM1N6T09NbDd1?=
 =?utf-8?B?MjVIS3BDRTNyMWpqd1lPY0czZ1Y1K1ZrQTF4aVBZZlJYREdnQ24vS21HK2d5?=
 =?utf-8?B?VHpWeFVGTkFVdFdqeFVoR29ESnREZDdsK3hvaktjTjl6dm5iNUVQYVZHZU5I?=
 =?utf-8?B?SVNEdnU3M04xMW53NXBhZVdJeU9FSkRHdHd0aFhGUUxnWm9CcUl4K1ZyTktR?=
 =?utf-8?B?YzdKL3FGQTVONDZOYVdyTFh1amJZL3hFMFZCNzJDTzFRVWQzWVd2WWNuTmtu?=
 =?utf-8?B?eDJXL0l1a0Z0OXZ6cS8ybmZyMWgrUlJmT0wrS0pNcXFzSVl4R3ZXaVQ3aDdO?=
 =?utf-8?B?QTF4bSsvbjlyMzJsWlZlcnhQenM2MmRibVlOeHo4ellob0xFVzc2NmhaM3VO?=
 =?utf-8?B?Sk9tQ1JuRG5VZ2E5UW5OZVFkUG9HNitrVDhZUURJNGFUZHNJcVcrUDRkbWJM?=
 =?utf-8?B?dmVEdDlBNzNGZXdtWVVobjcvcXkrVkpRZW9KOG5DWnVEcDlDZnhJZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d45a13-0ea3-4249-8d13-08df29c0b2ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 06:59:32.1594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHFeCx9GebMD9zr5dNi3/ishdYkaWRqA5goSXv7mPw4BqpzZVdnWrh/WbkchWd2rD3L6+ho6xrxIP+Gyc+z1xTdSLgAAgRHoHpRiI3DW5Sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR04MB993664

T24gV2VkLCBPY3QgMTQsIDIwMjYgYXQgMDc6NTk6NTlBTSArMDIwMCwgS3J6eXN6dG9mIEtvemxv
d3NraSB3cm90ZToNCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IE91c2hlcm92aXRjaCA8YW91c2hl
cm92aXRjaEByYW1idXMuY29tPg0KPiA+IENvLWRldmVsb3BlZC1ieTogU2FyYXZhbmFrcmlzaG5h
biBLcmlzaG5hbW9vcnRoeSA8c2tyaXNobmFtb29ydGh5QHJhbWJ1cy5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogU2FyYXZhbmFrcmlzaG5hbiBLcmlzaG5hbW9vcnRoeSA8c2tyaXNobmFtb29ydGh5
QHJhbWJ1cy5jb20+DQo+DQo+IFNvIHRoaXMgdjYgc3RpbGwgaGFzIHdyb25nIERDTywgdGh1cyB5
b3UganVzdCBpZ25vcmVkIGZlZWRiYWNrIHlvdQ0KPiByZWNlaXZlZCBvbiB2My4NCj4NCj4gTkFL
DQoNCllvdSdyZSByaWdodCwgYW5kIHNvcnJ5IC0tIHRoYXQgc2xpcHBlZC4gIFRoZSBjaGFpbiB3
YXMgb3JkZXJlZCBmb3INCktyaXNobmFuIHN1Ym1pdHRpbmc7IEkgYW0gdGhlIG9uZSBzZW5kaW5n
IHRoZXNlLCBzbyBteSBTaWduZWQtb2ZmLWJ5DQpoYXMgdG8gYmUgbGFzdC4gIFRoZSBuZXh0IHJl
dmlzaW9uIHVzZXM6DQoNCiAgQ28tZGV2ZWxvcGVkLWJ5OiBTYXJhdmFuYWtyaXNobmFuIEtyaXNo
bmFtb29ydGh5IDxza3Jpc2huYW1vb3J0aHlAcmFtYnVzLmNvbT4NCiAgU2lnbmVkLW9mZi1ieTog
U2FyYXZhbmFrcmlzaG5hbiBLcmlzaG5hbW9vcnRoeSA8c2tyaXNobmFtb29ydGh5QHJhbWJ1cy5j
b20+DQogIFNpZ25lZC1vZmYtYnk6IEFsZXggT3VzaGVyb3ZpdGNoIDxhb3VzaGVyb3ZpdGNoQHJh
bWJ1cy5jb20+DQoNCk9uIHRoZSB2ZXJzaW9uaW5nIGFuZCBjaGFuZ2Vsb2cgeW91IGFyZSByaWdo
dCBhcyB3ZWxsLCBhbmQgSSBoYWQNCmFja25vd2xlZGdlZCB0aGUgc2FtZSB0byBDb25vcjogSSBy
ZXN0YXJ0ZWQgdGhlIG51bWJlcmluZyB3aGVuIEkgc3BsaXQNCnRoZSBzaW5nbGUgc2VyaWVzIGlu
dG8gc21hbGxlciBvbmVzLCB3aGljaCBJIHNob3VsZCBub3QgaGF2ZS4gIFRoZQ0KbmV4dCByZXZp
c2lvbiBvZiB0aGlzIGNodW5rIGlzIHY2IGFuZCBjYXJyaWVzIGEgInNpbmNlIHY1IiBjaGFuZ2Vs
b2cuDQpJdCBpcyB0aGUgY29udGludWF0aW9uIG9mIHRoZSB2MS12NSBzZXJpZXMgcmF0aGVyIHRo
YW4gYSBuZXcNCnN1Ym1pc3Npb24sIHdoaWNoIHRoZSBjb3ZlcidzIGxpbmVhZ2UgbGlua3Mgd2ls
bCBtYWtlIGV4cGxpY2l0Lg0KDQpUaGFua3MsDQpBbGV4DQo=
