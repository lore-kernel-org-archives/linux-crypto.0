Return-Path: <SRS0=mI8h=3T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEC4C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jan 2020 00:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C4C420661
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jan 2020 00:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="r4AyYMDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA3Ags (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:36:48 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6201
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbgA3Agr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 19:36:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeMuVQH6koCvwP+PBsymrsHdlNbk/f3Z9UnlSZ7Cgu2GdZ2AN4fAR1vWayM2Me8nXarkTRDLxCWlDuxSMhfY6/Wo6cfhUVDhUReJMmwUHZfZPH93nLls8lrbSh18J59u1R49syj80iFa5rSZzHR85JHObx8BAKCrdlHjAOq3rFFMwarGU/c0zM/mZmCEcN2ZEuZsojZ3BuDaNVRzDu/RwWWCxj+QMh/sgYRAeai2Sb4jkqujh36C3xLkc95dYbpI7Uh1Ml1xLydlQ2AC2+jMitUPylFggoqCGZNErt7MYU2JeMJxTwuWZdkpsPFc/XLv76JILwD4EnhewCkFlSqmWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/vRZUwpQlytnz5no4GppnriN/YdotxBqDhJQONbJog=;
 b=H0aMPdZa+xCqG/pheyy6GFGMV6pj2fwOeoMN8sEeXLBfud2Mz8wOW48wIkGt9Ml3aVjPgiKT4dJtCQYvT5FRAOidmVfGrRvLHNiJcFyBf4PLcuZ/EMtj1lFTPaq2BFUT+A0TBzcE2HYgbhRRWLWR1u0cw5C8F9NBjBxUwf9R9OxLQ7Ii9R8WDT1/5bquOknWvab8M5iNACx/fONunxVU+Y1wNlNMNpNSYrOg+C11e7Npukh9vHviHJmocOA0nI1xB963Q82gibYrenVCnEzOo9+JrqdF5d2XGyQKs6j2/+ZPmH6pZaDyBrZM4ZIfCRgf+ntSYoGrYfDpOELgizVEZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/vRZUwpQlytnz5no4GppnriN/YdotxBqDhJQONbJog=;
 b=r4AyYMDvz4DeWZ73gaZ628qHv6uM6NAvnRFiu0Jat+3Gx1YLSYlVv3orifJzY9BZqMp7/oY84tJlOFEa/B7pJZqdEGEF53wLhtGUkOEurWVXjc96TTJkvLlLtpVrR++zqnKprfMBbBHedi17r2EpIXOfpX92v6W2Ue83O8jRzdg=
