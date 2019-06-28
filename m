Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289CFC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015C02086D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Q5r6Cwfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfF1LxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:53:09 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:62848
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbfF1LxI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 07:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6ZCKtARLt9uyX/UzQZL1dXl7+siErJjK5+Zt8MYUJg=;
 b=Q5r6CwfjNfiKNxyWrhnezyuK8Ey4jEAzWUDrf5xdLYIfBe15ic/oG+Hc7nufMWBp6iypZAAWfEtMcIihNGULsxs95MosYxFeitPob2djg96bDTY0OmOss2SZJlqOvEw5lvGvm6MVAO4zoRh6sQXGkZKfPe4jN2IhKTKmVqdPWHo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2750.eurprd04.prod.outlook.com (10.175.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 11:53:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 11:53:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: Re: [PATCH v3 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Topic: [PATCH v3 06/30] crypto: caam/des - switch to new verification
 routines
Thread-Index: AQHVLZTeu7MCd9HiFkS2/kUN1AZiJg==
Date:   Fri, 28 Jun 2019 11:53:05 +0000
Message-ID: <VI1PR0402MB3485DA252922CB9918FF989F98FC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
 <20190628093529.12281-7-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76f81025-22a6-405b-30a1-08d6fbbf2ec5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2750;
x-ms-traffictypediagnostic: VI1PR0402MB2750:
x-microsoft-antispam-prvs: <VI1PR0402MB275083092C28975482E389F998FC0@VI1PR0402MB2750.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(189003)(199004)(9686003)(229853002)(55016002)(53546011)(256004)(316002)(102836004)(486006)(86362001)(446003)(6506007)(66946007)(7696005)(305945005)(33656002)(71200400001)(71190400001)(5660300002)(6246003)(476003)(26005)(81156014)(3846002)(6116002)(74316002)(478600001)(99286004)(14454004)(7736002)(2501003)(186003)(76176011)(73956011)(76116006)(4326008)(110136005)(64756008)(66476007)(6436002)(558084003)(8936002)(52536014)(66066001)(54906003)(81166006)(25786009)(8676002)(53936002)(66446008)(2906002)(66556008)(44832011)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2750;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jRnRFXtsTZmKg9bsvUoa/WkBDM4FQOOqZcYDcIZOCzQDFPV5va/kjP5hC/GmDQbcy3HiNsfCW68JBLIZUX08Z/6+WwA7hAXGbo6JrV9BF6lkrK/QlVBoaExroXCdIAN4L7w3mQmpouEOURd4Unn+f6X9i+RSldPvcjhWAK9d1bkSL5KX4SO6LRmQDbNLQQclxsJ8Af7Mb08+M1julpW9QrhyuB257Nw3gJCqGw7jzCnh3JP6nUS8wXItjjZJkR+0TSNCc+ECYaEEZFhkKNo0Zze9Kf2UkCVhZO+UDSpxhZ8M2JHzuiE66xLyNRLfZoloqjsRTvmfN0CDB0ZDfmphyz3X7FYTdpdMyfoSvLhjzJfgMzGs+oWGm5gvxQRLNIGfxkRv+ANHIHF0HFWTZzx0htoXesYL7J3FsMvqa1R+RU4=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f81025-22a6-405b-30a1-08d6fbbf2ec5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 11:53:05.9925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2750
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/28/2019 12:35 PM, Ard Biesheuvel wrote:=0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
