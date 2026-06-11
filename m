Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010049.outbound.protection.outlook.com [52.101.56.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99F421A95D;
	Thu, 11 Jun 2026 02:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781146381; cv=fail; b=tnrCcOz/A7rbNLgFFSHhV9RjG+obKE9c9iLESHdGmVaQAkhgG0YN2qaHE3RRFBPYbW0F5peaX67+IOCP7okmvCPgBU8EOPKrbpk62fhULPTFCuCopCL2ohmryBDrEtb8tpa8auWENZDrx22/DmFkvy5yzQCiex6hllwmYOnAznI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781146381; c=relaxed/simple;
	bh=d+xzT3dhgauhk+5az6jPxY8L4WgguVyR3aJCIuTPjCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FS7XIxgHYzQDOlhWxgg/t5nGcIIJ8fmC89ffdgTrfv303VfYUJwA8hXPGbxCj3eC2SxfCdV6IeKiSY9TPcGcLSTjkrfEajx4GSOTcQDI7yvO9YcVSoNwOUMmVxPWJSlSfyyu4Ase36GrFz8KsoCL5et2Xi1y7phbFDNXPZqdHRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1NbTHbB5; arc=fail smtp.client-ip=52.101.56.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1NbTHbB5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hw1Ye/DNHcbNStjX9p7PiCrQE4GvJDW7QOU96W6liLYI9Ug8LatSU6fed/bKUnuiqp7n7mk/Yd/HLW+/+xgl0hDnlA25wMx5fmXqUitnj6H3NAGL5VBj0VESSJEq8DdsutnP1nwYBNfeu/65JRAYEr0dYFiAPVdlHR/QZqtQGeKG1sRYXzrzJUCIeESZ3bND3xvcK/do+nYtvb71y71oE8yE+oHJq/mKEnkWMo+ygfm/m1vY65u7HQG70JO5J63F5l/yEZLbbbNMT3haniiAMUL7AvL25C8sS9SvSl8XW7LVab5CwYG2ASUqykwRkBEC78IIlqObA+8EeGmCpgthcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lV1aAtPyXCcnP+P6XkpiCKHOZt6IpgeaVy/0s1tJef0=;
 b=FOJJo642y9uZNn4U5nwhb5RlJ1wfXkAtcR0o7eM/Mj2/TH8JAYfz1hk5noJRx7MAmP9riOUzfN+ghS1/0gqrf0EUet4cn0JGGZf3W+E4IgOFA5PX7MQHFBKcd1meqlZ51dehhaPQCcLEnZC5hz8JU8Q/W+WillVc94NOncjn0a50c83l1FPp/QpFvsHNRzRcz2OJj70rvzZPKkjvDswVNwlbrbPVW2xWYi1VN4KXUqecexNdvBMmsGCnSiduqfN4Z7IRaUKmYTo2eVBqPT7oJca9kTtewezC2Sb32swPb4d7aQhCtCW7qD12i300Nn7GI130rQ99axEuAs6/BrYM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lV1aAtPyXCcnP+P6XkpiCKHOZt6IpgeaVy/0s1tJef0=;
 b=1NbTHbB5Fot0jY1vBNELVsBXOTcszsyFdk8yxXa3H0pI9MoysfmrB1hKYY9OYUhNavUMYF2FcPZR5TodvNve6yWh/Kbsu1+74q03TIRfCp8kruVEFNZbu4EppT3wDygA1Kt1xcp6sM5Xq/GvbwtAeGaDJ8W4AYdc7yu9eQbTx/A=
Received: from DS7PR12MB9549.namprd12.prod.outlook.com (2603:10b6:8:24e::7) by
 SN7PR12MB8602.namprd12.prod.outlook.com (2603:10b6:806:26d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Thu, 11 Jun
 2026 02:52:56 +0000
Received: from DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6]) by DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6%6]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 02:52:56 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Eric Biggers <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Botcha,
 Mounika" <Mounika.Botcha@amd.com>, Olivia Mackall <olivia@selenic.com>,
	"Simek, Michal" <michal.simek@amd.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>
Subject: RE: [PATCH 0/4] Xilinx TRNG fix and simplification
Thread-Topic: [PATCH 0/4] Xilinx TRNG fix and simplification
Thread-Index: AQHc8TLoUsF1hl40KkacAzPG2NSr+7Y4t2RA
Date: Thu, 11 Jun 2026 02:52:56 +0000
Message-ID:
 <DS7PR12MB9549D4679D5011B6B25FEA0C971B2@DS7PR12MB9549.namprd12.prod.outlook.com>
References: <20260531191738.55843-1-ebiggers@kernel.org>
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Enabled=True;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SetDate=2026-06-11T02:49:17.0000000Z;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Name=AMD
 General
 v26;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_ContentBits=3;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB9549:EE_|SN7PR12MB8602:EE_
