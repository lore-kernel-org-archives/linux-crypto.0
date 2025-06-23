Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4031DB124;
	Mon, 23 Jun 2025 06:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750661338; cv=fail; b=qNIBH0DKmkbR453BIe6E6OZejf1Eus2+HFwckvkjnGpW/2tpOYM6jjwFhn/2FXWxaWMpD8mIOySZxcozLNrP+H3kMAYRKl7nvYyS1zkIf/0Jz6E0bNz1ohS7lFWzOtYDgP/k9lJN1GM6pSleqJ2iLK3lzg4fhchS/yAxyTmVU9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750661338; c=relaxed/simple;
	bh=678jnESUd5ExWc2IswDyH+u9/TMw/BiZ7JRMYnf7XtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cgfpVAk7H391Yj4rVHm0FCtitgTFrjT4Gq5q92eIaoDH7uxExtTFiEzna5PEawVN/t2JU5pWHOh0PUvFpLD4QbYMkZw3jYmCDDL9+jJSMPX5DfZGX9GX+lJ51mbVilsaHxMn+2P/xN6VpKvqrpFPWZwzHiW7nk4mMxyakgbBP4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=pe1hhrYh; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="pe1hhrYh"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55N2t98Y013674;
	Sun, 22 Jun 2025 23:48:36 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2125.outbound.protection.outlook.com [40.107.94.125])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47exhg8b1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Jun 2025 23:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rp0E6Dkur1mJKCHlw2mFdrtw1JaztzHxGhfie/o/yxhXnm8xwxAiczit4gM0Uhnt34jbAd3iI0FOYBRUcZmv0mqayyEOXDJmUtJHrqbF4x+TuvucqcwHwPwC3+fmQVmKvpOur0E/etH6uK1BqI5SHKin7R85eUgI9mNZQKkeUTmtaHe/qTYsN7jjpRkDCmt2Cc3NH9fI78cHPdRYyvdQPf+++F3HhziHzWu6myyeHBcV7vY3V61Nob14Zgke8L8cVDS5x06P0mgXD/By9fDGqgSI0WT+GcfdFVQVvnRrmIOaODANCQV7R7AJXjrePLezMwE6dnpka2vPFqfK02VigA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frzFPy+ZeOW6WvOIZFQ26QCL2gIBIG8PN0dQfdp8WDk=;
 b=N4TKuVvfyQxFA+jOL0PyLAC12ZYO0BDx386w+wEVGEozpuoXu8bdqWuR69ituZyL3I1cdbFUIlC4NzbKdAEi97YTe41gSl2lSqEdYeJB3topopiU4j92AiwbrqSDE5r49kAkHXNk2t/Kwa/OEuIMpilaFfA00mMLP+ISiAiJt4A10BrrlyEiBioxzTfq2Yvg4PjFDSTHj0eEWBTjcSP2q2u+bJNFR3ZhnzjPDHUszMSgpBm1vdjEY6vg8S7M98IbuINHZjQN6Wx90BfSoT0PbLSeXc18floBgEoNd4cHxiFXjHKw3KHsHlXJv6gaOD5i0zr7gPqJ1coqpwI5XnDUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frzFPy+ZeOW6WvOIZFQ26QCL2gIBIG8PN0dQfdp8WDk=;
 b=pe1hhrYh1huwoIbbaxvzyPjB5no+92Hshjn0BMOsDKC3WTTkypu/RKCcBSwi6FVbedODikicpX9klOEBp5nCy7vQc9p7erj7VqZP6/xisNWCMIRk8SDNZ5bjYE5F+6HaOCX1gTlXOl+kaZOd3nhVa8d9g8at4z0v7S3oDsKkop8=
