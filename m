Return-Path: <SRS0=DBcK=W4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6789AC3A5A4
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Sep 2019 18:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19F11217F4
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Sep 2019 18:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="jUxWUfuM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfIAS7F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Sep 2019 14:59:05 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:41658 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729070AbfIAS7E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Sep 2019 14:59:04 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Sep 2019 14:59:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1567364344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QMvDHwGoL/s8RJVvCvaCQht5EpBXYIui0qpIGDNpH2c=;
        b=jUxWUfuMV0qAzX/uEhDECBGl4OlZHuHbQSFuqdbVe8jNoOn/VheBT2+XCi0aATyF3gstsM
        4j5WfIZIo8RmGLvNqwWr5Knjusi1GUCsVTIuv+1EDmpOen7ep7nXHYJpYx00pGSarG4lrI
        X9lV8XrH83LUDsIw1Mde4sA9uhX0xuo=
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01lp2054.outbound.protection.outlook.com [104.47.33.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-cdrH-sWWNoCyOY1If3A6xA-1; Sun, 01 Sep 2019 14:52:25 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0830.NAMPRD84.PROD.OUTLOOK.COM (10.169.46.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Sun, 1 Sep 2019 18:52:24 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cc0c:2b14:aee6:f2ce]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cc0c:2b14:aee6:f2ce%7]) with mapi id 15.20.2220.020; Sun, 1 Sep 2019
 18:52:24 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: How to use nonce in DRBG functions.
Thread-Topic: How to use nonce in DRBG functions.
Thread-Index: AdVg9imU2pwN1ezdTiGr2PmY7g4OrQ==
Date:   Sun, 1 Sep 2019 18:52:24 +0000
Message-ID: <TU4PR8401MB0544172FD34CD6FB6F2269CBF6BF0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.57.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01d9f8ae-a065-49cf-18b3-08d72f0d8728
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0830;
x-ms-traffictypediagnostic: TU4PR8401MB0830:
x-microsoft-antispam-prvs: <TU4PR8401MB08305670E411ABFA0285502BF6BF0@TU4PR8401MB0830.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0147E151B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(53754006)(6602003)(199004)(189003)(14454004)(6506007)(102836004)(55236004)(186003)(26005)(476003)(486006)(7696005)(2351001)(86362001)(6916009)(33656002)(2501003)(71190400001)(66446008)(64756008)(66556008)(76116006)(71200400001)(66946007)(2906002)(5660300002)(4744005)(66476007)(8936002)(81156014)(6116002)(66066001)(8676002)(55016002)(316002)(9686003)(6436002)(53936002)(99286004)(478600001)(25786009)(305945005)(74316002)(7736002)(5640700003)(256004)(52536014)(3846002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0830;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n97oq0GgmXDwT+VjOoJNGRkOMv+PEBrhm2MQ2M+gAhvHF+b1UMgKcmn2iXJsk/395EEX+1yAsf4tMeD/5g94u8zAiGJCP5ot9bvKaOCWvCkY4KdNBjfJNn7WqH9iK+1GQHPrAf5hhxN263kDfgGJnDrtA8Y2PZEsM0IsScqhGsI4w2kXMULW8JNKarZ2arYTKGCsWEHRQK9XwDmKqXS4VD7NHkTe7tKZCKl45yDllxfsbsHSIbQmdTB1lVjxypOghXvR7He/FYiwpyIb2QwPSRQj6Kqp8e3knSXjSFigd8VIxqrVGwrL9TNUxa7789Bw0ypKGYPXP7+sOwf72A/Lwq1tg6l+TmIGGHu1Qhp/YozNgi4nDp7eOiwJxK39E3tvMtv2hm9bpLiVN5hk80lp4wCWpZvV/3ZSlRL2tW+V46I=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d9f8ae-a065-49cf-18b3-08d72f0d8728
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2019 18:52:24.3597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSggSiWHc3JO/TMdo8p2AzJtGgJcAOkdvN0C/55HYHL0nY48shNY0rE1V1oZaP0bL+SXKRL1UoUr/VBiU71NBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0830
X-MC-Unique: cdrH-sWWNoCyOY1If3A6xA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I am trying to implement DRBG CAVS test harness function for Linux Kernel c=
rypto DRBG with the following requirements.
=091.=09Derivate function is enabled.
=092.=09prediction resistance is not enabled
=093.=09Entropy input length is 256
=094.=09Nonce length is 256
=095.=09Mode is AES-CTR 256=20
=096.=09Reseed is supported
=097.=09Intended use generate.

Thus inputs are
=091.=09Entropy Input
=092.=09Nonce
=093.=09Entropy Additional Input

Flow goes something like below
=09drbg_string_fill(&testentropy, test->entropy, test->entropylen);
=09drbg_string_fill(&pers, test->pers, test->perslen);
=09ret =3D crypto_drbg_reset_test(drng, &pers, &test_data);
=09drbg_string_fill(&addtl, test->addtla, test->addtllen);
=09ret =3D crypto_drbg_get_bytes_addtl(drng, buf, test->expectedlen, &addtl=
);
       =20
I am not finding a way to input nonce. Please can anyone tell me how to inp=
ut nonce.=20

Regards,
Jayalakshmi


