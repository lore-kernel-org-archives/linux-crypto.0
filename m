Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD5DC742D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 17:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76E02054F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 17:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="QR9ySyR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGLR4U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 13:56:20 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:46468 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbfGLR4U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 13:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1562954178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/luIBdbk/1+l0y37VNWm6oAGSWgNtjOHiXjBx6BYZ4=;
        b=QR9ySyR0j1pL56uuEBjnp7bQpsdlsjfjzbUkiH+5MGjD7Q0md2fHMAuE4MP9Lc6x0ZbTYH
        HiK7pcOONsbtIfeVyPN4fpgSVLsE7aoUvrmC2eH3siTwg/8/v/a6enTYhBHEipARkEouTP
        ePiR429uUXhCT5ydhvlptr7y37SbfdM=
Received: from NAM05-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam05lp2051.outbound.protection.outlook.com [104.47.48.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-e0U5puxLOJCLcAVvz2iung-1; Fri, 12 Jul 2019 13:55:09 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0814.NAMPRD84.PROD.OUTLOOK.COM (10.169.45.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Fri, 12 Jul 2019 17:55:07 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.022; Fri, 12 Jul 2019
 17:55:07 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftABvXlyAAABAX4AABvU+0AAAhPaAADcrObA=
Date:   Fri, 12 Jul 2019 17:55:07 +0000
Message-ID: <TU4PR8401MB0544B9D0BCD4C091857A1EAFF6F20@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <1782078.ZURsmYODYl@tauon.chronox.de>
 <TU4PR8401MB05445179722F462CD8C05AB0F6F30@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <2317418.W1bvXbUTk3@tauon.chronox.de>
In-Reply-To: <2317418.W1bvXbUTk3@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.109.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5634e5d2-6769-42de-124d-08d706f21394
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0814;
x-ms-traffictypediagnostic: TU4PR8401MB0814:
x-microsoft-antispam-prvs: <TU4PR8401MB08140DE58DEC52900F6EFCB5F6F20@TU4PR8401MB0814.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(13464003)(6602003)(199004)(189003)(66556008)(66446008)(7696005)(2906002)(186003)(26005)(66476007)(446003)(7116003)(11346002)(81156014)(8676002)(6916009)(64756008)(81166006)(52536014)(3846002)(78486014)(8936002)(14454004)(6506007)(102836004)(99286004)(76116006)(55236004)(86362001)(3480700005)(7736002)(76176011)(53546011)(66946007)(5660300002)(71200400001)(476003)(256004)(486006)(71190400001)(66066001)(6436002)(74316002)(305945005)(229853002)(55016002)(6116002)(68736007)(6246003)(53936002)(4326008)(25786009)(33656002)(316002)(9456002)(478600001)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0814;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jAZuNGCvPb2+4l57VfXoTlUR37tnA6MKugKr2i6ibZF5qpFepcp2pnAjm1jXU82QdjRXJnrM6Qzs58ZZP6OLd3Rzw/5KgdgEsryWhlQKTbfkrOm81U3NbmM91gGElhL2njt03NUwvmhRxR7ZOuD2sTiunDk9/tWQiU/zE4RIxVMD95iwQhI8agisL9R8HP1FFEPi3nERtlQeOt1PVt9o3P6XnzOc9AHuaE8rA8o/Cs0LK8w4tJVCC1lrZgSP9xf10IOl5qFTyNr2MXB4NtWVap9vfYdsZyZwTrhyFzoUQp+pY+M/uryefiZaB/GQXtbTl3f3s/wQ2F2oEKpXG6zI6Xz9qfT2yqgEY5hCPyuGieAH7zbzuhwlkgNowR7NuL8hpTIo4wgA29bhudNhfV9fBE4N2cvhVcpVe1sVQs/3QM0=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5634e5d2-6769-42de-124d-08d706f21394
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 17:55:07.5236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0814
X-MC-Unique: e0U5puxLOJCLcAVvz2iung-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you very much for the suggestions, I have another question, is it pos=
sible to implement MMT and MCT using kernel crypto API's.  Also FCC and FCC=
 functions.

Regards,
Jaya

-----Original Message-----
From: Stephan Mueller <smueller@chronox.de>=20
Sent: Thursday, July 11, 2019 9:04 PM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: CAVS test harness

Am Donnerstag, 11. Juli 2019, 17:22:00 CEST schrieb Bhat, Jayalakshmi
Manjunath:

Hi Jayalakshmi,

> Hi Stephan,
>=20
> Thank you very much for the reply. Yes we would need to write the test=20
> for AEC (ECB,CBC,CTR) 128 and 256 bits, SHA-1, SHA-2 (256,384 and=20
> 512), HMAC, DRBG and also for key derivation functions. We are=20
> planning to write netlink based kernel module to receive the data=20
> (test vector input) from the user space and process the data and=20
> generate the result, pass it on to user space.
>=20
> I wanted to know if this sounds a reasonable approach?

That sounds reasonable.

I implemented the kernel module as you described it but with a debugfs inte=
rface to use the interface straight from a shell if needed.

Ciao
Stephan


