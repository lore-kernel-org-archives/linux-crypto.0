Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D993FBB0
	for <linux-crypto@vger.kernel.org>; Tue,  7 May 2024 03:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715053418; cv=fail; b=HqghUxM5WfvtDojr2gQRYUDcVuki+ZHmMX585uUCSyguA/YC2gqO83xoT3xSawKFoIYg+/Yv4I7mCWfueI5vA0DtVOsoKNHb0aXd6DhT3xPDre4GDU8CWllQzxqUJK1ZjwczeAY/XDAy2h2pjjTLhwODsdDW113gUd+ED3po2kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715053418; c=relaxed/simple;
	bh=dh2NA1wya0bab+wJG6m+L8vbhtJvzzS214Wh703Q0yc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QHWYBtpiFy3xtllzNhF6Um2omsAc8T7TngLLavAPk23slVMDCcGquL2lBYcIVSDlUf3nRskE0CWiUsYMK+VPX42R+GKaZjJP+v5/wrvJUEpLW2dfg3wXOqRBL4IhR18pT6JR/Drblqac/PlfdGpmgZAFE5MBFhwb7zBp3TG4S1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Th3Kf7b7; arc=fail smtp.client-ip=40.107.100.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Th3Kf7b7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZH++wBYW364M/HzXZ6Ps4IdeffUygbfzVxc75T9Ocq6boCJVwcCdwxpPkeJgjDuPD6X1GEOLaD7p7bYceM9UnDZieczaIfzPPVXH4ytGYqig4X2+Qkoe76D5xEx2Su+oDgXdUi9oquH+z/fZtCPIZXWLKJb/RQU3muvip6luJr9ilussp+1/CRFEtK9UWCgKhgbsTFTBXkMWrglIDBlxNNn0hJSY/s9yeF6EGs+UPJJ6vsrAUXipQeHLgrHnuXNJ600MkXJyaZORUJhIDuQFEk2Zgz06H6V7zbkYmDVG2C+C2qlKEn7GMigoqGemiD0a75aP9b3rQqaxdMLz/xuONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eth+hUfbpuxOXa38GJD/VXPrIoKvoXUAfvwwvWhAyZ0=;
 b=jHUbGd4Titvezw1PT2vmYjs6YOmV/31vilWt1abZP4FNb8p+yESs8qaj+m/fsRa9Xp8bVierhvGFMESDHXdUay27PaUEbEwLSLMgWQEdUvkJS3YLtef2aSrnSJwEAWJ4NtVshhbC5NWLnoLUuDf8CghWT4UdlK5HbpVKL/5w0muoeTOQnoWQB2Dpq18+CBMqYyt+fGHL3quhgsFd3qNnABDVW5bbGFZBrDAWDLjTcmY/2ti0hI5huVCJeJFYKpYfXTZGJxIftO1GJJGIud1zngvG6rCxRSRS3n+EkOc13a7ywFssuJ/FXgOLL33l3oNUiIGBchU48pePTkm/bdEsdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eth+hUfbpuxOXa38GJD/VXPrIoKvoXUAfvwwvWhAyZ0=;
 b=Th3Kf7b76bre/OrcBVhVOB7aimBMmhr57ScyObr3VQwNoH7z/g00Cc+TouP87NM1wxHnJOry12XkHXScZXPRrqtFMxg0N9yXsygVvY8JSWxt5jhrfr2Z9eyydligRvK7hgsvFoCw0O6mYdJQ22cBoFKNS+6D7Eu2ikH09Cty5Xg1oDyRsQpoLP+jEX/XtIU3ySIpNrl5lvtENdJ7TkcIXj+25bgf+ReJh0kGeGZsBKPLfVcDPC+3q85JqM1BYZXckyViE6dKDaTR850zcjeI4JEtV9fPw0Qcv+hIs9yRGwR4g2nBtF2EW6w7QDBy9Prbkw06yg7oIE+3pjC34h9Fag==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 03:43:33 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 03:43:33 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Topic: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Index:
 AQHaha3gsfDBlfEn5kWsP3WoOvnfvbFkS2CAgB2iPLCAAEO4gIAAB7lQgAM9E4CABd+cIA==
Date: Tue, 7 May 2024 03:43:33 +0000
Message-ID:
 <SJ1PR12MB63390D8D34339BF2096F4566C0E42@SJ1PR12MB6339.namprd12.prod.outlook.com>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
 <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <ZjS1w5S-8FGOVLtb@gondor.apana.org.au>
