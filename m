Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86EEC352A4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B65C620848
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 19:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fxlFMUw4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBLTEF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 14:04:05 -0500
Received: from mail-eopbgr40058.outbound.protection.outlook.com ([40.107.4.58]:45470
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727279AbgBLTEE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 14:04:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4MosG+wUcopBb2+16J2wXCLSGEh/+yVfa7RZusVZWvpspokhNpOY3KA8FwNuV3gWmUz+92FTx+cfkeeSFvSjA+K11MoDnj8suPndDe1GFQ6uVIOWLmmB6zQVBQrH4Bi25Noe+EGUlA5ZQPxfGy4igjWTIlgiUjlibYb6vzv9CF6gUqoU4gRjMbUm94hBq8qQev5u7pNYYUZTPbO3njSNPKz4EjYjFrtDBqnFHFq5lRIPaOLXHMbYfW7OJjByJar297t8So5qi/LWUusnQVANobVccIzOkj8zJHirr3oFYvuDdwQYlitHhesINgJH4sC6aZ21PyzvMh8rW5MDiEOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BupAzrf4hRlps4RyCb3qPGDq4kdNSbPzlOsPfbwnxB8=;
 b=g9FV35Y96R5xcbesw7wdJcIGstT80IM60d/mu2bcT4lkZEBGtYvMQqhcRB8RozU+wY98nR6NA+JImX3P11dq2bbis9DL2pHAPyjaMWKJkeqV+uGfUsl8AQl+dZvuXy0I20sazBXzVPEusi8N0PdA3rIHYag3oRE4twKlxqhNuvsvR82POOCoOE0LhMKolgMtUsmKYXQcwpLA3DRY1MV+CMJ72vC1XUb9i4aXIT16QULRYwF1asp7Q4146rfyii5vdK3WOfgU9fKUO30aXat1C967cN59sW+l/tP9XOgHLZTZO2klZf0PH0Sg5zZbbAUgShIaKc/bd9oMGUZvRyIxxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BupAzrf4hRlps4RyCb3qPGDq4kdNSbPzlOsPfbwnxB8=;
 b=fxlFMUw4SydKipALbsp2Dc8oRtl6iO2J25Jb8KV/2pXPqfWekXINEYsUBfOLIZx2edq/Et9e6cYrNM3SXEvt6ZXtO6Hm3xYEs03A3DcqCMUIAP6o7nO/sQrh584IuZ1y2r/JzDPV61uTtgW4gacd3DEIV8d/7b50CJ1uMBkujLk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3743.eurprd04.prod.outlook.com (52.134.16.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 19:04:01 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 19:04:01 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 9/9] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Topic: [PATCH v6 9/9] crypto: caam - add crypto_engine support for HASH
 algorithms
Thread-Index: AQHV4c23DLQNOiVYCkuTVfZUIsa9Ug==
Date:   Wed, 12 Feb 2020 19:04:00 +0000
Message-ID: <VI1PR0402MB348598008AC64EAAFF970087981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
 <1581530124-9135-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8443e5f1-db68-4752-5d3e-08d7afee5223
x-ms-traffictypediagnostic: VI1PR0402MB3743:|VI1PR0402MB3743:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3743DE1D58F1C5F72340287E981B0@VI1PR0402MB3743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(199004)(189003)(186003)(26005)(4326008)(91956017)(7696005)(478600001)(76116006)(44832011)(9686003)(4744005)(55016002)(64756008)(66476007)(66946007)(6636002)(8676002)(54906003)(110136005)(5660300002)(81166006)(8936002)(66556008)(66446008)(86362001)(52536014)(2906002)(33656002)(316002)(53546011)(81156014)(6506007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3743;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QYOWl9Mnt9lzeXJ/OM2XKXkLNrwGIf11C4NDNDik3q1+QX917Mdwj42f8EXLLop9XECsURFfG4M68Pk+gttATW9i26ZbamV3keJ2jaG8ZFdaVJAJH/kD2WC/mwr1Qtgg96fZVQJyNGbqBe0fPP2cyybgIXey1raY51vfDeUBsOppybdtabSloma3Go1/IVHYMQv6edqcvHTx+7Iw0ru21ytJ/r5LsG2NXnSs4pnrfjSw/q9+0I5sFjCZt79br1jX1zEA/FfSDsDoc6k6Q7ekOme7+4ruupVG1lvIL58zGQOUBxzZQTHyqZ1zZapGKoJEttM6wqam0d7EdE86J5jpnmkebvSPhAiwJ0w1ukx5HsUQQrkZG7XGvrZPQtw5Q9YjeX6qS/I73Jj45QIkeG8p+dlfzMGcXH2dNOxM3g22KCAe4Ah5PNBnDVICR5ka23B1
x-ms-exchange-antispam-messagedata: E0No7jsPQLYMRBEGZ0z5F2qmadF2D//V6yVywXHmYzBIR7OiQ7fneC7u3QRGcb31CFQD2ns53ik7Nzy6zMwt2FL5B+UTTHq8ZGl/U1xqFUuEDskC6UhanEpe2kk5kdJUhc1984ojIfpzPyCPp3hunw==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8443e5f1-db68-4752-5d3e-08d7afee5223
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 19:04:00.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DauUF3Coz08QYE53HK6OzvNv2UEy78eHsugYgC5vVjLoAgZUfVKkQEbyPYaPxdqzREJXOarjzqKIt8vZ/4yP6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3743
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/12/2020 7:56 PM, Iuliana Prodan wrote:=0A=
> Add crypto_engine support for HASH algorithms, to make use of=0A=
> the engine queue.=0A=
> The requests, with backlog flag, will be listed into crypto-engine=0A=
> queue and processed by CAAM when free.=0A=
> Only the backlog request are sent to crypto-engine since the others=0A=
> can be handled by CAAM, if free, especially since JR has up to 1024=0A=
> entries (more than the 10 entries from crypto-engine).=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
