Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830CCC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 14:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 558D22070B
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 14:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aULmRl+/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfKTOaf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 09:30:35 -0500
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:28224
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729157AbfKTOaf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 09:30:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaS/VmU3rKOh0JqdNvxNRuVqkon8pg43W8ta3ONRMLMpR5f9l9nb8kn6t9XkqdBBTv3C4tgVycTWMCQm8iqL5gzrAnVeAfCDAf1aEKCQGWEJesHQch7SHCogQ1AXbna5TiNLRCw7vGInToVbeLe4TP7kjv93jHXsazjd4CcJDc3PHgVvbm668yxxOlFY7rm5aCykmMfeHnPiNjrBnlCloCRD8OYYdOF2S7q2XsyJUtTLziKyvfpawBNZfQ7G9wynEGxNbo0bYlqjENO3xxh8xdH4HfSOhl7KDMYlBji8huGdJCRxm891aZ/9wyxIh+VuH+LGLc+1cELSpzr4AeAXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6fbpwxcECZPnKh2clpW3kRFVgUf4g0hAqWqBZG2Oz4=;
 b=l0nV7InMv5UyVUjbyWCxuX/AwccFvFNUSZYdouH1WOOoi2fuVdHHj7RKmeg47PbPYzmHe5exhzBg9Rhc1Vb3/zHa/0a8bbRoMAU8ImW8TGV1ussPuiGbe+GWQJWm2LzXoB3TfvMeJsIVIsEgvU9wrDim8Dv0grT2gvhLlUkCOjIOg1H2yBJwgqhPHZCglq3+l8pzV7g6hJjoRKQ74dwA1dBxOalXBPpA4pStkXv/UlbreiKhfttrAcE/B1YU9t99C8QYE0Jl0d4Ke0UFKmZJgGN8/mAM7Z9b3kbHvnMQzPjAh6GZqrPdfnH6bSdFFwWRvtTKbeyPAfwL2bSPzSVvvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6fbpwxcECZPnKh2clpW3kRFVgUf4g0hAqWqBZG2Oz4=;
 b=aULmRl+/uNJyPgxO69XePj3iYwZ9b4WR4wI3YClQgb68JJcnskUFQKyv+nGm0MVa2V/j+os6GccW72vg6X08ylEXRQ6e1ntJVS2J6JvrD2Xocn3hhfy1rzEUvKoY2EsITVK9+bmdLZqRluzN/HMS2n1331GX1CZ2mQRyPbKNyQQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3344.eurprd04.prod.outlook.com (52.134.8.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Wed, 20 Nov 2019 14:30:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Wed, 20 Nov 2019
 14:30:29 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] crypto: Fix Kconfig indentation
Thread-Topic: [PATCH] crypto: Fix Kconfig indentation
Thread-Index: AQHVn6haznq8vw1WjUKSyFyRA7fljA==
Date:   Wed, 20 Nov 2019 14:30:29 +0000
Message-ID: <VI1PR0402MB3485BE88F8060AF214FE56CD984F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191120134221.15774-1-krzk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 87407e04-47f6-49bd-bf1b-08d76dc6313b
x-ms-traffictypediagnostic: VI1PR0402MB3344:|VI1PR0402MB3344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB33443C0EF64296BBEA26CA0F984F0@VI1PR0402MB3344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(2906002)(14454004)(476003)(53546011)(8936002)(305945005)(74316002)(7736002)(76176011)(91956017)(66946007)(25786009)(66066001)(6436002)(558084003)(6116002)(54906003)(81166006)(66446008)(64756008)(66556008)(66476007)(110136005)(3846002)(316002)(8676002)(86362001)(81156014)(52536014)(99286004)(7416002)(33656002)(2501003)(76116006)(6506007)(478600001)(7696005)(6246003)(446003)(71190400001)(71200400001)(102836004)(26005)(256004)(186003)(9686003)(55016002)(44832011)(486006)(4326008)(5660300002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3344;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IYJI/cbKZhmJLD2KkzEqUAYtAlCXOdeeT5CfNlKgGgc6ogKalUxg/zmDu3tMw7ZABz3//x9vXdJvJbcD2zOrl5Yqbqas4uIOE3Wbx85XlmYbwXviF39bXygkeqYrWigBMzCL8DkitpNCX00BD0Q+WL5nWUIOJa552T6tctjPQ3R9ZQaHMtLC86sGUm+v2zoWG68d/6kmp43PzPMgCkHTwOO/gXc/SAgiyTi/kvPtXy7u48hIl2wnmbX2pZGDJjS6wOtiTrvCkYUg0LGVo48JoDMWDyNEV62fy63zp7xTq9CgTSFPSnbQ+6P8ScOD0l40g2MaYfKwVhbrCjKzYy8nTELwuuR/OjZf+rBYWJEg0dZwHJloDYuuPCqsmWXha9v3olJOumYmmromytal40CPVxMIO4z9MubUGlOd73N0uHF/6nuxCvSWTC6C0UigEj2x
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87407e04-47f6-49bd-bf1b-08d76dc6313b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 14:30:29.2026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzc5eUsN7Mov9hzlv6L3SQRge0EMpabbM0dpHvc9EAJDRIXypUsAU84YltoHsHTLujRo+apmkDTTgkRhFXaQwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/20/2019 3:42 PM, Krzysztof Kozlowski wrote:=0A=
> Adjust indentation from spaces to tab (+optional two spaces) as in=0A=
> coding style with command like:=0A=
> 	$ sed -e 's/^        /\t/' -i */Kconfig=0A=
> =0A=
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
