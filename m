Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EB8CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 886422086D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="LGUyNa9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfJWRIb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:08:31 -0400
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:12977
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727648AbfJWRIa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 13:08:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5ru9UVd0OjpStA65mM+dk71y4mcxSe0iErOnX8R7moHIuDa3uoL2rSrDgUvjSC8XBkZEBZ3Qg/KmM6uenyXWjOy01jMMSj9eoE9CvpsP0X5PX3gNO96GI6HpUYnQttLbTeiRc+gP+kQyyLVJ0XSuV6S1kuuEaNY14Fxw4j0KPB8VxEYwLEqusubl5yKYam4LmCEL/uRyGr+3E0rWE7+mFTKmypjEuwCt6cj28FdFlP/rIbjuRhJYa8zeI/FV8qnkrU9znGHI3m7+y2QjOm+KRA52JVAt3bUo4l10RKrJgMHAJZxS80dIMh0oU+QgKJWMi8GF1/PREVzq+ekBV3M6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vv0O/S3p81qWHemw78op7nQ98Do+XHA87z3pJoVb9go=;
 b=lAwmCjnnpWugjKYB2y47MdHnQKouCOxAoJR1iE7j8PM9lOIJCNEqcsQ4QIykkmwcVfXnSuR8hm2QqEH8upszdl5zxj9JgzL9WdzFV87gHMffZM5XgRwNDiUv8OkKQO4dXndOPNeKYgCH8bjYQY85fkDNxRhGnrGbLGzv9xp7aR8SQpzrCBITTLCGI3gRA9HU5OFaBqiCjknojNPCnPPXwk49WnO1nknJHFrytinYXWpfwplr1Yg5g8vdj9kREmTY3G4euIiOVQaVrkpMQhXlnP3y7+KoZknEm2ZqIMsjd5kP4SSj5XK8TMvN/R12D7hnZxJIgJRMZSagnmNNcHzTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vv0O/S3p81qWHemw78op7nQ98Do+XHA87z3pJoVb9go=;
 b=LGUyNa9wXoZWn96qF2pcTYOkQafTGGMHkA+2/oKiURs3dO6V2VkqwvZy6hdW2/1O/RKQ+3EYUSaciqv5CUIkQus8UQaD6fdDv0JJYhos3KOKmW2YYD/y7W44b9LMnMcjq5ePIm2K14yyqjF5D2f7BEhc6lt3o2rBdAfYmEZNB18=
Received: from AM6PR0402MB3477.eurprd04.prod.outlook.com (52.133.25.15) by
 AM6PR0402MB3431.eurprd04.prod.outlook.com (52.133.23.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 23 Oct 2019 17:08:27 +0000
Received: from AM6PR0402MB3477.eurprd04.prod.outlook.com
 ([fe80::a1b5:b818:c136:bf86]) by AM6PR0402MB3477.eurprd04.prod.outlook.com
 ([fe80::a1b5:b818:c136:bf86%6]) with mapi id 15.20.2347.030; Wed, 23 Oct 2019
 17:08:27 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] crypto: caam - populate platform devices last
Thread-Topic: [PATCH v2 6/6] crypto: caam - populate platform devices last
Thread-Index: AQHViO2nTXtx2N0RtkCKfqwx+l4MbA==
Date:   Wed, 23 Oct 2019 17:08:27 +0000
Message-ID: <AM6PR0402MB3477F7AE0BA69B4DA542F46A986B0@AM6PR0402MB3477.eurprd04.prod.outlook.com>
References: <20191022153013.3692-1-andrew.smirnov@gmail.com>
 <20191022153013.3692-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cae198d2-0e89-4f22-6f9b-08d757db9f55
x-ms-traffictypediagnostic: AM6PR0402MB3431:|AM6PR0402MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB3431EE9DD1CEC2736572234B986B0@AM6PR0402MB3431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(189003)(199004)(186003)(6116002)(26005)(7696005)(76176011)(99286004)(53546011)(6506007)(3846002)(7736002)(476003)(486006)(86362001)(74316002)(14454004)(305945005)(102836004)(44832011)(76116006)(66446008)(64756008)(91956017)(66556008)(66476007)(229853002)(6246003)(446003)(66946007)(256004)(6436002)(2906002)(54906003)(25786009)(81156014)(55016002)(5660300002)(66066001)(81166006)(9686003)(52536014)(4326008)(71190400001)(71200400001)(2501003)(33656002)(110136005)(8676002)(316002)(8936002)(478600001)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3431;H:AM6PR0402MB3477.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6+8myGPI/TGv8yBnMULzvE1WRB/ft2B49YjKYMgVeE4F0X54ceznhd1/iR0d6S5NCq8xOfFhYY4uxYi2CnDee/G9suSh8LKqRuVDXS+RbOZSxWXjgCjGQvuY4SLi+OF5/D6Ehv6Favw4UXx8RXVDAkCPa7fJVRV5oPfYWLQbiOV3XTEFTcIAzMr98vfqry1udnWurMtoPc29k3JaLigZUFhtgxH3Hk2yJA1S1RRyndtlhPXW7DjD+UZajhpXG/cG5yu4vyZCj0+NFlq3InlmYYl9TSpdaEwYoZ1XvZIVr+QFhtMOFEEueF2Geg9HvsmT6PHRa/4EWVdunN3n6oYzImxW7CRouPMWg/EAUdsvPNjGWFPnb/htWYk92hrXzoW3bCk/EtMCfSdbMUq8MYRjyi0JoPcVP9vWGe+ETproaetdZK6g2jbnF0WAYtcCsfsx
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae198d2-0e89-4f22-6f9b-08d757db9f55
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 17:08:27.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +iGGLUlo820HTf8Hwy0lYis0UVC6P1B8qdH25ABI+TgNOgVfSbwF6guER2cThnaIBZ6QLfZ18GC3+6EUeU2XyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/22/2019 6:30 PM, Andrey Smirnov wrote:=0A=
> Move the call to devm_of_platform_populate() at the end of=0A=
> caam_probe(), so we won't try to add any child devices until all of=0A=
> the initialization is finished successfully.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
