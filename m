Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC99C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F542070D
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="E6yCMYHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfG2PcK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 11:32:10 -0400
Received: from mail-eopbgr10042.outbound.protection.outlook.com ([40.107.1.42]:58880
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387874AbfG2PcK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 11:32:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZuhm9/ILqb77YsncBV9ZlZpLE7sJMUUsu5E4l4JhXRsnndQ0t2n65a2XwmR3DTFPHo4YWVmBhF1zh2Va1LbbMVQbDsboeo0eU3uvpetMWYU92KkAXpsFK39cshQDzFA8NfEtEwrA6NGRazMsDr3ZDoGfekv5Mda3fWQ4i/298zjLohqxv3q6npLOaC4d4gcr8QpCXZujOjHbOqY9PCdLIv/rW/HM3qfezlu9EyA6HDLoN54eNmP/p7x/zPX850SDxswOFgzut6PJjUMH08DTIT4q+b07Q8/a2xweqvl4dhQUY393DvCG9oCs/f7+PdK6dpQ5e91sFtSXMVPjcQ92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvTQPq0i76V89WvPjQt+1HXRG9BzKxSHkpLPxs7F5kU=;
 b=m4yczPCsSUEjbdEl31xJhcc2a8dPqYpRErQpvGWlPQmB/omCJAkqLBMlW6ArpLcxHIqRAcLFHxsyET46C21z90+dq6NAgmE8/qhF1riLm2c0/mHcZrr3vHyQuTY2J/D3AyEsq4/R62F88lMBTK7lSkyDbB2KJFU4Nxv7pdQOtCvneoFs8hrcNPh1enEF81AZazKtDwHcDCKeNxmO9tsuC3Xd8S9bTzZh9R8JfDY+KXM/oDWTy6Q3lrF3vomR8n5vpkpGoPYJTCwrPHEKNcn6bsLVUlc6VWsRml2wfZVWtJWWii+pz+RFxn3FXpL3duvNJ5e4L+06e0a6Zk0VIMTvTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvTQPq0i76V89WvPjQt+1HXRG9BzKxSHkpLPxs7F5kU=;
 b=E6yCMYHKP40xma0QUHyU4UTQeKiSGOEOUpiFx/UWUFdcYSHM4ihvb5D3BB+A5bxfVpZoZaID9Kyo9Ksg16K6yuDNgArUljfAq2YxHuwO2DhBjC6bsYSM9l19gCqnc3Nwkk0di9bvlnw71MUyt7N+5VXx0Wbed7xZObd/rKNYz+4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3920.eurprd04.prod.outlook.com (52.134.17.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 15:32:03 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Mon, 29 Jul 2019
 15:32:03 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 06/14] crypto: caam - use ioread64*_hi_lo in rd_reg64
Thread-Topic: [PATCH v6 06/14] crypto: caam - use ioread64*_hi_lo in rd_reg64
Thread-Index: AQHVPLPasN7jCYpIIEeSBtcbrn61Wg==
Date:   Mon, 29 Jul 2019 15:32:03 +0000
Message-ID: <VI1PR0402MB3485637BE588C0E819B05B1398DD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-7-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2363ec3f-9b44-4587-fdac-08d71439e7da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3920;
x-ms-traffictypediagnostic: VI1PR0402MB3920:
x-microsoft-antispam-prvs: <VI1PR0402MB3920166C4565605519DE712A98DD0@VI1PR0402MB3920.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(199004)(189003)(71200400001)(2501003)(229853002)(76176011)(102836004)(71190400001)(4326008)(74316002)(99286004)(256004)(53546011)(7696005)(446003)(86362001)(186003)(5660300002)(55016002)(26005)(2906002)(53936002)(478600001)(6436002)(6246003)(8936002)(476003)(110136005)(66066001)(66556008)(68736007)(54906003)(3846002)(6116002)(66946007)(66446008)(52536014)(486006)(7736002)(305945005)(14454004)(25786009)(9686003)(33656002)(44832011)(558084003)(8676002)(66476007)(76116006)(91956017)(316002)(64756008)(81166006)(6506007)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3920;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 62dbtpnQaQzcQ2F1ITedDujQFGR/N9SEFM8obYV0cLaxptOEYqjysQRhDPSCL76xQffrR5wgou3yHeK7JAoDgUtBC5w3mIgXUT9hRs9bKw+CMQy1cOVdl6mVF2qFRCQGxmWga8HRAnDtJeien+QnOBVX7h8s7KiAX94DjVhjPUff3KuEUrB50byLwpjLSD7xpUUWY7QEiFIUdkLNej3yJm5b2HCWeWL+1I4yNWlI53fI0CuDNoWn65/KzHbR1svWGAKFbm+m0VMrdshxV3lP/PMu/n7WBijy9xqxNFfrGZ/qMcUge9698spwU6tDe2Wa6seDCaNUwCVaXHQwN8Xlj4SkCG//zoNbkQt/yOsoFgtZyjKZsYtoXPEOSlUcieMx36wCFhAqq9QN3YgRbUVHW51dbIembPU1qkRXVzvZ9Wg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2363ec3f-9b44-4587-fdac-08d71439e7da
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:32:03.0195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3920
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> Following the same transformation logic as outlined in previous commit=0A=
> converting wr_reg64, convert rd_reg64 to use helpers from=0A=
> <linux/io-64-nonatomic-hi-lo.h> first. No functional change intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
