Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4B7C072B1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 08:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2355220883
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 08:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Nv9/uVBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfE1IUe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 04:20:34 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:43398
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbfE1IUd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 04:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TylURNC/HEKHBhkttdDRp+LsGMfvjUcou9kPlsazCXA=;
 b=Nv9/uVBdiQWw0Mq6JNVUTe02mn5pM5nfCK5MAG2qLi8R1R8ckGI6oJPqEWJmdwSU1inRXvOfxKl12UgHSpBKJzPgROpZRbiT1xz2NJKr0+bhRxIY2dZ5cfurijS6mrPYBdg8MvRdSPVcTCV6vUs99qXS/RTEm2NjBMw6uZHJTHQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3840.eurprd04.prod.outlook.com (52.134.16.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.21; Tue, 28 May 2019 08:20:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 08:20:29 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v1 08/15] crypto: talitos - Do not modify req->cryptlen on
 decryption.
Thread-Topic: [PATCH v1 08/15] crypto: talitos - Do not modify req->cryptlen
 on decryption.
Thread-Index: AQHVD9njMUF7ft0BM0m68K66eI1bNg==
Date:   Tue, 28 May 2019 08:20:29 +0000
Message-ID: <VI1PR0402MB348519D7E3927482A894F276981E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
 <1ad8020c8140da1b4f818220e130ed0074c37fe1.1558445259.git.christophe.leroy@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a44333a3-2280-4130-f9d1-08d6e345589d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3840;
x-ms-traffictypediagnostic: VI1PR0402MB3840:
x-microsoft-antispam-prvs: <VI1PR0402MB3840AF6B069EDCD443373728981E0@VI1PR0402MB3840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39860400002)(376002)(136003)(199004)(189003)(26005)(81166006)(81156014)(102836004)(186003)(53546011)(8676002)(25786009)(6506007)(76176011)(2906002)(8936002)(99286004)(68736007)(14454004)(33656002)(86362001)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(478600001)(76116006)(305945005)(7696005)(7736002)(71190400001)(6246003)(71200400001)(52536014)(44832011)(486006)(66066001)(9686003)(476003)(55016002)(3846002)(5660300002)(54906003)(53936002)(256004)(6116002)(446003)(4326008)(229853002)(110136005)(6436002)(4744005)(316002)(74316002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3840;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5JioKxmm9amMVF/gnfjA9MsdG+UNzUKciWYpfmj6xh3iWPC7RNY1pUIasEvjllxIdc/22QmPtIoBga2t0NxI51gMRMktN1TTfEXfb1qy4MggBT7CCYJwN2t1kX2/D40TEYUv2fxEVcQu3bys5BvAMzFv+nkNJuzXUIlrPH72KZtEMwyt5aqj/Yvjq/wFEyKxBOiGMSTv54EB2imu8cFDUJ16Se0vgJzjMIA5uJwjK4xlyXqebgYNEccNvga0qm3dwteeT40e+jxfvD2Eofs+KkggFjO07JXx3horNLE0I4jvAn2HgLj/BOQu06cV1Nm7LjMqAKVoFg8e+4uPXBxs0JXrtPrc7SGFrMIJuNHhgw/tQ3Oa04BK5wLJyp0fF6Wp422EjVil+31S58RHPZKjGhBbD90fNN30+y241nKGxuI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44333a3-2280-4130-f9d1-08d6e345589d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 08:20:29.7800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/21/2019 4:34 PM, Christophe Leroy wrote:=0A=
> For decrypt, req->cryptlen includes the size of the authentication=0A=
> part while all functions of the driver expect cryptlen to be=0A=
> the size of the encrypted data.=0A=
> =0A=
> As it is not expected to change req->cryptlen, this patch=0A=
> implements local calculation of cryptlen.=0A=
> =0A=
An alternative would be to restore req->cryptlen in the *_done() callback.=
=0A=
It would be easier to implement, though probably less intuitive.=0A=
=0A=
Horia=0A=
