Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52414C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B74D259AE
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fYORt5X7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfE3N3t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:29:49 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:23170
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726825AbfE3N3s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+Q9LdKVyud2zOKYVwhv4HC8UOhhStGkt8AiQWexonM=;
 b=fYORt5X7qRD5M/E4C2ORqxF0q7xJe1N8cWrpBolI3AO9O8nF+luzx35Xib3jaWU6v+YmjolNfo3ND3lYbbyN1WBnANPPKc36DY0Slwx5tKz4NvAYAMwwNxgzzMLFKiERzdvzUvPvc12nX+02oQwzv19Exu1ems9bhmpYg7aq+aQ=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4815.eurprd04.prod.outlook.com (20.177.48.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 13:29:41 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872%7]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 13:29:41 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF/PjPULMOhfkiEXDJZ6fiBzQ==
Date:   Thu, 30 May 2019 13:29:41 +0000
Message-ID: <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1320404-74f1-498a-d8a4-08d6e502df39
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4815;
x-ms-traffictypediagnostic: VI1PR04MB4815:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR04MB48156393F0F253F26C9155118C180@VI1PR04MB4815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(396003)(346002)(366004)(189003)(199004)(44832011)(7696005)(81166006)(99286004)(6306002)(2906002)(76176011)(33656002)(6506007)(66946007)(486006)(6246003)(76116006)(25786009)(66446008)(110136005)(7736002)(4326008)(476003)(305945005)(66476007)(8676002)(64756008)(53546011)(73956011)(81156014)(66556008)(446003)(54906003)(229853002)(45080400002)(74316002)(8936002)(6436002)(966005)(5660300002)(14454004)(71190400001)(86362001)(26005)(9686003)(256004)(66066001)(14444005)(102836004)(6116002)(52536014)(186003)(53936002)(71200400001)(55016002)(68736007)(478600001)(3846002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4815;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nDS9QpVa+AAMrpPvAC3o+dgyHdjZJ6EUpdSzU1rkgxXe/Ybnsf8UfDdHGMH7aQ+pbASDCvQmJVIjBiitT7Xi5EYUODykroGPq7ft4qVss9P2jpDA42o94H7e3Yds4vlXXbuQ7HwqNqKieGij/XdSZXM8PxI++c2eF5jKWA1k27q5i/ndbKG/BIDaMOkkA86nQw7qqw0T1SnvzAzDgt6d6NJuG0TGbAPKVXjI8CEdEsw7XydmAVOn2NO8UoBgC5X0xLsZhPBCDUZL2fMTja1uuddXwUiHo5rqcn+AvB0WFsfwhVddgo8xLkakMl0LOoN+XGZ5ToQQtbJHl2vU1ngNBXBeO3uAM+2k8mxyqNUmd+mDXoA92PVDJrbybuX+FaqtiEuVLaQVssxTjo/3bHKX9A2SsZ6Jq25KzZ9yUuYceII=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1320404-74f1-498a-d8a4-08d6e502df39
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 13:29:41.6339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4815
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 1:16 AM, Ard Biesheuvel wrote:=0A=
> On Wed, 29 May 2019 at 22:27, Eric Biggers <ebiggers@kernel.org> wrote:=
=0A=
>>=0A=
>> On Wed, May 29, 2019 at 08:10:56PM +0300, Iuliana Prodan wrote:=0A=
>>> The generic GCM driver should ensure that whatever it passes into=0A=
>>> scatterlists is safe for non-cache coherent DMA.=0A=
>>> The issue was seen while running GCM on CAAM driver. But, since CAAM=0A=
>>> does not support GHASH on i.MX6, only CTR skcipher part of the GCM is=
=0A=
>>> offloaded.=0A=
>>> The skcipher request received by CAAM has req->src pointing to=0A=
>>> auth_tag[16] and req->iv pointing to iv[16]. Problem is that when=0A=
>>> the iv is updated (crypto API requires skcipher implementations to=0A=
>>> update the IV with the last ciphertext block) is written in iv[16],=0A=
>>> which is on the same cacheline as auth_tag[16] that was previously=0A=
>>> DMA mapped.=0A=
>>> Solution is to use a pointer, aligned to cache line, instead of auth_ta=
g=0A=
>>> buffer, for encryption/decryption and then free it on completion.=0A=
>>>=0A=
>>> Link: https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F=
%2Flore.kernel.org%2Flinux-crypto%2F20190208114459.5nixe76xmmkhur75%40gondo=
r.apana.org.au%2F&amp;data=3D02%7C01%7Ciuliana.prodan%40nxp.com%7C8426e8db8=
5774c4e829308d6e4834cf6%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C636947=
649914200400&amp;sdata=3DFq%2F83lofKoEnz7HnzY1jjU1jUi0b2QmVZPfZrzWXtrk%3D&a=
mp;reserved=3D0=0A=
>>> Cc: <stable@vger.kernel.org> # v4.19+=0A=
>>> Fixes: adcbc688fe2f ("crypto: gcm - Convert to new AEAD interface")=0A=
>>> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
>>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>>>=0A=
> ...=0A=
>> So what about the other places that also pass an IV located next to the =
data,=0A=
>> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to mak=
e this a=0A=
>> new API requirement, then we need to add a debugging option that makes t=
he API=0A=
>> detect this violation so that the other places can be fixed too.=0A=
>>=0A=
>> Also, doing a kmalloc() per requset is inefficient and very error-prone.=
  In=0A=
>> fact there are at least 3 bugs here: (1) not checking the return value, =
(2)=0A=
>> incorrectly using GFP_KERNEL when it may be atomic context, and (3) not =
always=0A=
>> freeing the memory.  Why not use cacheline-aligned memory within the req=
uest=0A=
>> context, so that a separate kmalloc() isn't needed?=0A=
>>=0A=
>> Also, did you consider whether there's any way to make the crypto API ha=
ndle=0A=
>> this automatically, so that all the individual users don't have to?=0A=
>>=0A=
> =0A=
> Reading back that old thread, it appears that the core issue is that=0A=
> the IV is copied when the scatterlist is already mapped for DMA. This=0A=
> means the cacheline covering the IV and the auth tag is dirty while=0A=
> the non-coherent DMA transaction takes place, and given that we clean=0A=
> rather than invalidate the start and end of DMA mappings if they are=0A=
> not aligned to the cache writeback granule size, whatever sits in the=0A=
> cacheline overwrites whatever the device wrote in there.=0A=
> =0A=
> Iuliana, did you try pulling the IV copy forward? I.e.,=0A=
=0A=
I've tried coping the IV before the extended descriptor allocation, but =0A=
is not working and to make it work will need to make more changes in =0A=
CAAM. We need the original iv, and if we move it before =0A=
skcipher_edesc_alloc we lose it.=0A=
The fix exclusively in CAAM drv, to copy iv before DMA map, is more complex=
.=0A=
=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index c0ece44f303b..11e91c0c9a96 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -1835,11 +1835,6 @@ static int skcipher_decrypt(struct skcipher_reques=
t *req)=0A=
>          u32 *desc;=0A=
>          int ret =3D 0;=0A=
> =0A=
> -       /* allocate extended descriptor */=0A=
> -       edesc =3D skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ=
);=0A=
> -       if (IS_ERR(edesc))=0A=
> -               return PTR_ERR(edesc);=0A=
> -=0A=
>          /*=0A=
>           * The crypto API expects us to set the IV (req->iv) to the last=
=0A=
>           * ciphertext block.=0A=
> @@ -1848,6 +1843,11 @@ static int skcipher_decrypt(struct skcipher_reques=
t *req)=0A=
>                  scatterwalk_map_and_copy(req->iv, req->src, req->cryptle=
n -=0A=
>                                           ivsize, ivsize, 0);=0A=
> =0A=
> +       /* allocate extended descriptor */=0A=
> +       edesc =3D skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ=
);=0A=
> +       if (IS_ERR(edesc))=0A=
> +               return PTR_ERR(edesc);=0A=
> +=0A=
>          /* Create and submit job descriptor*/=0A=
>          init_skcipher_job(req, edesc, false);=0A=
>          desc =3D edesc->hw_desc;=0A=
> =0A=
> This should ensure that the cacheline is cleaned when the DMA mapping=0A=
> is created.=0A=
> =0A=
=0A=
Thanks,=0A=
Iulia=0A=
