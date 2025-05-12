Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023099.outbound.protection.outlook.com [52.101.127.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10492253335
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 03:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747022206; cv=fail; b=l0poy9OdWUovkWFVdmJ+AANMRiKp/tMAaxgoKZ7P9O34gUyz4WG1bJAAqO+3F/8U81E/3/JacsOOLpg5V9WguPcj31lngEp5Ot/0WLi+I9zvAeJR9RbhTA6q/uGZmYfytQQ/WHpydDNdhWuBMVP+HZyPQtFhuRlX+U2kDIujmMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747022206; c=relaxed/simple;
	bh=LXzhYiFs8oeeqw/AEamZqwQOyEuN7N4sooa6M1bix44=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uJlo0sDQZW/ifCgPuZtSdmVWhvyefDNgkr7VxZPVhSkZ7fcGUZdBYzGQJW8zHCZvSQyMLpzZ5cg+pujJsp+1qmwPgejWEul2RPcQ6SGHuJ76ggdh3ulRt0Vodm0LPf2Za/RoyIzXSwYsoDJu99aoq7EmJ/hD1LaEFnYD0NrWc/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aspeedtech.com; spf=pass smtp.mailfrom=aspeedtech.com; dkim=pass (2048-bit key) header.d=aspeedtech.com header.i=@aspeedtech.com header.b=G/9WVu8x; arc=fail smtp.client-ip=52.101.127.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aspeedtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aspeedtech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aspeedtech.com header.i=@aspeedtech.com header.b="G/9WVu8x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFH/OqYzRP8feZlGiIXdphzUOvcCmFHgIwsv4Jjh1YuJfLkhrhZOGvIsPwR3vjwO927yLa8/LqNAX+rJa1rJpVas23lAGMJohUMnwSlXu3NE1SaASi+Cw9HKodWao1usHlNygfRtyleVmsZllBvzCQqXVBSPy5qEeWGoRlsT5BV5cA7kKIoiaNTqryvnNUssgIkpoFALocXISUnZBlRqMB8mg45BkADLMFzjvVoLEkq9oshjxBzBkuvZLLT9tMNnOc3TwxJX3tYZ5dvW/j0cyZcHgDSFOBoZn4B6EzkOqAusaeiA+CALY8BljVwI/JljI620Yd0kVs2jysDSayJJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLF1biQbgFYhYiSO0orD5MrEfrgMO9t+3j4pfrGHGSs=;
 b=KLv0hULiH5/kna/6o3Ua9D48gM+avGVcRVOhrRKNg5isfJcATxPhd/vFtLj9TMscywmBf3hvzmBNeaHnTU6JRwr0m/HTaD5QTFhd60b5e5fgXxIkz/S2s6D9QyvtZ++nOy3g62SWLLvmlDQhlzHzOCBCxxc9zUpror4XKTPesdpwH9Qac6hh+TNkIUd/tQRTKGyaJRT6TojucIWpJgewevojwdsq9kn1MuklmVRDVLf7czaLvypm9FgdsvjH1uDBrvTS+VZiAhmWVO+L+jWCq6pTDUUIQZ2KgWUhd6LKoJ/fx0i33CWcLi/gQWWEufzmyI3WErGLun5J3LC5xXHp9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLF1biQbgFYhYiSO0orD5MrEfrgMO9t+3j4pfrGHGSs=;
 b=G/9WVu8xL+jcZ96cTFaq+qMS6GuuIoRESFspITKYYdH9JZ3WllyzTaD47M8sAebrrWihJCtvqJH3NyYiAPvUgVeJQ0BiXSYX+VsXwjs+HNM/2sVPcImpSPIRBFjnVgLC2gbIQJM60pVMBKTIxuE5V9+2B8/xajKxeArMBhOeQmVcVidqO1uMQIM5YxiXC3WgD7cgYS4Sde5Q83/krhNY2m1rm19N7Po+LY0SggKNOfozBo375KfPHp4QFjpaLIYXzJgId+IWneqbA3KQmMhslmWfak/Q3FoBLbaSjMdZFVUEEisvrn+RMklG+GoX6UNbqKxiewVydUnZN/NRrG9HEA==
Received: from JH0PR06MB6967.apcprd06.prod.outlook.com (2603:1096:990:6c::6)
 by TYSPR06MB6794.apcprd06.prod.outlook.com (2603:1096:400:471::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Mon, 12 May
 2025 03:56:36 +0000
Received: from JH0PR06MB6967.apcprd06.prod.outlook.com
 ([fe80::8730:2021:6206:d394]) by JH0PR06MB6967.apcprd06.prod.outlook.com
 ([fe80::8730:2021:6206:d394%6]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 03:56:34 +0000
From: Neal Liu <neal_liu@aspeedtech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
CC: Chengyu Lin <chengyu_lin@aspeedtech.com>
Subject: RE: [PATCH] crypto: aspeed/hash - Use API partial block handling
Thread-Topic: [PATCH] crypto: aspeed/hash - Use API partial block handling
Thread-Index: AQHbvmHxa+tgvGyqpESem5Q4kV61BrPOZNeg
Date: Mon, 12 May 2025 03:56:34 +0000
Message-ID:
 <JH0PR06MB69675F76775A8771A358F0208097A@JH0PR06MB6967.apcprd06.prod.outlook.com>
References: <aBnJ-fhTAuuf4Vfa@gondor.apana.org.au>
In-Reply-To: <aBnJ-fhTAuuf4Vfa@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6967:EE_|TYSPR06MB6794:EE_
x-ms-office365-filtering-correlation-id: cf6170f1-51bf-4893-dbff-08dd9108fca4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?AIiaeAmneh6wj6Xkp71oHIYnDxwp8dagjSnu5J6xnFMDsYjU/ePnupmhYxjE?=
 =?us-ascii?Q?5mWeQZv/VCMrPp7T45LRpauWWufUgcAo7gqMsGqgMbCLN0DrtnVG+2mWDgxv?=
 =?us-ascii?Q?bH2L+L4PNuWtYblsH1IEmIkyYwsM+SrLKCnLvNLrTvjFnj0jLxYrLpr+m/J8?=
 =?us-ascii?Q?AcfvYoreYitahTDxO2z/WsMCT/A9CtgBwuU7mu0bPvdMhLCkrqzSJy7OfpMV?=
 =?us-ascii?Q?fzjyUie5MmP1H+ZNfAYksn0K3yj5TGyGTF3+As8mB4dshgf9yroA8Vij8eTm?=
 =?us-ascii?Q?8FD3ZJ++xH1XAbf+SAorVJsu05koCXlBkJjQBMrBpDFdY0eszdR9kAIDXpss?=
 =?us-ascii?Q?FxDQGCr1f0ghRcj5+0xBHr9xN2Ce06iwRjmS/ziPPuIFZkDD0Un8xlA2NM4k?=
 =?us-ascii?Q?u9EkjjghCfU0MEdVXk5B+ywYnoYfiB7xo9r0GrGSqcqQWEmj3Eo1tsKRKlMe?=
 =?us-ascii?Q?wquBk0Mj6p33xhRBbd5FcqHqcNdagjDlGKd+n+SnbnDoBADnvSYfAHBZ3aP6?=
 =?us-ascii?Q?nPKT5Rnq+xJmjZ/KlkypRhyHaUGVqznBjazu7SvRN0kV1TJfcRXTk64ZnmLZ?=
 =?us-ascii?Q?CWE1UmTSFCOZcX4S17Q7qtrqrfBDc5wS8zGWaITZgsvLfhacO/3Jycrf7Zsa?=
 =?us-ascii?Q?p+24UwW6MkQE8BffmvS55EV3lot/bEdn3R3x1+6axw+TCd+5cHWPlt+mnOZd?=
 =?us-ascii?Q?VMESKkCd/NgwY5neHduqywrJbrvv0GAMXTbLWxa/x0WwV4YShzJTRORHuipN?=
 =?us-ascii?Q?T/vVmOSKtEBE8UmSCMt3CQZLlQL6bmnsk5XRjLFTtiIbOR/lI/rNMFOA3bB1?=
 =?us-ascii?Q?k3zEcodGZjC/1EoQKQnxRej+73AnS/tHRtK3Wt6nmNy5Rql2ZfERXHVaOVG9?=
 =?us-ascii?Q?OmUxD+Mqqi0cK0uGuscxNPHoLg7D5D87hKgr29ViUfbkIj82+ECKhp0AXOMS?=
 =?us-ascii?Q?v3sUrvz3LJ1CvP7iSqTTyVADBgUk+i/B2nz7xF5kDmK8aqn9tEeRd9sDRVcn?=
 =?us-ascii?Q?M4ia7uiF+//uqzFE6Q4DibLngh7FQOC5P/YKgGpDgea6ryf+qplKGCjfAi6p?=
 =?us-ascii?Q?l1MsNslNbdfWfk4uUyKhoeOxYKnxUcfc2vFrRIeH7ump5BVIXx4ERUSnhkuf?=
 =?us-ascii?Q?kOmM+d6B5Y5bv3x1s74e7b0YFcEx5UyUrHU8asQhCS23kSfud64LEdOOz2ng?=
 =?us-ascii?Q?RD5X9+rUmFOMwX2eJmiMahhzUO/N/9GOq8iJYjMppB/G78wvbIh9KTtnk3Yo?=
 =?us-ascii?Q?bZxUt+BMHjLrFzRBJ8KKMMZbXyueHBQlmSUwg5M6l7FJYWy1LO0YXkYX06Db?=
 =?us-ascii?Q?FI04mtmWR6dPdOsAkMhDDjPG+7A/K8YONIedYzxWhEGdaaN2P4L5uY5l9A8v?=
 =?us-ascii?Q?wj4r/SkOHuliV8YnndOCp7UZHLRhOz4/AuMERyc8raiCxuet8xKJevH9MP0T?=
 =?us-ascii?Q?ysDT7Y12bwg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:JH0PR06MB6967.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?IFMYKrtQIs6q67HbNsYkgQH4kOWoj5F0kHvhyBzYcVNr1mmhjfgFe7Qo87kt?=
 =?us-ascii?Q?PXCcOQK3Yodkz2m0DYHeDSgbsIVERXAD6jaVdk6O5pkN/KzEnNniuMmgwXTV?=
 =?us-ascii?Q?e9yckuTkjOKBcvCG5kwq8bFICfWV1iTiIC90OVYCixpN8GXwDEVfQmAYW8Gz?=
 =?us-ascii?Q?+z7XG7L+klyOLy55ZUumzk3W7yF0sj3x0SRaSp5VTJvy4JRnJE4tawmlqWO8?=
 =?us-ascii?Q?9sYl2na8z1/ojTcy5tytBAzcW40z/Jr/Og2MIBriQlgvFj50RWIFZA67HHtf?=
 =?us-ascii?Q?u2mTU9bhqkG9KJl0FnW0ONXRZpRsAQIBeKJ4wfrdR9HS7zyteHfArwegTu3m?=
 =?us-ascii?Q?pbTYYx03MUzi6dbDn6kXJQiotTNfRmZdBxMRuLKQsJT1pIzsQn7YEIbwAWdg?=
 =?us-ascii?Q?loDrzwJ1ZVSEAunmIJuoIW8trq9g6zEIk23NAHtY9H/+sk/FLgWo6VhwtYZS?=
 =?us-ascii?Q?pSbIRwYeowvXmu9Iya25LGzewobD2iwgx+nJMV+GBXou108ViAl1cxxZCX8U?=
 =?us-ascii?Q?Uxu0tbchT4W+6sselimIkBHXqgNIYuo7E4g/NF6jMOEG3An2iBcTb/AWdOic?=
 =?us-ascii?Q?o4rQBrSqYPKteRXxgyEuyzBTkudiMd9W2rw0O5O2wGVC0x9yltTb32Ldot9V?=
 =?us-ascii?Q?vFmpqN2uZWey0tBPZoLQDZ/qde37l0tXLgkMd+jeNoYQjnyvOGdbeB1jD5sE?=
 =?us-ascii?Q?6Yw6FVyQmvo7MXvoHhfaxhRETsuHRT9ICDvgWI/BJaPrBPSRRTEyAEUH64+1?=
 =?us-ascii?Q?aF+o2tUxsmQzlpcqN5NAJFsY8fRT6C360Y6E+Kf7aIgpdfO4i+NYcI2EWoh5?=
 =?us-ascii?Q?ZNyhC1W0x0Bf1cX8ZBGwsDmCRFz+G/Tff8N6iqjbPM2eoRYTLYJo7jw4priK?=
 =?us-ascii?Q?g8QAjLVOWjrgbff2AcnV/R5Z67hGzLtEafpvYyqHvb3PupZBaIqaUYQ87vxy?=
 =?us-ascii?Q?J/6R0WGgp8chB6TQ8uVE+wJ+pmo9kHImI1iiec8Mj0zewL45+PCTl6o0UXz9?=
 =?us-ascii?Q?RnA8wbTFyEDmmn+EuMYGOHPUwmC/DMMVsAmrHcPrVdd4L7l73/xCKc7wEq+u?=
 =?us-ascii?Q?NppZ1McKhd54iPhm9TXy43dWS1sWOhqyIq64B1YmEBA5sc9JGATCiHBivudP?=
 =?us-ascii?Q?zagYJiLbSxvOQNFKWweQdM3gHCA3iDvhzIQ2Z0eA1MBlcLH44YykAlVVcojF?=
 =?us-ascii?Q?Oqn7rlxtAiwL22Acc0RpOo9/BQlQy7t886bSBWkUdBHcIgLVlIX5FAGzyCbe?=
 =?us-ascii?Q?B3tnipVT3Ge/wz9OhcVGGCuJd8iMwYLzahjkmuNR12lLcnm4zCDeVUxwhxIF?=
 =?us-ascii?Q?ws6CrBGtFHHWzM8C2VXk+XyT0NT70ivNaJ2bEPO9N5wMBjVVx2/Ncj+es+iK?=
 =?us-ascii?Q?hgqN7MXGp/BIiY3+tHbHi4PTWT9yQJ6YiYNVVSafoTYOX0NPvcSfAel94AgF?=
 =?us-ascii?Q?CAcyYPKLoxJsw5LkcIDbVO3L812MDsa/0+MQEAYkmEAK47u/MNJ43I3eISUc?=
 =?us-ascii?Q?fZaYsI97MMY4MZktngYW0PmK1qV1vdv1FUIBx9hJ3/+I3eS0MYj0c+tVqsil?=
 =?us-ascii?Q?ezB4MQGjS9uyUgBdcOiky90f3+E9otni/63ln9Qy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: JH0PR06MB6967.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6170f1-51bf-4893-dbff-08dd9108fca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 03:56:34.0710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CupcKI/TOifCkBhI9Ixqc+5Ynqu6680L889TY1Y99zeb8Rub3U9zzeTa8tf3jjzzBDj2jQfrRHIJvNxowWCl3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6794

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, May 6, 2025 4:36 PM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; Neal Liu
> <neal_liu@aspeedtech.com>
> Subject: [PATCH] crypto: aspeed/hash - Use API partial block handling
>=20
> This patch is based on
>=20
> 	https://patchwork.kernel.org/project/linux-crypto/list/?series=3D959772
>=20
> ---8<---
> Use the Crypto API partial block handling.
>=20
> Also switch to the generic export format.
>=20
> Remove purely software hmac implementation.

The hmac implementation is not purely software-based.
The hash part is accelerated by hardware, the other parts are implemented b=
y software.
In addition, this patch introduce multiple changes that serves different pu=
rpose.
For better clarity and discussion, could you please split the patch into se=
parate submissions, each addressing a specific functionality?
Thanks.

>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/aspeed/aspeed-hace-hash.c | 805 ++++++-----------------
>  drivers/crypto/aspeed/aspeed-hace.h      |  46 +-
>  2 files changed, 220 insertions(+), 631 deletions(-)
>=20
> diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c
> b/drivers/crypto/aspeed/aspeed-hace-hash.c
> index 0b6e49c06eff..1409ecfa8c9a 100644
> --- a/drivers/crypto/aspeed/aspeed-hace-hash.c
> +++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
> @@ -5,7 +5,6 @@
>=20
>  #include "aspeed-hace.h"
>  #include <crypto/engine.h>
> -#include <crypto/hmac.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/sha1.h>
> @@ -14,6 +13,7 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> +#include <linux/scatterlist.h>
>  #include <linux/string.h>
>=20
>  #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
> @@ -59,6 +59,46 @@ static const __be64 sha512_iv[8] =3D {
>  	cpu_to_be64(SHA512_H6), cpu_to_be64(SHA512_H7)  };
>=20
> +static int aspeed_sham_init(struct ahash_request *req); static int
> +aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev);
> +
> +static int aspeed_sham_export(struct ahash_request *req, void *out) {
> +	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> +	union {
> +		u8 *u8;
> +		u64 *u64;
> +	} p =3D { .u8 =3D out };
> +
> +	memcpy(out, rctx->digest, rctx->ivsize);
> +	p.u8 +=3D rctx->ivsize;
> +	put_unaligned(rctx->digcnt[0], p.u64++);
> +	if (rctx->ivsize =3D=3D 64)
> +		put_unaligned(rctx->digcnt[1], p.u64);
> +	return 0;
> +}
> +
> +static int aspeed_sham_import(struct ahash_request *req, const void
> +*in) {
> +	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> +	union {
> +		const u8 *u8;
> +		const u64 *u64;
> +	} p =3D { .u8 =3D in };
> +	int err;
> +
> +	err =3D aspeed_sham_init(req);
> +	if (err)
> +		return err;
> +
> +	memcpy(rctx->digest, in, rctx->ivsize);
> +	p.u8 +=3D rctx->ivsize;
> +	rctx->digcnt[0] =3D get_unaligned(p.u64++);
> +	if (rctx->ivsize =3D=3D 64)
> +		rctx->digcnt[1] =3D get_unaligned(p.u64);
> +	return 0;
> +}
> +
>  /* The purpose of this padding is to ensure that the padded message is a
>   * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits
> (SHA384/SHA512).
>   * The bit "1" is appended at the end of the message followed by @@ -74,=
9
> +114,11 @@ static const __be64 sha512_iv[8] =3D {
>   *  - if message length < 112 bytes then padlen =3D 112 - message length
>   *  - else padlen =3D 128 + 112 - message length
>   */
> -static void aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev,
> -				      struct aspeed_sham_reqctx *rctx)
> +static int aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev,
> +u8 *buf)
>  {
> +	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> +	struct ahash_request *req =3D hash_engine->req;
> +	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
>  	unsigned int index, padlen;
>  	__be64 bits[2];
>=20
> @@ -87,24 +129,22 @@ static void aspeed_ahash_fill_padding(struct
> aspeed_hace_dev *hace_dev,
>  	case SHA_FLAGS_SHA224:
>  	case SHA_FLAGS_SHA256:
>  		bits[0] =3D cpu_to_be64(rctx->digcnt[0] << 3);
> -		index =3D rctx->bufcnt & 0x3f;
> +		index =3D rctx->digcnt[0] & 0x3f;
>  		padlen =3D (index < 56) ? (56 - index) : ((64 + 56) - index);
> -		*(rctx->buffer + rctx->bufcnt) =3D 0x80;
> -		memset(rctx->buffer + rctx->bufcnt + 1, 0, padlen - 1);
> -		memcpy(rctx->buffer + rctx->bufcnt + padlen, bits, 8);
> -		rctx->bufcnt +=3D padlen + 8;
> -		break;
> +		buf[0] =3D 0x80;
> +		memset(buf + 1, 0, padlen - 1);
> +		memcpy(buf + padlen, bits, 8);
> +		return padlen + 8;
>  	default:
>  		bits[1] =3D cpu_to_be64(rctx->digcnt[0] << 3);
>  		bits[0] =3D cpu_to_be64(rctx->digcnt[1] << 3 |
>  				      rctx->digcnt[0] >> 61);
> -		index =3D rctx->bufcnt & 0x7f;
> +		index =3D rctx->digcnt[0] & 0x7f;
>  		padlen =3D (index < 112) ? (112 - index) : ((128 + 112) - index);
> -		*(rctx->buffer + rctx->bufcnt) =3D 0x80;
> -		memset(rctx->buffer + rctx->bufcnt + 1, 0, padlen - 1);
> -		memcpy(rctx->buffer + rctx->bufcnt + padlen, bits, 16);
> -		rctx->bufcnt +=3D padlen + 16;
> -		break;
> +		buf[0] =3D 0x80;
> +		memset(buf + 1, 0, padlen - 1);
> +		memcpy(buf + padlen, bits, 16);
> +		return padlen + 16;
>  	}
>  }
>=20
> @@ -117,31 +157,29 @@ static int aspeed_ahash_dma_prepare(struct
> aspeed_hace_dev *hace_dev)
>  	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
>  	struct ahash_request *req =3D hash_engine->req;
>  	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -	int length, remain;
> +	unsigned int length, remain;
> +	bool final =3D false;
>=20
> -	length =3D rctx->total + rctx->bufcnt;
> -	remain =3D length % rctx->block_size;
> +	length =3D rctx->total - rctx->offset;
> +	remain =3D length - round_down(length, rctx->block_size);
>=20
>  	AHASH_DBG(hace_dev, "length:0x%x, remain:0x%x\n", length, remain);
>=20
> -	if (rctx->bufcnt)
> -		memcpy(hash_engine->ahash_src_addr, rctx->buffer, rctx->bufcnt);
> +	if (length > ASPEED_HASH_SRC_DMA_BUF_LEN)
> +		length =3D ASPEED_HASH_SRC_DMA_BUF_LEN;
> +	else if (rctx->flags & SHA_FLAGS_FINUP) {
> +		unsigned int total;
>=20
> -	if (rctx->total + rctx->bufcnt < ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
> -		scatterwalk_map_and_copy(hash_engine->ahash_src_addr +
> -					 rctx->bufcnt, rctx->src_sg,
> -					 rctx->offset, rctx->total - remain, 0);
> -		rctx->offset +=3D rctx->total - remain;
> +		total =3D round_up(length, rctx->block_size) + rctx->block_size;
> +		if (total > ASPEED_HASH_SRC_DMA_BUF_LEN)
> +			length -=3D rctx->block_size - remain;
> +		else
> +			final =3D true;
> +	} else
> +		length -=3D remain;
> +	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
> +				 rctx->offset, length, 0);
>=20
> -	} else {
> -		dev_warn(hace_dev->dev, "Hash data length is too large\n");
> -		return -EINVAL;
> -	}
> -
> -	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg,
> -				 rctx->offset, remain, 0);
> -
> -	rctx->bufcnt =3D remain;
>  	rctx->digest_dma_addr =3D dma_map_single(hace_dev->dev, rctx->digest,
>  					       SHA512_DIGEST_SIZE,
>  					       DMA_BIDIRECTIONAL);
> @@ -150,7 +188,15 @@ static int aspeed_ahash_dma_prepare(struct
> aspeed_hace_dev *hace_dev)
>  		return -ENOMEM;
>  	}
>=20
> -	hash_engine->src_length =3D length - remain;
> +	rctx->digcnt[0] +=3D length;
> +	if (rctx->digcnt[0] < length)
> +		rctx->digcnt[1]++;
> +	rctx->offset +=3D length;
> +
> +	if (final)
> +		length +=3D aspeed_ahash_fill_padding(
> +			hace_dev, hash_engine->ahash_src_addr + length);
> +	hash_engine->src_length =3D length;
>  	hash_engine->src_dma =3D hash_engine->ahash_src_dma_addr;
>  	hash_engine->digest_dma =3D rctx->digest_dma_addr;
>=20
> @@ -166,18 +212,22 @@ static int aspeed_ahash_dma_prepare_sg(struct
> aspeed_hace_dev *hace_dev)
>  	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
>  	struct ahash_request *req =3D hash_engine->req;
>  	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> +	int remain, sg_len, i, max_sg_nents;
>  	struct aspeed_sg_list *src_list;
> +	unsigned int length, total;
>  	struct scatterlist *s;
> -	int length, remain, sg_len, i;
> +	bool final =3D false;
>  	int rc =3D 0;
>=20
> -	remain =3D (rctx->total + rctx->bufcnt) % rctx->block_size;
> -	length =3D rctx->total + rctx->bufcnt - remain;
> +	length =3D rctx->total - rctx->offset;
>=20
> -	AHASH_DBG(hace_dev, "%s:0x%x, %s:%zu, %s:0x%x, %s:0x%x\n",
> -		  "rctx total", rctx->total, "bufcnt", rctx->bufcnt,
> -		  "length", length, "remain", remain);
> +	AHASH_DBG(hace_dev, "%s:0x%x, %s:0x%x\n",
> +		  "rctx total", rctx->total,
> +		  "length", length);
>=20
> +	max_sg_nents =3D ASPEED_HASH_SRC_DMA_BUF_LEN / sizeof(*src_list) -
> 1;
> +	rctx->src_sg =3D rctx->next_sg;
> +	rctx->src_nents =3D min(sg_nents(rctx->src_sg), max_sg_nents);
>  	sg_len =3D dma_map_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
>  			    DMA_TO_DEVICE);
>  	if (!sg_len) {
> @@ -196,10 +246,53 @@ static int aspeed_ahash_dma_prepare_sg(struct
> aspeed_hace_dev *hace_dev)
>  		goto free_src_sg;
>  	}
>=20
> -	if (rctx->bufcnt !=3D 0) {
> -		u32 phy_addr;
> -		u32 len;
> +	total =3D 0;
> +	for_each_sg(rctx->src_sg, s, sg_len, i) {
> +		u32 phy_addr =3D sg_dma_address(s);
> +		u32 len =3D sg_dma_len(s);
>=20
> +		if (length > len) {
> +			length -=3D len;
> +			total +=3D len;
> +		} else {
> +			/* Last sg list */
> +			len =3D length;
> +			total +=3D len;
> +			length =3D 0;
> +		}
> +
> +		src_list[i].phy_addr =3D cpu_to_le32(phy_addr);
> +		src_list[i].len =3D cpu_to_le32(len);
> +
> +		if (!length)
> +			break;
> +	}
> +
> +	remain =3D total - round_down(total, rctx->block_size);
> +	total -=3D remain;
> +
> +	if (length)
> +		i =3D sg_len - 1;
> +	length +=3D remain;
> +
> +	if (!(rctx->flags & SHA_FLAGS_FINUP) || length >=3D rctx->block_size)
> +		src_list[i].len |=3D cpu_to_le32(HASH_SG_LAST_LIST);
> +	else {
> +		memcpy_from_sglist(rctx->buffer, rctx->src_sg, total, length);
> +		total +=3D length;
> +		final =3D true;
> +	}
> +
> +	rctx->next_sg =3D sg_next(s);
> +	rctx->digcnt[0] +=3D total;
> +	if (rctx->digcnt[0] < total)
> +		rctx->digcnt[1]++;
> +	rctx->offset +=3D total;
> +
> +	if (final) {
> +		int len =3D aspeed_ahash_fill_padding(hace_dev, rctx->buffer);
> +
> +		total +=3D len;
>  		rctx->buffer_dma_addr =3D dma_map_single(hace_dev->dev,
>  						       rctx->buffer,
>  						       rctx->block_size * 2,
> @@ -210,54 +303,17 @@ static int aspeed_ahash_dma_prepare_sg(struct
> aspeed_hace_dev *hace_dev)
>  			goto free_rctx_digest;
>  		}
>=20
> -		phy_addr =3D rctx->buffer_dma_addr;
> -		len =3D rctx->bufcnt;
> -		length -=3D len;
> -
> -		/* Last sg list */
> -		if (length =3D=3D 0)
> -			len |=3D HASH_SG_LAST_LIST;
> -
> -		src_list[0].phy_addr =3D cpu_to_le32(phy_addr);
> -		src_list[0].len =3D cpu_to_le32(len);
> -		src_list++;
> +		i++;
> +		src_list[i].phy_addr =3D cpu_to_le32(rctx->buffer_dma_addr);
> +		src_list[i].len =3D cpu_to_le32(len);
>  	}
>=20
> -	if (length !=3D 0) {
> -		for_each_sg(rctx->src_sg, s, sg_len, i) {
> -			u32 phy_addr =3D sg_dma_address(s);
> -			u32 len =3D sg_dma_len(s);
> -
> -			if (length > len)
> -				length -=3D len;
> -			else {
> -				/* Last sg list */
> -				len =3D length;
> -				len |=3D HASH_SG_LAST_LIST;
> -				length =3D 0;
> -			}
> -
> -			src_list[i].phy_addr =3D cpu_to_le32(phy_addr);
> -			src_list[i].len =3D cpu_to_le32(len);
> -		}
> -	}
> -
> -	if (length !=3D 0) {
> -		rc =3D -EINVAL;
> -		goto free_rctx_buffer;
> -	}
> -
> -	rctx->offset =3D rctx->total - remain;
> -	hash_engine->src_length =3D rctx->total + rctx->bufcnt - remain;
> +	hash_engine->src_length =3D total;
>  	hash_engine->src_dma =3D hash_engine->ahash_src_dma_addr;
>  	hash_engine->digest_dma =3D rctx->digest_dma_addr;
>=20
>  	return 0;
>=20
> -free_rctx_buffer:
> -	if (rctx->bufcnt !=3D 0)
> -		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
> -				 rctx->block_size * 2, DMA_TO_DEVICE);
>  free_rctx_digest:
>  	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
>  			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL); @@ -272,37
> +328,28 @@ static int aspeed_ahash_complete(struct aspeed_hace_dev
> *hace_dev)  {
>  	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
>  	struct ahash_request *req =3D hash_engine->req;
> +	struct aspeed_sham_reqctx *rctx;
>=20
>  	AHASH_DBG(hace_dev, "\n");
>=20
> -	hash_engine->flags &=3D ~CRYPTO_FLAGS_BUSY;
> -
> -	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req, 0);
> -
> -	return 0;
> -}
> -
> -/*
> - * Copy digest to the corresponding request result.
> - * This function will be called at final() stage.
> - */
> -static int aspeed_ahash_transfer(struct aspeed_hace_dev *hace_dev) -{
> -	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> -	struct ahash_request *req =3D hash_engine->req;
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -
> -	AHASH_DBG(hace_dev, "\n");
> -
> +	rctx =3D ahash_request_ctx(req);
>  	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
>  			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
>=20
> -	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
> -			 rctx->block_size * 2, DMA_TO_DEVICE);
> +	if (rctx->total - rctx->offset >=3D rctx->block_size ||
> +	    (rctx->total !=3D rctx->offset && rctx->flags & SHA_FLAGS_FINUP))
> +		return aspeed_ahash_req_update(hace_dev);
>=20
> -	memcpy(req->result, rctx->digest, rctx->digsize);
> +	hash_engine->flags &=3D ~CRYPTO_FLAGS_BUSY;
>=20
> -	return aspeed_ahash_complete(hace_dev);
> +	if (rctx->flags & SHA_FLAGS_FINUP)
> +		memcpy(req->result, rctx->digest, rctx->digsize);
> +
> +	rctx =3D ahash_request_ctx(req);
> +	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req,
> +				     rctx->total - rctx->offset);
> +
> +	return 0;
>  }
>=20
>  /*
> @@ -338,118 +385,6 @@ static int aspeed_hace_ahash_trigger(struct
> aspeed_hace_dev *hace_dev,
>  	return -EINPROGRESS;
>  }
>=20
> -/*
> - * HMAC resume aims to do the second pass produces
> - * the final HMAC code derived from the inner hash
> - * result and the outer key.
> - */
> -static int aspeed_ahash_hmac_resume(struct aspeed_hace_dev *hace_dev) -{
> -	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> -	struct ahash_request *req =3D hash_engine->req;
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> -	struct aspeed_sham_ctx *tctx =3D crypto_ahash_ctx(tfm);
> -	struct aspeed_sha_hmac_ctx *bctx =3D tctx->base;
> -	int rc =3D 0;
> -
> -	AHASH_DBG(hace_dev, "\n");
> -
> -	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
> -			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
> -
> -	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
> -			 rctx->block_size * 2, DMA_TO_DEVICE);
> -
> -	/* o key pad + hash sum 1 */
> -	memcpy(rctx->buffer, bctx->opad, rctx->block_size);
> -	memcpy(rctx->buffer + rctx->block_size, rctx->digest, rctx->digsize);
> -
> -	rctx->bufcnt =3D rctx->block_size + rctx->digsize;
> -	rctx->digcnt[0] =3D rctx->block_size + rctx->digsize;
> -
> -	aspeed_ahash_fill_padding(hace_dev, rctx);
> -	memcpy(rctx->digest, rctx->sha_iv, rctx->ivsize);
> -
> -	rctx->digest_dma_addr =3D dma_map_single(hace_dev->dev, rctx->digest,
> -					       SHA512_DIGEST_SIZE,
> -					       DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
> -		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
> -		rc =3D -ENOMEM;
> -		goto end;
> -	}
> -
> -	rctx->buffer_dma_addr =3D dma_map_single(hace_dev->dev, rctx->buffer,
> -					       rctx->block_size * 2,
> -					       DMA_TO_DEVICE);
> -	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
> -		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
> -		rc =3D -ENOMEM;
> -		goto free_rctx_digest;
> -	}
> -
> -	hash_engine->src_dma =3D rctx->buffer_dma_addr;
> -	hash_engine->src_length =3D rctx->bufcnt;
> -	hash_engine->digest_dma =3D rctx->digest_dma_addr;
> -
> -	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
> -
> -free_rctx_digest:
> -	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
> -			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
> -end:
> -	return rc;
> -}
> -
> -static int aspeed_ahash_req_final(struct aspeed_hace_dev *hace_dev) -{
> -	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> -	struct ahash_request *req =3D hash_engine->req;
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -	int rc =3D 0;
> -
> -	AHASH_DBG(hace_dev, "\n");
> -
> -	aspeed_ahash_fill_padding(hace_dev, rctx);
> -
> -	rctx->digest_dma_addr =3D dma_map_single(hace_dev->dev,
> -					       rctx->digest,
> -					       SHA512_DIGEST_SIZE,
> -					       DMA_BIDIRECTIONAL);
> -	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
> -		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
> -		rc =3D -ENOMEM;
> -		goto end;
> -	}
> -
> -	rctx->buffer_dma_addr =3D dma_map_single(hace_dev->dev,
> -					       rctx->buffer,
> -					       rctx->block_size * 2,
> -					       DMA_TO_DEVICE);
> -	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
> -		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
> -		rc =3D -ENOMEM;
> -		goto free_rctx_digest;
> -	}
> -
> -	hash_engine->src_dma =3D rctx->buffer_dma_addr;
> -	hash_engine->src_length =3D rctx->bufcnt;
> -	hash_engine->digest_dma =3D rctx->digest_dma_addr;
> -
> -	if (rctx->flags & SHA_FLAGS_HMAC)
> -		return aspeed_hace_ahash_trigger(hace_dev,
> -						 aspeed_ahash_hmac_resume);
> -
> -	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
> -
> -free_rctx_digest:
> -	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
> -			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
> -end:
> -	return rc;
> -}
> -
>  static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev
> *hace_dev)  {
>  	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> @@ -461,40 +396,12 @@ static int aspeed_ahash_update_resume_sg(struct
> aspeed_hace_dev *hace_dev)
>  	dma_unmap_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
>  		     DMA_TO_DEVICE);
>=20
> -	if (rctx->bufcnt !=3D 0)
> +	if (rctx->flags & SHA_FLAGS_FINUP && rctx->total =3D=3D rctx->offset)
>  		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
> -				 rctx->block_size * 2,
> -				 DMA_TO_DEVICE);
> +				 rctx->block_size * 2, DMA_TO_DEVICE);
>=20
> -	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
> -			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
> -
> -	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg, rctx->offset,
> -				 rctx->total - rctx->offset, 0);
> -
> -	rctx->bufcnt =3D rctx->total - rctx->offset;
>  	rctx->cmd &=3D ~HASH_CMD_HASH_SRC_SG_CTRL;
>=20
> -	if (rctx->flags & SHA_FLAGS_FINUP)
> -		return aspeed_ahash_req_final(hace_dev);
> -
> -	return aspeed_ahash_complete(hace_dev);
> -}
> -
> -static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
> -{
> -	struct aspeed_engine_hash *hash_engine =3D &hace_dev->hash_engine;
> -	struct ahash_request *req =3D hash_engine->req;
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -
> -	AHASH_DBG(hace_dev, "\n");
> -
> -	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
> -			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
> -
> -	if (rctx->flags & SHA_FLAGS_FINUP)
> -		return aspeed_ahash_req_final(hace_dev);
> -
>  	return aspeed_ahash_complete(hace_dev);  }
>=20
> @@ -513,7 +420,7 @@ static int aspeed_ahash_req_update(struct
> aspeed_hace_dev *hace_dev)
>  		resume =3D aspeed_ahash_update_resume_sg;
>=20
>  	} else {
> -		resume =3D aspeed_ahash_update_resume;
> +		resume =3D aspeed_ahash_complete;
>  	}
>=20
>  	ret =3D hash_engine->dma_prepare(hace_dev);
> @@ -543,13 +450,32 @@ static int aspeed_ahash_do_request(struct
> crypto_engine *engine, void *areq)
>  	hash_engine =3D &hace_dev->hash_engine;
>  	hash_engine->flags |=3D CRYPTO_FLAGS_BUSY;
>=20
> -	if (rctx->op =3D=3D SHA_OP_UPDATE)
> -		ret =3D aspeed_ahash_req_update(hace_dev);
> -	else if (rctx->op =3D=3D SHA_OP_FINAL)
> -		ret =3D aspeed_ahash_req_final(hace_dev);
> +	ret =3D aspeed_ahash_req_update(hace_dev);
>=20
> -	if (ret !=3D -EINPROGRESS)
> +	if (ret && ret !=3D -EINPROGRESS) {
> +		HASH_FBREQ_ON_STACK(fbreq, areq);
> +		u8 state[SHA512_STATE_SIZE];
> +		struct scatterlist sg[2];
> +		struct scatterlist *ssg;
> +
> +		ssg =3D scatterwalk_ffwd(sg, req->src, rctx->offset);
> +		ahash_request_set_crypt(fbreq, ssg, req->result,
> +					rctx->total - rctx->offset);
> +
> +		ret =3D aspeed_sham_export(req, state) ?:
> +		      crypto_ahash_import_core(fbreq, state);
> +
> +		if (rctx->flags & SHA_FLAGS_FINUP) {
> +			ret =3D ret ?: crypto_ahash_finup(fbreq);
> +			goto out_zero_state;
> +		}
> +		ret =3D ret ?: crypto_ahash_update(fbreq);
> +			     crypto_ahash_export_core(fbreq, state) ?:
> +			     aspeed_sham_import(req, state);
> +out_zero_state:
> +		memzero_explicit(state, sizeof(state));
>  		return ret;
> +	}
>=20
>  	return 0;
>  }
> @@ -588,47 +514,8 @@ static int aspeed_sham_update(struct ahash_request
> *req)
>  	AHASH_DBG(hace_dev, "req->nbytes: %d\n", req->nbytes);
>=20
>  	rctx->total =3D req->nbytes;
> -	rctx->src_sg =3D req->src;
> +	rctx->next_sg =3D req->src;
>  	rctx->offset =3D 0;
> -	rctx->src_nents =3D sg_nents(req->src);
> -	rctx->op =3D SHA_OP_UPDATE;
> -
> -	rctx->digcnt[0] +=3D rctx->total;
> -	if (rctx->digcnt[0] < rctx->total)
> -		rctx->digcnt[1]++;
> -
> -	if (rctx->bufcnt + rctx->total < rctx->block_size) {
> -		scatterwalk_map_and_copy(rctx->buffer + rctx->bufcnt,
> -					 rctx->src_sg, rctx->offset,
> -					 rctx->total, 0);
> -		rctx->bufcnt +=3D rctx->total;
> -
> -		return 0;
> -	}
> -
> -	return aspeed_hace_hash_handle_queue(hace_dev, req);
> -}
> -
> -static int aspeed_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
> -				    const u8 *data, unsigned int len, u8 *out)
> -{
> -	SHASH_DESC_ON_STACK(shash, tfm);
> -
> -	shash->tfm =3D tfm;
> -
> -	return crypto_shash_digest(shash, data, len, out);
> -}
> -
> -static int aspeed_sham_final(struct ahash_request *req) -{
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> -	struct aspeed_sham_ctx *tctx =3D crypto_ahash_ctx(tfm);
> -	struct aspeed_hace_dev *hace_dev =3D tctx->hace_dev;
> -
> -	AHASH_DBG(hace_dev, "req->nbytes:%d, rctx->total:%d\n",
> -		  req->nbytes, rctx->total);
> -	rctx->op =3D SHA_OP_FINAL;
>=20
>  	return aspeed_hace_hash_handle_queue(hace_dev, req);  } @@ -639,23
> +526,11 @@ static int aspeed_sham_finup(struct ahash_request *req)
>  	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>  	struct aspeed_sham_ctx *tctx =3D crypto_ahash_ctx(tfm);
>  	struct aspeed_hace_dev *hace_dev =3D tctx->hace_dev;
> -	int rc1, rc2;
>=20
>  	AHASH_DBG(hace_dev, "req->nbytes: %d\n", req->nbytes);
>=20
>  	rctx->flags |=3D SHA_FLAGS_FINUP;
> -
> -	rc1 =3D aspeed_sham_update(req);
> -	if (rc1 =3D=3D -EINPROGRESS || rc1 =3D=3D -EBUSY)
> -		return rc1;
> -
> -	/*
> -	 * final() has to be always called to cleanup resources
> -	 * even if update() failed, except EINPROGRESS
> -	 */
> -	rc2 =3D aspeed_sham_final(req);
> -
> -	return rc1 ? : rc2;
> +	return aspeed_sham_update(req);
>  }
>=20
>  static int aspeed_sham_init(struct ahash_request *req) @@ -664,7 +539,6
> @@ static int aspeed_sham_init(struct ahash_request *req)
>  	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>  	struct aspeed_sham_ctx *tctx =3D crypto_ahash_ctx(tfm);
>  	struct aspeed_hace_dev *hace_dev =3D tctx->hace_dev;
> -	struct aspeed_sha_hmac_ctx *bctx =3D tctx->base;
>=20
>  	AHASH_DBG(hace_dev, "%s: digest size:%d\n",
>  		  crypto_tfm_alg_name(&tfm->base),
> @@ -679,7 +553,6 @@ static int aspeed_sham_init(struct ahash_request *req=
)
>  		rctx->flags |=3D SHA_FLAGS_SHA1;
>  		rctx->digsize =3D SHA1_DIGEST_SIZE;
>  		rctx->block_size =3D SHA1_BLOCK_SIZE;
> -		rctx->sha_iv =3D sha1_iv;
>  		rctx->ivsize =3D 32;
>  		memcpy(rctx->digest, sha1_iv, rctx->ivsize);
>  		break;
> @@ -688,7 +561,6 @@ static int aspeed_sham_init(struct ahash_request *req=
)
>  		rctx->flags |=3D SHA_FLAGS_SHA224;
>  		rctx->digsize =3D SHA224_DIGEST_SIZE;
>  		rctx->block_size =3D SHA224_BLOCK_SIZE;
> -		rctx->sha_iv =3D sha224_iv;
>  		rctx->ivsize =3D 32;
>  		memcpy(rctx->digest, sha224_iv, rctx->ivsize);
>  		break;
> @@ -697,7 +569,6 @@ static int aspeed_sham_init(struct ahash_request *req=
)
>  		rctx->flags |=3D SHA_FLAGS_SHA256;
>  		rctx->digsize =3D SHA256_DIGEST_SIZE;
>  		rctx->block_size =3D SHA256_BLOCK_SIZE;
> -		rctx->sha_iv =3D sha256_iv;
>  		rctx->ivsize =3D 32;
>  		memcpy(rctx->digest, sha256_iv, rctx->ivsize);
>  		break;
> @@ -707,7 +578,6 @@ static int aspeed_sham_init(struct ahash_request *req=
)
>  		rctx->flags |=3D SHA_FLAGS_SHA384;
>  		rctx->digsize =3D SHA384_DIGEST_SIZE;
>  		rctx->block_size =3D SHA384_BLOCK_SIZE;
> -		rctx->sha_iv =3D (const __be32 *)sha384_iv;
>  		rctx->ivsize =3D 64;
>  		memcpy(rctx->digest, sha384_iv, rctx->ivsize);
>  		break;
> @@ -717,7 +587,6 @@ static int aspeed_sham_init(struct ahash_request *req=
)
>  		rctx->flags |=3D SHA_FLAGS_SHA512;
>  		rctx->digsize =3D SHA512_DIGEST_SIZE;
>  		rctx->block_size =3D SHA512_BLOCK_SIZE;
> -		rctx->sha_iv =3D (const __be32 *)sha512_iv;
>  		rctx->ivsize =3D 64;
>  		memcpy(rctx->digest, sha512_iv, rctx->ivsize);
>  		break;
> @@ -727,19 +596,10 @@ static int aspeed_sham_init(struct ahash_request
> *req)
>  		return -EINVAL;
>  	}
>=20
> -	rctx->bufcnt =3D 0;
>  	rctx->total =3D 0;
>  	rctx->digcnt[0] =3D 0;
>  	rctx->digcnt[1] =3D 0;
>=20
> -	/* HMAC init */
> -	if (tctx->flags & SHA_FLAGS_HMAC) {
> -		rctx->digcnt[0] =3D rctx->block_size;
> -		rctx->bufcnt =3D rctx->block_size;
> -		memcpy(rctx->buffer, bctx->ipad, rctx->block_size);
> -		rctx->flags |=3D SHA_FLAGS_HMAC;
> -	}
> -
>  	return 0;
>  }
>=20
> @@ -748,102 +608,14 @@ static int aspeed_sham_digest(struct
> ahash_request *req)
>  	return aspeed_sham_init(req) ? : aspeed_sham_finup(req);  }
>=20
> -static int aspeed_sham_setkey(struct crypto_ahash *tfm, const u8 *key,
> -			      unsigned int keylen)
> +static int aspeed_sham_cra_init(struct crypto_ahash *tfm)
>  {
>  	struct aspeed_sham_ctx *tctx =3D crypto_ahash_ctx(tfm);
> -	struct aspeed_hace_dev *hace_dev =3D tctx->hace_dev;
> -	struct aspeed_sha_hmac_ctx *bctx =3D tctx->base;
> -	int ds =3D crypto_shash_digestsize(bctx->shash);
> -	int bs =3D crypto_shash_blocksize(bctx->shash);
> -	int err =3D 0;
> -	int i;
> -
> -	AHASH_DBG(hace_dev, "%s: keylen:%d\n",
> crypto_tfm_alg_name(&tfm->base),
> -		  keylen);
> -
> -	if (keylen > bs) {
> -		err =3D aspeed_sham_shash_digest(bctx->shash,
> -					       crypto_shash_get_flags(bctx->shash),
> -					       key, keylen, bctx->ipad);
> -		if (err)
> -			return err;
> -		keylen =3D ds;
> -
> -	} else {
> -		memcpy(bctx->ipad, key, keylen);
> -	}
> -
> -	memset(bctx->ipad + keylen, 0, bs - keylen);
> -	memcpy(bctx->opad, bctx->ipad, bs);
> -
> -	for (i =3D 0; i < bs; i++) {
> -		bctx->ipad[i] ^=3D HMAC_IPAD_VALUE;
> -		bctx->opad[i] ^=3D HMAC_OPAD_VALUE;
> -	}
> -
> -	return err;
> -}
> -
> -static int aspeed_sham_cra_init(struct crypto_tfm *tfm) -{
> -	struct ahash_alg *alg =3D __crypto_ahash_alg(tfm->__crt_alg);
> -	struct aspeed_sham_ctx *tctx =3D crypto_tfm_ctx(tfm);
> +	struct ahash_alg *alg =3D crypto_ahash_alg(tfm);
>  	struct aspeed_hace_alg *ast_alg;
>=20
>  	ast_alg =3D container_of(alg, struct aspeed_hace_alg, alg.ahash.base);
>  	tctx->hace_dev =3D ast_alg->hace_dev;
> -	tctx->flags =3D 0;
> -
> -	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> -				 sizeof(struct aspeed_sham_reqctx));
> -
> -	if (ast_alg->alg_base) {
> -		/* hmac related */
> -		struct aspeed_sha_hmac_ctx *bctx =3D tctx->base;
> -
> -		tctx->flags |=3D SHA_FLAGS_HMAC;
> -		bctx->shash =3D crypto_alloc_shash(ast_alg->alg_base, 0,
> -						 CRYPTO_ALG_NEED_FALLBACK);
> -		if (IS_ERR(bctx->shash)) {
> -			dev_warn(ast_alg->hace_dev->dev,
> -				 "base driver '%s' could not be loaded.\n",
> -				 ast_alg->alg_base);
> -			return PTR_ERR(bctx->shash);
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static void aspeed_sham_cra_exit(struct crypto_tfm *tfm) -{
> -	struct aspeed_sham_ctx *tctx =3D crypto_tfm_ctx(tfm);
> -	struct aspeed_hace_dev *hace_dev =3D tctx->hace_dev;
> -
> -	AHASH_DBG(hace_dev, "%s\n", crypto_tfm_alg_name(tfm));
> -
> -	if (tctx->flags & SHA_FLAGS_HMAC) {
> -		struct aspeed_sha_hmac_ctx *bctx =3D tctx->base;
> -
> -		crypto_free_shash(bctx->shash);
> -	}
> -}
> -
> -static int aspeed_sham_export(struct ahash_request *req, void *out) -{
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -
> -	memcpy(out, rctx, sizeof(*rctx));
> -
> -	return 0;
> -}
> -
> -static int aspeed_sham_import(struct ahash_request *req, const void *in)=
 -{
> -	struct aspeed_sham_reqctx *rctx =3D ahash_request_ctx(req);
> -
> -	memcpy(rctx, in, sizeof(*rctx));
>=20
>  	return 0;
>  }
> @@ -853,11 +625,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[]
> =3D {
>  		.alg.ahash.base =3D {
>  			.init	=3D aspeed_sham_init,
>  			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
>  			.finup	=3D aspeed_sham_finup,
>  			.digest	=3D aspeed_sham_digest,
>  			.export	=3D aspeed_sham_export,
>  			.import	=3D aspeed_sham_import,
> +			.init_tfm =3D aspeed_sham_cra_init,
>  			.halg =3D {
>  				.digestsize =3D SHA1_DIGEST_SIZE,
>  				.statesize =3D sizeof(struct aspeed_sham_reqctx), @@
> -867,13 +639,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] =3D =
{
>  					.cra_priority		=3D 300,
>  					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
>  								  CRYPTO_ALG_ASYNC |
> +								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
>  								  CRYPTO_ALG_KERN_DRIVER_ONLY,
>  					.cra_blocksize		=3D SHA1_BLOCK_SIZE,
>  					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx),
> +					.cra_reqsize		=3D sizeof(struct
> aspeed_sham_reqctx),
>  					.cra_alignmask		=3D 0,
>  					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
>  				}
>  			}
>  		},
> @@ -885,11 +657,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[]
> =3D {
>  		.alg.ahash.base =3D {
>  			.init	=3D aspeed_sham_init,
>  			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
>  			.finup	=3D aspeed_sham_finup,
>  			.digest	=3D aspeed_sham_digest,
>  			.export	=3D aspeed_sham_export,
>  			.import	=3D aspeed_sham_import,
> +			.init_tfm =3D aspeed_sham_cra_init,
>  			.halg =3D {
>  				.digestsize =3D SHA256_DIGEST_SIZE,
>  				.statesize =3D sizeof(struct aspeed_sham_reqctx), @@
> -899,13 +671,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] =3D =
{
>  					.cra_priority		=3D 300,
>  					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
>  								  CRYPTO_ALG_ASYNC |
> +								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
>  								  CRYPTO_ALG_KERN_DRIVER_ONLY,
>  					.cra_blocksize		=3D SHA256_BLOCK_SIZE,
>  					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx),
> +					.cra_reqsize		=3D sizeof(struct
> aspeed_sham_reqctx),
>  					.cra_alignmask		=3D 0,
>  					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
>  				}
>  			}
>  		},
> @@ -917,11 +689,11 @@ static struct aspeed_hace_alg aspeed_ahash_algs[]
> =3D {
>  		.alg.ahash.base =3D {
>  			.init	=3D aspeed_sham_init,
>  			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
>  			.finup	=3D aspeed_sham_finup,
>  			.digest	=3D aspeed_sham_digest,
>  			.export	=3D aspeed_sham_export,
>  			.import	=3D aspeed_sham_import,
> +			.init_tfm =3D aspeed_sham_cra_init,
>  			.halg =3D {
>  				.digestsize =3D SHA224_DIGEST_SIZE,
>  				.statesize =3D sizeof(struct aspeed_sham_reqctx), @@
> -931,118 +703,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] =3D=
 {
>  					.cra_priority		=3D 300,
>  					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
>  								  CRYPTO_ALG_ASYNC |
> +								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
>  								  CRYPTO_ALG_KERN_DRIVER_ONLY,
>  					.cra_blocksize		=3D SHA224_BLOCK_SIZE,
>  					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx),
> +					.cra_reqsize		=3D sizeof(struct
> aspeed_sham_reqctx),
>  					.cra_alignmask		=3D 0,
>  					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
> -				}
> -			}
> -		},
> -		.alg.ahash.op =3D {
> -			.do_one_request =3D aspeed_ahash_do_one,
> -		},
> -	},
> -	{
> -		.alg_base =3D "sha1",
> -		.alg.ahash.base =3D {
> -			.init	=3D aspeed_sham_init,
> -			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
> -			.finup	=3D aspeed_sham_finup,
> -			.digest	=3D aspeed_sham_digest,
> -			.setkey	=3D aspeed_sham_setkey,
> -			.export	=3D aspeed_sham_export,
> -			.import	=3D aspeed_sham_import,
> -			.halg =3D {
> -				.digestsize =3D SHA1_DIGEST_SIZE,
> -				.statesize =3D sizeof(struct aspeed_sham_reqctx),
> -				.base =3D {
> -					.cra_name		=3D "hmac(sha1)",
> -					.cra_driver_name	=3D "aspeed-hmac-sha1",
> -					.cra_priority		=3D 300,
> -					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
> -								  CRYPTO_ALG_ASYNC |
> -								  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -					.cra_blocksize		=3D SHA1_BLOCK_SIZE,
> -					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx)
> +
> -								sizeof(struct aspeed_sha_hmac_ctx),
> -					.cra_alignmask		=3D 0,
> -					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
> -				}
> -			}
> -		},
> -		.alg.ahash.op =3D {
> -			.do_one_request =3D aspeed_ahash_do_one,
> -		},
> -	},
> -	{
> -		.alg_base =3D "sha224",
> -		.alg.ahash.base =3D {
> -			.init	=3D aspeed_sham_init,
> -			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
> -			.finup	=3D aspeed_sham_finup,
> -			.digest	=3D aspeed_sham_digest,
> -			.setkey	=3D aspeed_sham_setkey,
> -			.export	=3D aspeed_sham_export,
> -			.import	=3D aspeed_sham_import,
> -			.halg =3D {
> -				.digestsize =3D SHA224_DIGEST_SIZE,
> -				.statesize =3D sizeof(struct aspeed_sham_reqctx),
> -				.base =3D {
> -					.cra_name		=3D "hmac(sha224)",
> -					.cra_driver_name	=3D "aspeed-hmac-sha224",
> -					.cra_priority		=3D 300,
> -					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
> -								  CRYPTO_ALG_ASYNC |
> -								  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -					.cra_blocksize		=3D SHA224_BLOCK_SIZE,
> -					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx)
> +
> -								sizeof(struct aspeed_sha_hmac_ctx),
> -					.cra_alignmask		=3D 0,
> -					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
> -				}
> -			}
> -		},
> -		.alg.ahash.op =3D {
> -			.do_one_request =3D aspeed_ahash_do_one,
> -		},
> -	},
> -	{
> -		.alg_base =3D "sha256",
> -		.alg.ahash.base =3D {
> -			.init	=3D aspeed_sham_init,
> -			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
> -			.finup	=3D aspeed_sham_finup,
> -			.digest	=3D aspeed_sham_digest,
> -			.setkey	=3D aspeed_sham_setkey,
> -			.export	=3D aspeed_sham_export,
> -			.import	=3D aspeed_sham_import,
> -			.halg =3D {
> -				.digestsize =3D SHA256_DIGEST_SIZE,
> -				.statesize =3D sizeof(struct aspeed_sham_reqctx),
> -				.base =3D {
> -					.cra_name		=3D "hmac(sha256)",
> -					.cra_driver_name	=3D "aspeed-hmac-sha256",
> -					.cra_priority		=3D 300,
> -					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
> -								  CRYPTO_ALG_ASYNC |
> -								  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -					.cra_blocksize		=3D SHA256_BLOCK_SIZE,
> -					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx)
> +
> -								sizeof(struct aspeed_sha_hmac_ctx),
> -					.cra_alignmask		=3D 0,
> -					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
>  				}
>  			}
>  		},
> @@ -1057,11 +724,11 @@ static struct aspeed_hace_alg
> aspeed_ahash_algs_g6[] =3D {
>  		.alg.ahash.base =3D {
>  			.init	=3D aspeed_sham_init,
>  			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
>  			.finup	=3D aspeed_sham_finup,
>  			.digest	=3D aspeed_sham_digest,
>  			.export	=3D aspeed_sham_export,
>  			.import	=3D aspeed_sham_import,
> +			.init_tfm =3D aspeed_sham_cra_init,
>  			.halg =3D {
>  				.digestsize =3D SHA384_DIGEST_SIZE,
>  				.statesize =3D sizeof(struct aspeed_sham_reqctx), @@
> -1071,13 +738,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[]
> =3D {
>  					.cra_priority		=3D 300,
>  					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
>  								  CRYPTO_ALG_ASYNC |
> +								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
>  								  CRYPTO_ALG_KERN_DRIVER_ONLY,
>  					.cra_blocksize		=3D SHA384_BLOCK_SIZE,
>  					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx),
> +					.cra_reqsize		=3D sizeof(struct
> aspeed_sham_reqctx),
>  					.cra_alignmask		=3D 0,
>  					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
>  				}
>  			}
>  		},
> @@ -1089,11 +756,11 @@ static struct aspeed_hace_alg
> aspeed_ahash_algs_g6[] =3D {
>  		.alg.ahash.base =3D {
>  			.init	=3D aspeed_sham_init,
>  			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
>  			.finup	=3D aspeed_sham_finup,
>  			.digest	=3D aspeed_sham_digest,
>  			.export	=3D aspeed_sham_export,
>  			.import	=3D aspeed_sham_import,
> +			.init_tfm =3D aspeed_sham_cra_init,
>  			.halg =3D {
>  				.digestsize =3D SHA512_DIGEST_SIZE,
>  				.statesize =3D sizeof(struct aspeed_sham_reqctx), @@
> -1103,83 +770,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[]
> =3D {
>  					.cra_priority		=3D 300,
>  					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
>  								  CRYPTO_ALG_ASYNC |
> +								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
>  								  CRYPTO_ALG_KERN_DRIVER_ONLY,
>  					.cra_blocksize		=3D SHA512_BLOCK_SIZE,
>  					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx),
> +					.cra_reqsize		=3D sizeof(struct
> aspeed_sham_reqctx),
>  					.cra_alignmask		=3D 0,
>  					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
> -				}
> -			}
> -		},
> -		.alg.ahash.op =3D {
> -			.do_one_request =3D aspeed_ahash_do_one,
> -		},
> -	},
> -	{
> -		.alg_base =3D "sha384",
> -		.alg.ahash.base =3D {
> -			.init	=3D aspeed_sham_init,
> -			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
> -			.finup	=3D aspeed_sham_finup,
> -			.digest	=3D aspeed_sham_digest,
> -			.setkey	=3D aspeed_sham_setkey,
> -			.export	=3D aspeed_sham_export,
> -			.import	=3D aspeed_sham_import,
> -			.halg =3D {
> -				.digestsize =3D SHA384_DIGEST_SIZE,
> -				.statesize =3D sizeof(struct aspeed_sham_reqctx),
> -				.base =3D {
> -					.cra_name		=3D "hmac(sha384)",
> -					.cra_driver_name	=3D "aspeed-hmac-sha384",
> -					.cra_priority		=3D 300,
> -					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
> -								  CRYPTO_ALG_ASYNC |
> -								  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -					.cra_blocksize		=3D SHA384_BLOCK_SIZE,
> -					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx)
> +
> -								sizeof(struct aspeed_sha_hmac_ctx),
> -					.cra_alignmask		=3D 0,
> -					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
> -				}
> -			}
> -		},
> -		.alg.ahash.op =3D {
> -			.do_one_request =3D aspeed_ahash_do_one,
> -		},
> -	},
> -	{
> -		.alg_base =3D "sha512",
> -		.alg.ahash.base =3D {
> -			.init	=3D aspeed_sham_init,
> -			.update	=3D aspeed_sham_update,
> -			.final	=3D aspeed_sham_final,
> -			.finup	=3D aspeed_sham_finup,
> -			.digest	=3D aspeed_sham_digest,
> -			.setkey	=3D aspeed_sham_setkey,
> -			.export	=3D aspeed_sham_export,
> -			.import	=3D aspeed_sham_import,
> -			.halg =3D {
> -				.digestsize =3D SHA512_DIGEST_SIZE,
> -				.statesize =3D sizeof(struct aspeed_sham_reqctx),
> -				.base =3D {
> -					.cra_name		=3D "hmac(sha512)",
> -					.cra_driver_name	=3D "aspeed-hmac-sha512",
> -					.cra_priority		=3D 300,
> -					.cra_flags		=3D CRYPTO_ALG_TYPE_AHASH |
> -								  CRYPTO_ALG_ASYNC |
> -								  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -					.cra_blocksize		=3D SHA512_BLOCK_SIZE,
> -					.cra_ctxsize		=3D sizeof(struct aspeed_sham_ctx)
> +
> -								sizeof(struct aspeed_sha_hmac_ctx),
> -					.cra_alignmask		=3D 0,
> -					.cra_module		=3D THIS_MODULE,
> -					.cra_init		=3D aspeed_sham_cra_init,
> -					.cra_exit		=3D aspeed_sham_cra_exit,
>  				}
>  			}
>  		},
> diff --git a/drivers/crypto/aspeed/aspeed-hace.h
> b/drivers/crypto/aspeed/aspeed-hace.h
> index 68f70e01fccb..b7fc8433e021 100644
> --- a/drivers/crypto/aspeed/aspeed-hace.h
> +++ b/drivers/crypto/aspeed/aspeed-hace.h
> @@ -119,7 +119,6 @@
>  #define SHA_FLAGS_SHA512		BIT(4)
>  #define SHA_FLAGS_SHA512_224		BIT(5)
>  #define SHA_FLAGS_SHA512_256		BIT(6)
> -#define SHA_FLAGS_HMAC			BIT(8)
>  #define SHA_FLAGS_FINUP			BIT(9)
>  #define SHA_FLAGS_MASK			(0xff)
>=20
> @@ -161,44 +160,37 @@ struct aspeed_engine_hash {
>  	aspeed_hace_fn_t		dma_prepare;
>  };
>=20
> -struct aspeed_sha_hmac_ctx {
> -	struct crypto_shash *shash;
> -	u8 ipad[SHA512_BLOCK_SIZE];
> -	u8 opad[SHA512_BLOCK_SIZE];
> -};
> -
>  struct aspeed_sham_ctx {
>  	struct aspeed_hace_dev		*hace_dev;
> -	unsigned long			flags;	/* hmac flag */
> -
> -	struct aspeed_sha_hmac_ctx	base[];
>  };
>=20
>  struct aspeed_sham_reqctx {
> -	unsigned long		flags;		/* final update flag should no use*/
> -	unsigned long		op;		/* final or update */
> -	u32			cmd;		/* trigger cmd */
> +	/* DMA buffer written by hardware */
> +	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
>=20
> -	/* walk state */
> -	struct scatterlist	*src_sg;
> -	int			src_nents;
> -	unsigned int		offset;		/* offset in current sg */
> -	unsigned int		total;		/* per update length */
> +	/* Software state */
> +	u64			digcnt[2];
> +
> +	dma_addr_t		digest_dma_addr;
> +	dma_addr_t              buffer_dma_addr;
>=20
>  	size_t			digsize;
>  	size_t			block_size;
>  	size_t			ivsize;
> -	const __be32		*sha_iv;
>=20
> -	/* remain data buffer */
> -	u8			buffer[SHA512_BLOCK_SIZE * 2];
> -	dma_addr_t		buffer_dma_addr;
> -	size_t			bufcnt;		/* buffer counter */
> +	unsigned long		flags;		/* final update flag should no use*/
>=20
> -	/* output buffer */
> -	u8			digest[SHA512_DIGEST_SIZE] __aligned(64);
> -	dma_addr_t		digest_dma_addr;
> -	u64			digcnt[2];
> +	/* walk state */
> +	struct scatterlist	*src_sg;
> +	struct scatterlist	*next_sg;
> +	int			src_nents;
> +	unsigned int		offset;		/* offset in current sg */
> +	unsigned int		total;		/* per update length */
> +
> +	u32			cmd;		/* trigger cmd */
> +
> +	/* This is DMA too but read-only for hardware. */
> +	u8			buffer[SHA512_BLOCK_SIZE];
>  };
>=20
>  struct aspeed_engine_crypto {
> --
> 2.39.5
>=20
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
