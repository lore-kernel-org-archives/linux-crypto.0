Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4838DE0
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 06:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QNHmhWZ9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inED+X4XL9MGCqmUOQ56h+iMdfdRaU+9+7+Ky5772xD8ZZO2vEfMOXNyxtP+B7aBaHD7B5kxXYMyJyqaNcLGvp0xb1FdFcEK59r3Rk8bamVQ7gKnILVZWRi+1nxBFPIMa6Zpp4Mx3IDO+hioWdFOWJ70X3mo5jpBRE3t/YTrVkw9db/Us+t0hPQth72m3+8Rc4V2YSn6i6F9Hk1U12voeHPjn9cbmvhlMERbxinbtwiSWOBZsvLGY6IKM5J5qTs2Hed1NDzyToX6tNrJKd0INxpPtJO75fwL+3PcJ+p3PDS+er7VbqDgr20QeP/8LybV/d5xfYt5YkI4PemAlI7r0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y12yxuNhwykZoRD8p4d6E/QvTEePgvmE2xfaYoa/UN8=;
 b=Ax7chPIXSoH1RVXS/1BBSTKJPnxh6lX74nub6FfMPCe9hiVZqkPpiXdDfDq7RCDs/5Wb4O1gAQq2fG246HSNTXunUSyzw/K4AdgJWlhe+0nX5NQhp8EfAV3JgzDnijyJR7cj0txsC4WnEVunwpqqW4fUNPRzzen7uHndarWtgQNbZbuIOesmgEUrjS2Xo2X1a3kWj+0SWKiSE2gaLB6xbBKq/D7XRsrIse1zj7xdmZxAoG9TPlWog3wtB8h5EObYWN9ed2Mr57k1RBLGu18m+ysBbxXKgST4TXEVZfOrLRQdCmuISs1/HOZUzgHqyNEN+L3KKSZTbnhSSxbe5505OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y12yxuNhwykZoRD8p4d6E/QvTEePgvmE2xfaYoa/UN8=;
 b=QNHmhWZ9c96nXyhvNN3Zgjn9YIkPf/ZvXNP+zbj9k8Z4sMC6QVwBeHsMIKRIxKWmwtFWBGCTOpQyUsvqPLJ36HjTM1kV2staFIyGY6WgjXSGaQ3VuZNeI5wHqX+z1uKTc0nP9LUL5tOk/Fy7FYbD/ePIKomVYzd60/DrtD014sg=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM8PR04MB8020.eurprd04.prod.outlook.com (2603:10a6:20b:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.27; Wed, 10 Jan
 2024 06:57:14 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f%4]) with mapi id 15.20.7181.015; Wed, 10 Jan 2024
 06:57:14 +0000
From: "Gaurav Jain (OSS)" <gaurav.jain@oss.nxp.com>
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
Thread-Index: AQHaNMwOxUV8nN6ZdU+iTMBQ8cWhj7C1MDwAgB0zeICAAFCfAA==
Date: Wed, 10 Jan 2024 06:57:14 +0000
Message-ID:
 <AM0PR04MB6004AE608B452F9C237AF1CDE7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
References:
 <AM0PR04MB600494E7DA11E8853C57566EE794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <20240110013905.2241490-1-Kun.Song@windriver.com>
