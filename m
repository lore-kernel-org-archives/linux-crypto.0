Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FDEC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAC0E2082F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="tD03K9mX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0JOE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 05:14:04 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:63362
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfF0JOD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 05:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ezh8oSDgSJRGG3KZkTd5MS1NYJoYR3tnTn1y8vM6sCg=;
 b=tD03K9mXDdRhp1ok919bkHM+bkcor2xn01/e1tKdmELFFrgT+L+lDa3WJYO+brqWB/FYeiWvl679yZWogAFm9aWfOQB3RicqeiZSgOyNspM21weTqza0Ea+LXkGDKsqnC4wMQDAPSJ6iI6GQ2pf6OKMePcbTiS/gdKso0BkMA98=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3440.eurprd04.prod.outlook.com (52.134.3.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 09:14:00 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 09:14:00 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [RFC PATCH 05/30] crypto: bcm/des - switch to new verification
 routines
Thread-Topic: [RFC PATCH 05/30] crypto: bcm/des - switch to new verification
 routines
Thread-Index: AQHVKJHmWZhrW+FFCkW+wbWQE6TVQA==
Date:   Thu, 27 Jun 2019 09:14:00 +0000
Message-ID: <VI1PR0402MB34856DCDAD66524FB58F165E98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-6-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3c7d79e-a2e3-418a-f5ba-08d6fadfcaf1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3440;
x-ms-traffictypediagnostic: VI1PR0402MB3440:
x-microsoft-antispam-prvs: <VI1PR0402MB344000F9E6C2D8844F9AFAD698FD0@VI1PR0402MB3440.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:226;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(199004)(6436002)(486006)(44832011)(81166006)(81156014)(186003)(102836004)(558084003)(53936002)(8676002)(256004)(110136005)(54906003)(5660300002)(76176011)(66476007)(52536014)(6246003)(8936002)(53546011)(6506007)(7696005)(74316002)(76116006)(316002)(66446008)(66946007)(66556008)(64756008)(73956011)(14454004)(33656002)(2501003)(478600001)(2906002)(4326008)(68736007)(476003)(446003)(229853002)(66066001)(9686003)(71200400001)(71190400001)(7736002)(305945005)(55016002)(99286004)(3846002)(25786009)(6116002)(86362001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3440;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4oxgBaXGxr+cPIA9NhY8U6CxuNIG3Oy8EiTgYNQ+uwx6eTfQLwLPJwBOJ0YT97F2PrzyeEDXEH6yV6ujizZfTHB2b5WYZFkLAAMyKef7F50FiMj3SALw2vDD2zTjWd/x78g3RzdMpAqpG5IySuKL9KvU96Swk2Vlu2akWj3+hkXvmS4213M8B8KK2IE+Hzxnwx+Y/PkKUwaKR/kfmTCWEiuCfYmmfctzsD68/BoZHPm8xluIW+kIkJM6tmfEnZcsjA61vkVn5eaQVEK0ty8d7EQAG2meUiDJ+FayCNWuKHLgxU8TdzcQ/C/GlEdUgqrO44hHiKjoKXDSsPViBaeRwhtuhe1iVXuahDNNON5xglTpESB4SUizhDoySOxqNUbQzoRFVNlq8oVv729lXnwBHbUivmgZ7Nq0tTs036PiD0A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c7d79e-a2e3-418a-f5ba-08d6fadfcaf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 09:14:00.8080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3440
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/22/2019 3:31 AM, Ard Biesheuvel wrote:=0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
> ---=0A=
>  drivers/crypto/bcm/cipher.c   | 82 +++++---------------=0A=
>  drivers/crypto/caam/caamalg.c | 31 ++++----=0A=
>  2 files changed, 37 insertions(+), 76 deletions(-)=0A=
> =0A=
Typo: caam changes should be part of next patch (06/30).=0A=
=0A=
Horia=0A=
