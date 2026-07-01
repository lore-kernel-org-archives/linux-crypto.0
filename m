Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A939733FE0D;
	Wed,  1 Jul 2026 07:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782891098; cv=fail; b=ij0Nqy8pUXz5PvZ7FH1204W+I+72+X/LCJ/ieaJ6ojzC4UUsSuxKvemp/7U00noremJT/HXIxz2Iw2RBO8KLjW60tNp4yURnHqwkUu+dIu6fnk+XcwpzXHXhPwrQJYh0bEHPtXtZXp2e3+58H8Y5FpPSC0FicrDJpT8YVGL8+MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782891098; c=relaxed/simple;
	bh=pc7h5uULeYS6RhyiyyeAtJGA4c4jTckwMuHPEBc6qRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j/VGmWHpFsiSbq9AIHTjGLO25l5wq73T78Po3Nlbgn6jv+w5SBcLKFbp/n16Xs/7x+eeOGs8Q0EcsLl46RMPpSBgAJm6IY5feqSimClny8+7BjHEIrPv579qnl9BPtOXRouVR8PDB5JheSekZsO15/0lmy8pFIPQeFq34+4Oka8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VCHBnp/K; arc=fail smtp.client-ip=40.93.201.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VCHBnp/K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBU/y99J8WTGfFv+ZJU9ZPBptqKlrj+4iQ+Fdymve9qlcn5R0O75u6fbpro2gBWNxoj+k74TbjGi47wfldB96HQApqIU03bEGprxAOy2x4j4gsDuPhZgihdUjFSrWtwKurosa0XGFDwKYa9nl6s6EFAy4lhhhLAhLiJ47ibusp6WwkEn3aO2K+Y9y1CFRcFiboLOKq97dKd2FVyXuGeAMvU5gibSVMN+ylOfkEsbKEBOX/tD/lXnpnmHJGDhIQp1NeLiPV/ajNKyIi9GF353lQdTOAc1bhd9cJ8JKxWdyiARwcMXJ63Td+dHTPBk8PiNJJZU171FOEUCmq0AFhpqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuV8a1CwzpzVDxsgDrgfy7XNpYOTGy0EFYQPFPpbjcw=;
 b=MN8X7qJFwBRRQn5WESPveBtC/E79HbvVRJJBYKpofQIvUV9uQtF0VUr/DDefuMk2zHrDmWMHxB45D6iSQxrHaEohdfqYo3wP81ZkCElNdBW587JFdpIIqTZJrYgEWYIA9mpAM43SG2EXA8XheJ9s3KxnvyCLWThhDSRCSxPYluPjueJM3DfDMcNRXMtJhjsirxD9JQTMKoGTlw+ENounh35SiC1wrOFOaFJHOezddlzjEokZqk7kcLTPWyUxHIZcExpegnvf+hgmPXf4BJ58abVaXGyMeRLOSe/82kj3KlnDKk1c9hkyw374YfNZ40CpAZE83MgLYDai/C62MGLSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuV8a1CwzpzVDxsgDrgfy7XNpYOTGy0EFYQPFPpbjcw=;
 b=VCHBnp/KV0xkXBtah2L7hRjtUm36VJe7xNmlA3eiI5w4Zsx8qMzqZ5UaAegCioqlCWOlOh6FsPNSYMMaQIvvFLRQ73Tyz/X6g0b5uRIcqmlyLnbrzluPl+AFBKOy+Eia+Fu3IbY6SqKxQOcoj6Hq7nZzJebiaPaxA5oJK6ti6lk=
Received: from DS7PR12MB9549.namprd12.prod.outlook.com (2603:10b6:8:24e::7) by
 MW6PR12MB8708.namprd12.prod.outlook.com (2603:10b6:303:242::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 07:31:30 +0000
Received: from DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6]) by DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6%6]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 07:31:30 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "Simek, Michal" <michal.simek@amd.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>, "Savitala, Sarat
 Chand" <sarat.chand.savitala@amd.com>
Subject: RE: [PATCH] hwrng: xilinx-trng: propagate timeout before any data is
 read
Thread-Topic: [PATCH] hwrng: xilinx-trng: propagate timeout before any data is
 read
