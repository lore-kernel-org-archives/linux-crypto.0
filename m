Return-Path: <SRS0=rTfc=SG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4C7C4360F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Apr 2019 13:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DDA2171F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Apr 2019 13:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="QYQNm9pA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfDDNl5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Apr 2019 09:41:57 -0400
Received: from mail-eopbgr30104.outbound.protection.outlook.com ([40.107.3.104]:38960
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbfDDNl5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Apr 2019 09:41:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZNOowWTrxGz5Kw/wCml6cvTxdxP5S11Gp0KP/Gidg0=;
 b=QYQNm9pA4oVbthFeKKLUwAlK0DeKamnEiuMuDZ6/dVC0DWk1cYqN8jqqzMt/eQRNlVxlxPSwx5HGypnh4Pj77q7fL2EcysTMAZs8/JVSviW9LJK1ZbmKg+4N9C7TibPY2U8idJ6UmKU1CswAvZySotp28nVgt2Mie5dw8nKFCVs=
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com (10.167.221.149) by
 AM5PR0901MB1156.eurprd09.prod.outlook.com (10.167.221.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.17; Thu, 4 Apr 2019 13:41:50 +0000
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::1474:595e:39d3:b62b]) by AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::1474:595e:39d3:b62b%4]) with mapi id 15.20.1771.014; Thu, 4 Apr 2019
 13:41:50 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Zhang Zhijie <zhangzj@rock-chips.com>
CC:     Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: RE: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Thread-Topic: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Thread-Index: AQHU2t+fclaO8KhrhESirEuEC3Q5mqYsHxyQ
Date:   Thu, 4 Apr 2019 13:41:50 +0000
Message-ID: <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
In-Reply-To: <20190315033140.GB1671@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a0457de-10a9-4768-12aa-08d6b9034a86
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM5PR0901MB1156;
x-ms-traffictypediagnostic: AM5PR0901MB1156:
x-microsoft-antispam-prvs: <AM5PR0901MB11567160E8C87E5283C83A3FD2500@AM5PR0901MB1156.eurprd09.prod.outlook.com>
x-forefront-prvs: 0997523C40
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39840400004)(376002)(366004)(346002)(52314003)(199004)(189003)(26005)(186003)(6506007)(110136005)(102836004)(54906003)(305945005)(25786009)(52536014)(8676002)(81166006)(14444005)(229853002)(55016002)(476003)(256004)(86362001)(76176011)(33656002)(478600001)(446003)(6246003)(9686003)(11346002)(7696005)(68736007)(105586002)(99286004)(8936002)(53936002)(316002)(74316002)(97736004)(3846002)(81156014)(4326008)(6436002)(14454004)(6116002)(7736002)(71190400001)(71200400001)(486006)(5660300002)(2906002)(106356001)(66066001)(7416002)(93886005);DIR:OUT;SFP:1102;SCL:1;SRVR:AM5PR0901MB1156;H:AM5PR0901MB1155.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z/tjVWRf5yceqiotwxSEUgC5xzf/p9Muggz03REruRnx9ytn378zyqZ8W+A8bybDiat5bipmGwfgMZy+jHwYEiDTR9mMlQAjgV92ame9A9pTujf4ILBGZT7DsPMEuX7Q/q+Ia3HtLBgCukSEc5x4u6O1Me0shTWXz+nPOJBdisIUW/D4iFfLy2BhT5VFoP06bOjgt/1mTbYN+zJde58Te8T+eEWARULNSL66qb+TJOeV06Tv06Fhp+sL2bF+B9rPXFpeg5NU+usoWLovDAThK802ovpuK5RVb4bxYJqibT9Wxqx5un/0VAqN3du5ywo0y7HjnOPCv4xsHVacdpO0yALLgHQgY+rdCJij8qF6KTNRXX+fl0b59YLDWA1lItTmDTjnkDnkyyrjdyNuo5ZVX9VA2d+NjVNg6j8WjhfylwY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0457de-10a9-4768-12aa-08d6b9034a86
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2019 13:41:50.3682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0901MB1156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> The issue is that the self-tests now verify that CBC implementations upda=
te the
> IV buffer to contain the next IV, aka the last ciphertext block.  But the=
 Rockchip
> crypto driver doesn't do that, so it needs to be fixed.
>
> This has always been a requirement for CBC implementations so that users =
can
> chain CBC requests.  Unfortunately it was just never tested for...
>
This did not immediately trigger me when it came flying past a couple of we=
eks
ago, but I ran into the same issue today with the inside_secure driver I'm =
playing
with: it does NOT return correct IV outputs for CBC modes.

However ... I'd like to question that very requirement ... if I may :-)

My reasoning is that this IV output *is* available as the last block of eit=
her the
output (for encrypt) or input (for decrypt) datastream. So requiring it to =
be
updated in the IV buffer as well seems redundant to me. It burdens the driv=
er
with an extra data copy operation, while in the majority of practicle use c=
ases
you would not even *need* this output IV. (chaining IV's would not work on
a hardware accelerator anyway, because you would need to serialize the
datastream, meaning you run at the speed of the round-trip latency instead
of the throughput, which is typically one to two orders of a magnitude slow=
er)

And in the odd case you do need it, you can just grab it from the data buff=
er
yourself.

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines

