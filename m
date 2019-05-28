Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF7AC04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 10:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5941C2070D
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 10:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lYumoZui"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfE1K6l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 06:58:41 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:30238
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbfE1K6l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 06:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZThu+XCpRZBM8jaMCMQA5O0s2CzjGyjWNprWfR641o=;
 b=lYumoZuinJW9odDtFTw2+rrlfQ29IVpmYkFHafTx8IfBeAe5grzBLk8IJXLECI8kS6qQeq9CXqEzbxBbJJWtmc50mWU09k/nz2Iw+6XImZI5Rp5kW+/xSgR/M4+hEf5etG2gWcTAZVit70sf93r3qUmgmsfvujgzdAdbM/VdfCc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3661.eurprd04.prod.outlook.com (52.134.14.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Tue, 28 May 2019 10:58:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 10:58:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v5 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVFTsIqleeE9MbU0ezlG/eKoEFfg==
Date:   Tue, 28 May 2019 10:58:36 +0000
Message-ID: <VI1PR0402MB348536AFAAE417EC5F541D74981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559037131-4601-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a240b2f9-a078-4688-4ef8-08d6e35b6f77
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3661;
x-ms-traffictypediagnostic: VI1PR0402MB3661:
x-microsoft-antispam-prvs: <VI1PR0402MB3661BE3E530E23222FDEF595981E0@VI1PR0402MB3661.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(33656002)(478600001)(68736007)(6436002)(8676002)(305945005)(476003)(14454004)(52536014)(4326008)(186003)(53936002)(7736002)(74316002)(316002)(44832011)(99286004)(102836004)(3846002)(6116002)(73956011)(486006)(446003)(6246003)(7696005)(6636002)(2906002)(76116006)(4744005)(25786009)(71190400001)(71200400001)(26005)(86362001)(66556008)(66446008)(64756008)(66476007)(8936002)(66946007)(54906003)(110136005)(256004)(81166006)(76176011)(53546011)(81156014)(6506007)(5660300002)(66066001)(9686003)(229853002)(55016002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3661;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oEYu/mSVeN3n5rE1eqHLyQmF+LPXDWhAWynP5L64cJO+orGB1IZ/etXU9Q09k7VUz7j7T7YL1byikrs+sCBasF7nqGvVH3vJyczilYJmk+c2jwAJR0Q6M0zN0Rcd6FYrAqRB6Aum67KqsEhuF4CSBkehw/fgWUD4SYIR2H0KTALsbCbIOscJMRnMACgLz/NFTXm+dkj4zSp3+HxrJaYfFv1Yluh4FRCh/ANYJUrk21B5cwcGZnxm9tiCQJQlx5d0WlD9H9Kj5tW71NK/bYyJCMUjsEvjHVEJeRF4IPa+z/mk5npRB+KR7/h/cHLC+0xRf0ZFq3oiuBDR7VMjKwyMBWAjdFVb5odnJtD2dfZqp0Lm4i0KuH16qd5t0GNafkrhJyroLtmrRafVvpLyktSlqr2lfIO3tejVJsSY7zm1Nw0=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a240b2f9-a078-4688-4ef8-08d6e35b6f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 10:58:36.9893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3661
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/28/2019 12:52 PM, Iuliana Prodan wrote:=0A=
> The problem is with the input data size sent to CAAM for encrypt/decrypt.=
=0A=
> Pkcs1pad is failing due to pkcs1 padding done in SW starting with0x01=0A=
> instead of 0x00 0x01.=0A=
> CAAM expects an input of modulus size. For this we strip the leading=0A=
> zeros in case the size is more than modulus or pad the input with zeros=
=0A=
> until the modulus size is reached.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
