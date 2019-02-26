Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD5FC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 14:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EF920C01
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 14:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="G81fk3I2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfBZOxv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 09:53:51 -0500
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:53261
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726542AbfBZOxu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 09:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsD1NVKX8pIdjVK+dEpSIpw+wXGjCJ5zbA3q6UWNvPs=;
 b=G81fk3I2n5sjCV9LsD5ghAbzwmZAAMgJJvh1MNwrGMTwyO0uYb0Lnl03ivhG0khKpzl0974ppb+8ZCZ2H5tllA2SD9m0hXAdVU7sfZI1Myep3vwsJWMCi92PnGmVAm6jflrAlhjbaQo3AVaiT0u8zJL2CLFaWlS7sKwTGAJqGxI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3501.eurprd04.prod.outlook.com (52.134.4.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Tue, 26 Feb 2019 14:53:42 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e%3]) with mapi id 15.20.1643.019; Tue, 26 Feb 2019
 14:53:42 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Chris Spencer <spencercw@gmail.com>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Topic: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
Thread-Index: AQHUypZsrSD4izM7BUuBqlVaxZEyMQ==
Date:   Tue, 26 Feb 2019 14:53:42 +0000
Message-ID: <VI1PR0402MB34857504705A898A59085B4B987B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk>
 <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23b49d38-d59e-445b-737b-08d69bfa338f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3501;
x-ms-traffictypediagnostic: VI1PR0402MB3501:
x-ms-exchange-purlcount: 3
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3501;23:YerR/5mRk34MX29KLCKb+eXQK1uC0Y71guM8mqh?=
 =?us-ascii?Q?h4WM/wx14iw8dtpcSYHO7qwtxZOdCOpNvXj2XLyZ2oEr6ms9iB9uzvX3Olq2?=
 =?us-ascii?Q?BzjlM6Mq0fy8zdA8kClf8+TJKI23dBPxkpYkVgqTkl+tCgUJWsZYn99eNBEc?=
 =?us-ascii?Q?OY+9DzWKEiKFaH6HNXDE9d/S3cFqJ4pvX+WzZsuvBkHrMOSQX9Y5EyaLUPab?=
 =?us-ascii?Q?O0pAcqghnNkSLnOA7g48jA1cvjo5NKfmQP7wXlYwM1b2K0satdLmWpinuiSl?=
 =?us-ascii?Q?Utu+sxV6m4vZI2HtTj8ZctxahhlgtZI3/fmi8F3MMNlHLtej7EdpyXLfLIZL?=
 =?us-ascii?Q?xkQI/iKBvw0khOHkgr3YffwCy5jaRIvZvmQ34Ic3uzxSPBXokxbZMnuBrVri?=
 =?us-ascii?Q?RbDs4ItxdMoMUuRjdsNffS0FZcXAR8eSMp1BF45lq0FD059E/R1n45FqWQaO?=
 =?us-ascii?Q?UzTYOiECNr+nvvoANoarXqa+A9JGM4oVKEvyx7uhbI5FBgE+8/Yo6zYaAxFg?=
 =?us-ascii?Q?ETjT+wklsN66qh9rrwoHB4JwBcbCCQVffUN8hKaQ6lkuobSVyzaJTDxHl1DF?=
 =?us-ascii?Q?iGIsm15NBSdmWMgQxs52PZGLaXul6FwNfCsS9x1bOb4ZGyxPFwYCd7eY0c+U?=
 =?us-ascii?Q?aGzlMoVc+bp0qE4y8oFeJl98b2lUcwxqtgzGjlZcLvlrcWHY6r6zc/RQNtgF?=
 =?us-ascii?Q?TXQLpAj9tB108HPT8ngryAYtrnhOm/lmTDWyL8k8hhG8dFfktZEfUGcBa07a?=
 =?us-ascii?Q?mNsjpcQhSUmBJgQzuEKx6RzD4G28MDN84Ao/57g0NXOz9AyLAcqUS2NgwKex?=
 =?us-ascii?Q?zupU/f2nj+dQ8+mh+CAQHlkPuI9tkPKcG4vO2ZWsrWuLKbR/xNecfUELs71X?=
 =?us-ascii?Q?C/ytA9pOWCdFKjX9vNC87fzglgDD9A3Z6z/hBeHmB+bRWL9osNX/2NcUVwOf?=
 =?us-ascii?Q?bpjNiF2pIi2XyR7ICzigEPaLZWJkuyOWPBu/Jxcu40DMXET96mZg05SY1L8h?=
 =?us-ascii?Q?PFJW92bCvsV0WSa+AvwLCIdD832YoWFGLGNVMj6rMtEcoB54PLkHc8Oct/mO?=
 =?us-ascii?Q?0biY5D5BgD9dDF6LyuXFv7YBq33sqbOz19VGiwcjX8/rMeb7gZkdOA1kNPAA?=
 =?us-ascii?Q?85KxMVCxvjsKrHQgOG5mhAt0Ep8S31bacoQPGm8aPEEk0pcLo3MdL9DyHXI+?=
 =?us-ascii?Q?V0N+gmzttrVP5dZXIZk/q6Bsi5YiIkZ5qWqgY6B9ovuy/bPNbu3HdQlWp2fb?=
 =?us-ascii?Q?JIUVnujEhtrWpfknFJuiBgv7QYcy+QTBBHAJUEUOfnIhhOShswbVQ/1EANHR?=
 =?us-ascii?Q?T+vcZoG4/EUf11RubQa6qGJiKW38zpnovLrDlLQ6SOK23?=
