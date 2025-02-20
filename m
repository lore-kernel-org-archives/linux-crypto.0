Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E7C1F03EA;
	Thu, 20 Feb 2025 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740046701; cv=fail; b=K5o0WrNC6zs89T3fPEcQggKeYrIbD6WrywVb53RB1VwOOHARiJbIUt8zrhTw6kwCuNs/e4RmZJMJl+EaKkkaegx/OVWjOgLGrv8w07cBJbknceTbw0PKGbH4K6cAMTJV86gLRXZzEFUvFks/+X8/3aHK6oap7W6nQvW4qBQeoY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740046701; c=relaxed/simple;
	bh=34+5duLucbzGb4RB7wJa01OxVcNBoIycWsecBVBhk9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L95peMisGBZmQQG7ub8L5y4cdPeylnHvsXSbHCmiQpV7HuRjRbug2hThd9GGF5A6VbcgcF+IaO4xEF33S/YQ2QvF6o/oFut1WF2YK2qRhUR1hnnBk7hb5vvjP55qydCxwry11zm9D2RX+fA/vd1V2OgjcRSbmf8I3XrA5Xql55E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=Ut0g1B4u; arc=fail smtp.client-ip=40.107.104.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ut0g1B4u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svI/px8g97rutUJrrnAVBFSJiPb0C02Sew9za5s/dpLtLSDJxXDzuL5Tc0IoRUiA31ZZTViylon4OryAmiEqJhVgIpo0veME0euBWF9WnnbICalkV1wsO6atbSmP/Zt8U89M6PY2o9vqM6pw4iD72sFImveQxC4T6CddUePVAMUQOU0XV/z20CfZ7K0KXMAaDJyhBas57iRNioaIJwJ9Ced0swPYELjqSj4M5eBUav8ERtmrQEgHHLCq6McrsTO2Te+ktT9tZBXjbZLJxsiFHXNSJf8Owdd+/T62klLy0CcEiySlP2BTEqYZtUxVKI+/KklWSkQlz7zTyzpasGUTqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qG34LRr0zJthu/0NifczuDL545z4NTptn79V2jxLHI=;
 b=wiZvH8MraP5ZcaxV5o8OcFmiQyo+FhUyCM4jpKyQAtCvsYsUukRRrrxAWVDyKT/o9xjvxGWxA/xr3ggASWffaM930WtRgzGEXCiJJUGON/H+eHHqHkjJF/aQpF7pZEUCUnHfSw1gU2PkjvTpAbeM/4rX19YDX5Crkx7pRKl9zHre6FSxfk/sSgqVtQmLEFmrEs3eZHIRVSW0aFeF2qA3enoWfY4sQ3ImjkWqyfYgLzlabImgo8lv6d26HJ9vGnsVgCheyRdpn9PjI7AcVhValpN6X4/lvzlUbE1ofdgv+IFCaO0skld6nwQMzeh8Kon+styH/wFdk2nRB2KxnmxO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qG34LRr0zJthu/0NifczuDL545z4NTptn79V2jxLHI=;
 b=Ut0g1B4uiabmB6Rm639rJJu7YeTlKh0q8Z2sdxyITGhXBhU91VB0akQu1IIMoQnKWuPkGsemGTF+6hFL1OBjthnhbyGmDPyf2H4VZgHXlU9+KRIzDgxlTxzaz3j7moiwKTFgJyJpZ87DgwiGB/Eti5GwW6eKprnRV73AyVowv36CwcuawooivwuZkRw0daStjfVvWAM13ViHsKbRJXFAArQdyjkbB+BM4kGWDbPYthVdp+MxHbf7wGOVZqwwHVBHXNDPlPx59OXFssP3apP51V0W3JdMrbt+4BY2SvLxsqnP0Kdjffm0z27JG7l6mPm9G58fwmPoCHd2ziezLlOSmA==
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by AM8PR04MB7809.eurprd04.prod.outlook.com (2603:10a6:20b:242::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Thu, 20 Feb
 2025 10:18:15 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%5]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 10:18:15 +0000
From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Eric Biggers
	<ebiggers@kernel.org>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qat-linux@intel.com" <qat-linux@intel.com>, "heinzm@redhat.com"
	<heinzm@redhat.com>, Horia Geanta <horia.geanta@nxp.com>, Varun Sethi
	<V.Sethi@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain
	<gaurav.jain@nxp.com>, "davem@davemloft.net" <davem@davemloft.net>, Iuliana
 Prodan <iuliana.prodan@nxp.com>, Fiona Trahe <fiona.trahe@intel.com>
