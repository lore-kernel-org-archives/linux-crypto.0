Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B355C32750
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 13:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92108206C2
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 13:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="HgzcOUOe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfHMNiJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 09:38:09 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:45834
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbfHMNiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 09:38:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMDMLXrlAR36IQexByfuneBdjzpoSuvTEHQwgA2V4tl7ds4UYalzMUc9F4C6dEM2Dl/CJT5fo/dlYUiUp3DoH1LOePZXvpyOTgyrb0cXHoH3bHz2EMy2nLmzjSrEaQQB35jMCoqST4g1q8doD/J49eoDiyYcyQleMhrTtUyb5b8/SNotvwN/RlPYZIQ9fTXRu1y8beXT43+A3vOebWj4PBI6/1EC57Tb0ig1zOsBN7CDI2PGDdcEoicXQLAG3jMCQmqA0ooD43QvBfj+MBrtKx2+c13vl+ABYO0gmdTze3CPoB+xjx/0GHFSLIvsIPqH/942+D8JuYiC7XsiBMiCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EH+lXp56FCAOt2aznN5ieP8SHBebcgP4yvq45d89AHo=;
 b=nn5c4V8r2uFmzhZGtQULr4dHrnj0gazAwdv9WMjOKLIQxfjRVdxlRm8T8lLs0py1cWu9PH0gO0+d5VaCr+eRrewMhOBVQll82iRzu7JDJDoFi6Zk8AXOthMocXjEjat+qkeclHSqyujFPW0Yihz9HDXrsjeDdPc9tb0rvxNK6fL0ud1QzvS5NlQo2OlqI1Aic8x9sumgcRsw8ow1upEQspaImyOKIUbohF9waNFa51xNUCjyoNpyXbkbQAbk03rJVWhbf0eiAncxAZuFhWXBUCPHsseC3yEAA3j1iUbZsBKuQ2lLeBGnX4UrzWRLSvCrys4avEcl+sI5KDShBbd9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EH+lXp56FCAOt2aznN5ieP8SHBebcgP4yvq45d89AHo=;
 b=HgzcOUOezf1ltNnjyKBUZG3nCls2W30n2x8dNliEoUgVCXMDZ4QtWhxDUDSu3QP6fGw2CpbcA6HbQc1ZhlR8tXV0epwTfq7tLNB/SnhB/3xcQASxMXza2b+oHCAI6yq5kI3ADMn2WooCQOuTP2iLNGY20mVF/T5Cc8P6D+kZvnM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3630.eurprd04.prod.outlook.com (52.134.7.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 13:38:04 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 13:38:04 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
Thread-Topic: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
Thread-Index: AQHVPLPfAFYTXvqoskun8b5hNYNNGA==
Date:   Tue, 13 Aug 2019 13:38:04 +0000
Message-ID: <VI1PR0402MB3485AE1FD97765AF1D43BAF298D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-13-andrew.smirnov@gmail.com>
 <VI1PR0402MB348580480F5EAF5F539B585A98DA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqEiCkXP+-w9WUc33oW6vDhHza2Jq_kQsXjKZ+__T5g77g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e8bf53b-318f-429e-283e-08d71ff3781f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3630;
x-ms-traffictypediagnostic: VI1PR0402MB3630:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB36301F3D0704AC82FD4EAEC698D20@VI1PR0402MB3630.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(54906003)(33656002)(4326008)(6116002)(52536014)(316002)(8936002)(66476007)(64756008)(66446008)(55016002)(66556008)(3846002)(6436002)(229853002)(44832011)(486006)(6916009)(76116006)(5660300002)(25786009)(66946007)(476003)(91956017)(446003)(9686003)(7736002)(26005)(74316002)(186003)(7696005)(66066001)(76176011)(102836004)(8676002)(81166006)(81156014)(99286004)(53546011)(6506007)(305945005)(2906002)(71200400001)(71190400001)(6246003)(14454004)(478600001)(256004)(86362001)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3630;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3Ajs+YTKMgb0CLnQTjYSZpm2N1+6OObJgLTCUI3S27FWD/u/q8MXGXDAXdXbmWMom9JGwUkAUBAud36SPvqnmO01W6MQo4rgQnboiiFxZj8xjvD7i1mVgMCNy1WYUTqXfo7+0+NdebP0lF11qs+1AcYTzXQ7lzLFExqQ63c1Skxx08UQ1XdK9PhQBrb/RJXQNqsBWnqu2TG19V86EoM0yYa6f4cluixkAUjkW3u380fwkhq6YNJh/XztIfMvHig4jD0QMM6reiett/EfuGVD6FtR/IjhMyGVz1xq1rT2rP1gcThQNPS2Lxcviyte+5kdwptschyj/XhWp0j5A6lI0UjwgvsDouLXZ9xm08YMKcbbKfhjTJEjI16xoGjNhoDBNQxOCPGqW/YcHBGU//svMbH0w2NlEScswvXmQAT68vs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8bf53b-318f-429e-283e-08d71ff3781f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 13:38:04.7906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4WNdfPLdcfBI+nIhDClaByIDIkUldbf56YTTqqrKPTyDdAtPsegXXFUYHw+/uYzPffMtf2nRE+pFvai7PhhMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3630
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/12/2019 10:27 PM, Andrey Smirnov wrote:=0A=
> On Mon, Aug 5, 2019 at 1:23 AM Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>=0A=
>> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
>>> @@ -603,11 +603,13 @@ static int caam_probe(struct platform_device *pde=
v)=0A=
>>>               ret =3D init_clocks(dev, ctrlpriv, imx_soc_match->data);=
=0A=
>>>               if (ret)=0A=
>>>                       return ret;=0A=
>>> +=0A=
>>> +             caam_ptr_sz =3D sizeof(u32);=0A=
>>> +     } else {=0A=
>>> +             caam_ptr_sz =3D sizeof(dma_addr_t);=0A=
>> caam_ptr_sz should be deduced by reading MCFGR[PS] bit, i.e. decoupled=
=0A=
>> from dma_addr_t.=0A=
>>=0A=
> =0A=
> MCFGR[PS] is not mentioned in i.MX8MQ SRM and MCFG_PS in CTPR_MS is=0A=
> documented as set to "0" (seems to match in real HW as well). Doesn't=0A=
> seem like a workable solution for i.MX8MQ. Is there something I am=0A=
> missing?=0A=
> =0A=
If CTPR_MS[PS]=3D0, this means CAAM does not allow choosing the "pointer si=
ze"=0A=
via MCFGR[PS]. Usually in this case the RM does not document MCFGR[PS] bit,=
=0A=
which is identical to MCFGR[PS]=3D0.=0A=
=0A=
Thus the logic should be smth. like:=0A=
	caam_ptr_sz =3D CTPR_MS[PS] && MCFGR[PS] ? 64 : 32;=0A=
=0A=
>> There is another configuration that should be considered=0A=
>> (even though highly unlikely):=0A=
>> caam_ptr_sz=3D1  - > 32-bit addresses for CAAM=0A=
>> CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dn - 32-bit dma_addr_t=0A=
>> so the logic has to be carefully evaluated.=0A=
>>=0A=
> =0A=
> I don't understand what you mean here. 32-bit CAAM + 32-bit dma_addr_t=0A=
> should already be the case for i.MX6, etc. how is what you describe=0A=
> different?=0A=
> =0A=
Sorry for not being clear.=0A=
=0A=
caam_ptr_sz=3D1  - > 32-bit addresses for CAAM=0A=
should have been=0A=
caam_ptr_sz=3D*64*  - > 32-bit addresses for CAAM=0A=
i.e. CAAM address has "more than" (>) 32 bits (exact number of bits is=0A=
SoC / chassis specific) and thus will be represented on 8 bytes.=0A=
=0A=
Thanks,=0A=
Horia=0A=
