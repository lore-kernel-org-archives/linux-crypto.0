Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2051.outbound.protection.outlook.com [40.107.20.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2959B364A9
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 07:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="HRkOHKEK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MppfVbCGfk0sN0erH3MCi5yOf49c0IvmmhC7D3IsjZYJsWarICRdubT29txlpVbdN9cYm6m1z+KY+kQRPphM/v7yOP74qlnTHSeUR1erLKgY7Q29NtqTZvfdGqwRMfRELIhqLLoniVbPVe5+Ngvm7RRd5os+SwQTFs8jOrpsDGFH1ARb0lAfZAxFmuHoke3gmy5lDL/wpM5gNt0NfqWYO0ixaFu/+bZkPjO18Ss0q1S1yt0IdIiWkCbnUqtQbNVUroANm0SeI5rtOW7hlmmzWqw9hZmuezctbMTKsC1DIFyUvsj0V0oBbVCjkVk8gCPKj+CxuMV7lutyyke6EiqoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXUZp3Xv6mfQ3mv4nefghhG00Gcf1dorwj9wpVLLdnI=;
 b=Pt/XF301iFoGaTDvMkcEazVqVGHEOfDJT+7NDwm97NmxMgDSh1FlIRcaGrqbCrCwLSevuSJoMzR4TZDT0dfi1CS4TLIqNpKucC15h8dLn1/62RemExFbOFSSUb9DgpuOAUa7gRjEjYK/n+Uwfd9cwLPIGWAm4q4kPND/7q/NYRsra7VIQsMXxaieBYB4pmwxJ6/5yxcwkQo/LRaC4eGWWROh3on9UniJyaads6uxEMG+7Sl2eNLwh3gkivEQv4RfwpeU4uRGXQ4lBfjSjZIf69Oc6qJqNxjdiGFJ50TbotpTQHwQDwE2a3zBC8w7qpL79O13O0UO+S0atFexTVM/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXUZp3Xv6mfQ3mv4nefghhG00Gcf1dorwj9wpVLLdnI=;
 b=HRkOHKEKuw4W346iGeTVV1S1s8tiVC3tpD8VNT06a6qQ0I31e1uNBM0NWK8j1zAqnisSvQ47pcY5QFdgkNyRmf9RC9T0WJOO6Bxst4GAugrENrrgzHOMyrxnPz0bKPEE6lRP+umixoZ3jhMOXwPP+VBx5CbBU8wTybbLVGnAWK0=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM8PR04MB8020.eurprd04.prod.outlook.com (2603:10a6:20b:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.27; Wed, 10 Jan
 2024 07:00:30 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f%4]) with mapi id 15.20.7181.015; Wed, 10 Jan 2024
 07:00:30 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Kun Song <Kun.Song@windriver.com>
CC: Varun Sethi <V.Sethi@nxp.com>, Aymen Sghaier <aymen.sghaier@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "filip.pudak@windriver.com"
	<filip.pudak@windriver.com>, "heng.guo@windriver.com"
	<heng.guo@windriver.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Meenakshi
 Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: RE: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible
 caam_jr crash 
Thread-Topic: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible
 caam_jr crash 
Thread-Index: AQHaNMwOxUV8nN6ZdU+iTMBQ8cWhj7C1MDwAgB0zeICAAFme0A==
Date: Wed, 10 Jan 2024 07:00:30 +0000
Message-ID:
 <AM0PR04MB6004B82755A53A216D2EFA13E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
References:
 <AM0PR04MB600494E7DA11E8853C57566EE794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <20240110013905.2241490-1-Kun.Song@windriver.com>