Subject: RE: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Thread-Topic: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Thread-Index:
 AQHZr19tPftu/4qhUE+Xly9w5Fkd4K+rmzCAgAAMzQCAABCvgIFUBGJwglCk2wCAA0CDsA==
Date: Thu, 20 Feb 2025 10:18:15 +0000
Message-ID:
 <PAXPR04MB8301A857849714D169DE8F088EC42@PAXPR04MB8301.eurprd04.prod.outlook.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
 <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
 <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
 <PAXPR04MB8301C112A114A6AC5A19D69B8E452@PAXPR04MB8301.eurprd04.prod.outlook.com>
 <Z7RGwot_t0RLc3-F@gondor.apana.org.au>
In-Reply-To: <Z7RGwot_t0RLc3-F@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8301:EE_|AM8PR04MB7809:EE_
x-ms-office365-filtering-correlation-id: d2358fc3-8b5f-44f8-7639-08dd5197e35a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|13003099007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Z5d3D85IYnqjeCvnBYFG8JDEDERjpXu/xxYdrPiq7WTR+NXE3PX1CEHg5NaS?=
 =?us-ascii?Q?w/EwDLAdUUdXrvByzO2C5Nz4VjNwRjNX681ZcEIhMwZykGp1jxl+n/jjoBxj?=
 =?us-ascii?Q?Up91xClzLDXalCzFBrpmbJpBpvgHjyiACvQVw5QYkX+IcWOD9Ifwhhb3nTSA?=
 =?us-ascii?Q?admSKlOAPlIuG458KoUi4Z0U7JyJUzfXeO4G3OoLk5neXRmfh2BrEWJYcJT7?=
 =?us-ascii?Q?LMv0UDsfgLTOKt4T0Y49YD4+EbJrAqWYYANzGxk+xRIgHJoVdJ4ElwzvbJ5N?=
 =?us-ascii?Q?VxaenwwafMpRYUAq+QWSROFVseYthYObgFPgdH5p+JJq30kSGO4aheH5lGSJ?=
 =?us-ascii?Q?lVKdpTnA1PEurzAvqM9la/D5AUVwCsz9udXo/yyoNa2l0DpV5g2oFDeC9srH?=
 =?us-ascii?Q?hXyJ2LlhlYZtlZetJJHNNz72C8fmw+iu1PWG7HENQYiVzNUfNTqCTq3r4pML?=
 =?us-ascii?Q?eXF8fjK2CsqGdy+rwgqpi7ZUNOm0w7OzqrrxvZIVol7qkdfTTz9Fwwj0vq4o?=
 =?us-ascii?Q?XABRMj+2qIHMJRtZNFwCLMSKsTS1fOu/BF0hNwiE0D09mtiSndFGS3wdW0cQ?=
 =?us-ascii?Q?woEhR4occXYPJPSS+EXfE3xCk9Mx1VINyUdN6f8dBq2JP90XoAY+8jI1dftV?=
 =?us-ascii?Q?Qc7tQ7Ulg0k//oU/9ofxhn2kj8Yzh8hok/0WmDqi1HmZTdy8J8rYcsJ5ifQq?=
 =?us-ascii?Q?wHIDjFrUGV6kch1Y09ynEYWiTV1xh+lVux/ZsqvQUJmdytZsucbJg4J8GVvH?=
 =?us-ascii?Q?DjY8mlR8+xyGrPQBfMKUC/hIZEXGS4LE5zvwshu970qC4UQsSUscenZC02Tc?=
 =?us-ascii?Q?GvmmZW+Lids8N9qqTdUrtf/YtpDiUOvV3IRWv61tGn3BAaoxZ2Z41k6q8JqQ?=
 =?us-ascii?Q?sRBOubaHC7xOyRl5HiMvbON1OgtDL2ritRumz0NkAeyvjIHxPuqRNPVQcFVQ?=
 =?us-ascii?Q?UGpECFz31ZIM/UMEFH22Fejg1ErjdjtLmNxUmtr/pZnOJ7mzcSklgHMDk4Ez?=
 =?us-ascii?Q?RyQtZMWnB3ZcMpOosg/+oYyQUPww4c2qmohM/BQ9MGZ8s/OKfbjtemCwbH/S?=
 =?us-ascii?Q?NueIbBLyuZFIn2lMou/c0COeaFS5zFsOn3dI6ZVHxfftzxocYgcQc8APnLPo?=
 =?us-ascii?Q?vX6sY6zSWdyWumBMnEKOtU0+KTFTgyCaQXVzaV0RPar4ax+TGs3LzJYDhQe0?=
 =?us-ascii?Q?pUfYLd95qq24VnGGpZChoUCWmiB6Te9XvxICzD2Cq9zB8jQ38OhLu6XQce9H?=
 =?us-ascii?Q?eJq6P0tzXPxDRe9qT660g5oLzY8uifE04rWUpU80jmr9siiW1JCWedB49kZo?=
 =?us-ascii?Q?5cIKnu+i6+01IFx7vVES26raXaGZLddBMwCDCjl5AJXB4Bp2C/5rS2Qkgdbz?=
 =?us-ascii?Q?uIvcRC3eR/O02uirlKU1tTrCdbKUD0+V6iyYL5adHI11wAHL/Mp7uB9O3SqB?=
 =?us-ascii?Q?xa1TrpbTpOFDt7MxqK9WVw+TMnIF3Pbr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(13003099007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?DteYQDs60vUDwroYThL2pRBw2gxkUc5HJy7ZgDVnPzqX9uWot0FNwn/Ev4v2?=
 =?us-ascii?Q?Kr4mTeTo3MST0bZPf2ITuWtR/egVCrO7xN/110KvfV7qRL3Q/iY3nXMc+qHy?=
 =?us-ascii?Q?nNqiJBqkZOTNfzVdibhjUT4ZV2tgnfw/chhNq5oxji+tLh7Pao9nxrz3HrGl?=
 =?us-ascii?Q?FK+ZuDSkwUo/x02LowMGRxH1MGTONcfufAbEVG8/8EaZa9ZYhUufVWVHbYbQ?=
 =?us-ascii?Q?i2Dcc4dlf4bwB4NSaUuV6DhLflXp+6uj6CN/K2WR+eNRmpG89FQA0976PaC3?=
 =?us-ascii?Q?ccoAuwOtiOVHFQFsBy9Mat4+zqvHp59beFAF/HzDBx51+6ursSNycoXghaw5?=
 =?us-ascii?Q?Zx8r+mB/gp5m/NxcKgU2ush0For77PnWmtMiyzSvekecR0mdss8BvkYcPXym?=
 =?us-ascii?Q?QmHijYg8yzfWQRJHGiWmb9hptoR7K8jsjHS+/4Z70bGutnxKl5jtaqGPIrBi?=
 =?us-ascii?Q?jPxpBGTy73g7y04uCBzu89/N6uvv5AZvESlu9BWNpbMda/glZ7gUXPpYVUFI?=
 =?us-ascii?Q?o6QYDeru4Y7HxCBhFKLQTS1Szd+gv+fR3IwJWeLVNljadPJM/ZpPg0XF3NlS?=
 =?us-ascii?Q?Rd8HF2yjK2UdL5J+csIscbrMJ6rjRxZ9crh1if3PY8XL9bNNIILX7UqciL+8?=
 =?us-ascii?Q?92uBWTbtCAgay6MbcENgviJ5j5vSREAlds7w7Oa+IZwl/qB7176+s2ZsdO/X?=
 =?us-ascii?Q?4U4lJg/34IbYpO3Vq9atcXbuf++GTzJbYgFTcilK4Z6JTR2BHj+m6bixRyax?=
 =?us-ascii?Q?HF7mqZlDpAUdppuV/pPG3t8/Gmr1yDynEEnnOYqNG7u7CywJu4FRtwFv3/p/?=
 =?us-ascii?Q?ismDmFSeqMFvlsfnAZZC4v+M6mzbHWB8BI7efc8wHelRDov4oSPtB3wa05NN?=
 =?us-ascii?Q?8QPyjrSm4iT0AjCeY+M8xo5tGBkcZTf5mUT6QCUeR7eK6n/ZgpRaV06xHceV?=
 =?us-ascii?Q?BszNN6nMgI9Cj5CIfIuUyiClVm6WAkMWyJQkhavpz/hJRfcfSUsEufhKXNpX?=
 =?us-ascii?Q?xLlYoWTK4qBxdbasucU43uF5Z7hvgVdB6OJIiQs+vW+nEOGFv8K3sofUTGDH?=
 =?us-ascii?Q?Um1pSJ/8JpVsJgFbhm0QG2StVtGFo+BIWXyxkwmwjKrqGN4PL97Zee2VL7s1?=
 =?us-ascii?Q?KXvNr/Jgs1485EnMgNHZeCfV2NYXVrNdjhBFD3lmP69do6wkPxEW8nD29WGd?=
 =?us-ascii?Q?Jh284dzJWRgXLhuSCoek/SnuhtYcOVnFTErvcy6FmgIUmEkViIJbcgYYyN7x?=
 =?us-ascii?Q?Z3bxiE6CeGitJlN9w8IsTpJdENC7jOTflvRaFJsx1qsr4FUYsQ4DIeViyXqp?=
 =?us-ascii?Q?raWPFfFi1NOiy29oYgQzJYd0U2eRn728ehmkYgPtJ4kg1u1Phe8eW3yJnbXG?=
 =?us-ascii?Q?l/fvoNdVq6dZnkWY/GxilOcf4K3tLO/lyT4xm7jguuu18/aoCmTPkjZEteK/?=
 =?us-ascii?Q?TkmP1BzGIIJ0DyLPz3ZNoxeR0HNcPnf8Ol4G3RDz34lbmu4fvigAuwpxIHQC?=
 =?us-ascii?Q?sga/YpNKzlDsGJYYgFVc8kf2ohNwYoC4GLlhER/W1qKQ0XnX9BwNDVk7xUzF?=
 =?us-ascii?Q?BvNTjbTGYL1ja9rA8znjJbYuG/5GMGMQz3Tgcq00hLr+xQ+kXVpIqOQcdRe+?=
 =?us-ascii?Q?fA=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2358fc3-8b5f-44f8-7639-08dd5197e35a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 10:18:15.2660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maLwIH+pCLuJZhvn1uAb9Sv5/+9e+c7BiXOhJJPBwFIROzpQkBYnPz1pFXQ9iSTm93eCQa/f3KMi0NjmzqWvviJj1aNZxkvYIF7f/Ggra/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7809

Thank you Herbert for your reply.

Will look around this.

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: 18 February 2025 14:07
> To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>; Eric Biggers
> <ebiggers@kernel.org>; agk@redhat.com; snitzer@kernel.org; linux-
> crypto@vger.kernel.org; dm-devel@redhat.com; linux-
> kernel@vger.kernel.org; qat-linux@intel.com; heinzm@redhat.com; Horia
> Geanta <horia.geanta@nxp.com>; Varun Sethi <V.Sethi@nxp.com>; Pankaj
> Gupta <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>;
> davem@davemloft.net; Iuliana Prodan <iuliana.prodan@nxp.com>; Fiona
> Trahe <fiona.trahe@intel.com>
> Subject: Re: [PATCH 1/3] dm integrity: do not filter algos with
> CRYPTO_ALG_ALLOCATES_MEMORY
>=20
> On Wed, Feb 07, 2024 at 06:22:06AM +0000, Meenakshi Aggarwal wrote:
> >
> > What are your plans for this change?
>=20
> I finally have a solution for you.
>=20
> The answer is to use a software fallback.  As software fallbacks do not n=
eed to
> allocate memory, they can be used in an OOM situation and you fail to
> allocate memory in the driver with GFP_ATOMIC.
>=20
> This can either be done using the existing shash interface through
> SHASH_DESC_ON_STACK, or with my new hash interface where you can use
> HASH_REQUEST_ON_STACK.
>=20
> Once you have implemented this fallback strategy you may remove the
> CRYPTO_ALG_ALLOCATES_MEMORY flag from your driver.
>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.
> apana.org.au%2F~herbert%2F&data=3D05%7C02%7Cmeenakshi.aggarwal%40n
> xp.com%7Cf6d4a8e6289b4a9dc1af08dd4ff783d3%7C686ea1d3bc2b4c6fa92c
> d99c5c301635%7C0%7C0%7C638754646705133902%7CUnknown%7CTWFpb
> GZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zM
> iIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3D%2BfhgGBR
> wm7gYcwhIu5%2FIqM9H%2BypKSqy4zOG0wOwNiOw%3D&reserved=3D0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fgondor=
.
> apana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C02%7Cmeenakshi.agga
> rwal%40nxp.com%7Cf6d4a8e6289b4a9dc1af08dd4ff783d3%7C686ea1d3bc2b
> 4c6fa92cd99c5c301635%7C0%7C0%7C638754646705157205%7CUnknown%7
> CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJ
> XaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3D%2
> BRonzL%2F8MSMEfp2DotM%2FkRx1bIWDStLckhzmH8nVcjc%3D&reserved=3D0
