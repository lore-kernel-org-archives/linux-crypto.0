Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazolkn19013008.outbound.protection.outlook.com [52.103.33.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D27C253B79;
	Wed, 26 Mar 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743016325; cv=fail; b=ljNO8BYp+0+yuuhF6m5cJnbb+xX77lm8PEvEi5rGOj8ii2Vqu1q/7mHZw7lA+HdKBM5X+kcDy6LSg+Pv6/17bbwKL9KstJVhrF8mWlInwja9drEgSAwSMhEpZA8mGCk7NNXWFCh+0LxwCTHfkdHdLFkLQCYz7HA9Y2n/IbaULpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743016325; c=relaxed/simple;
	bh=oq0urUtY6Sh4BF2K3V/bHucIEeuhHJR848D7GnPekZI=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZmsYtsafCJItwsiTXf7r8nr7GQLT4vEaGhNQFhD9Xq9ukPNXN3//Z6JtPiTKOJK9MKIHMEgX5t/TryIEcwk+pxcNbkVMi2jj0u1jZpFW4MLl2dMMNMgpMzP1CGgNVReYCpP6a17jRLdIUkk3FWS8Oa36d05dSwxjzuzR0DWVqEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=NhdlLVHi; arc=fail smtp.client-ip=52.103.33.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="NhdlLVHi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxbmHdeWG+0KMYALKthRybQOvb1LxZ0p2wUw9NfSxe6+6q1CevlAf0CLuNoBjlyfAt+Cps2XIoQ74O0aOqLdefmx46mYSYAoR9bNDtYzG4tsRQx+pa19dwpwFsD7BhYJxd0jIEMvMTpsJwF+n/oUCDhpXwa+NbKiRGhRrkkXDoBXmTch3MqLjxTlrg+UGmKmET22JKDBF+/nE0lDJ4fSKBiWaQlUype6ogULV5OkQrdjfWVhtHUghBnpyWZm7ibVPMknXUgrQFD/2gtVVPn9xteJT/bZQkAzlklmB+XPVmC9byqSSJdJ2QSBkXHRxfPMAhUevcLmbGIbJhoZ+Q3t9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6cwj8vi254ntCiPYfe+wRpl3Blt4PmW73vWy1Z5CGg=;
 b=RiZXoHgQzeF0gG+GEfNhCFEiqpkrPeGQ7iynX8+vg65NyqeISfGhYT4OpP5FwYoFRkuId1Iqa56fa7mtuD/Fa7S5czRIVfBXGa137gMY7j1lzowD7JFtYuF0VQwCIShbr4XdREkhEzUJcOHbsHHyLZOdEcqOu/Lry4ULW0fINBTUlXFmCHRLtkdsqMWeDSXKQPobYhPH/OG72obsexfkwHd5w4bTJdZ2jqjFNpLXYPPCsr1S1w9Hp2TwwJHqy5oi0jca+p6CISm6U33Vn0PR8BcpUEjXOfYNj5QeJYKZtUr3bGux8vlmO1k9tvaQ03XpOkscfs5YjVmJ0cdSq7ch0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6cwj8vi254ntCiPYfe+wRpl3Blt4PmW73vWy1Z5CGg=;
 b=NhdlLVHiOYSb+CDiLUZhQKrrZ5PY0uCASIKA5FW+IgUmfBrGuWSHZBDrGxTomm+DwahMAAL0YepULAg85JPHPL9Lo8O7BYNQKsEl/h8SmxbXWlUa8XFkmtWBKB7ar3ySgtvABSK30DICZiyrCoSokycW1GEJ9z+mBHUO+xG56D0ljF4OOolMVsb5iShkLcZQUUwMNqRfp0iv7sKYI48hTa8bFGeCbMVNK/wFZD6jxdViPmFjBayAWlp4HJoxxL4Ps9kMCrJnHYL8yHNp5Z79abvPpT21utMZ2SF118YUJnl9aJvhdr5I0X/eQsPZnc3ZRlPbj3zDPxHXfh9iKzs+1Q==
Received: from AS8PR02MB10217.eurprd02.prod.outlook.com
 (2603:10a6:20b:63e::17) by DB4PR02MB9503.eurprd02.prod.outlook.com
 (2603:10a6:10:3f5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 19:12:00 +0000
Received: from AS8PR02MB10217.eurprd02.prod.outlook.com
 ([fe80::58c3:9b65:a6fb:b655]) by AS8PR02MB10217.eurprd02.prod.outlook.com
 ([fe80::58c3:9b65:a6fb:b655%6]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 19:12:00 +0000
From: David Binderman <dcb314@hotmail.com>
To: "ebiggers@kernel.org" <ebiggers@kernel.org>, "ardb@kernel.org"
	<ardb@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: linux-6.14/arch/arm64/lib/crc-t10dif-glue.c bug report
Thread-Topic: linux-6.14/arch/arm64/lib/crc-t10dif-glue.c bug report
Thread-Index: AQHbnoKHUZIM+amPQkGnKbTAjwDK/A==
Date: Wed, 26 Mar 2025 19:12:00 +0000
Message-ID:
 <AS8PR02MB102170568EAE7FFDF93C8D1ED9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR02MB10217:EE_|DB4PR02MB9503:EE_
x-ms-office365-filtering-correlation-id: d32e1200-f154-4437-50ae-08dd6c9a15ba
x-microsoft-antispam:
 BCL:0;ARA:14566002|7092599003|19110799003|8060799006|8062599003|15030799003|15080799006|461199028|3412199025|440099028|41001999003|102099032|21999032;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?NvJnWvN2Zpjq3tjQy7yMPE0chIzqEU0yCRxloPevh/oCbSw0tgQvQ5rfvx?=
 =?iso-8859-1?Q?u1glrVFxC/IRoFiqOQcxHD2Gqmd4XE08/n2+7EwPYAzzSzzXNnuXfrP8s0?=
 =?iso-8859-1?Q?sNnvt2upHxZ5BooizpJJsbeDMS90axkIfVhFQqb3XggaSNsnBNr99JNJYz?=
 =?iso-8859-1?Q?24/zunPoEoCvC/4nXi1b7MDFlOoga3R78daT7D8UZQuEFB4cGNuoBGKbBS?=
 =?iso-8859-1?Q?P5hRjmrsyx3SNNAsyF/AHEMqanFN8VFEl5mzJbt2Jn73Mjf99MkLHRuGKw?=
 =?iso-8859-1?Q?Yle5vX/+Hm2tfWntYg2HsKAyT/ICOMQk7K9yP6E3Ytv2t4KGg9iFmrFtoN?=
 =?iso-8859-1?Q?nosCBGJcNFbwPsbkWFKTVZeOBEyFJK17rm8KWHqy0mP5qiWfsdOmZ2fiKh?=
 =?iso-8859-1?Q?diFbpFw+nowsfV/YFstlu1uCcAVQYpVi+M1yeWBLpw17FAwOgyN7DABo2r?=
 =?iso-8859-1?Q?t72wwlUOoDb+WSvR7zD1u0nqPa1tSk+zHT84KdJUCZv15GrfRppYTS1s6d?=
 =?iso-8859-1?Q?6J02AuLrRd/yo1LC+O0Crii6H0NTfp1BXNo98czmLsKeNfTWCMJORkFhs6?=
 =?iso-8859-1?Q?rIVYumRhC9oygx/j/xbG81OGVREJ6QAUc+k/DqJ76fxEuf9EI5NMZ7N/eJ?=
 =?iso-8859-1?Q?mezJsV1Y5VxqvxvHZ9mDee8CGcDkMq9VmN8oAnGgPpqpAdwtR0Z40UOLU9?=
 =?iso-8859-1?Q?LDzyJCXSnKiur5wXHu5jEpfvj2GeD69I92UoUEyaG5oieRNMM8vR//6CGQ?=
 =?iso-8859-1?Q?i767k2Ob5HIt/vORMyr+TXYbdwy4J5Nxp5Jd2fDkdLqyYZLgA69L19vupu?=
 =?iso-8859-1?Q?eUkVpz08s8a2QGZ6M/+vtvUwkCk7SCp3kJ5vOhqdFtm5D68I8uE1j5Mi+4?=
 =?iso-8859-1?Q?lZ1Jl17L7fQcHYm+lhpU7rRQxW1vLT3CbLxIMyM8iMat+MFXyYm2cbWj48?=
 =?iso-8859-1?Q?29d/5WVzHL36oJUVh9xF0IGZUVJbUl0XyL5oSYdMT3y8BbktCsIsR5q3g7?=
 =?iso-8859-1?Q?5i8kfkAWM41Yjb6WMqzJRBQu0HHAUJXvJCCMJTx1lEOMeRQ/lmPkLaYHui?=
 =?iso-8859-1?Q?RcLOdEosB0n5zIsXeVVck+4EGdI1hwVdSTNktbsRA/2IwF5V5pr6xfsgRy?=
 =?iso-8859-1?Q?Gw88cf5jtQry+qG3GTM6sxhqCjB1tJVjyArMXvvyb7PqlBaNZ/DWoOdSee?=
 =?iso-8859-1?Q?qpgzusZbmeLhFsLXfw+Sjk7KfrSvV4IUqng=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?KtqqwM+J1tGs3tFBJEn9QgzUyAE7AeBX4GeGXdsx8Nsi/vnsn589KSVkF+?=
 =?iso-8859-1?Q?MST0aeVGzkIOS/tl2/ifm8f/W22T8vOO00pA5opijv+yXncdbhfcPJ6YJ2?=
 =?iso-8859-1?Q?NITIDD5Y5x/O+IODpEfIJx0vZO31Z+Uj/bhYZ1n9/tgMiVE5XYU1Gm/7EY?=
 =?iso-8859-1?Q?lyqczgHVL5EfZ2Kg19XfC2VS/IXpVzDf0iyiQPuE83X2zkJ43Q72PQfm1X?=
 =?iso-8859-1?Q?NyWYbYSCFfZvZw32mbfHMJPzmgF/LU/trtye0E3W0GkEf85EngilXqhOlO?=
 =?iso-8859-1?Q?oBWrfVAaDBwW8c8mf2c6sT61am9DrkOOhxB7x9HqVqXqT8h7JtzhoeXhg4?=
 =?iso-8859-1?Q?PS6jFeJQ8lydoVHqb8ICg/t8wcMdRyi8WLq1FGWwjymkh7uiBwBdaD0pqI?=
 =?iso-8859-1?Q?M8/sW0mrTLGP0YBdUhRzVXu8VsIsC9xUVMiajYNPMDm0eoGlZU4isLJEvM?=
 =?iso-8859-1?Q?4ZXcxHXXiUOWJdlIfOvWuIs9S7s9M5Vll2YRipaSjxA0dd8Yf5XwcczkCk?=
 =?iso-8859-1?Q?XaYcNYYCBGxtG9mtZqDeGWO91YPn425zPzlV9Tr3gM4il4WjKqfycQW51Z?=
 =?iso-8859-1?Q?9vko1rEJiJf0u27Lycjx0ZZJRAY5TgEaOqZP4KsHrnFeinN5qbJ1tU7h2z?=
 =?iso-8859-1?Q?D6mfS91s3Foj8tDAnvLVpGkZ2SrE30tySGGxtb/Is/vusVXdzPfKVXsKrj?=
 =?iso-8859-1?Q?Wq/loiZ85zDdB+37PldWdqy4sYLd9pPE80puCsiOzGWXfPkHwqe88UPGm8?=
 =?iso-8859-1?Q?RFgq6gty3IjRJgVfU41P3P3Cl1cwZhJzG2kr8M1QFoXNwcfftsr8uMC0IC?=
 =?iso-8859-1?Q?waHwiFNgdIhj0UUttdb/8JAJ+rgGKkinFl1+BQ2OUWiT8/KTZBS18/ePpu?=
 =?iso-8859-1?Q?KkGhO6rDEzQHEfm0jv9JdroDZRDv+i2j4/L/H8Aml2nns5x7YJkwZzi2ek?=
 =?iso-8859-1?Q?razLbD8mNKY9LsndaY256hBSPW0BYriO3uiUKpVokGCy5lkDyGZYpZvUEx?=
 =?iso-8859-1?Q?9ob/41dT1k9MUD5Z+GiTJ+9VB6OvVAxdSeQJOPdnJOs36C3eNIMxWlyKxN?=
 =?iso-8859-1?Q?QQwaJULq5f4fDWSJtnk4ACVgLPunCc+vD/bSGyT12grhX61whQezgNqEb1?=
 =?iso-8859-1?Q?ZgB7UggY6ezRdr92L3JLYafEXDcFC1ixSXgGFxO6YTYXSm5uE0xAQpcXA+?=
 =?iso-8859-1?Q?IK3pit78t8CqAJZ8fZIT3163QjBeEa6E3udNZ90JUp2lYqUMqhNeyNTc88?=
 =?iso-8859-1?Q?KuOMJenAFZPTM2YIGlWw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7828-19-msonline-outlook-12d23.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR02MB10217.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d32e1200-f154-4437-50ae-08dd6c9a15ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2025 19:12:00.1558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR02MB9503

Hello there,=0A=
=0A=
Static analyser cppcheck says:=0A=
=0A=
 linux-6.14/arch/arm64/lib/crc-t10dif-glue.c:53:33: error: Using pointer to=
 local variable 'buf' that is out of scope. [invalidLifetime]=0A=
=0A=
Source code is=0A=
=0A=
    return crc_t10dif_generic(crc, data, length);=0A=
=0A=
but this line=0A=
=0A=
            data =3D buf;=0A=
=0A=
looks very suspicious. Suggest move local variable buf out=0A=
to file scope.=0A=
=0A=
Regards=0A=
=0A=
David Binderman=0A=
