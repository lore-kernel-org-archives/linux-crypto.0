Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2053.outbound.protection.outlook.com [40.107.14.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A214A9A
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="T/1crYdz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7B5zKlcacxYtpQUbzDWBhpTL4h7i9N+A7zcAuxGCIKL5Mnx7Ivoh+tas4j88qxRAn5Iu5jOpZPW0l9MlC7Du8BW1oMjxLulOaarM8J6X8h+KOlKT1ez/t7I9fFgJqdOmsTLVOP/VYSkNkYLnwDWWdbiWF/2RSaAg+X7PTnH+Xv9pYsDio8q6j4wkjX2VWw9Kc4DxLWf/h86kagBm6TshwL/9dIyofDqz1ROUOWsY765RN19NwP04Ii4fgSAZnIrW/Xp4FJrMawWPL1GFUjZJcCdnxBY79Lbb30aHaZkbrsIBEYsG++OoG4V7uIXyoho/HXlYM3gwrVMgJzRXJ81mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1Ee7sAL1vjFI90rYXC5uXnZVT4up8wDzuG1xIKCsAA=;
 b=JCh/rUGF37YyRyZ+qEIG5MUUy3uWX1EoAvElFGM8Sx+9fZYYrYO2e0rxsWhDSQWg5CWIyQgqoc7MCgEnri90w1EjAXip5jDKSqlFO7PIJUrb/ff6xZwiCgqTqarcUeXN6lxeoyvqjQeFjPvOVPiSWwihbkcmSu9Joft2glC+4jpaWHWyjEeQZBy5dmZ7q/Mj5HjX14JGf91en3wqufTDg+5rGEQ/GN8Jq5R4GNbVaWi6LXgeAeeIZeRsgFMnNqN/aMLsOJ/adgvt50+CAAFAjuc6tNR+/PrcZXOJ6aK0i0qmKub11p9gPnViFhB6lw+5/Ou+p3qP7e4WyMB4Iy5MHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1Ee7sAL1vjFI90rYXC5uXnZVT4up8wDzuG1xIKCsAA=;
 b=T/1crYdzAj0PwxDXJrNZRoduMS4smvYa0jgc+DDmGEjVnY23Lk6+tNePc10PcIPOtk6gfYauFzdsZMUOxPoZgmuI/4OyrBpBSTCxERejN2bAIPTBhNUpFSn7GR+oL1Up1Smoynb6GXiDd8XWt0SKZsFgTe5rgKUr8sN5DIeG5Dc=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by GV1PR04MB9199.eurprd04.prod.outlook.com (2603:10a6:150:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Fri, 22 Dec
 2023 10:49:57 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::f62e:ed0f:3b06:a7d8%7]) with mapi id 15.20.7113.019; Fri, 22 Dec 2023
 10:49:57 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Linux Crypto
 Mailing List <linux-crypto@vger.kernel.org>
CC: Ondrej Mosnacek <omosnace@redhat.com>
Subject: RE: [EXT] caam test failures with libkcapi
Thread-Topic: [EXT] caam test failures with libkcapi
Thread-Index: AQHaNIUs5x+vRqPNKUaISMpgxN6Xu7C1H2qw
Date: Fri, 22 Dec 2023 10:49:57 +0000
Message-ID:
 <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <ZYT/beBEO7dAlVO2@gondor.apana.org.au>
