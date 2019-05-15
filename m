Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35588C04AA7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F354F2084F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="d6c2s5T/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfEOGxD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 02:53:03 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:46593
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbfEOGxD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 02:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7wi1orUfQbgCBxY8G/nVeMFLA0syiE+GUDv6bMhKIU=;
 b=d6c2s5T/dJ2bZmu44aMMPsoHXgT41f9MJ+4az2p4dZu5Ry0eEfrvryP1dw4lKWDjzh7TtrPf1e5c4A/1vinReTX9DqmqUb1P0UBrCMNhWa3Nk7os5CV4hs2GQ0yGn61DR2ij5eXhldK+6WIgHcI0QKG52BhADeBfRUDGPgIg2SU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2784.eurprd04.prod.outlook.com (10.172.255.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 06:52:59 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 06:52:59 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 2/2] crypto: caam - fix pkcs1pad input without changing
 crypto request
Thread-Topic: [PATCH 2/2] crypto: caam - fix pkcs1pad input without changing
 crypto request
Thread-Index: AQHVCnRqfi6TUjMLqU+2umePOkXwgw==
Date:   Wed, 15 May 2019 06:52:58 +0000
Message-ID: <VI1PR0402MB34857944B58B6E0E44B5CCA098090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557852263-26896-1-git-send-email-iuliana.prodan@nxp.com>
 <1557852263-26896-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 026b9bf8-1b7b-448d-330f-08d6d901f782
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2784;
x-ms-traffictypediagnostic: VI1PR0402MB2784:
x-microsoft-antispam-prvs: <VI1PR0402MB27847A39D72B3FF5883CF5CE98090@VI1PR0402MB2784.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(136003)(396003)(366004)(189003)(199004)(68736007)(7696005)(229853002)(6636002)(55016002)(99286004)(6436002)(76176011)(256004)(71190400001)(102836004)(53546011)(305945005)(5660300002)(71200400001)(6506007)(74316002)(76116006)(7736002)(486006)(476003)(44832011)(4744005)(52536014)(26005)(14444005)(186003)(446003)(81156014)(81166006)(8936002)(8676002)(66066001)(316002)(73956011)(33656002)(110136005)(3846002)(6116002)(66946007)(66446008)(54906003)(64756008)(66556008)(66476007)(478600001)(9686003)(2906002)(25786009)(4326008)(53936002)(86362001)(14454004)(6246003)(32563001)(473944003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2784;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rNaECGxJKZ69CA51iS8RaKkJo0KZwL6AqFO/tM4c7Qsze95DlDcTmhsZmNCGocp8u6TPPE0ichsWjCTpoB7OYxU/GtFOZ8RtBWzuQPvko8JhsBlGvXyw70V8Sjd0pxazV4BOPL2M9kqfjOrUcFUgyBTsmaL2kR0iweWWofTxa6nKk9JSrl+yXpccGuVrfHc3Kw/R5tXVSdrYnBZyMAx2ABm/Y4aNZUvYNn328lTYeTs2713nw8LHd3aWQ5HLd/e9L0MVXT2TaSAN/UAoutfrPyBk5Wy6QCYWY0OYCiSYLz8lyc2+sGxwtYni6XxMkGqe0AshoUB4Xo52WDJLaKzSr67sJJgstj5zM3WhCnB4utJwVRBZ6d42V5fYV3KtpCAekWnTSSOcqDhEIk06hs0bulfnOfbvM16MKAPNMhF9HHo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026b9bf8-1b7b-448d-330f-08d6d901f782
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 06:52:58.8982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2784
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/14/2019 7:45 PM, Iuliana Prodan wrote:=0A=
> For pkcs1pad(rsa-caam, sha256), CAAM expects an input of modulus size. Fo=
r=0A=
> this we strip the leading zeros in case the size is more than modulus or=
=0A=
> pad the input with zeros until the modulus size is reached.=0A=
> This commit avoids modifying the crypto request while striping zeros from=
=0A=
> input, to comply with the crypto API requirement. This is done by adding=
=0A=
> a fixup input pointer and length.=0A=
> =0A=
This fix is not specific to pkcs1pad, it applies even to textbook / raw rsa=
.=0A=
Pleas rephrase the commit message accordingly.=0A=
=0A=
Thanks,=0A=
Horia=0A=
