Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2071.outbound.protection.outlook.com [40.107.8.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE517735
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 11:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="TJihbUl7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSFmG4fHITcWU4zw8LL6Gz1vL8vsKSAedETRMKmgu4/05UIvtmyin9yoWtcsbFLvwnZ7N2dSIHYpolFmBo7vPos28IOlfXjP9kNMs3Sys0d89ZVlLZRW+V5czrgZ6sHLoxc7uYYW/q/YPk7TxMY9du+0wVzSVrcsKzynaFSScm4yIzhmUIcqFuY+C86BQP1THX6gn3+6iLaJ/VxXVGHfRcROeKx6Z5UGCTPl6STnm+Ujy/08oN0ChWyCyWSAwzAMEQmKfJDfL2y5CRcWO1K8ZaooTlhCkTGQU9D0l4MnxF3QfgnDIUdQ7yeRlR8FUOPCb+sVOmgHVUnLlL4IXExnGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lv/qZoosszuQB5NdGM2LhAT/y04iJ8lWbHOcw94Hp0=;
 b=Z/G2B7xLSnZhHzxdEMVwymfJmah0jTj4x/ECKWOc173Rtkjoea81m1CrxVJyNpQgjTJcM2EGMVUfPPCUuHyVnAzubDBF/1K25w9sJCO2SoPBa8yDLw0bv9YQZCyf7HG+HfzdHUFbmuEYuuJ1H5yHiIrPFHfKIuazGa6nxVhPfYMRcXlj2SY0ZesJ3TLyzL3Jze0GY+SFdIwv1zdZ3e7OiMa5X7FL0/RRERhPap+Z6P6oTSh4jU7u3Iv3O29Kb/WcsjeQK7FjZsmW8idxw0yC8Q/pljoLqFx5r70wlVh59Pwww+8mrwgn8+RuS2tu1TlJVW2JBAVYCsT1teVAsdFrQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lv/qZoosszuQB5NdGM2LhAT/y04iJ8lWbHOcw94Hp0=;
 b=TJihbUl7BTe5wp/hnGFzFa5cbtRQ5OGTjsjQD8p+kDu/8fLpA0WkRpynnLPDMRc/QUaD8gipMMrdLTdychWzmE2B5MRQjH26+SiPeJGp1vMu72uQ7B9v+NNlKtcPtIq0tk16coieq/OMhxckb7row77aytjsnYnPpBuEySgA4e0=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by DUZPR04MB9918.eurprd04.prod.outlook.com (2603:10a6:10:4db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Fri, 22 Dec
 2023 11:43:21 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8%7]) with mapi id 15.20.7113.019; Fri, 22 Dec 2023
 11:43:21 +0000
From: "Gaurav Jain (OSS)" <gaurav.jain@oss.nxp.com>
To: Kun Song <Kun.Song@windriver.com>, Horia Geanta <horia.geanta@nxp.com>,
	Aymen Sghaier <aymen.sghaier@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"filip.pudak@windriver.com" <filip.pudak@windriver.com>,
	"heng.guo@windriver.com" <heng.guo@windriver.com>, Meenakshi Aggarwal
	<meenakshi.aggarwal@nxp.com>, Varun Sethi <V.Sethi@nxp.com>
Subject: RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Thread-Topic: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Thread-Index: AQHaNMwOxUV8nN6ZdU+iTMBQ8cWhjw==
Date: Fri, 22 Dec 2023 11:43:20 +0000
Message-ID:
 <AM0PR04MB600494E7DA11E8853C57566EE794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <20231221093209.984929-1-Kun.Song@windriver.com>