In-Reply-To: <20240110013905.2241490-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM8PR04MB8020:EE_
x-ms-office365-filtering-correlation-id: 8a670e06-c129-48de-fa90-08dc11a9605f
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SpiLpcLgU8RxyBqdNEscjXXZys53AYLLzxvPj9XbznXPprOVjykBSXa7kQdw7o7rYMP2l31fVqgCvW6aCQ1MGYgj/03KQ/n/kzBevVsnRADsNHXzYwiDb9wkT30epoNFiD1QhJG+1f312g5TwOmPso/xv3iLso44eQmB+EmHaJsvcX3CST08QUVSJ5SyiIyu8Llhzdn4Pa9aJrTv8Xykndi2lYmIQECl0xd7jcoI71AzEnPt+YnGvZm3Y/5QxtFh8eq8xXHgdhbxxEgXEv8/wsSsn7BzLCky87fSGarJjn/c0AP/oXV1RgNyVYlfGo6xaIHh3g8hffLO9aDFTPv19qbcCuvM+uZzf74M7AcYTMdQJPFFtVOsMdzfhqWLBZlPFhU3/FmPNZig+KsvIrRWbLDpaxtVdh12yuJP7W0AcmMFXDEAXwL2nNGYY81PemL+IngwAvnVzF8m5QyAA81Ha7LdFTa2eL2VroN6ffR1CZ9zZHFYgElz3jEmdVkdaNIHPSFB2Ir97nVQfjMpq9QN57G3uOu3X7zp5a6i6/HWVqroOT8tIBiYFgnBey9BcLTIchk6M39pGoM6v+9Oyl0VHmx+mPgZFxE4WNa/m3DGAwnDn+TSJb6s5dOMdgi/9++M
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(6506007)(9686003)(5660300002)(53546011)(55236004)(4743002)(26005)(122000001)(38100700002)(4326008)(52536014)(8936002)(8676002)(2906002)(7696005)(64756008)(54906003)(478600001)(71200400001)(6916009)(66446008)(66476007)(66556008)(66946007)(316002)(76116006)(41300700001)(38070700009)(86362001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xDfsNQEe0ejAS+0JBP/TL0g2CvpcPWtTqeT3oT6yGJRCnPEQ1TyUyyjTjpbl?=
 =?us-ascii?Q?MOjWYtGF717pCPFzm4c0gWE6gpHdhyKPySL5G9CArjNgTGIo0xnGrW8rVmuF?=
 =?us-ascii?Q?eUS/zBcTJxynU1OfaVMHpprT75VZUMchVqGILcblQGCYn86Dvi1/h32eWEjC?=
 =?us-ascii?Q?O4SXqVApzG5o66F7h8SKbyRvOXFNKIYV382p/kGShYlQuf8dM7loGox4FVqK?=
 =?us-ascii?Q?w5HOLwisMU3FljwA0CVJ0t/C59dr2xCjQXE4n8Ie9myfAzC7wOzW4pPv+9Xb?=
 =?us-ascii?Q?9Gr8lihubRSjepxg4dGReC3OgZLeDpLLqcI0oGjZaWP08HEKjIDtyfxHotlx?=
 =?us-ascii?Q?sA6wJMwVYOxlEhsd9tzxVlcGb67OlNH7f1ghthSXCYR+NoMkGrwQ7162lumI?=
 =?us-ascii?Q?besPE3zufnKaUCuih0J7HEkTZi/R8Zf4ILwIgZdfP6uueFp/aPiu1Faoi5bI?=
 =?us-ascii?Q?Wm9Gf5TZD2z5WuWZ9y09KscznfxnHOqFA48lKHpZU3PxGSyNVh8+UptZmm6j?=
 =?us-ascii?Q?GPtEoVRAH/dy+Ob/Tq6YYUvevXJegsh3JGOB4w2yEpuXmzSZt07xaNSPK1eE?=
 =?us-ascii?Q?+Dk3lkPcVI2EHMjWMBZbXQ9oWpAEvVp8tARa43W4rXMmg7M6TtUpxogja627?=
 =?us-ascii?Q?xzyBpxPqFoUKsX1PIEz+VgDyo1IwuSMxF4RAVwjkFOg95JeeqEd314bF1OEx?=
 =?us-ascii?Q?rWqURDzhVyrQ+IoWMdRScf+OlnUEm6eEjy3UFY9bgPGDnj9CkAw9agLTabnv?=
 =?us-ascii?Q?1HxnB7MRwDWcRZVSuuboTf21A26TDM804L/STwpk4QsURbcy7VTsGheVqyCu?=
 =?us-ascii?Q?vf+sxE3jC9uK782Q3GbDXetdHPnUtbbIrHPzRMQKqH8gFjrsl958ekeYemdr?=
 =?us-ascii?Q?lagKi4PgSEYAQ7z2WCZv3+Muhc6zZpBk0DKl/uf3pkBW7/GIh5I1fnOV8J3l?=
 =?us-ascii?Q?kMC/cq5rTP/6GVAEWxajBE9DEGRXcQYI94Orj6LmewDqPePayIO4OlruQp+l?=
 =?us-ascii?Q?Bvzwot/O4HsVsne1Fc57BsJx948QsGERIUcwSiIiPE3ZZ4PR3VQv/Rm0D8tb?=
 =?us-ascii?Q?NdNwsoiO3Q+LGlJKw2H5XTdjvv0N3v1Q2M2/5/pR7uqLzmC4/oVO07k/AI2P?=
 =?us-ascii?Q?g0VGsJwtgWQnX3I5hTVXfaDrIrNQyRrXZR4j6l4btTs0qUhafTOg0mr5CBg9?=
 =?us-ascii?Q?KXSgc3pts7wbVElf7Fe2jpsJX3th0FLRl8Z3tgGngxAwaQBumpsNpDlr6g8m?=
 =?us-ascii?Q?bVks9AVQDSu8hhMEQrlkR93752b+6xhxQaNyd7glCiDMugZb/j3a0TktpJZQ?=
 =?us-ascii?Q?lL6R2ajhun+4Jt/RfBd2cLB63en2TyRuH8C+o5Fyd7mOzT4Tt794Q+N4g9Ng?=
 =?us-ascii?Q?A1GmV0TbwarmK4N4Zh9HGIwz3g0PDAYcYLkRp0nUicF1x0QPtsOihjvUaujv?=
 =?us-ascii?Q?suXHmmiA6RxiWQNzhZiJP3E/i8rrSzpotzm4pdXRR+Qf4FxHD/2z8Q05rxkj?=
 =?us-ascii?Q?XxM9oVzkYmJNlPGrVQ77xsIjT9yyxsEdIrd6TTiX4RifAGpCrwhG3cfWTwDh?=
 =?us-ascii?Q?WGNR1ec8UjGh6cCy3DNbxLg54bpyc9BgaMq1/AMP?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a670e06-c129-48de-fa90-08dc11a9605f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 06:57:14.3243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLqwb7G1cAw5GAxXA23iIO3PVznBjyIDyyAEWfuQICLPvnMhsVGXoksfGSy6Kb4XpY6MKhVHgyVJzMLc8STKPQ==
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
