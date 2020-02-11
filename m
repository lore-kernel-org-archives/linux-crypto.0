Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9054C352A3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 10:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDC320714
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 10:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FYr4WAkg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgBKKXU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:23:20 -0500
Received: from mail-vi1eur05on2049.outbound.protection.outlook.com ([40.107.21.49]:6250
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgBKKXT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 05:23:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEd2NuYHC+Q6dIe1elHQ9Z0BYf7jUJ9OGxdlq3OqQEqO6oYTZAB/apjSR0mtznnHPCfseMeDao3YLO9EniOb3gTp4UzrbYj6JDQY/v5J8UdlEey5Tw5HhdmIzaQN/ORSHEA2PpH4/n2QerHpPhXKtsTyyGRcfVr4ZtkEBj/dE9I7zJgWyOkFeCun9/2dE0L1ErCjvUrT/wsgyCMaktXxBxIsdJYdd1XSLiJfKEEX1AGDlK9o/8bobTrEsgACdVfyxWaIO7kLicu/NCOdrDO893OmtmIDKE7JO08y0qDoXGCe1QUp8g327tpS1pMwcml/TzOdI7gAisfhDwOfWVXVug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j2Nc+pznExCtiV4UhEtGNKv5B4VM3THBdI84mcmTjY=;
 b=oWga5jLiXJQItvxBiBucaa7VbEwujpVnISWn94Xvd+jOS3Cbazf7Q0oCMWrHZ9yDNdl9yf2tXzte8fesbQN7sWinElVQ65DyBpFpVF/LpZ23jc+V5cWKVyjPp93Uq7/hfVwaQHq4G7FYI/jbuJdBwHVAXNqtlfdGUERfWsFniQIvJkQUGi806q/ZrQAaGBsPnBSZ5wksnnGtLzqRYuCVeT3jkWS27nZYOH/o80/ozYCDeTQ7ovRFKJ8BTZ+cKbk2lIGg9XG+MCGJlerhoQruzT+fh4/9g8iuPULDtMzGX1r1GUKaG+NmCa8nYW6Ftg4tK0hw2MXlKJJTEm+jM571Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j2Nc+pznExCtiV4UhEtGNKv5B4VM3THBdI84mcmTjY=;
 b=FYr4WAkg5kDpu/VDTTBHACF+xhZ0QaFy4meEffz1ciF8thD4Q2mYdWSyAzn5wiS7IWqawtQjgtB26t5So1gG2FUWVVXl7cEr5z62mHXHZ3GUbjWfd52ZOBXoLFX+JksTAEkxE6JTDkWGZHuwh6bfV9tLGvjUNW3jZIrbmJP108Q=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3327.eurprd04.prod.outlook.com (52.134.1.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 10:23:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 10:23:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v5 8/9] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Topic: [PATCH v5 8/9] crypto: caam - add crypto_engine support for RSA
 algorithms
Thread-Index: AQHV1wcsXP+aUn5J/EewRx4lhuSAGQ==
Date:   Tue, 11 Feb 2020 10:23:16 +0000
Message-ID: <VI1PR0402MB34854BA34A65EE7131F3831198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1580345364-7606-1-git-send-email-iuliana.prodan@nxp.com>
 <1580345364-7606-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0784ff92-c0e7-4d50-4948-08d7aedc6894
x-ms-traffictypediagnostic: VI1PR0402MB3327:|VI1PR0402MB3327:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3327F3A3844C5562C53E7AAE98180@VI1PR0402MB3327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0310C78181
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(189003)(199004)(44832011)(6506007)(86362001)(9686003)(8936002)(55016002)(5660300002)(7696005)(4326008)(66476007)(64756008)(91956017)(66446008)(66556008)(76116006)(66946007)(53546011)(316002)(26005)(54906003)(52536014)(2906002)(478600001)(4744005)(33656002)(186003)(6636002)(8676002)(81156014)(71200400001)(110136005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3327;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 63aS5UlIRIna2Eoe5p0+zCv4U8FmdCtbKDyh0f0sXQNtl2zET9/P0heFtm9syy7ymnxUq/1JrWOD6OSpoth6tgwhft/y7PCiGJwsiU6udqra4WA0sZFNwIXrE+u55O/k4FbscGGhrmxR1fTaeIdOUCEboYjo00X2ePa97k12mWjjYTdvo7yuYph3oAld0t2qs20yOyNPwOrY/SDUjtGDDam/sSw2Swdf7DegZ4hKujSpinsj39fn3iDAnei3a5sQbV3yquczZuR4r7u3OeFP83rflcTkdM6itbBqKTSuAYfhNIMwf6KfCrCrYSfy654E5269kwO2JWe4kqA3fem5z7h+iiAE4P+9/a0wx91Xy73BrIgaMwsK9g4qETvLZozeeJn36bZhlUAzrFuEphhiLUJ6ExzBTd0gtUTb5gD98H+5ONRCy9n1ifOBoIFkLguI
x-ms-exchange-antispam-messagedata: xS0aArJgMT32nxaPCde/wTBqNWhguHFMaprvFJmquSpSxrvfsVZfiAXY4TuC6BJdK2b2VAxs4uyUzvyZDB/uOVhLRJyVB3dxwjcmF2vp+iAHrtrPWRD/Hx6CuerE5duzUeBA/s6qSvzVuE8WpyWfcQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0784ff92-c0e7-4d50-4948-08d7aedc6894
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2020 10:23:16.5711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3PhaAeL89NzOzC7NyVsoIcEFHc8EH63FDMaa1gTaBqYtywSZJ13xAO4WTt6G7VLMu0g2wEWZyd+bplzMY9xTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3327
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/30/2020 2:49 AM, Iuliana Prodan wrote:=0A=
> @@ -1029,6 +1107,10 @@ static int caam_rsa_init_tfm(struct crypto_akciphe=
r *tfm)=0A=
>  		return -ENOMEM;=0A=
>  	}=0A=
>  =0A=
> +	ctx->enginectx.op.do_one_request =3D akcipher_do_one_req;=0A=
> +=0A=
> +	akcipher_set_reqsize(tfm, sizeof(struct caam_rsa_req_ctx));=0A=
This is redundant with the static initialization of caam_rsa:=0A=
	.reqsize =3D sizeof(struct caam_rsa_req_ctx),=0A=
=0A=
Horia=0A=