Received: from IA2PR18MB5885.namprd18.prod.outlook.com (2603:10b6:208:4af::11)
 by BY3PR18MB4595.namprd18.prod.outlook.com (2603:10b6:a03:3c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Mon, 23 Jun
 2025 06:48:31 +0000
Received: from IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231]) by IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231%6]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 06:48:31 +0000
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org"
	<leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Bharat
 Bhushan <bbhushan2@marvell.com>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [PATCH net-next v2 05/14] octeontx2-af: Add support for CPT
 second pass
Thread-Topic: [PATCH net-next v2 05/14] octeontx2-af: Add support for CPT
 second pass
Thread-Index: AQHb5ArVWD2cpOm7zUS12r6qHayWKg==
Date: Mon, 23 Jun 2025 06:48:31 +0000
Message-ID:
 <IA2PR18MB58852DD00543026135C7BBF0D679A@IA2PR18MB5885.namprd18.prod.outlook.com>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-6-tanmay@marvell.com>
 <20250620105544.GI194429@horms.kernel.org>
In-Reply-To: <20250620105544.GI194429@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA2PR18MB5885:EE_|BY3PR18MB4595:EE_
x-ms-office365-filtering-correlation-id: a2e6eb2e-30bc-47b8-70a7-08ddb221f7a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Sa/BidUmHVkFtsgy9QEluf54QQoiyLiBPXWor3p4qhTcCFNLRA76NEXgK3?=
 =?iso-8859-1?Q?nQP8K76V0KHrioW6KRfgqMH862xlyFeNe2XuenZTGwn+0604PzOncKQjcG?=
 =?iso-8859-1?Q?yIv8m2Axkdt+0kMNqQBMEOf9HkiXtCdYoQYYPFEKS7Lt9yOgAxQI4mvrTG?=
 =?iso-8859-1?Q?iZoUkoTrhgX76BXAdVxAvK/l20ETg4oIcxCD4N92VPUpSPYbyOv0OKzOx3?=
 =?iso-8859-1?Q?FonWcVa59BL0PTFF1bk5v7tH61iMtSiG8/I5IIkLy3gPE81PR/sTPFMzQw?=
 =?iso-8859-1?Q?LlBRBiylcL+sLA3B33oIJNjpNWMopRLdkX+oGqpq8Do55VG5epetySV5MT?=
 =?iso-8859-1?Q?TOOfMvLlO2bfpIeKiryr21i8APe2YDK2kkWJ9VejZL3H76m14gv+oLoxpv?=
 =?iso-8859-1?Q?3IETEmGCzM5+uj333YSUZaKwS4jFCKEwib2Bj15iWXMYqjlZbcE5bk3508?=
 =?iso-8859-1?Q?8rQr7C/i1LmlplKbApj6iQ9bLXyu8C54dmnWYJgQ0y8v+B0QgZGtHIQfVO?=
 =?iso-8859-1?Q?bFPqomvUo7Uccl9+XQ2TOohzn3WFGwEXOR5x++rcjbst9Omz1Ywr/Yiw88?=
 =?iso-8859-1?Q?W99WrqLJTwiodTOKZrdcwSofzu3A+qUzyM4uoyDhRqy8jRUs5Iv6LiuQOo?=
 =?iso-8859-1?Q?OWLsv5gaBTV8wZ3Mc7sCJnU80SwvHzGlr3ehfxHeD8M7f3oStxW2tfn4fd?=
 =?iso-8859-1?Q?7PrXHCc44SshNfQkD6XHc0YOgqueWm0e6iK8Va2LKZCBQxI6s16YoWXTnp?=
 =?iso-8859-1?Q?DU6HK5M3hU01ZVJYfBw2skWKBnR1hwq/aKI6offVJbgP3HuRNDgPBY+fp5?=
 =?iso-8859-1?Q?5f9UjhUB3J6NtHamq8dQf11agbGihRQsVB+Jk5DgMnTYj98Hj+p5YD55fJ?=
 =?iso-8859-1?Q?Dm+GFmFk6HsoF4CXETiNtjhcgr+Uc3gD86uV77x98wXSFMHHYfJHkqVx3g?=
 =?iso-8859-1?Q?I4sPjtZspOr4STrwYI4oy3d25ysHoIxucwK0p8oHYhRCl9BsCOl53c/z9k?=
 =?iso-8859-1?Q?qmjMaoqdLe9hCAyVw5lrTKunx3fAWxpwA5zoobqwREqkDJZXhWiHrN+PUc?=
 =?iso-8859-1?Q?GZ4MAr8U4YBq38eig/kQiKQNHqnSaaLJomSMSg5O6xnm4V4ZDQOp7+YmB7?=
 =?iso-8859-1?Q?mORC8K0h4NzNoCy3jB56eptNOcr4eaH0WT9qjxkZ4uSVpEHnRQCDBcgsQB?=
 =?iso-8859-1?Q?CWJWPfKaJ8RTJYzxd9OYyMsb8MJfLSQod7/D1IKU6lvywxKCyTU2BlA92X?=
 =?iso-8859-1?Q?w+sdqxu0ORukI2AErcpyXVcHiZDA5B57BaUCtorPx7Wy8rd0v3BEXaL7Dr?=
 =?iso-8859-1?Q?3W6D5e5+aYfdG1xuHyTAM5kYImbxD77WmUjJ9MYt90lzpUMPzA/OyFd5dd?=
 =?iso-8859-1?Q?/LzJOnp73iATYHNZO/JH07TfVoYye3asMLBYVGrt7EupJJgTOQpA65blHG?=
 =?iso-8859-1?Q?3BrfGcfrUbFLy8bjbgbhND0vj5CkT/u0JA3/CfSjjWXsT9X3P5kfXjtzth?=
 =?iso-8859-1?Q?k6d/I16j1iBlZX3Se77jyZiKQm5+AD1tYmVcgmULy3RkWzS/ktE+SyAE/T?=
 =?iso-8859-1?Q?gVKt1Ic=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA2PR18MB5885.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?85ewMohFS/N6hwSE6WPV+vQpKSwQfbzoZZZQdR7dN5qIieiHygKfR4K4FF?=
 =?iso-8859-1?Q?HVXWMEHlN1eY1clmdra0Vf48ivhdO1sSHcLhl+OznC17bFrn9l590Xj2Oo?=
 =?iso-8859-1?Q?y4CjWMgI+UWi8H3avGhjayuOczE9MkQd2bezdVnHDYREOECKZmzFsnx/aQ?=
 =?iso-8859-1?Q?7wE8k/I/XQVO99nzsba6XZ4EsoBYsUMeE0pvdcMXxokbclbJAXS0cPx1uz?=
 =?iso-8859-1?Q?OupYZEXlK/j5gJVfnjau1QdT/pe0Bgr1cj2D6phY1JLzLIk0WQtah7PZsu?=
 =?iso-8859-1?Q?5NH5zGlvwYxjSvC5gmb6OUH/0DdUYh+BcO7kK9+UKuDKUS4tGStSd+M9Xo?=
 =?iso-8859-1?Q?yiU3A4ivsQUXoWM6D2WU9+5eYdOsvVtgDaFEwr4oc1mq4vWYUIhtSmCX//?=
 =?iso-8859-1?Q?bMrwdB7eqmEinq0aOXvvXba4EYB3k0buudg4DWwOE1pt66tCk16KXT3Xqe?=
 =?iso-8859-1?Q?w8/m4JsaQksFQ49XdYgUJU9ctwLcbqIChy5bBaMOBFhKubA8D1LREG9Eq4?=
 =?iso-8859-1?Q?HHEShqN5Mk+bY7eY8gC6PXU5jaMBarhdSR1jgCFFXB6phlLwr/EfJg1cR/?=
 =?iso-8859-1?Q?5GX2zMw+nns3GDJsvT1PASS6VZsihP0463IJEFy8poWzyUBqNCX9l/kkQI?=
 =?iso-8859-1?Q?Nxog23xZRuhwfICVIeLImNlEBXDgxVIGZlRv6H+T+LyWyUdc2SV6of6WHy?=
 =?iso-8859-1?Q?PO/r5Q5CxaFBbX0CCvTy5xNHH4V7mSIx0aQ+Wd0AhKNYMQmfMhj8YNEET1?=
 =?iso-8859-1?Q?rgUbMNdfzQGAPN2bhC8tobmSF0qBPFNRsMOPK6YD0S/Jgvq4LgQSn8WALF?=
 =?iso-8859-1?Q?3dNNImXGoRiYREAQC14jY4ElFtAsikt5OzEUFT5KQTXSqdLDuoubxqV1Uf?=
 =?iso-8859-1?Q?yi5b+6WO5NYiQ2bckiXua+f/gxp9H24E/v2nrA54Cf8aHi+m48lyxi2yKh?=
 =?iso-8859-1?Q?VNxvsTPfHMFuzL1Jh1/BvxJFlhvGLMkAVXL8eIKwxZc94wDYu6qA/F0ENk?=
 =?iso-8859-1?Q?oBnsbGSygyA1IhqFZPbDyz7QuqlieT/gnwRMQmLWwfUSLwUOSG15BTA+oj?=
 =?iso-8859-1?Q?3MRqWVcPVAtpQjF/OF/JLWRx8SQTcYZ7YEgk4z1rjsOM0JMYN39xl+Jvd+?=
 =?iso-8859-1?Q?D9FjqkZWhPt1PSlBGgSar4Og+x05ANPH6WaxDYFAwc8zrriGIHUyHmsI+9?=
 =?iso-8859-1?Q?CkcC852zJspVPhFY9AYUUEdjRflijNRTZpoQSnmziG+6Imp/G8LzEcOfTE?=
 =?iso-8859-1?Q?+U0jpH7RHYnq0PnadKV+JL9JFYhQBQoQVzE50MvZNs5t7nbtfC3DvMvViU?=
 =?iso-8859-1?Q?BKRkMtqc1uPqZHFukvNqJ9xgrN8mJXbdE6j7r3bWQk5pNcuCq2l1ALFLQu?=
 =?iso-8859-1?Q?1Rtc1tDmxSFIOcIrjs6ph3vZCXguVGr25sR/WI39UVfCTokC+Ln8EDqRnu?=
 =?iso-8859-1?Q?Hk9FrqCHKQV/W4mLp1mxthPynqTkdY0VY9sSqOvxRew6UOhqX6/reM7cM6?=
 =?iso-8859-1?Q?4XPdW61q69EwAkyKeoIbvzuZ8pipWxZNvyX5RHrGjCXDHTzVQRgysKKTp5?=
 =?iso-8859-1?Q?UM86hSIJsOw/9PavxcNKUeX+CchjJFoLHpI5KY/VBwKx5OmaKgqVseAZL9?=
 =?iso-8859-1?Q?+UU79u3QMR4Lc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA2PR18MB5885.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e6eb2e-30bc-47b8-70a7-08ddb221f7a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 06:48:31.4943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LMyffaKBjd45E0D6k0pHoQ/AlcJNPVZqmvh4Ioyh93JsM5R3wVFKqUt8ZMaHjtA3IlxtS2sVf9rZwXqOWmJJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4595
