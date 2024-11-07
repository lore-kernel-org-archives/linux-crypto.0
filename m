Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8DB1EF08E;
	Thu,  7 Nov 2024 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730985230; cv=fail; b=IM3rwo61yGdvdr+ZSzhGKZXbsRvFbR5GGQ59GgHoT1i9rm1v4FQFAeJCBjjLJ4ah0xVbbg+dJdCXyQwRviRP89HMA9Q3IM++UKKdSdCQNhvn9pEtgfdUyJtZd54gFjguocS/PfpSWkdymzvjNqjiOS0wsgrb6xlIQVDyARfaWYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730985230; c=relaxed/simple;
	bh=G5+Tyb923A0DH+oLb1PbkGBpwMR7HI7AI0mPCX+AUTg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LARfkJLxdXCmGWErOastgl82Ta2eep3LxnUavx3VLzQPnrgpZjjFi1FRF4+uaV+eIviBlBYfGhD0+QmNlIpaUjIzWj1+BpsBAIQm4MbtP0FGx/I/MfqxT0RohsWebHynHYxM5rET/ypmsBULtpANROsrXcRGonxXi+asN6UyOFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UkNn+5sc; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UkNn+5sc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwb2MgPSIk8Lo+KrbBzOUdb1AcNgRh+kJBr3apHpSGG/DpfOjbKoZ93T4Fzy1PMpdFEtOB2LWcTDd9//WudfvYJztCW6Qvl89ybnayZ4iWhBGutcScsmNurSTuFZz3E5j8OvLppDwrcoYY9fT2DzUL19N9xPr9aDV5aFvsnzPmI+EL0dSQxRhku6Pt9C51CIGJA7I6KoNUVXKI+XdsqDa/SgiHeeq3oaLvE0YBy/0eqlmuClWRAsqvyPJ/HI73gX7fMP/Qr7pY60bhpACMf9J43fAieEIv1Nq0MVRFFeLjCj2AByj7Rf3/4KOnRJqumT+Nbl4M5TT2BdjgQ5jfev3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8JbIbPKHlbnw7vd9rL1hhsLaCkSjJH5S7VgyCXG18A=;
 b=cAwGDgYeL8IcsgK4fLMMItoYDp+czbpnw8ErLO2Z8oOADO03Bn4+kXCPu20QtdftesqhxdshELDNlior24YWpDQCUCxuFwhKYnBIraXQ+ugc7yZqamjOTt6KNi0NvsNC/P36Je7U5t4yPNJln221u6mbvNmga9ZB7apAUHWL3pzR+aPVtZc3aY8xGPyjh+lV91KbcsEf77NQNgf8oJ1WoQ1ZvGu+Euc6KIXoR3/SjNpZDStkmL2Rb6RJFp5KgILGqLAtTtLMOGE6M8hafi3DRw6iKXmQo0UfZFBPEqrRh2LBX8X/cdEVnYv96OKeKflokGeGDoPIDiJjG36gHbkcZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8JbIbPKHlbnw7vd9rL1hhsLaCkSjJH5S7VgyCXG18A=;
 b=UkNn+5sci8LtSde0tUolQ68TGUyhsDMjaJrkjbdY3TPXmfGCmvh0ZPzYMO7HVyP4zKPg/+m24QPTbRCb/vEvKQvMQxuSJRicNpvZZHz8Z/ieUZB2eJaqJS+7OijyIDX1aRhhBdY5t2s/h6hBdJ911E2ww8d3rnVj2SbLG9gII9H2O3HoA9lJOsAQdJAVT+CQapOB7KRhLGpXBN9pyzwJKp+IuDX/jNQT4n4Ykf8Y4f3PmeuYWenV0Zpm9OcwZwcByED/g5cZUWLDmZEQDURn5q0wtP1K1d+TzfRKUljRMyPj/rxiCYNoD7XOE3cdTXomrSYzRCtpCHjwl6bzgUJ6Gw==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 13:13:45 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 13:13:44 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Chen Ridong <chenridong@huaweicloud.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"chenridong@huawei.com" <chenridong@huawei.com>, "wangweiyang2@huawei.com"
	<wangweiyang2@huawei.com>