x-microsoft-antispam-prvs: <VI1PR0402MB3501658D708A2605264CFD84987B0@VI1PR0402MB3501.eurprd04.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(9686003)(3846002)(97736004)(7696005)(25786009)(71190400001)(71200400001)(54906003)(5660300002)(66066001)(81156014)(81166006)(6246003)(6306002)(7736002)(4326008)(44832011)(6116002)(53936002)(486006)(8676002)(76176011)(476003)(1411001)(52536013)(478600001)(74316002)(86362001)(229853002)(316002)(68736007)(106356001)(14444005)(8936002)(26005)(105586002)(446003)(55016002)(99286004)(305945005)(53546011)(93886005)(966005)(6506007)(256004)(6436002)(2906002)(186003)(14454004)(33656002)(6916009)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3501;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wdXXOIMwzY71RmOOHbB7sVP9VlSODw6hpV5D5h2DSEhDuGrHZeIBTC1X7jHPo1N06+ZIvh/BD8X9N70uzz3qGazpknhrq88etlf6aYCOW1dF4djDxtS2rQPVufV/AwkbkuhBCCSE0xb4q9KP03MD2c7NE5LHnvcnJcHwPHI+2ol596u9vOk28JCF7a8/fW+pbrCXxDyW+4UU+1iXUhFJdYKlZ+ler70XzPhang9IfvPQomlPb4/r4Dd6W5QgrelsMGg8SXesJIKsJd/7toIM1wOj1E0NI8NWLGp3D0SQO7DSXfsniXuJOqozYcCtrtZZvwgC83oXDBb8+i2hC6PpSLUiRVKH7XmaiiE8VVw/L6S2N4P641gonT+pX9AZDIPUiWpXeF51u0/f6QpeAGGrv1jcpHMjqdTSZyZpgIWKhFk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b49d38-d59e-445b-737b-08d69bfa338f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 14:53:42.7151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3501
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/25/2019 4:37 PM, Chris Spencer wrote:=0A=
> On Mon, 25 Feb 2019 at 14:22, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>=0A=
>> On 2/22/2019 12:07 PM, spencercw@gmail.com wrote:=0A=
>>> From: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
>>>=0A=
>>> This is required to support the i.MX8.=0A=
>>>=0A=
>> Why exactly is this required?=0A=
>> You should provide more details.=0A=
> =0A=
> I don't know. :) These changes were made in [1], although the change=0A=
> is actually described in [2] where it says: "Use a Job ring for RNG=0A=
> instantiation rather than DECO, even for i.MX6/7 families." This does=0A=
> indeed seem to be necessary to get it to work, but I can only=0A=
> speculate why.=0A=
> =0A=
The commit messages you refer are indeed rather poor, however you need to=
=0A=
understand the context: the history reflects NXP internal development.=0A=
=0A=
It's expected for the changes to be clearly explained, justified when reach=
ing=0A=
mainline kernel.=0A=
=0A=
> The original commit which added the run_descriptor_deco0 function [3]=0A=
> states "[...] and another function that performs the running of the=0A=
> said descriptor using the DECO debug mechanism." My best guess is that=0A=
> the DECO debug mechanism is no longer available so it has to go via=0A=
> the job ring.=0A=
> =0A=
This change is actually orthogonal to i.MX8 MQ support and is related to=0A=
SECO-based i.MX8 SoCs (QXP, QM) and/or OP-TEE support.=0A=
=0A=
Access to CAAM global registers (CCSR page 0) won't be allowed in cases whe=
n=0A=
Linux runs in Normal World.=0A=
From this perspective, it makes sense to eliminate accesses to these regist=
ers.=0A=
Some of the accesses are done for RNG initialization via the DECO debug=0A=
mechanism; to remove them, RNG is initialized via the Job Ring interface.=
=0A=
However, I still see some illegal accesses - for e.g. reading RDSTA registe=
r to=0A=
check which virtual RNGs ("state handles" in RM terms) are already initiali=
zed.=0A=
=0A=
It looks like cutting access to CAAM global registers must come with some=
=0A=
assumptions (since it implies some checks can no longer be performed, see R=
DSTA=0A=
above).=0A=
For e.g. in case OP-TEE is detected, we could assume that RNG was already=
=0A=
initialized. Similar for other cases like SECO f/w (i.MX8 QM and QXP).=0A=
If we make this assumption, it actually means RNG initialization is no long=
er=0A=
needed:=0A=
=0A=
if (!ctrlpriv->mc_en && rng_vid >=3D 4 && !normal_world) {=0A=
	... // rng init as before - using DECO debug mechanism=0A=
}=0A=
=0A=
>> Strictly related to the implementation, why is the code moved to a new f=
ile?=0A=
>> Please do not shuffle the code without providing a good reason.=0A=
> =0A=
> This was done in an attempt to keep it reasonably close to the changes=0A=
> in the downstream driver. The file was moved in [1] with the=0A=
> description "Move the code related to RNG instanciation to another=0A=
> file to ease comprehension."=0A=
> =0A=
> The RNG initialisation code is not really needed in ctrl.c anymore=0A=
> since it is only used in jr.c, so moving it out seems sensible.=0A=
> =0A=
> Thanks,=0A=
> Chris=0A=
> =0A=
> [1] https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/c=
rypto/caam/inst_rng.c?h=3Dimx_4.14.78_1.0.0_ga&id=3D5fd8fe866172c38e8cd0774=
1d98d79b995f05bc9=0A=
> [2] https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/c=
rypto/caam/ctrl.c?h=3Dimx_4.14.78_1.0.0_ga&id=3Dafa53c2c96a54b4432a26372e3b=
5e7dbccbb9671=0A=
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/drivers/crypto/caam/ctrl.c?id=3D04cddbfe6b5f334aa337a1a9797eb8914822f2=
f8=0A=
> =0A=