X-Proofpoint-GUID: lva1EsJlApGsLnX2OHdW5RHEd7pWvbuq
X-Authority-Analysis: v=2.4 cv=O5c5vA9W c=1 sm=1 tr=0 ts=6858f8c3 cx=c_pps a=BIp6kkfJeZTrem3KMu6imA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=6IFa9wvqVegA:10 a=-AAbraWEqlQA:10 a=M5GUcnROAAAA:8 a=vT5UeXGDksRoWzrgtFgA:9 a=wPNLvfGTeEIA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDAzOSBTYWx0ZWRfXxeb+gfO05nJg Jrnzxe7s5dRh249cNF/Upwcifttd3EHyqMwpNq8FI3VIHTTqqgKXK9ApTWkYWYzug8Oua5zM0Qt T9CEnJQkxIWByP3laMn2GQEm6q7hUDge8b5P1RFsvVNN+zmEXj/yWVWFcHwy7Vr9cwLOFFSG0my
 6og7yE4JCNjzkZhGT3TP7xr/zEc17v4QLDKQHx9T4eI/rTRRTH4xwtGxNwkSTwvrBrLSECJjRwf U8Yo/sssV8Up9meJRp/+6Yyir/Z+mZLTge6S49n+WwhJ8Ax7ONPq7TK5GVQ1Zjgn6bPeFDTugUK 4flXR5mhkFOjVwmrxJ3doOwMelMz4KVNUF3XvttwRaQn+KvEiIsv3Hzm4jwSrSghLx6UDsUFO+z
 bInUsfBTHQh+5qTf1UbYjYQfpDzKT9Hsr6zisWajSlbSDkQarVDwy/xyweBbz+R4shlHAJf3
