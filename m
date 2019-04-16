Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2835C10F13
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 12:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3791205ED
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 12:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GGtdrfzy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfDPMxh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 08:53:37 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:42981
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726796AbfDPMxh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 08:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsUN/fBd9sH4KZ7AId0LZyJkCgXr8ij6a/N9NkJpibQ=;
 b=GGtdrfzyvKv/I3PZpvmTveUn6/bCWBKZ6mZsSi1teMyqmAfZMYtWFHofp/MRKiG1Kk58TNxrhR4jF+18xENnUdv6OZsDVZV4qVvn5XbSw6159wukPnfPiWG5B9jwI1z/c+Py6kUCeRvad6sTpMuXxZ+dDqIF0PbUdJBZhU/K9PM=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5568.eurprd04.prod.outlook.com (20.178.123.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.16; Tue, 16 Apr 2019 12:53:32 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::e136:3450:c3e3:3517]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::e136:3450:c3e3:3517%5]) with mapi id 15.20.1813.011; Tue, 16 Apr 2019
 12:53:32 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 6/24] crypto: caam - Forbid 2-key 3DES in FIPS mode
Thread-Topic: [PATCH 6/24] crypto: caam - Forbid 2-key 3DES in FIPS mode
Thread-Index: AQHU9FNlrgZ2pe/kRkSmfaOXR0sAdg==
Date:   Tue, 16 Apr 2019 12:53:32 +0000
Message-ID: <VI1PR04MB44452C3A5520E78D63E1B0EA8C240@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQE-0006mC-7q@gondobar>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ed39555-8b31-42d9-1a7b-08d6c26a883e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR04MB5568;
x-ms-traffictypediagnostic: VI1PR04MB5568:
x-microsoft-antispam-prvs: <VI1PR04MB55687232804155C51F619E6C8C240@VI1PR04MB5568.eurprd04.prod.outlook.com>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(376002)(136003)(366004)(199004)(189003)(66066001)(5660300002)(68736007)(55016002)(9686003)(8936002)(558084003)(8676002)(81156014)(53936002)(316002)(14454004)(478600001)(81166006)(6436002)(44832011)(110136005)(6246003)(229853002)(97736004)(2906002)(256004)(446003)(106356001)(26005)(6506007)(74316002)(52536014)(105586002)(86362001)(305945005)(7696005)(102836004)(99286004)(25786009)(486006)(476003)(7736002)(3846002)(71200400001)(71190400001)(76176011)(33656002)(6116002)(53546011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5568;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4XWyBSRg12HUHiOJZ+aw6VMFCTp0qWn3pyq7WO/6UkKkRZlkbh34cOipn+DI8jSFfOdiV/YLLET1sjCVaO87eFlVSdHIzxdebmFAPIaxGSA8v9S0jotHC0OxbFN0bvuxCLTEHFxGEUiiMDoapQ+A0mf+4fOITJ3LciLVRuQ9tilN0csASrNFP+eKg4LQ9FP2Jd+oT4bAsQUxS2qOavr+mIIX5VssrBT7V8C7IlPVT4QU6VA7SRPU/nAEXG560RKp4A8jECVLHuShskiAtbX2QrdKwftSL4hBkLd5+oBWYp26FC6JmVJbbHkndODnJhb0OO6y5m1mM2T1rsf/Z6Z2tOxptmuevcwlkMw01awgeNSi/TvCDBRmqLFJUHEb0NcGTdUtoHv1rsjuzOSfmXOVHQf2VnHhhgvR52SdYAfMBxo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed39555-8b31-42d9-1a7b-08d6c26a883e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 12:53:32.6326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5568
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/11/2019 11:51 AM, Herbert Xu wrote:=0A=
> This patch forbids the use of 2-key 3DES (K1 =3D=3D K3) in FIPS mode.=0A=
> =0A=
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
=0A=
Thanks,=0A=
Iulia=0A=
