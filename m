Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE73BBCC
	for <linux-crypto@vger.kernel.org>; Wed,  1 May 2024 04:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714539131; cv=fail; b=OeqNQWRIGMi5MbhuzJnLY2kmwuckJQgP/fL5eubag0pF+7DhqUh7W6Y5Vxi7JDeq+xK5nQSlWD/npmt86v5hc9sgdjrLIjEBRhDIqITQqdvUATS7D393B62nlLenl35vFBIvNpMQVOaeKbEe6QlFJH4J+otQQySmhrnoyLIonHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714539131; c=relaxed/simple;
	bh=3zMI2zfuaj7ilb7JDc6i4EkoIubjLTnxVxAn+sdONI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kSOSh+tgZrz0nTuKOPrmmWez/gR7uMh5XNDSad+WA6lZfJrYbkTa7yDxIlZBmlcArk0cfWdTg2lr5L7lz+inj9fgjBNHkfL5OdFr8NV9mFno24evbq2uDI/sX4KEmJHP4EdAayeBXummaj+4otdbkw/LTClF1VVtHCA7QYChRzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qWwu6Ge6; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qWwu6Ge6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkQYLJsMZ48LiDeYtBUE1oDM6IYx03FPNiEHnrU2I9ulzxnDNqbWFHkyIIVSvi8IETVnV4KB8OQSRz/9gj3hqwa44pEpljTSVOREcnF7uN9rclCQe34Z02OIbQR2N//RitZqjn55Zoa+JTkSf5NgCLDdDtEQem0GxguVCaL1v0r5i1jfV3JomKO0BasDMZ1J4BgIPhPrxCmB0QLJndheg2pvNO1y0VHfhsyivGQukcPFW5CQqndwMtEX1HdfU7fJ4pBl7hcY2vbB4HaF9hbHob20ecvWIsYhKtGXvZBJNSlGYp09fXmsAVD60Zv5kk3nY6WKdSOAYm7AlJUR65mKuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dP0cSl7wLgeV2NkKZY1qe4tH3gIynLcryD5UTposgas=;
 b=QZ1lGdNM0rnM5Io7fl/xB9t3DtpVcWur8BIvGsfFUri3wQtb+MPAccE2gAE3mlihoNxOXdTGSQkDpvpZMZJTNRfG5qZduO0suMO9JlnH6XVSSOFCx0IsUAGmM/0WGriqgj5BtWYDFDU8mS/O4gRmUFfRhtCl4KIHDjD1HGyzcnWClbGwqrK6egKLe7nUsBne6S3vEXswtZkn7qUrteXDY5J1L5u16tDDAm7xeGlMBbS0+JxK4Jjs4AZMTP07fISe2NXCqI2aigrXVI71owp47PV8z9JBOR9vTiwDmupkviL6egDidF2b9VRiOgrHmKmlH/AZkR3aYjZ94zY86Ky9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dP0cSl7wLgeV2NkKZY1qe4tH3gIynLcryD5UTposgas=;
 b=qWwu6Ge6JrDZaf2mTMUADoIltYR+aIUI4U09pa4gTQo7LCD2J6cRWS06+w7o3S7IsDw7u1RRMWHisgnTklc34bCNf/hJAopwxkddLTlQ07yLvuXdhPjI7dAQJpHvy87RCaPn4V6SIUFESl/CZTMUTWiBOrpJsr4IHrRAhqGnJ03ke2IcPsZHAufG+WLRUhqOA3UyMrO1/QHnFy8G0jGUpmz68KeWMRHAqrZ2DYvOYy5a82WLEv+b7IWG9w7/yNwwugfwZXZaKejM9Mqwrm4rGh4wiuEl902JjT5rlL5DoiI6eONSpz2hxUpN/suCkiiV+85xjfUedtPII0EQMe4jGQ==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by CH2PR12MB4295.namprd12.prod.outlook.com (2603:10b6:610:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Wed, 1 May
 2024 04:52:05 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7472.045; Wed, 1 May 2024
 04:52:05 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Topic: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Index: AQHaha3gsfDBlfEn5kWsP3WoOvnfvbFkS2CAgB2iPLA=
Date: Wed, 1 May 2024 04:52:05 +0000
Message-ID:
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
In-Reply-To: <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|CH2PR12MB4295:EE_
x-ms-office365-filtering-correlation-id: 2ec65128-6772-4af9-5960-08dc699a72f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?hpeKqSBAla/OF5EopkblIdGCNNTtwwYwMK69hJuE8kJePI1eKFcXa8mNLWWE?=
 =?us-ascii?Q?32BlRESVEGbnxpjrsNuoGooInP0ClbynWQqIrClQ10tnmL+ZWrj22VrbIC8q?=
 =?us-ascii?Q?ILtAEjSCpCe/3QeuREh9bGn/OKhcjuXXQrHQzr42Imunh5kihRXT2h5Dpgam?=
 =?us-ascii?Q?SNAaYVe0mbEe4lJoKq6pcfz9Rgb0EZxPWk75faQHPSNBAH8Wu+/jncsLyNeZ?=
 =?us-ascii?Q?xMImeratQl+LMpBJVSsDXOWSTlg5GBHdyfw7vAQI2DASwC6ccsMnpLQ+vUR/?=
 =?us-ascii?Q?K715RMLzPfsDcyCZ4aHqPp6w0EjWnGJT5ndMmXEa3AvZi2Uk+VMUZm2K42fS?=
 =?us-ascii?Q?5jYA1wMe6jcsLxqtBxAIqjM0RJ1srnuUopya07hPKnuIMb3/m7+m12IYuED3?=
 =?us-ascii?Q?fFeWXmvP5zg7UpZy5Rgp6JisUA6rbIh6pU8nVzLooftKlWymWOOlk1pFpb3L?=
 =?us-ascii?Q?C+17oMhjDRRZs3dPP23Z2zC82C/IgP4nChrHdEdWy7mgVvjiekG441EONER5?=
 =?us-ascii?Q?5xsYYWmWztobh7KnbjlaUi7C/OjBMINsGQVMuQUnRtX8kO1E1NKP81g61ERq?=
 =?us-ascii?Q?iz/Jnpyr/p3HCe05gz48C23G6Gu52ADAai8oCFBRfE19yciQ7a3Lf8Igyvol?=
 =?us-ascii?Q?Fl7Xd2Jd4IyK0Kpq+fQRlnXFCzsq09jcB74mU0WPSvrcQpQrgrUEoMSN9ob1?=
 =?us-ascii?Q?zEp6QvdrCKP5QxB/kjKQ+kegVtEaTENGIrOXaK4yme2IYauml776Z5URYh7h?=
 =?us-ascii?Q?PiaTljlH4uLLXn7FF3+DZ2s7N7FuSjftTdcmEckMiIXOf1iC5RjkOOfNhsWk?=
 =?us-ascii?Q?EZ9yEV28F1qVy0GERFoUcNlggR8d5DjyVyjUjTx/JG3BVPhUwCbGOd4hTcs/?=
 =?us-ascii?Q?nPLfSP3Nhd0/0kBp/5WCqLgsWTXG3cKG6lH4tGxipn5UNPLLLkFDF/6WC2GS?=
 =?us-ascii?Q?qgZw9qWB6RTxqYgu59mU2pte5LPHCyZC+aMDrbE9Nbb7qNJQRzDy1yAPoOTv?=
 =?us-ascii?Q?GEKe5V/8CSzlYVRxcY+ugDeU68EXjixH99YWoddP3pdUwXzFTYn4ltv4nAwo?=
 =?us-ascii?Q?48BRw+3lvcCk2c7eP6dQy/o0NrnL3oxVIaZLNakqqBrzPwgszQoNfH/6cWa+?=
 =?us-ascii?Q?n/Eixb8/f00aeEgJfclRa6Mvx+cjo59Gyol9tbPILdwytw/JpA30CaTOTW1e?=
 =?us-ascii?Q?+hoU+rgqhcYsYIt1bLNmF1JLXu52Uf7HQdfaDnZafBHoH0PsFvTNRvOGr9pQ?=
 =?us-ascii?Q?9i+8frdJvsWsyV/bpsPNUY4SQ+I+mEVfgbRS2clC7/GROaGG2D7j4/IeZKIB?=
 =?us-ascii?Q?lhhIxZNH2e/kGyIhE8/aRkjOqxyWr780tfmAySEK9hUqtA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?wHcV1K5c1kuu+GhfKfkM+a3WeTyNlsc+i9bwvcKsQiWkdcciwCfx0PxlApxI?=
 =?us-ascii?Q?1fWYli6BckGK6PLP7anAfmzrzYiUb8xp6lwfor3VRBceXloq3K5Q/2NArd2g?=
 =?us-ascii?Q?/cPB29OG70LEq9nVT9iAItWPgaFdNG6sCk16zFYdpXyWoF3PS4lRNc/y4agS?=
 =?us-ascii?Q?DWFxnBe56OqxS/4E37F3MeqIplg83wmvoFGXErux1nJsBgKUDEi9fdd82ba+?=
 =?us-ascii?Q?N3Xs2t6Oh/XqC6cnundDUF/bvEV1swRlrbFrX+UiRxkaLdcFupdHiCHnohvn?=
 =?us-ascii?Q?Cjj9YmOsfL5Um8rPhD+UOuZx28CJYVEr3ezlQPl9MjsHo3rm89JAuW9XKuTx?=
 =?us-ascii?Q?szqDALh5ID54LnlMLWwhWAbc/FPqRKULQJrjinf6zCUWJMwiSqW9b8vt3m0B?=
 =?us-ascii?Q?oYrmeTXXGNF46JK7+CHHo1CW8JZtwsHsjVEEkjptNBYp4tBIZBuzN/YDPO10?=
 =?us-ascii?Q?cWeeHOylvWLupDi8WUU84kvyUEmljC1Ij/cat/0PvW+0E4Qk8c8i6pdIdzWk?=
 =?us-ascii?Q?tHiIAsmhKPqeV+6Ko75V8PNbzAUQ1ujZ99YqhORBC1TYCCs23ndsi7Dz45Td?=
 =?us-ascii?Q?Zgie/6FjtoKXFa6mm222nLVs6gJBtcUaPD0EXdv9+x7RRFZNh/lPYOz7TATS?=
 =?us-ascii?Q?aFJ5jkHBUXvYIm4tWZOtQ45JU3GNVGd8P/zA1NmlQeuttoaNUrWoPswTogpp?=
 =?us-ascii?Q?uSdlTFvChUPXrZyG42aHZ4ag18r9sliuh/lRwpq+xhJowfXWqMOFX+1Hztpc?=
 =?us-ascii?Q?v7mJTQnNMf+0+MxoESuaTcfpRytBvLMrzEuUrSwgyFh4V1UE+0vQgJra0c+k?=
 =?us-ascii?Q?0fPE216kHHZbr7IQWH3SQflS0+8Btt4mAzkuJdE7cOej69rQPcfSYKzQsRqe?=
 =?us-ascii?Q?3IVXcFDuSNZGlDW7/fFaW2sj2lHVQLOYsXF4P5Fg7Fy1zZAXAdY7mrAwVECu?=
 =?us-ascii?Q?jNM2Ce656n77vkkXXXXHQ63Vtp7wG+nEjBOzcBy8pN/xzlqEZuftmtzQQ+dN?=
 =?us-ascii?Q?ZmVT1wIUonCGMOTECPBQuHnz0HndxB0EuJr3KBfZuxbo+pL6AHad82JqWtyL?=
 =?us-ascii?Q?Cxy/wXPD4RbhsAW6uiUB/fCUtrF/2TYttYRJMFIYzfZ7rQ0Crgwc0cwEUUYI?=
 =?us-ascii?Q?+Uh8+PXJG60+/5tupO9N9s5yAP5blHUOLlkG+r1dJv3BBMNR8TKz+rTgqcAf?=
 =?us-ascii?Q?ifbe3d8TmIQvWk6iwG44Abn5dganH7N+9syWcz7H8DiOdWyXM6zJcIRKobEy?=
 =?us-ascii?Q?l0HZ07VoEoMxlJ0HPCKLFZ3qKRIMOWrpDoKrQ4OTI3Wc8PTF8BUA11Nw692q?=
 =?us-ascii?Q?uXYzgHf3jzzA3LmHKvwaxCslIYz6sc/vhlZ1LycPUXcdok9pPviMqDf1lbvS?=
 =?us-ascii?Q?JYwzjbTzyZeXrFWlaoMXpEa3N4OBGRW8YC7bhwBfM0OlFHWksNdBJdoFFGj8?=
 =?us-ascii?Q?PbP036+rmyha8E467WoJ+UMFT7wG0B4A3Qbiq1Zq6y0VvkhGLdJmMMIuRcri?=
 =?us-ascii?Q?bmK7rn6q6D/GoOLbMug9YiJORWPn3wqyVhv5ovwXYny0jXxLK3AKlcmF4FIU?=
 =?us-ascii?Q?J8UFqEVNsQatB3NOxwh7MZBalllZOq4+WsZ8voEOFWQ0gGHA5lJdgTO4uyTe?=
 =?us-ascii?Q?Ow9ENGWFgbYwISNRrgFpzeFQxhnH6ZBTTKp++ckU3hk6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec65128-6772-4af9-5960-08dc699a72f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2024 04:52:05.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bH+s0/uqC+JTzr2UfqoFMfXdMY+Ohwr5cuYjto/IPzNAkTDkzDrZclMA5qDuJ7H4D+gX7XDYn/wyipXiJT9YGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4295

> On Wed, Apr 03, 2024 at 03:30:34PM +0530, Akhil R wrote:
> > Add support for Tegra Security Engine which can accelerates various
> > crypto algorithms. The Engine has two separate instances within for
> > AES and HASH algorithms respectively.
> >
> > The driver registers two crypto engines - one for AES and another for
> > HASH algorithms and these operate independently and both uses the
> > host1x bus. Additionally, it provides  hardware-assisted key
> > protection for up to
> > 15 symmetric keys which it can use for the cipher operations.
> >
> > v6->v7:
> > * Move fallback_tfm and fallback_req to end of struct
> > * Set reqsize and statesize based on fallback_tfm
> > * Remove ofb(aes)
> > v5->v6:
> > * Move copy/pase of intermediate results in export()/import() to
> >   'update()' callback for CMAC as well.
> > * Check for rctx size when using fallback alg.
> > * Updated blocksizes to align with generic implementation
> > * Combined GCM and CCM init into aead_cra_init
> > * Updates to handle invalid cases better
> > * Reduce log levels for invalid cases to dev_dbg
> > v4->v5:
> > * Move copy/paste of intermediate results in export()/import() to
> >   'update()' callback
> > v3->v4:
> > * Remove unused header in bindings doc.
> > * Update commit message in host1x change.
> > * Fix test bot warning.
> > v2->v3:
> > * Update compatible in driver and device trees.
> > * Remove extra new lines and symbols in binding doc.
> > v1->v2:
> > * Update probe errors with 'dev_err_probe'.
> > * Clean up function prototypes and redundant prints.
> > * Remove readl/writel wrappers.
> > * Fix test bot warnings.
> >
> >
> > Akhil R (5):
> >   dt-bindings: crypto: Add Tegra Security Engine
> >   gpu: host1x: Add Tegra SE to SID table
> >   crypto: tegra: Add Tegra Security Engine driver
> >   arm64: defconfig: Enable Tegra Security Engine
> >   arm64: tegra: Add Tegra Security Engine DT nodes
> >
> >  .../crypto/nvidia,tegra234-se-aes.yaml        |   52 +
> >  .../crypto/nvidia,tegra234-se-hash.yaml       |   52 +
> >  MAINTAINERS                                   |    5 +
> >  arch/arm64/boot/dts/nvidia/tegra234.dtsi      |   16 +
> >  arch/arm64/configs/defconfig                  |    1 +
> >  drivers/crypto/Kconfig                        |    8 +
> >  drivers/crypto/Makefile                       |    1 +
> >  drivers/crypto/tegra/Makefile                 |    9 +
> >  drivers/crypto/tegra/tegra-se-aes.c           | 1933 +++++++++++++++++
> >  drivers/crypto/tegra/tegra-se-hash.c          | 1060 +++++++++
> >  drivers/crypto/tegra/tegra-se-key.c           |  156 ++
> >  drivers/crypto/tegra/tegra-se-main.c          |  439 ++++
> >  drivers/crypto/tegra/tegra-se.h               |  560 +++++
> >  drivers/gpu/host1x/dev.c                      |   24 +
> >  14 files changed, 4316 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-aes.yaml
> >  create mode 100644
> > Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-hash.yaml
> >  create mode 100644 drivers/crypto/tegra/Makefile  create mode 100644
> > drivers/crypto/tegra/tegra-se-aes.c
> >  create mode 100644 drivers/crypto/tegra/tegra-se-hash.c
> >  create mode 100644 drivers/crypto/tegra/tegra-se-key.c
> >  create mode 100644 drivers/crypto/tegra/tegra-se-main.c
> >  create mode 100644 drivers/crypto/tegra/tegra-se.h
> >
> > --
> > 2.43.2
>=20
> All applied.  Thanks.

Hi Herbert,

Thanks for applying the patches. I see that the driver is in -next now.

I had a question based on some of our customer feedback with this driver.
While running tcrypt mode=3D10 with Tegra SE driver, it shows errors for lr=
w(aes),
rfc3686(ctr(aes)) etc. which it does not support.=20

I was wondering if there is an option to skip unsupported algorithms in the
Tcrypt test. I don't see any vendor specific test modes in tcrypt as well.=
=20
Could you share any suggestion on the best way to handle this? Or is this a=
n
expected output of the test?

Thanks and Regards,
Akhil