In-Reply-To: <ZYT/beBEO7dAlVO2@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|GV1PR04MB9199:EE_
x-ms-office365-filtering-correlation-id: fa30f181-71d6-4e00-7895-08dc02dbbd38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 jcoC7y3i949TYvx+QBO27qu2N40AxHe3Zqp2LGGe1AlyGIkj0XJJ8JOo5hqlz1Ch7P1LH7QLuk/G1EGPIWm7fmcUwjIAVGxd1uMJXvIt9D+mapjR/Zt5z0LTl0vxAaqUKDq3iMqYslsG4My33KRk3qwR9FoaxzFk4p3/Ti01kQM8t6spJuNyxooWRDN/IYP6xUbtfLW3fFe1p5fO/ONEdkuYGKzYtnIyGH2PUWRe95FdvqwTIy+gBfxAhjeCpnftCiTC2Kx0GQFpUxIm4rrk+uVhxzP92Fes5JCi8ChbE2HMUmyK01/lEE1dqBEG7jSAR8BwlhPGAWdwTqqh6pKIBCzahVN0YmTA8XpqFIw0UESpmBk0RP+jkJrI3+VvqCZcOAmUwFm9PH+wInxeKxqi8EfXZoJC1xplk8u6x5kq4N6morAbRIFQNwi8lDN5SF8ZHWJaSOTx+YjkDdY1iVfVTYh6GQE5mdmVSldmZwISYbpcWsd2rhfxGqozEgsmBdVZi9ak+Iabv2dPMlzsUE7y/sSmhywRsVtJECFaseki3guDFPmv/aCd7FrV829qwLi9xcm8ibw19U8X8n4i0ece8bqMsndXUdS5NK+Zh9kTaB5b1FZ7UvXI0pL7rCtNfp7tHZXVq+RwPN5E1c6PTs4j2A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(366004)(136003)(230922051799003)(230273577357003)(230173577357003)(1800799012)(451199024)(186009)(64100799003)(316002)(55016003)(2906002)(26005)(478600001)(83380400001)(64756008)(110136005)(66556008)(66476007)(66446008)(76116006)(66946007)(53546011)(5660300002)(9686003)(55236004)(71200400001)(7696005)(6506007)(4326008)(52536014)(8936002)(8676002)(45080400002)(44832011)(38100700002)(122000001)(966005)(41300700001)(33656002)(86362001)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?svnIl51n55Oi0G+b/TZ2wFT7f3ZBbn53TFWTgCVQBtK2PCtKG8Sq1ke+tIvr?=
 =?us-ascii?Q?fxy/KfNna02CZjm7KZD69ovypjL8K/Mn6/FcFT19Qg5bjnr1cfeYOLL8/5h+?=
 =?us-ascii?Q?sUBaBC9uSvdBd4SWA5Z3uczYoc0Ku1c1jBNS2DYYxHI9O5EYEaNF85YDwhtY?=
 =?us-ascii?Q?mjFjAbOA1tqElJHrlrKuNmiHoaPB6H70r37DSW1j9aEvZpKOmJFo76Bu+Y/a?=
 =?us-ascii?Q?e2i7cYXhBYvWwxQvYQL4cVQ9Gcfqzfu4/bZbjGQJY1u3uB0xrL2G2qfLWB+B?=
 =?us-ascii?Q?K5Z2z1f1KZHIIOXDgz23zcdyQsoAJwD5Hsg/U4C5npK86tj0zpNOEnaROM25?=
 =?us-ascii?Q?iM5DvfpQlV7iViUrfAxXOX0wQEIJlldvo+rL1/owMO01JVuCg33GsFlpgRs1?=
 =?us-ascii?Q?L9+6TtQ2sc6Y7zyP5CoCVsLSBmKjxPQoGNSFeJpJzcU9Bb9VHV1yXTKx5nNX?=
 =?us-ascii?Q?UW5s/5ijvPEUSoT/6ze9XQ43ZQxbA29J1PhowUhfDLw5XyCr7WVgQdOt6VHy?=
 =?us-ascii?Q?wU6hjbrcWWk4L5goeaUEkobSuZMNlRp8lCox55YVJQYKVglizpYYGx7yaLCy?=
 =?us-ascii?Q?YG6kc9/CaMXFI10JmPmjwOlJ4L1XlDObWCPhmH+A3Uq0ox9B5LO6DNRJovON?=
 =?us-ascii?Q?p/J/wXGjO+RzMUgqWwRPf00E0oVly35G3Ja+osGaKpmu3AigkDziHjZGC5S5?=
 =?us-ascii?Q?IE32BFI9vCco/HlixuVlI+q35E0+7vg2WD9/DMLko1XGBS7EheUVVSsF+LFJ?=
 =?us-ascii?Q?ruW0X1kYNdVJKoAX3CotbOTOUsHDvKYzELtq7yqlQEunJV4GVJyd4a+Ef43p?=
 =?us-ascii?Q?6N9u6lk3U6ANMpcGCq3qq/Bhbbo2UW0EEaSqikaoXuloY2Pep/WwM+KBSq8s?=
 =?us-ascii?Q?WL22NtIInK+TwsoWslbSTsbYJswwf46H8jWGVMkzUsUyTRuzKXZR1FhBXOV6?=
 =?us-ascii?Q?8LTohtB+Xd9C2L5rDppLYs2Zfc4IqTVqn/Sp45iBKOcfYwD02w3IeSQVX7HI?=
 =?us-ascii?Q?6P4zfo24sk7vyDytSkqSGaK/d7WmayTXr3HbEWFv6xva07ZiWKPaeHR7frBq?=
 =?us-ascii?Q?3QLRMeZUZWhmvG5QefFbAn5nktQ3oMcsYDb+zL6GxeqmkjvuAE9bUjdLo2z9?=
 =?us-ascii?Q?hR/ZiDxbNUvHKd09otVi8Su2hK3iqH0gEX7laPSYYH8QuTz1876QfAJteR9r?=
 =?us-ascii?Q?0DNvFF02C0Kn6N+2XtADNo/921JiG4XvXUtZZAGz6zPl3szJfhaHL8Ug4tzM?=
 =?us-ascii?Q?+FOWWEWtWBb/VNBCYxeH/28v4eoiU3w1P6hl2pySRGjwdWlOTyqWHgLhHBcQ?=
 =?us-ascii?Q?SFDDvk2jAsbAFLCJnQMVlCkFTublFJtBMlLd/S48ksBbykIvwFe+7bcy3vLU?=
 =?us-ascii?Q?S29aSxhuGDV3ovSGxIcOHa7QuidnrLgXuJf8q6YhXmGLO//HYg8vtxok32k9?=
 =?us-ascii?Q?Mo+s1iLlK8G2d9PRBVF7WadJ/r/oy/7kuKhiU7HWGN/G+MCJ860I6AjCD9wA?=
 =?us-ascii?Q?HYVy3aXHZV9U/kOFM5AzxMcocQCQL8m/Mk1D63lmmW142hU+SuodMrNErHcG?=
 =?us-ascii?Q?EOPZlalSD5UYHDfs0nFWNfc/hUaxgmjFMGYCYc1A?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fa30f181-71d6-4e00-7895-08dc02dbbd38
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2023 10:49:57.5128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AuYcLc2WGXCqaoUfGm+aaJFVeS/NF5lfqntu2zqp6uehQDF+g/Mvh+BweHck19ONIeN3NZU3o0cipDHAA3cb9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9199

Hi Herbert

tcrypt tests are passing with kernel crypto CAAM driver. Can you please sha=
re the logs for libkcapi test failures.

Regards
Gaurav Jain

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, December 22, 2023 8:46 AM
> To: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Linux Crypto
> Mailing List <linux-crypto@vger.kernel.org>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Subject: [EXT] caam test failures with libkcapi
>
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>
>
> Hi:
>
> It's been brought to my attention that the caam driver fails with libkcap=
i test
> suite:
>
>
> https://github.co/
> m%2FsmuellerDD%2Flibkcapi%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%
> 7C3dad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c5c30
> 1635%7C0%7C0%7C638388117546628060%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> 3000%7C%7C%7C&sdata=3DaQ2MLvyfioDjh8a1c600f8A5sTMSlaPSckg8QY6RpVs%
> 3D&reserved=3D0
>
> Can you please have a look into this? It would also be useful to get some
> confirmation that caam still passes the extra fuzzing tests.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.ap/
> ana.org.au%2F~herbert%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C3d
> ad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c5c301635
> %7C0%7C0%7C638388117546784331%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> %7C%7C%7C&sdata=3D9YTdCRpZOzKmkYlMKhGvBkuvVG9tmg%2FQ4Y1VnLuVGCg
> %3D&reserved=3D0
> PGP Key:
> http://gondor.ap/
> ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C02%7Cgaurav.jain%40nxp.c
> om%7C3dad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c
> 5c301635%7C0%7C0%7C638388117546784331%7CUnknown%7CTWFpbGZsb3d
> 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D
> %7C3000%7C%7C%7C&sdata=3Djf80tCyfL65DjtCqNfX%2BYnEKIC%2FG8PL63LiZyP
> GGgdk%3D&reserved=3D0
