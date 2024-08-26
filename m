Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2137.outbound.protection.partner.outlook.cn [139.219.17.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30FA7489
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 02:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724637910; cv=fail; b=r3dJM5qpUhORPNVvXhNkX4q8XzobBIgQiLMjr7zCdVrfNffTdOsl7WOcKhOYp0BOYuBCQjCFaJC9XrBVR/BVoYzdPvBhIa+esXOFuIqkGbrU/52GvvJ+gl/KfRT2AYvi2/1gm+FZbqMuAcSSukGQs+NoEZrawSSJ0w2q6DR/5+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724637910; c=relaxed/simple;
	bh=bq0K9ypTFMSsTH3oDahrPe62PswZZXOpiFPSOd0rn7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Eg+Ek/RqRtOmk2fOWFPN4km7kw3s0tcbl6kZAfcvhE4LGjNH5ZWF1A+pQ3ksVbbV9A43v0AvG4WO1/o+aUQfmI5fU9E9r8nkKw4lhPI39jJqvobHBNMbEeVPikowEARgFOzKOHmTGo7C9Qha4mMJqwvFx4D1id7CnEc1ifgktFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1NGbEJSW2Ubi0ev2S+lbBYPHkUOy4ttDOX4nqyL5jJyY0XAJZB8jxnkXeymVqlNYLib8OEtJ/F6P3vAjh7wgHGuDE0geU9ZjwIKU0Cq41NAl+o64I05xrC3LQ0UT22LEj1YjVPF/rdYB2gkOfeNIyu9XB7Su72VZA9h2wYSuVqlh9OEu2nLCM2MlGcZSZpxLF7YcYNE8Lr7UrUk+IGbM3mudteWjPZGXSV/puA4fwrUp2DwXORloTg/whlJoQCUmyBSiZZC/fTa9twEdNcbHZOB/uSdokyzPRHcWIc6WFM9Z9wpx0I2sOzuQe9XzCnfJ4VL+eg8vdU0EsgdsMb+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq0K9ypTFMSsTH3oDahrPe62PswZZXOpiFPSOd0rn7Y=;
 b=OXxOkDguVGDXWbZGCnLSu0ZXja3X/oFDPjWc060+xaKcsIGm1oy7XiUEM/z7tDqVoQitVtLERG76qxpAwS8aDFk0nO24EUGBxjotSa5JtwrBG39M3ORld5ifdhxuQWpCUFZYXETe+2tJlVSdc5Mh0ILT5zP8tfrTBVjMhOb5u0Td0PZfPAaeRcnJlRtCIhY7zQIcw5HWdHWf0EAmWLB9fNvz+3+2xQqOiaJivMLv0paBlEZa95xHYM2vVqwlUV4qEKz3kCcei+CwzryYV2qFnYscdbkqHV9VtWcEKue6+ke7pYIQuDghZArztjeX134Eqn0bnYHddobMMw5nUICHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1184.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:11::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Mon, 26 Aug
 2024 02:04:56 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::f92e:ed2b:961a:ffca]) by
 NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn ([fe80::f92e:ed2b:961a:ffca%4])
 with mapi id 15.20.7897.021; Mon, 26 Aug 2024 02:04:56 +0000
From: JiaJie Ho <jiajie.ho@starfivetech.com>
To: Aurelien Jarno <aurelien@aurel32.net>, William Qiu
	<william.qiu@starfivetech.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, E
 Shattow <lucent@gmail.com>
Subject: RE: crypto: starfive: kernel oops when unloading jh7110_crypto module
 and loading it again
Thread-Topic: crypto: starfive: kernel oops when unloading jh7110_crypto
 module and loading it again
Thread-Index: AQHa9mUCPj6ctnsii0mHD65iohBobLI4y46Q
Date: Mon, 26 Aug 2024 02:04:56 +0000
Message-ID:
 <NT0PR01MB11822312703A78C4F17C302B8A8B2@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