x-ms-office365-filtering-correlation-id: b3d3e020-7b35-4fda-2ebc-08dec7648a35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|38070700021|18002099003|22082099003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 du1buuNCfRO2ehXdeAb5XCzlarjXh3yEnpWC4o9CQ9Cixk3yXeOroKpDOmWk1ROLMMB97VVgUBgMx6wBA4HWNugqYsd1krgpYbNQNu7GYbb5JUuD8AXds9vwK1D44j6kh8gTF6bUv0HQ8t3DiuOrMHyntjKiW4DTpJ200i4tLwg8MMgiLB5hgngLaE4oYYxbXNs7QH20wt4lxa69m94RMOWcKktE2jD86BptGWCPm/HYSKk9LcV/sOxSVyL+NLVmuoPUdk3L75fcetqArLKLD6fyBDSkUjstkfmZrL/i4QVlNinIRZAbg+8+6F/Wd5pDiGbldLGWthlBmXT0H/MB3bYALQvtOgk5/QDyPLtYMaZx0pE+yuwLWI0b9XYSkOwOyxdqGaIJYdKvXDKAM3g3+nMGZ2c4/ea44XzxWLrFVI2fGIf9MpQ+C3XTMOVjsZzl/tt5mjpQs5vlNDPhxuLbsWH7aPNS4QRD26V4sOtko9cf8OKMsUDjYXS+tZNwcYEnqbIH1TxUCSEUxZ9QK7kEkEhg0y7VpOGrI/cT4zRHvvesx62C47WBB9SATwKHnMFZoSMyQMlx3a/Au9GfOoD3Qkd+kDvUoY/Z8qf2SNVihVlivD09r1kFa+gW7IO/0qVg4/id4aROGthyF12T/e79D2r4apTSJdVvUaFSwPAebDgV4h0vietWJj2DtmdFNkKPkStE/v/kN9WWMop6t4KLLxPsMh/fexqvvO2zM+6kM7AtRoZ8/YhlMz7Cm076oLi6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(38070700021)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iwN+npcK58zEOleWerCO9BRZ67GRRYv+Pr/WNrOItUsWr+BmhC7Q55Uz/Pk1?=
 =?us-ascii?Q?CU4sifzIJ917sJAwL7/ZuKOkIkUb+wjDLTM0/z3Ph1lIZz6lKI1Oq+H1My+3?=
 =?us-ascii?Q?LJTOz5xbQnexHIp0H4OtUXAKOcnG/DwUy2aCfS0vZynsKHTcViSTKPBJSPpX?=
 =?us-ascii?Q?nyUSP5oA0Pu0IHtPAlaEYrEM+4YbuOkhk8IffwIdI4jk5ESV/ALUg7dygarG?=
 =?us-ascii?Q?hdvN/Z9j81MSTiUPQYs4pQPS94Kq/vMIfvpXyNw3FPxSuiVqg3/evyWisEYK?=
 =?us-ascii?Q?/xubg6ivnPZKzW86LOQiCDsL7A90HKBC1q/OnpPAZu3ya0JgFIXzF1EM+XiA?=
 =?us-ascii?Q?SxASvZK+JyfhG6P6wf7sjAeNhSvbx9QPqoSiuP1WJmBs+Mx7vbxjk6xF8FwO?=
 =?us-ascii?Q?mSR1gxnwkjbxFPAelvpCMDp5nzJ3/OlfHRpjCzxASS1J/xHo8FuiG4viiaNO?=
 =?us-ascii?Q?tm5KaCBZSmwJN7DMuxVG6InbFAo+TBUp5T/FrWEG+8Z5k/2RQzMCuSeCSKkO?=
 =?us-ascii?Q?b+QWP4kcUh+QXtBmr3VeEGvbgPOktgJIXp9lSF09ip/vtiwwgD4kiI98PqzS?=
 =?us-ascii?Q?pxPBbNj1LoreJpCPpa2KMHKCMzH+/owZ0RDZWRiH2psdKdlAhQbGZCO1LlWW?=
 =?us-ascii?Q?JuwtUSQkXZ1Ns/DWvwTUA5J7SbmU2x+CwptiE/J9I2qejX3TVsuyO4CGSyt2?=
 =?us-ascii?Q?DwaZYai6MpNr7BPyyDb3/xRPF2U366kGZTDb54FR3V7dP/kwFndIYaMlVKGr?=
 =?us-ascii?Q?e+CjuFJu2CpH6tEUVI1tjwXqK6mDnLC7anZ+tCJ/sUr1kpXdxGGr2kfmzAxh?=
 =?us-ascii?Q?Z5g/7oojRtNiHMrwwVxjJi/ZupwtYzksCbBmjbrNJrxIpNoo53J4BdfVa/W6?=
 =?us-ascii?Q?YzXr9syNWahEkE51T9arlLPswwst6NVErpYJtUcfUU6V1SXZ3Q6OHFqB8DLg?=
 =?us-ascii?Q?7zxZZivVvk73WvTJLKVf0MU4kQw+i30td26VLNI0u5oNOrNGRcX837dfgBw9?=
 =?us-ascii?Q?xPgZTGavxuxPN7XmPR+htIAF56TjrV3hX39+tw44vVhm0Jn5d9bqRUf9zDDU?=
 =?us-ascii?Q?WN1OhnzBRdVKIjsuDsF5KCKu0KV+60j2gc2iroglXOdFWRk9AT27KYD+9Pq+?=
 =?us-ascii?Q?ka/URnX0RvN9pJl5NdqWB3Gi+9FNBdj5jms1VVFqlrEh0/E+/g64q2p+NVPA?=
 =?us-ascii?Q?QyFxOeQx81Nz3m3DixEr/dIn2cW4ipbI2eMQN1gAQ1hkGsvCu9lEI4xa2Kjj?=
 =?us-ascii?Q?EXivC8WnXjHjFr3zXRu7bKuzEO85Yg4KMlLO69yvvSXren+iqnrntVVqbKAA?=
 =?us-ascii?Q?VX2T7kwTHuXv8mgmMnbCBoG+xAM/ztqXcriskZGBvtECV7yW3cnfdAiN98CO?=
 =?us-ascii?Q?+h8WMJ8gp/Ni6nxJf7cNW6WDEOXeBWWVWbzVykd5cJrqX1bidujQxdX/kgY5?=
 =?us-ascii?Q?uRShPMHu3pw0rbMm5sx3pd0W8PWOpaFgjpsDNpGyFPDtF+/KZTw3ZY584K+V?=
 =?us-ascii?Q?N+wU4JqrRPkNv+v3MWqCnxkZWYQ5BAKaXWViA9eEMpqSLDzIFavCggsgXiZv?=
 =?us-ascii?Q?zvJVBDWCs0neLhRIlSiTfz/XozRWzij6bHSqOuepVcqE/cFCIcWRhnjBZeWi?=
 =?us-ascii?Q?smMIbxmojqzTVz7mNZtoEACvbGx8jEOm1NbQ47yR54VVwtsCQhgBuIayv1Hh?=
 =?us-ascii?Q?WhUXSwxx6/1r0GLCAoncueT/AlFgCGEn7shX8f9GnOeLL1lf?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d3e020-7b35-4fda-2ebc-08dec7648a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2026 02:52:56.2534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: btIYMoMd9zPP0xrriejz8lk40jzVuxDM4W6yWtOMdgpGtEZyjaank4WLbg6rviXb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8602