Thread-Index: AQHdAtabK9gmDgDVD0GaZNSQvCuqerZYUT1g
Date: Wed, 1 Jul 2026 07:31:29 +0000
Message-ID:
 <DS7PR12MB954988025789E3A5F4F18FE297F62@DS7PR12MB9549.namprd12.prod.outlook.com>
References: <20260623060728.18906-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260623060728.18906-1-pengpeng@iscas.ac.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Enabled=True;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SetDate=2026-07-01T07:30:15.0000000Z;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Name=AMD
 General
 v26;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_ContentBits=3;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB9549:EE_|MW6PR12MB8708:EE_
x-ms-office365-filtering-correlation-id: 189d383a-28ff-4d0c-a202-08ded742c4a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|921020|3023799007|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 L97MEBipzZboF0aH7fTS12ZH9mJpID/apmk07bHqfVqPlFEXrJ2TbnBciKCRI6m7ZFhjo8tG7rM868BdvdojhTMi9JiEkfDFp8g27oXqJkbpFXTDM3nHnmbp8+C6izCXFV7vBEiG4MsdsXoR5zl2biptGrj9BTtCsM0GDdm6wq5n6LNgLw4rI0M8tn3Cyxsb/AJQLKTvNObBEcUdkdE0XglLDqLhzvRlz6iwahqJ1bZ5D8Kk3uvDa/G/DbjBMUto1d2UTVONYp3j1f5ZAzj1HH1YSiwucxxDLRCjP2r4z3CptPDSp7RRzS+ctm2v3RkqoTR3DLBrz9n9TuE6JmELLC7DaarwPlYWhz8APQJ0wAtL97BZFnKQl1ZPntO8DZKLx6G9F5hVJKOi7e9cgKqcQTfliFR9H6YjHTOZ5krghdMI/40fX758VZ7k0VtJ99h3n6vPbou3fddgi94y17FJ1CpqL29o+mqoqjLT9dEkmdsSKRicv8W08wpC+QrIX4X4fIJ4oOhUpwNyKsaGPXH4EjNwjnu6AdkfLOU4tn7wAgTfPQ/bMagk/KqSn0c3yVsdZvORZsBVPTscBQ2Gm4mkoMEGAoZa1C9rZqCKPRhim+tmhc7BVnC8ujeD5vvnV4s2yv4gsFL2I2xgJqzs+ZRlADIC6UkKaj454duSvhbYKhreie5/5Juin+P0+kIY4hD/PpyoKgxFecuNE6OBEUbjou09Yj31OsznlYPCMDsMxGoTvyY4CzfMP5FxlKWDjF9m
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(921020)(3023799007)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?D0Mo0kaP9xA/qOlY5cWX+6iYeZb1oZWpxUFOk7QJaB3g7SF3gmLXrH7CS7TD?=
 =?us-ascii?Q?Z4yVWcbTAlBb8IuIThUyCwyj7FhYNi4AhrCWTxRHD7cg4Cnrsk692lowmvOw?=
 =?us-ascii?Q?M8DzeMnzRnKzQrMNRe24DyooFSReAjrVwdPw0xZ07ad1PSBrLbW4qklF+Lid?=
 =?us-ascii?Q?MpSfCQMsDYzUvwLh6Km02ACJyeXAk06RYVK6h3eacMsJU8t0yOj7zn2OP0ss?=
 =?us-ascii?Q?DzK6K9hDwGF4Cuefl7j1a9vGEb7kc1qbAisBAwD8P1FXqLK2QrlUWp+XP005?=
 =?us-ascii?Q?j/TtSgjU5Uwb7/sCs2LKM6bMzh+FybbF+1NeFd//BieSLyZkRVcLMY16FI2U?=
 =?us-ascii?Q?g6fEPNJSPOIGD/WLeYjK82wFBSEbg80QEDbuXYy2BUyQCpfwpunKFRVQ4e68?=
 =?us-ascii?Q?b5T5ri3iae3octsmW/+7AHhS7ukE/aEK1uuGTP0dMGupkA1xV3EVAEy3oSf+?=
 =?us-ascii?Q?KZv3zbJ+iIOkOuUakVpSel3Llfii1+NpX/3QSJuJ0C6YrZAOj4+pcMbAwFVD?=
 =?us-ascii?Q?NYEk30WYnw73+/kfmqd+RIda00e+ZntUzAVWCNmej8zrWG5VZUxj4NZ2d/zA?=
 =?us-ascii?Q?2+I3ukM6VOed3a8JPgxGVHt1o7geGIFw1b//hxyffVqnbq7i5sWBsPrGHFyD?=
 =?us-ascii?Q?VVDhhFBHQ5EIWbY6u1U1d3Oycli2f2S5zNSS2BiJ0uH1C0JrB1FvtiL0NHxs?=
 =?us-ascii?Q?uZpviqTtL3w8WsYbl4NHF1Ca3tWlXLKk5DrnSpFiZGJ+ssBCySpv99q27LzS?=
 =?us-ascii?Q?zupt1Q8lfOedIRsEkVa7emkYBA2qvYHS3CAutosLrCDjC+eJYwX5KD7x9fRh?=
 =?us-ascii?Q?VyPSTqW06pScp4cwKvdNUGSMQQEiwNg5gY7RS8HZ+j5Rh8wsXqzc1bitzewZ?=
 =?us-ascii?Q?6U5gvsrr5NFwXANwDUVaPLa18AWzL4rhOK9DqPqZxtrwFgJwOyugck9/5+XF?=
 =?us-ascii?Q?21BnZiUgNRJ1GPqbeCfEScqmoVHGqCMfsltLlVKqX7FdHv3RXfmQoWP04goJ?=
 =?us-ascii?Q?Y5d0UDhOmfhqcAvJy9n0ED/r6a0aeidnEsMAMWkJYRFnpny2buPQqV2WxbuQ?=
 =?us-ascii?Q?BAvm7UWwEKHm7S6DiKBYaC11xMoU6I8WKEVsg7uh3wX8p53sRAgllFBbdqjG?=
 =?us-ascii?Q?2EANQzxTRsaXDfK4Wj9YBbQ6dZFYBLVtbkPc14GX8pEPliJIffyWkb3KLtLK?=
 =?us-ascii?Q?TDCkwYQJDHYdDcYQKa1uwn0CVHP3XMJV4WHAEz081rv+cwtapy8dp5MKZ4Um?=
 =?us-ascii?Q?ClMaAYBCpkJS+8DoGIKeFVpx6V89h/SYqhBwMAc/fJxpfu4IHlAop6p2JKJP?=
 =?us-ascii?Q?hVEtNnRwFkNZ7/pnjc5OIcGalcnt4UI58Trz2nCOMbTlJAXkJIJU9SFEXrwP?=
 =?us-ascii?Q?zKAU/rg4Zeuu53uRTIlW1g3+YPgWnw37klv8cScWg7wNgF6QWuDyWWBKVkKb?=
 =?us-ascii?Q?5ECBJO2R1/a2pwLvP/84TKZnFZ7TGxxUBR9bT2R/OIsMfqjkq9aaX+uhvzFd?=
 =?us-ascii?Q?UapURMe53HaBxt9wau0Fkw+dQiYhPirCYKKC/sfKfM91EFkT3q+T+5RVPAXa?=
 =?us-ascii?Q?T05Tuy7njOlOqYavpeoJl/xBzFUjVtMKTopNgDpenphvq2g3iz0m/LZkWeC0?=
 =?us-ascii?Q?ktCp8jpwhdDOs/gCV3vD+GR5s5HgbwsdTkG5OOlTc/j6yX04UdJ/ZTdvObZl?=
 =?us-ascii?Q?hiWS6I2K2wP/2mpTJt0gohR5QddbqNSJnaopqh4N/elclXxc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189d383a-28ff-4d0c-a202-08ded742c4a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2026 07:31:29.9980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlEz3eWPAfFDIC4xFo87qb8maMS9LBu9o9ZueReAaR2tYf2dz5EFJMTjXU2M5Kt0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8708