In-Reply-To: <20231221093209.984929-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|DUZPR04MB9918:EE_
x-ms-office365-filtering-correlation-id: 81074728-00b8-4ba8-39d6-08dc02e332a8
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 gGqxiNK/HuEImRe0b63YwiiEcp8Jd7xcJslFxeXAfC1S7liPyZq0n9FerS8VdY/aaezTlNz9CXgLM2hebbo8CQvvx80eADPyASaNdO4ROAt4XRV6AbAZUb1SH5jp/uGfB4E4SEr1j/DA8RrGV4gMaPBNHqWKNATDOU4MAJ5vTfrgqRHrbOG7kX3EyMDrgdhiyvzfWR9Gri2yrL8/wNkQ2+LOA8w1ghTIZIEtbwjTKQ5QWGmtcBZwMmX6bnnFH4G0IOTb6AYHYt3so7aGve7Yo6xtg46lPW8djJvawu0KV86116+TQmZ1Y4M5Qi4wwGOvX47UzWH0wNZlpdEiC0d3zxMffN8q2Ybc9uRJYASSkh87jmg/Cz5rXIsyI+sTku23uJvHPL+Sys4FZn15HBqphambtkuRo3SWWSyg7LDl6Y6v44hjKOCMPaRworx+c8QB0gxcNC+jnPMr4Izi5TS7g8hx8/7LpnIUhrkFie7Ke2QmpQNLnzIK/f+lW09pGb7gu3VxgP2oKGmUgrdKefV0SAx3ojMfn8dZUzGvm8Q4+axjipz79XWJSwa9gZA1x4QOZpfUxdWuStr9b/xx5zh1+mOWq09hTzGEbh7iH762+xlddvb4tUkEhg53rQe8AeyL
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(39860400002)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(71200400001)(5660300002)(7696005)(6506007)(55236004)(53546011)(478600001)(9686003)(26005)(83380400001)(55016003)(76116006)(4326008)(8936002)(8676002)(122000001)(52536014)(38070700009)(41300700001)(2906002)(86362001)(33656002)(38100700002)(66556008)(66476007)(66446008)(64756008)(66946007)(110136005)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?t75XmrRK7hEglhRdwaYz/O4wl8YPyDuNUDUz09gnXyrBlMPttV+500R4i9I4?=
 =?us-ascii?Q?aAb7toLf1rppAJL84h5y6KyPBSQsH0JVwdf+5T4egqXn4cCfJ3GxsD7WdvMq?=
 =?us-ascii?Q?5iVHu1jSE7pYJaez5ajwDjadowPATqTwUZlnVynpiA/4fsDTzWEGStd0NmET?=
 =?us-ascii?Q?CL8KlBZbCv94/crXfH3adDrTK6RIL7pb2jvAPIBcHAuwfxBphwYoJ2FmeAbv?=
 =?us-ascii?Q?PqME8mcvDw0lVudc95ZvmtSlD6YDKxxqygNqKHiaQdGfStZuVwWjlxurz8K4?=
 =?us-ascii?Q?C2j1eDtNUBezISW/1gzo71/RNSzYwgg18eVdtyu+nt49lPzgw7RpdwxqGbtm?=
 =?us-ascii?Q?KPZKYBNzgT6gJA3Y/Ap64/YSweBCozEnyuhAcQ7MGKgb+ITCtncZrBUVdBeM?=
 =?us-ascii?Q?g9td7bAPVQ3LkTnYg1q3S27D8xghu+kjQsCn1beiGaz+CWKrSi/RwUEelgAv?=
 =?us-ascii?Q?lijXKpEgK7rWqEEBDxbkshFLZrlZw3IIc02PmXMLcEmEOJlBlnQl7NotTp1f?=
 =?us-ascii?Q?bjut7otrBnUdN12EwV9/x0rIhH8/5b5d7bd3AWRuzqCLEu7llH63LXhtiIdY?=
 =?us-ascii?Q?qoU5itTSyKuHPhOm11vINKY9BQy97lLfqXc8bg3FMgGuCJAVRCgqxOnct2LW?=
 =?us-ascii?Q?hNI8cCIA7MAhdv31n/Q4t2d4VjkgVxNdmd0ow7ez4HYO2caZD66YlY/uAkjE?=
 =?us-ascii?Q?RSVZhPnafO6srjP1uIaze9QzW9tf+dc3RRlilv1jj/FtbiaE33VdiEBVodJS?=
 =?us-ascii?Q?/hGndPvxjEjTHN2AamoJz/37d5A4+PtJhaM6VSI4hERodXcbSyUqumDHisro?=
 =?us-ascii?Q?O07DniKBQ16LZ8DhxF4VLcLj3xt7cz7g/8wWLeEbsvj2Zyl0WQu1wUPxbEPf?=
 =?us-ascii?Q?CgNAixbxdH5QU+vYWnWnZRsOgxjatTvQv+MrtXt+JQL9fGgPA1jAxZRSWFxr?=
 =?us-ascii?Q?rhJE9mvqc+1kcMNPH0er+2YAbamhxmZWYmcsAUQ6n3pAtd8MgoX1rOimw0bA?=
 =?us-ascii?Q?IRde67ONpkKbYSrsKPJkWwZoQi/9AHSIa7D5fXxL+4QF/tifPiE/Jbdfavu2?=
 =?us-ascii?Q?t0f7yKL6rOREJKKs8VRVaWUOUht5LDgvDgKgC8yJzefxqOKaE+KOju+vX8am?=
 =?us-ascii?Q?VuN18eex5leduNwWcHA0sGBp+B8hVVQ3/O15egB1YtONeATESWA4oJxhr9Ed?=
 =?us-ascii?Q?P/J2+siRnNO1EKoQu0C18NRNkNYkxplQmjxisXnZBv/VEzg3TRdJ3Uk7Iazc?=
 =?us-ascii?Q?WjNy4prjylgaRhIbXJRSZ24bWH0hf3yR1h4UGxzB8apQNg31PSzp5NV9Xwl/?=
 =?us-ascii?Q?W9Ksr1E8p8mqLPlcA5qRb0kczu2nQoaKVH7gN/johULlArutKTfAgq9C+3Fg?=
 =?us-ascii?Q?9lSetkYsKVHnKYHGEV16HXtZSG6cB/II+ZdZb1b4UEjSsDGAt6+Icm5P3uoz?=
 =?us-ascii?Q?yZsR07pCxwKG8peymUYR97+cGeZr/QZWb7zzsmq1FHiSD1sZxx3DtCmWEnfp?=
 =?us-ascii?Q?WbTPvyEyC+wLO/dUnIoGdBoZXIApq9tAQjU/8833x3UOHT4VKyjG7Wlln7+m?=
 =?us-ascii?Q?kSAnd98kIQbMEtYh0oLYiLvQhFwdBiqMIsKf9xJ6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81074728-00b8-4ba8-39d6-08dc02e332a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2023 11:43:21.0104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lr7SMnd7UVKNWr6kbEKI9uRI2Y2fMOIhljBlEQzG29BqK8lwWxq7ChpFEaBnxcYLhwr17oVZi9j1zSIn2TI+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9918

