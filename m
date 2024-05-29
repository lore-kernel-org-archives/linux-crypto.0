Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7A15B122;
	Wed, 29 May 2024 06:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716964866; cv=fail; b=CrJyqYCLLNHunmmBxYivWq/x3+qNMtImzPJTHkj7cOln0t/HHq79x5EJtDE5MlYjMBdS9XyhROW3rLGe0FRkM8EjCBF43IGy+PNohzcraRZ3HPEepc3HujA8ogLxMx9prCRoAxShd4tiVqhkxcsrrXgkwLucIDFjr6Uqemq7bTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716964866; c=relaxed/simple;
	bh=0WXiAE/9CyWxalBj1lLk+S9FHt7aYQNbdsH6XGPPa24=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nNqI2hyW4MD2Q5HIP0fzLYG/EkLfW3BoqMNBaJHCeTVEsreWq/rpShBzs3B89l0tB5k9UYasSicuUp3owKL89c6Q1n4sIFN83TJUu+EdWXjLgOTrv2r7dD1nO3L5zEUEhD8cOjwVFVypQFARRuDCy5mPkW3Jwu4kvrWUJ+NSftk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QjYZOk2k; arc=fail smtp.client-ip=40.107.100.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QjYZOk2k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pli9s1vtKrpLJfrAPJ8lh0CpI1612txIHJa42Ibi8CqLfBlObN5+kgb61ONSzOZesPNJk5qd6g4BWZzS5mTtSg5EXZzOtgcwsUpXAGBUVpAv+CGrFLEJ/Tm3K0992EzDMhWwcFy0n5dJ8nvufzTW5k0rkObCKiDr+OPxC5W5rJxRhV3B5tK1HBOOMwDYUAe1lt90Ss05uySy6R+oWXTT6Zq9zU0wI1WvVRUyUD/hEE4KdL46Npow8G5GmZ2XWEg16iwxtlQqAtjChxKHYc7fA5JQ4xnKjDR5gTBReKrUC6KtqPJcWlNXd1rtkLARojPbwcGIkew0hh181dbYLb9CYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Id9cofer2Vj0Sh0MlvVw5vX3pHsd/vH6VTelQ8+LR0s=;
 b=fWkXpFgl6wf4qPBq3QerprFpxtdO8zBve2raBHwaO4yk3LjaQE3IjhoiMhks9XkdQW4pFIVlDymlxx735pTwIO2XSgFhuku3Pcmkob1EB+1e2skuP6iboMfLPi0tL8YGK40hJf0kzol70ho6f0YReetkgyAK1yXk0on28EqT1Js6BA9f3qTmMu4beJRwZR0PESM7walWpPKDwIDGUfig1TyVT0EWjMmxacRrSjlhmXhYEu7pFm62RRVICjX1u1dJrvfo100uRmUUo9k82m1nr2bFRZvAeHmIxnHeucLP8/+++zIsxFh1+NDD823j5GaralCPCtNx7ktvoNWLNZH/2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Id9cofer2Vj0Sh0MlvVw5vX3pHsd/vH6VTelQ8+LR0s=;
 b=QjYZOk2kmRKTNLovx7ZC5wI7CNIwppuDhd0lHPjq4vLos00h/IOjiibWycSIm6VyLih9SFv86ig2fjuiA8LzafVpBhHrejtmxIzzpAUci+fn1GmnM4tUY8ZKPO0zjj/l4Fe4L8VxGoD1xVzrxhCEnjhIswKIQXIDwaf1X/WTvdOl2tndJbZ2vcd3ekp922UdaxHvbqIe7skX6/rM+f2+iZyJGdK02E9sRbxZCa5uYTf3TTJXjl+mZhEBVPQzR9pE0HbL3DhhLAkQY4yPCjaCztM8NdWAZrqyXDsjnbJA9pYzkCixnRv34nlIAF7RpCulC+P0o9yGZaBKU/72DmbHAg==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by IA1PR12MB8465.namprd12.prod.outlook.com (2603:10b6:208:457::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 06:40:58 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7633.017; Wed, 29 May 2024
 06:40:57 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, Mikko Perttunen
	<mperttunen@nvidia.com>
Subject: RE: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Topic: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Index: AQHarrZLeawWiYOujkiA3zLjv6FXT7GtuQzg
Date: Wed, 29 May 2024 06:40:56 +0000
Message-ID:
 <SJ1PR12MB63391A3077F369FBF9BCB2D2C0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
References:
 <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
In-Reply-To:
 <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|IA1PR12MB8465:EE_
x-ms-office365-filtering-correlation-id: d5bfaca1-b66b-435c-c641-08dc7faa4ba1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?CFoFhx4Hvs3N+BUZZ6nVs5wIjEroTFvyt9TRB9IFjIiaZpduV2z3GF63tFFW?=
 =?us-ascii?Q?P+v0FuPCSnRiSPqdtH243skfLIEWlkPhef/qYERpo0yXVq+IkRoaKY66PFTO?=
 =?us-ascii?Q?L4vb/fzv9hfASE7FvQicTRzeggOYvkIggWYORgrW6F3WgRNsZB4k9Xy/Q9aA?=
 =?us-ascii?Q?CagIngv5q/EYh8dYaokE13aT6T50dH3/Q1k5ewKfV2KU4tHPfciRajYPkKFr?=
 =?us-ascii?Q?0aNAH5RTzYw77gEDw5k8jTRJ944md9gwrdbZrAQgoStURJPrvfcEkp2wSrKI?=
 =?us-ascii?Q?YzUWqoFVZW1aEI+mDUUAsRUdQFpX1X57QD5v5F+83aUmeKHtxKbpfdpSdXi1?=
 =?us-ascii?Q?WwIffnspwDCbGRmH4CXpvRVYzrqLFjuyY3H/vQW2lkwrxMd5VU2hRDARYtDR?=
 =?us-ascii?Q?tiCi9RfIUNvQ9eNeZ44oIFQAyEN8I6GRPrsxWdjPDTPicmnxuSI0wlXOs6ug?=
 =?us-ascii?Q?URKKYXBGDySfkynJKaU9AEl6KMA+uiX3/ZHrIZqaRx3tS+orzef05rC1TRz8?=
 =?us-ascii?Q?THrnYKDP0/Z6alPGzelPdGHBrryv3i0urO3YdmG/n04z/6vtyNPVFuPBKlAP?=
 =?us-ascii?Q?8TyNWPcl2iYE6n4OcffceAO/Z30OIe1LCMWlX9lDT49chLDFOStTJXbCdOW/?=
 =?us-ascii?Q?Hgbert5T+70V5SwfAJVi2i6lGR4t0xaoshx77EwKQV+dfoBUzEWSQdGAo7Yy?=
 =?us-ascii?Q?/6dk5j7BXYbHdx66Rk2CRqwKMH8dGQYMBTOqEe2ZvtgwgxbBANVJOqdzVgMi?=
 =?us-ascii?Q?Wg1u0UjDl3X5wOb9kroZGH2we9/r6+vQ7FA066w0ACLUdc0T44p5Ul7L+zUz?=
 =?us-ascii?Q?sdYYUSqTNNtvQHQgaAHtGvrMdMfC98JgMw2tk91Fdc1yv0UisHEKfd9qAicY?=
 =?us-ascii?Q?Z7VJIukPB0eSpRTKB3Y82UshWkYV9PqQkPnngwLpi2LXCtH40VaFxdBKxdke?=
 =?us-ascii?Q?2xZ00c658nfLN0N+h7IxeBkLppTVFC8l49SiIcgA+vEOELLnX1qtdo9fBHhI?=
 =?us-ascii?Q?6G4KGjwaS08XR63TomHAbxwjG5EPT3UKV0SCs4M4LplFiEE6SL7xpygC+jB6?=
 =?us-ascii?Q?hdvwZPhIW2Q4agl6lmaVnNDXD0uyEF5JehN+aw7pODUXDiuBPjbGxtfOTvIt?=
 =?us-ascii?Q?ZlfhR4D/qV/Ps1K2RfzNuacL7s8UmPBAm6zj2MrjrnphfthJB/zYfIlQ8F2/?=
 =?us-ascii?Q?mx8Ut7gUlDJ+zTb0k2ccToMtbvscbheQXtQzmh3DgviHKYAS26aMusvS9D0b?=
 =?us-ascii?Q?P0DdfkXzyJmh6EoyD+C2FBVA1gO6Z1/UTTSDcSfE+XsjbZDRqFnD9uJYl5g6?=
 =?us-ascii?Q?nSz1PznTUqufSaAENgGmsZdGI3ovYteiYId/gK35LfUDJA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rlLEmhA7cBasb3RL2dxT0/Ji6BW/iNu4SoAxlEwmlACfaGnHXtPxGuYYrdwm?=
 =?us-ascii?Q?KDvicmcGij+tYpuyT6/5lXLXfd7/z9SwAgF7kWiWuNZvLiltvErPFKS4xkDl?=
 =?us-ascii?Q?gNm3Cg+6x3IoaXYhJG54oNr43X120Au7fvIQ9acVDQwi5P56W33iuUX4vfzZ?=
 =?us-ascii?Q?BZR2HW5DYvA4KAMDz4jKhVUg96NVh+xTwnymXdL+nb0HmGFThlBnsAM9XP5y?=
 =?us-ascii?Q?vE5CKTkS0mVNlu6EjA7SZNWL9m/eIoTu0Zw2shkdOyA7VsuDjrkKaBv0L5Ht?=
 =?us-ascii?Q?znnXvLHncQePOdy2F+u0Ll5wnnI3I6tI5LUb1ahkFk/EU+uK2HrlpQ+8RP5E?=
 =?us-ascii?Q?kjQKRIGNDg+MS7nsn7BgRB/kJW1JeGw5UjOlqPFHv4jZknRi+rCybw8kt5w0?=
 =?us-ascii?Q?mLi6/UEKQuIYFgCIRvUMV9rDujFg2UQXO7TG/17TcdEMeorgdG7HZy+VY30E?=
 =?us-ascii?Q?9iJfXcoruU1RksAIXwjpRwBMLQY2mKrpc0d2lGw6TLDT79CFPSRPIDbDTQlv?=
 =?us-ascii?Q?RmPSyhAMXEAmflMZgvGQb0O7LEUTRuZBHT+WBq6A41ckT3T9qVD3f+jADucJ?=
 =?us-ascii?Q?lSBJSWm2lE0GDWqSThsdDkyjUKnXjRxy8JEJvBSAcgbNaS0sjyamKJue+gMg?=
 =?us-ascii?Q?F/hDil7c+uhMVl+siVXtyAPwNRK0RqaU2C6u1Oq314vI/nv1SB3jpPF/6Dax?=
 =?us-ascii?Q?y5UwuXePxhSRpYKFDvcRK12+CL0EejWgAEBoYk+qPs0ABv/SKAqrfjwgmaDt?=
 =?us-ascii?Q?2+hgPcWJkSH06Cbkm2kh7GiDyy7r4rODa7c7PUDKMQaQ8PLePJ2zlbf7sN6z?=
 =?us-ascii?Q?fCfEVlXF9+pxIoT2j7JeiHhhHxMaHn2zJqV4+zs3cJs1tajDYB9dUjrPg2ll?=
 =?us-ascii?Q?67YVqVNa8U5n4lMQgkmySkhFvlsA7cqHJzr9TJez7a/tLFm0b7LYilecU/VR?=
 =?us-ascii?Q?uTrLwmYLbLr6Vx0OfZrAyR6E7o+O1sr3pTl+0M+ITpQnGLfQhbQSmsouvZYB?=
 =?us-ascii?Q?YSQ/uH8BgKXqvA+yhe1GCiKkBsQagVKkuRHWjHWvcQYRJC3gSOu0BpFuFCVH?=
 =?us-ascii?Q?A0lDhPSYHv+Jp8Vll97e2MlUKWrAo9ydJlVcDz+LYtMss9imKrDTyOVLjJCN?=
 =?us-ascii?Q?v58/bT0whw3oV0ZmZzFVrgrKO3wHGetM9K5ZmNyw4BKxeBePhjBwDS0XSToL?=
 =?us-ascii?Q?ckhvmwc/h5soeM6v2iQmwS3spSXlv/piKVA+p/Af5xgandiLE5HYB875hmfk?=
 =?us-ascii?Q?WwUMcCVJADURuBDuL30YPN9uV9uGFjY912ux6oqFtJNbK1xow/+S9RHAgeaS?=
 =?us-ascii?Q?XlUXwFDOhc0Ax2mP1JAY61mkDBWN2xGu0G1+5vtyByD+kCx6syBnurJvzw73?=
 =?us-ascii?Q?Cl+04s7W1bM3+T5kDiPgt2ZewRSEDUrE106UXavio1eARA/mMlyDkPO9jusd?=
 =?us-ascii?Q?CpAwBeYW5iOdzS/mr5aHvTDJoYmyR0wTfqXZ2gP7b+2DF15Mth/zBCoK/S7g?=
 =?us-ascii?Q?6zO3tIEC2kmdc9tvN3miSDl0hNYUH6F+96b7eZ230JYg3WEqEC/U8RhFxxyY?=
 =?us-ascii?Q?zlFV5VVMiYXGlu4hOY2MsKP4uBG2wuBvDl7tXXjZ?=
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
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6339.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bfaca1-b66b-435c-c641-08dc7faa4ba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 06:40:56.9682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Su1QbDkZF/oFnL13mUXd8l0OHa/wZhHm+YVFjm6rHy3YoKZig/oJq0eR6LjgG8W/8K4zaoH8PgqvgPuRkTq5UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8465

>=20
> The only iommu function call in this driver is a
> tegra_dev_iommu_get_stream_id() which does not allocate anything and does
> not take any reference.
>=20
> More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in=
 the
> probe.
>=20
> So there is no point in calling iommu_fwspec_free() in the remove functio=
n.
>=20
> Remove this incorrect function call.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only
>=20
> This patch is completely speculative. *Review with care*.
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/=
tegra-se-
> main.c
> index 9955874b3dc3..f94c0331b148 100644
> --- a/drivers/crypto/tegra/tegra-se-main.c
> +++ b/drivers/crypto/tegra/tegra-se-main.c
> @@ -326,7 +326,6 @@ static void tegra_se_remove(struct platform_device
> *pdev)
>=20
>         crypto_engine_stop(se->engine);
>         crypto_engine_exit(se->engine);
> -       iommu_fwspec_free(se->dev);
>         host1x_client_unregister(&se->client);
>  }
>=20

This was a futile attempt to fix a kmemleak warning in host1x_client_unregi=
ster() in a very old kernel.
I don't see it anymore, either with or without this change. So,

Tested-by: Akhil R <akhilrajeev@nvidia.com>
Acked-by: Akhil R <akhilrajeev@nvidia.com>

Regards,
Akhil