AMD General

Acked-by: Harsh Jain <h.jain@amd.com>

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Monday, June 1, 2026 12:48 AM
> To: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>
> Cc: linux-kernel@vger.kernel.org; Botcha, Mounika <Mounika.Botcha@amd.com=
>;
> Jain, Harsh (AECG-SSW) <h.jain@amd.com>; Olivia Mackall
> <olivia@selenic.com>; Simek, Michal <michal.simek@amd.com>; linux-arm-
> kernel@lists.infradead.org; Eric Biggers <ebiggers@kernel.org>
> Subject: [PATCH 0/4] Xilinx TRNG fix and simplification
>
>
>
> This series fixes and greatly simplifies the Xilinx TRNG driver by:
>
> - Removing the gratuitous crypto_rng interface, leaving just hwrng which
>   is the one that actually matters.
>
> - Replacing the really complicated AES based entropy extraction
>   algorithm with a much simpler one.
>
> Note that this mirrors similar changes in other drivers.
>
> Eric Biggers (4):
>   crypto: xilinx-trng - Remove crypto_rng interface
>   crypto: xilinx-trng - Fix return value of xtrng_hwrng_trng_read()
>   crypto: xilinx-trng - Replace crypto_drbg_ctr_df() with HMAC-SHA512
>   hwrng: xilinx - Move xilinx-rng into drivers/char/hw_random/
>
>  MAINTAINERS                                   |   2 +-
>  arch/arm64/configs/defconfig                  |   2 +-
>  crypto/Kconfig                                |   5 -
>  crypto/Makefile                               |   2 -
>  crypto/df_sp80090a.c                          | 222 ------------------
>  drivers/char/hw_random/Kconfig                |  11 +
>  drivers/char/hw_random/Makefile               |   1 +
>  .../xilinx =3D> char/hw_random}/xilinx-trng.c   | 134 ++---------
>  drivers/crypto/Kconfig                        |  13 -
>  drivers/crypto/xilinx/Makefile                |   1 -
>  include/crypto/df_sp80090a.h                  |  53 -----
>  11 files changed, 37 insertions(+), 409 deletions(-)
>  delete mode 100644 crypto/df_sp80090a.c
>  rename drivers/{crypto/xilinx =3D> char/hw_random}/xilinx-trng.c (75%)
>  delete mode 100644 include/crypto/df_sp80090a.h
>
>
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
> prerequisite-patch-id: 07e982b663ac3f8312ca524f6b91b5b38661df5e
> prerequisite-patch-id: 72064361a8f36e015ab0b7e1fa4d364b40d90506
> prerequisite-patch-id: 8978b8e0db7f47935e5f6f0aff14a97f55d3073c
> prerequisite-patch-id: 6aa0e3e93a008279d71e535a3d0cf48643f55e19
> --
> 2.54.0

