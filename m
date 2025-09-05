Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013015.outbound.protection.outlook.com [40.107.162.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F6524F;
	Fri,  5 Sep 2025 04:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757048196; cv=fail; b=diBqOY/1cLOof0sUvP++AS+Ap0VbbKqVQCB0TFYtG8P9R/BSd6dclQdfs/dAnY6Tmkd8KV2plmymJHjeEA3RUGijquQyOnZitMARhgZkG0o5jQJ+yAuFuj3svNuFTmd+LIJg/rpcBuDkH9Q+Xdr17lK7ogtpspyQyFFjY/rF5kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757048196; c=relaxed/simple;
	bh=wYFI41/rcqCbZvmj7ROdl9sftbkZEikHmly4GFwf20A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HT+xsM52zDuYhNks7d63v0rX2rC/S5uWzloZ1U1R8mGJ8uBNRHaHgy2DxW71BsxhFLhBjDGaUUCWal97OYvqNc+B1ONza6o+cD/QoAJ0QEm/0egQJQxneFhl36CGbRogeOi25/mS9zC6ctyHMBfL2dQY1dKZThEeyLuzIHr5Glk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=Oxgoa1iJ; arc=fail smtp.client-ip=40.107.162.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="Oxgoa1iJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cEFBZ068/+ma/6Uz+VIs/bqxSPntamwHq9No4TL6riDS9jKvo10cj0W2L0eiQzwJKNloME2b7MQj11owi/66TJgT+BQjbc3pwXqDLtjo649i8BODhKhHdW5yWHeZsuQ+r46EIYjRKRj+Hg9PoyPtw4QtJbl1NXQyJaTdO+XRZSZShKe3Cp3yqy++gXwzatHuxs21TpaIvmU6oD1nw5BUsArH0SVSM6ly6OHstuUl3BEmndc9QDCpR2td1vi+2epTx9TBuwgjKyY+gCAPNVov0Dk7T+KV5D9FzdYAM0Mi0EQMrFl+rQYXlJQ0gZ7d/t2yTjT9IdISqLldzFHbqpzMdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixnu/OkkP+rn3ix1r0szYhyh1z5Tg9p+a5c+zPO5XVk=;
 b=oI5lfhaE3Vi1LlGB5ZGHXIjQue206bu7n1Nzi110SdBmEp3z56rGQm0Tj1wSKTHUkIYN355JNMP6KdSck/vHkz++MZGdh/bep+TjO/6jxf/JPdClUkky/xwrp+e+V/oshVLiz1TqEpSAJ/vfqtwfMLJAOxT2F8SEn+3VCvwnKeECPxJ7w8SuTjyiEFOTe5jChVFnqO5zPK/kDRa+BVjRm6BgZTMrBG3TZvbUeq8+t5sYfqUKEieJAS8JmsrZ5QQYW7Pox/iJdO6Unj3mkt91kIhlioorecJiYiQTrinV8EEijiQiorzarToJNYiGivVT2FeKzN5587oifSurFMlvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixnu/OkkP+rn3ix1r0szYhyh1z5Tg9p+a5c+zPO5XVk=;
 b=Oxgoa1iJhyOvPOIMVn4qblCOaPxXVqa6/+zBCweGlj8yNJKqIHI4Hk2A/FHApo3+9ABagleJSOl3wAuZj3CsgrScxfvfIu1UDAwwBxVQlJORdzm5WgEfHExebi4OIbLYrvy20oCOGmKiBGYmTCZW4odX7ABB0B8Px0wjJhekXFLSaWg+6IJNVkaBbmYu/BOwIeNx1wPfY64UXkQLcYzsJUbhRKXGSoNVh8oLr+0JH5iQMHCuFxyx0lVdaaMSAdu/F37gpkLqiAo7m7HfnbOn0ZD73vcjnhaZ+ZySVxNQdjFugeH8cj1M2lsZu+MhIZMeEr6+g7irshwBtqJpf9vfFA==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS8PR04MB7960.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 04:56:31 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 04:56:30 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Horia Geanta
	<horia.geanta@nxp.com>, Varun Sethi <V.Sethi@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
Subject: RE: [PATCH] drivers: crypto: caam: Add CRYPTO_ALG_NO_FALLBACK
Thread-Topic: [PATCH] drivers: crypto: caam: Add CRYPTO_ALG_NO_FALLBACK
Thread-Index: AQHcHY7HjG6IeFBkBku9X4+2GCN9DbSEB6dg
Date: Fri, 5 Sep 2025 04:56:30 +0000
Message-ID:
 <DB9PR04MB8409E71E337D9DE9F82DB373E703A@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20250904112615.4050572-1-meenakshi.aggarwal@nxp.com>
In-Reply-To: <20250904112615.4050572-1-meenakshi.aggarwal@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS8PR04MB7960:EE_
x-ms-office365-filtering-correlation-id: f0459b84-9acf-49d5-0c7a-08ddec389450
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?zx+oSChFuc/8zGqguP7b95r/avhvzVB1fv4TChGPBzxQAzF/w++X+M0DqsKG?=
 =?us-ascii?Q?9ofzo3s4ETm1v4E5j2CGp6x4WVXlGKgFNGnQYXcUD6vRumi+j9t6PcOrOa/E?=
 =?us-ascii?Q?TXH0B0FTwEqha/rBT0OHlhzAng3VkoO4uKlIhgJcxHTXSQluRO3yJS9ftVlN?=
 =?us-ascii?Q?HN9dezPpA40T4NsbE682ljWsrecfaycFickQp6c4nqR1hac79xVZBfcXq2G3?=
 =?us-ascii?Q?pUN+jmdKIDm/EsFugN1aYlRhnh/Zq4JMBjZRhqOsznjYflXJi0zt1k2RxhXe?=
 =?us-ascii?Q?kE1HZVp0xPRKIshtQ6oQ+kaP3q2tkppcX1QVwbMepheatcyY6zYVo+wLu1u+?=
 =?us-ascii?Q?W8drKrzBx0Re/X1m2qVx4e/GLBqUv4nyjJXu98w6I/MeY0NHmcKR+hhqnYdM?=
 =?us-ascii?Q?8a3RSq0Gmfw/iFItXb4L7o/jLeii8kFP2ALvdm5LbfahESlkqMRAcqS/0shs?=
 =?us-ascii?Q?5tXiV5ZISOsMesa82YG2yS9C5ju+cR4ieGaUhT06h91fkDy7W4MD8K3Icr38?=
 =?us-ascii?Q?6igdRuUTVpOXbpmJnQ9ZU9KFMyxz3sFB8gTA6QOOBK9WpQlujPv4TOeUqE6X?=
 =?us-ascii?Q?VzMv1LQm3Ku2U9J7+j3Os/Pejt3y5jXfA2oOhCijNwu413d4OM1T8hN2N95w?=
 =?us-ascii?Q?/YY3Fi3NYG8mBFqk0TptLGFSJCaHf1u+YveOJFiwIuk63Fo63NuR0+xDX5nP?=
 =?us-ascii?Q?gwy5PPrYu4Y32IOQbwVcRE4tyUXSu9f69DceF+6HTwaJGzpkBeP6we3amVX5?=
 =?us-ascii?Q?OhwMFp16i8rMkckZuy/uCB8U81DWUzpuxJk/TnPHhKxk310Y0MmAzKJ7itRE?=
 =?us-ascii?Q?RQSnN48Ss4YOFJS7GtGjQGW36wH/8XDSgAzKMg6z7QKZk+LLdCvWc9P0oMFd?=
 =?us-ascii?Q?WGxvcKqVrhkIVWd7QGEAKVX8GV5PvFcqymFEtIZ5nGLnQ2Z28EAJ//1ejKz6?=
 =?us-ascii?Q?Oq3vV3VfIxcdBdnYuGQO9MtMPamjdswr0OC3QLtyIqmbbbGh+eJW0QSpNpx/?=
 =?us-ascii?Q?iAmkM8S60vQ/uhWCSqwaHlDj9GufqgCGYU1ciOGHdeZVz6902BUGUYdrZNHZ?=
 =?us-ascii?Q?QJlx+C1U1JDTUDtVlKXqmoiYijrE9KbosnKt9aDCZMz7PJrSNtz6rhoHOniM?=
 =?us-ascii?Q?4DoPegudvVbJ3h9yqu2XkZfN3NxJuvhASSVocHdCdwhO88KKUnhYQ9qtbPAX?=
 =?us-ascii?Q?BkChSPQmW7YDIuXmlgos35rSVGnCfigLD3ODdfW+tSQ/CVM6WV0OtXDcVpJR?=
 =?us-ascii?Q?Tay7adHmnp5jNXf8UTvememUnc0RxlUwO/UdsQElOeQw5PQHJg4jFWvQ8fqZ?=
 =?us-ascii?Q?vY/akOBbN8WB531e5WC+qTEaL6O/lm3FmlB4Hj6JJv1qcdiAlrn+QsiGU0CR?=
 =?us-ascii?Q?glBplbTaLxF3ogwDDUf40LZB0TnEbl3rQAtU1pWby/fsaWMlHmWgzwBrPdQA?=
 =?us-ascii?Q?3JB6gSFnqPfXMcAqFZSLL2eXLF0lklA25v03ZqDAuCNrKmp85IypTA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?DmwPY+ZFQukuGGEu7Wpb3YZzTzpzgSJK+hhP5izvUNvE4HANudX7J5BsBGXr?=
 =?us-ascii?Q?1GiuK1VreQ+vBr1Er/MCl3kVgcy77WAuJRtXCnMhrKCCCH3enrL1mO2fb0+2?=
 =?us-ascii?Q?X1TnX5TWxtnSsivcDIjACIijPrdfLiKRGSS+Vq7bKmc9e3rGG/R86IrUd5HY?=
 =?us-ascii?Q?FqN7qbzHJ/NUsAA8O26BELTzA0c+3tsxPZzr104H1E0DkG1HBlq9V9XyDtiK?=
 =?us-ascii?Q?DneiKRed5LwKYNbNtneiGxFKAscHEN5H8aKDatsIf6smDbiyg0/c8n1608yz?=
 =?us-ascii?Q?bKBxQyCdR5ZoG8Epa2Av/Wy1271pILolTsYubUQYN9uW+OQv73Q99jpV5h7Z?=
 =?us-ascii?Q?3+9qybsIzGKT2JXAWz6ZvRNnXI7mADWhTOuBZivDIpOsGc/ZtbCtBZG6KcE/?=
 =?us-ascii?Q?xjgSJ3izXUEJT38eZU2QcKH0Pi/9FhIMRCkN0cfzKGNqQWH3kSPyZvDd8hM/?=
 =?us-ascii?Q?9kSFif9h/TspxJ0jLc0ugSJtT8P7ZBjSDVqhGt555af/fYMd8tDi58Q+F948?=
 =?us-ascii?Q?GuqI1Jfp3+8GezJNcTQV+gqExeOvT4NnU0kdHp3GXFC19W0xYdAnI8yCGawh?=
 =?us-ascii?Q?MPAMbFZwTY06Zz9ZBAyS1vwe3cnN7RU9Ee0mATUVn+//2tjd1WqvNub2ho4x?=
 =?us-ascii?Q?Qj+POS4yVPwr8Yl2/xm4USjcN6Qea4O4L4UrKgRqDWibAe1aFBFo4dn9fjuq?=
 =?us-ascii?Q?RKJjtUe12yyCUOc9ACFung+k66PHRd8ppKBhCnVeaj3m1VyJRd3NPNkDzEru?=
 =?us-ascii?Q?eVFRrth1eM0IkWlE+tzz3sokUGNrq0yVI6Ej7syke8vkaQaX9Mnl2CZFkHWF?=
 =?us-ascii?Q?NawHi+NM3Pb2KJto+uSbP8jzIwHynM4l5K2foNtN60hoKphzei4PK0wIC3Qj?=
 =?us-ascii?Q?0Z1wqej0eeOmJs53FA5FNiXc+9pAfjXdwnw+bAemKmdalNwev/hC/WcZwhwy?=
 =?us-ascii?Q?+9I6Oa9btKwy1JHDBv4kzksxejFO83QU7225zvDJ16D1TSJvqse/PDBUOiAS?=
 =?us-ascii?Q?LAJvc5v9PzRzEWaDPyrLD5qfvjlBBNLOV/4VRmvbDrjega8rx+HRN9fYeatt?=
 =?us-ascii?Q?kMclIMLfj8QZ84Qg5FcMKDu32/ktKJ/+yfIZ7vak9LgoPR3wzjhxMM4BhmWA?=
 =?us-ascii?Q?mwcmVAJPsiT1+hpqTTX8OlLsRff6qV7TSHOm6YjylwZEiOqWAFMJNwGoWC6S?=
 =?us-ascii?Q?NWQL69s3WhQHEP6wmAhbXJlPdUWuHWlggUAlc51XwdX70CUZ7hT8Oqj6dAyb?=
 =?us-ascii?Q?nUBYPmKPgzfMrRklOPu9wfMXYQBDtwRGWJ/ir0rZ4vWlGORQDlMYaxC4/+pv?=
 =?us-ascii?Q?nr5/apZiEumdtEqRyJ7gtEGe/A3S0NV1yERc8IEbosxwB/iugLkWcloiyi4p?=
 =?us-ascii?Q?OU6DYkIPBYcDU6SzsPpfU+tE8Un4Ine5ZC0RS8nNMApj9XSEZw16TqJyHAOQ?=
 =?us-ascii?Q?xyOfgnyEqpuE+8jSFMe7utyuw6teDeL23k0gw/y94cYLvYwskDe2/UfxTIfT?=
 =?us-ascii?Q?QmPvGD42Adatjesxm9iVKq3OqM46VOErGqWZWHViwDNgiZ5YxcrH6bS2lKjQ?=
 =?us-ascii?Q?z4bU2LV8Zl834q/WsVo=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f0459b84-9acf-49d5-0c7a-08ddec389450
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2025 04:56:30.6644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSTcGz2vOGdvUuYVwGLt8zLgiAKDwUVDA8JJrHHqYxxhTZnstAmJkpZLQa7aMIUSlwiX4oPhShwjg5emABTigw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7960

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>

> -----Original Message-----
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Sent: Thursday, September 4, 2025 4:56 PM
> To: Horia Geanta <horia.geanta@nxp.com>; Varun Sethi <V.Sethi@nxp.com>;
> Pankaj Gupta <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>;
> herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
> Subject: [PATCH] drivers: crypto: caam: Add CRYPTO_ALG_NO_FALLBACK
>=20
> From: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-cdc01.nxp.com>
>=20
> Add CRYPTO_ALG_NO_FALLBACK cra_flag for hash algorithms.
>=20
> Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fal=
lback")
>=20
> Signed-off-by: Meenakshi Aggarwal <nxa07556@lsv05950.swis.nl-
> cdc01.nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c
> index 25c02e267258..90aecefdce01 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -1933,7 +1933,8 @@ caam_hash_alloc(struct caam_hash_template
> *template,
>  	alg->cra_priority =3D CAAM_CRA_PRIORITY;
>  	alg->cra_blocksize =3D template->blocksize;
>  	alg->cra_alignmask =3D 0;
> -	alg->cra_flags =3D CRYPTO_ALG_ASYNC |
> CRYPTO_ALG_ALLOCATES_MEMORY;
> +	alg->cra_flags =3D CRYPTO_ALG_ASYNC |
> CRYPTO_ALG_ALLOCATES_MEMORY |
> +			 CRYPTO_ALG_NO_FALLBACK;
>=20
>  	t_alg->alg_type =3D template->alg_type;
>  	t_alg->ahash_alg.op.do_one_request =3D ahash_do_one_req;
> --
> 2.34.1

