Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A4AC76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06812184E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 14:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="s2fl+OUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfGSOtO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 10:49:14 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:8256
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727344AbfGSOtO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 10:49:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dThh2LdDu+nJ2c2EeMf83U3d18B//254WidYKVD9ZTHByQhHfkYtqbRhbuYfju48s5nCRCigI8pVQ7loY6YqPwn+typ/jwyufo28tKyTLEwRqyv1VKEaKhFbNCYOaWjQpgDp1bDnMgTrcnAcWHE9y3ByayJJv7WivCDRztTjXo6ErIjCshHqZGiOceKxA9siczdshcFRQw9bhFRKc81OJU1O3tIqCwj0amM7pjc89JIUgFJxSJm1ECd5q8c+J4GT2xIMWxOJD/zX2Iu76KJ8rGDlQxUffWOHOZ2zzcIsuNIkmf5vnYpRwHrC+Ay+ng5j37R8s4tVUxIr5/QOK1nCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVRMp50eN6RLn0mhZHkhAcl9GTShNbZ0JUcbcwJO7Ts=;
 b=bOw8Lv/gqXEouUW7myyfQkoRSLg/H9NMizJzYxLn3djGmhBVH6u9sZo9qglmoAF6PQN2yzUwfEPEwq9OGvUKq/xaWD//I2wO9PbZgEDPyK1ixc3y1AHuTZTiu6r2haQoqlfEAcaWai+KBIFEGtplHCr+5od8VwU+t6j+IkvGei4Ufv0OkOhUze83yf7BVumY4R9BnbluSH7pEz7ASezxgLnr8E/ZMk5moL40YuAU0uk0hPop3t7MI+8TWwkD8wZkRyBxY7bvfvxMjg4lc0pMaZwD11ChuZXmpvZuNU2QXHNEzbC5hW3DBSfRRZMzqaRowsX1G1LpWbH6NEEWxTDolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVRMp50eN6RLn0mhZHkhAcl9GTShNbZ0JUcbcwJO7Ts=;
 b=s2fl+OUko23BbfngM16irmwZ2rOKAodZOly6iJ1Bb5kESBv6LRCjIsRaVjYDYuaoJ02QKQJBkZtz2QZG9Bh7FhS4wHNhXkQFTAWrOMMQg8LFYMKCgjNqD/YbxtwK9Lo7IOUOTN48B2NVEsM9WWpMAnPNK4/oC82bhHNkoUIddK0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3822.eurprd04.prod.outlook.com (52.134.16.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 14:49:10 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 14:49:10 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 05/14] crypto: caam - check authsize
Thread-Topic: [PATCH v2 05/14] crypto: caam - check authsize
Thread-Index: AQHVPcSqXRMilFpOykej3QzbuducsA==
Date:   Fri, 19 Jul 2019 14:49:10 +0000
Message-ID: <VI1PR0402MB34850B314FCEB1E079F77C8A98CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-6-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 841aac48-7b31-46a5-e49e-08d70c584252
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3822;
x-ms-traffictypediagnostic: VI1PR0402MB3822:
x-microsoft-antispam-prvs: <VI1PR0402MB3822F3726678D3BAAB55746C98CB0@VI1PR0402MB3822.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(199004)(189003)(99286004)(305945005)(25786009)(7696005)(446003)(53936002)(4744005)(6246003)(229853002)(9686003)(76176011)(7736002)(6506007)(55016002)(53546011)(14454004)(74316002)(6636002)(102836004)(6436002)(478600001)(476003)(4326008)(54906003)(110136005)(8676002)(86362001)(33656002)(66446008)(486006)(44832011)(316002)(2906002)(52536014)(3846002)(26005)(71190400001)(66066001)(71200400001)(81156014)(186003)(6116002)(81166006)(68736007)(64756008)(8936002)(66556008)(66476007)(76116006)(66946007)(256004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3822;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U9Ll0qUuM/3O0RD4soqi3ynujjri4b2VhxO1Ez56dqrHTI9AQ2V9MteofB6OldHl8Qd6OuEOZD3M7DwWrPeBceDtXJkp8PFHF4DxX5vzNfGbnFyIiRMOos7VNrTVied7V0z+lNVofRFil68SYbSgBOQsMekqNk29DMHV9+Q6sPOzQ5odi9l0ZmgCd+wXw0D5i+/aDM0rDIwJyHxHDsbbSz/7tHe43V+XD3J6mIliDGALdHiWbGmLkoFIaYPznYMeQy+opQex4cHyDcOC4rik7W6p5SusAaM0hQQbzQWkb2WDkHAy0HSXxwr7SZd1HS1c13+6ie7ZNDIkIF1hAdrjxKFDTD42Zoa3zNMXyA09kxvqaZ+9S+X79XrsnAgh73VnwFC/9/vPKDWfLNfukTDKGaZTMGC+bFweQGxHZVcVfmI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841aac48-7b31-46a5-e49e-08d70c584252
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 14:49:10.4339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3822
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caama=
lg_qi.c=0A=
> index 46097e3..5f9b14a 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi.c=0A=
> @@ -18,6 +18,7 @@=0A=
>  #include "qi.h"=0A=
>  #include "jr.h"=0A=
>  #include "caamalg_desc.h"=0A=
> +#include "common_if.h"=0A=
>  =0A=
This include should have been added previously, in 04/14.=0A=
=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c=0A=
> index da4abf1..0b4de21 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.c=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.c=0A=
> @@ -10,6 +10,7 @@=0A=
>  #include "dpseci_cmd.h"=0A=
>  #include "desc_constr.h"=0A=
>  #include "error.h"=0A=
> +#include "common_if.h"=0A=
Same here, the include should have been added previously, in 04/14.=0A=
=0A=
Horia=0A=
