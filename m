Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F82BC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46B4C2087F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GDfnlLWk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfG3MKq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:10:46 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:62471
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726717AbfG3MKq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:10:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk97nsOYb91fzhQDJhnZ1RWVxLxhwD8sLH2V0Nzv4H3gxNwMSwqn2LEhB4GTfFj/6Qodd0C9wAV+dhC3CevZ2Aa1SFazUPmrNx7DMTljJSjJjJyV+1nbDRP2jqkRvkiVofKMgaLO1Etd/mcAzTOACC6WGG7H6cCGqCDvd+1HxoT4EB9xLpNNThm1MDg/7y/YOTd7ESfZUA/M3oxpmGTZuZfUjDLxGC09kVclPjZJCejdywIG5D4hMKwQ+QKxCbsSxrp76F5H3LFnflFdSS2fKCAx2AoeHBjYLBIdL682bVxqWHs2zSmRYr4aR9Y8KNnUADYCbeLHuJv82mbYEx7a5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNzGLUP7Or2D6hK6jTYTP2FOsutzS0OhQCA1HL5QsSM=;
 b=jMiqt6lb35o2h7AknEfJIZWGCgRGL5EiiOJID58UbXxWB5Np5XTfH+79SKAx+9J7ujCanIOAK399fvPdLePXEXXQJ8M3JBYHQMqILVARXaBknHwZD7NZYpUx53YzQiPHrLIqhopYHUHoRTcp/L2JP+wdRra4jXX7HuM7iWHo/6fzM1XR5BoNsYGIYHGGCs2DXGsMJNecbKQkQpVHWoBCdIY00NLBXwZsNIsj2PdjYEe6LjTzxCoyHhEqwo9MGpXRaOvUSFa0J5V8B30yZaWxYK67CzjmByHCrWH22tg0q0pVSpouqPOrVz+kMNhTOzAEG7/Q6o81w/tAoTwCenjZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNzGLUP7Or2D6hK6jTYTP2FOsutzS0OhQCA1HL5QsSM=;
 b=GDfnlLWkNPtSnjafvTG/+dzzC18z6DgVpfLIpV8aXO3IHPVbtsKGf1nvqmJd0fUO1nwD8MuTtrgpYMy/lBpgbi6hW9xOnTaV2ttmR/jWFSNB9lIxAIqbV4Vqy4fVinrDYhmLi4xvS9tFZ5N25ukFqMiL69tDGveipuU6xVwn/P0=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5166.eurprd04.prod.outlook.com (20.177.50.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 12:10:42 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 12:10:42 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 09/14] crypto: caam - keep both virtual and dma key
 addresses
Thread-Topic: [PATCH v4 09/14] crypto: caam - keep both virtual and dma key
 addresses
Thread-Index: AQHVRsbo/K7duR/t8kGtx4yGfVP2+w==
Date:   Tue, 30 Jul 2019 12:10:42 +0000
Message-ID: <VI1PR04MB4445EE29118E184B73974CB58CDC0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
 <1564484805-28735-10-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a109383a-d7e8-4fee-e46f-08d714e6f1e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5166;
x-ms-traffictypediagnostic: VI1PR04MB5166:
x-microsoft-antispam-prvs: <VI1PR04MB5166AEF1295CD45A33AC01018CDC0@VI1PR04MB5166.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(86362001)(110136005)(4744005)(66066001)(6636002)(476003)(53546011)(14444005)(7696005)(8676002)(44832011)(81156014)(76176011)(14454004)(186003)(229853002)(81166006)(102836004)(478600001)(26005)(7736002)(8936002)(6436002)(68736007)(33656002)(486006)(54906003)(6506007)(2906002)(316002)(66446008)(66476007)(66556008)(64756008)(66946007)(91956017)(6246003)(25786009)(4326008)(53936002)(3846002)(256004)(6116002)(74316002)(9686003)(52536014)(305945005)(5660300002)(55016002)(99286004)(446003)(71200400001)(76116006)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5166;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: svXeshaRFZNubqvm0yC8YGSsgspgUfdmA9fBvPd4Qxg7wL4VYiMzQZ3a6tbDMySqvUfbwAW0FfQnM74Sr2qMjglI1zdeuuJgVOotTOIJFZEF66DM1MXKJkHpNzf4X7+KA9cBUqXHk/NZKECTDyRCsVbUtmowgEBFJqb9kfS9ijqyRUXbVSwLfFmUbAbwOTOXw99GY0fT6NaUjknMBiUfuen22Hy7myZl+eCfwLG7JmYn62KS0eQUtiZHGD/kEou5QUp/m49OEvtNUk9utv+VQQnjTHaoDp9j4jRmuw9GTzvvLmsPM8+jzJsshCwOdZv6O6dwnypwOqUW9AxKJfXnTS+7npEAcYPH3cDAAILKu0v1bWm7TEaXheH4iGQHPrDnEJZEWdhqhPyaaKdIGw7phJdbg5hZmDglUY+7O/vQq1s=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a109383a-d7e8-4fee-e46f-08d714e6f1e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 12:10:42.7872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5166
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 2:06 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Update alginfo struct to keep both virtual and dma key addresses,=0A=
> so that descriptors have them at hand.=0A=
> One example where this is needed is in the xcbc(aes) shared descriptors,=
=0A=
> which are updated in current patch.=0A=
> Another example is the upcoming fix for DKP.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> ---=0A=
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
