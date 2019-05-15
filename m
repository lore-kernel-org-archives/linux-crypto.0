Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF98C04AA7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206D52084F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="bREpdORC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfEOGax (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 02:30:53 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:64320
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbfEOGaw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 02:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pVzEsuObWcI1i32KWw69jMg/buUZwRHWwTc9urPPx8=;
 b=bREpdORCQhpk3BcEXZPXGvh7lu3CaKN2OjdHofe2K1l5u1M+EolhzLlui9mcMAC9zBojxAXRUdWBMMbO33yZNoli/IKkWJULg/N6yV/ApBxEIofZJz5AtwjTYB5ePmcUKaPh87aXP27/gdewRClJISTgkUxeWIY6C0UckitA05s=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2749.eurprd04.prod.outlook.com (10.175.23.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 06:30:49 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 06:30:49 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix typo in i.MX6 devices list for errata
Thread-Topic: [PATCH] crypto: caam - fix typo in i.MX6 devices list for errata
Thread-Index: AQHVCnhXFvg20HyHa0+AyCigja1VXA==
Date:   Wed, 15 May 2019 06:30:49 +0000
Message-ID: <VI1PR0402MB348565FF1A87F81F89E5497198090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557853989-29075-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6cb9c6a3-9ac0-4ecd-3d38-08d6d8fedf1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2749;
x-ms-traffictypediagnostic: VI1PR0402MB2749:
x-microsoft-antispam-prvs: <VI1PR0402MB2749CE5EE01A88D8F4F165AA98090@VI1PR0402MB2749.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(396003)(366004)(376002)(199004)(189003)(71190400001)(64756008)(66446008)(256004)(71200400001)(14444005)(66556008)(66476007)(53936002)(81166006)(3846002)(81156014)(7736002)(305945005)(6436002)(2906002)(73956011)(446003)(86362001)(476003)(66946007)(76116006)(486006)(44832011)(6116002)(5660300002)(4744005)(102836004)(6506007)(53546011)(76176011)(6246003)(478600001)(52536014)(68736007)(6636002)(14454004)(9686003)(7696005)(99286004)(25786009)(110136005)(186003)(8676002)(8936002)(229853002)(26005)(33656002)(55016002)(54906003)(316002)(74316002)(4326008)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2749;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C7e6OhavABQKw0pwHYjdWQ3ELyFJKkzIXN0kEACPfQjmUAFqixIpZd633WsGYOY99COfA8iOq6ETxRASZlifLpscskWILlTwLNcCoKKf2ZxFeGi9c3mnQuRPJ7RUrlUsanJzdun5PXU6/Bl+1qzTZKQGkI6GyaCVe1U67nq2rX9sL+GEOhNBL7B91P7r9K+AnjqYrblZFtQcU4bow5Xi//SfXEdJOwYadjvIdRtoWnXbXiWVaMUqBeWPzcyCwpgBepdHv8MktWNqQcAkFh0zGlWO84ZcPIG53IYoLBVi4MnjfLcKFjHrF2ptTcvlzGbIngd90Zl4L/izkbfP1pYH31ddj/9G+zGPe883yzRyZ/2XpP3sguikZgjbGkqGhelEix5aRtP32Htx1x55E3DJQPlMuKtvutuaOuDtAuyqhXs=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb9c6a3-9ac0-4ecd-3d38-08d6d8fedf1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 06:30:49.4990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2749
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/14/2019 8:13 PM, Iuliana Prodan wrote:=0A=
> Fix a typo in the list of i.MX6 devices affected by an=0A=
> issue wherein AXI bus transactions may not occur in=0A=
> the correct order.=0A=
> =0A=
> Fixes: 33d69455e402 ("crypto: caam - limit AXI pipeline to a depth of=0A=
> 1")=0A=
Nitpick: No wrapping for commit headline.=0A=
=0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
