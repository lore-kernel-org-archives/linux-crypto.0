Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F958C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE6B426431
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gU1c8T3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfEaGKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 02:10:54 -0400
Received: from mail-eopbgr20052.outbound.protection.outlook.com ([40.107.2.52]:30784
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbfEaGKy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 02:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTTZ5HuvNK3CLAOjmlrh81Bo2CFMoMn4a80T1nEW6Kw=;
 b=gU1c8T3U23cKrSD/g9P7hn0buHwOAg1Tv1D4CaEcgmq9dEAdSsUYosukde7baQErP7+952i4/PcIujPgTuj7Gqk71V+suYetNNMR1t6q7J/Ga8Ik9Xw9mtLGpEBX7uW9TIy8EiequTN6s8bvi+H/SgUVX1O6R658h3R8wmSUrQM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3950.eurprd04.prod.outlook.com (52.134.17.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 31 May 2019 06:10:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 06:10:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF+dOvdDzZqYUSH856vNqfARw==
Date:   Fri, 31 May 2019 06:10:51 +0000
Message-ID: <VI1PR0402MB348582411F826968EBC59A8B98190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com>
 <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190530132623.4h3y2bymv4uvfnms@gondor.apana.org.au>
 <VI1PR0402MB3485D7664F87D8C38FA8FD5C98190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190531054250.p2bc3igiu4s7dmvk@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ebea888-bb1f-4255-3f36-08d6e58ebbaa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3950;
x-ms-traffictypediagnostic: VI1PR0402MB3950:
x-microsoft-antispam-prvs: <VI1PR0402MB39507D9FE515B16EB4D5762498190@VI1PR0402MB3950.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(4744005)(55016002)(54906003)(66446008)(66556008)(186003)(73956011)(316002)(64756008)(102836004)(476003)(478600001)(26005)(71200400001)(52536014)(305945005)(6436002)(5660300002)(71190400001)(7736002)(6916009)(256004)(76116006)(66476007)(3846002)(76176011)(229853002)(9686003)(53936002)(6506007)(6116002)(33656002)(68736007)(486006)(74316002)(53546011)(6246003)(25786009)(8676002)(66066001)(4326008)(2906002)(14454004)(8936002)(7696005)(81166006)(81156014)(44832011)(446003)(86362001)(66946007)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3950;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e2IkReiYeH0FxDR5iMepgOIzPp2jrRxUtSNNSB5b+fFmAx6qGnJ1Cc3gdhGy6Qj8ADy0sGuX5JA03OCT5dhNUlgtRE2rE9WwXrbSPU4c3hueyu8NRW6eTm7BZZCAznhN93KaT+RcrJZdlPCbsVdiUc99TRFj9nYsraMMfGPQ+mdVXB2hvU8NzW/QxiToO0PUjsF1SDaCQe9Fld1zKAjznOtICJEFLzHEexRwAjigISDty3icD+vg6pBzG5FxV9zCI9deJQhYpzWrurzpgRRp7hDnwcZhSCmqdXWvI+g6v5JfQo6IcJy3M2AEWIJJdTIdZ6Zp8Tp9sN1nMVfP4ZGSiYiFrhmz4VcQU0eugId/p/i5GZplABW/H3Z+LuwIe/yH9j0LfLx4vSzChjO7vqFJSDTwzVZqpIVBdLqjqAG3AW8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebea888-bb1f-4255-3f36-08d6e58ebbaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 06:10:51.5097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3950
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/31/2019 8:43 AM, Herbert Xu wrote:=0A=
> On Fri, May 31, 2019 at 05:22:50AM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> Unless it's clearly defined *which* virtual addresses mustn't be accesse=
d,=0A=
>> things won't work properly.=0A=
>> In theory, any two objects could share a cache line. We can't just stop =
all=0A=
>> memory accesses from CPU while a peripheral is busy.=0A=
> =0A=
> The user obviously can't touch the memory areas potentially under=0A=
> DMA.  But in this case it's not the user that's doing it, it's=0A=
> the driver.=0A=
> =0A=
> So the driver must not touch any virtual pointers given to it=0A=
> as input/output while the DMA areas are mapped.=0A=
> =0A=
Driver is not touching the DMA mapped areas, the DMA API conventions are=0A=
carefully followed.=0A=
It's touching a virtual pointer that is not DMA mapped, that just happens t=
o be=0A=
on the same cache line with a DMA mapped buffer.=0A=
=0A=
Thanks,=0A=
Horia=0A=
