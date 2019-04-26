Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749FDC43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C9322077B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="K9Rd0KTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDZQFv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:05:51 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:11462
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725984AbfDZQFu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 12:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7AqpQS3kfMYtecBaPyqv6U2lPiougpSpA8Z0ITV+Y=;
 b=K9Rd0KTwG6xtvht1OYx8IpHTFhj2TDk3ZCdse33Rc5K7hTpTcOfwl9w33kgZRdFwSlj6l8tdV89Y8Ij3XOP9Yc2ARsLWr1juW8vOc+SEFjD39L7+z3OuNRIXNJX6IJZRbiIgtLbv26NPXPI3LgA7Tqqkk8yC2u1746N3oc4A/Is=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3885.eurprd04.prod.outlook.com (52.134.17.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Fri, 26 Apr 2019 16:05:47 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1813.017; Fri, 26 Apr 2019
 16:05:47 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Franck Lenormand <franck.lenormand@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Topic: [PATCH 0/7] crypto: caam - IOMMU support
Thread-Index: AQHU+4N3anqMDo9NOUqVDDhJ3xPEHA==
Date:   Fri, 26 Apr 2019 16:05:46 +0000
Message-ID: <VI1PR0402MB3485DC75484184AF9CCA87A4983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
 <AM6PR04MB54473208BC59642200F4591A923E0@AM6PR04MB5447.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.230.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cd8241a-4c6d-4b1b-eb32-08d6ca610b5f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3885;
x-ms-traffictypediagnostic: VI1PR0402MB3885:
x-microsoft-antispam-prvs: <VI1PR0402MB3885AC90DCFA7433688D587C983E0@VI1PR0402MB3885.eurprd04.prod.outlook.com>
x-forefront-prvs: 001968DD50
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(136003)(39860400002)(376002)(189003)(199004)(25786009)(97736004)(76116006)(4326008)(478600001)(6246003)(6436002)(229853002)(26005)(33656002)(476003)(81166006)(81156014)(305945005)(74316002)(55016002)(44832011)(6506007)(186003)(446003)(102836004)(2906002)(8936002)(7736002)(53546011)(14454004)(99286004)(486006)(9686003)(7696005)(256004)(5660300002)(76176011)(66066001)(54906003)(4744005)(110136005)(316002)(71200400001)(71190400001)(53936002)(8676002)(68736007)(73956011)(66556008)(86362001)(66446008)(64756008)(6116002)(66476007)(52536014)(3846002)(66946007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3885;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MKsTQDPSE18wDVSQDcQ0Vn0QpGhcDYlZ74fscMMZjrY7PV8xx3ukkKG2QUO+K2g85Kwe0ivjVAg7sSWexkOHoOqM/oS9Tn6BzeTaO0lyOHwVgtOcPkyfonrv49m/CIoRV6N+bTfN1Ykglu2Tsv1FEp5W3yKZFrHdC4+HchDgNbbVFtxUKHEal1Igf1/Es+tguXKddF00aClY6WsFzP10Zt45ARif7t61sKRXxRrzHxKaVpWahB1eaT4CSdrZSoBUyNEhHQgFte9A/qNbdWyl9TiSqBWItPMblye5TuknanVNweqc4vzhyvN4LBOLXpkgriYpDSwUL29BF20nrgQjlbmGMcBF6sQLhJkRbGnfSKVHJ2kXwyIUD8GN7HBMKa57Pv+qfLEXemlLZm1CB2t5mD3sz27N1NKlRXh1fcz4XdE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd8241a-4c6d-4b1b-eb32-08d6ca610b5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2019 16:05:46.9576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3885
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/26/2019 10:28 AM, Franck Lenormand wrote:=0A=
> Hello,=0A=
> =0A=
> When you speak of "crypto engine", you mean the caam engine? In effect th=
e "crypto engine" component already exists.=0A=
> =0A=
Yes, in this context crypto engine refers to _caam_ accelerator.=0A=
=0A=
> About the tests, what about iMX?=0A=
> =0A=
AFAIK the only i.MX platform having an IOMMU is i.MX8 QM.=0A=
Currently caam driver does not support i.MX8 family.=0A=
=0A=
Tests were run on i.MX6 and the patch set does not introduce any regression=
.=0A=
=0A=
Horia=0A=
