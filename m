Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D079C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416F520874
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kuoijEHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfFLNyB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:54:01 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:35811
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbfFLNyB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFxVOs7UzjM0kvE1FZD/4uN/u+z/Ymfw5kMixgrZ9U8=;
 b=kuoijEHquwUc1HBjf1ps6qxZ9pffwvybELS9KHJZ0vs5gSH1TLmW+YzgXrvV3Jjp+gG/AIcd2h/eoJARyHMi22DOJ8DalPQ0UQ5ha3x71+eowdj3U/GYA2tzVHR9o4CTEuCA3pyJtOtmWIwRwt0343oX+b72HL60QK9Hk5wDOJQ=
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com (20.177.50.140) by
 VI1PR04MB5904.eurprd04.prod.outlook.com (20.178.205.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 12 Jun 2019 13:53:58 +0000
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1]) by VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1%7]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 13:53:58 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the
 i.MX8
Thread-Topic: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the
 i.MX8
Thread-Index: AQHVHWwJspoqZbZRu0O/kUXjAFynTw==
Date:   Wed, 12 Jun 2019 13:53:57 +0000
Message-ID: <VI1PR04MB50558864B434388A52A00915EEEC0@VI1PR04MB5055.eurprd04.prod.outlook.com>
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
 <20190607200225.21419-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47fdf32f-0069-4d44-15a2-08d6ef3d6a9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5904;
x-ms-traffictypediagnostic: VI1PR04MB5904:
x-microsoft-antispam-prvs: <VI1PR04MB5904F77FF24BF01B000F9EA3EEEC0@VI1PR04MB5904.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(376002)(346002)(39860400002)(199004)(189003)(66946007)(3846002)(6116002)(73956011)(74316002)(91956017)(8676002)(76116006)(229853002)(305945005)(7736002)(64756008)(81156014)(66556008)(66476007)(66446008)(25786009)(8936002)(81166006)(14454004)(5660300002)(33656002)(52536014)(6436002)(53936002)(478600001)(6246003)(9686003)(55016002)(4326008)(68736007)(6636002)(110136005)(316002)(54906003)(102836004)(6506007)(53546011)(26005)(7696005)(76176011)(2906002)(186003)(256004)(476003)(66066001)(486006)(99286004)(44832011)(86362001)(71190400001)(71200400001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5904;H:VI1PR04MB5055.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gpBs0gDBsPK34N6xcn18gr0KC6b6IJ4fKmbG9JPKGw3FyXOo5NljtHRozAxPuHl3RI0CdODDxdRUBG2uXDw9zpi/esbc7A/Qs7QBIBgwVZ2BrkErnL16xJ4fMz0YB5UavXPKpjVdNfFG4chS7V7/F0BReu1KjtYvBwegPGFA0RKLV6teSy/iFTXCkgu7rks1b3QDH+22HFy45lMyj3oOWmD2vw9qMeMkQ0/U3i9NUwEBBJRrcdpVm7DfaY+YxcA2mzt7vFP7eUgYh6ScvHDVrH35cGIpVS148iWpc5NjX2HlFsxIIcXY6a+X+wc/BpQHyTkYkJUCfGZlXLdo1extj4xYJHPexydstahUDoPo48G6si+oQ56zJty4jlSX2f9RoPc6FOnI56yHlKZT7AgMi2x8Z5E1SzAb5aoN6SSKBP8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fdf32f-0069-4d44-15a2-08d6ef3d6a9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 13:53:57.8886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5904
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07.06.2019 23:03, Andrey Smirnov wrote:=0A=
=0A=
> There are no clocks that the CAAM driver needs to initialise on the=0A=
> i.MX8.=0A=
=0A=
The clk handling inside CAAM is very convoluted and this patch doesn't =0A=
help. All the driver actually does is "enable all required clocks", this =
=0A=
shouldn't be complicated.=0A=
=0A=
I propose adding a const caam_soc_data struct which has a bool flag =0A=
marking if each clock is required or not, the replace all the =0A=
of_machine_is_compatible() logic with statements of the form:=0A=
=0A=
if (ctrlpriv->soc_data->need_ipg_clk)=0A=
     ctrlpriv->caam_ipg =3D devm_clk_get("ipg");=0A=
=0A=
You could even make all clks optional and claim that if a clk is not =0A=
listed in DT then it's assumed to be always on. However that means that =0A=
on some SOCs if DT is incorrect you can get a hang (due to missing clk) =0A=
instead of a probe error.=0A=
=0A=
> +	clk_disable_unprepare(ctrlpriv->caam_ipg);=0A=
> +	if (ctrlpriv->caam_mem)=0A=
> +		clk_disable_unprepare(ctrlpriv->caam_mem);=0A=
> +	clk_disable_unprepare(ctrlpriv->caam_aclk);=0A=
> +	if (ctrlpriv->caam_emi_slow)=0A=
> +		clk_disable_unprepare(ctrlpriv->caam_emi_slow);=0A=
=0A=
Clock APIs have no effect if clk argument is NULL, please just drop =0A=
these if statements.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
