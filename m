Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB84C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B8520849
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 03:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="azY1TTFO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388439AbgEZDHY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 23:07:24 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:51246 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388417AbgEZDHY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 23:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1590462441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAtvdIbSfSYJkorzxcPEs8IcBmJSbm99y6TwBqzgRcs=;
        b=azY1TTFO84lTkb9wprmQWdb/5ekzU0jbd3SXycqoFjbzb2fNR5KdNsU1Qv07lU02rglPR+
        sw6onQHBTBpKXuYyPGrVpG73rv3Ol2JUWWQMsn7thNAnS8WVY+e0mn9y6RwYVLDYyq2gGK
        8/dfPapCV4wg+Gc7pGozz2T5ispPI7A=
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-1e9xp3-7O6q6EVjdX5_g6g-1; Mon, 25 May 2020 23:07:17 -0400
X-MC-Unique: 1e9xp3-7O6q6EVjdX5_g6g-1
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7514::20) by CS1PR8401MB1126.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7512::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.29; Tue, 26 May
 2020 03:07:16 +0000
Received: from CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd]) by CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::dd57:e488:3ebd:48bd%3]) with mapi id 15.20.3021.020; Tue, 26 May 2020
 03:07:16 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     =?iso-8859-1?Q?Stephan_M=FCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Monte Carlo Test (MCT) for AES
Thread-Topic: Monte Carlo Test (MCT) for AES
Thread-Index: AdYv5DokmuoSohTcS6aV9BTI5pb2mgAA7F8wACeCS4AAKwgigAB2Gw8w
Date:   Tue, 26 May 2020 03:07:15 +0000
Message-ID: <CS1PR8401MB0646A38BBFAD7FBABE50CBECF6B00@CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544BD5EDA39A5E1E3388940F6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <TU4PR8401MB054452A7CD9FF3A50F994C4DF6B40@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <CAMj1kXFa3V1o5Djrqa0XV5HvBqLjFvWqnNLRteiZo+dbhy=Tnw@mail.gmail.com>
 <12555443.uLZWGnKmhe@positron.chronox.de>
In-Reply-To: <12555443.uLZWGnKmhe@positron.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.106.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce8a55ac-1292-428b-2d3e-08d80121e509
x-ms-traffictypediagnostic: CS1PR8401MB1126:
x-microsoft-antispam-prvs: <CS1PR8401MB1126CE8DA4CF667043F4D567F6B00@CS1PR8401MB1126.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 041517DFAB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e1lXH19WWZGBFZQSrRl6RmOqEHp7grMzirCQ7u/A7FCff1p+V6ahRis+SPdtiuH8d72E/cuOsMpmspBqD80G5o90fIhvBfFgfa4YHEDsTfevsKIIqgtKBZHaw3iV48VGb0YKy4raOmKWeFeR7y7FTyOtVJ6BpzrfJX708lZKgI3NqffvagTC2229rVF6pXaKEF80d4BYmSkxX4UskpSBhislPW3rjnVf0Iz4jRrGma/6XapaoLwrWjFp23sKZ0aFipzG1PMbg5BuDD/gwjJsCP+uLpuobFUymZrlMTApcr3atZPBSyVw6UUGqiB+gR7bhOzvY4e4JMb2O/scNIwdp55WCBj+15KaonuMU6qUe09ZqSopGb/Y8NbUGiZEQPksJPt2upo60arop75gBJrYyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CS1PR8401MB0646.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(396003)(39860400002)(346002)(366004)(55236004)(64756008)(66446008)(66556008)(66946007)(66476007)(55016002)(6506007)(2906002)(66574014)(53546011)(26005)(7696005)(71200400001)(76116006)(186003)(33656002)(478600001)(110136005)(8936002)(52536014)(316002)(4326008)(9686003)(966005)(86362001)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LCXI08YWIMwZPrquHElYi2RHxB2TTYB5rdIMC0FOqsZa4ID8k46UKe/WApa/AMSGe1s6YTFTvTKjZ7X+lnMUEQziYmyiLWdCF+eVlZ4hF1V6Tydev++sKVE3D70GU9py1EwLVALrKW5fDHmaZifgDQWKVdNtJMPLyHx4L8zFybkxWqzNsSW1oins48l5ES0vpDj+keWSqo/RcNw3pWv2I/BsmQc7FWr3kAylq/4QiVLE/HEEoI7v38OqaZu3oJeWGpyRJr96pdxDDN08p8dHdkSeOtEWkNeMVne3zcVacF/RCLex5ddDyskFuyNjBWs69zOYVYjH4MKY7x7AnurfcNPse0diYStPtC3R0Z5n+vDcy298+uk25HD8gZPt+CHL4itc2uyNfNPjlF3Lcn3s/Py8+nG2GyJQKxuF4yVi7zfifPe1VvwYuTpAF6jZBpnj2iu2QkOOQ9H4Kzw1XJIwcKPzznTa4sPxJM5w3pd8i2uWSiesSM8GBYOr6OiuWOIY
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8a55ac-1292-428b-2d3e-08d80121e509
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2020 03:07:15.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/TTsAr871YESOlsrQEk3Yf+VQpn9Qg1lPIU+7hwxfbc15yoNctJ1QFM2zMr6nGYYArlMICaynSQeAbQlFRfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CS1PR8401MB1126
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

I to add the backend support using libkcapi APIs to exercise Kernel CAVP.
Can you please  confirm if my understanding is correct?

Regards,
Jaya

From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.or=
g> On Behalf Of Stephan M=FCller
Sent: Sunday, May 24, 2020 12:14 AM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>; Ard Biesheuvel <=
ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: Monte Carlo Test (MCT) for AES

Am Samstag, 23. Mai 2020, 00:11:35 CEST schrieb Ard Biesheuvel:

Hi Ard,

> (+ Stephan)
>=20
> On Fri, 22 May 2020 at 05:20, Bhat, Jayalakshmi Manjunath
>=20
> <mailto:jayalakshmi.bhat@hp.com> wrote:
> > Hi All,
> >=20
> > We are using libkcapi for CAVS vectors verification on our Linux kernel=
.
> > Our Linux kernel version is 4.14. Monte Carlo Test (MCT) for SHA worked
> > fine using libkcapi. We are trying to perform Monte Carlo Test (MCT) fo=
r
> > AES using libkcapi. We not able to get the result successfully. Is it
> > possible to use libkcapi to achieve AES MCT?

Yes, it is possible. I have the ACVP testing implemented completely for AES=
=20
(ECB, CBC, CFB8, CFB128, CTR, XTS, GCM internal and external IV generation,=
=20
CCM), TDES (ECB, CTR, CBC), SHA, HMAC, CMAC (AES and TDES). I did not yet t=
ry=20
TDES CFB8 and CFB64 through, but it should work out of the box.

AES-KW is the only one that cannot be tested through libkcapi as AF_ALG has=
=20
one shortcoming preventing this test.

The testing is implemented with [1] but the libkcapi test backend is not=20
public. The public code in [1] already implements the MCT. So, if you want =
to=20
use [1], all you need to implement is a libkcapi backend that just invokes =
the=20
ciphers as defined by the API in [1].

[1] https://github.com/smuellerDD/acvpparser

Ciao
Stephan

