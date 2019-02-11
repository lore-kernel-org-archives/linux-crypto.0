Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CCDC282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 15:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 432A2222A7
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 15:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kyMaqRpt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfBKPNm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:13:42 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:11136
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730200AbfBKPNl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 10:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMcSFShBSMAcBZbVB2x5xJC6GmiwJRDey2MxNfp3wNI=;
 b=kyMaqRptKtdFoz2rWgeK1WSEW/Q1Bup++7JmvrDj8fs3D3rwamZS17XAeroTvCpFBLv6+eaDp0a2UYao73fbn5crndFftZ3oJP+fC/uVY/gnU8SlktpHO+dgNGO0plOZkRJk2iluTB9CPaM8wjAabxOVFD9R3kdzxgvarWQMMqQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3709.eurprd04.prod.outlook.com (52.134.15.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Mon, 11 Feb 2019 15:13:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1601.023; Mon, 11 Feb 2019
 15:13:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Thread-Topic: [PATCH] crypto: caam - Do not overwrite IV
Thread-Index: AQHUuSvyCmTFYLEeOE2P2XtmnR+/Zg==
Date:   Mon, 11 Feb 2019 15:13:37 +0000
Message-ID: <VI1PR0402MB34851754919DFF6FD0FDA57D98640@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au>
 <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208114532.5yznhgeq6m6gh5fo@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3709;6:pttTr26xMt5MDndcvveXL1acvElvHO950EG+vQD8ZVSwp6EfgOguUuc3YA8CMeEFXkMv3wSn+v1JGXYelI3MCVCWAq2X9qDOi6dGi7xOw/C2CPGvIpzKQrdk7+3Xct5okWVsnM68JJwEaCeWVSqrtjC0Pf89RmNSfwc2/3fPFDCIpOnciRj6pSrznN2kZnnDQSlV8BO0TjjdkJBaU2u9jUZK41v7JvEBv9mdx043URYs8iSKBs8L/S4DmWvyKXk1Bbxp6cmAEPlh6XJAEamCzABNGbk4ZhqZ6HT6vlY+PAUvSYtER5PoLKOWHp43XlyI6Ybqc56aK+xQgFQZ30P9WbhJYp9OdA8DaVJyKSJkzL2BzcuENlU1ZU0DdzMXY3anvw24GSF3c0Qt2bwTmNpVNNHvFLM5b1w/dK6yj3mv1Hm4wlLCs6A/XcUja1A6JCF0jPAgAXhpuCtCzLB4S0D8/Q==;5:pm1ZplQXdpCUioOF9FKh1HSlEOTF5OvvoS1pWDHx7zwjjYNjLLxi+jx/HWZRsLmWgp46Z9Vrn4yj1WIO8eHg9iix/l4Jf0waDwRhWzkVu3vsrQgFTgiXyVzjxaa0WCGRN+e6KUAmlijf/BwT7GD/BuBagS23A9c2H1QfxY4e9wgrADwkPVg7JZ6O/GO0oFcqxsv+sJtEBb5HVdyRJ3awbg==;7:M1vN9aY9gt78ehuSKPier2iU3HNIdL2mq2NR2jUSCgR+XkcaDblBGcdgrk3rlCy9yDJ9bWICxTKSBzujsii1zmi6hWBc1LFRU9y24Hdxwh/LqVhdMtf2NfrE3+eSeiQTnzK65thUXkBy2C7T6X7yjw==
x-ms-office365-filtering-correlation-id: c13b8acc-8eef-49a9-bf9a-08d690337f85
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3709;
x-ms-traffictypediagnostic: VI1PR0402MB3709:
x-microsoft-antispam-prvs: <VI1PR0402MB3709CBD422C845D826EB57DA98640@VI1PR0402MB3709.eurprd04.prod.outlook.com>
x-forefront-prvs: 0945B0CC72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(346002)(376002)(396003)(189003)(199004)(66066001)(81166006)(81156014)(8936002)(256004)(14454004)(53936002)(8676002)(93886005)(6246003)(68736007)(55016002)(9686003)(6436002)(229853002)(7736002)(97736004)(102836004)(33656002)(305945005)(71190400001)(2906002)(71200400001)(478600001)(74316002)(76176011)(44832011)(186003)(316002)(99286004)(86362001)(54906003)(476003)(53546011)(6506007)(446003)(105586002)(106356001)(25786009)(4326008)(3846002)(486006)(26005)(6116002)(6916009)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3709;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EX5OyJt9uTAWmKMVHdscj+Fe4W0xd+01WqIXeogLeoG8xOhMvs0rz6HR4J/eJS6BUX/n0fBc25EXXrSkJoiZ8Opc6z3Y8Uen+IBmD/WL4poWNcRZvFjYNGZ3gugXdb2L9D9NhzrMUUCFswWsD0vFcZGOKmCcVCvsjZ1yEjVIQpjxKPovlPTnDIrT7uYgPYo6AwsLwzJ8xkfdZbJ2VPFgpRoG6msuPcPTyC10funSb9iuEkdZpKIl4ov2IHTCGv9S2j1U5vKFfoLkQGw+KlOFZQVqjOLR8O9HIpz1SCAazFdBa1wsJA7UGXBbGY7w2nmyYlqRja8MVa2Yt+W/+xVuJugHPLbzj+HQVR91p3k3+nlzVNYvPyx7ENv3VKYlaTHFE9TyLSstuY66kMQHlixWNCX3AAVVblj+uHc96Rq9n40=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13b8acc-8eef-49a9-bf9a-08d690337f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2019 15:13:37.6427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/8/2019 1:45 PM, Herbert Xu wrote:=0A=
> On Fri, Feb 08, 2019 at 08:41:37AM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> So if there is a real intention to support offloading skcipher, as this =
old=0A=
>> commit suggests:=0A=
>>=0A=
>> 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")=0A=
>>     This patch adds the necessary changes for GCM to be used with async=
=0A=
>>     ciphers.  This would allow it to be used with hardware devices that=
=0A=
>>     support CTR.=0A=
>>=0A=
>> then we must take special care when building skcipher req->src and avoid=
 having=0A=
>> it's first entry (auth_tag[16] in crypto_gcm_req_priv_ctx structure) sha=
ring a=0A=
>> cache line with req->iv.=0A=
> =0A=
> Could you prepare a patch for this?=0A=
> =0A=
Yes, will do.=0A=
=0A=
Note that I am seeing the same issue on CCM.=0A=
=0A=
Also for GCM, besides auth_tag there is iauth_tag[16] buffer that is added =
in a=0A=
1-entry S/G in gcm_hash_len():=0A=
	sg_init_one(&pctx->sg, pctx->iauth_tag, 16);=0A=
=0A=
It looks like there other places where this happens, for e.g. "tail" member=
 of=0A=
poly_req (crypto/cacha20poly1305.c) in poly_tail():=0A=
	sg_set_buf(preq->src, &preq->tail, sizeof(preq->tail));=0A=
=0A=
Thanks,=0A=
Horia=0A=
