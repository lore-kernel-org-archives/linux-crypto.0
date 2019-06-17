Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78FCC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 19:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8102084B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 19:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lHl47qJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFQTsK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 15:48:10 -0400
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:61860
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfFQTsK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 15:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asUwSrh9wzmqMIXDAbUAPbF5ii77dRvDZhKIHyb4vXQ=;
 b=lHl47qJNOdHeEZJIu7gMfmBQNHqzjmeiVjNsvwzyMGn1PaVgF6ZuD0kH2YEKB3w8AD2Qb6vCDixzCWFVw0aDxLn//26W3iULtYBGK1d1HWqmvu2oiLWBDm2UzhmWW9uEm/iBxGdmXIlaGOK6BMbySCzCjL7M/8joWd2DdftLrKE=
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com (20.177.50.140) by
 VI1PR04MB7056.eurprd04.prod.outlook.com (10.186.158.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.7; Mon, 17 Jun 2019 19:48:05 +0000
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1]) by VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::9577:379c:2078:19a1%7]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:48:05 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] crypto: caam - simplfy clock initialization
Thread-Topic: [PATCH v3 4/5] crypto: caam - simplfy clock initialization
Thread-Index: AQHVJSZJSx98FK+FPUqkFei6+EQfcQ==
Date:   Mon, 17 Jun 2019 19:48:05 +0000
Message-ID: <VI1PR04MB50556DE0057E1B5802E0DAA1EEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-5-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 255a00c3-ff97-4223-f7f1-08d6f35cb751
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB7056;
x-ms-traffictypediagnostic: VI1PR04MB7056:
x-microsoft-antispam-prvs: <VI1PR04MB7056EB50DF4BCDD535C1A804EEEB0@VI1PR04MB7056.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(366004)(136003)(39860400002)(189003)(199004)(44832011)(486006)(446003)(6436002)(76176011)(2906002)(6506007)(476003)(4326008)(66476007)(66556008)(64756008)(66446008)(55016002)(7696005)(68736007)(102836004)(53936002)(25786009)(91956017)(316002)(73956011)(6116002)(3846002)(76116006)(6246003)(66946007)(53546011)(54906003)(110136005)(229853002)(99286004)(305945005)(33656002)(86362001)(256004)(14444005)(14454004)(9686003)(186003)(26005)(5660300002)(52536014)(71200400001)(8936002)(2501003)(81156014)(71190400001)(81166006)(8676002)(478600001)(6636002)(66066001)(74316002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7056;H:VI1PR04MB5055.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SANIjUTF2QetDwTJm7SGVey0nuJgXl38O1ec5wHNF/oBLedpZMWP/rauuFIXIC7q0b0kMCS8KxPGfSqTsiEvp0x/ThgIcr88V5k2RhYcJOkoe+mOFjU0duTH6Y9kabj527oX/eXJ0Rl8XjInU3iHRolo+9zUHb51XlNjwtRcyQW0WfqtAPum06c26z5MV0j3tzHz4utvIAbbngUulxIJP8k/USsZbGKQqFfgEVkxUn8vKfQtl4Uda+sy3TjXHe7mzA2l+ocasROP8gfaplG2Fuy/Ha41rxqm5Vc74jqJ1pqpZCMXA62GHcmgRobJkeaxftv9lCBju7LUzrTvwUZE87cAJGtSSJqjjnQRCjv5vRbKALR9fvUCOxYVTOZj8RpOzU2X921e4hexmR7JlxXP0pIW1/mnjJ0cu6loOfNjOZo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255a00c3-ff97-4223-f7f1-08d6f35cb751
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:48:05.5888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7056
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/17/2019 7:04 PM, Andrey Smirnov wrote:=0A=
> Simplify clock initialization code by converting it to use clk-bulk,=0A=
> devres and soc_device_match() match table. No functional change=0A=
> intended.=0A=
=0A=
Subject is misspelled.=0A=
=0A=
> +struct clk_bulk_caam {=0A=
> +	const struct clk_bulk_data *clks;=0A=
> +	int num_clks;=0A=
> +};=0A=
=0A=
clks could be an array[0] at the end to avoid an additional allocation.=0A=
=0A=
> +static void disable_clocks(void *private)=0A=
> +{=0A=
> +	struct clk_bulk_caam *context =3D private;=0A=
> +=0A=
> +	clk_bulk_disable_unprepare(context->num_clks,=0A=
> +				   (struct clk_bulk_data *)context->clks);=0A=
> +}=0A=
=0A=
Not sure using devm for this is worthwhile. Maybe someday CAAM clks will =
=0A=
be enabled dynamically?=0A=
=0A=
It would be make sense to reference "clk" instead of "clocks".=0A=
=0A=
> +static int init_clocks(struct device *dev,=0A=
> +		       const struct clk_bulk_caam *data)=0A=
> +{=0A=
> +	struct clk_bulk_data *clks;=0A=
> +	struct clk_bulk_caam *context;=0A=
> +	int num_clks;=0A=
> +	int ret;=0A=
> +=0A=
> +	num_clks =3D data->num_clks;=0A=
> +	clks =3D devm_kmemdup(dev, data->clks,=0A=
> +			    data->num_clks * sizeof(data->clks[0]),=0A=
> +			    GFP_KERNEL);=0A=
> +	if (!clks)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	ret =3D devm_clk_bulk_get(dev, num_clks, clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to request all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D clk_bulk_prepare_enable(num_clks, clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to prepare/enable all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	context =3D devm_kzalloc(dev, sizeof(*context), GFP_KERNEL);=0A=
> +	if (!context)=0A=
> +		return -ENOMEM;=0A=
=0A=
Aren't clks left enabled if this fails? Can move this allocation higher.=0A=
=0A=
> +	context->num_clks =3D num_clks;=0A=
> +	context->clks =3D clks;=0A=
> +=0A=
> +	ret =3D devm_add_action_or_reset(dev, disable_clocks, context);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
=0A=
>   static int caam_probe(struct platform_device *pdev)=0A=
>   {=0A=
>   	int ret, ring, gen_sk, ent_delay =3D RTSDCTL_ENT_DLY_MIN;=0A=
>   	u64 caam_id;=0A=
> -	static const struct soc_device_attribute imx_soc[] =3D {=0A=
> -		{.family =3D "Freescale i.MX"},=0A=
> -		{},=0A=
> -	};=0A=
> +	const struct soc_device_attribute *soc_attr;=0A=
=0A=
This "soc_attr" is difficult to understand, maybe rename to something =0A=
like "imx_soc_match"?=0A=