In-Reply-To: <ZjS1w5S-8FGOVLtb@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|MN2PR12MB4189:EE_
x-ms-office365-filtering-correlation-id: ba1234cc-6b69-4a93-0085-08dc6e47de8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?F2v5Y6CIbnSF1PJb4MYNbS3MNCmUJ7CrUZCn9gbt0mN9WuEG81lDFLIzoVTS?=
 =?us-ascii?Q?yzkPePOoMwTdtQFnfIGzLeN20C3uZgLY+6uOHoEU6CY/RsS7Bhg5cu9ZjmwZ?=
 =?us-ascii?Q?RwuvqMZdrkyk4/70v4HPwaiyB8Qh/GtJUmufwUaSHzikc3L9GvPjrkZ8s2kA?=
 =?us-ascii?Q?r41KlEBmEtJcaHdRpcfrOYD4nmuCLxDpmv8R9bOgNiGnp/2dN8v8BpeQf6aT?=
 =?us-ascii?Q?VezYx2ImcI6hI2xj2l/SIT+SAGdBCepfd1/5VWrKE3jtu5G47S4WBOpsPocl?=
 =?us-ascii?Q?RjDGddTA9dS65y5u5tP0xGchEYnRnNBq7pT+22pjFyirmdSqFXS3ps2mqBKR?=
 =?us-ascii?Q?2K/yk7Ml5zB2oOTZSuvMA8iFORCHCU2cDckec83HkUnqf12v+98+5kP3JwJw?=
 =?us-ascii?Q?VlhJrDgIcsVYlVg/XWXiD1itDHyDinqYsSDjIRwUL2chx6f62lFodZOR87oz?=
 =?us-ascii?Q?gd1YrSucmAC2J/xoF91GMH68Kks7nZqzjL6LhmqxKkUcvyrTuO9eo0KuF/Q7?=
 =?us-ascii?Q?FZ+DcfR5OZrB70QXXcCjrPXS7fYHGJAlNmd7Km8HDgs3RZHCxS02jNHWOGST?=
 =?us-ascii?Q?7XRBQfM+YPLyHCfjcIJbHnQ8R8Y8J3YY+S5wVsub1vYl3K7heRphJHkCvDVj?=
 =?us-ascii?Q?ToCcfQIvUC+Xv6VgnMT0bUuQGIR6tq0FgWo2Nz8vfxAsXAasB7YlX1Yad8lX?=
 =?us-ascii?Q?pi5O53TiVSfJ8W3kGTAsrxMiB4kASjYMhJBrd3YF8MijtUzgcl1GH9YScUpU?=
 =?us-ascii?Q?igLPyay4HnZemiDQTNKHhh3m7dZKsSYkh8GL41hEur0gAjEkHRroVz0VxNa9?=
 =?us-ascii?Q?g/ScjREMK66c3oRY5LvDVeW5ajDKhQdbgvg6ORqcks5SeR3p6uXp1vhWe9mZ?=
 =?us-ascii?Q?grqqItU/CgXiKqRUt38kjOCTHWXgbX+cAnrlKQvjTlvkqQTm/b//jR/S2dM+?=
 =?us-ascii?Q?p/2fW8Pgtn5LH1de964DG2RptNpsLFMuoy1iZ/wepXvmNgRe+YVX+2y951rQ?=
 =?us-ascii?Q?A7A4TYO6jxf5C/JnQ/r0tsq7RxjSG9xiVEPqeFI5fWzgYQGhBWrh06cscKgR?=
 =?us-ascii?Q?FAax8WWIe7ZDCsJuNRPWxfOJgct/acvChzG/SbUQxTTkGt9OPcRldURz2CNF?=
 =?us-ascii?Q?NoWT6TCTN/HYNY1cpI5fZLzNG1sn+orny8qA1pcrFcFiDDhK1Zs6wR47UTMS?=
 =?us-ascii?Q?cxRGGYetvw2IUusvhtjpOdzfEVjqZm8Hp7AAAaGhVSfOCTcEi/XYfozPTrap?=
 =?us-ascii?Q?t3NpfZiHCvYyPmGvtSIb/Jppjt3XH5G3DT6x6485a1iXpCTHx69Lt3+NrwOI?=
 =?us-ascii?Q?Kfyj37Ij5h3SWu/GqKiKCdFIfm+6Qfs4yFv2D+tM6vlOnw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qJi9+yhTsT0uZAQyWTwgLw6B/tuCM3l6sMSSknDjUpieUm5p7+ckEvQorTSK?=
 =?us-ascii?Q?UYf0FNzEVB/gOY1XvQF4MGSWl3tzlvtelgYLJre7Bfuhcwz0nFFFkM37NwSQ?=
 =?us-ascii?Q?eMQ3y6syyKL+IwzfzX9urEZ57WSbb/KeJIC0Sgsk/8De0geqMTdEh7nenGTU?=
 =?us-ascii?Q?llIghlgWNnP3uuDOIDdO/rup+LExGR0DItmXcM4+QdyHY8c+lqL7zBE1T9pw?=
 =?us-ascii?Q?vk94IRJCxtEYbED7WFBhyAbL7+dfCxfxe6jAtp02NYUDpkc9+tWYriyBwkBR?=
 =?us-ascii?Q?Nj/o2P+Nnrin9Chm92j2sEcfGjwDPgJmyb4DmHzJeLp7Ya6JsE3aAGJIQe4p?=
 =?us-ascii?Q?pe1sp+TS6dlxRUvhV6K2TtTWFlQiO7MUuzICvyMLCXAKQNoUJjiP4tRx/Yrt?=
 =?us-ascii?Q?BcpIqRUkddb+3T+YVk+b4eSxHc94ia44mIGO10RXiRj9lwIGoGNyDWFbtl4V?=
 =?us-ascii?Q?u/PuBEusSIiRYXEtP4uinnm4DnmzM+d6TkQQkIaQDLvCpkf5Xb7TkkjgzbcI?=
 =?us-ascii?Q?NSklMFQEwdZgTn9zHJErtSkp3of4WMe9hdwI3wp/MT0WHtPfGagrsVoHa9VT?=
 =?us-ascii?Q?jHYVFyPuMWVnGUkpohoge05hEErU9mcIStjh005HjhYdXcW3lKuEaZRT29cE?=
 =?us-ascii?Q?R6RiN0h5Z0CKVdmnghpxG9b7ZEIgp9xh5wrZW+CE9J77f80Hlwhv/O3LFVfR?=
 =?us-ascii?Q?CUcZi745WAQVcXmMEA5La8/OWe+JC0+s+YpKqr+l6klMYP6irioQ+EkZDE8r?=
 =?us-ascii?Q?ELLVCH12wIl6gzzjwh/bAhI+pDK2ok/e6MufVbHfzvGbad2ER2rqz86qVp/9?=
 =?us-ascii?Q?28owtS7QmQibLPsP/c2TG+SYxdS9hSFj5Z4DjpNZqD2Fs555MliMdVrbuXCd?=
 =?us-ascii?Q?ld9huVk34+mh2+tc/TYVT4OxtAX+ywcu2Bfk045rcwGLLXShvxLGV90sVKPJ?=
 =?us-ascii?Q?fES2Ii9EkDPgKgN2HwKmnTdFR0/HA3D1jZo7xCRiManYa6Z6gDtSUpL6khLR?=
 =?us-ascii?Q?57MZU2qLYnf+rijs/DFqvq1NqihFIOcZ0tXCfcydN4Zo0nrTMU0IVZC95QQg?=
 =?us-ascii?Q?z1vwfuS3WagS4evGBE5bLZ8NM2+MXgpmlNaRV3GV5S/x1SIG70AIeZ/92vH8?=
 =?us-ascii?Q?5loWHclW00QKluSmrsySRrbRlneXHa1HWmG/Sj1oaw6fTEwoP/Q+my3zOysD?=
 =?us-ascii?Q?8fWfwZyXLNTeVornGjK35mKPfJZUzYFjPoHz3YiKpsKY+3iyr1EGKh8wCd3g?=
 =?us-ascii?Q?DC1a2W7eLLc83SarmA4gbqdJhurdsKkkF3g/OUu4ql/Lvd4/Id83YNKIcuSg?=
 =?us-ascii?Q?wAJIQDJdvv1GCFTzJxqtosMBjJ6t+6iNaHt6OIAHj4lBW7Dvi9P24OU91+S/?=
 =?us-ascii?Q?W11LwVFk1vs2i7GXldlkDqUBPx6AFaAvTHURwZA1eAqkbouBMNRXU1CEK0PN?=
 =?us-ascii?Q?cc+VHCUK3aP7OuDvOqNn/hS4FpMjTeRMBdkUtTcmoGbT6IpcuYL/h1SLKyge?=
 =?us-ascii?Q?cxFcb0lGmjA28hFeOhypxzr4UPXqbb5DpT94TIorl6g+RkL93/TIrakWiEjb?=
 =?us-ascii?Q?GYijixdMtoOFUS6tcxy5Gd/2PxaWwpIVO/lQQsdR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1234cc-6b69-4a93-0085-08dc6e47de8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 03:43:33.4672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHN8dm3IxHFZhR/FMccC+NjGQwBxVo/JcTbXh2/ejvsrFYbCrU4eiAOjGqPPbWAhc1KtsnfKSlb4Rb6LeD11fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189

> On Thu, May 02, 2024 at 02:56:42PM +0000, Akhil R wrote:
> >
> > I get the below error. But this is because we don't have CONFIG_LRW
> > enabled in our defconfig.
> >
> > [ 1240.771301] alg: skcipher: failed to allocate transform for lrw(aes)=
: -2
> > [ 1240.778308] alg: self-tests for lrw(aes) using lrw(aes) failed (rc=
=3D-2)
> >
> > So, I suppose enabling the defconfig is the right and only fix here?
>=20
> You're not supposed to be using tcrypt to test drivers.  The driver
> will be tested automatically upon registration.
>=20
> The tcrypt module is vestigial.
>=20
Oh. Okay. Got it - makes sense.

Thanks for clarifying.

Regards,
Akhil