X-Proofpoint-ORIG-GUID: lva1EsJlApGsLnX2OHdW5RHEd7pWvbuq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-23_02,2025-06-20_01,2025-03-28_01

Hi Simon,=0A=
=0A=
>> From: Rakesh Kudurumalla <rkudurumalla@marvell.com>=0A=
>>=0A=
>> Implemented mailbox to add mechanism to allocate a=0A=
>> rq_mask and apply to nixlf to toggle RQ context fields=0A=
>> for CPT second pass packets.=0A=
>>=0A=
>> Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>=0A=
>> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>=0A=
>=0A=
> ...=0A=
>=0A=
>>  void rvu_apr_block_cn10k_init(struct rvu *rvu)=0A=
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drive=
rs/net/ethernet/marvell/octeontx2/af/rvu_nix.c=0A=
>=0A=
> ...=0A=
>=0A=
>> +int=0A=
>> +rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,=0A=
>> +                                   struct nix_rq_cpt_field_mask_cfg_req=
 *req,=0A=
>> +                                   struct msg_rsp *rsp)=0A=
>> +{=0A=
>> +     struct rvu_hwinfo *hw =3D rvu->hw;=0A=
>> +     struct nix_hw *nix_hw;=0A=
>> +     int blkaddr, nixlf;=0A=
>> +     int rq_mask, err;=0A=
>> +=0A=
>> +     err =3D nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, &blkaddr);=0A=
>> +     if (err)=0A=
>> +             return err;=0A=
>> +=0A=
>> +     nix_hw =3D get_nix_hw(rvu->hw, blkaddr);=0A=
>> +     if (!nix_hw)=0A=
>> +             return NIX_AF_ERR_INVALID_NIXBLK;=0A=
>> +=0A=
>> +     if (!hw->cap.second_cpt_pass)=0A=
>> +             return NIX_AF_ERR_INVALID_NIXBLK;=0A=
>> +=0A=
>> +     if (req->ipsec_cfg1.rq_mask_enable) {=0A=
>=0A=
> If this condition is not met...=0A=
>=0A=
>> +             rq_mask =3D nix_inline_rq_mask_alloc(rvu, req, nix_hw, blk=
addr);=0A=
>> +             if (rq_mask < 0)=0A=
>> +                     return NIX_AF_ERR_RQ_CPT_MASK;=0A=
>> +     }=0A=
>> +=0A=
>=0A=
> ... then rq_mask is used uninitialised on the following line.=0A=
>=0A=
> Flagged by clang 20.1.7 with -Wsometimes-uninitialized, and Smatch.=0A=
ACK. Will fix this in the next version.=0A=
=0A=
Thanks,=0A=
Tanmay=
