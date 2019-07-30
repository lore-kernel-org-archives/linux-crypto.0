Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91246C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CD5208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="QNyNYUAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfG3L2f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:28:35 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:3653
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfG3L2f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:28:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjiejT9sblZYsPn3sLL//bBnb+cW21U0J+dvkt98Jp+SKxx30lcAZkAaI7Rs5vMLrlVealIUwZBfm7SsrK/Pk17YU2dTaut5oMamuTCwhmwDx0LLHKHYj5X5yjuvlZUHP60AKshbJx6amt6VR4jpTQ3zQiL9BMNIRcBYxXMAuX5ghRdsRGi7mFd5SE698dKB8lg56g8OZmlpAq8JRJvF1zuPSRlO8kJC/JMbokBuFT8S4jug5UqHyjQw9pAkl2ayUhqEMC49H1GyjN9E5ZMtz0sW90WcT2mQRi3xWsVznd8VD3tda8VSQtSLTQN7zYj+dSaImrEPjDkpzP3h6mTSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH7+hto5oNx3Edv0u4GhSg2J2nCtnUVNPkKFei3R0Dc=;
 b=Yq3yCZ7+BqOz9b7thR1MeJuh2M/KMgpxAUzBlvVE8tPsB7SHc9N5MVe+aiHIz0Tbxl+SIll//YC7dY3a4z4bk9MPTwIri14H025/tVKqzkJnZBWahHuRNZDVOHor+b7WW1/JoJ0hujX/0MXSLzKdwLobntujDzknnuqZ45s2HkN8nBgmrtQBnTX+nf4y2m/prFhuUnJzh2dOAXIamX4ZisMk0yNxQLF4fGx++6aqmZWF0XejqqCvkbJKL5sIEaus8xi1ar2mDbnG1BI0oUFxIdqotUVwcDdvCZda81bBWXaFL/ZZ66Egwjwoms94WxFYAhbKzYyaWuD0RfzwqEvScA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH7+hto5oNx3Edv0u4GhSg2J2nCtnUVNPkKFei3R0Dc=;
 b=QNyNYUAzfm/5ehvVkatqpOPaaNOTK1/vFGoi57mlBT3DRli5OqMndyJqS/BS8melhqspPruuCdSSKVSPQXwLuK600b3yOa9mWh3QEveo2Cpjz53+iW29d4d9VgfKFb8B6EuiHWD5NI7nbhLsbCPZrQSaD/xPNTEztEM6cRlSq4k=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3950.eurprd04.prod.outlook.com (52.134.17.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 11:28:32 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 11:28:31 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: gcm - helper functions for
 assoclen/authsize check
Thread-Topic: [PATCH v2 1/2] crypto: gcm - helper functions for
 assoclen/authsize check
Thread-Index: AQHVRsJGLUqkx7nVhEaXdqs+ZuWJEw==
Date:   Tue, 30 Jul 2019 11:28:31 +0000
Message-ID: <VI1PR0402MB3485C5F4AA9D6C7872E8D92F98DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com>
 <1564482824-26581-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 285b4ef5-8228-45e3-370e-08d714e10d52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3950;
x-ms-traffictypediagnostic: VI1PR0402MB3950:
x-microsoft-antispam-prvs: <VI1PR0402MB39508CEBBA790D9124253EA498DC0@VI1PR0402MB3950.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(199004)(189003)(110136005)(76176011)(3846002)(66446008)(64756008)(76116006)(71200400001)(25786009)(446003)(33656002)(66476007)(66556008)(44832011)(316002)(7696005)(6116002)(26005)(91956017)(486006)(6506007)(53546011)(2906002)(66946007)(71190400001)(229853002)(86362001)(102836004)(99286004)(476003)(8676002)(55016002)(54906003)(478600001)(7736002)(74316002)(558084003)(14454004)(66066001)(53936002)(5660300002)(4326008)(6436002)(81166006)(186003)(68736007)(9686003)(52536014)(6246003)(256004)(8936002)(81156014)(305945005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3950;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lgvj5+eJak+Xbhu4ZQU/sFPQtZpVFbSagbNYdoVpfLnJWwpkz9mCB02S2wANn9Ykb+NLkmr3yINuqVe1ZtKer/PG/DAAgXNXOE00jEDZtnaZfkYIMdrutBS1qr2ew0Ne5F4pyqnZn3PAGm8fnQX7Lzjwfdto7GIi+3RlJ88LHCiTqwn+kbd/h1LmIku6KF8pHuhGwSJ3wCQ0qtYEmqWNGVSHPwPVQrMVmF94VOR3xETEMCpGArsEu7ia9Brz7x4TEBfJgP/c18Q+AEl/8pzUp64Qw1ZCuUzi31SABy3MwDtSuc5fqX1s9h36lRxkubelsrNVQjmvihq+Su6x7E/sP6anqZO8Thip/QmPajvyn70zag/8YwT82mNvhzzJDN+zhjJv56ujgUqm1na6lRGbmPfCE3O/ZhLOoGeLHb9C/FQ=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285b4ef5-8228-45e3-370e-08d714e10d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:28:31.9283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3950
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 1:33 PM, Iuliana Prodan wrote:=0A=
> Added inline helper functions to check authsize and assoclen for=0A=
> gcm, rfc4106 and rfc4543.=0A=
> These are used in the generic implementation of gcm, rfc4106 and=0A=
> rfc4543.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
