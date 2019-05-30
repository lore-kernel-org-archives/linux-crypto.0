Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2049AC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB6C025694
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 07:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="G6ik2JFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE3HrO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 03:47:14 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:1933
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbfE3HrN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 03:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu8ody0B788MoHcMObvsSRBH5BL87/RrxpClRusCouE=;
 b=G6ik2JFtgPa30ylK/By+7Zrhr6WlZkPjGG37vfT9IC4meXmW2GvH+tSGUIJCuUWo+a1lhBm840e26xn+xVnJpeI3S3TKZipFv/7xvAqV9ys7rcsfbxcmjD0YqY6C+JUSQbutIy8Bbh6ZdlXtLwmi+NrnRBXuckJIu9vCEAiQC1g=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3503.eurprd04.prod.outlook.com (52.134.4.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 30 May 2019 07:46:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 07:46:29 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF+dOvdDzZqYUSH856vNqfARw==
Date:   Thu, 30 May 2019 07:46:29 +0000
Message-ID: <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e22427a-0e4f-493c-4701-08d6e4d2ed6d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3503;
x-ms-traffictypediagnostic: VI1PR0402MB3503:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB35033ACF36CE4AE3B0F946F298180@VI1PR0402MB3503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(376002)(39860400002)(346002)(199004)(189003)(66066001)(26005)(53936002)(305945005)(6246003)(55016002)(44832011)(5660300002)(7736002)(71200400001)(86362001)(486006)(25786009)(4326008)(52536014)(9686003)(71190400001)(14444005)(6306002)(73956011)(64756008)(110136005)(66556008)(66476007)(66946007)(476003)(33656002)(14454004)(66446008)(2906002)(256004)(54906003)(68736007)(74316002)(99286004)(186003)(8936002)(76116006)(91956017)(316002)(6436002)(229853002)(478600001)(102836004)(8676002)(81156014)(81166006)(3846002)(53546011)(6506007)(966005)(6116002)(76176011)(446003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3503;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LHYPDfIx1oic4LXVX2Axv5zsf4doEGTwqD5xSlHpthVNZS4vpu1kAvQnYIeLjOS+lVQTslWoQBvpD7amh7F3DTx3tvoSVuwLV7hC4kq6pBomtp1HCcv/DjRiOZ1arRshspYzCROVFDGdxn6PGsOFycXsXr4Prpk7QF5v9J5wGAVvm0qQ/BuqXm4xB68oC2ndi+VhCuqWWSzXuCxXfSsS/pxj9DUrmiVXLlJ0fyft5iX3WWLBshJGCQ9+USRVva4nz7dR5TtCwXxDpUCLy2z1LqLbDer0lCWJN2NuhYvAE/7yfelinvCOnHiWVweFlqEQNY2OsQZ0V08Q3dQawLVz7nmBCXYvKvh3vTh5/vOvZM0R0tmE9MtNIgSRU36WIdee6G1UKO4jgoI9RetYJwlDTMC/a7nCYdE4xRwhffKto5A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e22427a-0e4f-493c-4701-08d6e4d2ed6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 07:46:29.5981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3503
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 8:34 AM, Herbert Xu wrote:=0A=
> On Wed, May 29, 2019 at 01:27:28PM -0700, Eric Biggers wrote:=0A=
>>=0A=
>> So what about the other places that also pass an IV located next to the =
data,=0A=
>> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to mak=
e this a=0A=
Fix for ccm is WIP.=0A=
We were not aware of adiantum since our crypto engine does not accelerate i=
t.=0A=
=0A=
>> new API requirement, then we need to add a debugging option that makes t=
he API=0A=
>> detect this violation so that the other places can be fixed too.=0A=
>>=0A=
IMO this is not a new crypto API requirement.=0A=
crypto API and its users must follow DMA API rules, besides crypto-specific=
 ones.=0A=
=0A=
In this particular case, crypto/gcm.c is both an implementation and a crypt=
o API=0A=
user, since it uses underneath ctr(aes) (and ghash).=0A=
Currently generic gcm implementation is breaking DMA API, since part of the=
 dst=0A=
buffer (auth_tag) provided to ctr(aes) is sharing a cache line with some ot=
her=0A=
data structure (iv).=0A=
=0A=
The DMA API rule is mentioned in Documentation/DMA-API.txt=0A=
=0A=
.. warning::=0A=
=0A=
        Memory coherency operates at a granularity called the cache=0A=
        line width.  In order for memory mapped by this API to operate=0A=
        correctly, the mapped region must begin exactly on a cache line=0A=
        boundary and end exactly on one (to prevent two separately mapped=
=0A=
        regions from sharing a single cache line).=0A=
=0A=
=0A=
>> Also, doing a kmalloc() per requset is inefficient and very error-prone.=
  In=0A=
>> fact there are at least 3 bugs here: (1) not checking the return value, =
(2)=0A=
>> incorrectly using GFP_KERNEL when it may be atomic context, and (3) not =
always=0A=
For (2) I assume this means checking for CRYPTO_TFM_REQ_MAY_SLEEP flag.=0A=
=0A=
>> freeing the memory.  Why not use cacheline-aligned memory within the req=
uest=0A=
>> context, so that a separate kmalloc() isn't needed?=0A=
>>=0A=
If you check previous discussion referenced in the commit message:=0A=
Link:=0A=
https://lore.kernel.org/linux-crypto/20190208114459.5nixe76xmmkhur75@gondor=
.apana.org.au/=0A=
=0A=
or (probably easier) look at the full thread:=0A=
https://patchwork.kernel.org/patch/10789697/=0A=
=0A=
you'll see that at some point I proposed changing crypto_gcm_req_priv_ctx s=
truct=0A=
as follows:=0A=
-       u8 auth_tag[16];=0A=
+       u8 auth_tag[16] ____cacheline_aligned;=0A=
=0A=
Ard suggested it would be better to kmalloc the auth_tag.=0A=
=0A=
I am open to changing the fix, however I don't think the problem is in the=
=0A=
implementation (caam driver).=0A=
=0A=
>> Also, did you consider whether there's any way to make the crypto API ha=
ndle=0A=
>> this automatically, so that all the individual users don't have to?=0A=
That would probably work, but I guess it would come up with a big overhead.=
=0A=
=0A=
I am thinking crypto API would have to check each buffer used by src, dst=
=0A=
scatterlists is correctly aligned - starting and ending on cache line bound=
aries.=0A=
=0A=
> =0A=
> You're absolutely right Eric.=0A=
> =0A=
> What I suggested in the old thread is non-sense.  While you can=0A=
> force GCM to provide the right pointers you cannot force all the=0A=
> other crypto API users to do this.=0A=
> =0A=
Whose problem is that crypto API users don't follow the DMA API requirement=
s?=0A=
=0A=
> It would appear that Ard's latest suggestion should fix the problem=0A=
> and is the correct approach.=0A=
> =0A=
I disagree.=0A=
We shouldn't force crypto implementations to be aware of such inconsistenci=
es in=0A=
the I/O data buffers (pointed to by src/dst scatterlists) that are supposed=
 to=0A=
be safely DMA mapped.=0A=
=0A=
Thanks,=0A=
Horia=0A=
