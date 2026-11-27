Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.110
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795815929;
	b=HmJ6MJwIoiwkyCJZPwdAxTQMMDKRLpwEm1RwByYvy5jodNz0alBQHoq6/8H1rOK1YLJU
	 +xsVPWepKg/+UeO0lNwWz6y+9hwywmxVjy2Uqz1B1TBQio+bWlwyNkXfgiHL2cmNJNSlk
	 4NLq30LvqnKGgGvdIortcV2v57NIvxEfeNxmyQm6ySy6VrabsM4UHjkDiAC6m4fOrpfKf
	 9a+/X/h938C0HE1wWV9V+Um41UmMfbMyRmXQrQZ0ZRdJdEfNgX3y17Z9UTFIGhdTa+Itr
	 ogq/0g8IGG1SPiR7iPKcWofh9RjkfQaGHbGgfgNyHb5sXc7oNzSvMdkU3bGJi+TwYUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795815929;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 dlp-product:dlp-version:dlp-reaction:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=SzeaLheTQi3E8HeznqEOl3qenX5Ejye0IztpI7ef7s8=;
	b=sZjpGjXatnYX9GJRaGH94zLxxlhy1pyKy02tWRRmlwjAoY9NxaD12riz7TiQ8Aj7CHYk
	 Amm7AsVYSQFSuIkmSaZKDQFOrXXeJuqzhCYMa6F0tw2t+1CV+E1KX6XiQUpUxyUpmjWIR
	 HMtueUUU0oPOj9k6g86oGKsTicqLG4bPZcI2V1IVeO/Vshiz4b2dJqXjyRyi83Hmf7OBn
	 AFXB4XFOF+JCErP01a5ZkhD9Xl7mMRXpP5bdeFiWM3ZIqiGwTZ9xstnjSPllTzIn6LBh7
	 kHbc2/CI5RqVvC2b1Gq0nVjQb1wB39ReAlvSXk8UQA1ffoQb0JJ3G2DK7abVyiP6FSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=2rLcXxMJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.110
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022110.outbound.protection.outlook.com [52.101.53.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A9606A32F;
	Fri, 27 Nov 2026 21:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B0A9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=2rLcXxMJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psug5ii55beSuR4706yBNuvwNF9cvgVCwe7zoHheMz8dAQ+1MBZ8tImCByhsAgEi7Jejh437ZS+cvCRWVyQceg/9n+LVcQBO/wwBeItKTjt82j1YEgfzo0iGctFK0SyFftjsXELB2ZJ2xkPwnka0oavF5dxM1/xXqglLXSfYcaBOwolLa5gSAxh+MhdVuce6T2oLROghAU4NmgNj1f6fIk11abRtZnX9DZzgMdbX+DeCj+nHhY2m7X4e9zU5SILM2HoGU0Hy2LYZA6eRgkE5x7efIu36DTXyIoYIzv7J2mV7SkwuteEoeolUhfcOdXvBViMaVMAWavHopOKJ9+8wMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzeaLheTQi3E8HeznqEOl3qenX5Ejye0IztpI7ef7s8=;
 b=imW6xCwG2LVqVKQ44VAA2l2Tch+H+HCYQnAXCV+fIeV0LAVZ9x+1y8tS4dMTMD5fKtWFfJdl1qxXgYpSYerhizwcyVxU/D6cr6dvaitXo0w+xf/0PVdSPaQncxaE2ckTdAhA0aA2r7FTFsJ9ueESdJdd2tCspWCwg0Xx3NJawUgxq61htpjCgyFE7T+W+cnyWpVcgMsca43TZ1eWwV755xhS/I3pLHw8JTjgbitHeF3utXuV7kDr2HAOTgNgZcq8gWh6rXwVPKQvQDgGIg3CWQ4pA/3C2aBx+b2uLxQl62/WE9Wpe3nFHjet47c/HxjtOVxyLhI1NiE4LQ3BMhILxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzeaLheTQi3E8HeznqEOl3qenX5Ejye0IztpI7ef7s8=;
 b=2rLcXxMJLoz0+rQsAVFWQZDClEjCAK7ghZp1Y+4nwHNJSHoiyvkb0LTT3h1bIwrnzXqh6KAFAmGvJF/1Z6NAra1BbQpGN9J4i6FR0n3C6OnYXb0uKh0YiUjXtnqhv49u4UrL4hvqBi7CQqWEuvOn7qgWxc+Z8i192ZuLpxAim0+QlK1uM15NXdMBrGz+YuXIIEzquFJriRhc1jo6hgXqp1tbOh40amJcbHikmYpz46iHJ3MWk3oI+WWfytB4Yk93h2lSOitLYIrYNPnkd0GGuyjfZhl5CeDk2Fl9C4AIBz4n8+i8ioVLwEmAJ7iPw2uOaW2KJx4zsXZT2DCcTGgFkQ==
Received: from CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22)
 by BY5PR04MB7025.namprd04.prod.outlook.com (2603:10b6:a03:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 21:45:23 +0000
Received: from CO6PR04MB8347.namprd04.prod.outlook.com
 ([fe80::b435:8025:e6cc:5233]) by CO6PR04MB8347.namprd04.prod.outlook.com
 ([fe80::b435:8025:e6cc:5233%5]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 21:45:22 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>, "Nguyen, Thi"
	<thin@rambus.com>, "David S. Miller" <davem@davemloft.net>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v9 4/5] crypto: cmh - add AES skcipher/aead/cmac
Thread-Topic: [PATCH v9 4/5] crypto: cmh - add AES skcipher/aead/cmac
Thread-Index: AQHdd4WKoO3M2PtYEkOUUVNuyGpd2rdBYNYAgAEhJjA=
Date: Fri, 27 Nov 2026 21:45:22 +0000
Message-ID:
 <CO6PR04MB8347789202CBBBA316F00661D7412@CO6PR04MB8347.namprd04.prod.outlook.com>
References: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
 <20261118-cmh-b4-a-v9-v9-4-70385613fd50@rambus.com>
 <awkHPjWDibjxrb7F@gondor.apana.org.au>
In-Reply-To: <awkHPjWDibjxrb7F@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.14.1.396
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR04MB8347:EE_|BY5PR04MB7025:EE_
x-ms-office365-filtering-correlation-id: 24c04fdb-4890-4ad7-a977-08df4ccfbd50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|38070700021|10067099003|56012099006|261026121527099003|18002099003|22082099003|11063799006|4143699003;
x-microsoft-antispam-message-info:
 iSsGFdLLDjnpKfeVCGAbkerZg/B5cNDGn5yED7tBh8vBVJQaFb7WRBIanlp2fkNNzGhz95Q36wFVfiNoY8qCOJbCSyD3+3gKaPD6AU0h2huZ7JrbAUtJtkHMvKGpXT1WLXHczmd1zVWwd97BNmoz4BxlSlBD658Xdsrgwvkw83OAwTt9c2FX3+bleSDCsnBdRlUGKM3rKLWeZQ236xnhxN3Bx1nxDTY+IUJkkpmxzVFn8oJHzZLDANP6f4XsH7B5gryYO8wK4OYtvHzQ7dhzIDTgeO/wHk7hz4kiI/iSEfJBMNKXQfNbxHCEbiyp4ri4xbVYmuSu/ilNQ8mEI4rBIvLB9wcejF6t/rjr+cL1/6WVBq5/YjgyilB+iKHq94UzKxlBafZCVF1nDbD7NDDgqNi4MsAMGH6yuwXybzXgbMRPwCl5EObWEsy7KrjAI8t0lUNgu640Uud/XcLfMJI8lsLCh145fyrU9tYfpl+Qk5e4sS3ptURrw/Kw49RCO9E83kdtxmMnfC96FvfEdcNAPAFB041wwq1AQYb+KQakxiOSTlJznvq2drEBBikpVxbR7vXq8wDoF2gfka/sPIVQqSzMzHk0Q8XeimiZ1jfuBjP9PdWpaMF5Gcep3TZncG7MJfe1AM1yY53Uv7Sz2OvS9qSTTk6xNsJTu4/wM1oUtEeWF2v2jjvJ/WuffP0oeWsm+tscVbois7JVAj2beeFypQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB8347.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(38070700021)(10067099003)(56012099006)(261026121527099003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/+DfCiVAGDOxyTpiBtNjqBJAbYLmZRO4pf3N0Va8PR1x/CX8FXabuMM6KX3X?=
 =?us-ascii?Q?4ByWJ0jkYwJMBvXTGvhzsdClw3HPfhEm1RC2Rsz7z49vmpLYADsNt/kGP7nt?=
 =?us-ascii?Q?Wmn8GCy4MapKzkbMwydc/Q0Gy5//Mzg8YMHQCtLwvTA8LsZgqM41rmkU+HHT?=
 =?us-ascii?Q?KEpTy2icsD8GQiJGeyYDX1kSPxPWDbbZ/Wsn2WlUz9FXep/quECBOnPZwu6x?=
 =?us-ascii?Q?D+pyOypSzVB2RkZEYFXt+0cWvJRo4/KmA7WG3WECCsyQJKu+je9RDveyOcFb?=
 =?us-ascii?Q?lghGoenA3YVPYaq7pFuLSu4ZIQQ1ltU9Mvoa+wH1k1E5LwvBwHVaBPC8z23/?=
 =?us-ascii?Q?W4Y8zra8U2IcLCZ2kAMvMUMtxsuirDEahqD7mJ+DxnjqFC+KG7jSk1HDGj+z?=
 =?us-ascii?Q?p6etYBuErIC/Ta5KvGBO7qmnLxuvyTcK1t4K4LK5vXVfHatB5cG/qNiD4YMu?=
 =?us-ascii?Q?5IjI+XAo74DOwWdWuKM4TfeUtcuyVPCokAoGkxLz6w8nEfNZdXffjasnxsyJ?=
 =?us-ascii?Q?VCeGPBBlxMBi8Fm0lw7j298neBri/jN15f9I+dS5SNW0r8DlLIlbbBOH6cO8?=
 =?us-ascii?Q?kuX9E396qIMgTK6X3tT0kQr3BRCsjLhEIHOxnhWjpvFG/78fRT0g0/8GEqv+?=
 =?us-ascii?Q?5+UClhCM/xotBzs8XGDw1hzsyAQaetu1mzQUL9FJJdLm0CAplFjS0deUD90n?=
 =?us-ascii?Q?c1F5KNNQ30OkbppZ9DhfVhVdPkhuoutmp5HwI9jqcogJtrBdcJ3gXVe81VZq?=
 =?us-ascii?Q?TrKSgb9eFMUFIZCIVwG8NCZkEzLMAgxyx1yW8ZEVpw8OCwMj6u59plBX30zB?=
 =?us-ascii?Q?l76OPCkvMNlv28PoM8AMgTvDYrZspZokMkVcCd4sc68gbDnVB0w619taJuns?=
 =?us-ascii?Q?QSgAZ5O8QHEMsXrisadyaJi2KQTWwtQgqP3X+EqHrBW5rOBfrlzhlR8dEQ+1?=
 =?us-ascii?Q?4kxnCcKhFV9BzeQsDEHQKDE6jV4anz/4Gjin42U/C9YFwEOx2zx7zwCsdbu2?=
 =?us-ascii?Q?qjnWuFNvn68v21Q7TMBJjVsp9V2UnP+Si4zUYoHW01CiElDOWLyA+Z9tqYnK?=
 =?us-ascii?Q?mAuemaP6SUt4Su4lO3r9qjC1Ofz5WC1ecANskgkohrO0Z7763vCoqiNIEsWQ?=
 =?us-ascii?Q?IDMDwGfoHnPm3awmc5Vt6WqFiu3gwhwPc6WuEnSYBd2DAM2LWrd3Bzbkzf2a?=
 =?us-ascii?Q?IEhPK15Qaqtuk/nGRykAOgtv2+RGj45ZmdBSKilERMeIPLat54U9SxRijqxC?=
 =?us-ascii?Q?8PTRwugZlwkUYneuPZhPlvSZ8MKku7Bu/hI4t8YJvAo9PhDucLHMihge+DDc?=
 =?us-ascii?Q?+RBGqACQvP22RMFzhEMS/l/90TgZDVFgeU0MrcCJ8yATtpqtMQSDHywh+5lp?=
 =?us-ascii?Q?S/LXLOceKwv2jQqg0cZxxTow0R3NAw1pmfVoqc7kcRl//veFZTGki6m8Vf4S?=
 =?us-ascii?Q?6iADVtX5p3+T6lEnHvSwbyinehaVraYEpwcxnhbTuzgzOrKN58oF9KDnPf+1?=
 =?us-ascii?Q?ejq2s/pYN75zVUUkW3XO8WJx4WnMRwSUmdN541CpFE71zdbsMLKzstKFGS93?=
 =?us-ascii?Q?xi5JhGCF+RuyvEBxaVGchTkggJlqakCN4aMGaRf8CvF1xfQ8nYkZeOCM4N6O?=
 =?us-ascii?Q?aZZODOSNYz0vVodomMlwcse24LZ474PgnPAYXW5SRj07X+vzFe5DyZNXxoSA?=
 =?us-ascii?Q?hFF8Jomo/6QFt7/8ib+EbidsLnjYPi7MAlrZ+JdEozjEoPJOHtWs0k6hrPA8?=
 =?us-ascii?Q?Wjt9zG+GNA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB8347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c04fdb-4890-4ad7-a977-08df4ccfbd50
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2026 21:45:22.7736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Oa2Ye5ETb5CLIjebRH0zNSit3RjG9MQlw610TcJ8iuDV9JK3DaIKLSQYVX6GackmhuW/J3EdVD8OfaBoFbQXc+2MSyXQrzNjOYRq9k8BLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7025

On Fri, Nov 27, 2026 at 12:29:50PM +0800, Herbert Xu wrote:
> Please don't use embedded fallback requests.  Put them on the stack
> instead with HASH_FBREQ_ON_STACK.

Will do in v10.  cmac(aes) is NO_FALLBACK and allocates its own
fallback, so it will use HASH_REQUEST_ON_STACK on that tfm, as will
cmac(sm4) and xcbc(sm4) in a later series; the hashes and HMAC there
will use HASH_FBREQ_ON_STACK.

The ccm(aes) fallback request will stay in the request context, as the
generic ccm template's reqsize can exceed MAX_SYNC_AEAD_REQSIZE.

Thanks,
Alex
