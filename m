Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C35EC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F36212146F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IY7iy47U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfBYOWT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:22:19 -0500
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:17742
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726099AbfBYOWT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 09:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmGY7PgsI/hLKPPbBT5+anjT9mJMMwhSVdLj14ZLcwo=;
 b=IY7iy47U4tDOqY/xmst4kCfHAH6g7vr9UUhGTBzKNClgrfV8Tux3mLcu4NeboIGDmVq5uqKY/TXZfDsJ+l/4LzA62cEYo0Z9UKtu/fECNp5psO2pehPHBEAaGJH0pviDG2jaDjLqoCiNkgJ0RzYEEJhJ8kC+1kbfFoWVH8PKqqc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2863.eurprd04.prod.outlook.com (10.175.23.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Mon, 25 Feb 2019 14:22:13 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e%3]) with mapi id 15.20.1643.019; Mon, 25 Feb 2019
 14:22:13 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     "spencercw@gmail.com" <spencercw@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Topic: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Index: AQHUypZsrSD4izM7BUuBqlVaxZEyMQ==
Date:   Mon, 25 Feb 2019 14:22:13 +0000
Message-ID: <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1668e52e-fb30-4b93-a6db-08d69b2ca322
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB2863;
x-ms-traffictypediagnostic: VI1PR0402MB2863:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB2863;23:XCDAcmo58BuLGF7C6JyfQtf5ZukORQUB3gNHuwK?=
 =?us-ascii?Q?07DI9x9oroA5UaqQhcn2JmFB0sqZlifZpjJbbuTFSPs9A3RS805xqTZ9GCxm?=
 =?us-ascii?Q?FKNsWXwTyLF5H9YPbpcS+L+NwQCSZOu5cSmkP7T/xMdM240yMZGYMvOKoBov?=
 =?us-ascii?Q?kn94ZytHZR1oSceRab4Jcgfny57HaqJadvwjGCNj1gwx02xCSeFp2VXiMUr3?=
 =?us-ascii?Q?QmrKazE9NJ5KreAoeCfVzK/s3DGwKTH4AQeS2+z+rGgzUr/2PjEAkaGlrEEx?=
 =?us-ascii?Q?qs5l93ffpDX+Ovl/MEjCteWfJ4vs75vs6ZQkgl0/guwyiadLE/0nIf23yLXv?=
 =?us-ascii?Q?gV6WObZG3lKT+4MUyfXbzGj/7GGJlekR8/tV0OeZ7Hi1O/8ayS4fnh8vmtjb?=
 =?us-ascii?Q?fIDdgCavCIFqNWnJRJ6pnGTvJjkcpbJk2wwjfyV4bEfNnCtKpwF/f0GWoIAz?=
 =?us-ascii?Q?2nUMYhGcdFMwDl8XQ+LFsqwt14Mc1JcUcQK7FBI6Xs7R2NRhMxESr+4dadda?=
 =?us-ascii?Q?QLeNkVaoBW5ccvGSjKVUG9aczNfRb2nkQUZgyxq79OPCqRm2xo30NJ4Y6OKu?=
 =?us-ascii?Q?E0vnC/XU2gXt757mw83093VrifhHjZUyM4mbFu1b/J0bik/IYx/zje6mt20Z?=
 =?us-ascii?Q?gFx52FU0P72/ZwP1MLvBzMjpjs4+k3laBF1XiJ9dEOD+7IJjbNL9p7oUPdEo?=
 =?us-ascii?Q?RQTCbxLLnaojYJ/euaKnuE2vVFCpSJUYWehDVS9AJx4b6MI/NvsVUEzpDTNN?=
 =?us-ascii?Q?1cKIF9bO4C1cUYVWG4iJD7rRQMsQ2IlM0KplHb2v3/kvbm4rX9c4v34wsFXS?=
 =?us-ascii?Q?3FqfjZpnMz4h/WuJXKW3lH/Y2x0ZAR5dNeO66g0VCS+MxYpt34uKomeVvVOG?=
 =?us-ascii?Q?ci/NOUUU0ecJ+qdnJwiMr/6pOjgKOjLV28ZGoU1Zz65VaNlHZ1OQktIsZik7?=
 =?us-ascii?Q?YHEzFX8Eq4a6teLvInQCydu4FKEx8x5zD5+c9pgXYob30riPtL6otGqjKDWN?=
 =?us-ascii?Q?qje9B0MwPK1Bzu444Rl51/TzJBDoVaIa5h09srVwT8NMBL6gL07K4NwJvH5U?=
 =?us-ascii?Q?crccE2EqK2a2ZvV1BJiuszSh0N3nOvKSnIbkRg2UALQ7+fZi65J/XkG/nx7y?=
 =?us-ascii?Q?LHQoCo/+tdCoItD3xZdyfxwLg4j29pt51gCHfxzMKHTS58+Iiss+DXfeRgYt?=
 =?us-ascii?Q?vDd9+U8C+2LiOi/oNa3XU714qSkwKWWmk2cwl0bntzB+CoFdHjbttXmKCGau?=
 =?us-ascii?Q?IqZAcqvTsaKLDDrRmCduzJAbVTAWl0kyJq20BDtjgwFVfD8vI6MjtB+TbPPH?=
 =?us-ascii?Q?ldQ=3D=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB2863BC83808A363CF0C4DDEE987A0@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(136003)(376002)(346002)(396003)(199004)(189003)(3846002)(86362001)(81156014)(8676002)(6116002)(14454004)(4326008)(305945005)(256004)(6246003)(99286004)(76176011)(105586002)(7696005)(7736002)(106356001)(25786009)(71190400001)(71200400001)(186003)(54906003)(68736007)(9686003)(53936002)(26005)(55016002)(6436002)(8936002)(476003)(446003)(97736004)(5660300002)(33656002)(66066001)(52536013)(110136005)(6636002)(74316002)(2906002)(53546011)(6506007)(478600001)(316002)(2501003)(81166006)(44832011)(102836004)(486006)(229853002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2863;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MWItcIkUWkTLcIeDULmvm3Kd9BYDh6k7IuEcFpHa6E7hr/HCFZKODFnsq7Oe379vNTyWX2HG2F0ijqnckB0XcfpyawOUShVEjiiAGBuds1Gg3UX3suKn9yosbazty2LDb6fzxwMXJtFpxkmXM8McCu6yQoWBvzdiyIfJurF44sdTBJJaMRUA7ConvlU/HGcoSnG8LOiCfVpS0FbtE8S84yzLO2xY8AxdatNg0D6Pi9AY+4GL+9MTv1+K7IM6RiUHoaPDeE/DuciSjRHnlwO46kZYeJIr6M6bSdA8JeqLw3k21NpAo/+3ondizjAIRxsrpx6xpoz1ODYkbrc3tT1o0cbOPU/TQR4eYvr2xqFtRdf2m8igzd8+NsQ0rgJU28IND88ZRa46b3PG+wzfbwNtCpCrb0Fn1IZnuY24rtzu0uU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1668e52e-fb30-4b93-a6db-08d69b2ca322
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2019 14:22:13.6076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/22/2019 12:07 PM, spencercw@gmail.com wrote:=0A=
> From: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> =0A=
> This is required to support the i.MX8.=0A=
> =0A=
Why exactly is this required?=0A=
You should provide more details.=0A=
=0A=
Strictly related to the implementation, why is the code moved to a new file=
?=0A=
Please do not shuffle the code without providing a good reason.=0A=
=0A=
Horia=0A=
