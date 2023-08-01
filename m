Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AA1C0015E
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Aug 2023 08:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjHAIcH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Aug 2023 04:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjHAIcG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2023 04:32:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36BD1705
        for <linux-crypto@vger.kernel.org>; Tue,  1 Aug 2023 01:32:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liIolIg0ACNyKrh9BUFO76ef+AZh4lxG4V3JPyfUQmeOCZ8M29ZRlNwwNBKQ6br7J1Xvo6c/rGBWk5Y8bUWrvNTO6oFzxq+eZPqvSzQDdKGecu0HO0Fh8YXZV4jFq33O9lmvGPzT7v8lD18l3hENCon0orpVHHujET2bL5E/PD+/KGKtJCxruc3esTVOiGQpFliB2G3/XIKOP+M6zS7RASgR7K02GvWZJw3SfiBh7ZVvFY4ypKDz+xdwdwLTXHtK3AHxiNK+6si6x04wWAkD/9L4vgpD5wAjvxVqBkVhkhoSx3ZmMCO15lDE5ffQqG8gy0cTlTYBrdNGShyCCNDpOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkNoOA08Z+lm/eJ49Vic3sXfJxjJjJ9cqSRgYj4SPjg=;
 b=KBl7lidHNELlzaqIythKptM0FL1USilVnSO3jDjnc+IC0SUNeNYhxldUlGrUPFV9Dvk7YatHS7v0mOnuRZ0SA2NEWju2/bQaWi4uwjfDGsfu3OopSIl/kfKP2hBa7j+jwcUdk3T46KoXtDElIftZBOw4XUrXlCERH2On3cSey7evortRJE6FoLw1N+JbfrxNISo/VQKU+DBBKJnqiJgHAMdE5aTNF30Dd7zZVcGlzFV+0PozoMmcOFjcwSKUxaqD1gJxc19MgQmWtdnup3i4SjBUIG/e9fzzHM/+dEYB6YdCm3xcCS8mkXZvU8qwJvk0M1L82olVRruUM160CLTzag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkNoOA08Z+lm/eJ49Vic3sXfJxjJjJ9cqSRgYj4SPjg=;
 b=dH5MniVg3tNuasis9R7cvypXCmkJglzdBPNXyt6IhN/QoL1JiEs/kWN7A+AleAX+37EetnLQ3ddCuMjoNjYiSLTemyRNA5yKtC/7LlG6sP2tJ4or7ioC8r4IqEld7AtgCXJHbKwT/vkzQu/crKDxXxQ8C6TZUaShJ9370u71lgU=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by DB8PR04MB7178.eurprd04.prod.outlook.com (2603:10a6:10:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 08:31:58 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1392:7c78:1b43:769f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::1392:7c78:1b43:769f%3]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 08:31:58 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
 callback returning void
Thread-Topic: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
 callback returning void
Thread-Index: AQHZv5ckURa4X/GUU0ad7ZXQL63KoK/TqmOQgAF2uACAAAPxIA==
Date:   Tue, 1 Aug 2023 08:31:57 +0000
Message-ID: <AM0PR04MB60047FCAB210815A689A2E08E70AA@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <20230726075938.448673-1-u.kleine-koenig@pengutronix.de>
 <AM0PR04MB6004495B1BC8F72A1EC6EED0E705A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <20230801081408.nbu6j7srg5mt7sbj@pengutronix.de>
In-Reply-To: <20230801081408.nbu6j7srg5mt7sbj@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|DB8PR04MB7178:EE_
x-ms-office365-filtering-correlation-id: fe2db3b3-aead-4e70-438f-08db9269c52a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EH71t/oTSRT4aeDwimyq5eDEogsdXWyCfx5CQM4Xc9ilx6JaCcSIw4Psi7SbI8q6+t7HCFCnZ0on0wi0VIBBW/pD0arf3FATKlQMQmEVYCGoqNQ4vzGSy7KGtO8VHVdp0lqAuc6yFYXzP9JMZMul/c2ciXWriQXIOjB60j6DyIt5m8zxKGNwtjxs8EAMUfe3Xmqi87+I7Ej1PZVpcvNPBZbhisvkQON9cE5xt8EctpRx2yBvoQ308+d6URBHdfmDoPrYbhb7LqpaS+L1A0GX+lISYuHSiLONkFhpK8N+w0JiD8bAa2QHKkQE9rhcsPmJdhU9ZrnZ9SzjDF2bDkXhpnWfRJvP1SjiNrttX3tRBPZgIgB1g6Gnn5QYBGH+RDl1UOMX1Rp14Aa9wu+PIm70uP2nOuE8/PEmUg3CtqwqOfjeOs+cSxNt7Te8BHZBrEpUpxw0Yk0Braiv2TpIFBqsXTeGK+uzqOcaNdtI6OZraPatcwjzmZFrvQzXmmp/Y8VAUANdNqZrQDEYPPypwejWzGnOgn0iuTfWmkRGQ4yWzN+68Wjkv4sg1kJ+FIInrCpkaTX6IOpMJysDwp1DqRIOTzNAR4oqyj+Cb/aDZNflI+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199021)(38100700002)(33656002)(6506007)(5660300002)(76116006)(53546011)(4326008)(6916009)(66946007)(55016003)(66556008)(71200400001)(64756008)(66446008)(66476007)(52536014)(54906003)(9686003)(966005)(122000001)(478600001)(2906002)(66574015)(8936002)(8676002)(38070700005)(41300700001)(7696005)(186003)(316002)(86362001)(26005)(44832011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gb7QDTrsNnuNrqkMApDM9JneFQwXQWuRq0PD2Tg0aUI+tXacYWdgUMqOGB?=
 =?iso-8859-1?Q?KbHKRIXUv43/T8m5JLFOMhu7KeDlosLwv4eTGN/ec5vxaXpcuQv0GRE7eV?=
 =?iso-8859-1?Q?jIYmo329uQuHFlBXKqg4Hy448oJ656vo5XFfN48D5NE8s3dzCv0kTJ9q69?=
 =?iso-8859-1?Q?anXJ+5S7aKgMB1MmuxUM/aAPqEUcmkIZuUWddw4cUs5F9umjiHKk3/EJ/O?=
 =?iso-8859-1?Q?1Bgn5EQlvsbm637T2hmh7gQ5BCnp0JuKFVs6bVPRuBWjn4lRJm8u5HeCs8?=
 =?iso-8859-1?Q?W2Af+xHtR2mehl6/GT4nQ0uht5sMt7TovG+3UoIjD5HV91WKuFNCq78ReB?=
 =?iso-8859-1?Q?dEDgUpXcoZ5X7BLuMrH+Y3WpLriR/K6iBFYRXErOtLeE2pkOWvSsZ9yvE1?=
 =?iso-8859-1?Q?/B8wKGUz/AdmtspDzwwOdOBCoS+ohWYG+I41d6kMzGkEeUB+QAr5T8g7EF?=
 =?iso-8859-1?Q?TVv1olFwrG0vyagQ6ccvE6VCjgrpHriRCyk2TnTc4feW1myou6Ae5ZnAds?=
 =?iso-8859-1?Q?A/eOoPOFqUHkDtII5+OQs5SRU5UrGXH+VgLBn67f5vg/Q/K852TKxkOC3t?=
 =?iso-8859-1?Q?BFOrw1olnu7nD545PVTDmJc3nCqlkV3ZTzMhwliCDA7STwNBp7nIHRxCI7?=
 =?iso-8859-1?Q?UhGScAUL0E/qF8St3IEsmxa2DWRKz4WVZSoVzFBHF/KUlo08Ora8K6Xoyz?=
 =?iso-8859-1?Q?x8mC4/pjYyS7fPvaQyjmW+s+wMReU1LLr6kxF1tpLMGyI81CEpak+vPDCP?=
 =?iso-8859-1?Q?KhZ4n0radhI8/R0D0JCc5IzYLgTyxVhY/iuD0c7ot1714MPEgp5/ssgq4G?=
 =?iso-8859-1?Q?whX0OcB46Hm8cWMTFWyWNMUbiQ4rS5HbCFgp57iKNhrTqpS6McTtNQd+S7?=
 =?iso-8859-1?Q?AM+YkqYIZs+uZktvw3Q91DU/hjUrVArOAZhglmaFopho2yLE82j2k2C65p?=
 =?iso-8859-1?Q?omOHqBDJtucIgdmfwvEjT0y5hQHJoPilQuNGRl5P5DLmWFL+j+JcOib6Jo?=
 =?iso-8859-1?Q?721lAv4RctT811vw0AaH7QIzWTORhonoYuJBSERMcjxQ9oWClISfAbmmOe?=
 =?iso-8859-1?Q?5Y3Cyay+DysDz9SE0s703s1/si1yMVaYgcedml7blNcz6Fw16LrnkdZJzy?=
 =?iso-8859-1?Q?6d6nHXL8h089+rJBMP4Kb7iHMB9f4PfZLbUW1ts/Z+XesHEY6nzkb/Ux34?=
 =?iso-8859-1?Q?2IFrqfgvy4w0z8cJ19nOywzplf0k2Xrg32xYLoRLIcO7Td8b29p9Zx0Nht?=
 =?iso-8859-1?Q?yj9mmYtwITMKXzpx6CNB1GX2BiaGGk5+LhY/nCDd8O8nujAF0j9CEP11JU?=
 =?iso-8859-1?Q?L83msuEuXgzs3PA3UFZFvwEoZWj23xJIFeObnzLM28p0CQJ+dCWAmnUqxk?=
 =?iso-8859-1?Q?QrdqY5Vc3gTq2GWaluc8T5F2gCHsFW+jXRNoDCjExEvOUcjp8Bm0p5DxNJ?=
 =?iso-8859-1?Q?Y6B4mFKoTMaZECaiIDxUcg+iytLQkV0V3m4uNygo/6c+ld9stzXOEe0PmW?=
 =?iso-8859-1?Q?Vbyqh2NIPQeK05lGtdKgdZ4STKkALoa8BVWJCbB131lcVaeRWHbaOkDo4o?=
 =?iso-8859-1?Q?dIRvdTxAOunwI4DudYeMhN80n1dTYAmh7MnAeAVI15k40XLNF+lDDjC35h?=
 =?iso-8859-1?Q?NXfDiikUxck7RbM6EIijaCXTgv5nfRRRaW?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2db3b3-aead-4e70-438f-08db9269c52a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 08:31:57.9573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V5q+gU43hJPaC29b5X75/9yCw3DzHd593+s9vFW4sQgFYmz3oP0HgRuvxxfOTDVnXXCfR+bVIZomjcNAm6QeHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7178
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uwe

> -----Original Message-----
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Sent: Tuesday, August 1, 2023 1:44 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>
> Cc: Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>; David
> S. Miller <davem@davemloft.net>; linux-crypto@vger.kernel.org;
> kernel@pengutronix.de
> Subject: Re: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
> callback returning void
>=20
> Hello Gaurav,
>=20
> On Mon, Jul 31, 2023 at 09:56:22AM +0000, Gaurav Jain wrote:
> > > -----Original Message-----
> > > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > Sent: Wednesday, July 26, 2023 1:30 PM
> > > To: Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> > > <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>; Herbert
> > > Xu <herbert@gondor.apana.org.au>; David S. Miller
> > > <davem@davemloft.net>
> > > Cc: linux-crypto@vger.kernel.org; kernel@pengutronix.de
> > > Subject: [EXT] [PATCH] crypto: caam/jr - Convert to platform remove
> > > callback returning void
> > >
> > > Caution: This is an external email. Please take care when clicking
> > > links or opening attachments. When in doubt, report the message
> > > using the 'Report this email' button
> > >
> > >
> > > The .remove() callback for a platform driver returns an int which
> > > makes many driver authors wrongly assume it's possible to do error
> > > handling by returning an error code. However the value returned is
> > > (mostly) ignored and this typically results in resource leaks. To
> > > improve here there is a quest to make the remove callback return
> > > void. In the first step of this quest all drivers are converted to .r=
emove_new()
> which already returns void.
> > >
> > > The driver adapted here suffers from this wrong assumption.
> > > Returning -EBUSY if there are still users results in resource leaks
> > > and probably a crash. Also further down passing the error code of
> > > caam_jr_shutdown() to the caller only results in another error
> > > message and has no further consequences compared to returning zero.
> > >
> > > Still convert the driver to return no value in the remove callback.
> > > This also allows to drop caam_jr_platform_shutdown() as the only
> > > function called by it now has the same prototype.
> > >
> > > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Hello,
> > >
> > > note that the problems described above and in the extended comment
> > > isn't introduced by this patch. It's as old as
> > > 313ea293e9c4d1eabcaddd2c0800f083b03c2a2e at least.
> > >
> > > Also orthogonal to this patch I wonder about the use of a shutdown ca=
llback.
> > > What makes this driver special to require extra handling at shutdown =
time?
> > >
> > > Best regards
> > > Uwe
> > >
> > >  drivers/crypto/caam/jr.c | 22 +++++++++-------------
> > >  1 file changed, 9 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> > > index
> > > 96dea5304d22..66b1eb3eb4a4 100644
> > > --- a/drivers/crypto/caam/jr.c
> > > +++ b/drivers/crypto/caam/jr.c
> > > @@ -162,7 +162,7 @@ static int caam_jr_shutdown(struct device *dev)
> > >         return ret;
> > >  }
> > >
> > > -static int caam_jr_remove(struct platform_device *pdev)
> > > +static void caam_jr_remove(struct platform_device *pdev)
> > >  {
> > >         int ret;
> > >         struct device *jrdev;
> > > @@ -175,11 +175,14 @@ static int caam_jr_remove(struct
> > > platform_device
> > > *pdev)
> > >                 caam_rng_exit(jrdev->parent);
> > >
> > >         /*
> > > -        * Return EBUSY if job ring already allocated.
> > > +        * If a job ring is still allocated there is trouble ahead. O=
nce
> > > +        * caam_jr_remove() returned, jrpriv will be freed and the re=
gisters
> > > +        * will get unmapped. So any user of such a job ring will pro=
bably
> > > +        * crash.
> > >          */
> > >         if (atomic_read(&jrpriv->tfm_count)) {
> > > -               dev_err(jrdev, "Device is busy\n");
> > > -               return -EBUSY;
> > > +               dev_warn(jrdev, "Device is busy, fasten your seat
> > > + belts, a crash is ahead.\n");
> >
> > Changes are ok. Can you improve the error message or keep it same.
>=20
> What do you imagine here? "Device is busy" lacks urgency in my eyes and i=
s hard
> to rate by a log reader. Mentioning that something bad is about to happen
> would be good.=20
Agreed.
Do you want it expressed in a more serious way?
> Something like:
>=20
> 	Device is busy; consumers might start to crash
Yes, this is also fine. or
something like:
              Device is busy; System might crash.

Regards
Gaurav Jain

>=20
> ?
>=20
> Best regards
> Uwe
>=20
> --
> Pengutronix e.K.                           | Uwe Kleine-K=F6nig          =
  |
> Industrial Linux Solutions                 | https://www.pengutronix.de/ =
|
