Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4BCC3A5A5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 04:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7BE621897
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 04:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="i2T5KtiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfICEbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 00:31:03 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:22510 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbfICEbD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 00:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1567485061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r04AMbjNCvZ8zLgtB1wTjZabJqtDXRDYx5THMfsYoVE=;
        b=i2T5KtiOHuACVGU9tljyMoXbn8FxsPKZ4W3KxgzxEHH8tIivghf4L01odxKpmOsT7TMXay
        sUL+sgw0Fc0KAkoFVkAewyMfItDDSB3S2IyoAZqPijbwZLXW9jyuI97vuWFnkH+p3J4yzN
        oaE3z94EJrzI0vpSnBneNvMRYqhVDJU=
Received: from NAM04-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-tghCeD-iMCCo9QP1oqJskg-1; Tue, 03 Sep 2019 00:29:40 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0333.NAMPRD84.PROD.OUTLOOK.COM (10.169.49.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Tue, 3 Sep 2019 04:29:39 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cc0c:2b14:aee6:f2ce]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::cc0c:2b14:aee6:f2ce%7]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 04:29:39 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: How to use nonce in DRBG functions.
Thread-Topic: How to use nonce in DRBG functions.
Thread-Index: AdVg9imU2pwN1ezdTiGr2PmY7g4OrQAd2GCAACilNxA=
Date:   Tue, 3 Sep 2019 04:29:39 +0000
Message-ID: <TU4PR8401MB05443149BFF00388520A0F36F6B90@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544172FD34CD6FB6F2269CBF6BF0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <4456652.e1v30m9lHF@tauon.chronox.de>
In-Reply-To: <4456652.e1v30m9lHF@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.56.132.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04cf7c49-1966-42ef-b8e9-08d7302755cd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0333;
x-ms-traffictypediagnostic: TU4PR8401MB0333:
x-microsoft-antispam-prvs: <TU4PR8401MB0333C2ED8291F42EE40A3F1AF6B90@TU4PR8401MB0333.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(53754006)(189003)(199004)(6602003)(13464003)(7736002)(5660300002)(305945005)(11346002)(476003)(486006)(446003)(26005)(102836004)(6506007)(53546011)(186003)(256004)(33656002)(316002)(55016002)(53936002)(229853002)(9686003)(8936002)(81156014)(8676002)(6246003)(86362001)(71200400001)(71190400001)(4326008)(25786009)(7696005)(6116002)(3846002)(2906002)(6436002)(6916009)(76116006)(99286004)(66946007)(66446008)(64756008)(14454004)(52536014)(478600001)(74316002)(81166006)(66556008)(66066001)(76176011)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0333;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UWwXvTNF7To5skafOwteJrCnG0w4ejDqYPBroMdpx3Uimko/iQUTikf5OpGIEROEivPZ6urgmbkjSLr28GnU6SnoNr9z31AWkZxvS3ovOZH9ZXcti3yO91TAT7IkYsXqO/2R2BIsf8bcErBaxHzBqzHpWM2LKW/kvACgoB+D2lwDdUJk2R7Qflhf8hhZFEftAVJ3D3Hzma/4eIluH6Qrs+jdADW9r45Un4v+bO/wvD8xgA92K8NCQOppvy6UeMTCZoFP27gMFfgMAFiOSMfXhUHHiPfQSG63i4A28ZQIXQfJQHUCceJU228Xk6ywzwBNhr8eOuYEJphVSsPhog+c/fXfqT08pl1zWHOHEeIrOGPjv9kVpEtwI3BCpvhLlTvuXBEkM/KGyHr5ieudq0I5N4pceB9IW6bakdd2wEYWb78=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04cf7c49-1966-42ef-b8e9-08d7302755cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 04:29:39.6278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f29kfK5jGD6OVfSeUWezrgqwR3ZC7nqocVf6p6Ln6mnMLZ5P/2+CjMVVyyVltBkP/o88ZfNIYqd6ARywaWGSoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0333
X-MC-Unique: tghCeD-iMCCo9QP1oqJskg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you very much. I will try the same.

Regards,
Jaya

-----Original Message-----
From: Stephan Mueller <smueller@chronox.de>=20
Sent: Monday, September 02, 2019 2:35 PM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: How to use nonce in DRBG functions.

Am Sonntag, 1. September 2019, 20:52:24 CEST schrieb Bhat, Jayalakshmi
Manjunath:

Hi Jayalakshmi,

> Hi All,
>=20
> I am trying to implement DRBG CAVS test harness function for Linux Kernel
> crypto DRBG with the following requirements. 1.=09Derivate function is
> enabled.
> =092.=09prediction resistance is not enabled
> =093.=09Entropy input length is 256
> =094.=09Nonce length is 256
> =095.=09Mode is AES-CTR 256
> =096.=09Reseed is supported
> =097.=09Intended use generate.
>=20
> Thus inputs are
> =091.=09Entropy Input
> =092.=09Nonce
> =093.=09Entropy Additional Input
>=20
> Flow goes something like below
> =09drbg_string_fill(&testentropy, test->entropy, test->entropylen);
> =09drbg_string_fill(&pers, test->pers, test->perslen);
> =09ret =3D crypto_drbg_reset_test(drng, &pers, &test_data);
> =09drbg_string_fill(&addtl, test->addtla, test->addtllen);
> =09ret =3D crypto_drbg_get_bytes_addtl(drng, buf, test->expectedlen,
&addtl);
>=20
> I am not finding a way to input nonce. Please can anyone tell me how=20
> to input nonce.

The entropy string for the DRBG is the CAVS entropy concatenated with the n=
once as defined in SP800-90A for each instantiate process of each DRBG.
>=20
> Regards,
> Jayalakshmi



Ciao
Stephan


