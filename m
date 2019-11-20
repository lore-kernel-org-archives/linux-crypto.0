Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C69C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC5522317
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:09:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="i/jnrMew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfKTHJi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:09:38 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:13113
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727127AbfKTHJi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:09:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUNoUUiNTseQopihvVegypJrIEN6pexmwJvkr5Ig4ufg8nSKfRw7a9rFohvxwxJrgUV8/lFQ7HcuikM8VRhVEw9CjaRCsQu0TzQrFbVP4n+n86jTUfSMy6mYPabrvdIB79aXuSeEsjSQTJMg3qNKxXU643w7Joe8UGAGrmDFyDNwWpbsVuY0Zpt0c0NGnELiWn/vCOw6NRZGnacoSXdNuGjmXJ+pFjo8TV3ENTsZ/OEt5du47iuwSO4hki1ilHNRNGqs3twacXNKXTC3Dn3PeSaSayGhLd5e+gy7W3Tayvy4fOfAg+9l8wTjh4ttmzEHPtPBe0FuV7AoFcL8ETi8nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0hvPUbI9y5USJUyl6DYQaKF0hJiF4WPFRb8dN370+Q=;
 b=eS9uedB8yfPbFElT2zK5LBOB4NqpEQPgCLTRT/cM/K19GQRnrrvFhiwxtzo8BuNwwz+J2du3CcyhgDrXLM8RPIlrcLymswmTr/6d65gqutdbXfmQY5XHFfgXr7sLsUkUHy5CoVlGwvqE5y1xpnO3pfjVj+bYgcBUPBIz5qwRqxTAt7UnaeV87KG2jD/5CkuGC8ZNxL9kC6fujiizjofHIINsZ4LtdQrGVQSFPNSJVG3HHdzXawfdVmydxrtftpcT06UhXloqowoBI7wjGY5K32XAWcD9lnoQM53dv9jUGxZrV6pprUQPSx+W6iNq+pvgqkhGNyJiJ0BQwuVIpCTvtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0hvPUbI9y5USJUyl6DYQaKF0hJiF4WPFRb8dN370+Q=;
 b=i/jnrMewoodMEZux3s/FtsUl+8aNqz1vI3sa/X19FhF/p4hIyhI0r0aD2SMXMB+s3iSawko5a1+KaokFatZE+rjE8tq564gA7KLeIR6N6MQzq2ZVjGYqNaRYJz0B4xPKTZMuvRHZ1NfTWKi9Yq7uCWWtOwxPjNzMZ8mIZPe/BtA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2766.eurprd04.prod.outlook.com (10.172.255.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Wed, 20 Nov 2019 07:09:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 07:09:34 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] crypto: caam - introduce caam_jr_cbk
Thread-Topic: [PATCH 2/5] crypto: caam - introduce caam_jr_cbk
Thread-Index: AQHVk+uzb+AyX2c07UmzzrqWyCz1BA==
Date:   Wed, 20 Nov 2019 07:09:34 +0000
Message-ID: <VI1PR0402MB3485DDD50A84CD8441D8FCCA984F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <20191105151353.6522-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1cf32126-d7d0-42b1-c582-08d76d8898c4
x-ms-traffictypediagnostic: VI1PR0402MB2766:|VI1PR0402MB2766:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2766305D4480B72300DB5651984F0@VI1PR0402MB2766.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(189003)(199004)(476003)(86362001)(102836004)(44832011)(6436002)(76116006)(7736002)(74316002)(305945005)(91956017)(256004)(966005)(478600001)(2906002)(316002)(3846002)(99286004)(486006)(14454004)(25786009)(110136005)(54906003)(186003)(4326008)(6116002)(5660300002)(8676002)(33656002)(81166006)(81156014)(2501003)(6246003)(52536014)(229853002)(53546011)(6506007)(55016002)(446003)(4744005)(9686003)(6306002)(71200400001)(71190400001)(7696005)(76176011)(26005)(64756008)(8936002)(66556008)(66476007)(66946007)(66066001)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2766;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bXzDRv9k1c2AtMfZF67wzcBx+kWXDlGDRxvccT3SCI2pjR25HXjxbZyp+r9K7Yx/kys64zCIfBs4hA1cmWUworrlxslnt+X4cJwE7O0526PLzKmkY9OavJUD2LmelLVPVzHDHRxymkUBor92uTP62duC146Ud6/hitv5ZHTaUjJTEKoX1RwmpJeZxZbkh1Axy0AErozNk+eYHMm8teo6nkE5npMLEgtyIG3wajlTImgSjPveGAwWtL6KJHCIdbvACLpoR4VJHlYFjgEGPx06gawtT9g9IayJ1ZDV6S113tvgM1P/841geRhUm1lyY7I9y56YSqGemkArkni5/RNsT4uhbD9maM1MkJVdfxsMEHMkWU2y37jrF3HrN1qdWQNndV3Ojbb/o3SGggly/HMgQ2tjTPk89oCcVawqHKoRC/PKDWghwz9s7mWO8muZI5QE4U42DvyBRhTzPS2hQHk94c+lecosDJH1WHohuI/fo4c=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf32126-d7d0-42b1-c582-08d76d8898c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 07:09:34.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9VE/AYCZfN84sLZtP4j0HZjRiF5DOHP188KuyLvNTe+V0kroBJhzavnFDdA2vkhtG5R/ONcjQMjErgK6jua3ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2766
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/5/2019 5:14 PM, Andrey Smirnov wrote:=0A=
> Coalesce multiple ad-hoc definitions of the same function pointer into=0A=
> a dedicated type to avoid repetition.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-imx@nxp.com=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Note that there will be a conflict with the patch set adding=0A=
backlogging support:=0A=
https://lore.kernel.org/linux-crypto/1574029845-22796-1-git-send-email-iuli=
ana.prodan@nxp.com/=0A=
=0A=
Thanks,=0A=
Horia=0A=
