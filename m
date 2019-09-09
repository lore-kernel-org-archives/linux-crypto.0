Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F847C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69988218AF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IkliQBn4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfIINBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:01:39 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:48964
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbfIINBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:01:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEI0iiP7GoPkGliJPjzdy7JU5DR3wjQMXmhuqY3HNakoHluj4VR6P9a3GRaODsiHLCEKW9f21KdINeNtnRILRioaP0Fr51PxE29/m4xR0f7125EWoQElqUmvorxonwm7qTttNOh/nAeCc11PSk2dsgkI4s5JEnT/kCBDnblZyhxiPI3jjLIf4v+TDq6STw3ksd5AmYXtoRfLhmS5vYHlefu9WD2V53hUL2cUHhtQgNuggHifIsp08o7fxPsWUaNjbpzZjNuJ7NLvPeG6UZTutwbtVDkZ7yuIdeTZLNEFBvri6QSsj9lUh/wA3WLyXJQuoHti++4byB9Byuq+mY13pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwmUpl/Jkxjag3FFXbdMSlBothp7KMhsOW2Z712Avxg=;
 b=PTQZXaiT6N4ozFigX8Mc+idhMOvVNNz1qbptuo/dqqjqu1H+gSQyPvHzciN/5haFYodFyE5A9T8ggc4swbYpnpPRvDhEZRuOup3TFOSbayRxFnpafUbTMMUPFS0hcf1YGj2WTJcc5eUlK7YGtqmi1K3kIJIZd1nhChmrlsSU+MBKwrW1Kt0bfno7M9LAE9X8gEOcmZfYDcth59+2i9m/7dhtIAENlVj+ZLvhLwi8HxO4Yx2KXAESIf3dZGPl4rnbv9DP4EbPEazPlA2C+ZDbrox74TgKzpkugqeRH6KmYqo5DzepjZk1rY7jIzStL4ttRbrL0HGmqEUqBL0waI1WLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwmUpl/Jkxjag3FFXbdMSlBothp7KMhsOW2Z712Avxg=;
 b=IkliQBn4olkiIWJt++E50foBxsnzKCUKwJKuGNtNhJIJ8+eaqi1RVou/iVGSM3UmppjuSmRUcyJ9Tt+UihRBebCsTSbVow1sSgB9uMMm2cOYwTcjfqGjB9GIbbMHG2Z2Ff+bq42dnbFR2GozweM5RCuRsu22N0HhsBq57aze3h0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3392.eurprd04.prod.outlook.com (52.134.1.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Mon, 9 Sep 2019 13:01:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:01:33 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/12] crypto: caam - use devres to unmap JR's registers
Thread-Topic: [PATCH 02/12] crypto: caam - use devres to unmap JR's registers
Thread-Index: AQHVYslvb9FRxbBH50Gx/mHeQrstLA==
Date:   Mon, 9 Sep 2019 13:01:33 +0000
Message-ID: <VI1PR0402MB3485C0C5500766000E9A425E98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1014d7d7-4362-47c0-f90c-08d73525d75d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3392;
x-ms-traffictypediagnostic: VI1PR0402MB3392:|VI1PR0402MB3392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3392EDF652306CDF20EC4BD798B70@VI1PR0402MB3392.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(189003)(199004)(476003)(81166006)(316002)(256004)(54906003)(6246003)(33656002)(186003)(66476007)(64756008)(66446008)(6436002)(86362001)(91956017)(76116006)(26005)(66946007)(66556008)(7696005)(9686003)(2906002)(229853002)(4744005)(71190400001)(71200400001)(99286004)(53936002)(3846002)(6116002)(102836004)(53546011)(76176011)(7736002)(446003)(110136005)(486006)(74316002)(52536014)(55016002)(6506007)(4326008)(14454004)(5660300002)(25786009)(478600001)(66066001)(8936002)(44832011)(8676002)(81156014)(2501003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3392;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x9cabrj6s0Quhmwrb5Er4DhOEELAGguPFlKDeayIF4RTrII3cccY40JMLqwldKVvYYaXTdb91I1KCCSZRppJs7jsylfZFI/aqTGrTQambvPvfyea0iBWxaq9CSbjZK7k9rraX/SL1+7CLZu9f8xtyR/InDRhvCa3erZMP2iTFLDmNgJ+hYHeGkoUebYQi/7j++ti2ESJOUSUxLx+G/R8wJIQ0htDoiM/SPoetBhNEXRzP5nVo82DFPSm5zxwYZ74XM4NL5iz7DfRkwZOJZQ3W1hoNFhMiFa2XGgMIASmL1FSMYflP2pcYrkvV5HPI4PXQeFJTs27tHJAFoMpUnvlVB/g9jW3G1FFunByI2ei4f1ny6n7YdiCsbM6Q+EeM6X8qAgpd++4EikTqgMAHD/sPH9NVE4WEvkJvwu1RtJjs5M=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1014d7d7-4362-47c0-f90c-08d73525d75d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:01:33.7517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvmBZxyH/CkiEUa0vD1bwO3ViTjhorbd4prTAQ0KAadQ1TPs6VJ6zW5kIPeUvOniqWy0tSivjijd3xwq74C08g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3392
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to unmap memory and drop explicit de-initialization=0A=
> code.=0A=
> =0A=
> NOTE: There's no corresponding unmapping code in caam_jr_remove which=0A=
> seems like a resource leak.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
