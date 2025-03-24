Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBC72AF19
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 06:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742797426; cv=fail; b=Wf40oVIuOpwjnQxUen7rUeYZtOh8QDPJ7ojuw2VDtFeMlQl0nbWutbSPovMFveZbww0dbIaDAROMWWBKKmrn06uInZ/ZSOsqYO6rRFeO2wyM8T+riqDYwOKoIeK7dYiT/U3upnNph0gG04/rNezT894iMUhoyxpEN6dYri1mqm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742797426; c=relaxed/simple;
	bh=KQaRc+vyuse5/lpqMdIaty2efs0sYoPJW1Yn0yB6mKE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lJOrvNmkV/Xz/G9YEx6SfO2DWiKmFzWYRibCCDhp7V3JtYfPc4Y6P/SjN6bZQjOv8dmS8h980OoJscWEdLpXCXvnoyNvSzgklFl/Eudh+H5G3d9kKqzCVxNFRoGOJiwDdqewt7zhHw4sZNfBzcSOkXZN2m5lEmfWlbiFKtQsibQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=e1oqpF/+; arc=fail smtp.client-ip=40.107.22.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="e1oqpF/+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/mUfo8J1BEVX4biAkYztCuXBUaCWu8Q9UA16D2tg9BTsZyFsdoJma6GQu0DfOyZa6bjaGsU0HSwcusfS78zKmKx7e0wTcxfplylRSbPQVWxHMiXUlBUWeV/nXAFojL2uHL0hILS+kMsWCrcZQW2ePUzFHFmwYcV0MjFXy1s7PBFQR9v0lkBuERxhEXbfwqXOaL6lfvdAyTsfC0loHp+QpIDgLSU20cSBwoxs3j/cndXlvcxQOPad7P6xsb8cn4lHtu5NOYiOv8Hb8H6U8WfVo3Bmt0pZeEMSrpA/PBfYcko446AfZwzk6qEegBz22xbYLhyEMEGNSZ9/rAM5fo8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SCIZGHKQ2Ob+5G5pfuRxIrF+eMxpo0/MjEI/DDJ5dg=;
 b=MZpvcCBSyXLmWj2yo/4Tcy8yVlHlA0j2RdbTyyWOWU3wdXCf/XWuLTrVendKLeS0Uw6WTdLQVIhw1aEPt+Efe4z/swWuRRyTxAOpng9YyIDmJmfNO7L1qP8cd3ruLTDERxYkggaoJRvhc3Bwfb8qWkD/W0VRVHASkurhhr5Mni2Fk/KcsUhfV1VM0NGr6T6oCmIqe/JcPndoi5zGw0CIvadFsOsKNhleNmcMJrcx0T5JOLRuFwswQN2961ZpKqTTYhMC//CQGjvmG+rM8CtG6FeWqgTUUq4w3tDIg+/jh8XKfGFd/ofaTVqX4v6Rnrfr6oHj3w6nJTSPUtaShkOJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SCIZGHKQ2Ob+5G5pfuRxIrF+eMxpo0/MjEI/DDJ5dg=;
 b=e1oqpF/+FByU75szuUQxZBGcTfO+C+imTR5aWNHbgtewmfQwra2SjOvl0wkCiKoAt6qsiF2H0d4Pkq+3V9/dqrvOqsq96WmUwKHlr8l7bxjUF2/FxDoS8qymKf45tQJeNlW/75Gt5jcYjrfT1dA2LHhliiBOZAAbYQl9KxzcslG4Fz8SHy0MRVVkArTGjiIn8Het7dVjwSGm0tSxu5k/vFT7oIUepyimITXDPzR6Dt+GHCM655TlD2OItYupO3Ir1PYO7iCwBzn9iwW52Ari0GvJOysLVe9cWAIuUwg5WrIS8H32AXRRp3AK1jO5iSvBFUiJBKQTCSSN9o51AC1Iaw==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS1PR04MB9288.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 06:23:41 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%6]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 06:23:41 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>, Pankaj
 Gupta <pankaj.gupta@nxp.com>
