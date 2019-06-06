Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A01C46470
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 08:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA4E7208CA
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 08:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Q4g5/q+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfFFIg5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 04:36:57 -0400
Received: from mail-eopbgr130072.outbound.protection.outlook.com ([40.107.13.72]:22658
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725769AbfFFIg5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 04:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7h5SvArmkf8QqPyEV6TGpf7kya+Md+9ykMPuufAV80=;
 b=Q4g5/q+zFoMJCjVQ26vqFOxNIUR3f2TRRTIZUTA5w8Rs8lTSwlLIuvRaQPt/T57nefXUCV/vewKiNTFQTu/cBImMlLSa0wzX9/T0wKodCoH0ECyAPAzZpiOnCPBYbiFiDsdgdDb03x73U0jMeTl9OejHlBYDoq9PZFDsQEIFaAk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3549.eurprd04.prod.outlook.com (52.134.4.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 08:36:52 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 08:36:52 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVHDJUFTzexZfnZkK5jYnCMHmb4A==
Date:   Thu, 6 Jun 2019 08:36:52 +0000
Message-ID: <VI1PR0402MB3485A46E17D52EAA8A26984698170@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
 <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au>
 <CAKv+Gu-YtKRsUYMMD_PNoFvrPpmwTD7fJNs64Q-34L8-TvucqA@mail.gmail.com>
 <20190606064603.lvde6dproqi3vwcq@gondor.apana.org.au>
 <CAKv+Gu-DokZ179_Gx8_20v_pQ3w_CARKdO0xdsO8CRZJG1uOqA@mail.gmail.com>
 <20190606065757.4agqd4poer4rexri@gondor.apana.org.au>
 <VI1PR0402MB3485A016A2E5FDEE57EBF48198170@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190606071548.5dacz7dnpt2lyrtv@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfafcc17-2d70-4987-65d3-08d6ea5a204b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3549;
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-microsoft-antispam-prvs: <VI1PR0402MB35492D77277632FBF5BAB22A98170@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(396003)(376002)(366004)(199004)(189003)(3846002)(6116002)(256004)(14444005)(305945005)(6246003)(14454004)(478600001)(4326008)(54906003)(66446008)(53936002)(25786009)(66066001)(8936002)(33656002)(7736002)(52536014)(81166006)(2906002)(71200400001)(76116006)(91956017)(68736007)(86362001)(66946007)(73956011)(7696005)(76176011)(99286004)(66556008)(476003)(64756008)(102836004)(53546011)(6506007)(66476007)(8676002)(81156014)(6916009)(229853002)(186003)(446003)(9686003)(316002)(6436002)(26005)(55016002)(5660300002)(44832011)(74316002)(4744005)(486006)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3549;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dTzWD6XjsYcRLj7a7jNfEcV8wvUeYngR2RdKIw9zwoPLQpi+UnNuYV5c3i/2mCtl54Ni5lHdM1niiL7bBYL6GcHzBWz2d7revIgmsLH2ELmS00HCUASZRHGbvY+QwgK94g0S3Ctp24kF4c5Y/IVOrUtWGGdweOmQVYkUD6HJIAKLhL+6kYQ5b9VuV32RKY4dejWkGH5ve65S7R9QZmf7arDSOY6wMRO1XPorJqAWweK6eVVQYSFRZs9sOsa0XQxtJfTRsfXm+Z/hxB/ZJBVJ8/Ue7SgIx3iavLWwHHRDmVkwLhXBnplB5TXILDhazuOOztIElqujmpF7IiNTQa7gKx2mD/6PWs5B1GQPzVNWtxWH5IRcnehQra38ZGURBVMnWXMB/qpHF3Ur8RIzKmgndlU+X77sCI4uLMQXhW9Mc5k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfafcc17-2d70-4987-65d3-08d6ea5a204b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 08:36:52.8382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/6/2019 10:16 AM, Herbert Xu wrote:=0A=
> On Thu, Jun 06, 2019 at 07:10:06AM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> Not really.=0A=
>> I am in favor of using the HW to update the IV, which would work for all=
=0A=
>> skcipher algorithms.=0A=
>> I have the fix ready, will send it in a couple of days.=0A=
> =0A=
> OK that would be interesting to see.  But I presume you are still=0A=
> going to do a copy after the DMA unmap since you can't do DMA to=0A=
> req->iv?=0A=
> =0A=
Yes, an internally kmalloc-ed buffer is used for storing the IV (both input=
 and=0A=
output IV).=0A=
Once HW finishes the job, area is DMA unmapped and then output IV is copied=
 into=0A=
req->iv.=0A=
=0A=
Regards,=0A=
Horia=0A=
