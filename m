Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0205AC282D7
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 11:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C543F2080D
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 11:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qqAES8w3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfBELt5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:49:57 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:45056
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfBELt5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 06:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4Hktep0crnTFxZMzesxwWKViaAdHmhW/Ne95fbdFXA=;
 b=qqAES8w3f3AfTumR2b5ttFv9wLnbl3KpLB9w9pGkxu7albXQaf7RO1NaetAxBd/HyuSIJtrdm4s60fH8KpCZOoKNzISNAl83ME/D0sc773lfBN1TsIWghkN0BRCULJowCN/C8qnaN87bK/5x3IjfdFuBBjVrf25huwTimmhQJvc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3392.eurprd04.prod.outlook.com (52.134.1.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.23; Tue, 5 Feb 2019 11:49:53 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 11:49:53 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Thread-Topic: [PATCH] crypto: caam - Do not overwrite IV
Thread-Index: AQHUuSvyCmTFYLEeOE2P2XtmnR+/Zg==
Date:   Tue, 5 Feb 2019 11:49:52 +0000
Message-ID: <VI1PR0402MB34852118C52B0A0CB409A8F6986E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190205083146.icnk3y46vonpxsin@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0402MB3392;6:u5WZAba4ElAjym4nB0K0LCbZGVURSPwlDgiDOlQnAnhFd4DFsAoZgTwd0U+8jlkXzjB/Ak+cRnq3ntah8iaDEH4MTAKEa0Gz567PUsC2Lur+eAQB9ByHOyCOZP+Sx2UmHWCoJBO1yN4UXSptCU/v49JN10RRqkBknJPxw/rjgEkNSIZxUkks4dHKdd0PlHO1GQy6ZXril9Ay663teATLB1feyE2agemyf8Hqo2uh2JPzBZpmRKT2kC9NXjyv0kE8pRV1JdaBScFBlwalM/NgVthHVi5E31AHX7F4JLZE8Y06r5ANImvnKvXdMn5KXvHXoq7/VTxPXIJ+MKLhe75ExLjKsf5yMBJ3giTP9fPqfV7BwarSXNPgi8g1MTOtZtdKUVl7CWNm00qIO2j3QRjhcLOSRdkZGjZZrfbFLAQYZCvhLCIuRo5pUfk7oPpli8pTQ/TwDoQMJynU4cpa6o+6+g==;5:X4Ybt5jv6ADB3JvZS3Z4NYBj5YIOqyCY+uznqRiVqQ+5rGzh9HVe0Gc+8qmdP4XafLLOBUF4rt457OtL0LrZdorqKi6yD3w4ciiEDQzS4lMWX5tHfs/UQWcH1iSctCGQwI87KeGz+h+njz/8E/lhFTwCu+d8k72NXmauPFjhZtHysJccgX9Lax2s65vpo5XS0w7hs4pmkweHUjSa2EOjcg==;7:T4RljGAAexyVk24JLSKvct9qp6vUskukFvXpn9j2ScJXgu4bETr4+ihFv1RZR6EzXzxRQmpkm1k5TzCM/1wDBuFQCaGR8jaQlB3NDGzmTvPhWhU1PEU8Z/j36gK0L+Jp1vZhIRpcr4uj23bcQPOK9w==
x-ms-office365-filtering-correlation-id: 1b700e07-daeb-4666-43ae-08d68b600a9d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3392;
x-ms-traffictypediagnostic: VI1PR0402MB3392:
x-microsoft-antispam-prvs: <VI1PR0402MB3392D63A453D90376C172D51986E0@VI1PR0402MB3392.eurprd04.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(74316002)(229853002)(54906003)(9686003)(55016002)(6306002)(6916009)(53936002)(256004)(14444005)(3846002)(6116002)(316002)(6436002)(99286004)(7696005)(71200400001)(71190400001)(4326008)(68736007)(6246003)(25786009)(76176011)(2906002)(86362001)(33656002)(446003)(486006)(105586002)(44832011)(476003)(8676002)(102836004)(26005)(81166006)(81156014)(8936002)(6506007)(53546011)(97736004)(305945005)(7736002)(66066001)(186003)(478600001)(14454004)(966005)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3392;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dwY58Z7vLLteR6Iv4547uCl8SQoUBuC4JnlXetWvzKWkd1BP97CxDKhoeNuUwc6vyXElt3z5o7XJGwI3A33JYOprBV4+GWMtA/iqJJ0He8nKNONVh4gZVth/RbPPL0IywIGWpJbSggAvSjDnm6dVGVaHyA9KcghCbng2PjhalcA8IATTtkMg8NY6r89iY180N2w+W04YY4rCHtkCHZtb/80PdrBH4OLPkfO7cQCZOf/4U4CHCVgkUeo1TB0BrAYAi4okhpUyZyW17k1Ct3ODzYTBQnoyqr49w3f9egtQZcQVQK/sv51es0uTQeCeII1P1z1p5lr2ifT9BKyOz7fx3SxoKHcBrQbDHTnnOsU5fMVJ4xEeGnulMn1iTwhxLSnvI3QTRjEZfKXi6eS5T6FjVLVGCc3RpBp6lmOleti7LiE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b700e07-daeb-4666-43ae-08d68b600a9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 11:49:52.9793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3392
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/5/2019 10:31 AM, Sascha Hauer wrote:=0A=
> Hi Horia,=0A=
> =0A=
> On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:=0A=
>> On 1/31/2019 8:12 AM, Sascha Hauer wrote:=0A=
>>> In skcipher_decrypt() the IV passed in by the caller is overwritten and=
=0A=
>>> the tcrypt module fails with:=0A=
>>>=0A=
>>> alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-=
generic): ret=3D74=0A=
>>> alg: aead: Failed to load transform for gcm(aes): -2=0A=
>>>=0A=
>>> With this patch tcrypt runs without errors.=0A=
>>>=0A=
>> This doesn't mean the patch is correct.=0A=
>> crypto API requires skcipher implementations to update the IV with the l=
ast=0A=
>> ciphertext block.=0A=
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
> =0A=
> I can confirm that this solves it here on my side aswell.=0A=
> =0A=
Thanks for confirming.=0A=
=0A=
> I have no idea what's best to do here, but I'd like to have that fixed.=
=0A=
> =0A=
Yes, me too.=0A=
I would wait for Herbert's input though. As I said, it's a bit weird for a=
=0A=
skcipher implementation to be aware of updating req->iv having such a side=
=0A=
effect on req->src.=0A=
=0A=
> Is there some easy to reproduce testcase to show the issues that arise=0A=
> with my patch? Apparently tcrypt doesn't do chaining, right?=0A=
> =0A=
In theory cts(cbc(aes)) decryption would have to fail when cbc(aes) would=
=0A=
execute on caam and cts() in SW.=0A=
=0A=
However, cts() SW implementation (crypto/cts.c) does not rely on underlying=
=0A=
cbc(aes) to update the IV, instead it uses a temporary saved IV - see discu=
ssion=0A=
here:=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg27719.html=0A=
=0A=
Horia=0A=
=0A=