In-Reply-To: <20240110013905.2241490-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM8PR04MB8020:EE_
x-ms-office365-filtering-correlation-id: d9bec9c8-33f9-4917-7acf-08dc11a9d522
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 RktQeSOhrRqCoIndVxg6vITKEj/pi8OciN+0R8TW+lje/sh0Yh2Dgr9cNlhHSdXDJZ1RcThQsj09TGdfwaurIQ2GaY8iqdaIAT63WWMpLvHSL6lDDOWWE9U3l3UqN8w718Y1o2RF7KLOnFDTR/+2tSKu+ADLW4R8GuW9iZgfFmclXiSn790w3FiuLR38/GHV6TDAXaFAWpYxJr/4oyjM/AObQSmBF7u3gz6RRXdNYmo9uCERDL1KUdAcv9IeKxOPuwRT8fHHn/BWs2UeWK2qGP9vqG3cQVHJJc4VxECrqW082+ip2g7YWbHss9xZtVDGDuB3elKPSw7wgRI920r+2oI4iv28TzOvkHtCG1TSoJaDB4kq+h5UhKSqSIlzCO2fKLmUtxQuaSkeUwi0QppHAr4envv1HysL95fGBDYvdmzdSkCLxKcprC3MHPOPJenV2CTaNpjZb/nf1xgvHq3GRzeQ4W6HWmGcwTk85ExdebVOuG8J6S0MiKGnRqLHLU0OnhY1P+8nK12pRauM0U++ROJm4sX7YCGrG+WznuMhM3kMf9Kdg7ToweTZB1Iu6SOaHgLyyX1VjtIhz4a0GukUdcOGH4uT+lPKsKQMxiFepUROYydb88242jMq6AgT94zV
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(6506007)(9686003)(5660300002)(53546011)(55236004)(4743002)(26005)(122000001)(38100700002)(4326008)(52536014)(44832011)(8936002)(8676002)(2906002)(7696005)(64756008)(54906003)(478600001)(71200400001)(6916009)(66446008)(66476007)(66556008)(66946007)(316002)(76116006)(41300700001)(38070700009)(86362001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?U5mK8t6vcJY/WrngGbj5B9coG79Dl5klM9aemNyCJ+tHQ8jTmCKy81XB6ay8?=
 =?us-ascii?Q?1hjnLxNsIhn3tL5gZba7vujAV2r9UHpbIxDO9gCDLDyp8uq+bILmwdveiuhk?=
 =?us-ascii?Q?VqrEhVQPNcEJun39Rr0Ih1EGkAPnv9C0Vt5PVLKZtwFfUkNWCHd1Q1bfgh3E?=
 =?us-ascii?Q?GfPsma92ICItvtc1v8JqG1ydGptHFa+2RvrLm2/RCCtF5uxcDIUpBKgeSnQo?=
 =?us-ascii?Q?9Kf3pQjaAbvEGBXIycaXkP6CIdcBd8R96KMJml7ZNE/KtPeCng3qh6w3oQGJ?=
 =?us-ascii?Q?R6PN6BhbKA+CSKhxN6ZdlejL9+M74EmSCyNB9/+DS7K78fUzVjN6Aw5xFN9a?=
 =?us-ascii?Q?skA2x6ZSht73HOLqQYrTtB9Qm4jbUdIl0770BXFsL4pCjszc3+CiNjf9GfOp?=
 =?us-ascii?Q?XN1uDJclbkZ+Lhl2Psgdcbp/qpltuYhDzNO1PPC+NMFe2OhCpJpZs01AvXba?=
 =?us-ascii?Q?3T/0WrQLrqRPwFMQY+UE+/Xf+GtyQ5pXK8vTnEC94GYw0pa6URrpv4f0JoMu?=
 =?us-ascii?Q?jr/OmVTqCAdyHWORsSPR5SrcHPDKyc5XnJevYOHAzxJmeFuTR2ZwED/t3e34?=
 =?us-ascii?Q?imtr9XKDDB8rVT0aVUmLcZB8GCdV1ZUAbb24RGOC3TbS8c0qY+kGqwgq0npI?=
 =?us-ascii?Q?bqp6YhRfzq7LxHOGCot33JBmfqT5QoqLdekTDbmHnT3Uj/spUh3p/tVBnqpq?=
 =?us-ascii?Q?C29jVOlBRiMA+u76pDqynohtGL2hujckW/srSuhOWIuN2ffHunrN78WflHoA?=
 =?us-ascii?Q?RfCvChkLZ2C4cDY/j/i/vBw9WF4tCugorI2x2Sa1SA2nbQYp7X2Id5qphVBZ?=
 =?us-ascii?Q?p35/31ODE9bC3ez/Pa5viM0vEj+0Ui0LHGDMxWPOlPdUTaOWktZxtr4kRd+m?=
 =?us-ascii?Q?coZknsrVkqoqvmsu/iS7rSOR/AKgXbi23anyfsDAAHWhNeK72tibIEzYAM6a?=
 =?us-ascii?Q?ikljK/PkJAc2xJH2hfq+ujB+Iu+u0POPtarY91CQWTFGw/CHxOaHvGFltl1D?=
 =?us-ascii?Q?BfgLhG13sccn05aPsRdnTuO2JNAJOHflMWvHhut/ZYKfQa20alu7cOKwupnY?=
 =?us-ascii?Q?UfdylETtTRwgi6h6P2wFUZCxNAYwN/YAgUUj9+l4XXmO0bmfEhhGCW5Xl3+9?=
 =?us-ascii?Q?FGMePqNEpbvu0Iz+IXFmao09LTlaF+Zmo5x5l3aN9pkieVkCVZKq1el9t6ez?=
 =?us-ascii?Q?ygdIOfJjfHM/NBA9RxLNBgfbHRQUM2gvoQq+TwliaJABGpMBXMmyx63aXu0G?=
 =?us-ascii?Q?3XPWO4OdQIAKCQplmIXvS3bmYrwRcg7ZNfPvrmW8kVcEYciHxet9NOY2jUTq?=
 =?us-ascii?Q?8J6RhWHG8OgLRSiu9b7mbGqkCpQ0GzMT5F3HAEDFnTOwtn9kT1Mwj1/Bghax?=
 =?us-ascii?Q?Prv/8dBSvRVaG7KZwI+BdrhX59FzAihIJpFumd7U+z6IeIrv0yDM0M6ZlNXf?=
 =?us-ascii?Q?bAggLA9WhZ5tYQs0yuTq+Dgevx6ZyNURR3BkdtmRaAY5uiV/6USBJ3HBlkyF?=
 =?us-ascii?Q?gmoLCqLs0IBvzYXTwWAu4nFKzGGm5nMQH2UscZrvJ5kklGfC3fRu/VZp5aB3?=
 =?us-ascii?Q?eBSWXlsg82NoHr61vi9z+8fTxYy6ZrqA8FkT1OmU?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bec9c8-33f9-4917-7acf-08dc11a9d522
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 07:00:30.2265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t78mklrvHmVaZjVg7CVgdLbm0Y+wv8ouLCGZMooZ157yr1IFKHf9chHU6sS2qzXwgZi9d6ldzaXLqwf/6ZDWXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8020

Hello SK

I am submitting and replying patches using gaurav.jain@nxp.com

In Later kernel versions we have provided fixes related to job ring flush a=
nd there are other changes as well.
It would be better to add these changes on top of 5.10 tree as we also run =
multiple tests and not observed this issue.

Regards
Gaurav Jain

> -----Original Message-----
> From: Kun Song <Kun.Song@windriver.com>
> Sent: Wednesday, January 10, 2024 7:09 AM
> To: Gaurav Jain (OSS) <gaurav.jain@oss.nxp.com>
> Cc: Kun.Song@windriver.com; Varun Sethi <V.Sethi@nxp.com>; Aymen Sghaier
> <aymen.sghaier@nxp.com>; davem@davemloft.net; filip.pudak@windriver.com;
> heng.guo@windriver.com; herbert@gondor.apana.org.au; Horia Geanta
> <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org; Meenakshi Aggarwal
> <meenakshi.aggarwal@nxp.com>
> Subject: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible ca=
am_jr
> crash
>=20
> Hello Gaurav,
>=20
>   I hope you receive this email. I'm following up on a patch I submitted =
a few
> weeks ago. There doesn't seem to be any response yet and I want to make s=
ure
> it gets pushed forward.
>=20
>   I know you're busy and thank you for taking the time to focus on this.I=
f you
> have any concerns or feedback please let me know and I'll be happy to add=
ress it.
>=20
> Best regards,
> SK
