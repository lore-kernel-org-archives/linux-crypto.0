Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCF7C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 19:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F652085A
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 19:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="WxJa7wXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFQTYa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 15:24:30 -0400
Received: from mail-eopbgr130072.outbound.protection.outlook.com ([40.107.13.72]:27430
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbfFQTYa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 15:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJY3HURf4B+Uyav3u4C4mG294/93fmChqXHtGwXZY20=;
 b=WxJa7wXQ97WsplDi3QUelB3xlibQ4TtRLl+0p0LFnBhpQ3aYm19T6/1pVfwJ2xXgu53s8wp0SblVU1keD+/bBEZRuskV8p5SeRizgbRKbMqVzN3z/xbFlcrYyA1Tlu7/pBUq8LVx5QQdde3SFCN0+B0YwDUQrK/aLS9wiDCDHlI=
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com (20.177.50.140) by
 VI1PR04MB5470.eurprd04.prod.outlook.com (20.178.121.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 19:24:25 +0000
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1]) by VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1%7]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:24:25 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH v3 2/5] crypto: caam - correct DMA address size for the
 i.MX8
Thread-Topic: [PATCH v3 2/5] crypto: caam - correct DMA address size for the
 i.MX8
Thread-Index: AQHVJSZIVXANdmo1E06O+7eMXYofbw==
Date:   Mon, 17 Jun 2019 19:24:25 +0000
Message-ID: <VI1PR04MB5055A9A725CED589FCF9254DEEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5460fb4b-aa15-493e-9f26-08d6f35968f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5470;
x-ms-traffictypediagnostic: VI1PR04MB5470:
x-microsoft-antispam-prvs: <VI1PR04MB5470F0BCBBA9D2E827605614EEEB0@VI1PR04MB5470.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(366004)(136003)(376002)(199004)(189003)(71190400001)(6506007)(53936002)(26005)(81156014)(102836004)(186003)(7696005)(486006)(476003)(53546011)(14454004)(8936002)(52536014)(74316002)(81166006)(446003)(478600001)(7736002)(64756008)(256004)(3846002)(76116006)(66946007)(110136005)(66476007)(86362001)(8676002)(66446008)(68736007)(5660300002)(6436002)(4326008)(25786009)(99286004)(54906003)(6116002)(73956011)(76176011)(91956017)(66556008)(2501003)(71200400001)(66066001)(316002)(55016002)(229853002)(4744005)(44832011)(6246003)(9686003)(33656002)(2906002)(6636002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5470;H:VI1PR04MB5055.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S2UadDtTlYG6ImNGOtp01+woYApGyG5djlxC6QWaaUbs9CZwHZ3OcoIJV6ly3jDlco8a89UbQMrtPY+qQeriHswNG1VdV7iC+GA5VRKFCbuWprZiwrsE4JyyEYaRdyWXQXlmbO0GeNfl7gEhBKohqgse7yeCDrqlqgBmpQcypDGc3/rkgnNDpmrm7wsW3vXqNpHo1UXo0ccCfMt1bdVMjdLFSSrx/QHSW9iUpArehsJzJhj6zVh/A6ihtQX5ubLoQZlVPj84ixkH4E6JqCTRhb8qY1z6ozbGzcsypg/ma/C7dnuvKajUf3Gt3r2+ynnHkJyAtLg0spzXz0jyahi5IykWEjl3pqN3zYbEBvVHw2RyhShGGHw6DZ7g7PKaypyuQs5r+In/9eJoRbgl8jqoARPE7d6//VdSuYpO/6jzGWM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5460fb4b-aa15-493e-9f26-08d6f35968f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:24:25.6516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5470
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/17/2019 7:04 PM, Andrey Smirnov wrote:=0A=
> From: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> =0A=
> The i.MX8 is arm64, but its CAAM DMA address size is 32-bits.=0A=
=0A=
> +/*=0A=
> + * On i.MX8 boards the arch is arm64 but the CAAM dma address size is=0A=
> + * 32 bits on 8MQ and 36 bits on 8QM and 8QXP.=0A=
> + * For 8QM and 8QXP there is a configurable field PS called pointer size=
=0A=
> + * in the MCFGR register to switch between 32 and 64 (default 32)=0A=
> + * But this register is only accessible by the SECO and is left to its=
=0A=
> + * default value.=0A=
> + * Here we set the CAAM dma address size to 32 bits for all i.MX8=0A=
> + */=0A=
> +#if defined(CONFIG_ARM64) && defined(CONFIG_ARCH_MXC)=0A=
> +#define caam_dma_addr_t u32=0A=
> +#else=0A=
> +#define caam_dma_addr_t dma_addr_t=0A=
> +#endif=0A=
=0A=
Wait, doesn't this break Layerscape? Support for multiple SOC families =0A=
can be enabled at the same time and it is something that we actually =0A=
want to support.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
