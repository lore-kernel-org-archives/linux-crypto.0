Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2254C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F6F2230F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 07:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="JRCOnaMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfKTHGP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 02:06:15 -0500
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:61158
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfKTHGP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 02:06:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMFjeYY5YXEq5wUBEBmWQq1+Xf1/cvEcyvSBEgMk78JPy6850XXWrMyrleKFFq3y9O4HF2mBer0oLNGjTfQKEs+LUFn+SKRbGEC+RzzAx/JGvpi2dyIvj0UdyG6IqA8PrCcfONue81taZXYY/XGB4xEEHPhzW3SSqkmWb26Zlu9AMB79Bg3hQH2azRtn2gIjRRMeVeSL8xy/VoL1G5rTbRY9PPkNIVHlzHotfziM+A5cjJroHb18E2Azrc7Th8IAzW8nhw6BsIZMJXA8ZTMXo8u0XBYe4pKKpfw+zBpyqn5Z940M06UOvnliNIB44ZC7wAKmNV+8UfMBHfXMiPMr6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR6HH20iOyEobUKXR+uZvsCOLAJEQWDCvThIzSbb8oU=;
 b=YybgNv96j1t+B0W5gj+vBtyB/Jt2omB6ngmRD2mvmzWLwFMGP/vWaC2GxlvSEVuvS80mLwf3tEcwphyq9OIH11GILnndEYt+EvHPG903CWV1BryCRbDXQdvZK83egVv+5oaSwxenleNRhK4c+ypn+XyP6Pj9nqzfVVvH+w1yR0/5nv5Z3KpraKhCb84BSLSfAbF11r0zbpSjyUDHg25ypgsqqM8dYEOxgjPUm1yr44B43yNbjK2oSaYeyxNq4a920iCRRuojXf1oC1A1hWkbvbfv4ktGBAe/SyyHnyBslqQ6ZklN0IOhkhQap9Ehv8318Cjq62Y4BWxRWg3sYMpuLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR6HH20iOyEobUKXR+uZvsCOLAJEQWDCvThIzSbb8oU=;
 b=JRCOnaMpvkuOLKKycgHeu2a4nfcUwiljoj3bPJHfsE7vRE1CkrroEaYEiOqCxFUND4e4vgSfanxFqZZhflb4LI3Y+a97Nroob2apCFuhBuo+t9mVFYgoM4VFDB5cEMfesY5yf0OTEVWjN4bkGDo1xxRqvI57Y2DPVCK1OpRRNec=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2846.eurprd04.prod.outlook.com (10.175.25.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 07:06:09 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 07:06:09 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] crypto: caam - use static initialization
Thread-Topic: [PATCH 1/5] crypto: caam - use static initialization
Thread-Index: AQHVk+uo5Ig2sdY7ikuWVk1lodRIAQ==
Date:   Wed, 20 Nov 2019 07:06:09 +0000
Message-ID: <VI1PR0402MB34852B194D4CB5051732AD41984F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <20191105151353.6522-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5a7aba7-bc6a-484c-42da-08d76d881efb
x-ms-traffictypediagnostic: VI1PR0402MB2846:|VI1PR0402MB2846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2846CC650830EF67E6CF152C984F0@VI1PR0402MB2846.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(189003)(199004)(91956017)(8936002)(76116006)(476003)(229853002)(86362001)(6246003)(44832011)(186003)(102836004)(4326008)(25786009)(14444005)(256004)(26005)(55016002)(14454004)(316002)(54906003)(66066001)(110136005)(6506007)(4744005)(478600001)(486006)(6436002)(53546011)(9686003)(66946007)(2906002)(33656002)(2501003)(66476007)(66556008)(64756008)(66446008)(74316002)(99286004)(71190400001)(6116002)(305945005)(81156014)(81166006)(3846002)(7736002)(71200400001)(76176011)(7696005)(8676002)(52536014)(5660300002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2846;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /aUCOLC4SVSYr6lWreDcuFKyQ5IK4B+m6yOLhgKvwa6TYVcoLP5OOKYtoe6VKcWH2BloeUA+FVt0PFG+vz+SM2oBwQXzG73aUt6LqOqiqNdxxYYJ3lq9fUCsyVbb0JczyMO972EJM7xzt9Op/vuMQ9jSIQWqsNDtN6G6Wwyi3Bh4rXbIzNo6ooMql6WyfCPHYfmz+JurJMu4TFsPMpofNwQshV8rxWkzHJhyN+XIMn/D/PCsz2ovlHgXXhKg9xe2CW3gYSH6Wt87cywWYFH1aIqOS8bsdODfCI0MW7tdqv9OOdUkFESq60Iax2LyB3JKjWISfz5JYfyEWxXI6zFXG2W5lZI+PEvkGQEUtIZsspPYMlzPpglUr5OparoXIYh6B5Ish5qyVw1VBijzEaZtJs06MeikUe6qHBRQxf/4El1k5zA3Krwtn3qZcBi++jiv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a7aba7-bc6a-484c-42da-08d76d881efb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 07:06:09.7408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Szydmr9jGULFstq38KMNZshocogd7T3DwOMo7P1mTCCp2tJHEapQ2ItRs73MFsKSdICDyYG2B0x6ocduvX00Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2846
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/5/2019 5:14 PM, Andrey Smirnov wrote:=0A=
> @@ -589,8 +592,6 @@ static struct platform_driver caam_jr_driver =3D {=0A=
>  =0A=
>  static int __init jr_driver_init(void)=0A=
>  {=0A=
> -	spin_lock_init(&driver_data.jr_alloc_lock);=0A=
> -	INIT_LIST_HEAD(&driver_data.jr_list);=0A=
>  	return platform_driver_register(&caam_jr_driver);=0A=
>  }=0A=
>  =0A=
And with this change, jr_driver_{init,exit} could be replaced with=0A=
	module_platform_driver(caam_jr_driver);=0A=
=0A=
It's probably worth adding this here even if we later decide=0A=
that moving away from platform driver for jr is the way to go.=0A=
=0A=
Horia=0A=
