Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F440C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A18020693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Vp7cYXso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfG3Lzf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:55:35 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:65286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfG3Lzf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:55:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HE043HXCptkS8MyABZOHunzmJQumjzQkbwEBg53DytlGjuBvjCvhc7Q+0cdCMt8xgtRpZK2SZSQATEXIAqugG6Y9fD9fGEbsFGBmeWjYk82wT49vM5CRWYNelipY7ZkbmJUIcgHC2gSgpfI48L9enAHidnNYuvi2L6J8fUDJ+j7uSjbZ6S2YRJtWQCnWpnaEooFJzFB59IAdsum7fgChz2EQv7cdNhI2ioFGpcxIfG6GzScmiWL98TrW4GB/hG5A/LMTB8n95YyVW8z84h5G1gfBm1UAG8m7Fkxv/olBAxI/Ke2EaFN9PZJC9bcJ0gt+iKZPZygNWaMc/3GnkWM/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAFYHVanRIxPa59/EhU2gy1fL5NqBPTv5Zn10oFU0xk=;
 b=VM0la2fTzVI3LvvKzu+1rWNEqIg2zA/NMHc6OqbS83zmsljwHpUs0XMerbSaqjyMo4ZCRML+9ZeUkkno45MHZBWPnhMwBDEinOVDM4zldvhIUE1vT++mhIKqP1UanY7jxQW+UE3GrtkGF7wTpKb6hcqdM7Xwr2X9MIPGEAixUr0s9n2mFPFLx493tuHIPfrTS2isxooDpFr6Owdp0xMQv067/gaNhlL2efqlTkHiIoKVjQMjGXjLpwOOSfIDsxyiO0OkHBaGHSBMrFDApttSvdAxeL0/X4w4e+CXeZE1KrOKW4phAIhSl9+ihniLKGNC3DpYp/zHasDrfigA4V4usg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAFYHVanRIxPa59/EhU2gy1fL5NqBPTv5Zn10oFU0xk=;
 b=Vp7cYXsoXzSRZBwyX7IcVsaOWHYZbDGcVmxsJrfOoIbrtq6hr5iuElhvtr2H1cgroE5RaaxfSxUvjp1oBrbF2ZX6o418LsDIpDjGPu69R9xatT7babRl7DBoViq/qDBBs3Im6Y7n7VIuOJuMlnKyeDq5wqpWX27oY2LTIDHIcok=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3680.eurprd04.prod.outlook.com (52.134.15.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 11:55:30 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 11:55:30 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 08/14] crypto: caam - update rfc4106 sh desc to support
 zero length input
Thread-Topic: [PATCH v4 08/14] crypto: caam - update rfc4106 sh desc to
 support zero length input
Thread-Index: AQHVRsbmfUSbo2E0uU+2cq+YZ001Zw==
Date:   Tue, 30 Jul 2019 11:55:30 +0000
Message-ID: <VI1PR0402MB3485CD37422496ACD99B153198DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
 <1564484805-28735-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e132f74-72e5-4652-0078-08d714e4d1ff
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3680;
x-ms-traffictypediagnostic: VI1PR0402MB3680:
x-microsoft-antispam-prvs: <VI1PR0402MB3680C97C33F7CBCBB96F855398DC0@VI1PR0402MB3680.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(199004)(189003)(186003)(76176011)(6506007)(26005)(44832011)(478600001)(15650500001)(446003)(7696005)(316002)(3846002)(33656002)(6116002)(53936002)(6436002)(110136005)(54906003)(53546011)(71190400001)(52536014)(55016002)(256004)(71200400001)(68736007)(5660300002)(8936002)(476003)(66946007)(66066001)(6636002)(9686003)(14444005)(486006)(4326008)(86362001)(558084003)(99286004)(25786009)(74316002)(81166006)(81156014)(66556008)(64756008)(305945005)(66476007)(229853002)(6246003)(7736002)(8676002)(14454004)(76116006)(2906002)(91956017)(66446008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3680;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pmpnwozpNozyBgtOb/nICFKadHzVX/tgGzkHkr5c51fEF9n0wC7a6zeIiw6wxifXsOREmiQqkwPckJaSlKBCQ8pdolpGMAQO1rjC8Xjzu3vysGvBhGNlYPCMoEWY6+69YaQc2YvcRu4aGbWjiyLFc0UL3Sy1ng8xN0DKO/Eh784DMEvviFtifC4b18lyHPCzem3yE/4oInscbP27ihix6tGMKnEkmaqlvMW/vawUPvS8zPYsuFMkAhlkXq4D3rTkfjBaqcGvFiQIlT12k91a3ThrZSIEha/mmh0p/kR6Z3iwWIZ4MadMwkVnF1MspqFuDQ7YkAZAIFsqMrT7MNbtzZt7CXgVRkHwMgqQrApafLm21YLuw1JlJyoPQmutUYvyIsmDdPtU2p4r5xwV9/XIaOwSGlVcFuA9xaaiZawGZPE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e132f74-72e5-4652-0078-08d714e4d1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:55:30.3344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3680
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 2:06 PM, Iuliana Prodan wrote:=0A=
> Update share descriptor for rfc4106 to skip instructions in case=0A=
> cryptlen is zero. If no instructions are jumped the DECO hangs and a=0A=
> timeout error is thrown.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
