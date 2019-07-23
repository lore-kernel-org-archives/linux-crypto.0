Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752E9C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 14:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A52021842
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 14:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="F/IgDoO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbfGWOR2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 10:17:28 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:8100
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732972AbfGWOR2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 10:17:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gm5QVtQ90s8ZTmx2OqsiI8Us4NiroSb9v3/SOJPiTaE1mDoRI0PFB5Kimr0msYnObSicFYenLKEon5RfP4BsQxOfKrRCXFd9jawPTP5JjWtmjOlRIzigxH/YRvuXxStJ41SOG40q/Aj507vav0RwPcvjDCXJCqJWjwKSKEaX1367st93WPzMWeanIEnpF586ICch4NLd02Fbnbzjow6vQfzmmSFKKdIuzU5lb85nBjdIpkQgvSekVzylaCPXuwBSFabBN644BiDUdUJyyayW30OEB51zGgVK4z02gpa4/pME9PTPWojWa7Q1Xtj81iUgyjMamJ0qaeAIGkwmZdWvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hhXx5l9cykJ6eoTSz8YsUulV3YXes2hZ9BH4G99wYw=;
 b=e/SD48xjOUESNZgXoVgV3XebMX56urNywEkMC4ZEZLtTpxJQsF7T+Gc7OayJdbOtRn5N5MdzCA3BTy03UdVlV1GK3CzXWScp/NSrcfm1xfnN2FyxCGY+hbbGNtOZAhkHUT+wWS9b19jlAQgSiTQIcuSleEOarWnsxjmyzmEPEgdKzOMjv0z0DXTr6ZfYJSVNn7ntppCPUHsyc84G601GZsm7wZEqD2TlljJ/Kq1zmQl0B/ww85jvoaFoRcWg70BTNFBI29R2j/8a0s6KgJFEmZtui5xsE4On+u/I2oMYJrDQkH87MzuZ1vYYj5M61IYjmohMuknDHzt44URcMLS8vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hhXx5l9cykJ6eoTSz8YsUulV3YXes2hZ9BH4G99wYw=;
 b=F/IgDoO01LgTT1N8bNIDl6PUHuR1sdmyoj6kO5nuiAYKLy0f0Ez44qGF1wXur2SzWQ86siR9SJ4zBhmSC7K5+LQkmZXe2bktmjNYWNOYcsXzv/1mTFePUC6FWi9nT/nDSq0eifWG3IVA6fja6cE7Of5yf/BX5SbhH4ebOfhYppg=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3760.eurprd04.prod.outlook.com (52.134.15.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 23 Jul 2019 14:17:23 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 14:17:23 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Leonard Crestez <leonard.crestez@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 02/14] crypto: caam - simplfy clock initialization
Thread-Topic: [PATCH v6 02/14] crypto: caam - simplfy clock initialization
Thread-Index: AQHVPLPWYTLdMdHH1EGtW/zbNRZFgA==
Date:   Tue, 23 Jul 2019 14:17:23 +0000
Message-ID: <VI1PR0402MB3485E4DDB5E3BDCBC2AAAFE398C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f02b2314-1c7d-4a36-3561-08d70f787b68
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3760;
x-ms-traffictypediagnostic: VI1PR0402MB3760:
x-microsoft-antispam-prvs: <VI1PR0402MB37608C70DE08E2AF3CF42E4498C70@VI1PR0402MB3760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(189003)(199004)(14444005)(256004)(66066001)(305945005)(86362001)(7736002)(102836004)(476003)(6436002)(74316002)(99286004)(44832011)(486006)(316002)(6506007)(53546011)(8676002)(110136005)(54906003)(14454004)(478600001)(71190400001)(186003)(71200400001)(81156014)(81166006)(26005)(7696005)(2501003)(76176011)(25786009)(55016002)(76116006)(52536014)(91956017)(6246003)(2906002)(66946007)(446003)(229853002)(8936002)(5660300002)(33656002)(53936002)(66446008)(6116002)(3846002)(66476007)(68736007)(4326008)(66556008)(9686003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3760;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0kJ+nsZ3uH2ZGJ/so2W0Nd0ouO0wJtokfXn0hVO8Y1qNRVx8/O6yaYX1XGXd7zvlfKXhP2QiC8FQVZ2gupd4AYiKueIvZJWsb95WDvQhUla+T7f7lNcVTqSC7N38zLIlStIbIfnly3ldHOqEVbko+NAiig4vPm6cgbjl0QwuBAcyY8NgRRgkhiqe1Qz8ArCtpMaHO3AXXefH2KqGywB0+wM9tGPFkM/zFXGXxAAkOR60uWR/F6kxbMKHHmyal4SniJRwH1srAMKyNuclcY2RDkkeFjGkNnocaZlcnd2QhCP5L/DY6M+ZkwSsZMND+VYl1oVVwr4TpBV4jLzS2QyFV0S036BkfMoW+qdGRDtRH9zp5W6u/tZ3E8pIBtwvjC9CoASYjeP+wNYCz7uwL9mpv6Dc5+y5X3mOincR2BGBgQI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02b2314-1c7d-4a36-3561-08d70f787b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 14:17:23.5534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> Simplify clock initialization code by converting it to use clk-bulk,=0A=
> devres and soc_device_match() match table. No functional change=0A=
> intended.=0A=
> =0A=
Thanks.=0A=
Two nitpicks below.=0A=
=0A=
> +static int init_clocks(struct device *dev,=0A=
> +		       struct caam_drv_private *ctrlpriv,=0A=
> +		       const struct caam_imx_data *data)=0A=
> +{=0A=
> +	int ret;=0A=
> +=0A=
> +	ctrlpriv->num_clks =3D data->num_clks;=0A=
> +	ctrlpriv->clks =3D devm_kmemdup(dev, data->clks,=0A=
> +				      data->num_clks * sizeof(data->clks[0]),=0A=
> +				      GFP_KERNEL);=0A=
> +	if (!ctrlpriv->clks)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	ret =3D devm_clk_bulk_get(dev, ctrlpriv->num_clks, ctrlpriv->clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to request all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D clk_bulk_prepare_enable(ctrlpriv->num_clks, ctrlpriv->clks);=0A=
> +	if (ret) {=0A=
> +		dev_err(dev,=0A=
> +			"Failed to prepare/enable all necessary clocks\n");=0A=
> +		return ret;=0A=
> +	}=0A=
> +=0A=
> +	ret =3D devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
> +=0A=
> +	return 0;=0A=
Or directly:=0A=
	return devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);=0A=
=0A=
> +	imx_soc_match =3D soc_device_match(caam_imx_soc_table);=0A=
> +	if (imx_soc_match) {=0A=
> +		if (!imx_soc_match->data) {=0A=
> +			dev_err(dev, "No clock data provided for i.MX SoC");=0A=
> +			return -EINVAL;=0A=
[...]=0A=
> +		ret =3D init_clocks(dev, ctrlpriv, imx_soc_match->data);=0A=
ctrlpriv can be retrieved using dev_get_drvdata(dev), thus there's no need=
=0A=
to pass it as parameter.=0A=
=0A=
Horia=0A=
