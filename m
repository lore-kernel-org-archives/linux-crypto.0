Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6ECC28CC3
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 05:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0490F26417
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 05:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="j6QXK/uv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfEaFym (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 01:54:42 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:44622
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbfEaFym (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 01:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9KvCdF2OUa8sLZWIjPFK/ED4GXgsMhavpNvHe4TQcM=;
 b=j6QXK/uv4etP6gy6j4z78O1WL9EbVK9LmBcLxI7PcmNT06WCpjwGcf8iEB9Cb0KHz4L/SKGYFZ+BVnPIh6xOEX4G1J+STwr5quPdlDG3GlpEV0SjXnBrWQCHpmNrE7u7TDO+8NaLyBGUMP/zvI8aowO4s5tv/JdZuVVtegVsV+o=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3806.eurprd04.prod.outlook.com (52.134.16.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 05:54:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 05:54:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF+dOvdDzZqYUSH856vNqfARw==
Date:   Fri, 31 May 2019 05:54:37 +0000
Message-ID: <VI1PR0402MB34858358EB89E8DF051729E598190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
 <20190530143438.d62y3woaogyivqpm@gondor.apana.org.au>
 <CAKv+Gu87wkLkZZLfsJwc02yuKpDx7Sa=Nx+1YW8pPE4DoWXGRw@mail.gmail.com>
 <VI1PR04MB44453A74B90C08AF14CED7DE8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 362b3f52-8032-4ef8-0e1a-08d6e58c776c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3806;
x-ms-traffictypediagnostic: VI1PR0402MB3806:
x-microsoft-antispam-prvs: <VI1PR0402MB380616A0CE711B21BB83FCB498190@VI1PR0402MB3806.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(396003)(376002)(366004)(54094003)(199004)(189003)(316002)(6246003)(7696005)(4326008)(53936002)(229853002)(14444005)(33656002)(478600001)(14454004)(6116002)(55016002)(99286004)(6506007)(76176011)(81166006)(26005)(53546011)(110136005)(81156014)(9686003)(68736007)(86362001)(256004)(6436002)(8676002)(66066001)(7736002)(8936002)(64756008)(25786009)(54906003)(486006)(74316002)(76116006)(5660300002)(2906002)(66476007)(102836004)(73956011)(66446008)(305945005)(66556008)(52536014)(446003)(71200400001)(186003)(44832011)(66946007)(476003)(71190400001)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3806;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RSVrf2KHsQvAQM1Onl/fxdQ/d8sKcNIPuFf/chclyulzB6Djx12fLV9bXVlaX5C9ypx9Xlm2DIf0M+tftDaUJ/hhaCTKHFsSUt9Pw6K4ZL7jQfDkvohOpa8KkquXsphEQgv1xM12motjB+d7dUlqYBylwY26l87hQUs3wR2ur2I6kTe9Ua2So3Z7VTeRrcT19Zdeg1F1XtFGgIlqVoBboenc/usOWfB/X5OZMVFnjKo6jXhXEMBfn4jDyEGFdKXyL+0yM5kwKKSrLdQGzCWiRga3w3/SPYJJgluwyTK4pkerNhielkYH6hDpf+PgeD6E3+ZpuE0SWJo1n9CB3pw5EHsu3Zyxyvv2GFlysJV+ENLjUQtmjYPpL7+XplwX/+kU335/4UvUnZxzbUraQzJW7NF9KPxGn5Hlx7mSbdb7S2g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362b3f52-8032-4ef8-0e1a-08d6e58c776c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 05:54:37.9817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3806
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/31/2019 1:00 AM, Iuliana Prodan wrote:=0A=
> On 5/30/2019 6:05 PM, Ard Biesheuvel wrote:=0A=
>> On Thu, 30 May 2019 at 16:34, Herbert Xu <herbert@gondor.apana.org.au> w=
rote:=0A=
>>>=0A=
>>> On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:=0A=
>>>>=0A=
>>>> This might work:=0A=
>>>=0A=
>>> Looks good to me.=0A=
>>>=0A=
>>=0A=
>> Thanks Herbert,=0A=
>>=0A=
>> But given your remark regarding CBC being the only algo that has this=0A=
>> requirement, I wonder if this might be sufficient as well.=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg=
.c=0A=
>> index c0ece44f303b..65b050e3742f 100644=0A=
>> --- a/drivers/crypto/caam/caamalg.c=0A=
>> +++ b/drivers/crypto/caam/caamalg.c=0A=
>> @@ -1844,7 +1844,7 @@ static int skcipher_decrypt(struct skcipher_reques=
t *req)=0A=
>>           * The crypto API expects us to set the IV (req->iv) to the las=
t=0A=
>>           * ciphertext block.=0A=
>>           */=0A=
>> -       if (ivsize)=0A=
>> +       if (ctx->cdata.algtype & OP_ALG_AAI_CBC)=0A=
>>                  scatterwalk_map_and_copy(req->iv, req->src, req->cryptl=
en -=0A=
>>                                           ivsize, ivsize, 0);=0A=
>>=0A=
>>=0A=
>> Iulia, Horia?=0A=
>>=0A=
> I can confirm that gcm (and ccm), with ctr-aes-caam, is passing with the =
=0A=
> above fix.=0A=
> =0A=
The check should be:=0A=
	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) =3D=3D OP_ALG_AAI_CBC)=0A=
=0A=
Having this workaround is probably ok, until we properly fix the IV update =
for=0A=
CTR mode.=0A=
=0A=
Thanks,=0A=
Horia=0A=