References: <ZspDyIZiG8kvXaoS@aurel32.net>
In-Reply-To: <ZspDyIZiG8kvXaoS@aurel32.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: NT0PR01MB1182:EE_|NT0PR01MB1184:EE_
x-ms-office365-filtering-correlation-id: c36aeed1-adba-4f52-7f0a-08dcc5737b75
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|41320700013|38070700018;
x-microsoft-antispam-message-info:
 WwbzmL8qk7USj2605wpIS8OKA7bjqQ0f8Hjx38bAHlkvyv2MONYQ79t6czN5oxUQncLL5cWcgXsulpL536TMdSVzfbUtZl2UwkJ37wVphAzP2HcZ0PAgpNxUImHSWeYzuM/AM0dCnGzRRyS8w6mDsNSy7WHqgfhmUPAOg+fnVHK7BcvFOMUYfO2pSjojkSL2I8ho1MrDu7w0pieMsyl5SaE5yLeScQWD5sm1Ju8TCIaKHASQXC2cByE5Huti4Npsqa/7ZHIP0DJcH+U8ylFhR45Zne4aG+GKN8CNODTDn8bmDBBVjxRV/d9x6SqdVz5+dHCQSY9rN8E0KkjszLuE5lJooOXY5wo5szPCrwwCBI83pR28j/rdUalyaXo1d4XiFS0nOv9ZH2wPhuSHyseNzre5UmCiI+0Ltjb1X9Q2FQvN4ey54x78p+ZK/FkPdjNSxDxV15YpDliAkJ1DnVzYx4XuBST/59aGUrXQ1VDZfETkKE/zt69IUwk02a6H0r64lOyvJ+j1GW1Ze02Tb11oTeqKtNS8E4eVf3zt5/YGHFNZZbCDDgFZMyvzQoxrmm824FJtsSMHSl4rS/ZJ2g0TKOp9cGf50gH1VTcs58ct2Py8zRWGMcex3l/ymcH8edn+
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(41320700013)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PiChpTChvdZYcHj8Bi2n9K+nh84U7tEXVWBqGy4w0TFenZ1cowUEbf2jTPEO?=
 =?us-ascii?Q?ahfSJEyu9GVxUn40p0qj/rq/CvBr+V3ZyG3xitUpgC+gjDMslp96FDAjyRuG?=
 =?us-ascii?Q?KqCdmiCmH0uCtShUn6ZrRwuJfYP6Bp3MRNEGNm23Xp73r+oB5GtReujt9r9r?=
 =?us-ascii?Q?SLiUMjPkEmu7BMhlh4nx70/lpW8XbbHMlBMgtDO5Lmx8iQAmvypbcN7KsdFG?=
 =?us-ascii?Q?1wkkwDmk3ysD7F5kHveCssDtDBT+xKd5klBnEp1tnTKd+CdLAEPRa1xOTJU/?=
 =?us-ascii?Q?6n3pHtmV3jdBaP2PpqV3cOVNrmaGN/NxBRXfkFnwj2A09Is/awLJmixvM7wO?=
 =?us-ascii?Q?LN9aM8keMnc1T+aFy8nQX0Mwf3eaZylyCDFmiSNdouZSpoIZW8vVWameE+ER?=
 =?us-ascii?Q?Rl9par0j0p8jreirU2Ii6e4grQuzHs8o+7/6HtDopybAqQMmaW2/vkjs+PEM?=
 =?us-ascii?Q?rIme/NH5rCAUBFAZ48JhnNu3eIR0SwjIw+l2nRFSaG/wiShyXQgVsEPmP3p/?=
 =?us-ascii?Q?6LFRoEZD1hpTcBd2XAOMmBZi8qsQPnjlDwbaqqfn6hDvbTk9PN7UJzDiN1ei?=
 =?us-ascii?Q?X5agKT+N5CbQVjZ5EyiI0/UnCkn/liuBrOcFbUDNnFkkLvv9l6w8qzMPhzEq?=
 =?us-ascii?Q?pe2E4NKWSOFLYN7PciHyKfBw0mX3a5ImNndfKWDjYcKu91sIlFbA4KOvJkLR?=
 =?us-ascii?Q?Qid+njjl/yPEOfDJASNLvbcVfq8VpP9HWy3D3KA+YYu7C5/MViekXnJgyk8x?=
 =?us-ascii?Q?tvRTQ+pDh8s8vqJzaa3Kqwy7EaF9R3Wi4M1t9ml0jhfe2A/yP7Di8Wevrqw9?=
 =?us-ascii?Q?BCORc+EDh+FnS0Y+F49osb6RnbA2VcYRFXkP2dqQZgcfb9tVXCCMBgxTrueM?=
 =?us-ascii?Q?B9ZHj7CH864r9bL+0+kDdTBwZLpzgR3fXX/zGoIxK7lBCeR1pC5I6C0ciMft?=
 =?us-ascii?Q?KB2+3neKHN6FZmHvaJ6oE40UOjmRL0U4tZESZ6+SoNiIg8EQdP0iJxOp/MfB?=
 =?us-ascii?Q?1pAi6XGS2/RyD7xnKbsLSHaU2E9pwbOcx+5mWvLXNZJnhQ5M4gEr6MutR3Aj?=
 =?us-ascii?Q?Zi3ydZFzKjT4RuXIjOz26vrUIUDg33IAUgTeNqxS8YEXHTa6vXKhRCLWgvsn?=
 =?us-ascii?Q?xf9OR+YarO2166pQ+7/kicr8U3wsGymxUG/co5xFstAuoXdnisxczQgFkops?=
 =?us-ascii?Q?K6mnHBUmawP8bcmyg4GvpeIMN+T0czZSDEOmS4ZJgw3vkh2gFp082vTVTGYU?=
 =?us-ascii?Q?Dd+ld9RUl6cyzC48sie+9T25GyfiLsKhff3DT/VdEQe5qE3OHCt/Z50koNkA?=
 =?us-ascii?Q?5vYMEYerg/hISwLZ6X23vemdMGW7Gj2czE7+vcUOL/hnQV6yKz4G7ibOPPb/?=
 =?us-ascii?Q?BAO+x/NqWuGpu+IdHnmo8wlYGCo04Hv5DY63r+z1QjyQ0YN/iSWTlM+o0caK?=
 =?us-ascii?Q?WzqYloszY9crZEVVpKSl/Mhkdgce6zTgzJb7SGHaenssUL4nlCdS+4aW0n1r?=
 =?us-ascii?Q?HXeRoN1A1M92AuQn7kICgRTo70gw+JODbEYViG0wlFYfNZfscJUV1EqiY2GS?=
 =?us-ascii?Q?OLySssb7hLMSTDfjJ9kJ3ttDYXW8NFjz8f8knJ48L9o07hr28BqTzNb6WTvI?=
 =?us-ascii?Q?vw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: c36aeed1-adba-4f52-7f0a-08dcc5737b75
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 02:04:56.2524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2GO4ll+V9wnVPAJK3wl2qG6V1WuY/VQEKbcBdqGFUopzYo8O/Gw70ew3xXhTmDEVAnREmBWwtW7Whrafo2IQ71CyhnTbNscrHUokx1lhAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1184

> I have been testing the jh7110_crypto module on a VisionFive 1.2a board,
> running a 6.11-rc4 kernel. To benchmark the crypto with and without
> acceleration, I have unloaded the module, and later on I loaded it again.
> Unloading it works fine, but when loading it again, I get the following k=
ernel
> oops:
>=20

Hi, I'll investigate it. Thanks for reporting this.

Best regards,
Jia Jie
