Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D047C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 08:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F3160EB4
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 08:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhKDIIW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 04:08:22 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34195 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDIIW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 04:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636013146; x=1667549146;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0XDLjLI0gLxEIEpD58e3q35MBdx4lk4NZDiQVgPaNwY=;
  b=KSxMLFAqYYbHjcKjBQ3U+DmcFvUq7xsFTzZJVycLZGz3+s5yrySRa6kk
   en8cOILZd7J8d23InrXpAyI+H8ExayRxQg1BVjW4SfmBu5X/ybvMXI1t7
   FHooy04nM9Mk5FRIVMWiXGDxW9fLPcjmXHUEs+jhnOQqmkw6ciTVGXtaV
   T40EsA+aIQhRm1Q/l8pFgUEvqSxc5nEwoES2VNkPyUuOqVZU+k8XKPMNu
   iZgQ2gEpZMinX017J2buKUmcVLrF7LA3MGdFyKYirPk7PxFyJ5GlPDL89
   irxdj6qsdJNfFJLAVfPxXtOoirI2qftf8i/wr3Sypo1H3AtPzrEHhinql
   g==;
X-IronPort-AV: E=Sophos;i="5.87,208,1631548800"; 
   d="scan'208";a="185671089"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2021 16:05:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8E4HKcjwafZsiY2X1U+a/B/sLErvscBiSeFX2liVymqnxv0+8G2SL+ARbPYKetxlSVVfDcyYxwOcOoNP7dGEVK2xorXs2OK2jCmLhoxs7dH0prQk2rM640/HSnVK8n8cWHHwJju1Ycm8o1idrVCzgKwmKRDD12JIPy8nbhv/2/ekqJOc2OHg9fQ/2JRk3NJpzUAy5u3k1RxTFfPwqX39+M7P+6R+sSElDJOr9ImgfqGw9RMzre6z7QZzj2e6V6ZNI1ao7fxLYuSyKRY6HiNMK+aHgOKWxxJOMsBVD3xwpWfOvGvGX+FUTrV0hsJgtrzN/U8kJKLcM+OyH45WfSqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxsxCpI3ipaiSnSUbopTF5z+iAhFynmlBGvli5Cv6xE=;
 b=NBwBTkYrQyI5UCEDa2kwO7RCSNDO2m9JsxT9w2lXoR9E74sEVdIiqPf6STtRJM6lbB7e4xJ8CH04JVWHW213PYc/DleVvFRB9tCkKp5dbTdKEkVfu46eAozUh8kuwydmTMim19rVHNNkPuuHZywcNRuPiH4bHGtyURAOhzu5K6MSrm4YfJO5bimq+Nf0VU3gecFwd+q6kt91Sm93qjZ3qvYMGqcyEZuEdX0EkHk6uCa6+V69gksgK82ZJbBXrhIhc7P23QMYbfz0LBSNPDB+vZgFs4g3vSlWCSsJba3tnHqUh7r/plpO1ChjkcdYVotjbuvd+9htHzDsHoMPQGnJVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxsxCpI3ipaiSnSUbopTF5z+iAhFynmlBGvli5Cv6xE=;
 b=sN96eDh0sf7gBIJogew9pYbqpzAde+RhPi8E2lcI/QELYmfa8wEI7MTCqvrzLy7MgaIIzl9JD6PImK7xoNxHoxvipF1ezmnKLrJ1aeGVvUk2Nk3GJNHYoPAtv3Fq7WbzdELhgQT1FbDDMI6f6Adbr7pDhI+TfRQymJhNGcA0slI=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5884.namprd04.prod.outlook.com (2603:10b6:5:163::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 08:05:41 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af%8]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 08:05:41 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        kernel test robot <lkp@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Thread-Topic: [PATCH] crypto: api - Do not create test larvals if manager is
 disabled
