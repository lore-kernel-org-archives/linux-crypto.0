Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.96
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792528047;
	b=g0S5qsbqwM0gUhaOzzeXkq2Ee8ocQ23Oylq57Fq4c9KGeY7YxdpV9zoV6tsoBSK8oHJa
	 ZX532EpGEMEPo1rsW+6G646lcy3xWb0FAyd2n3Vdze0jTvPX5hv4leXKkEAxc3/5FABia
	 7YugcSroVhz18fnQ3VMqFTHJVrXr8agjtDXRFBLku/sBRHsXsVe4qOBY/nWcT95ENhx0d
	 3f78EU2GEdHg6Ru4SfIWMbtG8+6rCiCs8Iq4NyLVK99jIYkjnFzu5Qz/6hZgxZl0a2szv
	 2+kAy9cGHUilC8vWNyobptueAITaddpd5qIWpK7+sTJFqjpLlMWHmjzwpHdgEYWxjEA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792528047;
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
	bh=GcgZkrCzO8aOuNoG2ozxhtitgrnuwOYXjWguKEOAvVw=;
	b=MU8i18wPlHcLRLvsZcnojz3GVW8jEhadXFs2WAM9zcnieL8sjiosSCVNoisSEOpkeGCp
	 78lEOuIfvEmhxp6a/QqdjXCwGKVvkTTUtTAOzzebLuCqLTin7bYfrU4+zlS9x3fK9mhrB
	 /w6xCPnGItMA3SinO9DA9cKGPspqqyMCdS1SDgac2Gi3hWzL7vlYdExJZd1Y7abilUt7p
	 skU6z2uC28YsODLnuDneoUEowGxSoXwqdYOIW9H5oHEVwWddGGjibzZlSYejOSCHw+7TD
	 ztQJIZ4GdCGq8OelU98KzC4mjGAnt0S5Ixin+rg2T/1FOnQUmO2wlp/toWgVkTAenhg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=igqHOTMP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.96
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023096.outbound.protection.outlook.com [40.93.201.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E279606A31E;
	Tue, 20 Oct 2026 20:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E279606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=igqHOTMP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qu/Swslte3VBMym9yfyGrFRG9PieabQ0ryCMrh9hKKXAzZX7BFJwEv6R8GG3asWIbzTP9uhgHb0ENPiE96HR0EdDSbi9jz0t0yG6O030xJPo/mtRS1DdbieL1d5fyc8O31CXKFcGJvRnNhwQ4j62Mg+jzLRDtTpHvYYALPLY+ojAvmjnvhGcqbDjYuCvEvsO3BIJGjH6p2z7YHdQA5A2/A0upv+l39dhAxOA9HwFOeqE/C738MuEOtedgl5ql4N5ally6HnaYE5p/mD38wO4DUkivaGwWlyEGdrBs8fIAt8zoQHZ2Y+l8/E12CKf/zTe6+sWHsfVIYV8D30W8NaZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcgZkrCzO8aOuNoG2ozxhtitgrnuwOYXjWguKEOAvVw=;
 b=aUBLkkBvG768T54WUCOzFYDLPT4k36p1OypDRGoMRJ9x3JzQib0mJrP51mwo3uSJveBCgw9IjAi0oDrFMHlV6CHu1cTV4WCU6RLsnctdwbYa/9o/nPbOoqhAXmytn820h8iC90tcfRhJsTBGLamElLvqb3u3HqRLUQYvXFENhm/fARI45Os8Ur+HK+2hVEimVJBYwP4ISSPYgB2ynwd7kzwxOFlNrpO4miQQaAIys8KvhC0DtB5PEa6xDKBNHIi2w4tWo3tePDRxcGvmIrsSi/wvOj/ibU/nSjRqxbXMN6Pqu7UqtjtG+jyYx31aqNb0BlP6MtVaLfboksjQk5eFNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcgZkrCzO8aOuNoG2ozxhtitgrnuwOYXjWguKEOAvVw=;
 b=igqHOTMP6kHpAGikngGeTzJWT7LNA86BL/v5ZXJoIeJIFXSO7uwo5fSDUMxTrZ6Ex2OZVermjHbVmuuGI8X1tYa228X5Q3CJiQ3e4DYS/207vqWR6tIkHng3ZBQAKk14XDj0gkzNnu2yAYk4ZI1aVTiBRLTvbhhXRndUNcGF7o8w2Cmb/UOCD/OdaFqDCzeX9vykLkRpLsCLVHUBUfHGIaaCDJmypxhCNPeK7TM9X+elbaOag3kUVAyEicGzsPMpYDC2rKp+h5q23y8qUBoyWtdGrk+0aZkjNuAHtZqzkZyqoWC8nyxROcQb3nH2DHHTb8LCtwSLIHHeKOdGxDijig==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by PH9PR04MB755183.namprd04.prod.outlook.com (2603:10b6:510:411::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 20:27:24 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 20:27:24 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Conor Dooley <conor@kernel.org>
CC: Conor Dooley <conor+dt@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan
 Corbet <corbet@lwn.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob
 Herring <robh@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH 0/5] crypto: cmh - add Rambus CryptoManager Hub core
 driver and AES
Thread-Topic: [PATCH 0/5] crypto: cmh - add Rambus CryptoManager Hub core
 driver and AES
Thread-Index: AQHdWzsf2ri+IRKaj0WI06DJnkhjM7b7wkiAgAAKTNCACx+ycA==
Date: Tue, 20 Oct 2026 20:27:24 +0000
Message-ID:
 <SJ0PR04MB8406EBDB5FAF852695400009D7672@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
 <20261013-evoke-coil-60a7037b7a0d@spud>
 <SJ0PR04MB84063ACE9EE09E2E52B24DA8D79E2@SJ0PR04MB8406.namprd04.prod.outlook.com>
In-Reply-To:
 <SJ0PR04MB84063ACE9EE09E2E52B24DA8D79E2@SJ0PR04MB8406.namprd04.prod.outlook.com>
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
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|PH9PR04MB755183:EE_
x-ms-office365-filtering-correlation-id: 7f0a68ed-23fe-4d8d-8d8b-08df2ee88cf6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|38070700021|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 Ih4l/4u4AYcMqlUAng5zD1QH4sKP9hiBB6xsiFFuTi8ay/Lm2FCoNain3kRiXG+dtBCrM43g2uJXMd2bgkpbZU9VMuvvb1x2PYSUSVYXKmJ4RoMmR2Ao4X4r4QJ5oekKFQKCvhMFBhFh2lgGyn6zZPXOfeLsmwKM5UlHxTU2kq+d7OwRvufe6bDaLAQ7Bw30QOx662lH7yKprLmjnSjKcgnmmygkXNEnkwAVoCZURFT3mavXmV1NePuBOFPHmxqC+IGY1eesO7Oxx5g/4LZxcTOuF4hksaBWjCJOmnUf52KRzdsOYItu7z4GDRIw++ojUBFpFM14UEnjV1iosAqBUg5IB4PlHUGmD98UDFtdS2TB9DXI6NM4hemNwL9sotJl53Tnj82ogpdNE6Reoo+mA+EQiuSACau8rH6IIqBrBSNrNS/r/gZIxRBlFZAxzdMBcaq7xRB6bhJBWSpw0tQ+8iFCeW1WMmnWZ/lCy9iqnfZiY6eO+/MpNr9Bt662IC1IetQUuMKNal6L24jqpV54Nu+D4IeQNSk5wVjxuUeiRFQT7BCHpwukHMv2dZlxYkHS31tMlvTBQxqtpF3o8oYl7vnOsD0eS5JzuY/DLr3igr9yZJbXxEptk5BJyNlx897Ppx4kt6XJdKwB9+26YZKPfilT1dzh3Ty0g2/g0/2Mu0A38gs1Q+U6IZtGErATJ08YQ2cLYLUnRd5Ic1NBQZcySF/+prjyweHEmzmKnevC628=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(38070700021)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9ASPCMliEvEuW58hER2zoZxg7XmP5OoeBerIbH5bVpT1MeiAnfo6i+yLfltU?=
 =?us-ascii?Q?j7xZ2CWeuxxV0pjSU4OXGRxnC0MLU6Oo/QQWiqNMlJJEZxbqJoc+YN8xPcEq?=
 =?us-ascii?Q?HWhgRetoS/raX5Mitb0pnYGc7LvN299hLO0oGWAsDWJ2r7cHj+rq5tJK1oNa?=
 =?us-ascii?Q?cOdiLiPlLOuaQwkZ/tI3EQDR/9K86107vuGibL9uUCtFyAYcdvDX0Ne05qFy?=
 =?us-ascii?Q?r1voBBicH61T+sCiF5L2ceHe7xJ2GXTww6cK4h7WX5X4hYn/Jx7YxudQd5K6?=
 =?us-ascii?Q?tt89RSRwdMo7/nyeX9Evh4lC9h4mDVC4rtgbQfin/io4fZHTphVOBJE6sZzr?=
 =?us-ascii?Q?wo6CnnBMPP/MyIW4mNwjMYF+JivAA54ceGM77d470KGsBCT1nAhx0AhhCGAr?=
 =?us-ascii?Q?lzF1pzmaHYrXYcDygtdDpSZWURZzBKRLGbalIYStlcABYR4bOgylC0Jv8jyi?=
 =?us-ascii?Q?eajQGnqpIugTnIwLsuSJ6aJoV4OJtqWY1LQeCP2tZjs0UNJGqpswz1vSHCAW?=
 =?us-ascii?Q?5lhcRQpno2lWjxEXa4GYpdzRgHVDq2XiNwL688SddioUgRWignRKGEHnMp8N?=
 =?us-ascii?Q?vN6pRumII50DJWsmL2eaI2XmcKp466ZNuqM7xlZpsno7maJzmHyVxtqnblvX?=
 =?us-ascii?Q?iHN2Bx46sH4pKlu7YrCa8UyQtsKPW2aN/R7vqaYpnyyj+K6E0VY5PyYqQNAG?=
 =?us-ascii?Q?rCaYV9CBPkYNxeP1mXlPfmfwEvEYClCjV5uXtRm8EDijocpngtKj2e3yzsXT?=
 =?us-ascii?Q?Csxp6lhNWVHz4VH8PgL7Vg9YM+8hYQFPwqBOaqsdHv8lJMNEXka2NmneQ9WY?=
 =?us-ascii?Q?c9gi5OWOAnP3bJBKGB9HKUiQuwiMYaG43PYCzFltiCp41uLinp2P/3dY5RYY?=
 =?us-ascii?Q?wa8u0tsYTPt78zPMUfdABa446UGhu2+XtTKyu3wRyEJ/pkmULXn476sCyFdS?=
 =?us-ascii?Q?xjrVkEtILVgTcxqRGuEeUnjw8N0NKG9rAd83pBDgjr4w5q0TjAg1Tpiebku0?=
 =?us-ascii?Q?84cgqSEz3RsPJfKyzcf+QUxPrPPeP/W4IgO7sYY7lpWeyzQsquljXj3khyRD?=
 =?us-ascii?Q?OC0C/0b16J44ffLd0T0XI3HF7uWv12L7WEX3ZcN26dgTT0eiyq6ekzWelsvr?=
 =?us-ascii?Q?oBphZ7f4Acst2qEr9hvwbTxaEHXDKw8JGHbcGgVDw1xeUEd49OgMq8PmbU+l?=
 =?us-ascii?Q?dd8QaQsWJ+/OtuvIsg0xjZtkqgv6OyiRIOWwJsMGoCcI4I8Ond6pkTw+LK3y?=
 =?us-ascii?Q?HVSpvDKdFbqXYhiHtsh+GBTVXcpOr1VrTop0Mnj3A0re6vIF8AcWP63DyXEF?=
 =?us-ascii?Q?ojcvW16InWlOqjF8aMIRGxwxiXe47SbdbXeRfxnmwcGVI354CZallur8J/l5?=
 =?us-ascii?Q?LVCxEMz73KT8n6/NvICY8z9fKu1Ix2vB0U/nKoTXPB49n9EtQBnFsMpGNwqG?=
 =?us-ascii?Q?saT1wGzMpThI/Bn8DaCQx0Z3vLGrw3nY8/FqFPYzvMPmc4frINjGb3tBw/4S?=
 =?us-ascii?Q?aJDZeTEzAGmcjCSq/5OEw30UDfe1+DiYET1pkQbfQmZqwkTqFw1OIHp9B/eh?=
 =?us-ascii?Q?twCmixS7VDDW1SJvXXIASwvAcOir1y+QtIxqkoGaiq+XkWaAR3GaYLFKGVRE?=
 =?us-ascii?Q?4o+J+tsJlxsYlhVvQMPebNgXEkq4j7OPJXQNOn8ecZXfR6mlyiBnXDVz3GS2?=
 =?us-ascii?Q?msKNv5Pf+8VSjYwxZNlw68s7XrZw1gSdT1o/sKiHVYK4WTsBrB1+TP515ZUa?=
 =?us-ascii?Q?JmL2n71RDw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0a68ed-23fe-4d8d-8d8b-08df2ee88cf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2026 20:27:24.1673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RT4V1oB+udlLqd/OG7RFQ1HYXnVkLLofFVIxvvozF8VbZfTK3F63P2XLifUCx+ewHB3+p3t9A84UZivDPI8OXaClJKV23+1aR69YLw8u5w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR04MB755183

On 13/10/2026 18:35, Alex Ousherovitch wrote:
> The next revision of this chunk will be v6 and carry a "since v5"
> changelog.

Correction: the untagged [PATCH 0/5] posting was itself the sixth
revision -- the v6 Conor and Krzysztof pointed to -- so the corrected
re-spin is v7, not v6.  It carries a per-revision changelog (v1..v7) and
the fixed Signed-off-by ordering.
