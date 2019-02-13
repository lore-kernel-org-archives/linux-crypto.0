Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAC4C4151A
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 20:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB5E222B6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 20:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZmAPB3nO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfBMUsd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 15:48:33 -0500
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:61243
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727251AbfBMUsd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 15:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhoOEDKrJczN9bGyMQgmNwyTlGTjKOAEXqsmmUNPsP4=;
 b=ZmAPB3nOImBlb6ieSVHQ0yrJarelRPNa5KZXuXn8fLCKBAICewZlry03Hv/v0n4qVAdh5/dzrd8X+Co5OryxC61OcM8Uv/29lLU0gxmI/yvQecN79wCIZ/i/1lnhR6WOUm8oMI+gAckxNmj+WQWwFKx8M0FOw38nbjxaaJrXlKM=
Received: from HE1PR0402MB3484.eurprd04.prod.outlook.com (10.167.126.13) by
 HE1PR0402MB2779.eurprd04.prod.outlook.com (10.175.36.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Wed, 13 Feb 2019 20:48:28 +0000
Received: from HE1PR0402MB3484.eurprd04.prod.outlook.com
 ([fe80::7d94:a064:b55b:b28a]) by HE1PR0402MB3484.eurprd04.prod.outlook.com
 ([fe80::7d94:a064:b55b:b28a%5]) with mapi id 15.20.1601.023; Wed, 13 Feb 2019
 20:48:28 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Thread-Topic: [PATCH] crypto: caam - Do not overwrite IV
Thread-Index: AQHUuSvyCmTFYLEeOE2P2XtmnR+/Zg==
Date:   Wed, 13 Feb 2019 20:48:28 +0000
Message-ID: <HE1PR0402MB3484D933C4012C349E24C9D998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au>
 <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
 <CAKv+Gu-bA-bZLGe+SFzkBXOL1xNa9SBFLGQBKrPAmM+aHuw8LA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e45a577-0fbb-4de6-e20f-08d691f49b76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:HE1PR0402MB2779;
x-ms-traffictypediagnostic: HE1PR0402MB2779:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;HE1PR0402MB2779;23:BzQlFQzjbkOJlz6fszuv8vlNDVd9B3Y3qqwaywT?=
 =?us-ascii?Q?i5TFPOPwTQ9uOfil4ijZy32dp4JipZadRTq+t28Jw2jAMGSxox6rGdl7D8W8?=
 =?us-ascii?Q?fi1HUZpULL+gTstWWskssBoa5uvnJlgsllo7HRj9iSHkjIL2kq1pZH7Umlfw?=
 =?us-ascii?Q?/+l2LF6YW84AvgynnLcKTVsTLu8XMZawdB1wPNyh7fFtPauwE94PvJKX18kw?=
 =?us-ascii?Q?O8+Bh060eVftUHUWbgqHdt+7VDZRHHdWhaY/TiPiduEFXduQ755zQ118WKSM?=
 =?us-ascii?Q?Ktt71Moa06ypz2hZNtXsIpCggogtMHf2ceiERIf7OvZBad71QZFlrGZ7w4x2?=
 =?us-ascii?Q?YMPPeCX+JBAxMs8gbBOdO1Na123yliy1Pt/vwNvZ5HJY5qTWsOyfwNtcV4wP?=
 =?us-ascii?Q?Ghn3PXiA86jJZ+HJUkAuYa2lTE0a6c6qvK+SFtOCPqMxgAoeElj50kuFpdRF?=
 =?us-ascii?Q?kAIZIBEk0u38RysI9yCkgULTd+LrqpC3FxkbwwSjYEQsdXVdb/itlbIWDYGG?=
 =?us-ascii?Q?5nBtNlHmlo2wWOZ+dU3UBzd6W2uR0VYrNLbZIxKXvdRaE7zVoTg7fBQf8elu?=
 =?us-ascii?Q?1m92g9t0tqudQYXj2K6mV3ja/LmvTz9wCrjiBWb3vUZX43X26hAm+HzejYuA?=
 =?us-ascii?Q?F/pbEfHat/zEFpl4prNFctqBVXFoG4KglUNk/Zz0TxtvXVrLY+JUxqF/wPR/?=
 =?us-ascii?Q?G3eIqDrQiu+uDyKM/URX/5ySr68OpKyGZ80KbAadsfnAJ5WaCerGkU2Hr3OR?=
 =?us-ascii?Q?1z9IUwpmwVGb+WWB4enoGzXfdQhw2ekZqBLXWA/zAjl1+sPMMVnZFsWWsHst?=
 =?us-ascii?Q?Ejjj7I7rDaVbTpNznAAIKmeWEtcsT4kFBeJozLbRUXx29JjVsy9mxZC2QLb6?=
 =?us-ascii?Q?Fi/cX5IPN/Ua908Xn3po+VpPzGPn+ovUeotothPK9RK5GXGS0XJ7PxBYwrzU?=
 =?us-ascii?Q?ePZGTGoehmkhuqI/gkkC4129ro2tuFnehE8nUJO3iIxTgVIVGPG872IbG+iL?=
 =?us-ascii?Q?+p02I/KG18FF8MQXDLf+5lfg9Km+R6hgW2mybDh2XzSsZEneOmKd4qP4NNNz?=
 =?us-ascii?Q?hj+9Vmwv7t1D790YIZ2Z38GHz9iqHISMvbaVfCq67GPll4qjv/nAUbfV9uyB?=
 =?us-ascii?Q?Hdnjl+R+IMXzvdUOuXInRhoij92XAFgIRZJiA3Puy9hZF5vgsKlM3XJzqbn6?=
 =?us-ascii?Q?CmHNcODrwUkXFr/A3VeNl60K7E79zFJ7e38BevmDb6Yg+aGeWe3wlQnWYkw?=
 =?us-ascii?Q?=3D=3D?=
x-microsoft-antispam-prvs: <HE1PR0402MB2779E4966FE4F3206050DA8998660@HE1PR0402MB2779.eurprd04.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(189003)(478600001)(9686003)(6246003)(6436002)(55016002)(74316002)(71200400001)(71190400001)(4326008)(6116002)(256004)(44832011)(14444005)(25786009)(3846002)(86362001)(229853002)(486006)(2906002)(102836004)(7696005)(26005)(53546011)(6506007)(33656002)(8676002)(53936002)(97736004)(476003)(81166006)(93886005)(8936002)(106356001)(14454004)(305945005)(68736007)(6916009)(7736002)(66066001)(76176011)(186003)(54906003)(99286004)(105586002)(446003)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0402MB2779;H:HE1PR0402MB3484.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7W+QDV9Vt6KeMTFSqjpqbHmyXt6K5C8PWhH/IiHnVgMt/qobARm5wXRZfWJMRESntUxzisRfGtuvf9WuEmLhjwK21Hdaq4FHHV7kYih9nEOaaZ5kjxtRrx9jq10QSGHiI7sC0DtFZFlHdjHczv0bpTN1k7UmUqbTcNage7bYYF4dPBEx2InZO3qKgi7iTKh7Vn5NFowegKQfKLbrlFwWtEfIsEX4F8H07lx1TZmDxi7Z4hVircIpNjKgGMNExv8sa/k4+pr5mzGQLVSItla4qGyCI7+wjDHVVHETGVe5l1G/NYdMuGVVyY3LyJMwB/j5dxKtJagA7j7bx6cZlbze31u+WTgVtc/xWHGFUYb+YemlPVyvXXad+rLmtYd6yK3Q5HQXD3mtYRzZDsfKldur+NsXn4yZa81S8zD8zgG+Ycg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e45a577-0fbb-4de6-e20f-08d691f49b76
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 20:48:28.3889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2779
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/12/2019 11:13 AM, Ard Biesheuvel wrote:=0A=
> On Fri, 8 Feb 2019 at 09:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:=0A=
>>=0A=
>> On Fri, 8 Feb 2019 at 09:41, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>>=0A=
>>> On 2/8/2019 9:16 AM, Herbert Xu wrote:=0A=
>>>> On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:=0A=
>>>>>=0A=
>>>>> The root cause of the issue is cache line sharing.=0A=
>>>>>=0A=
>>>>> struct crypto_gcm_req_priv_ctx {=0A=
>>>>>         u8 iv[16];=0A=
>>>>>         u8 auth_tag[16];=0A=
>>>>>      [...]=0A=
>>>>> };=0A=
>>>>>=0A=
>>>>> Since caam does not support ghash on i.MX6, only ctr skcipher part of=
 the gcm is=0A=
>>>>> offloaded.=0A=
>>>>> The skcipher request received by caam has req->src pointing to auth_t=
ag[16] (1st=0A=
>>>>> S/G entry) and req->iv pointing to iv[16].=0A=
>>>>> caam driver:=0A=
>>>>> 1-DMA maps req->src=0A=
>>>>> 2-copies original req->iv to internal buffer=0A=
>>>>> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->s=
rc)=0A=
>>=0A=
>> This violates the DMA api, since you are touching memory that is owned=
=0A=
>> by the device at this point (even though the addresses do not actually=
=0A=
>> overlap). Note that on architectures that support non-cache coherent=0A=
>> DMA, the kmalloc alignment is at least the cacheline size, for this=0A=
>> exact reason.=0A=
>>=0A=
> =0A=
> Actually, the driver does violate the DMA api in another way:=0A=
> scatterwalk_map_and_copy() is accessing req->src after DMA mapping it.=0A=
> Does the issue still exist if scatterwalk_map_and_copy() is done=0A=
> before the DMA map?=0A=
> =0A=
> (On a non-cache coherent system, the DMA map will typically perform a=0A=
> clean+invalidate, which means that the invalidate that occurs at unmap=0A=
> time cannot corrupt adjacent data, but this only works if the CPU does=0A=
> not write to the same cacheline while it is mapped for the device)=0A=
> =0A=
scatterwalk_map_and_copy() is reading from req->src.=0A=
Are you saying it's forbidden for CPU to read from an area after it's DMA m=
apped?=0A=
=0A=
Thanks,=0A=
Horia=0A=
