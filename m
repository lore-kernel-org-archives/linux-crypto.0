Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96030C28CC3
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60A982642F
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 06:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="s+qkuG2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaGFM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 02:05:12 -0400
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:34514
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfEaGFM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 02:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cexnX76HJAUYQU8pvLDLRAF9I9f40LZxfLa+17DRNWA=;
 b=s+qkuG2LD0Z07YrqXo5MPAcXvZF3LNMn8w2WPT6E3qG9XeFBqHyILG+FzdprRgDZpFWoywaUQWzNEIkhRsjoxam4UNiLjeT6wflAP4gFZSxdxnsNLzsAvwZaVjCJJLRmdOLRCktw0b2A93a1Z3O82wHlwnk/X9QB0Tzgn45+xHw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2943.eurprd04.prod.outlook.com (10.175.24.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Fri, 31 May 2019 06:05:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 06:05:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF+dOvdDzZqYUSH856vNqfARw==
Date:   Fri, 31 May 2019 06:05:06 +0000
Message-ID: <VI1PR0402MB3485E750B15281E7227EC49198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com>
 <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu_ucBhuK0YgGZ+Qhv4zqvU868GVRpWY7KVaTsj0O8k3OQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d0da71-9492-4713-d8e8-08d6e58dee24
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2943;
x-ms-traffictypediagnostic: VI1PR0402MB2943:
x-microsoft-antispam-prvs: <VI1PR0402MB2943332F9287F61F77F6D9DD98190@VI1PR0402MB2943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(366004)(396003)(199004)(189003)(44832011)(99286004)(86362001)(25786009)(478600001)(316002)(54906003)(26005)(7736002)(476003)(55016002)(305945005)(7696005)(486006)(66476007)(66556008)(64756008)(66446008)(9686003)(68736007)(52536014)(66946007)(73956011)(76116006)(446003)(76176011)(53546011)(66066001)(81166006)(81156014)(5660300002)(6506007)(6436002)(14444005)(53936002)(256004)(71200400001)(71190400001)(102836004)(8936002)(4326008)(33656002)(74316002)(229853002)(3846002)(6246003)(186003)(110136005)(8676002)(14454004)(2906002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2943;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C7jYVfeaATvCr1lTIXcncQRJYSoX3PVmNUCfefeK5guHAyz36NeZXJ+jy9nqG7WnIfgAfDGm/ZuHgvwwtzMQ04XLaQjNo4yLJysItNifNNxEivfo1IbkX7C55ItmReinrT2SJ9M/xjxZWroCywMzJZdHVOyeEpgUOnFC8zDEnT8VVAzJxXtlWuwCq1knq1kLKBXjbmxRBoda2dsPsuMHZOIPTKfZx9Aeu/ekW+vdhhqRJ966mTiHhgB09kvKfBtAdCp9ndY64Z9mYK1gC22fn+/RkbUJvz7rMBp8/cEYHdGQr8C45BmXXfmZznz8SCyc6wd/SeY3/whrBRKcIhSEF87YmID/TQBySGvWMsHX6eDI33XF82wCIV6Ffr/AkOr2f/IY/mw+dqg/OL9OW4geSqMwcT89P598jEZmt0dlP1o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d0da71-9492-4713-d8e8-08d6e58dee24
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 06:05:06.6466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2943
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 4:26 PM, Ard Biesheuvel wrote:=0A=
> On Thu, 30 May 2019 at 15:18, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>=0A=
>> On 5/30/2019 11:08 AM, Ard Biesheuvel wrote:=0A=
>>> On Thu, 30 May 2019 at 09:46, Horia Geanta <horia.geanta@nxp.com> wrote=
:=0A=
>>>>=0A=
>>>> On 5/30/2019 8:34 AM, Herbert Xu wrote:=0A=
>>>>> It would appear that Ard's latest suggestion should fix the problem=
=0A=
>>>>> and is the correct approach.=0A=
>>>>>=0A=
>>>> I disagree.=0A=
>>>> We shouldn't force crypto implementations to be aware of such inconsis=
tencies in=0A=
>>>> the I/O data buffers (pointed to by src/dst scatterlists) that are sup=
posed to=0A=
>>>> be safely DMA mapped.=0A=
>>>>=0A=
>>>=0A=
>>> I'm on the fence here. On the one hand, it is slightly dodgy for the=0A=
>>> GCM driver to pass a scatterlist referencing a buffer that shares a=0A=
>>> cacheline with another buffer passed by an ordinary pointer, and for=0A=
>>> which an explicit requirement exists that the callee should update it=
=0A=
>>> before returning.=0A=
>>>=0A=
>>> On the other hand, I think it is reasonable to require drivers not to=
=0A=
>>> perform such updates while the scatterlist is mapped for DMA, since=0A=
>>> fixing it in the callers puts a disproportionate burden on them, given=
=0A=
>>> that non-coherent DMA only represents a small minority of use cases.=0A=
>>>=0A=
>> The problem with this approach is that the buffers in the scatterlist co=
uld=0A=
>> hypothetically share cache lines with *any* other CPU-updated data, not =
just the=0A=
>> IV in the crypto request (as it happens here).=0A=
>> How could a non-coherent DMA implementation cope with this?=0A=
>>=0A=
> =0A=
> I don't think the situation is that bad. We only support allocations=0A=
> in the linear map for DMA/scatterlists, and buffers in the linear map=0A=
> can only share a cacheline if they were allocated using the same=0A=
> kmalloc() invocation (on systems that support non-coherent DMA)=0A=
> =0A=
> That does mean that it is actually more straightforward to deal with=0A=
> this at the level where the allocation occurs, and that would justify=0A=
> dealing with it in the callers.=0A=
> =0A=
> However, from the callee's point of view, it simply means that you=0A=
> should not dereference any request struct pointers for writing while=0A=
> the 'dst' scatterlist is mapped for DMA.=0A=
> =0A=
Is this the only restriction, or I might find out more in the future?=0A=
=0A=
This kind of violation of an abstraction layer must be clearly documented.=
=0A=
=0A=
In particular, if crypto API implementations cannot rely on DMA API guarant=
ees,=0A=
then exceptions must be listed.=0A=
=0A=
Thanks,=0A=
Horia=0A=
