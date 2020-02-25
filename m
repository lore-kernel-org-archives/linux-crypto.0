Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9588C35E04
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 20:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8748821927
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 20:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lY4cwsjE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBYU0R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:26:17 -0500
Received: from mail-vi1eur05on2081.outbound.protection.outlook.com ([40.107.21.81]:6063
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731685AbgBYU0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 15:26:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uw1Ix3PbMj9o7FOrpvkavgaONivTimLNO9PFXsVWQWfaKztWawWk5kMo9lsBe/USugBHLWpFGuV1Z6mqZ2tG3CWIC4zdjArAw1wAVLg7friLRhRhGJiAaVjmVth/CG3iUkZkW5HKQlk2CxCzCG4fXAlD49iwpqgGGTOufIL9/AjQrL/bRamE3+9g9UiAG5lgQDAWlPDFjjL+muS8vqR4rrbHWAEjPUZ16/ASCNkU1hpaFIXa9llSTRwVymZYv+QeqC7bw4sd+hx4d9sOZdfWHaU0dXEt805cYR2YqrAJydBTbIkl3p2LJRbkT/7snt2UpPHgAFzgWtV12MQFewL6kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cayu79wOyGEn227qtv7X5t4JIzglzRpTlHAZ6QHTDos=;
 b=OedsqO0ibBYpnYAjtKg6MVrjpaJ90dmWtt+qdYv9UmZf3LpZEEdTLmppIOnD7l4ieNCSeUsWEclDjuCz0HKRV+IZEE+ouF0ueMOdxeDYmpCAWe/gH/vM9rFRTTy2e1N8SKa8zKPTApI7j4ywSFutX2Lh6ovAcIOc9sKwCevcrlAzIuZuFtqf+q4PPCAEKp8Z2Gk7LdLfV1RHYHqukxkj6tVuQCA14K4H3GyZi8j00llVN5g6EvPCkFFhOoTF3vnlv5+WhVqQk1WxnKCW+xFPr8d+kj+OUQ7yQmPLuG2ZJZzDNVatzz1Ecv+8eJQuqSHmfunUBfAqnDlwHP7lyG72Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cayu79wOyGEn227qtv7X5t4JIzglzRpTlHAZ6QHTDos=;
 b=lY4cwsjE6doHG5CdpHVHUaoHvAekoV1VTvGxAGs+FAFxZN51AbJitp2ZCHtkbmBEtWOrA1Alm7BA0HXPjeicaspIgm7iCD9Xnwi9rrl2GnO7mR/7fKprD68PGaYlf5+krFdZBOCiSje+hGrge+bAFptuYkzRO0AYAoTK9wTD5/M=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3695.eurprd04.prod.outlook.com (52.134.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 20:26:14 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 20:26:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v7 7/9] crypto: caam - invalidate entropy register during
 RNG initialization
Thread-Topic: [PATCH v7 7/9] crypto: caam - invalidate entropy register during
 RNG initialization
Thread-Index: AQHV1TLWgWFMXoW0dUik/8LP0jRlww==
Date:   Tue, 25 Feb 2020 20:26:13 +0000
Message-ID: <VI1PR0402MB3485FBC57F580FEA36F7336498ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-8-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a24ba5ae-ee12-48d5-8cce-08d7ba30f5c5
x-ms-traffictypediagnostic: VI1PR0402MB3695:|VI1PR0402MB3695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3695F8786E7C0DA8A467DA7198ED0@VI1PR0402MB3695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(52536014)(110136005)(2906002)(5660300002)(44832011)(8676002)(4326008)(26005)(33656002)(316002)(71200400001)(81166006)(54906003)(186003)(81156014)(4744005)(6506007)(55016002)(7696005)(478600001)(9686003)(8936002)(53546011)(86362001)(64756008)(66556008)(66946007)(91956017)(66476007)(76116006)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3695;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: umKsa/QXmJSTSdRGylv1WJVLo8Aw9tjGN8YokEYWwbpqKy11KRkFXWZKTRSIW1ywnhcrZ8Jj1dIIXj4x8lQ22dmnExwI8bF0z+zXjl0vnnkbaylyNpETGVAXQjimQYEKoRTWSLSCoEVf3saeNxaVOfw5dQRRcUgfXL5C7P44CDSKOlrv4TJodJ6PzI1TL7RgXDHuPFlABkWPQ5RiLv50AcBUjuyyRHvbqJ3YE3Wux9gVEfm5ooaywcMJnhlUwYOw5QMfVWqeHngOVCopX+ibU72fQY5iZPht4WE3N5g6V9xqB5gUg88Ai/U6TNJ3zF2y13ZQwi0TuN3BKm1w2BE1ypmeQZuBRTb1qNXa0BHARbVTBlg3+D+VN5ZZRnZHwzjJBcnNS2edAN92PggN44Ua2Zfkpkcl/3kXpZpzzle3OM+OZ5ykFzRm2RKWTjrvpHYA
x-ms-exchange-antispam-messagedata: etryfZHFMNm13U/WzbtWxEveE+kSQzuTWbEebdSumQ/B8bqbViHfztGFrU6cI7zgLQ1+anBUyxI9tZLxRmBOf0YobcDekSgFTQvAsILqDrh9eleTNQ82K8hns2va/QKZ3Du5DwpW2pGi5aoII+dTEQ==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24ba5ae-ee12-48d5-8cce-08d7ba30f5c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 20:26:13.9336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAsIk9mrCTRyRDc/Ace0VxwCPOI/Ub1O/jEL1rylym5if7DkbJoOlYP3dFccgiYGfjqcycWi0hCyuIHPYIuwpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3695
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> In order to make sure that we always use non-stale entropy data, change=
=0A=
> the code to invalidate entropy register during RNG initialization.=0A=
> =0A=
> Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>=0A=
> [andrew.smirnov@gmail.com ported to upstream kernel, rewrote commit msg]=
=0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> Cc: linux-imx@nxp.com=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