AMD General

Reviewed-by : Harsh Jain <h.jain@amd.com>


> -----Original Message-----
> From: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Sent: Tuesday, June 23, 2026 11:37 AM
> To: Botcha, Mounika <Mounika.Botcha@amd.com>; Jain, Harsh (AECG-SSW)
> <h.jain@amd.com>; Olivia Mackall <olivia@selenic.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; Simek, Michal <michal.simek@amd.com>; linu=
x-
> crypto@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Subject: [PATCH] hwrng: xilinx-trng: propagate timeout before any data is=
 read
>
>
> xtrng_readblock32() polls for 16-byte chunks but returns the number of
> bytes read even when the first poll times out. Its caller then treats a
> zero return as a short successful read, and partial reads for full
> 32-byte blocks can make the tail copy use a fixed block offset rather
> than the amount already produced.
>
> Return the poll error when no data has been read, preserve partial
> positive returns after some data is available, stop the generator on all
> collection exits, and append tail bytes at the current output count.
>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/char/hw_random/xilinx-trng.c | 32 +++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/hw_random/xilinx-trng.c b/drivers/char/hw_rando=
m/xilinx-
> trng.c
> index f615d5adddde..4a1a168bb46a 100644
> --- a/drivers/char/hw_random/xilinx-trng.c
> +++ b/drivers/char/hw_random/xilinx-trng.c
> @@ -87,8 +87,8 @@ static void xtrng_softreset(struct xilinx_rng *rng)
>         xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
> TRNG_CTRL_PRNGSRST_MASK, 0);
>  }
>
> -/* Return no. of bytes read */
> -static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int
> blocks32, bool wait)
> +/* Return no. of bytes read or a negative error before any data is read.=
 */
