Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795480123;
	b=CxvmJ4w6qkfoEgqULeDXYH8hgkJ9rcPTiGrEmz7Sjja08w44C+vsz4Mfzhq/fw1nLBiU
	 a+J/mLGuf0h1P7U9dAjBx6+oVajJdjzSYFmaCdP+7AFn5wok9dlLpt+8FIFWqxBQocywy
	 EAWm73J55nHjbWasc9WUrnLLogQsUP1FGf+CeCeB/hynZ6Hn7ZOWaN8qIUTqqOIo4PmJW
	 4AjcxPWP8L4UTa5Ew3AdlEtAjqgPrxYakVv/CHS7nBQ+zReRTBFvASI4Hj5bLPtA4VBzH
	 mp2zASIOIy335I8mKUlgttdlW8H6ryobTBqJJc2aZX1fj8XBd7iY5X+9FgbzwKUjEVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795480123;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=HCFTqAnW320iFcR2SToBPxskrU6pK3PK7XCzjz17lmw=;
	b=k5PzK72HM4+exG322zcnJ1B/DyvejV/zmMWkqRj3CugrdiNpKaxC4UJwtPfg8DqyQNuM
	 YHWWk0TIZJyo3EnYVduyVVRIZmvg1X+JTtPNwpUVrywQlKPcIYblgJ33Ee2iUsm9vhV7p
	 x/2fmG59JfsiVWmCdpapHIwG4lby9hKXvTUexYp9KyHvQcOn1djzyf7O9G3520ESpcQPG
	 IPYRTnpVltcyQb6nP1lkqhqJX/3fiy5wArxiNZZJ5ams3NMMjMtHWGnYVe2Wa0fjQ5TZR
	 VNQ8YuPW+4Z+FNJiQU5nBCVBu68DC6cbd3iOn7q0jrLytZSN8+7qu9EiNkzx9N67gVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.jp;
	spf=pass smtp.mailfrom=outlook.jp;
	dkim=pass header.d=OUTLOOK.JP header.i=@OUTLOOK.JP header.a=rsa-sha256 header.s=selector1 header.b=TK529F5i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.7
Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazolkn19010007.outbound.protection.outlook.com [52.103.66.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE3606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 00:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51AE3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=OUTLOOK.JP header.i=@OUTLOOK.JP header.a=rsa-sha256 header.s=selector1 header.b=TK529F5i
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvkdidrjEsp/h0KKvQNygpTW8RrjwF2rVMrL6KjJyqAN5jdSZ68rt9VlZUHQQqsd3fWTm58Q4Hi3f4AaGLE/D34ts7wlIJYBFI/GL9BDJEngGu0YqwINhUeSaE7KqATFvNx1Pq3O5gCiVBC5edaEOpEea2a0cGGKK6bzilV39hFDSixvm0Dt5TbRt6HeOszqIe0C0I2Ca3QmIL72dWVtLCvE4fGVBzbts3zg2Rm9X1VjIyduSVTsPPpiVPPpQzfo92caOlaPZnKph82ULE9e6KJdBp4FO4wVU2cAFgvAjIKKXfcNYaW4bXQ8vsfJ1R7P8FJ+sZ0OWt9T3dRwxpJaVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCFTqAnW320iFcR2SToBPxskrU6pK3PK7XCzjz17lmw=;
 b=HxNJB+6KMY0vcycdlRwLyANy2evySRnu74t1eLNXdcxEbVkWKX17nmqh8phYlr/Kx/lTWpFwjIz6CIIhNhd8CWcSiiSYda6rTfhHiaioH2KcvM4V9rIvdY+Jd6TrjzZEKL+kV7mPpwTvKJBvEndJ9lOPo4oiO4rQsL3EP1FLltaTX688IS5ayLW7qsVAOjsHnl/v5K0OML/LXD4MEhTRQMQgtFhmSRTS32pU2sM1GWhu0r7IKhec612lg6+4k0JiX/TOumAYTMAOdZuFGbYt6AhFIMGK8+vv4LEMoDk/OZnRGzEYFKGmvVlRYbURaScFpy3upI+OqhmJwk1gqh1LZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.JP;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCFTqAnW320iFcR2SToBPxskrU6pK3PK7XCzjz17lmw=;
 b=TK529F5it46053pFNqjHJuRq1207wPpr6T1XOluZ2pJ9RvyaE/DPCVqZHV4MJfm9Xmiz7nNgClu4xBFVz+RWLkThBnUzF1A6Fp+Hdv37qZK8qtwCh3BuWBkbKaFzcGzCx3qUM1vyApGPImsjit/0gq32A3RXXlNDkSwL3ri1l9inSmtz6nxwokYkEhQQpe6XN+YXbbCrppFWUJf0MEUEwSXiItlfDLZoARh4rEumHvAHtg5u2kMK2nYZEhGGe+QEpVKZXM95FKPH1JD2QCmoyQZcLrIBLUO+P41oHfry4CLq7WULPWEnmdz6QwsmgaXGe2f9fohTcm/njtYnpoZjQg==
Received: from OS7PR01MB14363.jpnprd01.prod.outlook.com
 (2603:1096:604:388::11) by OS7PR01MB17900.jpnprd01.prod.outlook.com
 (2603:1096:604:441::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Tue, 24 Nov
 2026 00:28:39 +0000
Received: from OS7PR01MB14363.jpnprd01.prod.outlook.com
 ([fe80::eeff:dfdb:bd3b:591b]) by OS7PR01MB14363.jpnprd01.prod.outlook.com
 ([fe80::eeff:dfdb:bd3b:591b%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:28:39 +0000
From: Keisuke Tsukuda <tkdkei@outlook.jp>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC: "horia.geanta@nxp.com" <horia.geanta@nxp.com>, "pankaj.gupta@nxp.com"
	<pankaj.gupta@nxp.com>, "sahil.malhotra@nxp.com" <sahil.malhotra@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, Keisuke Tsukuda <tkdkei@outlook.jp>
Subject: [PATCH] crypto: caam - allocate enough space for blob descriptors
Thread-Topic: [PATCH] crypto: caam - allocate enough space for blob
 descriptors
Thread-Index: AQHde6rAcHhKBHOcrEG/IF8E3XhVqQ==
Date: Tue, 24 Nov 2026 00:28:38 +0000
Message-ID: <20261124002830.35444-1-tkdkei@outlook.jp>
Accept-Language: en-US, ja-JP
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS7PR01MB14363:EE_|OS7PR01MB17900:EE_
x-ms-office365-filtering-correlation-id: 1d600fc7-d90e-4638-53b9-08df49c1e29c
x-ms-exchange-slblob-mailprops:
 Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CINgpPGOsHyCWP8u8ebmX/iT3fAEzBAvpixpS3b7Kur0574r14HGu0XAxrERB121r5A4AjjLC/bZvGCxB9tPQui0sHW0eiZOk3PPkBYws+iJm7EaUCANeyGhhIEa6nO/3rgtp09xb2ooJalkCbxf4biCL9DedcqmL8JA95LY54driA4t4BpcWRGs6QCAPiVpZ4KiYb1OBpcm6+b3kxB6vSWw238MxwYPFjFL8FZ0c9aIz3oGXqnne4mKXB2lkCsk+jp7JQBQViGLDF3vsT3CQ4UNoc/K/EKCLjLsHvWqGLjXPq5jL6Wq37kIdNe683J1UCLH7td1rfVTkO46z6bEMU5MzockRtVBVYsfl0NsIsKxQDqqvnzMa1ohYP1wT/HhL+uAcGxPQowaNbDD6/N7q6QyD19tH5Eh+QpHx1385cDlfOP/UzJJ9uamm3NXw4DvDWnYn05prh+KpT1jqEGdrleAv5WCKMz27dIokjn7psi4kYGNpxzkIZUYv8T4cn5CpinuTsIpWC+PqY2Mi9INPRlH9Ab3mC5p/XxoTe2xpHKx/iv/tGLiZPfkKzkR+CMM/yy1sg4mO2sNypaOlHyPVDqI4UezTVKfkhbfUZIXUJkd9+V2T3FSqA+eeznmNW20JzUTRvwAYYPvWXq964uqScj0x54qgtp0dMwjLn0TBc923SAbGCoeCP6ikOP7bd/XtNJQL5aX4gYjW9T/7PFqyfO6g31hwELNh10R2CtBqcIDg=
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|8062599012|8060799015|19110799012|24021099003|4140399003|25010399006|38102599003|7072599006|39105399006|25031999004|15080799012|22141099003|41001999006|14041999003|40105399003|102099032|3412199025|440099028|26104999009|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/5NTS/YKgqjDgj9SBlk9ncoG9FGLYwm6r3KveSsAKegVJ0K8xnqhCMZcjK?=
 =?iso-8859-1?Q?G8BzLv2IDy6vgviXSKPDMJn2KHqb1F3XO6HyLiS4TQ2+T8mniyXPprA1p/?=
 =?iso-8859-1?Q?rG5O895YY5qjLolf60bV2PcdRIDUkRZMk7gFQNImDyiN7cc9lk71m4rvRl?=
 =?iso-8859-1?Q?bUxph0XvLABhUEScl/WLUH83FBt8Iu5kS8D0CI46a85lirD1TSvnthSTJ6?=
 =?iso-8859-1?Q?ziVCqrIFnT2E8BDZ9SC8qbfEToxP5401hx8oeXv+tAhvwBX6DW8rhOT82s?=
 =?iso-8859-1?Q?HxdVYNjaYZ28MYdZ8GTjRZA6JJ0fWII4P1ehGQMsrLqCDZggGkX4CPc/de?=
 =?iso-8859-1?Q?8ryVjKtgiL9UbHOL0EtiHkmWk/uzQ29++X69Q8dDxEFqs+c4Af/UxtoK44?=
 =?iso-8859-1?Q?jM6ozRI9o54i6s5AunAuAswRUbgMmFAlvM/jRqL9cO2HvYgiWK+f+x0grB?=
 =?iso-8859-1?Q?vkIJGK8rYJ7VXJ/Sey+FXUPEscr/XM8ppAHZZMxsyhZaZlK3KfYviDvvDr?=
 =?iso-8859-1?Q?+2lWgqOQSUcA3bKdvSw6N3/wNPxQaQJw7hFMBDKNVmkIWtnROM85QrfE5G?=
 =?iso-8859-1?Q?oet1SjUhT5Euqproc9T3xkE3mPd8s2j/dPL9OxAqox0VFE53hK786M4/72?=
 =?iso-8859-1?Q?hR4PrpFQksY6zSP6m9W2lW3E4uu+Q/ODKkCQNJ0aH+HJvAIQduxnATrMQE?=
 =?iso-8859-1?Q?Hea/Kt0dS/IGcArowFc3P0YyGw2BBgari83Tm26+bbWe/nzex2uSDehNOG?=
 =?iso-8859-1?Q?aDxvjDO25Jg+x3EczWzMfWxzWH4cWjgEJOxe/CHDue9PiN9l9c4W7kUaVc?=
 =?iso-8859-1?Q?3V1wXI3Kz1rxcjGjoglQUNgvC0AypgybnZt65IZ1Oy2nGMvzfJmNzfZKtL?=
 =?iso-8859-1?Q?KwknHVHIVqMiSeHndyL3PA6lxTqtGzhKKB3L2NaqrE9eC11ThxS/LGEhgZ?=
 =?iso-8859-1?Q?3brIAT2IIdI0rYYCU6t9KkUZGmj/vtvKxGrsGeFfbVsOCO1aAlB26eKZJs?=
 =?iso-8859-1?Q?540T4tBhpEvdEc0nVcClKXYvDvqXxCax9oInIBkKY4FV9L2eNqVVZkmXLv?=
 =?iso-8859-1?Q?JvnFrba2mhTg+M1D2Sf/Kia9vBUiJauCzitCm/LAjMVmymrbWFKoZ5ttlF?=
 =?iso-8859-1?Q?zS1IZmw5WKSFwqlsWN8DK072wr21twCpMgFwzAruccPY0jsPes3qRa2uGe?=
 =?iso-8859-1?Q?ImbQG7tKFAHAKw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CtZIopMaW3m6pcM4h82INiu4hbYp8SO9vpUzWpglyNIe7VC7taAEIBRFUi?=
 =?iso-8859-1?Q?hvLUyl0G/QiItncRHm9DXBZdRzjBtVqeGarIx6otfND99iUVDD7tUHKMja?=
 =?iso-8859-1?Q?+zPIbpyyPmfXRXaMA6YVMJyKVp7WAkwq/jhU8sEdkhVL1p0GINls2rz0sv?=
 =?iso-8859-1?Q?BIsDWC+bEF1h/PyZyG0Nb3l3HRLttiUk3rg/afGNlkKLWo7g+3qbCmZjUv?=
 =?iso-8859-1?Q?/s7mtGUjyx86ODxcf0QyUXrhZ/bDX4BlPHNw7OZ22PeV1N8k5QwhtHsitS?=
 =?iso-8859-1?Q?jFiSqLWPO/JsAh/Tq2g1Y8MmM5+N2TvxtaxiDBL4u/fP4+Hrk+DWsuXvhs?=
 =?iso-8859-1?Q?cT9YGFkz96kusxsTQUbQdqm2KpOmDzlR5uVZsfHo8GAB+t58i39Iixb7AN?=
 =?iso-8859-1?Q?5zR8a3s44Oht91q8HSZG5FrdNZKGJBusMdw8hiIMsXWRHro9kAe63i1mRJ?=
 =?iso-8859-1?Q?D2+UzrhYcmwMqKRfTx8A4nJ2r9SoHjF7a8pj6IwPNN0bRpmzgCS8sYZi1/?=
 =?iso-8859-1?Q?n1Ivn8KKrZXbA2tw323BAp9eU7kA6PO8S27WgBDdk8za/YbkmQTYl8zElw?=
 =?iso-8859-1?Q?UhCWCGI9BjYCeYTSONH3lhoSYkviV+W727kIgZRuWrf4j/Zv5nLBE6OWp7?=
 =?iso-8859-1?Q?7xYLEP4KAPtRPvOVM0IfehCEll4qBlDUam6i2Nw+dvVNkNOQJF+QmABMav?=
 =?iso-8859-1?Q?D9ZzorNCrL/bTYhXgqOMoeWu/N7oN6bRB30MwytQ1bKqg2BBVeHB8lNK9y?=
 =?iso-8859-1?Q?ygB25V8UXSbd4ajwr565pVCl4D5JtAfBVkE8NHRH7CFQDiT8XNs/gYFATB?=
 =?iso-8859-1?Q?IivwMopaX0pVM2dr0v2qm9GFtzB/osyvdWBIfjOPh9iVafjYT7v4vgj7pd?=
 =?iso-8859-1?Q?TR3DwGxZqj4SsTgLpo+lMTtWLluID7DTR5gsgoBqnbrYhxCA/Jc2eSzY/9?=
 =?iso-8859-1?Q?7mVrxDo04q2kFmo/7oD+iPto7RTxvFMXQ7VMN/bQDaKeEyulGq+MJwg2mO?=
 =?iso-8859-1?Q?pE8hDSDL2r+ffpAWqKwR6RHP68cOjPuDMF/fFRjfBrYOX4+ufnsysP3gyi?=
 =?iso-8859-1?Q?cL/Zr8bfiCr/bLAmmpPjdu2/QHXFg0LDyYkJFP50ySk/Elh3AW7Kn7Xj/9?=
 =?iso-8859-1?Q?hFcScWR9Z6BtOtXjk+z4G7ewu5nSHQX4Jz3dRtDYIwl6UgpwdDi5TBOBLr?=
 =?iso-8859-1?Q?GTO6sda3sYdCpwnOcsPeTxBQ/SaBmxoFKiACLcmbSL9IPiN5qjCD5SYjNN?=
 =?iso-8859-1?Q?8ylxFfhk40euDg0vEumwi6tcGg80FCSBYQbIoScUAi7dX7bw+6xhE7xscO?=
 =?iso-8859-1?Q?0BpgZ7b1VhC1lXOZDVZyqhZMOLp1Lam59r0LNirE6WaorMKpXkAR9cwKe/?=
 =?iso-8859-1?Q?1Tg6nO3OWviFbAfUabI8Afwsm/cNSn9mbvGOPNHNTUw0jyeWBUP6U=3D?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB14363.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d600fc7-d90e-4638-53b9-08df49c1e29c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 00:28:38.8694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB17900

From: Keisuke Tsukuda <tkdkei@outlook.jp>=0A=
=0A=
Commit a703a4c2a328 ("KEYS: trusted: caam based protected key")=0A=
replaced the _intlen sequence-pointer helpers in caam_process_blob()=0A=
with append_seq_in_ptr() and append_seq_out_ptr(). These helpers append=0A=
an external length word for each u32 length, but=0A=
CAAM_BLOB_DESC_BYTES_MAX accounts for neither word.=0A=
=0A=
The trusted-key caller uses the 10-byte "SECURE_KEY" modifier. Its=0A=
12-byte padded length leaves four bytes unused in the macro's 16-byte=0A=
modifier allowance. Thus, when the DMA and CAAM pointer widths match,=0A=
the allocation is four bytes short. On an i.MX6 Quad, "new 32" builds=0A=
a 48-byte descriptor in a 44-byte allocation. KASAN reports a four-byte=0A=
slab-out-of-bounds write at append_operation().=0A=
=0A=
On this 32-bit configuration, the protected-key path would build a=0A=
68-byte descriptor, beyond the observed kmalloc-64 slot. This path=0A=
was not tested.=0A=
=0A=
Allocate CAAM_DESC_BYTES_MAX, the existing 64-word descriptor limit,=0A=
instead of maintaining an incomplete blob-specific size calculation.=0A=
The same trusted-key operation completes without a KASAN report on the=0A=
patched kernel.=0A=
=0A=
Fixes: a703a4c2a328 ("KEYS: trusted: caam based protected key")=0A=
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>=0A=
---=0A=
 drivers/crypto/caam/blob_gen.c | 14 +-------------=0A=
 1 file changed, 1 insertion(+), 13 deletions(-)=0A=
=0A=
diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.=
c=0A=
index c18dbac56..0b19e5f7c 100644=0A=
--- a/drivers/crypto/caam/blob_gen.c=0A=
+++ b/drivers/crypto/caam/blob_gen.c=0A=
@@ -20,18 +20,6 @@=0A=
 #include "jr.h"=0A=
 #include "regs.h"=0A=
 =0A=
-#define CAAM_BLOB_DESC_BYTES_MAX					\=0A=
-	/* Command to initialize & stating length of descriptor */	\=0A=
-	(CAAM_CMD_SZ +							\=0A=
-	/* Command to append the key-modifier + key-modifier data */	\=0A=
-	 CAAM_CMD_SZ + CAAM_BLOB_KEYMOD_LENGTH +			\=0A=
-	/* Command to include input key + pointer to the input key */	\=0A=
-	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\=0A=
-	/* Command to include output key + pointer to the output key */	\=0A=
-	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\=0A=
-	/* Command describing the operation to perform */		\=0A=
-	 CAAM_CMD_SZ)=0A=
-=0A=
 struct caam_blob_priv {=0A=
 	struct device jrdev;=0A=
 };=0A=
@@ -109,7 +97,7 @@ int caam_process_blob(struct caam_blob_priv *priv,=0A=
 		len =3D info->input_len;=0A=
 	}=0A=
 =0A=
-	desc =3D kzalloc(CAAM_BLOB_DESC_BYTES_MAX, GFP_KERNEL);=0A=
+	desc =3D kzalloc(CAAM_DESC_BYTES_MAX, GFP_KERNEL);=0A=
 	if (!desc)=0A=
 		return -ENOMEM;=0A=
 =0A=
=0A=
base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d=0A=
-- =0A=
2.50.1 (Apple Git-155)=0A=
=0A=
