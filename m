Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B286CC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A162133D
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UPkeqXPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388460AbfEXGwY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 02:52:24 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:44516
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388359AbfEXGwY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 02:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlRvQZo53BSUi27LQlzuJ4QnlVhn6ZgzMtaFg7S9t3E=;
 b=UPkeqXPCDFtNUGZPLsCHZEQVeAFYbIB2ssI/ZAucHRqgQSK3PHdygibydmXS3qIxwU7FgVZM85F+I0Ws+EnBk3VYi2ouY6XhAiOJgjconTuZd8CqRI9xoSd77T7gM6FqpPcGblxuOCujKDSqFCpcUtNkppUkUwzyVd8scMT/W6Y=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3694.eurprd04.prod.outlook.com (52.134.15.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 06:52:20 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 06:52:20 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVES51mI1lYxB850GcRxowCCF+GA==
Date:   Fri, 24 May 2019 06:52:20 +0000
Message-ID: <VI1PR0402MB348566DBD83A4FE5B9B5E42598020@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
 <20190523061202.ic2vgimgzvvm6dzc@gondor.apana.org.au>
 <AM0PR0402MB3476BE4FE08AC135742D262998010@AM0PR0402MB3476.eurprd04.prod.outlook.com>
 <20190523123813.xosynrnsdpqfieqv@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b5aec0-73ff-4bd4-b3a0-08d6e0145e1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3694;
x-ms-traffictypediagnostic: VI1PR0402MB3694:
x-microsoft-antispam-prvs: <VI1PR0402MB3694C4D65D4CB4C14AE07E0B98020@VI1PR0402MB3694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(186003)(26005)(54906003)(305945005)(316002)(478600001)(68736007)(6246003)(446003)(229853002)(14444005)(256004)(7696005)(33656002)(53546011)(102836004)(25786009)(6506007)(99286004)(76176011)(53936002)(74316002)(4326008)(66066001)(52536014)(6916009)(2906002)(14454004)(9686003)(66446008)(3846002)(73956011)(66476007)(66946007)(76116006)(64756008)(6116002)(7736002)(91956017)(66556008)(86362001)(81166006)(81156014)(476003)(8936002)(55016002)(6436002)(44832011)(8676002)(486006)(5660300002)(71190400001)(71200400001)(4744005)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3694;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qsPN4EIZ9+qol1kzlAnlF9D232Yf1lRp7FciVavShxats2jykaApOSO65GU67aTC4Kp2xsYr2YyCPsmduv94naXWHb46+gwpzM3pUIZvaMfEnT/AJH3Pi/XH6EiPG1nT3O6EkACeYhdmji5Cx7lc4CQ57UrCLyYlLfnUqc4znAlBf9k1ACcihlvfBdBLIOtSpRB6NfAoKya979OeJJnEKppAwe/4zvOzv1NB3x/GOxyYxasUSsDJMUJFJhFYeZzjV5Ptm4v0EVV3fq1PFaJv8Bg8/nl0eziwS8ZRBLLxCqiiaQPkgccMD+XVclBW+RNVawDt0+E2L935/XBjeGp+zAT84fEkZCVXCuCkTnUQ9iW1xFhfpM1CKC1xun4UGs+GB+XL22auc+QtVPRTfv14xUmsjZMovp1eVOrx+owJfKE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b5aec0-73ff-4bd4-b3a0-08d6e0145e1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 06:52:20.1076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3694
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/23/2019 3:38 PM, Herbert Xu wrote:=0A=
> On Thu, May 23, 2019 at 10:02:41AM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> When crypto_register_akcipher fails, it merely prints a warning and fall=
s=0A=
>> through (does not immediately return), thus there's no leak.=0A=
> =0A=
> How can this work? Wouldn't the exit path then unregister a bunch of=0A=
> unregistered algorithms and crash?=0A=
> =0A=
You're actually right.=0A=
zero_buffer is leaked in case crypto_register_akcipher fails.=0A=
=0A=
Besides this, there is an existing issue (independent of current patch) wit=
h=0A=
algorithm registration: algorithms (in fact, rsa) are unregistered even if=
=0A=
registration might have failed.=0A=
This should be addressed separately.=0A=
=0A=
Thanks,=0A=
Horia=0A=
