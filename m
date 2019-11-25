Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56480C43215
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 08:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D262082F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 08:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FlCxswqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKYICt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Nov 2019 03:02:49 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:57861
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfKYICt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Nov 2019 03:02:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JewMVeP001r9e2jRlPUescjiAEcQB8p5lhd0GQcKHgjAT+Tg91cyIrQkhX9H2qSE05B+j3pE0ys5Qo5pWFOsUCCw6rFP3/6e/Nh4xvDJouXGD1eDF4UCvLEcRBf9+nra6QWvnW2GpPh+uUlgaSb3peAUhxAb9gmRJwZ9OY2/ORCe2+Xx+Jh6Ob7d64MA5jzTNFW4oizcFLdOQcF0WKLI4D0otBq0VuwLgLT+b8+p8sR9y7HVjSAcDxARCOF9GmJ9rhoCvY19w/vnAeauJogrRCorMmWhVfQzTbGiFBkX2sFfeIV462WhlGCpGmh1RElHcT606oGdcsk1mUi6qK/Q0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uhYEdZCoec9WSffkdF4Oe5jZgL043atWeWMmdXkSzU=;
 b=mGXou2oWH4LAfaZOIo03UWdy+5BsjvCMTYBNSHcPkeIOLMxHhdHnpc/o0WM7S+63TSn8F7GDYjjDR7mimcOUOXq0+HStfRKyy9lPzTm5uYH2NkX/VwlBOns9QicU963mUEc+Kb1v4gS6yyVEWzvfzrzMNh+zOMBoLlAdKxwPwp179+zlVeRoWCm0rqgUR9OW9Tw4gXHaXIDzdv31CEiCiZUWL5e8cEpCvQJfW5YXH4m5HDzbfZ0ErtQd7tih8HRARf3ELW2pMP/dh/Z88sGwmsHgR5wcbUR4uJYI+j9bppjurj0lBrxS98CqBXuWRA/joKCrKlFrEHztyjc4hLWn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uhYEdZCoec9WSffkdF4Oe5jZgL043atWeWMmdXkSzU=;
 b=FlCxswqj1yEI2WFC+LbZFsxAOfotSsEhi05IIUUWxOQDpXDv/ZE+HHIXUD+KHtnpNSja3qB1Jcsthy/0cBkNj7/liE9b1452shw5sHdDC8Dhne5xAVk68Xwrjv2/WDU8EGAhJpBx2zsfnKJ/1LOqitcDBDcGPmD4R+03qsVr7lw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2848.eurprd04.prod.outlook.com (10.175.23.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Mon, 25 Nov 2019 08:02:45 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 08:02:45 +0000
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
Subject: Re: [PATCH v4 1/6] crypto: caam - RNG4 TRNG errata
Thread-Topic: [PATCH v4 1/6] crypto: caam - RNG4 TRNG errata
Thread-Index: AQHVoIQxRNGIQZ6nZ0+/zH6oZ3HYNQ==
Date:   Mon, 25 Nov 2019 08:02:45 +0000
Message-ID: <VI1PR0402MB348579B485FC139EDA222B0C984A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
 <20191121155554.1227-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d9e3258-d989-4886-d161-08d7717ddb05
x-ms-traffictypediagnostic: VI1PR0402MB2848:|VI1PR0402MB2848:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2848A6D2D210AEFF6A581500984A0@VI1PR0402MB2848.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(2501003)(76116006)(91956017)(5660300002)(6506007)(53546011)(71200400001)(71190400001)(54906003)(44832011)(478600001)(14454004)(26005)(102836004)(25786009)(316002)(110136005)(76176011)(7696005)(52536014)(6116002)(3846002)(99286004)(6246003)(256004)(4744005)(4326008)(66066001)(229853002)(33656002)(86362001)(9686003)(81166006)(81156014)(55016002)(186003)(305945005)(7736002)(8676002)(8936002)(74316002)(6436002)(66946007)(2906002)(66446008)(446003)(66476007)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2848;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E7et/QmkoETc6r14/w2mSJll/o83MwgDLGM608Cs3hKGKr/We98ZVj34qqnSFQqm+Od4OFgAWmFLLPhpad2jaXpSDucPEK1ma6DFQCDM+n53M4VFH6kA795kYk3VVLaMwn4Mz4zJNkgExAytTkLNUv+cYTov4P0E2XiQder1ZRcuiagxhZrGj4/MvyZhW+jC1Ojz8fKezlQY7qfdXQDWE0lO66FaewKE+H59rcRFNYcJL7DgKcpmzoxcs1QYirogXbKcFm52Fc+yrTA+kkJez7bQCZAkWUpX6MPByNld+hlQtgXUupUSEs04sCdRtcQc4k8vgzXBjmZiHQh3Os9gLMJ2yog9oammFK/2Zc3jd9H74Jga6bqgAXBR2r3BKX24TgSANcb1rqQm1mLBqNt0x6/jHT0uY1aQELsmNYbgIpOc0XcrFyUCCQLVEUIdoLP7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9e3258-d989-4886-d161-08d7717ddb05
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 08:02:45.4327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q55ko4pWw+PFfuxqvqv1/aLgZ6ycqTCy0m3/Wj1o3NwBZ8YCk4RZjwfhgNKACRuUtBi1i0hTO0cnfrg+ys9d1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2848
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/21/2019 5:56 PM, Andrey Smirnov wrote:=0A=
> The TRNG as used in RNG4, used in CAAM has a documentation issue. The=0A=
I assume the "erratum" consists in RTMCTL[TRNG_ACC] bit=0A=
not being documented, correct?=0A=
=0A=
Is there an ID of the erratum?=0A=
Or at least do you know what parts / SoCs have incorrect documentation?=0A=
=0A=
> effect is that it is possible that the entropy used to instantiate the=0A=
> DRBG may be old entropy, rather than newly generated entropy. There is=0A=
> proper programming guidance, but it is not in the documentation.=0A=
> =0A=
Is the "programming guidance" public?=0A=
=0A=
Thanks,=0A=
Horia=0A=
