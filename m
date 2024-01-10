Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2044.outbound.protection.outlook.com [40.107.8.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B171113
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 09:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="J4BvfvVX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5wNBq8kMZwdvGNWITU1JWKXsClzTZ1xst9swXUU2zxiiD8+RJW4nDhy+TpWbHzQEGXOxSMcTswx2TYFeMEm3eCO+XfdZY6ZNOqjvnabb3aERYhUedw104oubmJPznjMMZkaOTSAaeYRsOIhxhICz0Eq9qyTKuHooZHVD5t4pJBgpXwNR73kSkFrx0lQn/Fb81LOTjZz43qEVNYcg/MhP7t4VuPj6v2WJ5PZi5NFmcox0UahuniWUiyIbHmQrnLQzgm5WXlXM1M4Rqgl+34cXZN+RFZ262j0WebQiwbHof1NN7qVgrwrywfPHU52y/wLvTALJu7+4D5KP9jNm6dOIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvofmwuLsJ4AFkNzEz66EX8hdhNGiIOulJbvEKeaGzU=;
 b=bvjB3KsjFh4qPwkeKIUqUqCyw029gBVE5W4wH+RjivFw9z2kNstxkEv3ahaSgiOt4tR3vHgzU2AlAyKo4dtwMEfOFCsFPGRLogpjcWt4k5dhZoldNf2vMHT8591pEVDxgdkqJq9lPkSAPyt2b9z9D2UWAG3qnN8w8nBloiGQXeyNcZTzE/KVyasfAUyeryJGzgB8/d5oeGD0EjbSpOIgdvOV/iqRnvrinNdLk9/7oiyqCVdxRYwPGZ0HS6tOyErw9pIOTQTSwd6p/tvtL7NeZ7RcoHWAgBrI+UzpAPkvyKwi5e4nEYZXmvORnoVJ/v5upXsihQRV0pVm9WLVAbH6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvofmwuLsJ4AFkNzEz66EX8hdhNGiIOulJbvEKeaGzU=;
 b=J4BvfvVXOnPgQcnVPorAex5tt96l7zfwyAi0P1jJteFGDqByl/ZSpl+tx1Hi930y1gLmizHOm0zrAC2gOaOJWiB4u3BPnC27lfqH+4BzEImF+DADM8JBqVWStxYW9q5u0Rew9wEBMbLt0l7HFn1aKgDrdnebh/DQANoyvn88xTs=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM8PR04MB7218.eurprd04.prod.outlook.com (2603:10a6:20b:1d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Wed, 10 Jan
 2024 09:14:16 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f%4]) with mapi id 15.20.7181.015; Wed, 10 Jan 2024
 09:14:16 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Kun Song <Kun.Song@windriver.com>
CC: Varun Sethi <V.Sethi@nxp.com>, Aymen Sghaier <aymen.sghaier@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "filip.pudak@windriver.com"
	<filip.pudak@windriver.com>, "heng.guo@windriver.com"
	<heng.guo@windriver.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Meenakshi
 Aggarwal <meenakshi.aggarwal@nxp.com>, "richard.danter@windriver.com"
	<richard.danter@windriver.com>
Subject: RE: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr
 crash
Thread-Topic: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr
 crash
Thread-Index: AQHaQ56ceWii/sYVC0amEMLId/XZerDSu5zA
Date: Wed, 10 Jan 2024 09:14:16 +0000
Message-ID:
 <AM0PR04MB600455078CE01BE8246117B7E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
References:
 <AM0PR04MB6004B82755A53A216D2EFA13E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <20240110082532.2858045-1-Kun.Song@windriver.com>