Subject: RE: [EXT] caam hashing
Thread-Topic: [EXT] caam hashing
Thread-Index: AQHbm/Xe1BM5gitOrUa+gTTLYSPli7OB0fKw
Date: Mon, 24 Mar 2025 06:23:41 +0000
Message-ID:
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
In-Reply-To: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS1PR04MB9288:EE_
x-ms-office365-filtering-correlation-id: 8e5dfe43-4580-4249-e4ee-08dd6a9c6be4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018|13003099007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?7slmJhXrWSCLTmk+bY8QoVN69bv40GT5LYZKGPUdOS66qMmM0kOoZf+3SH6F?=
 =?us-ascii?Q?g42E8Ql/35W6mKYjoYkMPt3kGIYQ8eDKFcf/zzimTi/MYExolBPo4dywpTbd?=
 =?us-ascii?Q?VMGC20B+1Hjk6NmzFo41NgJRbSbe4K+Mc23TB4pRwoijdXErMSXd6K8VtMzU?=
 =?us-ascii?Q?3YLlraHcSM9s0yQD6s+W4ZK2A9cgGDJR5oO34q124ahcZFHyKZnaGDcRIj/r?=
 =?us-ascii?Q?/mzP1l10EZU+wlvm+qAhqU2ATOXOz5SBdpu6Uv/h2vG8G6sqGtjlXbKxqlv+?=
 =?us-ascii?Q?YFHLXb8m4iYqQbWKAj/zWMBrzEJylVwxFzf7a1aIFtrWexuGZ7i2XU14uVAP?=
 =?us-ascii?Q?kJZCyFp/LiNNttXuv8XwmKN54oTEUQ1iATBMuAhyUQ/UKD/j4R/WuDQLPbYA?=
 =?us-ascii?Q?ndqRGOVnSfnf+qe1/RBrXjEFeUyMTpizXL2hdViWUwm6mIqUSY0GlIanKv6X?=
 =?us-ascii?Q?diKvuP/qPnQ+fqhbs3nw6TpXFGMgqGldcILxzlTzw0On5iluJLQJwPU9+SPw?=
 =?us-ascii?Q?KZIwqrngz5XPcZhctEP8Tsxjjo3MQSD1+Y8SjnrS2f/i6oDKRVbJdvLLQZnV?=
 =?us-ascii?Q?b1yJQ3lRxfdgCUyadhPDWNLjxhTDxvfcrTbGI3RIQQ4ppdBLzwYX01WcEVvN?=
 =?us-ascii?Q?XvHud7er0RNRhrBmtI3OLVfKPNivDBq4Yd2guOG/3W9v+Mj9xhewUXn2AOoT?=
 =?us-ascii?Q?7ltrFRNc5ESTId+ewcyy1+Wg90rI5NYib7jqisv+NCiWJli+yb2TJGH1Nd2K?=
 =?us-ascii?Q?UF/72B3yLYrDwezJWn8BaKHin3gvCbxdJ1AKbkfjBfU6ip6HRx6MtEcfXs8C?=
 =?us-ascii?Q?/7SQ25G5XGVNPLye6bY05dk35hUDNWG8O7QxG/YmIS++55lDAPKyEc19ugpi?=
 =?us-ascii?Q?yNQU1YbxVMiaXnDg//WENkZzUu0+8yOuF5FQ5aabYuAfU7loq7qS25C+dku9?=
 =?us-ascii?Q?JQ14oNzWE6r/ihjs9mxjQXo0OnCxk2xW7OZk9k0hSbn0/vGgjmsLWdFS/XV5?=
 =?us-ascii?Q?Z3WW70wFHbWyIW+2TUHr2iRtCBWqUtVx3pL+/Mg9sffVV1qAoQvoiUh/ALQj?=
 =?us-ascii?Q?cD8NN77yilrUDJKe6aRyphlrOoEHU4ybZHJNQGSmwPCkeDxobx/rutDOm/2G?=
 =?us-ascii?Q?SXUPlpA9F/oFCimZCHmBNmWvJ2fXgHQ+5yEg7FZk1rIlLH6/y8hKdhfbIVaX?=
 =?us-ascii?Q?Y3ovTE9TsoOHEfdjxXS3/RnlxgiNWvFRBJ4p5+cu3pKpFoLHDCtbcPmDJEZ/?=
 =?us-ascii?Q?AGxTV7zXfBdTs513nabvDbS3qSHkGxtpvEtA5ifFMwki7h+R+fSKLQZO7Cph?=
 =?us-ascii?Q?I3BKas0PHh86EX6XeII6utZhuqN8n64woRnoWnIQzLYhj7q+k8aUf9PupfyB?=
 =?us-ascii?Q?toOjq4pGNu1Lly/Y7o5FDEXf8oFq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018)(13003099007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ILieul+bSZNSwmCi3V314eFGFjQd/pm1tKE8d6QaN7epwFbFiaNoFmg+HVqH?=
 =?us-ascii?Q?1x+guyYCCCgHcZDsMVShV7rn80P9zmwuakKWaNU1atinXHgeEG9mUm5lCxAZ?=
 =?us-ascii?Q?dXYuIDOWIejIFiM+lfSYau3kE6oEwIiwdBOl9TBPplBB7ENSqe/n4XQVUb9B?=
 =?us-ascii?Q?pYjhriEwddjEgeHwNPm9yDz4amrk1/ewMXxKdyv0QlNxgzmqO1edfWtmm3LR?=
 =?us-ascii?Q?NYFt7W2UzC772UeYx9ASW2tyk+7F5mgm19/wqp3THOp9AJy3V9oQyO9d16vX?=
 =?us-ascii?Q?OXN50IL21E1uVDkRQOMfgv96wl8RRAdsXMpxVQAM6kftZ1j8cS6Bshgq9yOU?=
 =?us-ascii?Q?KxY7N7EozXrfioDtkTsaMlib8/Fpt0TeyCsaBHV2tanwMxxJVW6XHRw9ZiG2?=
 =?us-ascii?Q?/XdLMgtd/ZiPambQno3WYTInRx95e6aevYib79/fmn7b7IJlUksHSfSRVB+7?=
 =?us-ascii?Q?c1t8bu8CUjIbYIV5IoqrvxocVrVPA9Iw8rb885DBaoFQoD5P9n8FWwIcN94e?=
 =?us-ascii?Q?8ULkx3dhk74tYRuEkmVXqbOC7zpoCXqbh/yI/yAdMHgvAaAY0PKvgIq9jYkT?=
 =?us-ascii?Q?lvT8CxIKgT8AETvJJ6XrcNuCOq39gZvxMBdsUl0zaQgv3zJ/cpnd32xAxlR/?=
 =?us-ascii?Q?8NHHZt68FNwkVcSkLKnv75k9Yk6EA2N4Nr5GOH4pO+W5XTpDNwNLsc9bBlqU?=
 =?us-ascii?Q?vKTxFPuYR0gkA3SKgvJ3IQgdSfgpoVqnXCkhsoQUbaYuk7tYc2r3djBs119z?=
 =?us-ascii?Q?3xXldHiIG0MvmgtY/8dQIqZl/0I7XbISk2BdFDW+hv8kGQYmJF/LqyG6eCNt?=
 =?us-ascii?Q?y0PMeycFtR48GfDWqjxvPSSeIPkX7XAz5K+2LsefA0TG5qG91WdB4uN5scQR?=
 =?us-ascii?Q?w5vi36zxUbE5//uzW0S2ZRYIlTs4d3MN5hXn4ay/gJ2FEwfNFhns1Hd/Z73R?=
 =?us-ascii?Q?b59RRgTkEw93CFFgQ9rSpLZIXlXSUd5Ds73NSwqhq0AUDg/FQ/E3Bg+8mqm8?=
 =?us-ascii?Q?RwbZTaWpnyJ3aFc1WE/5QhE2bsGchzn2kHQhIN94b1hhOlfHIwiiJ2qTD1Dh?=
 =?us-ascii?Q?BxIuikBA+IXTm/ph18npbqu6VYnY+/LSqdBlUhtdcLKdEzF7ImJKCV8HntDv?=
 =?us-ascii?Q?bs8gWs9IR8zIh4tWyMNTyRIiYW6Dm6Jh5d7kNMfVaS+9DrsR2qEuFg9M9kjC?=
 =?us-ascii?Q?M3lq11IWXwCKPFe4oma4ZW4zgoOjLD8EFlOCjxRlvTev4coVW+sEx/h7yYlZ?=
 =?us-ascii?Q?P9H0WmORMjMx/+vem1Qu/tSdfoeAfRMnNlhSLBspXZIw74ZLJHsSGcsEzuk+?=
 =?us-ascii?Q?kfMIX0rW81sNYB2xKSZ8I5x16PgkBClclQERe27jCN4YkKlzKfgd+tcuGehC?=
 =?us-ascii?Q?YWIwMAQaZhneZzPDSpsrMbMirQdHNLivi1sGcmkLhk5RHq/emF1fkHydUJmL?=
 =?us-ascii?Q?TgjMWoTJ3R1fxM30XCHAsZ4aY4HulWNpD1S6fK4cIS1z6Qj0TQssRsgDziq4?=
 =?us-ascii?Q?Sb/TukVW8ArF2SnFw6Ao+nm5ZVZ1PirHxubO/H77At9NOwDk6QxQT77z3jlI?=
 =?us-ascii?Q?Uix3w2HbrvXlyCz01kS0GQOdlDvaB5ECxCwVUSRN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e5dfe43-4580-4249-e4ee-08dd6a9c6be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 06:23:41.3715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFT1uLMqpwTA8vJ7JEGhGuRuW5hNriKmevw8IxUqEDxUuMqxJmMZ4D/RWQ9ZWXWdl+45uogUQIK4j4cs0wt6uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9288

Hi Herbert

It should be CPU endian.

Thanks
Gaurav

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, March 23, 2025 6:47 PM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Horia Geant=
a
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>
> Subject: [EXT] caam hashing
>
> Caution: This is an external email. Please take care when clicking links =
or opening
> attachments. When in doubt, report the message using the 'Report this ema=
il'
> button
>
>
> Hi:
>
> I'm working on making the export format of hash algorithms compatible so =
that
> you can switch between implementations seamlessly.
>
> I've got a question about caam.  caam_ctx is supposed to contain the hash=
 state
> plus the running message length.  What endian is the running message leng=
th in?
> Is it CPU-endian, big/little, or caam endian?
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apa/
> na.org.au%2F~herbert%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C0446
> e71d9c3b421145b708dd6a0cfe71%7C686ea1d3bc2b4c6fa92cd99c5c301635%7
> C0%7C0%7C638783326240938282%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0e
> U1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIld
> UIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DNWGG1NLD9UhFBjYU12FboJF%2FGx
> ID1NsXAcfMjqGKBtk%3D&reserved=3D0
> PGP Key:
> http://gondor.apa/
> na.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C02%7Cgaurav.jain%40nxp.co
> m%7C0446e71d9c3b421145b708dd6a0cfe71%7C686ea1d3bc2b4c6fa92cd99c5c
> 301635%7C0%7C0%7C638783326240960950%7CUnknown%7CTWFpbGZsb3d8e
> yJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiT
> WFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DqtXx%2F%2BBKFYHymw8
> Ol3vzbG9VeYHQp0CiR1I%2BUBLGzXE%3D&reserved=3D0
