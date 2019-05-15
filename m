Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678CAC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF452084E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="C6MlpCQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfEOMpg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 08:45:36 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:8260
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfEOMpg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 08:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vjulWNtFIuDzzZVLB3YmibWuEZ93u2o20N7TkbUFrI=;
 b=C6MlpCQK0Iisv09AcfN36zfMyjdZL4TvMbwhtXMuiq8NIfAwq0C2qlxqBvI850YmhrD3tbwDpydzikblt5zecYbo+Lbl5a4PbSk/6Ki5HfxcaCcoQakMYpnJIk0vvFI0oNEEY/UcQ1Fh8+Jl0P8BkRKMmaUgSBtd0RiE7Nu//JI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2896.eurprd04.prod.outlook.com (10.175.24.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 12:45:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 12:45:32 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Topic: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Thread-Index: AQHVCxD13Q1EOIwSiEGsSCDp99Uy8Q==
Date:   Wed, 15 May 2019 12:45:32 +0000
Message-ID: <VI1PR0402MB348554352CD4DF0A451A5CBC98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fce0594e-26df-43c3-1075-08d6d93337f7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2896;
x-ms-traffictypediagnostic: VI1PR0402MB2896:
x-microsoft-antispam-prvs: <VI1PR0402MB289666C30C360F65D56A43B198090@VI1PR0402MB2896.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(366004)(136003)(376002)(189003)(199004)(8936002)(256004)(81156014)(6116002)(33656002)(2906002)(66476007)(86362001)(68736007)(8676002)(3846002)(66066001)(76116006)(73956011)(71200400001)(71190400001)(66946007)(66556008)(64756008)(66446008)(53936002)(102836004)(26005)(9686003)(52536014)(6246003)(186003)(99286004)(81166006)(5660300002)(53546011)(6506007)(7696005)(76176011)(55016002)(74316002)(476003)(6436002)(4326008)(305945005)(6636002)(44832011)(14454004)(7736002)(229853002)(446003)(478600001)(486006)(25786009)(4744005)(316002)(110136005)(54906003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2896;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DcDUpBmAazVTfpJFjmckR6N/61PsPr/3XlRDsfVnDVVEkPs3+wC+vnHr6I8z7tBdRtu2bVNhn/pOXntMB9NyS8DRchwrZdRFXyDnuwPkGaPL3M9f/eNulBIXV67E7Kh1mEcU2AqOjvz2e6zyJ1Fldn9AsWPM89P5eExPSJqfJPvwi8mlbDo6oqRYDmnvMWfn8DC37uC9xhqmN1niCgU1AF7gl6vUFDbC109VA0/FgC6QJmWYfWH28OhsgBecIMqGaO2NGynjuOkv8LIESkhoHmHMfN+tHV7prdHBMpktGBQXiERHw7CqudzNgpPsu6VV6rGQi8PX/XjBQ2epvXCDpNuk0QtNfYzyWqarOm3mMrUWKAh/4TwXyoaIhfpTbu95Qflvaob5KarQChQ9fTN6SBEMs/z82xQRWQArQkMpOmk=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce0594e-26df-43c3-1075-08d6d93337f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 12:45:32.3130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2896
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 2:25 PM, Iuliana Prodan wrote:=0A=
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
