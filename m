Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965E2C282C8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 19:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 369C22087F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 19:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gJIL1u4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfA1Tu5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 14:50:57 -0500
Received: from mail-eopbgr00080.outbound.protection.outlook.com ([40.107.0.80]:58080
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726719AbfA1Tu5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 14:50:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExpgHOA4Ax3dSGpbWZmo7A9t4xDERcv4T0+xxngjsNQ=;
 b=gJIL1u4l3ek66s1Yt7Yzbfu7BehiuWQ4zHkIaicsFr84orYVVAk0HiO+MRQPdswY0KzI+3iKlHMjH4+JPXhSyjdwo3ry4cj7/zsRQJJZiboFCrFk3mV2GDYYnZMtKp+ArS8A69Gz0R3ahxpPpZsGHg7Quuv8fQkCzSfNE60wBVU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3936.eurprd04.prod.outlook.com (52.134.17.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Mon, 28 Jan 2019 19:50:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1558.023; Mon, 28 Jan 2019
 19:50:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Roland Hieber <rhi@pengutronix.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Topic: [PATCH v2 2/2] crypto: caam - fix DMA mapping of stack memory
Thread-Index: AQHUtaFSDnpyWRrBME6Rg2w1yvLFEA==
Date:   Mon, 28 Jan 2019 19:50:54 +0000
Message-ID: <VI1PR0402MB34850F22F806E819DE5E8D9298960@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190126180215.9842-1-horia.geanta@nxp.com>
 <20190128190047.7btanivlbj5jpy3u@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3936;6:yqaUj9KK75erhaRr0cvc4KNIHUbXzMuA0NZegxUxTCFRC91f3bztGznqLb0nRwQvX4CpQN7e0yEs1ffu6CPBk0r1SKYnsrjndgX1OMgPvLzrj2hZD//9kjlYWoOqmm1IXlbQ31IXlx3o0pDtgHQmD8eFQgLkN0aAgzYQKzdyo9jIJiQjqdSiRpBb7zDDFj7293qKp7Dw6ao9XFwdrleOj+yqfAVCR5YGDbQUYF4HCiNuDkNXIpDghch5aa6vlFxMyq5ad9nhO8ZMwmNBefjSpPVxLVXgOfxZDnga5RZjuBUPIsUeZqnFv21/oUjhI/bNYmLH+RuzGI97QhRR/SnYBETws4dwq376bEJIjpB/dzwSJDcapHMHc8A0nr04ROvAgUewDJ02tp4jkhHu11qh0mES4dslQcXzWMe1DGzvgpT67cg0ByOsn9ZuCqInNqqqXT7xDlRqnBXIzK0mCedTUQ==;5:pmQ20O/HHksZttG0zaMRFE8E8Ghps515jMY7mkIXFPgr5QSZa45gxcHujvJ/8BSrJdXm/M8u56Y4eIQ8gfAJ60EajxjnsYcOl7tYtAmUv+t2fe9YhIXfJw/oP77BIjaPHxaGqpOvOFPwHRuin+zOm6aX+LAbbXJQrMsBqRxhoCV/BzK/94l6yk74GFTevXOyKWh9lnQTEMbOTHTVkn2Nlw==;7:PEDopZmiVY9kaEEg819+Q5xDQY8JizTWniTgZrnMN0FW17sYwyZdx9qt+FRYdj3MuJLCqfRPNSBbaNNMeL+gItjUC2FqbJS820jt6zp6SOAAl9neYnqu67jw1V45JfWLksRLBeFoDs9GfNOcOhQN8w==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 40a22c74-959d-4531-af1b-08d68559ea1a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3936;
x-ms-traffictypediagnostic: VI1PR0402MB3936:
x-microsoft-antispam-prvs: <VI1PR0402MB393678EB7BB14A591A62E5C598960@VI1PR0402MB3936.eurprd04.prod.outlook.com>
x-forefront-prvs: 0931CB1479
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(478600001)(53936002)(54906003)(446003)(25786009)(476003)(14454004)(86362001)(4326008)(105586002)(186003)(316002)(6246003)(486006)(9686003)(6506007)(26005)(53546011)(102836004)(66066001)(97736004)(71190400001)(76176011)(8676002)(81166006)(8936002)(33656002)(74316002)(7736002)(99286004)(7696005)(6116002)(55016002)(14444005)(256004)(44832011)(106356001)(71200400001)(6436002)(6916009)(229853002)(81156014)(2906002)(68736007)(305945005)(3846002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3936;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VlcYCU28IX/ZFHtFyvyWBEtXmUjPq2tLmNNCUv5HHKujC5DJ/pVS6VLsk42TfVF4JtXSSXmOJ8nwmPn0wuhCdJF9xbwH+Vh48MTStVpjjsFccpcdzLorjcgXfYnbdd7TLEchkhmARdrvsJaP2xTX+IbRIi2dZIjoZakygkDgOq7pEZJmi3a/oG/ykAl1QtNgfn7l1y7+eBrsIN0o8YSLsMNHh1TGVf4rlw2hzvKlYPe+PBLmNYKVCCrI1420E1ygED2s5Xaq+Jd3uGmTO6dMZRqY7AP6CXIRYOpEh1WB1az+JOLgyOCiMkDcxEVr0Qk+zL4yqqzNKtPyu12U/wNBo5QkMmr1sR2bY3ooAFh5RScIBglwEGi/n50sKoJk1qxZO1PHTrRbsYkUwzWtkYKR0QZLII4lMh0eppurV/B1WGc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a22c74-959d-4531-af1b-08d68559ea1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2019 19:50:54.3953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3936
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/2019 9:00 PM, Roland Hieber wrote:=0A=
> Hi Horia,=0A=
> =0A=
> I didn't understand your patch thoroughly yet, but I tested it and it=0A=
> gets rid of my DMA-API warning, so:=0A=
> =0A=
As mentioned in the commit message, the main idea is to use the buffer hold=
ing=0A=
the partial hash (state->caam_ctx) also for the final hash.=0A=
So now:=0A=
-crypto engine DMA writes final hash to state->caam_ctx=0A=
-driver copies hash from state->caam_ctx to req->result=0A=
=0A=
There are some implications of this change, mainly the change of DMA mappin=
g=0A=
direction for state->caam_ctx, clean-up code (DMA unmapping) and updates in=
 how=0A=
crypto engine job descriptors are generated.=0A=
=0A=
> Tested-by: Roland Hieber <rhi@pengutronix.de>=0A=
> =0A=
Thanks!Horia=0A=
