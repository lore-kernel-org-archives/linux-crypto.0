Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FDDC04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4349721019
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NBX67nQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfEUOYA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 10:24:00 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:50446
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728176AbfEUOYA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 10:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqTKAsa+8YAqW1DnFUInjSXfYGq2Sc9h3cbVOw2ypS4=;
 b=NBX67nQ+Otz7iG2i6GWvH/W3ZxUEUDtUQTwHbloQoS7k4mvge7d3CBdgOGFhkFKAGP0XVij+lejdcSLeBBa64Q3sUvEkE07QNfpbFtQD4G92LcchcsJglMHcauWHQuPRHXAuSYBTHkEfr9fxeAunNbmUPIEHEyIokMDx2qOpA5s=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3694.eurprd04.prod.outlook.com (52.134.15.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 21 May 2019 14:23:56 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451%3]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 14:23:56 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] crypto: caam: remove unused defines
Thread-Topic: [PATCH 1/3] crypto: caam: remove unused defines
Thread-Index: AQHVDJL9WaSBuCaA8Eu0E3uoeJxsJA==
Date:   Tue, 21 May 2019 14:23:56 +0000
Message-ID: <VI1PR0402MB34853790FF4329B3E79ACF2E98070@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
 <20190517092905.1264-2-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0651ae8e-05a3-4024-f9c2-08d6ddf7f549
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3694;
x-ms-traffictypediagnostic: VI1PR0402MB3694:
x-microsoft-antispam-prvs: <VI1PR0402MB3694375A238C05ECF7C5B08298070@VI1PR0402MB3694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(136003)(366004)(396003)(199004)(189003)(71190400001)(7696005)(2501003)(5660300002)(76176011)(81166006)(81156014)(446003)(478600001)(71200400001)(99286004)(66476007)(66556008)(76116006)(66446008)(64756008)(73956011)(66946007)(102836004)(53546011)(86362001)(6506007)(6116002)(486006)(25786009)(66066001)(44832011)(316002)(476003)(68736007)(305945005)(9686003)(14454004)(53936002)(3846002)(4326008)(26005)(74316002)(55016002)(2906002)(8936002)(558084003)(7736002)(186003)(6436002)(52536014)(8676002)(229853002)(110136005)(256004)(6246003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3694;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bJdicIGTby/DarvrdWiemvtW0BG9Y9Ef+GMB6Q4q8Zmh8Lp2XZfAS36f9Bwlrrc1nJQmKJvOoN16zOb/yZ8dDOzsadU/LyqmBT5XzoHOrZRxocL38Og2+VFKOUkB9WntkdY0DcmDtwaaYpiKquZjKDo8JylxawgtVls73/3e5enlRxejwYL31+3jE3HJ4AU0ig0a3QFX4Xj1kncFAk0Qv3Mb8AmVUPMpCGJ/wuu54KpM56EeGLonQF5A/iUNHP+jv1hFTInwTdQzyO9dcWyZY7vIizdtr3RG54DyafaYJ1ivVa7wByxhFt/hus2oVJcOzkbe4AgjL5SRJ9Nq0eSgbbn8soK4/5w6tHBdsEHhdYiivOL7Jg3gnQpsUrmj/IPK++ceqjKDYaUDtsNCg0Hv+Ju8DaMvlsnwTKo6PW/Caws=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0651ae8e-05a3-4024-f9c2-08d6ddf7f549
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 14:23:56.0341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3694
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/17/2019 12:29 PM, Sascha Hauer wrote:=0A=
> The CAAM driver defines its own debug() macro, but it is unused. Remove=
=0A=
> it.=0A=
> =0A=
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
