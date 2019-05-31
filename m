Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0288C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 05:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CD72640B
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 05:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="C7ROTWir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfEaFWz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 01:22:55 -0400
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:19173
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfEaFWz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 01:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNSW2W2IBW6qOqSspZzlI4/HnOUsOpeZusH+vOpm54E=;
 b=C7ROTWirApeHmQBs90qH+92AylcHh5xrInTaJQKLmlCx31P/zsgGBDGSf1l9Uy15IGAQEzwsO/VtGUXHbVLQBEymxIwKlB28G8dvMNaK0ve6lY+0I/s1sJt78yYssKTI/YcUSrSq5AX5Yi5xD39/Qz8x6qh6dQanPPB5pFp05Vo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2863.eurprd04.prod.outlook.com (10.175.20.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Fri, 31 May 2019 05:22:50 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 05:22:50 +0000
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
Date:   Fri, 31 May 2019 05:22:50 +0000
Message-ID: <VI1PR0402MB3485D7664F87D8C38FA8FD5C98190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com>
 <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190530132623.4h3y2bymv4uvfnms@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5204a36d-7f14-4f9e-e7ac-08d6e5880682
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB2863;
x-ms-traffictypediagnostic: VI1PR0402MB2863:
x-microsoft-antispam-prvs: <VI1PR0402MB286387D77F94757340DE627098190@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(39860400002)(346002)(189003)(199004)(81156014)(81166006)(8676002)(305945005)(7736002)(99286004)(4744005)(316002)(8936002)(186003)(9686003)(26005)(476003)(66066001)(446003)(486006)(14444005)(256004)(52536014)(71200400001)(71190400001)(3846002)(6116002)(5660300002)(2906002)(86362001)(66446008)(64756008)(53546011)(6506007)(4326008)(478600001)(66946007)(66556008)(66476007)(73956011)(76116006)(33656002)(44832011)(6246003)(53936002)(7696005)(55016002)(74316002)(6436002)(14454004)(6916009)(54906003)(229853002)(25786009)(102836004)(76176011)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2863;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HxjhNHwiAS16SFq5HHoTtIotQdZs8DFhb9CoXgzwZ7Idh+hO9Gh8Tb4Spc6319YnDeT1vVD0R4oPK9SYuVtGK9t6okj3eSFwFOxkSwBoBxhwdbLT+DPBa3ADOmg9SqWHSJMCu7xPL/RDO2yYT2VuL3uqzRLg7rLv2rapDZESYyH2o9peeoQH3sm3o3tcnDkrD+QCbwv8dCrkDiTPSYpltsZM6O5qy9NFUjEONRIDe3Rx1RPpj89WEyOHNDvO51ztcTpkmbBqRXzJpLqCksuhc/tyzVCCPmdhiFPuwqKhP/YMy2mwQjhNpjA7u9qE2cZ29HfeDOxn2+F0tpDOCUgrGxy8bydpBI5qX2Kv3SQDLEX4T8JhImkJDDELBI5tQI9HVkXL/UXATnUTegJhLGb3H3zXPjhRDGsWVvMF37iq2x0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5204a36d-7f14-4f9e-e7ac-08d6e5880682
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 05:22:50.5110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 4:26 PM, Herbert Xu wrote:=0A=
> On Thu, May 30, 2019 at 01:18:34PM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> I guess there are only two options:=0A=
>> -either cache line sharing is avoided OR=0A=
>> -users need to be *aware* they are sharing the cache line and some rules=
 /=0A=
>> assumptions are in place on how to safely work on the data=0A=
> =0A=
> No there is a third option and it's very simple:=0A=
> =0A=
I see this as the 2nd option.=0A=
=0A=
> You must only access the virtual addresses given to you before DMA=0A=
> mapping or after DMA unmapping.=0A=
> =0A=
Unless it's clearly defined *which* virtual addresses mustn't be accessed,=
=0A=
things won't work properly.=0A=
In theory, any two objects could share a cache line. We can't just stop all=
=0A=
memory accesses from CPU while a peripheral is busy.=0A=
=0A=
Thanks,=0A=
Horia=0A=
