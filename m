Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6846C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A0620873
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="dy6XE5ef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEOOAm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 10:00:42 -0400
Received: from mail-eopbgr10051.outbound.protection.outlook.com ([40.107.1.51]:23205
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726834AbfEOOAm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 10:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJh/8vQoHaVocWkVoibMP2JxnCvIFr4nQtQKT8JoNMs=;
 b=dy6XE5ef7GQNuMSDMsmKhRnsGOtk431QfTHJKGibw27HWkKFYXO3IFlcgrHSZejKlPtxl3BT3oWV/VZUl44gYLMak5b2WCVroF0tbPmcIGdYHwOSpdd1ZWxpJ9y9pcowyA1Cxv/Y4mg6kM8iBsjnGt84tVt3h+HkWA/tu+mMTC0=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5262.eurprd04.prod.outlook.com (20.177.51.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 14:00:38 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872%7]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 14:00:38 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 2/2] crypto: caam - strip input without changing crypto
 request
Thread-Topic: [PATCH v2 2/2] crypto: caam - strip input without changing
 crypto request
Thread-Index: AQHVCxD1rkBi6ZHI30+wWLoL2LqnOQ==
Date:   Wed, 15 May 2019 14:00:38 +0000
Message-ID: <VI1PR04MB4445FB86FB1FF3EA412241E48C090@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
 <1557919546-360-2-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB348547115B62EB41C7DC2D8798090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91d19de9-c57e-46c2-54cb-08d6d93db5f0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5262;
x-ms-traffictypediagnostic: VI1PR04MB5262:
x-microsoft-antispam-prvs: <VI1PR04MB526255317B05A8724B9AEC1B8C090@VI1PR04MB5262.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(376002)(39860400002)(136003)(396003)(199004)(189003)(76176011)(446003)(486006)(6116002)(3846002)(4744005)(8676002)(9686003)(44832011)(5660300002)(2906002)(25786009)(55016002)(71190400001)(6506007)(53546011)(52536014)(71200400001)(110136005)(86362001)(14444005)(256004)(99286004)(476003)(7696005)(8936002)(54906003)(66066001)(186003)(4326008)(6246003)(478600001)(68736007)(102836004)(73956011)(26005)(64756008)(66556008)(66476007)(33656002)(66946007)(76116006)(305945005)(66446008)(7736002)(74316002)(53936002)(14454004)(81166006)(81156014)(316002)(6436002)(6636002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5262;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4rxnZ+dDmFVS1FbWt3LkuXe5otmZylj1D4uiVshgxqdwBo31JgVE/liJwPOHeLpXXVz1SlWsfOCCqJjAfL3M91S/LPnj9lx/VRdc6CHyoKSWilI7H8rvtMDSKq5H2T7NVYkDEbtiqKkTrd1kDMWRwRiYt8k2bvqmWaG0lFDupQoUj+Wrp02oQRVAgCU3Qe6rRBlY8Jm3Aqcw3J61TYqCkY0JUX/RLp2LvYkTyZk+c6hi9CyGzNHGJF3Dk0Sr/zVjhej92NldQx5vhZf9UKfSNuL8PodkiAXl7XdqeHIZXBW/oXM9lYyGGPT+E5bEVC8zSINnaCj/k7H80wH4/k7vPwqbpJYMTiKpv+qvQFyhagKSaIsoT453BnEOUcwS54xHeZno4r7ZGbp1++9wmwpAKclk3N6dMpzI5gpQt+PKCkk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d19de9-c57e-46c2-54cb-08d6d93db5f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 14:00:38.7213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5262
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 3:59 PM, Horia Geanta wrote:=0A=
> On 5/15/2019 2:25 PM, Iuliana Prodan wrote:=0A=
>> For rsa/pkcs1pad(rsa-caam, sha256), CAAM expects an input of modulus siz=
e.=0A=
> Only for sha256?=0A=
No, is not just sha256. Is a combination of rsa-caam and a hash =0A=
algorithm. I'll send a new version to fix the commit message.=0A=
> =0A=
>> For this we strip the leading zeros in case the size is more than modulu=
s.=0A=
>> This commit avoids modifying the crypto request while striping zeros fro=
m=0A=
>                                                          ^^^ stripping=0A=
> =0A=
> Horia=0A=
> =0A=
=0A=