Subject: RE: [PATCH] crypto: tegra - do not transfer req when tegra_sha_init
 returns an error
Thread-Topic: [PATCH] crypto: tegra - do not transfer req when tegra_sha_init
 returns an error
Thread-Index: AQHbMRUj6zRLf8q3jk+YxFkS5F6tn7KryWsA
Date: Thu, 7 Nov 2024 13:13:44 +0000
Message-ID:
 <PH7PR12MB8178FB2C64F990DFD3D9D5BAC05C2@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20241107125211.1679517-1-chenridong@huaweicloud.com>
In-Reply-To: <20241107125211.1679517-1-chenridong@huaweicloud.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|DM4PR12MB8474:EE_
x-ms-office365-filtering-correlation-id: 169ac787-90b4-4ea9-d808-08dcff2e0215
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?SFquOjrKDT8WA0nf2zR/djULMSlIVa0ucdNzv+5X3j6hd32Axd5003/wvNbG?=
 =?us-ascii?Q?RRZfKpxJ5JLYgbwFVbi031cDkRQowgNkoGS+xndG7FoAVH/MUhz4Z1nJehXq?=
 =?us-ascii?Q?4k0+E3qX5uORvwLfSs5LVNR0VUEnrBiOimjv3CaugEVezjLpOqNrfLtM1hNX?=
 =?us-ascii?Q?veX+x8dikxzg3CKoVsanmL5/I2ieH9F/txFL38w9a3qnXLHfSTmFT7YPSaux?=
 =?us-ascii?Q?DMwlCOGRjORhhjP4rKPmWYKH0jpLbw1wwrXFJ4wbrtFFUJoQmuNQSk/vFZDw?=
 =?us-ascii?Q?UqXyMqgeX+z83bHFoDuIEYGlnTvX8aa83NWSs70ylhtd4OKKmb/Jc4yVKHJB?=
 =?us-ascii?Q?7wkh1cAFAFt7NYd1su1IOPLpUDSATYCjUjPgBbUloaGB/7uAiDg8tOYZYoZZ?=
 =?us-ascii?Q?NgfGvaynrun4VGDbKhT6nlHCHtN3h5kgYaPXv34FEvr8peBKI6R0cfakh/eI?=
 =?us-ascii?Q?6jrbCeKEuR9cXXE44Cin54GXbPQbPDtMBmFRYbfj5aIDojX4zzaN9knmszJU?=
 =?us-ascii?Q?3ToErHno4uRcDZPZCP1EFtBk/A/7x2mTq/yR4jU3oHqOgpXdLlkYQgWTNZFe?=
 =?us-ascii?Q?PW/D8pxW/Wm5p58zf2wahWQ2RLoMsaM2/phMz+e0zwHiPZAQCfURv2XreGZz?=
 =?us-ascii?Q?tpBAU7QlQkkyv9hpPlMpC+E53oJ88L+BWCGT51CaTRipkPP7UXMHrjkEb43C?=
 =?us-ascii?Q?BiOd0NWm+vg9sXZzPex5/0rvkUsVW9uaHXXAkdDi4GXxWP3Sg24uj4Wl62EH?=
 =?us-ascii?Q?UbCrGbK7xJ5T0jmsLXUkDfiOaDBrNbPtzoFDdKw+kfk6bFAjs31326IscBXV?=
 =?us-ascii?Q?+5tGIV8UT1oGPwyEzcuWHzxpo/CuBwEfSZzKMFVFkr3tmTbcfM1dQDw9H7sk?=
 =?us-ascii?Q?gFEsQ3VsztPOb8nIskM77jvFSRbwm6AopwesAXhTjl4Fs3z25r75LxSXdian?=
 =?us-ascii?Q?YThGsJZ5VIoiJQrnK710Zou9QIkwK3889OQ4n3k2nz0lhicBdw4BGBFHxBiJ?=
 =?us-ascii?Q?TxINWm7Nvc1YseQqQwzkr7rii2qoAL7v+g6oLsuqvOLBhr74aiCAtRfkoSmj?=
 =?us-ascii?Q?H4tF45q4zk7UhrwfwVfM+93enZ1f6jsWMLXv3nm3RoZIuGW5qEjO3GV85es/?=
 =?us-ascii?Q?2SSGRH9jC4KD9QL4AbfCS3PPSK/nmS2SCAtNsUfS0pQSpgtMSYhSu+yKxHSd?=
 =?us-ascii?Q?6NRXYsP92rrARfwtG8+iwhrRnDaV1AFhgqYdHnzAxj1Xhj+Q2FBBre5m+Aid?=
 =?us-ascii?Q?tRWOjgBFsF9ZZyL5T/HKVVz9HeIfePwfqy6BxZw/kpdWJ1XkREcGvrGjV5re?=
 =?us-ascii?Q?0s9K6RNL2rGfp8ryr9+2Pr3rpRxea1vNtYWZeMLTO+pTw7++0OJkSyc5wTh6?=
 =?us-ascii?Q?yY7uFNs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Xk+edjc0s1fHQdK6i5/H/O+gqIVrQvgJmYRct26Wv1tGkqdEhBTLq8MjskmJ?=
 =?us-ascii?Q?pqQihGMcQgimCy1uPzSXxDkBfXqwotbv2fxaLplD5op6Esf8Qr5/M1oYQb87?=
 =?us-ascii?Q?R4Q6jiZ4PMuJfTKPW5X5pyNwinBa6i765Km9DB3X0ByVDMSI8ltJMmvOk4Ov?=
 =?us-ascii?Q?qlmqsxYyHS9/8ifJf3Ab8KxS7ICqJLD+uWVWlV3t0MQnxmFAfSc7Win74es4?=
 =?us-ascii?Q?RdPgFodZKW53w003EplAwdcAuU0aXy7eVnVSduPDwOXKHTQ31pmlaWh9Z21B?=
 =?us-ascii?Q?S/yKNVJTlGbgqpjYoIWBBInako20ZblO/bHDtRB+82gweYDKxxBP9oYJ6Z35?=
 =?us-ascii?Q?yTgHGMANw7DWz7h4uZiAQTYIKIt+LYwy6PZGt2AgarKA3TCNFiHGLv7+4dB0?=
 =?us-ascii?Q?YrR2NCYkM7jxaDv1blLmOBNBKvWvupKwA9pu2EZKH0bvvLgb2SllmTV6E1NK?=
 =?us-ascii?Q?TCbUaeNnocPNnjG79v7DQvq3aQerADcOGFt85MvT+ChXQHShw6FRUhWG40TC?=
 =?us-ascii?Q?SSbQt+R52ctvSUwk1h/nCqL2FWJM6uSSI+fxSqkX5fNarX0qPQmyIRIIVHHq?=
 =?us-ascii?Q?ny0XnmsGf92TFhf1D+6IbNhLP2+KK3FDUXiTO70Y8RgvqBTRmoNGQyzC8wSH?=
 =?us-ascii?Q?cFKLk2l+qm5lUYLn/HCLJLBfCEjauq2RcXcgyedsqJjmKWNE8oBr5QYPFxrY?=
 =?us-ascii?Q?ZHgOtIWPl0zpvJGiBUSLx3WxQLivHnLIroHij/LQeXxkky8IR2taW/3+Vqyg?=
 =?us-ascii?Q?qwpBGxdhOKIL4z4/6l2CLvZaL7TsIZLgy9UjtTZLYYoYboCJVezu+iXspl0u?=
 =?us-ascii?Q?LrERwcPfuEdz4byO8IgR56m6zQTDHRgxRtRSYC8/7zNtOJ3T2NzO6RBCQuzs?=
 =?us-ascii?Q?XWJnFtbDNxx/gvpP7YsZVZnn5GWpsxKX9jXTDDSFV+BniPkCdGrcmbnsnL+n?=
 =?us-ascii?Q?toje0TDQtk4i5PG429HVquxHdyox2WA+NRvOay4x8+vdIqYQn5UexGjdA6DZ?=
 =?us-ascii?Q?rX7iCq0tyVYuWbHXC/IShP95xvV7SZ3z3AUZYAonv2f8p5KERCW9DHOF10TO?=
 =?us-ascii?Q?WyZ47++EvyFbR1zA6eNTgLWSx6cM0s0AgjQ3srRZDpKkrZRZWuJ62kc17QZL?=
 =?us-ascii?Q?5cJ4bfWkk+reMsmEtDnBshWp4mxte8Mwfq12vPG8rX2aRnKUJMxlhUYoXaMl?=
 =?us-ascii?Q?uzevlN36hNoOKUOmtgD6ALbjYRiooEy0T+TsyHYLFD6aVVT4uJlq5Y5l7Zzp?=
 =?us-ascii?Q?T6EuMpjGKhY9tr8NSersi9VBR/QITFRFPpuiYzofN9fjkPRp4bIfL9OPMBiX?=
 =?us-ascii?Q?N0oMzE9GXsTeFfgPigM8nloKlp79QC+tnO5COHNCCNnEotCQIYpHT9L6yAJh?=
 =?us-ascii?Q?AxAiKw7RyApn/qKUOeVW9m7AKMqDLlh4CmCQVYGam+v9uNSJ+NRCTQGdPqD/?=
 =?us-ascii?Q?aJRGNjC+Lw3yARbU6AtNicy65wvHY1gOqcIwvpHAUngxUwDDm1hpYUFe8r+U?=
 =?us-ascii?Q?VXcVF8UKl8hnjMl5uFAVByEB5bm2ylsgyAYgF0vF9u/hEDa8vgioZxLaplH0?=
 =?us-ascii?Q?gD5kasgP5fkttlHOQHUXXuY9hxjoaoehkc8bEPrv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB8178.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169ac787-90b4-4ea9-d808-08dcff2e0215
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 13:13:44.7917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GT/SiAg2a/m439+B5fpBlM0SnUo+zKSSyxKh/U5zXHbGW1TxCEU4DatSSzDGIZyg/ZuH51f9HCXUKGfFNx+hkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474