> +static int xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int bl=
ocks32,
> bool wait)
>  {
>         int read =3D 0, ret;
>         int timeout =3D 1;
> @@ -103,8 +103,11 @@ static size_t xtrng_readblock32(void __iomem *rng_ba=
se,
> __be32 *buf, int blocks3
>                 ret =3D readl_poll_timeout(rng_base + TRNG_STATUS_OFFSET,=
 val,
>                                          (val & TRNG_STATUS_QCNT_MASK) =
=3D=3D
>                                          TRNG_STATUS_QCNT_16_BYTES, !!wai=
t, timeout);
> -               if (ret)
> +               if (ret) {
> +                       if (!read)
> +                               return ret;
>                         break;
> +               }
>
>                 for (idx =3D 0; idx < TRNG_READ_4_WORD; idx++) {
>                         *(buf + read) =3D cpu_to_be32(ioread32(rng_base +
> TRNG_CORE_OUTPUT_OFFSET));
> @@ -119,27 +122,40 @@ static int xtrng_collect_random_data(struct xilinx_=
rng
> *rng, u8 *rand_gen_buf,
>  {
>         u8 randbuf[TRNG_SEC_STRENGTH_BYTES];
>         int byteleft, blocks, count =3D 0;
> +       int full_blocks_bytes;
>         int ret;
>
>         byteleft =3D no_of_random_bytes & (TRNG_SEC_STRENGTH_BYTES - 1);
>         blocks =3D no_of_random_bytes >> TRNG_SEC_STRENGTH_SHIFT;
> +       full_blocks_bytes =3D blocks * TRNG_SEC_STRENGTH_BYTES;
>         xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
> TRNG_CTRL_PRNGSTART_MASK,
>                           TRNG_CTRL_PRNGSTART_MASK);
>         if (blocks) {
>                 ret =3D xtrng_readblock32(rng->rng_base, (__be32 *)rand_g=
en_buf, blocks,
> wait);
> -               if (!ret)
> -                       return 0;
> +               if (ret <=3D 0) {
> +                       count =3D ret;
> +                       goto out_stop;
> +               }
>                 count +=3D ret;
> +               if (ret < full_blocks_bytes)
> +                       goto out_stop;
>         }
>
>         if (byteleft) {
>                 ret =3D xtrng_readblock32(rng->rng_base, (__be32 *)randbu=
f, 1, wait);
> +               if (ret < 0) {
> +                       if (!count)
> +                               count =3D ret;
> +                       goto out_stop;
> +               }
>                 if (!ret)
> -                       return count;
> -               memcpy(rand_gen_buf + (blocks * TRNG_SEC_STRENGTH_BYTES),
> randbuf, byteleft);
> -               count +=3D byteleft;
> +                       goto out_stop;
> +               ret =3D min(ret, no_of_random_bytes - count);
> +               memcpy(rand_gen_buf + count, randbuf, ret);
> +               count +=3D ret;
>         }
>
> +out_stop:
>         xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
>                           TRNG_CTRL_PRNGMODE_MASK |
> TRNG_CTRL_PRNGSTART_MASK, 0U);
>
> --
> 2.50.1 (Apple Git-155)

