Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E31EC282CC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDC121919
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="jOiWNVEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBHIln (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:41:43 -0500
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:30099
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfBHIln (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 03:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbK5iFNu3jnglG2HexT5DFvO5PEARhjQiAfYHNJ4eBQ=;
 b=jOiWNVEY5WFVEiA0r0vzz6nYceMHECoin9aq5/ByVeGH2oH3keAE4kKX6YvVO7NwSthRFsDaBLvVTnFvz1Vr4HMd8nZiPlYdnr6Jpfr5W6nb8Tu1pdYDUMnj2DkOLdS0D2IUiPg+9D5qBioyEXjxHtjn8mX3ihX2CvQZmCRIR5s=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3583.eurprd04.prod.outlook.com (52.134.4.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Fri, 8 Feb 2019 08:41:37 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1580.019; Fri, 8 Feb 2019
 08:41:37 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Thread-Topic: [PATCH] crypto: caam - Do not overwrite IV
Thread-Index: AQHUuSvyCmTFYLEeOE2P2XtmnR+/Zg==
Date:   Fri, 8 Feb 2019 08:41:37 +0000
Message-ID: <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3583;6:96GFhnYL0iRFjo+1tRy1peWMYAirc5tl2sHagSkTlZvqWTb2e5i3VEdVuiDmhY0UwsvreNnJtABLhGkqauHTTzLVp42tdjt+M9S7g1O/x7defGt3FtIiJPDpfAASbkQ/yPtrW96AnOJaGCHQygTB9GMDc98ldJBDwhUK8prJgzAFCg1w6SzPKAihpG5vGM1f+Mv4PahPw1lR+h8lCfBs9xJcHht4eH1dUuWm0tb24P/PJZg2RMw6jtEDT5elSfTppEEqffDdkyJC0gUsiaiMkORXeRlVQXLPW2m4nKcToL3nAZ2WPr+ehqaYNYRMV+WvKpm4EHtgJKyTqAp9AMuOYwGzc7UKaHu2sqFwur7YdC5o8w+4SKRv65yYZ/MfhPIDwMC7CMl4a1l+7R5wt/MYpILoktKpK9c9G2qOORgwE6HpJntiS4mQ35jDWzuUw/uuuMgytLAEgKRrUTXFd7iXPQ==;5:Zxc0t6JNJUGXsrgNdtBlyO7oRju6tCoow/4oxcHuG+4geUM6Wd4s1I4EWmS7UywPvgUfqkYb0RB1tK7EXlEbhEQ13Ei9e8cIwOTV4vjPtuqBIs/WNunPbjKHB6Z7DbOENlqLQOAPrz1iVSoNocPJ8ZiVSNvG8loslTvJuDBVepgQ9QU3n3hdZDM4iy3H/eLL72xbZbaEMUz4wdpAWzAbOw==;7:U4AuLK3veKK4Cs4tRRQi3wh5x5xqnJRjTOFKuyhIvN0lzCDj7ISN3X5LoBXvWgjfRzKWjP9wnRpHbqxDObobsgjH4CnLygflgdtOtflAIuSdyaEjNjpQFRi1oFG0ydCcGWYyQhIgwMDXPTHgmCaPbg==
x-ms-office365-filtering-correlation-id: 78bc3ab4-04bc-45fb-032f-08d68da13d10
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3583;
x-ms-traffictypediagnostic: VI1PR0402MB3583:
x-microsoft-antispam-prvs: <VI1PR0402MB3583AC70D6174503AF340FFA98690@VI1PR0402MB3583.eurprd04.prod.outlook.com>
x-forefront-prvs: 094213BFEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(136003)(346002)(189003)(199004)(55016002)(478600001)(53936002)(71200400001)(229853002)(9686003)(6246003)(71190400001)(6436002)(6116002)(4326008)(14444005)(6916009)(68736007)(256004)(25786009)(3846002)(7696005)(53546011)(6506007)(7736002)(76176011)(66066001)(476003)(14454004)(446003)(105586002)(186003)(74316002)(8936002)(99286004)(33656002)(26005)(316002)(102836004)(81166006)(81156014)(106356001)(8676002)(305945005)(54906003)(97736004)(2906002)(44832011)(486006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3583;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UTQ3f22L75eOGBL0kbbFE+LuEnK9TerN/5zTt1cQFpK3t6stTBr27FGbVdmxqx4jfRRbDlzcZ2/vxofswMR1ZYTPbr+G0P7bMW8InGI7gIT6Uohj0/EayKTyczSzzRHJbJAO0g7Le40K7AGtqOtvVIGDQhhxXfO81g/jodHfNfCOXGaIDYfm0h25KqJc385E7sux6NMAVxmwfyOCfWhV75eZHXbw1Kl4IbUZgYc6mLm+RVnB2imyzYg72ig09Y+P6bV/hefzKbCJ+t7xjEYmMp9Uf4n417SwKh+kM/s14szeW5ZFrgsaznPCyGt+klFyibrRP8V6whTjRKo2d4+ameJzRg2YLvsYk/6xiXYvdCy7UfdES5tyJ7AfWOwOGEUEIxJEs5ez8898mGT3ujRcll+GyxB/7KEpTW1qtYuRDF4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bc3ab4-04bc-45fb-032f-08d68da13d10
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2019 08:41:37.1923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/8/2019 9:16 AM, Herbert Xu wrote:=0A=
> On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:=0A=
>>=0A=
>> The root cause of the issue is cache line sharing.=0A=
>>=0A=
>> struct crypto_gcm_req_priv_ctx {=0A=
>>         u8 iv[16];=0A=
>>         u8 auth_tag[16];=0A=
>> 	[...]=0A=
>> };=0A=
>>=0A=
>> Since caam does not support ghash on i.MX6, only ctr skcipher part of th=
e gcm is=0A=
>> offloaded.=0A=
>> The skcipher request received by caam has req->src pointing to auth_tag[=
16] (1st=0A=
>> S/G entry) and req->iv pointing to iv[16].=0A=
>> caam driver:=0A=
>> 1-DMA maps req->src=0A=
>> 2-copies original req->iv to internal buffer=0A=
>> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)=
=0A=
>> 4-sends job to crypto engine=0A=
>>=0A=
>> Problem is that operation 3 above is writing iv[16], which is on the sam=
e cache=0A=
>> line as auth_tag[16] that was previously DMA mapped.=0A=
>>=0A=
>> I've checked that forcing auth_tag and iv to be on separate cache lines=
=0A=
>> -       u8 auth_tag[16];=0A=
>> +       u8 auth_tag[16] ____cacheline_aligned;=0A=
>> solves the issue.=0A=
>>=0A=
>> OTOH, maybe the fix should be done in caam driver, by avoiding any write=
s=0A=
>> (touching any data, even seemingly unrelated req->iv) after DMA mapping=
=0A=
>> req->src, req->dst etc.=0A=
>> Having req->iv and req->src sharing the same cache line is unfortunate.=
=0A=
>>=0A=
>> Herbert, what do you think?=0A=
> =0A=
> Well just like the other cases if your input is a kernel pointer you=0A=
> must not perform DMA on it.  Only SG lists can be used for DMA.=0A=
> =0A=
As I said at point 2 above, req->iv is copied to an internal buffer, which =
is=0A=
allocated using kmalloc.=0A=
=0A=
> So the IV needs to be copied on completion.=0A=
> =0A=
Is it mandatory to be copied *on completion*?=0A=
In some cases implementations could update req->iv before completion - for =
e.g.=0A=
in case of cbc decryption the last block from req->src is copied into req->=
iv=0A=
before the engine performs decryption (to avoid in-place decryption, where =
the=0A=
last block would be overwritten).=0A=
=0A=
I'll try to explain issue at hand in more detail.=0A=
=0A=
------------------=0A=
|       IV       |=0A=
------------------=0A=
|  input buffer  |=0A=
------------------=0A=
=0A=
Consider that the skcipher implementation receives, via crypto API, a reque=
st=0A=
with req->IV pointing to "IV" and, for simplicity, a 1-entry req->src=0A=
scatterlist pointing at "input buffer".=0A=
=0A=
In caam's particular case (and for decryption):=0A=
a-req->src is DMA mapped=0A=
b-req->iv is overwritten with last block of req->src=0A=
c-crypto engine executes decryption (using the original value of req->iv)=
=0A=
=0A=
If IV and input buffer are on the same cache line, there is a problem when =
the=0A=
device is non-coherent (i.MX case) since CPU is touching part of the cache =
line=0A=
(writing the IV) after DMA API mapping was called for the same cacheline=0A=
(req->src -> input buffer).=0A=
=0A=
I don't think we could ask an implementation to be aware of the memory layo=
ut of=0A=
req->iv and req->src (and req->dst etc.) buffers.=0A=
=0A=
If I am not mistaken, req->src for skcipher request in crypto/gcm.c is brea=
king=0A=
one of the DMA API rules - Documentation/DMA-API.txt:=0A=
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
So if there is a real intention to support offloading skcipher, as this old=
=0A=
commit suggests:=0A=
=0A=
84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")=0A=
    This patch adds the necessary changes for GCM to be used with async=0A=
    ciphers.  This would allow it to be used with hardware devices that=0A=
    support CTR.=0A=
=0A=
then we must take special care when building skcipher req->src and avoid ha=
ving=0A=
it's first entry (auth_tag[16] in crypto_gcm_req_priv_ctx structure) sharin=
g a=0A=
cache line with req->iv.=0A=
=0A=
Thanks,=0A=
Horia=0A=
