Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BF4C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 09:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77E0023429
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 09:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pk5YcKP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfH3JPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 05:15:20 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:14017
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727904AbfH3JPT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 05:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAAeoKsletD97ly+GED9hgGxYOB9cg/eEKtlnELJDbx+nATtmHt2qAPf9UmH66KJSrOLDd7XGsrChHeYuhhYAAmgdHIJcq+UMpAhSQkFbXW7jTObREyLfewrfznTXUmt1rrHjWDngPpTecWZdz4RLNyCZbFdvRP9vX6q799UfIikn8Gcx0drSHxgbfF9mgCLHb6cz4of3YWPyLy09Ko0muLp1Q21ECIpvGA/ixYmP7C130sGKEEWjLBZnc4XegR/hwZAgw5J/SsjHtRym9VU0ex3Rz4kDSMpEHGKdPPilLjf0L0FxB2RHDgFu2P+2B6jHbEKonZ1xAE25Y1E0cBXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCU/30t0Wf+n/x59SKNRdVEXEj1VVIRDu0lkDEkHAns=;
 b=gEZE/n3AsG1dDFumH6HadHXxOkV6qc5fHLWOPR6ygRGwEFyN9/cG/LKV3OBpt29HDNxkE6OCR+Mpx1CAw4smqGxNlr90ldoMZukumweUmuoWWohZ8n/Uvk0CYZ8kcQi7AW0Ey8xLU7Su+TV9XK+27/A0YhoCXsUkTGqDwLhUeBJcs4Nb8ph2lGXW8THmhbTQnKbQiINp37CFfkDWQIbziBFvgRtbCxalUq4ki7nf7mk85jINUvTXo1BeDws6e7aV/T7R8lmaoG3o/WQcx6bhIgYKxBH1mVV6ZLnFWKymg1aFf7leTYkwbcOYHz482c1Ow8RMDTsOl74YnaRzbZEisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCU/30t0Wf+n/x59SKNRdVEXEj1VVIRDu0lkDEkHAns=;
 b=pk5YcKP5GthNvzEcy/7uYth41U9i+1ELY0e7xN2XrZRi9bDVBxgRZ8lTI9amBWfKphQzGL20wvTg9KLjhmchu4Kk0jac3Qlh9se5/o5QBzskpRYpTcwkXQShoFg50NsQA0PaAh9kKpeHXCz6NSyWM/pdTTV8EdP2nS4DGvCJKrs=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4463.eurprd04.prod.outlook.com (20.177.53.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 30 Aug 2019 09:15:13 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 09:15:13 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "christopher.spencer@sea.co.uk" <christopher.spencer@sea.co.uk>,
        "cory.tusar@zii.aero" <cory.tusar@zii.aero>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Topic: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHVV5VB3CgVSzdtsUuKFBe5Nr//dA==
Date:   Fri, 30 Aug 2019 09:15:12 +0000
Message-ID: <VI1PR04MB444580B237A9F57A7BAAF32B8CBD0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <20190830082320.GA8729@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f886d9c6-9707-4475-5a79-08d72d2a9068
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4463;
x-ms-traffictypediagnostic: VI1PR04MB4463:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4463A91DB8476ED7A2C331128CBD0@VI1PR04MB4463.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(189003)(81156014)(54906003)(305945005)(110136005)(66946007)(14444005)(6436002)(76176011)(76116006)(5660300002)(229853002)(86362001)(25786009)(66446008)(66476007)(91956017)(66556008)(6506007)(53546011)(102836004)(256004)(26005)(486006)(44832011)(476003)(2906002)(186003)(74316002)(446003)(81166006)(33656002)(6246003)(9686003)(71190400001)(71200400001)(6306002)(99286004)(55016002)(53936002)(7696005)(64756008)(66066001)(3846002)(8936002)(6116002)(8676002)(966005)(7736002)(45080400002)(4326008)(14454004)(52536014)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4463;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sYntJzJ8u3SFqJ8I6tsH4+tRynH+sCvpNRv2pi2WWbInUASaXgzkLVgmQZ3DDS35mgSRCWeQr3yuCjnxY/PqQ9HVsMKNNwywWBki2VusMvg3WCLcBg4L3Vr5BHmpnGCDCGhYJ7UsuEmChYwYpq0+LRlEwAkUnrFvY9ErKOLM5N+wyynOKHR1Svq9/9iaDuwQgANX1CoaKRzmDf6tto8n9yhuB3/JtYO6omeJW2ZXZW9MLvx/r4YmAD4BjvEhETqRD6gPdjLA9kBEntTtZ1xNsD2P40WKZGDleG9QsCMW2UQYOxXSkmwwW9h4KBwNYSX6U8jBTzRKOdAwhNSBDrnIQ1AbKgZfcd02XL2VKiGccSWfZmb0i/WQhfkN3GjefaOZ5X7qAWcguNBawSc8d6VmT9FuQt4xo0LZzAp7/YpCvjE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f886d9c6-9707-4475-5a79-08d72d2a9068
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 09:15:12.8999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55GO1WQLYLTHEZwHLmkT1F4i2dR8BVSquDtE8fVQ6qUez+dOcV/15E251IDZkRO0xjWbg4sPr3tCaE9zRzXKfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4463
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/30/2019 11:23 AM, Herbert Xu wrote:=0A=
> Andrey Smirnov <andrew.smirnov@gmail.com> wrote:=0A=
>> Everyone:=0A=
>>=0A=
>> Picking up where Chris left off (I chatted with him privately=0A=
>> beforehead), this series adds support for i.MX8MQ to CAAM driver. Just=
=0A=
>> like [v1], this series is i.MX8MQ only.=0A=
>>=0A=
>> Feedback is welcome!=0A=
>> Thanks,=0A=
>> Andrey Smirnov=0A=
>>=0A=
>> Changes since [v7]:=0A=
>>=0A=
>>   - Series rebase on latest cryptodev-2.6 (198429631a85)=0A=
>>=0A=
>>   - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"=0A=
>>     converted to use CTPR and MCFGR to determine CAAM pointer width=0A=
>>     and renamed to "crypto: caam - select DMA address size at runtime"=
=0A=
>>=0A=
>>   - Patch adding corresponding DT node added to the series=0A=
>>=0A=
>> Changes since [v6]:=0A=
>>=0A=
>>   - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"=0A=
>>=0A=
>>   - Collected Reviewied-by from Horia=0A=
>>=0A=
>>   - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"=0A=
>>     is changed to check 'caam_ptr_sz' instead of using 'caam_imx'=0A=
>>     =0A=
>>   - Incorporated feedback for "crypto: caam - request JR IRQ as the=0A=
>>     last step" and "crypto: caam - simplfy clock initialization"=0A=
>>=0A=
>> Changes since [v5]:=0A=
>>=0A=
>>   - Hunk replacing sizeof(*jrp->inpring) to SIZEOF_JR_INPENTRY in=0A=
>>     "crypto: caam - don't hardcode inpentry size", lost in [v5], is=0A=
>>     back=0A=
>>=0A=
>>   - Collected Tested-by from Iuliana=0A=
>>=0A=
>> Changes since [v4]:=0A=
>>=0A=
>>   - Fixed missing sentinel element in "crypto: caam - simplfy clock=0A=
>>     initialization"=0A=
>>     =0A=
>>   - Squashed all of the devers related patches into a single one and=0A=
>>     converted IRQ allocation to use devres while at it=0A=
>>=0A=
>>   - Added "crypto: caam - request JR IRQ as the last step" as=0A=
>>     discussed=0A=
>>=0A=
>> Changes since [v3]:=0A=
>>=0A=
>>   - Patchset changed to select DMA size at runtime in order to enable=0A=
>>     support for both i.MX8MQ and Layerscape at the same time. I only=0A=
>>     tested the patches on i.MX6,7 and 8MQ, since I don't have access=0A=
>>     to any of the Layerscape HW. Any help in that regard would be=0A=
>>     appareciated.=0A=
>>=0A=
>>   - Bulk clocks and their number are now stored as a part of struct=0A=
>>     caam_drv_private to simplify allocation and cleanup code (no=0A=
>>     special context needed)=0A=
>>     =0A=
>>   - Renamed 'soc_attr' -> 'imx_soc_match' for clarity=0A=
>>=0A=
>> Changes since [v2]:=0A=
>>=0A=
>>   - Dropped "crypto: caam - do not initialise clocks on the i.MX8" and=
=0A=
>>     replaced it with "crypto: caam - simplfy clock initialization" and=
=0A=
>>     "crypto: caam - add clock entry for i.MX8MQ"=0A=
>>=0A=
>>=0A=
>> Changes since [v1]=0A=
>>=0A=
>>   - Series reworked to continue using register based interface for=0A=
>>     queueing RNG initialization job, dropping "crypto: caam - use job=0A=
>>     ring for RNG instantiation instead of DECO"=0A=
>>=0A=
>>   - Added a patch to share DMA mask selection code=0A=
>>=0A=
>>   - Added missing Signed-off-by for authors of original NXP tree=0A=
>>     commits that this sereis is based on=0A=
>>=0A=
>> [v7] lore.kernel.org/r/20190812200739.30389-1-andrew.smirnov@gmail.com=
=0A=
>> [v6] lore.kernel.org/r/20190717152458.22337-1-andrew.smirnov@gmail.com=
=0A=
>> [v5] lore.kernel.org/r/20190715201942.17309-1-andrew.smirnov@gmail.com=
=0A=
>> [v4] lore.kernel.org/r/20190703081327.17505-1-andrew.smirnov@gmail.com=
=0A=
>> [v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com=
=0A=
>> [v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com=
=0A=
>> [v1] https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fpatchwork.kernel.org%2Fcover%2F10825625%2F&amp;data=3D02%7C01%7Ciuliana.pr=
odan%40nxp.com%7C33d82b783fe44b7397a108d72d2361d7%7C686ea1d3bc2b4c6fa92cd99=
c5c301635%7C0%7C0%7C637027502298978288&amp;sdata=3DTc%2FSuS60cL8%2FLisYBtfa=
rPAVmcx7ITpNgaiLMq5YLIs%3D&amp;reserved=3D0=0A=
>>=0A=
>> Andrey Smirnov (16):=0A=
>>   crypto: caam - move DMA mask selection into a function=0A=
>>   crypto: caam - simplfy clock initialization=0A=
>>   crypto: caam - convert caam_jr_init() to use devres=0A=
>>   crypto: caam - request JR IRQ as the last step=0A=
>>   crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64=0A=
>>   crypto: caam - use ioread64*_hi_lo in rd_reg64=0A=
>>   crypto: caam - drop 64-bit only wr/rd_reg64()=0A=
>>   crypto: caam - share definition for MAX_SDLEN=0A=
>>   crypto: caam - make CAAM_PTR_SZ dynamic=0A=
>>   crypto: caam - move cpu_to_caam_dma() selection to runtime=0A=
>>   crypto: caam - drop explicit usage of struct jr_outentry=0A=
>>   crypto: caam - don't hardcode inpentry size=0A=
>>   crypto: caam - select DMA address size at runtime=0A=
>>   crypto: caam - always select job ring via RSR on i.MX8MQ=0A=
>>   crypto: caam - add clock entry for i.MX8MQ=0A=
>>   arm64: dts: imx8mq: Add CAAM node=0A=
>>=0A=
>> arch/arm64/boot/dts/freescale/imx8mq.dtsi |  30 +++=0A=
>> drivers/crypto/caam/caamalg.c             |   2 +-=0A=
>> drivers/crypto/caam/caamalg_qi2.h         |  27 ---=0A=
>> drivers/crypto/caam/caamhash.c            |   2 +-=0A=
>> drivers/crypto/caam/caampkc.c             |   8 +-=0A=
>> drivers/crypto/caam/caamrng.c             |   2 +-=0A=
>> drivers/crypto/caam/ctrl.c                | 221 ++++++++++------------=
=0A=
>> drivers/crypto/caam/desc_constr.h         |  47 ++++-=0A=
>> drivers/crypto/caam/error.c               |   3 +=0A=
>> drivers/crypto/caam/intern.h              |  32 +++-=0A=
>> drivers/crypto/caam/jr.c                  |  93 +++------=0A=
>> drivers/crypto/caam/pdb.h                 |  16 +-=0A=
>> drivers/crypto/caam/pkc_desc.c            |   8 +-=0A=
>> drivers/crypto/caam/qi.h                  |  26 ---=0A=
>> drivers/crypto/caam/regs.h                | 140 ++++++++++----=0A=
>> 15 files changed, 359 insertions(+), 298 deletions(-)=0A=
> =0A=
> Patches 1-15 applied.  Thanks.=0A=
> =0A=
Hi Herbert,=0A=
=0A=
Can you, please, add, also, the device tree patch ("arm64: dts: imx8mq: =0A=
Add CAAM node") in cryptodev tree?=0A=
Unfortunately Shawn Guo wasn't cc-ed on this patch and, to have the =0A=
complete support for imx8mq, in kernel v5.4, we need the node in dts.=0A=
=0A=
Thank you,=0A=
Iulia=0A=
