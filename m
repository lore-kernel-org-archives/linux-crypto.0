Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D650C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A7262082E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UcSpGx1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfEOM7y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 08:59:54 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:10702
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfEOM7y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 08:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYIOyoQvsGi1rTW4VytLfFUdSZgKechJQIZAz1twH5o=;
 b=UcSpGx1MR+m6iSHR4DhJ/4BgndAFbfpYgv0Dc8PbgGFGcDCcJKkzclS7XWG+7VP1teMN3unYJuJoEsD8ueiZ3E/qipsLn1eR56j/1Qvc+q44nQjgWbKWUNTuClh27go0kxhJBR5fQ+rL3URA5ReRuTo4xpfukEs4/EliFoikpFA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3424.eurprd04.prod.outlook.com (52.134.3.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 12:59:50 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 12:59:50 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
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
Thread-Index: AQHVCxD1jRNmo1IFzU+WL1DE3FYP4A==
Date:   Wed, 15 May 2019 12:59:49 +0000
Message-ID: <VI1PR0402MB348547115B62EB41C7DC2D8798090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
 <1557919546-360-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b775a9b5-b92e-4016-cc54-08d6d9353714
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3424;
x-ms-traffictypediagnostic: VI1PR0402MB3424:
x-microsoft-antispam-prvs: <VI1PR0402MB3424F035E5B044CAA42BB42898090@VI1PR0402MB3424.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(4326008)(71200400001)(6436002)(71190400001)(102836004)(76116006)(53936002)(25786009)(81156014)(86362001)(5660300002)(4744005)(6116002)(6636002)(44832011)(81166006)(14444005)(256004)(3846002)(33656002)(8936002)(7696005)(66066001)(229853002)(8676002)(446003)(110136005)(476003)(486006)(478600001)(68736007)(74316002)(52536014)(7736002)(305945005)(316002)(2906002)(99286004)(9686003)(53546011)(6506007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(55016002)(186003)(26005)(6246003)(14454004)(76176011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3424;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: plYG3jG2CPSm+ij9wGdqnc4NvBwRGlQe7jatUsV6Mg+W9L4SLyNB2ywDFTolrCx3AM1M8w6uFZsZb0Et607D5lUDzkydrusJzR5jdBsmYLCognUkcUio+Pbfe9u18gaM3jG43fj6YULyRi1B311R5l2bG2sUogwE+B/oZDakH3J6F2OSoTEDbXn5+MgRUUx+LmT1bqIzXveqOkOz/RPugfIOLFzCFk26vL7qsuKluJT+n0hH/i5fYY69NuFIKBzjg2+1Es8ATjAwrcKQTM7XX0h7ST4IYL/7LZP4wmPEALC3xrmXrqu1QplvaonwU+ChBYpXKAq4UDFDxL92086F39rHVnCWnGDIfRRsUA3lxTbCuiyR2HikQW6W9x+KaJMeI6K50fabwNNvE2iZLA0Gw8chDDRt4HP78vlPxFmn6ls=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b775a9b5-b92e-4016-cc54-08d6d9353714
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 12:59:49.8846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3424
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 2:25 PM, Iuliana Prodan wrote:=0A=
> For rsa/pkcs1pad(rsa-caam, sha256), CAAM expects an input of modulus size=
.=0A=
Only for sha256?=0A=
=0A=
> For this we strip the leading zeros in case the size is more than modulus=
.=0A=
> This commit avoids modifying the crypto request while striping zeros from=
=0A=
                                                        ^^^ stripping=0A=
=0A=
Horia=0A=
