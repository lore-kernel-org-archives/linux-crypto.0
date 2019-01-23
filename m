Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A06C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B5120856
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=CAVIUMNETWORKS.onmicrosoft.com header.i=@CAVIUMNETWORKS.onmicrosoft.com header.b="OSeMtJRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfAWNab (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:30:31 -0500
Received: from mail-eopbgr750077.outbound.protection.outlook.com ([40.107.75.77]:3517
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbfAWNab (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 08:30:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-cavium-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lykaplj2STb4WGjZoD3KLti7Uo5E/uUK2vzcVx3Q+/0=;
 b=OSeMtJRc3Ow8PoBCN7k2zGwG0ZWwIeRLWiY71yzDou8mQBj2elA2mbwoBH0I1Kcwc5VfhhqGPVB0KjsZG912gZFIHkU/mCKdTm8wIqI9BocteraqDZH2XRsKk1puRY7TDuPRd6dH/Q/aQdUHBjnxatU4L4U15ymwqfrLj4cG52k=
Received: from BYAPR07MB4599.namprd07.prod.outlook.com (52.135.204.25) by
 BYAPR07MB5782.namprd07.prod.outlook.com (20.178.0.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Wed, 23 Jan 2019 13:30:19 +0000
Received: from BYAPR07MB4599.namprd07.prod.outlook.com
 ([fe80::f549:786e:dc77:f919]) by BYAPR07MB4599.namprd07.prod.outlook.com
 ([fe80::f549:786e:dc77:f919%4]) with mapi id 15.20.1558.016; Wed, 23 Jan 2019
 13:30:19 +0000
From:   Jan Glauber <Jan.Glauber@cavium.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Richter, Robert" <Robert.Richter@cavium.com>
Subject: Re: [PATCH 4/7] crypto: cavium: zip: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH 4/7] crypto: cavium: zip: no need to check return value
 of debugfs_create functions
Thread-Index: AQHUsx/IvviD8o8m6EW/rhbqghkiag==
Date:   Wed, 23 Jan 2019 13:30:19 +0000
Message-ID: <20190123133010.GA13961@hc>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-5-gregkh@linuxfoundation.org>
In-Reply-To: <20190122151422.14204-5-gregkh@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::46) To BYAPR07MB4599.namprd07.prod.outlook.com
 (2603:10b6:a02:f2::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jan.Glauber@cavium.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.5.44.95]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR07MB5782;6:4JVVMPh8rOb0t9TkPgsP8eBfgF40lGgk+WZuUZk+04iFrNWLkb+GoOZ8NPTkQScHdI77m2FM3fVY375vZN6BH4OG+Jp/qu5hQQQyTVjUy3w/aM+4NyEGuVlcFFmDQgxmSScGS6NAGdSwMStl4gWuszC//KCOIX2AzY8QPIoWe8NGIQBeKeg7OCDXUS0h3X0sjAEOblrOX8hyrIKCaFhbEgIwRhLQYr3XpGhu8J1w/8xECLEtf9ZO1WdyBWwG2VJGFyubAhR/EuFHdFbheKkGG02fyigP3Pjzy+TjaSz+YjzPwbpr7Y/SxM/B83HmFH54ApoCyzBU8OmXOvulAcwaaQfvvVpZtZnEbtV+rwxGUo+KV2t3i5o2SVffilV8tbtEcYiVYePWKZpBU42o51J1bxQZOzDIs1ubEjBl0zH1lEyV0uYYvSvRxlsBZXAUnay4NHHAalEhivKVuyArylicSw==;5:BNd6pOxMS5wnIg70iWCg0J6caC28RXOEubtwnroO9jMvIWHfyH4LvcXq4axZQQc6IHMFsuOuojT7f9DrXUro0aTZY1AhxMJovdZ/oEWJXv75scH+hl0guZ7JNreLqBKpvVExbK7ysw4EgZnr1nj9C7iBGYvEMsDGW9b06TqX5Cx6Tt6EM+5vAvl4nhukllPxlk0C4ZYX9AuFg3T7IxxC+A==;7:wlzT1CCiP98Yhb+Oo/0pWHKvzyFR/CRFrtA17FQr7BwZWuClUAMMb3neV6yrG2jhNRbEJ+pJLaF7v5OiT0RzM83alK6pXhtVyzHuDLJbQq5B8c3rp5uvx1zu+3XoU41+C3BpPr9+yzNRufulmEfMLA==
x-ms-office365-filtering-correlation-id: c4adc9de-62f0-461c-e304-08d68136eaec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600110)(711020)(4605077)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(7193020);SRVR:BYAPR07MB5782;
x-ms-traffictypediagnostic: BYAPR07MB5782:
x-microsoft-antispam-prvs: <BYAPR07MB578235FC6E3AF8D966271CD591990@BYAPR07MB5782.namprd07.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(346002)(366004)(376002)(136003)(39860400002)(189003)(199004)(71190400001)(71200400001)(107886003)(25786009)(106356001)(44832011)(105586002)(68736007)(102836004)(256004)(6916009)(66066001)(229853002)(33656002)(72206003)(6436002)(8676002)(2906002)(3846002)(6486002)(6116002)(4326008)(14454004)(6246003)(316002)(508600001)(33716001)(53936002)(76176011)(305945005)(52116002)(7736002)(9686003)(99286004)(8936002)(1076003)(26005)(486006)(386003)(6506007)(11346002)(97736004)(86362001)(81156014)(81166006)(33896004)(476003)(186003)(4744005)(54906003)(6512007)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB5782;H:BYAPR07MB4599.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cavium.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UFZc/ql26FXftU207VjHrgTsvc1CK1v7HqHxaF7d+cKVVwZMVUBEbkkr9JlyMXYCqYBoi0GFbqW0yPs3+92rbvRaaKWtwxmoe1Fq/n3IAxoGrDjwoUL9+DFHZlvb9fMJmrJoDctZ/RfMBDcEyWplzptcOc07V3dWDJfe/ghT1GthyXHKXREgr3GHu3FUsz27Lym95+vEhIC4nnwjbp2V+QgEDAZU3HovqutSZ+ld51rgrsrQMWeUYgXGMqSgC9aENACd9YJvxgd53QM0U6VI/sYzMdEEUTAIzRBVlRitnPpqOw0rf8zSA86RBdUGT0m58N5HG9En5NyQRxvselpBx+1qdiq9K251WQ0PKG0VljCeCOschaDwdc0QWmUIx5v6bBxX49pfRp4Uklb+MG4XeBxepKZTq2sihNejR8DzvIU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <421AAA6FEBD1E6428ED9DC9840B2A5E9@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cavium.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4adc9de-62f0-461c-e304-08d68136eaec
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 13:30:17.3802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 711e4ccf-2e9b-4bcf-a551-4094005b6194
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5782
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 22, 2019 at 04:14:19PM +0100, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
>=20
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Robert Richter <rrichter@cavium.com>
> Cc: Jan Glauber <jglauber@cavium.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/crypto/cavium/zip/zip_main.c | 52 ++++++----------------------
>  1 file changed, 11 insertions(+), 41 deletions(-)

Reviewed-by: Jan Glauber <jglauber@cavium.com>

thanks,
Jan
