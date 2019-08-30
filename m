Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1996BC41514
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 13:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E37D1233FF
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 13:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qx82lidP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfH3Nf0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 09:35:26 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:23790
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbfH3Nf0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 09:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfjhBIlml3HTu9DtU+UUtIaToYM7Ppnv2pzE43i+XK2EY+aNkM0gfFiWfvrqK8xOdTH6L78fl4/SFza9gSLytGiuFjzFpaQuTKvoW63BcrLKguOiRffKCd7y/WunxpP+FGp1i8i6xaMA2wOEfdAyzH8hsR4hRN05NyBj86NudKncLLUIMNEr8HkbwNBe43xiupGk4lX0tcqprybrfidd76CxPHeqHoQ3R/Q6i7UekhOggekfQY5kdzrJA4SS8P74vMv0LDlT0vG90eEuflNQ8bbp0Bv+XxeqNaNAVMpewMwehqCbUxN4HmjgMG/gc9SuPsoq0OKX5hffoxtrLquZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcdYGdKtuGLss/qwp1ISTPO1NkmiuVilXzXtgC/DN0Q=;
 b=R/0UNNAe0D51WooFo5uICiimdEPdZloUTMdWOhhikcySwB5Tx62WDD0UhUrsYb5dr9xZwX6dEeeZemCMJPTrM7pze8lCAVcUQtuyIM6GkQBsL31VtW8HuYhZmODV+/G3m43ToOi2Rch6EC3hmHetSGOmrO98i24Pd+wO/Knza0G6IwJF6uEh2pGTSbOkKrRFjWS1P8bpmn39D642PWWPFM/HqZahQrOm88XxaqBQuzq39zzRbhYkO8QXiqJyO1/RLpv75vK7iRfT3ijqu/73sQTfOf0AwDX6RfjJSuo4gP/Q23ytxAFUyN82+bgFyFMCMzMTT/Fy2Lo6/Hh9fFI6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcdYGdKtuGLss/qwp1ISTPO1NkmiuVilXzXtgC/DN0Q=;
 b=qx82lidPXFOdr26LBFiaAcryoLa75N2X0O00hnC+8HVrAVdHaei+hQBgzSoU+vnNkZi4IFBjmiUoKTmQjRPOzH+eT6hbKCYCD7dQbK6RYeVmtUtgqVyIYq7rLjpSH87URE/C/v/kPLBedeUIO4h2lcLExQqW7JBsxjCqwHt3dpo=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6879.eurprd04.prod.outlook.com (52.133.245.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Fri, 30 Aug 2019 13:35:23 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 13:35:23 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "christopher.spencer@sea.co.uk" <christopher.spencer@sea.co.uk>,
        "cory.tusar@zii.aero" <cory.tusar@zii.aero>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Topic: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHVV5VB3CgVSzdtsUuKFBe5Nr//dA==
Date:   Fri, 30 Aug 2019 13:35:22 +0000
Message-ID: <VI1PR04MB4445AE3FE7AD09C4544D155C8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190830082320.GA8729@gondor.apana.org.au>
 <VI1PR04MB444580B237A9F57A7BAAF32B8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190830131547.GA27480@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0937ce22-01dd-4374-44cb-08d72d4ee8a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6879;
x-ms-traffictypediagnostic: VI1PR04MB6879:|VI1PR04MB6879:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB68799E9C3CEAFEDE1639D1418CBD0@VI1PR04MB6879.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66446008)(25786009)(4326008)(476003)(8676002)(74316002)(52536014)(81166006)(81156014)(64756008)(14454004)(99286004)(66556008)(66476007)(5660300002)(44832011)(26005)(486006)(76176011)(6436002)(4744005)(2906002)(91956017)(71200400001)(7736002)(66066001)(6916009)(76116006)(305945005)(66946007)(71190400001)(186003)(446003)(3846002)(9686003)(33656002)(86362001)(8936002)(54906003)(102836004)(316002)(478600001)(6506007)(7696005)(53546011)(55016002)(53936002)(256004)(6116002)(229853002)(6246003)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6879;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PP+ZjmNW4zIxtspQal1B6ElqmNEPGTDkowp+ZRMj8RLY8r6xi4RZooqgB6xhexj2SbYAXdUTkU3dMcDmqFSyQRce7p4pAOzQn9gJis6y3kDJewr6kEL9sgygRb9+8klbBpE4s3pmwmytBQAnjez0L0yQ52iUy8KTDoizUoyALaLaKHltt/qO82QcW64/jJfRlEYY73rcGCD3sgWjCdHa4iaDH39VK6Nz1ruVYYTRRyhjUh6AUzy3ub2rCqEKPejPfyBvU7QWu3FuFQeARgczNyjEf3O7AI9r23utTsz9hIBpRpSIZNF4aB0ezHiGjwOWn/5qT2DW/OtCCc2R5CpDRAS8KTpsM7u0EOO1TOvE+Zj6UzM+wp8zYuXhuBZA4tbqAOp6OL1LEFlQyDN/zknNMxUa9fCGuXECTjiG97mL+s2hM81/1pA4bvCVx47tmOCwWEgf9FPVNToa9g5a2d4aoQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0937ce22-01dd-4374-44cb-08d72d4ee8a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 13:35:22.8360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p3B/9dByiz33KQnpqO8amnMFeo5rUbvXj7/6cQqKTwBRhTjqGfWXIqKSKn2KzaqExQAuRfxkX3Aaj5YEYSDjIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6879
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/30/2019 4:16 PM, Herbert Xu wrote:=0A=
> On Fri, Aug 30, 2019 at 09:15:12AM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> Can you, please, add, also, the device tree patch ("arm64: dts: imx8mq:=
=0A=
>> Add CAAM node") in cryptodev tree?=0A=
>> Unfortunately Shawn Guo wasn't cc-ed on this patch and, to have the=0A=
>> complete support for imx8mq, in kernel v5.4, we need the node in dts.=0A=
> =0A=
> If Shawn can ack this then I'm happy to apply this patch.=0A=
> =0A=
> Thanks,=0A=
> =0A=
=0A=
Thanks, Herbert!=0A=
=0A=
Andrey can you, please, resend the dts patch and cc Shawn Guo?=0A=
=0A=
Thanks,=0A=
Iulia=0A=