Hi Kun

Have you seen this issue in later kernel versions > 5.10 ?

Regards
Gaurav Jain

> -----Original Message-----
> From: Kun Song <Kun.Song@windriver.com>
> Sent: Thursday, December 21, 2023 3:02 PM
> To: Horia Geanta <horia.geanta@nxp.com>; Aymen Sghaier
> <aymen.sghaier@nxp.com>; herbert@gondor.apana.org.au;
> davem@davemloft.net
> Cc: linux-crypto@vger.kernel.org; filip.pudak@windriver.com;
> heng.guo@windriver.com; kun.song@windriver.com
> Subject: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
>=20
> Test environment:
>   Linux kernel version: 5.10.y
>   Architecture: ARM Cortex-A
>   Processor: NXP Layerscape LS1028
>=20
> Crash in reboot tests:
>   Reproducibility: 1%
>=20
> If a job ring is still allocated, Once caam_jr_remove() returned, jrpriv =
will be
> freed and the registers will get unmapped.Then caam_jr_interrupt will get=
 error
> irqstate value.
> So such a job ring will probably crash.Crash info is below:
> --------------------------------------
> RBS Sys: Restart ordered by epghd(0x1)
> RBS Sys: RESTARTING
> caam_jr 8030000.jr: Device is busy
> caam_jr 8020000.jr: Device is busy
> caam_jr 8010000.jr: Device is busy
> arm-smmu 5000000.iommu: disabling translation caam_jr 8010000.jr: job rin=
g
> error: irqstate: 00000103 ------------[ cut here ]------------ kernel BUG=
 at