Received: from AM7PR04MB7173.eurprd04.prod.outlook.com (52.135.59.203) by
 AM7PR04MB7080.eurprd04.prod.outlook.com (52.135.58.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Thu, 30 Jan 2020 00:36:41 +0000
Received: from AM7PR04MB7173.eurprd04.prod.outlook.com
 ([fe80::7910:5943:cfc6:2e0]) by AM7PR04MB7173.eurprd04.prod.outlook.com
 ([fe80::7910:5943:cfc6:2e0%6]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 00:36:41 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 0/9] crypto: caam - backlogging support
Thread-Topic: [PATCH v4 0/9] crypto: caam - backlogging support
Thread-Index: AQHVz4yHoq0pN4/MIU+xYn0bBfzzfA==
Date:   Thu, 30 Jan 2020 00:36:41 +0000
Message-ID: <AM7PR04MB717311F004D034092E7DBE1C8C040@AM7PR04MB7173.eurprd04.prod.outlook.com>
References: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
 <20200123194301.GA20198@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: da4082f0-cebe-4ed7-0150-08d7a51c79be
x-ms-traffictypediagnostic: AM7PR04MB7080:|AM7PR04MB7080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB708022629AED88238B46186A8C040@AM7PR04MB7080.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(9686003)(55016002)(66476007)(64756008)(66556008)(66946007)(8936002)(66446008)(86362001)(52536014)(5660300002)(33656002)(316002)(71200400001)(478600001)(2906002)(54906003)(4326008)(45080400002)(53546011)(6506007)(186003)(26005)(6916009)(7696005)(44832011)(76116006)(81166006)(8676002)(91956017)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7080;H:AM7PR04MB7173.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F7DkBzeqfhpIJc0ToT+TVxcrvU2R7XgyZMWD25y3zyi5DSXclG2TIefinMOTV0nsLrQmN2W6pFpVbhb/tHt/lh6iruaFbqmnSCXqq+Z1CQB65IXnVCqWmkVi9v9MMgVohz757Rn/cOuAXYFr+5Q1HBb8zLdZkJhEzUlZF7OP/dsSljgDl32TR9KwAUzqktS/h4IiNKOE/tjdQPo/Z3k42zXjQidV8+VdKTtLtooI78JvlxmcepyiIft7Wyfhz3eU54KB0616/Z1DkZqdtHTGBQqBwPtWivUTkKtsaarB/X9e3J45kU9wlIOip6TgPyjJi6xa/l23IzgtkTaXEQkf+nYeL8N6VVOqhMlthowIQy7JGWZ5CKqWb2IWCxImzGhAQeoOOH4KFbCpda6HG2emwIxTcrggW274nFAvAaBh29oGwcjar0OarbS7S/klMUmW
x-ms-exchange-antispam-messagedata: 6EQl9SIbWb2eXyTRVstmEFXgjcUJsoyYnubSyff1y+hQ+PdiZh7oD/grsQY3/z36vdNzBZk8BJGcxYwD91TJpoih0oXcf26Shb/SoncCaqeLlVVWoQvQCz0y2KH99s1qN0beSoAn0z8cLMQ1HdCEAQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4082f0-cebe-4ed7-0150-08d7a51c79be
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 00:36:41.2892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uPA3fFcSPplxY30Rt2YMB0SlCNfMGStaN4uT6/ptTf8cmC7z3IVIKFx0dagoztwGOTZtANzWpR+KhSJovPNICw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7080
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/23/2020 9:43 PM, Corentin Labbe wrote:=0A=
> On Mon, Jan 20, 2020 at 02:23:59PM +0200, Iuliana Prodan wrote:=0A=
>> Integrate crypto_engine framework into CAAM, to make use of=0A=
>> the engine queue.=0A=
>> Added support for SKCIPHER, HASH, RSA and AEAD algorithms.=0A=
>> This is intended to be used for CAAM backlogging support.=0A=
>> The requests, with backlog flag (e.g. from dm-crypt) will be=0A=
>> listed into crypto-engine queue and processed by CAAM when free.=0A=
>>=0A=
>> While here, I've also made some refactorization.=0A=
>> Patches #1 - #4 include some refactorizations on caamalg, caamhash=0A=
>> and caampkc.=0A=
>> Patch #5 changes the return code of caam_jr_enqueue function=0A=
>> to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is=0A=
>> busy, -EIO if it cannot map the caller's descriptor.=0A=
>> Patches #6 - #9 integrate crypto_engine into CAAM, for=0A=
>> SKCIPHER/AEAD/RSA/HASH algorithms.=0A=
>>=0A=
>> ---=0A=
>> Changes since V3:=0A=
>> 	- update return on ahash_enqueue_req function from patch #9.=0A=
>>=0A=
>> Changes since V2:=0A=
>> 	- remove patch ("crypto: caam - refactor caam_jr_enqueue"),=0A=
>> 	  that added some structures not needed anymore;=0A=
>> 	- use _done_ callback function directly for skcipher and aead;=0A=
>> 	- handle resource leak in case of transfer request to crypto-engine;=0A=
>> 	- update commit messages.=0A=
>>=0A=
>> Changes since V1:=0A=
>> 	- remove helper function - akcipher_request_cast;=0A=
>> 	- remove any references to crypto_async_request,=0A=
>> 	  use specific request type;=0A=
>> 	- remove bypass crypto-engine queue, in case is empty;=0A=
>> 	- update some commit messages;=0A=
>> 	- remove unrelated changes, like whitespaces;=0A=
>> 	- squash some changes from patch #9 to patch #6;=0A=
>> 	- added Reviewed-by.=0A=
>> ---=0A=
>>=0A=
>> Iuliana Prodan (9):=0A=
>>    crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt=0A=
>>      functions=0A=
>>    crypto: caam - refactor ahash_done callbacks=0A=
>>    crypto: caam - refactor ahash_edesc_alloc=0A=
>>    crypto: caam - refactor RSA private key _done callbacks=0A=
>>    crypto: caam - change return code in caam_jr_enqueue function=0A=
>>    crypto: caam - support crypto_engine framework for SKCIPHER algorithm=
s=0A=
>>    crypto: caam - add crypto_engine support for AEAD algorithms=0A=
>>    crypto: caam - add crypto_engine support for RSA algorithms=0A=
>>    crypto: caam - add crypto_engine support for HASH algorithms=0A=
>>=0A=
>>   drivers/crypto/caam/Kconfig    |   1 +=0A=
>>   drivers/crypto/caam/caamalg.c  | 416 ++++++++++++++++++---------------=
--------=0A=
>>   drivers/crypto/caam/caamhash.c | 341 ++++++++++++++++-----------------=
=0A=
>>   drivers/crypto/caam/caampkc.c  | 187 +++++++++++-------=0A=
>>   drivers/crypto/caam/caampkc.h  |  10 +=0A=
>>   drivers/crypto/caam/caamrng.c  |   4 +-=0A=
>>   drivers/crypto/caam/intern.h   |   2 +=0A=
>>   drivers/crypto/caam/jr.c       |  37 +++-=0A=
>>   drivers/crypto/caam/key_gen.c  |   2 +-=0A=
>>   9 files changed, 523 insertions(+), 477 deletions(-)=0A=
>>=0A=
> =0A=
> Hello=0A=
> =0A=
> I have tested this serie on a imx8mn-ddr4-evk and get the follwing crash:=
=0A=
> [   34.367787] Unable to handle kernel paging request at virtual address =
cccccccccccccccc=0A=
> [   34.375715] Mem abort info:=0A=
> [   34.378506]   ESR =3D 0x96000004=0A=
> [   34.381572]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=0A=
> [   34.386888]   SET =3D 0, FnV =3D 0=0A=
> [   34.389948]   EA =3D 0, S1PTW =3D 0=0A=
> [   34.393091] Data abort info:=0A=
> [   34.395978]   ISV =3D 0, ISS =3D 0x00000004=0A=
> [   34.399816]   CM =3D 0, WnR =3D 0=0A=
> [   34.402781] [cccccccccccccccc] address between user and kernel address=
 ranges=0A=
> [   34.409922] Internal error: Oops: 96000004 [#1] PREEMPT SMP=0A=
> [   34.415492] Modules linked in: ctr des_generic caam_jr(+) caamhash_des=
c caamalg_desc rng_core authenc libdes fsl_imx8_ddr_perf snvs_pwrkey rtc_sn=
vs caam error imx_cpufreq_dt=0A=
> [   34.430977] CPU: 2 PID: 267 Comm: cryptomgr_test Not tainted 5.5.0-rc7=
-next-20200122-00009-geed96b480af6 #39=0A=
> [   34.440799] Hardware name: NXP i.MX8MNano DDR4 EVK board (DT)=0A=
> [   34.446542] pstate: 60000005 (nZCv daif -PAN -UAO)=0A=
> [   34.451337] pc : __kmalloc+0xc4/0x290=0A=
> [   34.454997] lr : __kmalloc+0x48/0x290=0A=
> [   34.458655] sp : ffff800011b0b740=0A=
> [   34.461965] x29: ffff800011b0b740 x28: 0000000000000002=0A=
> [   34.467275] x27: 0000000000000080 x26: ffff800010c4b598=0A=
> [   34.472584] x25: 0000000000000cc0 x24: ffff00007b79b000=0A=
> [   34.477894] x23: 000000000000ac02 x22: ffff800008c5c254=0A=
> [   34.483203] x21: 0000000000000dc1 x20: cccccccccccccccc=0A=
> [   34.488512] x19: ffff00007d404200 x18: 0000000000000002=0A=
> [   34.493821] x17: 0000000008080040 x16: 0000000008182040=0A=
> [   34.499131] x15: 0000000002004800 x14: 0000000000000000=0A=
> [   34.504440] x13: 0000000000000000 x12: 0000000300000017=0A=
> [   34.509749] x11: fffffe0001ca2702 x10: 0000000000000000=0A=
> [   34.515058] x9 : 0000000000000000 x8 : ffff8000115e98c8=0A=
> [   34.520368] x7 : ffff800011776000 x6 : 0000000000000000=0A=
> [   34.525677] x5 : 000000000000ac02 x4 : 0000000000000011=0A=
> [   34.530986] x3 : 0000000000000002 x2 : 0000000000000000=0A=
> [   34.536295] x1 : ffff00007aaaf000 x0 : 0000000000000001=0A=
> [   34.541606] Call trace:=0A=
> [   34.544051]  __kmalloc+0xc4/0x290=0A=
> [   34.547377]  skcipher_edesc_alloc+0x154/0xab0 [caam_jr]=0A=
> [   34.552607]  skcipher_encrypt+0x58/0x118 [caam_jr]=0A=
> [   34.557397]  crypto_skcipher_encrypt+0x40/0x70=0A=
> [   34.561839]  test_skcipher_vec_cfg+0x254/0x768=0A=
> [   34.566279]  test_skcipher_vec+0xfc/0x148=0A=
> [   34.570285]  alg_test_skcipher+0xc0/0x1e8=0A=
> [   34.574294]  alg_test.part.32+0xb0/0x378=0A=
> [   34.578214]  alg_test+0x3c/0x68=0A=
> [   34.581354]  cryptomgr_test+0x44/0x50=0A=
> [   34.585015]  kthread+0x118/0x120=0A=
> [   34.588241]  ret_from_fork+0x10/0x18=0A=
> [   34.591818] Code: d5384101 b9402262 b9401020 11000400 (f8626a98)=0A=
> [   34.597910] ---[ end trace 3e4862893c99a748 ]---=0A=
> =0A=
=0A=
Thanks for testing this.=0A=
I'll fix it in v5.=0A=
=0A=
Iulia=0A=
=0A=
=0A=
