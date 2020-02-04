Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A936DC3524D
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 14:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75FE22084E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 14:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kVH5JxNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgBDOI0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 09:08:26 -0500
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:29667
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727210AbgBDOI0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 09:08:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZIQ1j81TPp80gTQIylo5gbitsA77GwhE/7ZvIXGmz/KyFxq8RTJ32/KV3P1hhUhmTyvkGkrb7X/pXpI7RaUIXPPKN5Yl7IxYHiCFUqs8mHlJWbr2WtX0s0aGcNjddX6iPgKdyE7SPLExvy1N3ZKnQ+KOU2nVPFHyFAd0UY8JkIiiUDLlJMSmspk8SF8QIY9zS52C02nhcebXqzUCkMetiwq3qUcS8IL8NoQtOQNok8eddhpLvQ6gfNq+e61NuITGUOwYBmtTy6xMroNLiQakkhu7JHNiAzEe8EwFhSbAlUVx9ABCqdxn8YvMQTfGJX6AlrjyBDNyTkOhk6HSJdYZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2RvehsuBBP44KB6zOhDPrdWQ0L4M24POqLlm9qZlto=;
 b=OQPU+gVpPuyugix7BI6vhsZM3o1PfbwcEvZh7XYwEW/jbxhiuuYWWUtBfGTkbN1UQXt57mXVAo6oksMoFUzWsZAy1XxujapvQQ88x2IsmeaM74sQzPGvjFcwYyutv+SWF5ojA7cC7SU0PePZqK/gmdXPNG0NvQ8qKtlWCBqn84sx4Piqd6q9xCVpvKjVQ8InTkqKWo4kRTnmInXuiM3ckb/JswcnvZNqXoDX2Avxj6WUqlKaN51TGrpzEAe92VlXhhspeRRxXyl7Q5U0rBYb6n2dSFUii6b5vnXnd2EWb1o2ooNztxf9bj3KipVlsNlsFNOjM3FZlVxxlJ4baqXXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2RvehsuBBP44KB6zOhDPrdWQ0L4M24POqLlm9qZlto=;
 b=kVH5JxNLABC6/R88v2ZSWwZYPSlvFVIOLJq9HHGKVvbFtXYF2N7xFSpQ2BEvC2NxcXriRncCfPbrTFrjRh3o/+CCGjvAnkMBLiHxioPyaT3CFGKqaJRtXceLgQS+YRIK2vPWCSTlJsiC89kNxcoSazLeHBDG2UxlShTBSWTTubU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2814.eurprd04.prod.outlook.com (10.172.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Tue, 4 Feb 2020 14:08:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2686.028; Tue, 4 Feb 2020
 14:08:22 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
Thread-Topic: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation
 descriptor with GFP_DMA
Thread-Index: AQHV1TLP0i8oyBdn6EKevKHj+QF50A==
Date:   Tue, 4 Feb 2020 14:08:22 +0000
Message-ID: <VI1PR0402MB3485FF5402B8C0FFF48FBF2298030@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99aedb3b-81c5-437a-d9dd-08d7a97bb1e4
x-ms-traffictypediagnostic: VI1PR0402MB2814:|VI1PR0402MB2814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28142875E205389773B2A26C98030@VI1PR0402MB2814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(189003)(199004)(91956017)(66556008)(66446008)(76116006)(66946007)(66476007)(64756008)(110136005)(5660300002)(4744005)(54906003)(26005)(71200400001)(316002)(6506007)(53546011)(33656002)(44832011)(86362001)(7696005)(55016002)(186003)(4326008)(478600001)(9686003)(52536014)(8936002)(2906002)(8676002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2814;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LZpyo1amEVGjUBGJqR2OkzyTwkxjjR8S+ifsqfdxSOISK1csspvvWurykZDMYA9OB27JoRudUy2gpcmHEMv0ebmC7RslPJlz28XNDSFokrtvYLDJ4h1rYb6pqepKot009gNOjNST1NP847SICh8+dhjD/fnX9UJAeg/lIAq8M0CYwQIsuNppkA5z9IjiWqfVQ9bCyqnwlbYkdkd9BQbqRFzacI7ioHHcH85/4mJ8iyNtAkYQsnhbNM2h4mgVsZ1EgIS+MroNTF0yzlH0coxKlqo0NVS+L+2ukCUnlDZb6apeG2XYKAC2e6uPCBhSDxdPmTKZh3oEGoWOw2xy7Sr6+c4uBU4IG6GUPS821jQ2eLcx05+jM+s1eQwFFYLymNKcGFPph66mu8h6CcQtPOG/MW9QJB990e1Axy1TwHZZ5CweGN13RJ8ynpPvqH16gOe/
x-ms-exchange-antispam-messagedata: eKo64oB86Qq3qrx6jEz3qn+WAHnRTT33IwYElR8gMXIGzz6BqgX0f6TSxkNkYWCqAG/2oj53Lnekz5zF3KPuaOzBY901/eF+kpjvBdAL2kI7P63gIKr7U55GPtZOKGRigTPxpC6uzay4tdpmtkwpjQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99aedb3b-81c5-437a-d9dd-08d7a97bb1e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 14:08:22.5292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0j/Ms00l3Kx/lRT5wejPT3TNfjZ/Q3EF6LD9d0zrMlV2ESnJ1S6IdX65BWZ14oxz4FkpHPw9OflYTCqbGHaGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:57 PM, Andrey Smirnov wrote:=0A=
> Be consistent with the rest of the codebase and use GFP_DMA when=0A=
> allocating memory for a CAAM JR descriptor.=0A=
> =0A=
Please use GFP_DMA32 instead.=0A=
Device is not limited to less than 32 bits of addressing=0A=
in any of its incarnations.=0A=
=0A=
s/GFP_DMA/GFP_DMA32 should be performed throughout caam driver.=0A=
(But of course, I wouldn't include this change in current patch series).=0A=
=0A=
Horia=0A=
