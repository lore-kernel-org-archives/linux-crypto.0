Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E1CC4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16666208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Uzmdl41d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403838AbfITP30 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:29:26 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:48389
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403797AbfITP30 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 11:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itEbbi+ZH9U3U4rkxjh5nYl9fGiqIo2OjtrxAvICjzvU7gkKpqMOiJaQQbCJKZaYOuBC2JY3Wn1Q2pPUwcLFVpvqELVQUbvhIATD0NsoW5308vjUvRNqp/d+DyyaXGK9hojhvbu6E+GHlmpHvbaliftldx0LIU363Q3bRWAxnAAywL2tLF+6o0nx5izjba+3MUgTIWiEX2YNeUSSB9pEZ5sqAvh3Wg310dlwiUBhCOndrmArkxtx7gV+30QHwBfe6I7MyRaBSTfRxisFSUYcSzXYtAqPcXQLSH75yxA7Whzjct1xURDxHnXvD6ASZg58Q/lLiojB9S1djBlTyaOjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJrwUAbeAFs3mHu9OZIX2w/NfC5NUpvuB0x/SsMy+Z0=;
 b=e64ZJ7MPFunyyWxhH0DxdpPl60j/ouh/KXRO3PIEiVBuDEC9PbD4LKrkEHFDFp8T1sASesC6id/Zh6rkJ28d8HS/OPtc+xan+rHr8kgvS9WVQM6bdnITw41nDsZLrVkQQ3ALmV5RHv0pblGyS6x7BOfnuxIFRYp2f/dvSGDnJvhs50MRga+rgBW2Iu5rUbfHLnrMRVAvd/CDoIJplH+1BLvpA25Mbc19Hr4iCbto4FhUYTrflkPR5Rs6A+OgNhJWzBGEh78uzas2mVrYR8ITKnDt0yctXaeioykBeNQVQk6Mw4thIHF2a1xOButHLATll4joH4IpkkoO8gJWuWVbOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJrwUAbeAFs3mHu9OZIX2w/NfC5NUpvuB0x/SsMy+Z0=;
 b=Uzmdl41dV0qJD49ziNEhcW3nUYemW/L6DgfDg5znUuUIHE69ELHpxpOCjsz1XfG+wiUJBE98Eys2UY7EKgpMWhPCNqXjORCyq0W3DAF/Mnu8qKvblbGzJ/VhR4jaIoKCDqZyBkPpykqYUwEFLlqYurTfKEeAu3NP0rR5rEu/URo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3792.eurprd04.prod.outlook.com (52.134.16.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Fri, 20 Sep 2019 15:29:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196%7]) with mapi id 15.20.2263.023; Fri, 20 Sep 2019
 15:29:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/12] crypto: caam - user devres to populate platform
 devices
Thread-Topic: [PATCH 09/12] crypto: caam - user devres to populate platform
 devices
Thread-Index: AQHVYsl0CvYDdvisv0CEeYmaejaS7Q==
Date:   Fri, 20 Sep 2019 15:29:22 +0000
Message-ID: <VI1PR0402MB34855628A0B4F5D70368A6AD98880@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-10-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34b2c8b4-3dde-45e5-d9d8-08d73ddf5065
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3792;
x-ms-traffictypediagnostic: VI1PR0402MB3792:|VI1PR0402MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37921F340F106D285C7526F598880@VI1PR0402MB3792.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(199004)(189003)(110136005)(305945005)(74316002)(71200400001)(71190400001)(66066001)(316002)(186003)(26005)(4326008)(7736002)(102836004)(256004)(6506007)(66476007)(53546011)(66446008)(66556008)(64756008)(25786009)(66946007)(76176011)(9686003)(6246003)(7696005)(99286004)(76116006)(55016002)(478600001)(6436002)(2501003)(81156014)(486006)(86362001)(2906002)(91956017)(14454004)(33656002)(8936002)(8676002)(81166006)(52536014)(476003)(229853002)(54906003)(3846002)(5660300002)(44832011)(4744005)(446003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3792;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P770HIH4md0mNX/a4T6IUnKRtpW4ljlwDAH19WXIu1qh+DepZvIZN1yFr+GomxiaGVf3QRNRa5f1bjvf5cCW6dp7C4YGIjSAy9k83lcrR9p9+IXCvh4Y8+HPjHMkghECOJTfMum/IG29Zp4NW0v4coFEUI3ELz3Qae9PiyHyvxyBK8HdfC9O1bVc/RlGTPq3BEzHcDIjnNY7F7J/c6FJlMGn7CLuAWQXuq1kHF45rNaaUIM0SGD2DnlRLrQ4xef+spTfD6XDpz6XgVPRHlnyF9fScOIgGjaDoTt7+F7g1liNXUT3IWIuJqIsLPv3O1xA9tpVSQDibyLU/faBJ2nzAxy89EaRdbYXTAO9IC8domMRsedmpe58k4uFsDO/AET5do0YO94+OcFS/mRRDqUf9iBKklExBn44xYZ47QBfLZg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b2c8b4-3dde-45e5-d9d8-08d73ddf5065
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:29:22.9629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cyOl9GbG7m4041DDpR03xmlFWzOzGkoKF0L4EcZySgH62f50X9bFY8ll9P2wEfhVOw91B4z4+nnN0zm8CXQu/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3792
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> Use devres to de-initialize the RNG and drop explicit de-initialization=
=0A=
> code in caam_remove().=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
