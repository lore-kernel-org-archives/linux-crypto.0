Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667B4C04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 06:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3318620848
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 06:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CTAbbyiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfEQGLN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 02:11:13 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:39413
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbfEQGLM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 02:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxkJdwOFopavm+ZyUxZ4encVoL+uCEP5Lo0ZQ76BADI=;
 b=CTAbbyiT5cCI7DKkCgtiMtQ4L1KgY8Ev/fJSWcZH0ooXHzdPtAphvbv4q/+6Z+LRGINrlWTYvvf8Ys8TP0d2lsqZTwbieC7m4wsZVh1jpxaqKq096UJp7bb78Po15loXK8d4xiUmyDvbWdpwrHKnn9Nr+JoRAdeQ5pAtG1Slqw0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3373.eurprd04.prod.outlook.com (52.134.1.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Fri, 17 May 2019 06:11:09 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451%3]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 06:11:09 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Thread-Topic: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Thread-Index: AQHVDHdRrXIrKim4f0WfWBBm7eUFjw==
Date:   Fri, 17 May 2019 06:11:09 +0000
Message-ID: <VI1PR0402MB348565B9C2A68E7694B9B041980B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190516142442.32537-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e065a260-9229-4726-cfd5-08d6da8e7498
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3373;
x-ms-traffictypediagnostic: VI1PR0402MB3373:
x-microsoft-antispam-prvs: <VI1PR0402MB3373003954F1BEADDC9AB02D980B0@VI1PR0402MB3373.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(366004)(396003)(189003)(199004)(5660300002)(446003)(74316002)(53546011)(66946007)(66556008)(64756008)(66476007)(486006)(66446008)(76116006)(6436002)(476003)(73956011)(25786009)(33656002)(6506007)(52536014)(2501003)(110136005)(102836004)(66066001)(26005)(186003)(6116002)(229853002)(99286004)(316002)(7696005)(7736002)(86362001)(305945005)(71190400001)(4326008)(53936002)(81166006)(8936002)(3846002)(6246003)(44832011)(68736007)(4744005)(14454004)(55016002)(2906002)(256004)(478600001)(76176011)(9686003)(8676002)(81156014)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3373;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KuyKA0JH6MnfxhOHT2nvMVjeaNWrdujslV3kH+epVwzGsuu+iqeh0WzS4JOfN29S/G7ofW4qDTJ0D2J92gcWvP6/sOaPFq4Se/9kbgrKKeDHLpwES+fcYrCAZ2PrCK5WujHHH38FscXVfN2mNfByDLwPOKnwAOQ9eo1OlcfUlEr+fBgEYZp3kAdFuKosMAbkGwuFtmWjHNshhZp8cgORLp5r+wjsT17PEQIB0x5DlB2U6tYce30DNmxthlHpufk3DCd/HEBkR/0OcoIaMjNM7C8XbPZi7oiCfXO4kg56DFRusFoT8dAwihj6hCBVBrSrNtmY6GNj/cVvfR7Fb5BDw1mgDV9Rrba6+J2Onld+VpRXMdeGeuQ+6gJNG8Vp8mqXP7J/Ij+IEWYzx11yMtQM2CbjCqCiz7+92eLQnQ7jZeM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e065a260-9229-4726-cfd5-08d6da8e7498
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 06:11:09.4797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3373
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/16/2019 5:24 PM, Sascha Hauer wrote:=0A=
> For encryption the destination pointer was still mapped, so the hex dump=
=0A=
> may be wrong. The IV still contained the input IV while printing instead=
=0A=
> of the output IV as intended.=0A=
> =0A=
> For decryption the destination pointer was still mapped, so the hex dump=
=0A=
> may be wrong. The IV dump was correct.=0A=
> =0A=
> Do the hex dumps consistenly after the buffers have been unmapped and=0A=
> in case of IV copied to their final destination.=0A=
> =0A=
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
