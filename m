Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B91C76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 07:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72FBD20665
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 07:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="a+R0a19f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfGQHIS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 03:08:18 -0400
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:19526
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbfGQHIS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 03:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNj5DRa/6byCVqNEw946F0vmTvwVcfwy1fxFz+uRmto=;
 b=a+R0a19f6KCTKuFeOJzXkR9Cw3IGRMwOQchlWXWrKBCB7MWzxk/bYhpq36VIgUQATUcz2X8J2YcOTchacObjYdOyXBTWw9fz+Sq3PsDfCgVCa0ZxhQDv7txXKq5LJqECziFW1zkcuZR60CngGq5oKCT/UvUKHh8WxvMQUHfW650=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4686.eurprd04.prod.outlook.com (20.177.56.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 17 Jul 2019 07:08:15 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac%3]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 07:08:15 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Leonard Crestez <leonard.crestez@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 02/14] crypto: caam - simplfy clock initialization
Thread-Topic: [PATCH v5 02/14] crypto: caam - simplfy clock initialization
Thread-Index: AQHVO0rFDbdaRxn10E6ZpXPILy0l2g==
Date:   Wed, 17 Jul 2019 07:08:15 +0000
Message-ID: <VI1PR04MB444576A86254A175874EE4158CC90@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190715201942.17309-1-andrew.smirnov@gmail.com>
 <20190715201942.17309-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 366bdba8-5a0a-408a-59ec-08d70a8589a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4686;
x-ms-traffictypediagnostic: VI1PR04MB4686:
x-microsoft-antispam-prvs: <VI1PR04MB4686A32752A6B647E64CD66A8CC90@VI1PR04MB4686.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(199004)(189003)(76176011)(2501003)(68736007)(7696005)(3846002)(14454004)(6116002)(33656002)(66066001)(54906003)(110136005)(186003)(2906002)(26005)(316002)(74316002)(99286004)(6506007)(102836004)(53546011)(6246003)(4326008)(55016002)(256004)(305945005)(7736002)(71190400001)(86362001)(478600001)(9686003)(53936002)(446003)(6436002)(76116006)(44832011)(8676002)(66556008)(64756008)(91956017)(66946007)(66446008)(66476007)(8936002)(52536014)(25786009)(476003)(4744005)(81166006)(81156014)(5660300002)(486006)(229853002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4686;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UUtdAZwFQwtA8tEvocE8xoPXKi1Juf9b6S3UjOZJRcvPkzkZFE19WBPyd8hwHLg/vpDag2McjQsKMsyu7mSAskGeUzMkeQoVOR52kVk1AVTMC0nroCqtzFFSz1qQSUoE/kHDsjlh9JEyasxf6KyTanaR9v/ylBQtwdTaCjsATV8IrN4cFPStvBQEpCc7nNDYJbclIM7lAqKr+lr3c2uKgZToUDeOu+eckrN4YYt+HFCb0jWkbmgWGdLD879RKptGSuZRMkzMTMtPjfa6boLH4BpSEb0IIHA8fhBjNHq5wRoP5FvQ0MKE2cf6hurKQCJzgApeuBlUp+kp7FMrk30TKZi2k8gJQptpvzkodWyHoTiB4P3QMlJfnIV7klG18QgLQ9UQEVehqmIluO0xt1DHDKQ0+SN0z/QKf88++rssuTU=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366bdba8-5a0a-408a-59ec-08d70a8589a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 07:08:15.1370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/15/2019 11:20 PM, Andrey Smirnov wrote:=0A=
> Simplify clock initialization code by converting it to use clk-bulk,=0A=
> devres and soc_device_match() match table. No functional change=0A=
> intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> Cc: Cory Tusar <cory.tusar@zii.aero>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> ---=0A=
=0A=
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