> From: Chen Ridong <chenridong@huawei.com>
>=20
> The tegra_sha_init function may return an error when memory is exhausted.
> It should not transfer the request when tegra_sha_init returns an error.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/=
tegra-se-
> hash.c
> index 4d4bd727f498..7e888bf5f66a 100644
> --- a/drivers/crypto/tegra/tegra-se-hash.c
> +++ b/drivers/crypto/tegra/tegra-se-hash.c
> @@ -612,6 +612,7 @@ static int tegra_sha_finup(struct ahash_request *req)
>=20
>  static int tegra_sha_digest(struct ahash_request *req)
>  {
> +       int ret;

I would suggest moving this variable to below other variables for aesthetic=
s.
Same with the other patch for tegra_cmac_init() as well.
.
>         struct tegra_sha_reqctx *rctx =3D ahash_request_ctx(req);
>         struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>         struct tegra_sha_ctx *ctx =3D crypto_ahash_ctx(tfm);
> @@ -619,9 +620,11 @@ static int tegra_sha_digest(struct ahash_request *re=
q)
>         if (ctx->fallback)
>                 return tegra_sha_fallback_digest(req);
>=20
> -       tegra_sha_init(req);
> -       rctx->task |=3D SHA_UPDATE | SHA_FINAL;
> +       ret =3D tegra_sha_init(req);
> +       if (ret)
> +               return ret;
>=20
> +       rctx->task |=3D SHA_UPDATE | SHA_FINAL;
>         return crypto_transfer_hash_request_to_engine(ctx->se->engine, re=
q);
>  }
>=20
> --
> 2.34.1

I think this can be combined with the other patch for tegra_cma_init() as b=
oth are similar
fix. Apart from the minor comment above regarding the variable position, LG=
TM.

Acked-by: Akhil R <akhilrajeev@nvidia.com>

