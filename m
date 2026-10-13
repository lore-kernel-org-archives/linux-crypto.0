Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021086.outbound.protection.outlook.com [52.101.62.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F174A0921;
	Tue, 13 Oct 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791916526; cv=fail; b=bpM8b/cE6EpmhDkOSZI5ytf9k/bruwBCnzBn6u0wKtM4/XkcMfZcSomW5owD2X41Jg7FGvKf5VLLC7YE/2XJ0rZwZFbDl75P5iiRcP/nGwWGRH4M49wNw9K1ekujRaKd/MOI9coYxM/QyrzlkvCQiFhJxwSSqheKPQ9tKUR5M+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791916526; c=relaxed/simple;
	bh=HJD46zJ9WVqKP7BpNa3crK5UQySF10gO4jd0Gtkgq0g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PDVDO0OM1dD0Gzy33xf1H8UYGA3vXLMKfJ+24Dnw/izhPOY51hon+3aWqiyOQhmM2AjmiuvyDuvdpvsL/STBU20RVs/lYzZMPelYotBOuQFD2y7BxZeRig7UMMhJnrhutvpVAOXnLNwJQDA5cWAFhGxJimSRkw1pjn3x054ZF28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=uZEAvw8G; arc=fail smtp.client-ip=52.101.62.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="uZEAvw8G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JDKT3WJHvVszzCF6NV7QP3W3spnBEAiltNSmdUuylHrzZ9nUBCTY3PTXMJ1CymmRKg+wcf2YlCJQQQvUHJAwwDiHraZT4OS521Pr1wFAuUUY77Prcx7om6pm3zdESvSROCGLFmzyY8B88N3+4D/fd8RVaOfHMsbvAh/3d77DmFn4bC6JXQIZc7dXXyR4S3PV9tfy1+V9fl38ao7HZUIDI627/COillA+DHhu3vgiNMHa46KWsNEwllR0OyS/YyHykpaFMj8EHFgOEXZE1u1Wm+yJPVIVkC0dTYMCGJ6sT3bwMil/ZZ3IYu+fTMyY3NgzTJrmZZ8uylMDn7/2XWhJnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PklP1Qo0ScXaf+dnwiogrYZQuZqN98TwgqNS+OLSGFE=;
 b=RAsiEwqE8lpi4dT1caxUrUUGwRMXKU2OdRyWU9FIyJ3gpCXeyde83lw9VRu9Wy+4s384BihlyKjg9uE321AUSNWzHzZbCh4iP0b2h7obT9Rp0t7KO1tdjQ+xKgDipYQ/hAPD2d/yrCvRNBCe+8FVaxfqH92UWX3ptVgOG0rlj9E7yrqAJk1NrOqE18+ODsa99u/IoMOlqsiGH89uxSmhzzFYlZZIiB7h8kJ8VWPUq/7wuBfUdDRPI1R1smFu3cJRdJSnbfHhu3RfpyHq6SVUoVavC9wAxqKl+NL3pPw2DQYQ4E6w4ixj2OsrbaZZpjTkjBlhBL8gFI670Sfh86jk/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PklP1Qo0ScXaf+dnwiogrYZQuZqN98TwgqNS+OLSGFE=;
 b=uZEAvw8Gpkm82Lqot2+vzjxXZI6swVfgqcrodC7pnuP91l6tlIu3r5HwKtmfwJc6JMMC2d69GgbECCZE+j96fBg6KR+gY3RwiNsL3tc3hK/l4PBnjJAoeTmEwJYVNIwc+bEw5ftO7/T5/63e/T3bqGSCD/paU3y73QF/t5yVvikZzxiua+GcrwJweb2tXm/y4lSnWeUzTLkFBeuksyooyI7u2u2W9E5TYAemP91bYJg8UimRVwaWu4NhBC6kD4DHPcJaEuvUXJLVXykQqITJoPIDHnvLzapq2KXmAdJiZTieKQIm5uafzrlt6Xs2VDw/zbx0j2z3Pm3NGaxtayFLeg==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by BL4PR04MB993787.namprd04.prod.outlook.com (2603:10b6:207:301::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 18:35:10 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 18:35:10 +0000
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
Thread-Index: AQHdWzsf2ri+IRKaj0WI06DJnkhjM7b7wkiAgAAKTNA=
Date: Tue, 13 Oct 2026 18:35:10 +0000
Message-ID:
 <SJ0PR04MB84063ACE9EE09E2E52B24DA8D79E2@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
 <20261013-evoke-coil-60a7037b7a0d@spud>
In-Reply-To: <20261013-evoke-coil-60a7037b7a0d@spud>
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
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|BL4PR04MB993787:EE_
x-ms-office365-filtering-correlation-id: e0c94f84-ebd2-4c9d-0748-08df2958b64c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|10067099003|4143699003|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info:
 b6sPcZjszAjmfl5HyWgqGn/hGck9yyLWrP02n6OUV7QW2iLJC4oDvSsVOB+uORvpM69LEmTPG2SC80HoVxP2sN0sm+KumPZona+BMYLKpVDPvfvOkXDxsrjBkejyaDucsjHAzCz/bMdpIiBFydM1XMnC7EzyxNUVXn9A0/c+puW479c/dGFi+znwVb6t/qKPURydQGYitx0JeshJfuQ1gmpvujZ1QErxQO4Y8cs2W89J8g8MdoYnUWMFBE3KLo72mIFM775jCspctWZAXd0zPniq/e/PRz6uImApOsCKnj5loccxGwJhzpa9zM4oldURN7hLdGZyDlIMiLfFNESKVbPSTas2ct1THwcvZKwY+rvYJ2W2m2GgRz4RLWLJvpl3+hv2ffJyret4rEN54X92dmhhFv2C/MdmqWBLLCSmudeaVRhU3wdDKjpOfH0DEk6C2o3mjGeJqkoJhZ36uLiLSZ1kIweeRrZ3nLGn8r08B7+o6aIvjv8L6AeM+PmhpPxF5LbcrmDrnyauqHY1xFfpbqPwVZmGw2jvu9S0FGcXyOyu11qIEqRUTjAOiEO0sAh9NobPqiD20lmW76uepXDukqxsvf7ZFbDbfYv28fgqWkKfKMfwgV4ffN2UacyBvVjdqmHIZb6O8kZYLzpcD9X6KQVTF1ZhhunU/Cw7TZeN0BzRzHw1j7ERbpmw4d2s3gOrioRyfjvjQoCzeW3dQrQ1oHpBEPGfsaf0elrd+6JfTO4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cGTs7rPG9m4TFTWX7Iqjn2kvsHNj25H1njim6sZMlvC9Nxtcfm09jWwnsi2E?=
 =?us-ascii?Q?9fFEPFovrDCW8fCaV1xGv6F2ZOJIJ3nD/e58Ww055cpjgOCzBNCjmpwJ0QHE?=
 =?us-ascii?Q?D2q9eZDyYd7mtTv5g0Z1/rODKHynjlouDazX3f48B2mEyESIftNiKpmjcm2n?=
 =?us-ascii?Q?2aJQa6lxhbbF1D2pIjYtHwuXlcs+Ess+MJLEFX8eHdqE3eEJzCMLgTc65TF/?=
 =?us-ascii?Q?bnGQFnjY3nQrCsrzsh5iZQI1W0zq3z/qOCdm5/iCKyZPo2zISmQm1CIb/XuQ?=
 =?us-ascii?Q?RGus+MqevuqXrDl6FgEgTlhmwKD1/JTlIV/BE/1khlkLIG6DBhhequ8VSmem?=
 =?us-ascii?Q?um5YYDDtn0l/JOwq0zRzi67BPbyzlzxN9TT7mLZTSeTjkdTbbjm1rIRCHqj3?=
 =?us-ascii?Q?lgf0wSo9OpzgoHkjTLq61m7C9x9dwmkkDkNqMmVJA4vkenKcNJT3F9uNa1H4?=
 =?us-ascii?Q?rtsKdsHnGEryrelQ4nEAnm8YljDb+OUWDNSqtKsQ4b89G4rYgftE0fAwjbJV?=
 =?us-ascii?Q?5Z6krLwyslf1VrWZpMej2xHgjSqHZ3iacNwlnu1ID4dV7h1JcUw3uzCtB/pU?=
 =?us-ascii?Q?ayn2jxqAeutNNIILOQcEfRRoAQLTp3yODalcteOrVIDpnbtvq+C5ABjQPCVy?=
 =?us-ascii?Q?kYKCPz+woZbjuubiZhRsz7EkAxnqFIhzwy3CfG/MOuPdQ4CSPGM4f57JS9wS?=
 =?us-ascii?Q?UhBcAPkAI0oXH3oLxLPtGM81/1smsbA785taymYhbvLT21TIoFzrV87rHkar?=
 =?us-ascii?Q?O2ZYNiY4EDSLZw8iOi8A25MpllUUutcpdkUJ1oECEikPsLqfAdfmrvqLK/ci?=
 =?us-ascii?Q?0q06HTR1DcwAsEvrPu6pz3x9M0dmPpcUgf4mQGma7EuOcYNVltQirwd6doM6?=
 =?us-ascii?Q?kF4dLyxT0oO40g8GsmIMX5xB2wEe6mSG0bIsmkA0e3HEt6E0xv+d3wP3JjCL?=
 =?us-ascii?Q?sGJz4769xmo9i5XbZqxBeMoBX9t4UU0oHx35M8S30dp6q0YhrMhD9odKbso5?=
 =?us-ascii?Q?0vo8flTlxllxdIVsfSm1OLGjEj4rKPYfKs6YDchBmlHBPnhijvBAFdHXV5B7?=
 =?us-ascii?Q?8w7PN5bmQXEg5ZThLNIDK2KBbUkqqQqrPTGF0x0r042QOA7ZIR5xs03BgefE?=
 =?us-ascii?Q?Agm47aSL02OzYsu6ayoCDsU+adjqVZWuhbVpxOXf5Y9ljlh5zbYxhSbcK+wI?=
 =?us-ascii?Q?Beo80xBoC2YcYtPlvKNpOXttk3IGZYTzkSSl5l9lwQqKBgVWWVIK7nEAJXhv?=
 =?us-ascii?Q?ISXOD/nq0RIizZX8meBy0GoNF9trIq4co1IJTKuSKFg6BIrpW+zZRVsVb5ly?=
 =?us-ascii?Q?yaBbGphcmEccMYCUCti/hqITGyUmS63Mg6t8iF1JMZnVYQ3fbt9tDLCR4q53?=
 =?us-ascii?Q?4RqnynVs1IEt18uZEn8D118YcGTTLjjlnP2U+bAM+r4Wf6Crg8HTs0s7oHmf?=
 =?us-ascii?Q?8UvUxJ8QAWW30QkWL+q+fsqgFcYzd/y5w9gRE28QsB1DAQXWQQ75ly7uUiSS?=
 =?us-ascii?Q?7AmxaXOcUnxmztC2Z5iXXxHkWiKjANP0oYrfiPHgoPkD7SUVnMYiP2qGXG0R?=
 =?us-ascii?Q?htwt8166dqXS8kLMLXVMjNAssoWrdto2YIlOumqKfF5ODvLsQ0wS7auOL5w3?=
 =?us-ascii?Q?d8EHwxwcun5fWgLt9Gevsy1YPiHAVQgBeGZJKx00cZYm2HAEGNKh3f661T1L?=
 =?us-ascii?Q?ARhQ94pBCIL7ccGtsaHt/M8xCFzfifzNqWLYp9QjWyPOMD3r8dhOSSTyHLig?=
 =?us-ascii?Q?NrVkaTmVZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c94f84-ebd2-4c9d-0748-08df2958b64c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 18:35:10.1695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZwdvWLr8os/HYAOir3jUbXuH/Az6yE+n0EvsBnanvCX6UL51Xq0mqVMTQvgj1ZusVzY+JztVLgCwHXanPvINAy1TPp91WbJfrPjlVa6Aos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR04MB993787

On Tue, Oct 13, 2026 at 06:57:55PM +0100, Conor Dooley wrote:
> Maybe you're breaking stuff down, but this is v6, not v1, and should
> contain a changelog.

You're right, apologies -- I restarted the numbering when splitting the
series into smaller chunks, which I shouldn't have.  The next revision
of this chunk will be v6 and carry a "since v5" changelog.

Thanks,
Alex
