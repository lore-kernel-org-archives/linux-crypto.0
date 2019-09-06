Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9468BC43140
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 11:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E6EE20854
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 11:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IdvDoxT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfIFLSW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 07:18:22 -0400
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:25134
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726073AbfIFLSW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 07:18:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWroSz7GH792ASO6L+ELn5L9VIHac0ffLFcPKtJnSt2BC9flVdnFZMKnAxBhjWHPGVNJm6wrdda1k0D+sOTWrpaVLm36L2sSemXqKQM7471weWhUcKOR70745w9dZhHbCylgE2yNDT4aG7sAknmuR4gz3nuLn7ahCAMrQopCZ320jMxbtjOgSfYUqo2McnL9vrguHS5b3yYvar9fR9XYEBTC64Aho/Esciw+ejNJ+X0/aiSVT0PNTP3NHcE3mZUFfbh9lZSWKuoiJCUE9lq+4m8OolQ6GUVtGEhF+qETR2UP0dgvRF3yZZMN6yooEVuHWphIxyZSvJqFG4+XdlhAEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InKFfsRalINzXhrZ9l0u41ddhF7WeEyH/qrBTlpVTCU=;
 b=BC05WM92A4RGzLV0bEJ7AM9j+6vvSYbezt4KcXGtoFPWhx+WjjO2ZT/MthSkxOK9LtshFWRbn4FTSpC7EpdpQ61kei0U8gfKzVlUSasBATcUUjI9S4CGXkODbvufVa8rvcfvm5kw95kjXEntbYU9ML88Yqocje+U5ZylVVtIGtUNpImZMSnF6MOoSQ0vD+NqzNQclRS1jD5AuH7Fjva3JlpKXsCvtSaMUhRyqNZghwhjk9H/cClIUj14ct7LmH799Zws4WBbfQO0rxV8lrQWZEkpJBwozGEXSTnwQZUtj4qLwoKLtt0NSX9Hb9J1RATG3Y+iy9fKQaaPcQNKdzJ0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InKFfsRalINzXhrZ9l0u41ddhF7WeEyH/qrBTlpVTCU=;
 b=IdvDoxT/rOJA7l8wpfjZCCB9zAGWnZV1YsUTR7bjCClCIt7CngS9RFwg1oAbNyERgPg2EYBIWT7+Rx6m9fEXaO1W8rLBZuJXIJmxCtA3k4mOyn+eS3qNz9HURjY9RcbFWlsziJYHNFo+rhU7+8wC+NjTfXMZ50RtJ8Dv0kcDoyw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3519.eurprd04.prod.outlook.com (52.134.4.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 6 Sep 2019 11:18:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Fri, 6 Sep 2019
 11:18:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] crypto: caam - make sure clocks are enabled first
Thread-Topic: [PATCH 01/12] crypto: caam - make sure clocks are enabled first
Thread-Index: AQHVYsluURguU4sBokGb803XxaftYQ==
Date:   Fri, 6 Sep 2019 11:18:19 +0000
Message-ID: <VI1PR0402MB3485E5EBBC1DCEF17103964898BA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 084b7520-e1ad-4824-ee48-08d732bbebbd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3519;
x-ms-traffictypediagnostic: VI1PR0402MB3519:|VI1PR0402MB3519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3519E0597847F8B437EDAD3D98BA0@VI1PR0402MB3519.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(189003)(199004)(52536014)(478600001)(229853002)(14454004)(2906002)(6436002)(6116002)(3846002)(91956017)(76116006)(5660300002)(66946007)(66476007)(66556008)(64756008)(66446008)(2501003)(55016002)(7736002)(305945005)(74316002)(25786009)(4326008)(53936002)(9686003)(6246003)(86362001)(8676002)(76176011)(8936002)(81156014)(81166006)(33656002)(316002)(446003)(7696005)(476003)(53546011)(54906003)(102836004)(99286004)(6506007)(186003)(110136005)(44832011)(26005)(486006)(14444005)(256004)(71190400001)(71200400001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3519;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +AnM+KamxhIG6fT3ByjVccbHniTYJ5sP+5n2mxN4tGbM623BAyzxmEXjR2ASimECY1GTkJnPgCqKDdQb4hAWk0jynnSE4DOI9MZnzowZ+Li+kSJfgWCKXnGU2BqwtzqxkR7WdwdPiB+mgC6DJiRZ8dD35DjF48xz/nMoFqyn3XokTC/krk/pgKWnDUsHdTrGikqPVGBFFTGzDLuJ4+KGoqqqPnhHqdUizy9UBtNRclWamoHgIXMYNQG0yMpTK942tUB8DBBgH/3K8UVowTQ2s/Scdhj5V051PZPegLWOCEtcOFwG4OCETgqzKSoty1wpknSac649JvtkYJ4J0CwtKJCWwT/0lnPVRoCqQ2qgXOjXea74rmHLDI2GeeIZiR5prlXZNL5+lQe8OVCoBVuUzwgwRSGfh6g5UZuDO0jYl9o=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084b7520-e1ad-4824-ee48-08d732bbebbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 11:18:19.0581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXRk3dEq3JXWZv3cC5w2RpKmd8Q4hlRzsX8o2BRKSp4V7f6rL84H9puyKJxRgdRu344ssLc5AgQKpzgqct5XCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3519
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> In order to access IP block's registers we need to enable appropriate=0A=
> clocks first, otherwise we are risking hanging the CPU.=0A=
> =0A=
> The problem becomes very apparent when trying to use CAAM driver built=0A=
> as a kernel module. In that case caam_probe() gets called after=0A=
> clk_disable_unused() which means all of the necessary clocks are=0A=
> guaranteed to be disabled.=0A=
> =0A=
> Coincidentally, this change also fixes iomap leak introduced by early=0A=
> return (instead of "goto iounmap_ctrl") in commit=0A=
> 41fc54afae70 ("crypto: caam - simplfy clock initialization")=0A=
> =0A=
> Tested on ZII i.MX6Q+ RDU2=0A=
> =0A=
> Fixes: 176435ad2ac7 ("crypto: caam - defer probing until QMan is availabl=
e")=0A=
> Fixes: 41fc54afae70 ("crypto: caam - simplfy clock initialization")=0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Considering this is a boot hang, in case this does not make into v5.4=0A=
I would appreciate appending:=0A=
Cc: <stable@vger.kernel.org>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
