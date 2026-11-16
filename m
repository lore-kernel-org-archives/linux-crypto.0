Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.76
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794869360;
	b=sFx+6sEg0xNcPvjvjgfcLLeiS2nwh/JhDTJZHGVWmNLtt66JjLRCj7mVDGDIbMenwfxg
	 Nj4kGa/JXjeuL7ZKkKgVcSRMYnE+zXuRRq2Apl7QmqRO/K0FHE8cgyTaFBVjbv5+JtS4D
	 1UUZDC/VBkr85PVeC+EX3qYrLAmiJLBfcE0IiL1m/E7PFcqEPNWEkXffD3GAFq8UyBjzR
	 b9sW5hBq1jIc1tVxdIDWapqmwwnQZQijkEG72MkaGDrvX+8+P6VgRTPOEOUZxqH1/64no
	 1AXLQd103mTLu4TmQ5S3meFYPETbW6xVQhD7ThlTQYP3KOWMmKk3Q6lmKiXQ9qEfBrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869360;
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
	bh=vYo3nIcaGZhFCp0i5S6AFVRcgjtEPLPeJWhFKSkVk/M=;
	b=XAZEPlMIdc5Q7qgMXWA6HVZSfipp99shJadO/sV304CM4AUo4U+sbYwK0JCsQmIyIzU+
	 +dbmSDaY/IzFwRpFSfurvOP6p0bvexat8AefbaOpwBGeXyjTPNaGQq944wWWpljrO1+Rw
	 HQXJuaff9v8XqPdSj8nAEeKdlUO7bzmNU1gJltL9OkLY0bQjaz1tMttHfJDwe5f9THBIC
	 AT9Ra7NjbbqIcQhpkNnUX+maNNj0LOiplkoAS/bwYVFq4zR7DwlAwgVl3l7McbmYxLXuc
	 fQruo1cZELrPhtGE2XChE5lub8lb7BgWxbqPzqo8wK2kBiiN52SJ1yE3CCi1G/JoAQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=i16zDRG6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.76
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021076.outbound.protection.outlook.com [52.101.62.76])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A2606A31C;
	Mon, 16 Nov 2026 22:49:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1A2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=i16zDRG6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SK9dI0SfB3yGMiCbmBDatqq2E/81Kx7cjvLdN/ry3fgQoBwKLuz0Yg4nxwwL9rtC8+wStV5O2qyl2++aSIfQ677Q0sWbiWZZkGFg8JJcg7gSD2DIufoc/fgcMCqZ5afATKeN+dUORuWw435qugy71XzokPKlcevrm1lg/Bd8hmkd3FheF2p28gET02MGTJQiUjzzaH4x6cvZhGydczwVrVj+aiDuCtPXgw0nFHmM1LtbUX6TJ7mtkBjAHKnqiKefYUvqUEqizf/dDMbDxYX11OC+vxGGpUPHe+EmYBwesACMA683GNxE0dNoGZ3JF7IsCi/94K8J8p8S11e5Vj01AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYo3nIcaGZhFCp0i5S6AFVRcgjtEPLPeJWhFKSkVk/M=;
 b=dOC7pye9OMd2Ayyjm9/+RcY55weUVWgTZ0YdRVF2COURN0TbtdaCMMqAfP0Kxdq/5acm8Eil9EAct+pGTVzs1Rl8EgKMYl2Ea6gvQ6QW3Y8gjV5cx1pB7TFV/0/fqEsa5eepeoJY60HPNhJVWynDiYI1z5pdTolAWUyzT79lVMgL/EyU89NYc8uhH3HBulOCw8LKv5h2K+71Ruzotq9xpRNEPS1DTZKsmf/GggO74mu5CsBM3khzW9Hsq8qfTGRcz2FCKqUJe8Z9pBxBv3ga6sOgd/JczhrL5WBvkDeSWVxhet3sLEg51drFQleK3ydr/++WII7djRDaN+sB88D4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYo3nIcaGZhFCp0i5S6AFVRcgjtEPLPeJWhFKSkVk/M=;
 b=i16zDRG6HbhORYn7SPgy0CU/3hsOGKQH2Csv54vuJnFvecPnHY3820Ar+yRp/lkcDEOEESK+fXXVqsXHYDh7gloK5jFjt9P4H5tQzPMwIYXeqWMvkDWK5hHsOw10JO7iQL0mqAVjAQSuOTpLAhq7ZzH+11HJyYPYvEBFkc1/ljmA/fv/kNikwI6Q09dq3j1vLWcE23l9JxS3fPnnLLJOuMys0g9ij3ASdJxG/Gq06ZtfdMUZLbR7q8zYyj50V2GKQ0RYe0qJpp08um5gE1tjI8AyxOaOoVQ+6gq330F4WyeFgcoV+YwK3oDKu+ZrZay8twAGLeKf0WyTo4sA+l0Z0Q==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by PH0PR04MB7415.namprd04.prod.outlook.com (2603:10b6:510:18::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 22:48:58 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 22:48:57 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>, "Wittenauer,
 Joel" <Joel.Wittenauer@cryptography.com>, "Nguyen, Thi" <thin@rambus.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	<krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
	<rdunlap@infradead.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v8 4/5] crypto: cmh - add AES skcipher/aead/cmac