> drivers/crypto/caam/jr.c:288!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP Hardware name: freescale
> ls1028a/ls1028a, BIOS 2019.10+fsl+g3d542a3d22
> pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=3D--) pc :
> caam_jr_interrupt+0x128/0x130 lr : caam_jr_interrupt+0x128/0x130 sp :
> ffff80001144be50
> x29: ffff80001144be50 x28: ffff800010f61008
> x27: ffff800011228000 x26: ffff800010f61008
> x25: ffff000027904800 x24: 0000000000000072
> x23: ffff8000113ba140 x22: 0000000000000001
> x21: ffff800011433000 x20: ffff000027904e80
> x19: 0000000000000103 x18: 0000000000000030
> x17: 0000000000000000 x16: 0000000000000000
> x15: ffffffffffffffff x14: ffff8000113ebcb8
> x13: 0000000000000008 x12: fffffffffffcac8f
> x11: ffff00000038bb00 x10: ffff8000112a1e90
> x9 : ffff8000100a99c0 x8 : ffff800011249e90
> x7 : ffff8000112a1e90 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000
> x3 : 0000000000000000 x2 : 0000000000000000
> x1 : 0000000000000000 x0 : ffff0000279ac600 Call trace:
>  caam_jr_interrupt+0x128/0x130
>  __handle_irq_event_percpu+0x84/0x2b0
>  handle_irq_event+0x6c/0xfc
>  handle_fasteoi_irq+0xc8/0x230
>  __handle_domain_irq+0xb8/0x130
>  gic_handle_irq+0x90/0x158
>  el1_irq+0xcc/0x180
>  _raw_spin_lock_irq+0x0/0x90
>  caam_rng_read_one.constprop.0+0x248/0x370
>  caam_read+0x8c/0xb0
>  hwrng_fillfn+0xfc/0x1cc
>  kthread+0x14c/0x160
>  ret_from_fork+0x10/0x30
> Code: 2a1303e2 d00029a1 910ee021 940b2b1d (d4210000) ---[ end trace
> f04d90f3ad0da5f4 ]--- Kernel panic - not syncing: Oops - BUG: Fatal excep=
tion in
> interrupt Kernel Offset: disabled CPU features: 0x28040022,21002008 Memor=
y
> Limit: none
> --------------------------------------
>=20
> Disabling interrupts is to ensure that the device removal operation is no=
t
> interrupted.
>=20
> Signed-off-by: Kun Song <Kun.Song@windriver.com>
> Reviewed-by: Hen Guo <Heng.Guo@windriver.com>
> ---
>  drivers/crypto/caam/jr.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> 6f669966ba2c..d191e8caa1ad 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -135,6 +135,10 @@ static int caam_jr_remove(struct platform_device
> *pdev)
>  	jrdev =3D &pdev->dev;
>  	jrpriv =3D dev_get_drvdata(jrdev);
>=20
> +	/* Disabling interrupts is ensure that the device removal operation
> +	 * is not interrupted by interrupts.
> +	 */
> +	devm_free_irq(jrdev, jrpriv->irq, jrdev);
>  	if (jrpriv->hwrng)
>  		caam_rng_exit(jrdev->parent);
>=20
> --
> 2.26.1
>=20

