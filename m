Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA03C2D0EA
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 08:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D802A20730
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 08:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CIvztrBV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDHIPl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 04:15:41 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:47694
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgDHIPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 04:15:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ1vktoeCFBcZahs3Dde3tgjbsrqeV+zQzqZw0giv6MZCwYljAe8Gp5GT13RwJQL15VzJevLqgxuXarGCdMTE5DAk6pBvVinCJo3j8CSUg64VvWIaGeCDrgeQGEPoqqCmUq/JzmebaEMUgaPTk+FNZp64gNqwaIFg2w0mXdehJqPPQJ09+EEp6EtX57M85fwvFQw8eDZ6f3mbd/Y2vg3tUwDhyTGG0bGly67Aidcihix0dRro2XIYrJtkh53a8frQGst+3gdsCp8b9dGknhLofN2i4zgFrEMntud7lo51LKaDEZpN3ZWuh+m4Fj+HIrjCXi3d5zu3sD7eRLeOVQaaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0QaSYlkoBdfpPg2sMKq+a3t6QQKjtVudydYatEdLm4=;
 b=OL85oUSVLldJQYvxhynO0xGfR0Fz2JHRymHmGausnXxJMkhiTUpEZzmhpnGiGlhb0+zVQZGx45dsE/e4IsmWB2DTM2SqnGmTYJ++1udsnYa8PcwI940MPAlufpqIWSVRlmWxLxpheHhIbEMJSxVwvxh1ZpJRc9h40Gr5lxsDHMvxQdNzP8QqlQKSH5JM/anWMF52RtAfewoaBA3m5CPECymNtUpMDHDDM7GrE5JFEAqAMnApLnoE9JPgRn7q0PH40l3i7V5BC1hPqEDnRxIF2l+6jJ1UGmgs17nNHLjHSsEI68pTgO0dym8vrlk7TO91QPDpBzchDg8pPNHUPIWxkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0QaSYlkoBdfpPg2sMKq+a3t6QQKjtVudydYatEdLm4=;
 b=CIvztrBVndXnoMIMkzNlt4hP0Fy6PCK5QGAunOBxrLME8RcBJr9lGtB7RPG6rxNJmnqYkaG7bP+700jCqRXwHTGKo3BZ1WG+dbAnFjV+N2p0zyE8NBPuovCyGqqrSrNc+VCLsXiZnI5K71IU6kjWN1JSGmJEiWKGLjSw69JnV24=
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 8 Apr
 2020 08:15:37 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::c465:f38f:6be3:5d97%7]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 08:15:37 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix the address of the last entry of S/G
Thread-Topic: [PATCH] crypto: caam - fix the address of the last entry of S/G
Thread-Index: AQHWDPV00PSwOi9LsUOpd4pCsi/lHA==
Date:   Wed, 8 Apr 2020 08:15:37 +0000
Message-ID: <VI1PR0402MB371251675D031EBB78F206238CC00@VI1PR0402MB3712.eurprd04.prod.outlook.com>
References: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
 <023d6704-557f-d701-a19b-2edcb002bf6c@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [82.78.65.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e2ceef41-076f-4103-5157-08d7db9504f0
x-ms-traffictypediagnostic: VI1PR0402MB2815:|VI1PR0402MB2815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28159DD6FC8812BB1203452F8CC00@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(316002)(4326008)(52536014)(5660300002)(8936002)(81156014)(81166007)(66476007)(66446008)(66556008)(91956017)(64756008)(76116006)(54906003)(110136005)(66946007)(71200400001)(7696005)(53546011)(6506007)(2906002)(478600001)(6636002)(186003)(44832011)(8676002)(33656002)(86362001)(9686003)(26005)(966005)(55016002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3IfTRrv8mlaxFGB9DaT3vusYHeoZW/qukw1IlBxh6Y7/QajXsXZ+zDsjuhfICEEk0cg/uckRq/RU9e203aolrVTzXD9RkmvTyTsYHsY1fkJ7w3phGDEiGcAlMhYykcSqTkSLh8ENGNq/XWWfMTMKYVGdmqIUwmRZuaJBimtso95uOZW6Tfv/mS+vblj+OhwARNIr80iHIxnPw/DxB36u+7sYdeOpdPQZvkh03kchvVb+mlDXjJ49Vndn0jK/h3OMZZyBAqG8IrO1akQ5D9/7piTU+iKs9rUwRiGIjHd0tN2CNJzKsVu6FeX1bFEQAsegT1OiFpQxfb6zTjOZ2rchh7aZKiAIFSGo2iffYxa6LtCpcpr+juuKO/hK9OXaiMn+uVHLx1M5xuolDkKCepqP/VlJ17hoIX7EF7TpBA/8J/r6W6/prb5TV1qVUL7JAl3BfeISBcBYK5Z1MK7aK3x8O+zEWNdc+QHfjW8PWET45A7pgXpS4OMYEQxulXY25UJd6Frq1/4iUy+aGkJz9nYgIQ==
x-ms-exchange-antispam-messagedata: Q5Exdnzseyo2U6WmDZET6FH0khyEECWIVqAVZGccsejfi/lLV1j0+wmUdeGgIaG5JHMicrhZD04p1NKxjgTAqLJ5rpd7GmmKJEVP2HesdfnnqdnVuOJ1XIh6ZqqAOUwn9vtCWalB1zIBSvr94lsjYA==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ceef41-076f-4103-5157-08d7db9504f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 08:15:37.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwZaLu60D1v9l4q4L9yn7wZ1Qohp5pbYf3Oo/zM+BT3aY99rQPt6xMH925it1SOti84hkd7bE3tWKFf4V+rsog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/7/2020 9:56 PM, Horia Geanta wrote:=0A=
> On 4/7/2020 6:59 PM, Iuliana Prodan wrote:=0A=
>> For skcipher algorithms, the input, output HW S/G tables=0A=
>> look like this: [IV, src][dst, IV]=0A=
>> Now, we can have 2 conditions here:=0A=
>> - there is no IV;=0A=
>> - src and dst are equal (in-place encryption) and scattered=0A=
>> and the error is an "off-by-one" in the HW S/G table.=0A=
>>=0A=
>> This issue was seen with KASAN:=0A=
>> BUG: KASAN: slab-out-of-bounds in skcipher_edesc_alloc+0x95c/0x1018=0A=
>>=0A=
>> Read of size 4 at addr ffff000022a02958 by task cryptomgr_test/321=0A=
>>=0A=
>> CPU: 2 PID: 321 Comm: cryptomgr_test Not tainted=0A=
>> 5.6.0-rc1-00165-ge4ef8383-dirty #4=0A=
> Non-public SHA1, dirty tree.=0A=
> =0A=
> Probably it's not reproducible without applying previous fixes?=0A=
> https://patchwork.kernel.org/project/linux-crypto/list/?series=3D266561=
=0A=
=0A=
Yes, this appears after applying the use-after-free patches.=0A=
=0A=
>> Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")=0A=
>> Cc: <stable@vger.kernel.org> # v5.3+=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Thanks,=0A=
> Horia=0A=
> =0A=
=0A=
