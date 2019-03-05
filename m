Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C16AC43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1E820661
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 17:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="P/iZO8oe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfCERfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:35:06 -0500
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:44519
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfCERfG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 12:35:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLo5RWSu5m7uOIDhoCR9inJ1syNVvoL3eeWVLJ6K4+Q=;
 b=P/iZO8oeCI/Miwk0Cx3kKBm5WALHGczxMSofCikhRS0QjB8MGSykqtulug606/ayhu85LWnOsj0KFrIFm7vQVBs2UUshidNaniH9DV2uskgWJ1wBjY7Md2zbMlJruQ/PWaIt07VP+Ai5d8mC/gsTYQSkiGSX1Q4kPBYcEQ5QttY=
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) by
 DB7PR04MB4252.eurprd04.prod.outlook.com (52.135.131.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.20; Tue, 5 Mar 2019 17:35:01 +0000
Received: from DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5]) by DB7PR04MB4252.eurprd04.prod.outlook.com
 ([fe80::9ca:d78:c154:25b5%4]) with mapi id 15.20.1643.019; Tue, 5 Mar 2019
 17:35:01 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Topic: [PATCH] crypto: caam/jr - optimize job ring enqueue and dequeue
 operations
Thread-Index: AQHU0yEvYfnJy4m6QkW0mfkgeeAyJ6X9TGWw
Date:   Tue, 5 Mar 2019 17:35:01 +0000
Message-ID: <DB7PR04MB42528B5F67984BB8CBF54EDC8B720@DB7PR04MB4252.eurprd04.prod.outlook.com>
References: <20190305065820.13072-1-vakul.garg@nxp.com>
 <VI1PR0402MB3485BD912D8FA0E1A33CBA5298720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485BD912D8FA0E1A33CBA5298720@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [160.202.37.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d428e889-d16c-4260-1766-08d6a190e58e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4252;
x-ms-traffictypediagnostic: DB7PR04MB4252:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;DB7PR04MB4252;23:e0kgl/zT7qtwGqWTvpTq4p+lY31xu+99Oq6OqtQjS?=
 =?us-ascii?Q?RGolKpFk+lw6M7GiCBQovbBR7EdC8219UimrrgpGVFsUc+BMOy9YiUvfkMmF?=
 =?us-ascii?Q?iUTIsRP1zSW5rZh7zxmlNcIXCMNY1TSj34LW2O8mBr4cXsx1rka4yfClWhXu?=
 =?us-ascii?Q?ghY0lQbTKGa1eviDEq556wreNJXojoZforQs/7bmxWhhdXVYhhEo9C5SYawi?=
 =?us-ascii?Q?ggHLuP+ryyxOkwzms2OdFJpgAYYKiJBTed69HdtbdiGkgSCOr9fvf3KPNPAs?=
 =?us-ascii?Q?m31vOthuIfquYW/zxl42DTvAPp1N5FrEi4cseuFYEqugI16g/J5uRVxXsN8q?=
 =?us-ascii?Q?6wBdha1ezSWyP8NDQO63mT0l6ZmvtOKG/q6xRjtddmrkXPBdkaZGdBIeun8j?=
 =?us-ascii?Q?lG3tLnB7HvTh8T8HMnZHpZ1wCAH/y2PXS5I4lG0ATXZuXDDx4woeI8GXVwvz?=
 =?us-ascii?Q?Y/NvYBDJpj6qSyXQcvoCv2hSLklxqz74LXdP8eJARK1V+zNyaoWmm/E6fCco?=
 =?us-ascii?Q?y/ugOAVphY8t0BVZECc+SygF05S/GGummnTVWW1e6GUNoREvulcSPwhBPMpG?=
 =?us-ascii?Q?4gB4S3hJoFJuhm6immB8ZDQVItygOMzBh1x+mJDSPAjdhAxAhoGSJfA+lrkU?=
 =?us-ascii?Q?CzmQKJtDzL1/OqG3kpZQWeDNugzxHCWyR9djJ5tdnIsCr6T1gTQMKS4RGJkA?=
 =?us-ascii?Q?bpzrH6Uz/txDDkbCCkzqxU5wmsbO1FNdBKgStpn24/F18zHFizdGepAVWLDf?=
 =?us-ascii?Q?NhqqGm+dMYEZFxMg1wdcp6QtkWoMHIZoPU5MBuFvar6jXZfqH7Wv1rr86Vbm?=
 =?us-ascii?Q?1vsd6ZcroaLEVK6gGZ+MJ/9iJRgRhYCawXBNTwVybxNq5oXaqeFPpzx4Qek/?=
 =?us-ascii?Q?a3EssRSdv2DglMcy4r88RkdDMlnNLsFV6phdcVKH7JRV8zVOT3ADg/+ZKUUL?=
 =?us-ascii?Q?sO8TBazzDX0OQ1623857MbMhMgB6bMJwHy6YPf1nVfe3uBfcSWJa1+m1Bvtk?=
 =?us-ascii?Q?ivTNb6QxeL7E6ZHidOfy8AWhH6+3M+UogdFUCelITgozFnJJHEHU7nt+fHJQ?=
 =?us-ascii?Q?ThbK8+siaUcdNuXDKbetGpvDeW0Ve6xYeA3PRf1RN0oOetgt1872V2ZwCT5/?=
 =?us-ascii?Q?eNaiC7qAADUegCvvBhT60vEtYQoqoZVFjN7SDAjD4qLRqzGL1kod0cTXDS8V?=
 =?us-ascii?Q?OQGHUvX7r4KIIcWJeCuQsFYvB4hZLKi2ZscdkbzakliW3qVong1e742txULF?=
 =?us-ascii?Q?5DGRhKyrPXDVBJMJHislpE/b9hFDXof4SA8OlB/saX43jB1mOpcDr79iBMA9?=
 =?us-ascii?Q?lpStB1pKhNbl4F0WSd4L+BhIgvq2f4h9s1pzofmB91jVft5glWvo2pzhmiI/?=
 =?us-ascii?Q?Fi/wYbOqAPTCARl/VgKzkO77ZQ5l5NbJ0MkcqkPGTsha/1w?=
x-microsoft-antispam-prvs: <DB7PR04MB42524354696C12D3313BB8928B720@DB7PR04MB4252.eurprd04.prod.outlook.com>
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(396003)(39860400002)(366004)(136003)(189003)(199004)(13464003)(76176011)(99286004)(2906002)(54906003)(3846002)(6116002)(9686003)(6506007)(97736004)(25786009)(66066001)(4326008)(26005)(52536013)(53546011)(7696005)(110136005)(14454004)(86362001)(71190400001)(55016002)(74316002)(478600001)(53936002)(102836004)(6436002)(305945005)(7736002)(71200400001)(44832011)(106356001)(5660300002)(105586002)(186003)(486006)(81166006)(8676002)(8936002)(68736007)(33656002)(81156014)(316002)(229853002)(11346002)(256004)(446003)(6246003)(2501003)(476003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4252;H:DB7PR04MB4252.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KM3nGwa0mWpbc/NUZ6pg9f4KcwtBvPXTmeztQk8hEnRlEDnBqwPW+r/g6iMMbMscsVpfV4NW4HyOAXB0J3139ClFi2RgqYgKAeNOTFh72ykiSamgg9EmLSZm7Ao5BYik1dcsgem0ve4u3Z6kj2ETqceclSvI66wcfWf2w2HUfi40k6KuwXVdufIem1OtbVA2qIYWExpS0XisDD6Xk6fZkePmQ3DWsPhnajHvinPrq6Cydw7KxbFepnP9zfmmobtJXOgfW3S9C5B30RRPhbgKe7BzsT38RrxoEwEJDEwflW+LfdruDVz9hQQ+VLOx0wb6b5scOMj2cE1QKxpyrF6PJEuvLiZA/t5AwiTGdh1tsNB/jKAEqT4QBig5Vq2C7/bM/pD6lkxfpGgNWSMF/Fa2EvaRroCzzfSdbRPSptbuHNk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d428e889-d16c-4260-1766-08d6a190e58e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 17:35:01.7190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4252
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Horia Geanta
> Sent: Tuesday, March 5, 2019 10:14 PM
> To: Vakul Garg <vakul.garg@nxp.com>; linux-crypto@vger.kernel.org
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH] crypto: caam/jr - optimize job ring enqueue and
> dequeue operations
>=20
> On 3/5/2019 9:00 AM, Vakul Garg wrote:
> > Instead of reading job ring's occupancy registers for every req/rsp
> > enqueued/dequeued respectively, we read these registers once and store
> > them in memory. After completing a job enqueue/dequeue, we decrement
> > these values. When these values become zero, we refresh the snapshot
> > of job ring's occupancy registers. This eliminates need of expensive
> > device register read operations for every job enqueued and dequeued
> > and hence makes caam_jr_enqueue() and caam_jr_dequeue() faster.
> >
> How expensive?
> Please share the case you benchmarked and performance improvement you
> noticed.

The performance of kernel ipsec improved by about 6% on ls1028.

>=20
> Somewhat related: it seems that after commit a0ca6ca022ac ("crypto: caam
> - one tasklet per job ring") the "outlock" spinlock could be removed, thi=
s
> being a good candidate for further improvement.
>=20
Yes, I remember I discussed it before.=20
There are other inefficiencies as well.
Will submit patches.=20

> > Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> > ---
> >  drivers/crypto/caam/intern.h |  1 +
> >  drivers/crypto/caam/jr.c     | 12 ++++++++++--
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/caam/intern.h
> > b/drivers/crypto/caam/intern.h index 5869ad58d497..b6d96e2ecf4c
> 100644
> > --- a/drivers/crypto/caam/intern.h
> > +++ b/drivers/crypto/caam/intern.h
> > @@ -59,6 +59,7 @@ struct caam_drv_private_jr {
> >  	int out_ring_read_index;	/* Output index "tail" */
> >  	int tail;			/* entinfo (s/w ring) tail index */
> >  	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
> > +	u32 inpring_avail;		/* Number of free entries in i/p
> ring*/
> Locality: this should be near the other enqueue-related structure members=
.
>=20
> Nitpick: use "input" instead of "i/p".
>=20

Sending v2.=20

> Thanks,
> Horia