Thread-Index: AQHX0AAsn8beV0dNDkOTE4cq4i4dGw==
Date:   Thu, 4 Nov 2021 08:05:41 +0000
Message-ID: <DM6PR04MB7081CC2C50DC09AD877367C2E78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
 <20211001055058.GA6081@gondor.apana.org.au>
 <YVdNFzs8HUQwHa54@archlinux-ax161>
 <20211003002801.GA5435@gondor.apana.org.au>
 <YV0K+EbrAqDdw2vp@archlinux-ax161>
 <20211019132802.GA14233@gondor.apana.org.au>
 <alpine.DEB.2.22.394.2111021636040.2330984@ramsan.of.borg>
 <DM6PR04MB708155E447FD9A79AB89686DE78D9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CAMuHMdW1wLAt9Y=-GMMuk8HWE3UnRgKNMmD9fq34Rq8J7QyrzQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5527255f-fb96-42ac-0dec-08d99f69e524
x-ms-traffictypediagnostic: DM6PR04MB5884:
x-microsoft-antispam-prvs: <DM6PR04MB5884872302A602036CC85074E78D9@DM6PR04MB5884.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0aY6W0bJ8l4kFAbs34EMfzQw3abj975hSX8YP6m0TiA5arTaD2HQKdO3X1YR3XsIGwtCK8sQGugGQnNOJClIG7bKK4v+KORe2zNF/RS38uHnqolM/O4IqIKDOS7k2qkEakTvVehQo50Fkjmd+qiZZJWzOSjluufUEZj62gBRXxnV6sWPXlmOyuKtaTpDtrrjBNaZpMsuow/KfRmkbIdo0JwdKbiT1yOjFJHgIO3JXGFPmP8pDZhBiQ3f0bgi9dkjWwrqvcKBgu2tsLUWrMpgelERXD3NmB5ULAI5meqrv9TIWTUA5Zr+9A4LNyLjDvxa4n8m8NQHG6ueVdkSSfMPQyxjzEJJ0z7g5ozGnus2W+iKEBK27jJdnOTJyBhS5bOeRfG2sVfqF/lcW80mTvrRDuIfb1W09o6FyrMsKnuXhAw6l8VcGxKIXjznqiK/X24Fp5wr/K02Zu8sL2h6TgKTvR40OfCqhoxHHV35vI61fPdWrVL+4CRvw7RY/dpTdzkj58ezYBiUobm3u5iQ88pYudcwDk9S5R2bZ+AYlIVN46EZ4S+uSpWVo/AsBI+mlvTgaYjyrUVvyWPiwlT5pKRhrtFd376mZhHU6zmoiQ8M6r5UqBQae3CVhKNqRucmMPS7HUPnvzTb49b0XYyDFSdZBWozccag24SJlOzE2VVo07RoFzLNDBMBKAOVGIZv2dYweJJiRjeYQ3ZvAKwzRkguLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(2906002)(316002)(54906003)(4326008)(6916009)(7416002)(66946007)(86362001)(8936002)(71200400001)(55016002)(66476007)(66556008)(38070700005)(6506007)(8676002)(83380400001)(91956017)(508600001)(53546011)(66446008)(64756008)(5660300002)(76116006)(122000001)(52536014)(38100700002)(186003)(7696005)(33656002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7T4VWy8AQsJKpz/SlnkAmeWTjUR2v1z2QPoLcXw7d8kYewcYye7noW8Uw5Vq?=
 =?us-ascii?Q?GDwS/nkYgCfKWQRHHtYBG+5oKU6u6qlXl7FOKgydcoUUXh+wjorIzOKGzNyF?=
 =?us-ascii?Q?wBg248mEVBoqrGOykYRDslkmcYzPP2CxRs80xOVLbHZgAcA5hD7XHDF9G65l?=
 =?us-ascii?Q?rwlNyny0gW7wJSIPwkRuYOcYXemXPn3aLY3Vg8MvzqMXIy11sI0M4gZaTAhS?=
 =?us-ascii?Q?mt/50vZEWYVucJjHJRkOI2u276S2+Kp4qkmlgtI4u1V7yzECqbnx5T5fJSv8?=
 =?us-ascii?Q?VTPa3I+MzBnB8vsqAv9bUDI77jTAOhROewPOzZ1J96PQQvLOChNzL3/b21Ic?=
 =?us-ascii?Q?EO+gkaLfzuYsb56q6HRi+isT4c/kza0OySrIDpi4okqj6BeT0TS02u+wDesr?=
 =?us-ascii?Q?b3SFlwRuJpxmxvnKdRj+Gxu0UMzY1LQxgOP4f0nu+v06YjTLMcGWYVXudwRK?=
 =?us-ascii?Q?PoyxdcTeReAntONORnPf+ssqfk3/bYP6WiomLK7JseZoXfzHUgFfqTRo5fuP?=
 =?us-ascii?Q?whbF9UQ+31R6ROP40b0+R2G35UovdRGBeCSYzh5yV5X5htGWvqMHjSWBwhWQ?=
 =?us-ascii?Q?TTuH4F1IQct5KQX3uKa2XRwP6Zb8Q6M3g0+7VGu0DDj2XW+Oq+kQnCx8T61V?=
 =?us-ascii?Q?C5tH4HBtHqWisI0Q9GLhUpo4Xca/ygMXGVLW2FY7TZo1NFxUKAEUyV4HK/8b?=
 =?us-ascii?Q?TMVxsD4Cx3Wv/GtgJQ7GEC4HcBNmHJFsBD5bikEirllppyVmSt3EyjxF5ZCX?=
 =?us-ascii?Q?or0yHTqHoKP2e++Fty+x8WA1IxQKu6sQw8zLNHzykxYIsZjESD8JFuCmQubX?=
 =?us-ascii?Q?Km2TOiXfT2//sGsY2j/lltQKZGA4u+VBpozQXovxTYATftkW3pU0GKtiNOJj?=
 =?us-ascii?Q?LzAsqYYwerPxHKVz+U2fdFBUTce5bEN857U9CDi9b6QtFTk6cPt0SqEtVQ2v?=
 =?us-ascii?Q?RSKmlSGOCQpcmKKIusirtdK18kwGj40P1im4UsNFzUh6GuoP8TNBHLc+vb6f?=
 =?us-ascii?Q?nm2/dzAYaUSzWiG899wlldJetQ+uP4GDbvIIXmpU76Ait6tKfWTdnaApIxKt?=
 =?us-ascii?Q?YMM3gyQAlhmgh21oewIaPxzQ7pTIGBDBQ8TJqWycbNkWFADyFIG8dFgoYL4H?=
 =?us-ascii?Q?+mIW3HSGvq2U1R6h8yVCupWHX9mheRvYjn2qJMOq1G6CUKir/GRrMZgZisHB?=
 =?us-ascii?Q?gheAL63TsuY1c5RITaTi+SFSoKJ1ekn7k7LEWHvZYISK+U7tUbuU2RhoH5ez?=
 =?us-ascii?Q?+XUUI39Snt+Ld3npGmsybl6rxdpraKgfeD1aBrhNyOTPtpjzm1llJoTd7u+n?=
 =?us-ascii?Q?rxWxkcEWW3z5IZc6dqf9OXBhtJXog/D+Hc/hkVsJQwSd7h9EQGZQgUpbtcdC?=
 =?us-ascii?Q?uDhmzrg/0gg/IvEkH9h30PIkNwFeOTqglYf8jZbRUqftINXqXzMJpSZZhr6B?=
 =?us-ascii?Q?b7mbEBa0ivxoz4OeS/EceT+2YGyq1cGE52EYyCnyZdqV8dIi4gE0amP4JmPC?=
 =?us-ascii?Q?IC9X375tbGovF34ShA1FyaF2ajeNkBPkzFNFK2gU7zbyogNjSntHnDMUHJTb?=
 =?us-ascii?Q?u9Cr9wRjIeFhTGLCxcDRDAQiH+qoi6XIWnyUvbUXjv1E3ZQnTngToCNH4Y+4?=
 =?us-ascii?Q?wM948bi1TbWNNaEtnUCAsSCw7xwUX7BJiNKMe/LrvK2ou+HcSl+MlqEahXxs?=
 =?us-ascii?Q?PuzXT/ppT4cG8C57+djoOcs1JRyz9LWrxxsxlyVU1oaRExKd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5527255f-fb96-42ac-0dec-08d99f69e524
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 08:05:41.3885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSKU0kdN59E9I439UlyA0bf+Ny87aGCbJZzfilGkDv3QDxUXbpO3id2i4Dco+lSccePDPHmnxjjwi9a0DJF4Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5884
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/11/04 16:58, Geert Uytterhoeven wrote:=0A=
> Hi Damien,=0A=
> =0A=
> On Thu, Nov 4, 2021 at 8:29 AM Damien Le Moal <Damien.LeMoal@wdc.com> wro=
te:=0A=
>> On 2021/11/03 0:41, Geert Uytterhoeven wrote:=0A=
>>> On Tue, 19 Oct 2021, Herbert Xu wrote:=0A=
>>>> On Tue, Oct 05, 2021 at 07:33:28PM -0700, Nathan Chancellor wrote:=0A=
>>>>> I assume this is the diff you mean? This does not resolve the issue. =
My=0A=
>>>>> apologies if I am slow to respond, I am on vacation until the middle =
of=0A=
>>>>> next week.=0A=
>>>>=0A=
>>>> Sorry for the delay.  The kernel robot figured out the problem=0A=
>>>> for me.  It's the crypto_alg_tested call that causes api.c to=0A=
>>>> depend on algapi.c.  This call is only invoked in the case where=0A=
>>>> the crypto manager is turned off.  We could instead simply make=0A=
>>>> test larvals disappear in that case.=0A=
>>>>=0A=
>>>> ---8<---=0A=
>>>> The delayed boot-time testing patch created a dependency loop=0A=
>>>> between api.c and algapi.c because it added a crypto_alg_tested=0A=
>>>> call to the former when the crypto manager is disabled.=0A=
>>>>=0A=
>>>> We could instead avoid creating the test larvals if the crypto=0A=
>>>> manager is disabled.  This avoids the dependency loop as well=0A=
>>>> as saving some unnecessary work, albeit in a very unlikely case.=0A=
>>>>=0A=
>>>> Reported-by: Nathan Chancellor <nathan@kernel.org>=0A=
>>>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>=0A=
>>>> Reported-by: kernel test robot <lkp@intel.com>=0A=
>>>> Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency fa=
ilures")=0A=
>>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
>>>=0A=
>>> Thanks for your patch, which is now commit cad439fc040efe5f=0A=
>>> ("crypto: api - Do not create test larvals if manager is disabled").=0A=
>>>=0A=
>>> I have bisected a failure to mount the root file system on k210 to this=
=0A=
>>> commit.=0A=
>>>=0A=
>>> Dmesg before/after:=0A=
>>>=0A=
>>>       mmcblk0: mmc0:0000 SA04G 3.68 GiB=0A=
>>>       random: fast init done=0A=
>>>        mmcblk0: p1=0A=
>>>      -EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. O=
pts: (null). Quota mode: disabled.=0A=
>>>      -VFS: Mounted root (ext4 filesystem) readonly on device 179:1.=0A=
>>>      +EXT4-fs (mmcblk0p1): Cannot load crc32c driver.=0A=
>>>      +VFS: Cannot open root device "mmcblk0p1" or unknown-block(179,1):=
 error -80=0A=
>>=0A=
>> p1 exist as the message 2 lines above shows. And since the mount error i=
s -80=0A=
>> (ELIBBAD), it is really all about crypto. Since the default k210 config =
compile=0A=
>> everything in-kernel (no modules), it should work. Was crc32c compiled a=
s a=0A=
>> module ? If yes, then the k210 will need to be booted with U-Boot and us=
e a real=0A=
>> initrd, which likely will all end-up in a no memory situation. ext4 in i=
tself=0A=
>> will consume way too much memory...=0A=
> =0A=
> Everything is built-in, including crc32c. It worked fine, until the commi=
t=0A=
> referenced.=0A=
=0A=
I think I read this backward. I thought one of my k210 patch was wrong... I=
t is=0A=
the crypto patch that is at fault here.=0A=
=0A=
Thanks !=0A=
=0A=
> =0A=
> Gr{oetje,eeting}s,=0A=
> =0A=
>                         Geert=0A=
> =0A=
> --=0A=
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org=0A=
> =0A=
> In personal conversations with technical people, I call myself a hacker. =
But=0A=
> when I'm talking to journalists I just say "programmer" or something like=
 that.=0A=
>                                 -- Linus Torvalds=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