In-Reply-To: <20240110082532.2858045-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM8PR04MB7218:EE_
x-ms-office365-filtering-correlation-id: 2793b802-64bd-4f70-293b-08dc11bc8519
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 cCdOJaCBdu6m8mA39r844G1u3mpxOERPQC0dc9ltzd68Z5n4rQC3LZVn1YY2UrjWlYLxT98XWj9xWztPr25Zmsx774ETUhEEHlH2Axy4Y01RciXy+YGToi634Mo0bYoHy/q5l6sfxfsGw/la+IvBclztNGQtl+0mLU4dxhLPcvio8v3VrxDsgI1DqQdiCi5w409sGubLGesikic8mbeM1zfZBFXl75PkG5pNvdhCouhp7iFPiC0/p5ZMgJkgUnVXeKyXgQlRd8rjv9J+8O1M+qsWZseIZ368GqoI1vZx/liHT3vA4+zZ/im8fZrrg9VxeG5B/jHP4opaHx6TmOcE/omuhrhxfl/Kbk1P4e3A83kYXNDoRJmU2lqG8TNXj5b/sdVJHV2IONv331EsYk/8JRCEzWVfh9+hJwsf8rp0ziRCUQHWHULSZA9N8dUIcWyrmULtcDdSpyR+DlGx5+du/N7k3PKX4CbYxkPWEPUddFi+/XsB+vdpP5fHUb/XhjCJCXzM3+zLIdEdfV9MT6E4Krvj96IWJGOuQvnCr9cjXUoFq4aMgGVnhOCAtH/qgz6RqsOSD1bQEsshmXbLo8KfvXbXMpIrMN/mq+jdGhvIFJuMn9T5x3JvOLl097v0Rf2o18i3pxakaZ16wdaKbAnkeA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(136003)(346002)(230173577357003)(230273577357003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(86362001)(26005)(71200400001)(478600001)(6506007)(7696005)(9686003)(55236004)(53546011)(966005)(83380400001)(5660300002)(44832011)(4326008)(2906002)(41300700001)(76116006)(8676002)(8936002)(52536014)(6916009)(64756008)(66556008)(66946007)(66446008)(66476007)(54906003)(316002)(33656002)(38100700002)(122000001)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?C/PdtL53Sd+oqfnsBXDCMZURT9NI7wfeoJ5v/HVhgQbzdvE+BR4jJyTJodRx?=
 =?us-ascii?Q?foO9WYQQHMZ9micZwsUpxEZXHmfsVHbHETO7uALTbYUtqLWrYRjEFPm7K4c2?=
 =?us-ascii?Q?TU3mgRB7YWxPBqbPAPENd6kjPQKZz9L2ubb8nj/PZngS99YntB131Tm7A2gp?=
 =?us-ascii?Q?xeX/DVYD0Xn0Cld4x//aaOd9I9QMLbgSPV7YaU/lAgtV//fDnSLSqZVTa/it?=
 =?us-ascii?Q?SDqCjn7kvd9oDJYqGRIahmr0bumpGQ+5oGXb1k28uG07lx/NaUqGWDIolP/l?=
 =?us-ascii?Q?3Dq7z3qaBB9O1CUR3gNrry+wCCrGB2gszXi3FHgG1ghAtsnmWY6OuVCztnjV?=
 =?us-ascii?Q?506fS4X6K5PlsRoyH0FLPJKHzzujn0IvNqhzM1QI7yAl1ETDfoPn809Oo3aA?=
 =?us-ascii?Q?WE5O/Jit0zVQtzzLYwQLvP1X4RmnwZkNeB9OX+uAq03HN9msVkrTXG647xre?=
 =?us-ascii?Q?7qYQ2dUc0q5LAgBazyFigjh4J3mpzd050AdejiofIBE3xhWRisnsIPPzHJeN?=
 =?us-ascii?Q?12keBPHL+0Io85DctatNb+AUgcCiWRbyyJ+sUIqo9RYFgt58GHkvlfRE2PS/?=
 =?us-ascii?Q?IC2BaJD/+1lyQ8BtEuZOje65HYtbqnL51gbrhDrH78DNUOa6vJ8JLHqgBBjJ?=
 =?us-ascii?Q?k8Q3tn8G5/S17jeQCJnKZIIQ0nqMHVNf+YQNYDUKXe8coW793ojO6XNrZdUq?=
 =?us-ascii?Q?R4TK4w5WErdppFdVqyX2Mu9L7DzZB6wbLK95O7oQbOp2h4wI84WBYRJfa28s?=
 =?us-ascii?Q?OhFHgCFZUcCDveSPldfDe96XM7BPs3/c/XqhURTEQzAln90lg1G2a3KB45X0?=
 =?us-ascii?Q?wYRggNwu/7/bx57IJEQFaQV5U8G5sSmlezXPY4AjzC8ci4LUmXR1OWNMMpkp?=
 =?us-ascii?Q?JQE62169vdTvFYO9uL72lXbQgFdbf7jlBOet9K2JqRcToHr57yde/oV+Flxy?=
 =?us-ascii?Q?+v9sORtbS8VywJFeZBNoM0T7pm5apNIW3mD/UY9rscPpYnl3ZEInYcLdTgOE?=
 =?us-ascii?Q?fCEJeNzFGfZ3RT1El4IpQ4tjZO6LERCSNe/XLXLD67oO9tsuKn4fNC7SBf2K?=
 =?us-ascii?Q?pLmI1H8HIgXg1Xpef4ebB3IBLPGfHOMzT2scWMmDQh1pfL4i8crXpesN0YSx?=
 =?us-ascii?Q?UWZnD8+u4zR0z5RTVHNiLtAOvyAOrIsJYw1hbml8qOfF/Fkb23x3npYTw+jl?=
 =?us-ascii?Q?bmSj2Mwa3GvcQBdTFc2sxR/OFDNfJtZMzz1/SW67S345JoxrSVHYVm+9vw/9?=
 =?us-ascii?Q?RFUei2ocNo1fnp1PP0e+BcoarFN8mlhPpBSIFBJaV6iocEmQpkIrC2dDIoRG?=
 =?us-ascii?Q?44CJfpEKWeDk94fNCnv4m80wYEAbd++TnQaYHskB0V2KbZP3dkwKW7l7FPUM?=
 =?us-ascii?Q?TAgIJnbMDloYkdfQfb0cgeG5MzJWwQ/RABbyJ5EAgAxL/h25xo1tdmqTBbic?=
 =?us-ascii?Q?Ke5hpbifyB7Tdb18GK6d/+S7OdAf5wIIUnMqzISUyCb8UOUH5ESd6lnpabGI?=
 =?us-ascii?Q?qNQYNc0MOo9Yu8HmLl8SvTBizHlTumRKI/rSMUMuY7+g8jCk0Coh3PJNKOZx?=
 =?us-ascii?Q?A3uXQBkAlFr4KRlo/A6MmyNfjDdch5/w3L+kkA6+?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2793b802-64bd-4f70-293b-08dc11bc8519
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 09:14:16.4090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VrzGh/UEqwmVEbs4dXi4FjsL4SGaq91ggxAqKRYb+uCzUWjBBMY9P7sDH7J2JiWDBNGZmdXpdyr4AYTcT/VPHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7218


> -----Original Message-----
> From: Kun Song <Kun.Song@windriver.com>
> Sent: Wednesday, January 10, 2024 1:56 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>
> Cc: Kun.Song@windriver.com; Varun Sethi <V.Sethi@nxp.com>; Aymen Sghaier
> <aymen.sghaier@nxp.com>; davem@davemloft.net; filip.pudak@windriver.com;
> heng.guo@windriver.com; herbert@gondor.apana.org.au; Horia Geanta
> <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org; Meenakshi Aggarwal
> <meenakshi.aggarwal@nxp.com>; richard.danter@windriver.com
> Subject: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr=
 crash
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>=20
>=20
> >Hello SK
> >
> >I am submitting and replying patches using gaurav.jain@nxp.com
> >
> >In Later kernel versions we have provided fixes related to job ring flus=
h and
> there are other changes as well.
> >It would be better to add these changes on top of 5.10 tree as we also r=
un
> multiple tests and not observed this issue.
> >
> >Regards
> >Gaurav Jain
>=20
> Hi, Gaurav
>=20
> Can you identify which commits?
> Our version has added some related commits based on 5.10
> -------------------------------------------------
> 04ff8e37a2df crypto: caam/jr - add .shutdown hook
> f7ea4a6a6511 LF-3093-1 crypto: caam/jr - fix caam-keygen exit / clean-up
> c41daf27fa44 LF-3079 crypto: caam/jr - fix shared IRQ line handling
> 1f12127de72a MLK-24912-2 crypto: caam - fix RNG vs. hwrng kthread race
> 04e3a61f9bb5 MLK-24912-1 crypto: caam/jr - update jr_list during
> suspend/resume f48d9e23262e MLK-24420-3 crypto: caam - add ioctl calls fo=
r
> black keys and blobs generation
> 5c98742fbf60 MLK-24420-2 crypto: caam - add support for black keys and bl=
obs
> -------------------------------------------------


https://github.com/torvalds/linux/commit/06e39357c36b0d3cc2779d08ed04cb389e=
aa22ba - drivers: crypto: caam/jr - Allow quiesce when quiesced
apply this one as well.

>=20
> But We have no way to port this commit because its architecture has chang=
ed
> too much.
> commit 304a2efe9d55875c6805f3c2957bc39ceebbc5c0
> crypto: caam/jr - Convert to platform remove callback returning void

Ok. I think this can be skipped.

>=20
>=20
> On your test enviroment, modify function caam_jr_remove Test scenarios1:
> if &jrpriv->tfm_count is not zero,whether will crash?
>=20
> +atomic_inc(&jrpriv->tfm_count);
> if (atomic_read(&jrpriv->tfm_count)) {

This way jobring flush operation will not be triggered and reusing jobring =
result in error.

>=20
>=20
> Thanks!
> BR/SK