Thread-Topic: [PATCH v8 4/5] crypto: cmh - add AES skcipher/aead/cmac
Thread-Index: AQHdcTPqNFe/xeHG9k+5MlgfGFK287cnnXqAgAm5S2A=
Date: Mon, 16 Nov 2026 22:48:56 +0000
Message-ID:
 <SJ0PR04MB8406B9447401F28535E76C10D77C2@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-4-4cea8ebc1d40@rambus.com>
 <sashiko-outbox-207570@kernel.org>
In-Reply-To: <sashiko-outbox-207570@kernel.org>
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
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|PH0PR04MB7415:EE_
x-ms-office365-filtering-correlation-id: e9daf613-8b63-4a2c-45d0-08df4433cc3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|921020|11063799006|56012099006|10067099003|4143699003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|5023799004|38070700021;
x-microsoft-antispam-message-info:
 wjFe95P5YzoMq3TI0/Y1Ze2SYpQxjDivNBdp0XaXGQtQNex+hUiF0DQ6IHcAnyCsIJka5uCuUPzq+poAbqbPrxbP5RE6hLrbodKr4a0uZDcj0hZfwAiB1b8CFGt2LiW8fl0+o8oWOfKoglJ6DWR97FLrH0wbcsRs41bWhQXzkN3ZeOTFfHCHa9CjOapetMgh+9zbnBKg9DG0RCNmno04oEQBl2xfhlbebllasuiRleAbi3CIDDIPw+0FWwgphOE46Kd3BjC73divME5z/XnAU+fJlorCI7RpAQ13z5mPOJxnJQXV+Hi3wkXG9JejPDQ+Pgbm2y0rLaYGqSqR2p8MVJroMXezBpqCnWz0vRKhUp9NkNZe9DuGKkh9T7Bjulk8/ZU0XcQv0rsOHDy3DynhEQCu+sVjhirOEAKRFgRc2b47TaAmZrq6kfwmRBsoGFNTbF5ul3woPBNfKC/ihpJqNCXVJDX+aVvsGM/VU0XUHrGX2PxggVAdFR2D8MUilG5IPPiV0F1MYWk2poDe7KM0VQTbNQJOgSzBsb6CXED8vANnqzimi6kL83XLNyEou5UCXqfigmtGgQPd7RClXVQBS2J3xBUaxAWhUeWFEY/YRwS/uqjyRTaXpIxMKqoxeTfAkJT3JgcEQJxlrryL9D7vGPBTn1Wjx0pd/LPEwTtJCshbOGBNK4/ivxX88z+o3rq70vXMXkqSKHWJqWSdxRBaBOqJ+NfumzQ6iFknegGqxcN4iuah6USEeauh1t/PPpZs
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(921020)(11063799006)(56012099006)(10067099003)(4143699003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(5023799004)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UY4Gjkas0HpF5Mi9jkI71P5TfdzN6i4wudW2I7SXNXR5CDyzT4YtChtpyEMj?=
 =?us-ascii?Q?EzujPLokcxLnFdAY77JlsU5LG2eGkPSvKeDkZO5unq1dd1yBv4K+eIQMR1SG?=
 =?us-ascii?Q?l1HoE37KgJBomsCMg4J5/ASpBbl3An9TaWl9TsiNwKmrpo9+saEA36AMH4Dy?=
 =?us-ascii?Q?9G+Tk2XKc3Nr63zgHgpLWTWvvse6zYknLH8oGq5Yt1c37LsPLNu/aEHpRoBy?=
 =?us-ascii?Q?pGICbnfZqwG+NdySvahgnxFXpQMjj1ittZqRN17IhBL40LTE8hNotILaF/s5?=
 =?us-ascii?Q?OTnS6TO1VBU9kZSqWNaVX0w68oXiCMpCs/uDE6xqyc8BwS7OzNB1li2KHtIU?=
 =?us-ascii?Q?aC7GBTV/rZkvadXJTqKxFld9ILiO5dny28MIXBlHLk1ZbjJR+IEG2EVzPOBt?=
 =?us-ascii?Q?QrKK2fM5ealE7CjWCRKBfF1T3gGofUMU/Kn2AK4IzdJlx8l3HIaiBR3qUcRp?=
 =?us-ascii?Q?kqt59qGq3AYwrKoSHx72gZsdJ6FdpXerIBVCxLNDMw7+A4RosIQ9+dsclVZr?=
 =?us-ascii?Q?zJihcfOTYMFs8I/O1lirtTHf5mqWF0gF3TVgk3bCaZMc9b0Xuy4ZhEfoAeXI?=
 =?us-ascii?Q?R2fPlcdH8tD9s66pI76J+QH+iAxjwu+UeAJjugx/usl5pfUsIa90nZjj1MWz?=
 =?us-ascii?Q?ks8xc6gmthpYJ69AF8Ng/Du5Cuxqix+y6IWrK1chmFF32afHYWmpmT3q+V61?=
 =?us-ascii?Q?hDUdZeKqWNL1ZFvR4DL0agmUV9pdBswcr9NmzRRZ9kg1XrzZwlmOgnDP4shC?=
 =?us-ascii?Q?aq9f1HGts/e2TYIj983r1oW4iTO4C49OzZTQvA773i3WstyzmBZJX81UGhn5?=
 =?us-ascii?Q?VF9gzxW2qT83UYf4qE88UP4OBgVBnNxnDsa9FTb/PtAyfAR95F2Lhhq5bz+N?=
 =?us-ascii?Q?bAl/O/gKQw3J9ewi32/gb2wvR6xb2Bo26RLjrzjdmQ+OuJF/Lg9N22RU0WT+?=
 =?us-ascii?Q?9Dl0ScW4n0pSUaUjcNMijotVMORBbWaiiYHg/HfWA/oAGiVIM+0WvUOqYFNC?=
 =?us-ascii?Q?Jj/3BZCSzi/QKo4qKzTjxaGSnAzeZuRUamCDWVsPXVvoYyWLMdJ0yjaYWIZh?=
 =?us-ascii?Q?2S4z99wG8weqooxyrLi55/XeEN7zi7+5FodQ8cuBdS+WTIRNOg07lolqbyrV?=
 =?us-ascii?Q?cueBasQxBkLPL7FH/XzSziLw8IhmO6OuQnzHIzSzavegD5WN2PVGuos6yRqm?=
 =?us-ascii?Q?W8dul/o6cs/SEZchKuWE7xe/HZ7dSt8C876hQHfRHcNHuXyBbZcP7ghyppN7?=
 =?us-ascii?Q?7tLipC8sg8rWM3TWO9M7Qux2UxmmxHp4/M23qVUlSy1k7nZwZjnRvHHtxJ0K?=
 =?us-ascii?Q?c1NUbC1R3slMKBmYf1prg62t4dvC+uPuvOqbySaT77fBoBpbyr4Wryc9wc9g?=
 =?us-ascii?Q?1X0lkCkgmSm4zzenrSJ8fjiXCbIUz7HhDKYzvkLqTK9NH+6JyLF1408S0jgn?=
 =?us-ascii?Q?FlhdK4jnF5zIbZ2xhBQt2XRV7EGvYsQJeYC2k1rXsDk+lm27ktBZf+bb5j/y?=
 =?us-ascii?Q?yIvKT6+a2edtMiBTz9cn/gKD2x0uE+7Egl9i2pdqzJb83t2qDADWgC55AyJg?=
 =?us-ascii?Q?DoVINUXDM0n+iBcnXUvlROu3SejFg38HnyqIMLBNZXoTngW7eMzkNO6NP870?=
 =?us-ascii?Q?mCJm2NI6p75YQm/eJjKbNclvtOQIqNIqbPhRcrxiLSRUPL5W+P17TNSIC18h?=
 =?us-ascii?Q?zICKubQ2Bll+0NK4KM8XXCJP4b4ljFIII1Mud8f71Tn2YrxXba5Wc4PaJti1?=
 =?us-ascii?Q?DmPJb7FpIg=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9daf613-8b63-4a2c-45d0-08df4433cc3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 22:48:57.0414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0SCV4C9IYO0WPpFJy85oPW5pUO7OIeyY3358NnrxTa2BYFOO/SII6K6OfjyVFwnWhcwpYbPcf3c8QVI0l3MJtChORqFRHZdCt9G7BW1DYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7415

On 10/11/2026 18:18, sashiko-bot@kernel.org wrote:
> - [Critical] crypto: cmh: stack overflow in ahash_request_zero() via
>   missing tfm->fb
> - [Medium] crypto: cmh: missing CRYPTO_ALG_ASYNC mask in
>   cmh_aes_aead_init_tfm()

The ccm(aes) fallback mask is fixed for v9.

The overrun needs a caller to pass this cmac(aes) transform to
crypto_hash_digest() or put a request for it on the stack, and nothing
in-tree does: the only caller of crypto_hash_digest() is testmgr, on the
generic implementation it compares against; the HASH_FBREQ_ON_STACK()
users (aspeed, qce) use their own transforms; and the hmac template
rejects a keyed inner hash such as cmac.

Setting ->fb from the driver, as proposed, would have the driver manage
state the crypto core owns, so v9 keeps the driver-allocated fallback.

Alex
