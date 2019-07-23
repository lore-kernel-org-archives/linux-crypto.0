Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7CBC7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57E89227B9
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZS1pe4f+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfGWJQW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 05:16:22 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:11160
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729835AbfGWJQW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 05:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSV8zzvPWo0EH1TxpTeVVyZlHMrhyy+rfdFT8SZLGD+v7fG25CaZAzYOM4j4AgpN7g2lVamQno95OZCnat+2OlMXClIPV04mMJqNqyArgvnhVbbkw6muo3vANU4cU9oweuGLq43kFLUh6WN8boXdq+lfNJUa6Nwrsoz3XkS4sF/j/bMwmyP+iuMP96pOxsXbZGvxg+eCaNi80Kmls5Jg32x0vvo/1VaH41MI+KVHNyknN/Tv0K2EqQKltPvOnPUXi/ZhSIuAk5q48MQjnAE+OLY48V5L0JBjm6wsksR8GyACcMVhCqD3XSqtxuUkeLD4C6E0vJ0xHmoKPvW1bWlrXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5hFGxAX6rivvFJntNAEf+1SVj7Tif/xbHf5XaOtwjU=;
 b=LEQ6wMPMEEmyBwNpA1A97FZOpzmefFopPK9FbF2IcftqjA37GG9j8Kv2LcmRldVovhZH5RVRy9FByyTHGeJp7gTqEMX1Imwl80f62YJkRRvpJnqu4rET/pqpOyE/e/cWBNz3k3vRiNUurpvIrjyQH9BXSqjxjFhOTg93g3E+4ioO16gtOXJ5If5CRr1LbuRrWgXNi0JnB+0LchtgMqMzipxUVfYkuKDCgeNyvf76xTStj5w9eNNIESGvcuJguGy7AtmD9PMhgJAIQEZfe2M4Xb0q59mQI7R14WuocilCHHEvmDXl8vrAWNinznRoir54/1952+3eQsYScdTxoWb/cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5hFGxAX6rivvFJntNAEf+1SVj7Tif/xbHf5XaOtwjU=;
 b=ZS1pe4f+yZv2phrDiV/zsEiRmwZ0VZj6rZDXuQqsDJUeL8O6ppCsATUZQEN4wEtbVbitRj8jf+7sSW5C6qVGhr8ZoUBzhFDLL21lDEmWDCylRczXQjoNUHdO1VzwP9CPmnD08Aj2qr39XIjTCHiHwUZFwQSV8bSycazy9i+cO5o=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5290.eurprd04.prod.outlook.com (20.176.236.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 09:16:19 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::94ce:fde8:cab7:873f%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:16:19 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVQTKZYEyobdVG002zgP86IbRAmKbX689w
Date:   Tue, 23 Jul 2019 09:16:19 +0000
Message-ID: <DB7PR04MB4620F5C78CFE5C1250CEB9C58BC70@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <20190723083822.32523-1-vakul.garg@nxp.com>
 <VI1PR0402MB3485646A093D68040F78A3CF98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485646A093D68040F78A3CF98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.120.0.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d204123-ad75-44ca-e838-08d70f4e6c45
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5290;
x-ms-traffictypediagnostic: DB7PR04MB5290:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DB7PR04MB5290B66DDD83C3A810A6314D8BC70@DB7PR04MB5290.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(13464003)(446003)(74316002)(486006)(71190400001)(11346002)(7736002)(8676002)(305945005)(476003)(81156014)(2501003)(68736007)(25786009)(229853002)(86362001)(102836004)(44832011)(81166006)(52536014)(66066001)(966005)(8936002)(256004)(71200400001)(6306002)(6436002)(3846002)(6116002)(55016002)(9686003)(4326008)(99286004)(54906003)(7696005)(53546011)(64756008)(66446008)(66476007)(76116006)(66556008)(6246003)(66946007)(76176011)(6506007)(316002)(110136005)(186003)(33656002)(26005)(5660300002)(53936002)(2906002)(14454004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5290;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bLYvOYJUHmSp9Aof5I8xrDGPYrTXsYGQqPMMlheAQpEKk78/t3zwC/BQBSI/r/hxHqJjkuThLpUu78RH0qRAdU+ck5u2YLm1rvSgSWC8VT9YLQykbBBmIiS7lAvgn2W37FnwQ/l3V03DI3lH+z5jRG2toj8LW7IUlwdIn5E5AEh7h+3UduM1Z8RXn0jvPaQOxaY2aN41j9HNP2dhs4r9xej+9NOSBN2rJ/asfgdc8T1v4OpA0jVVSmrDhDaerc8mHQFwtBZCOZCU9Ov+wC/sYsXx4fS3DIzfOlIHx+6ZO5XBNdOg331vNw0fR6CFE2/VwSYUVuw3JVjCWuLxHWHhNlAbWbrklNiCUC+l8anIQfuoiKfu/x7tyfXAm3Eo+VVQ1id87Z9emGXpgLL17SNDI3EjD35ZfPDlXa+KytaWA2k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d204123-ad75-44ca-e838-08d70f4e6c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:16:19.3501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vakul.garg@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5290
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> -----Original Message-----
> From: Horia Geanta
> Sent: Tuesday, July 23, 2019 2:38 PM
> To: Vakul Garg <vakul.garg@nxp.com>; linux-crypto@vger.kernel.org
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>;
> herbert@gondor.apana.org.au
> Subject: Re: [PATCH v4] crypto: caam/qi2 - Add printing dpseci fq stats u=
sing
> debugfs
>=20
> On 7/23/2019 11:42 AM, Vakul Garg wrote:
> > diff --git a/drivers/crypto/caam/dpseci-debugfs.c
> > b/drivers/crypto/caam/dpseci-debugfs.c
> > new file mode 100644
> > index 000000000000..2e43ba9b7491
> > --- /dev/null
> > +++ b/drivers/crypto/caam/dpseci-debugfs.c
> > @@ -0,0 +1,80 @@
> > +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> > +/* Copyright 2019 NXP
> > + */
>=20
> .c and .h files have different syntax, see:
> https://www.kernel.org/doc/html/latest/process/license-rules.html#license=
-
> identifier-syntax
>

Thanks for pointing them out.
Earlier, I was not able to fix checkpatch warnings related to license heade=
rs.

> > diff --git a/drivers/crypto/caam/dpseci-debugfs.h
> > b/drivers/crypto/caam/dpseci-debugfs.h
> > new file mode 100644
> > index 000000000000..1dbdb2587758
> > --- /dev/null
> > +++ b/drivers/crypto/caam/dpseci-debugfs.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> > +/* Copyright 2019 NXP
> > + */
>=20
> Yet another nitpick: incorrect commenting style (for the 2nd comment)
> https://www.kernel.org/doc/html/latest/process/coding-
> style.html#commenting
>=20
> Why not make it a single-line comment?
>=20
> Sorry for not catching these earlier.
>=20


> Horia
