Return-Path: <SRS0=EMKO=VK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040EDC742A7
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Jul 2019 16:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A4520830
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Jul 2019 16:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="SgDEfOXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfGMQE0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Jul 2019 12:04:26 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:44162 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727918AbfGMQE0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Jul 2019 12:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1563033865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdSdOq5oKPLK3JPDjW8rhad6oaLfWYl0Y3Bkhv10D0A=;
        b=SgDEfOXDquP70HLL/vII8olmjQozphAvcQsUvFQKCxxXMJiZ/DV++8G2zfPAPDqA6s0Jmc
        2fqbR8pTuotRxy67OB6iyFdTO9ANFS1d37+4PBgKhwhJ0p4QIMz7oAs8YY3zdchbDNXitC
        FvbnW4onskotCIcv2J9f9RVgsM7C1ek=
Received: from NAM05-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam05lp2058.outbound.protection.outlook.com [104.47.49.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-Uo6vEPNXOFKi22Cucai0rA-1; Sat, 13 Jul 2019 12:04:23 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB1070.NAMPRD84.PROD.OUTLOOK.COM (10.169.47.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Sat, 13 Jul 2019 16:04:21 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.022; Sat, 13 Jul 2019
 16:04:21 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftABvXlyAAABAX4AABvU+0AAAhPaAADcrObAABJuHAAAp3c+A
Date:   Sat, 13 Jul 2019 16:04:21 +0000
Message-ID: <TU4PR8401MB054418DDF7FD6828A905D7B2F6CD0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <2317418.W1bvXbUTk3@tauon.chronox.de>
 <TU4PR8401MB0544B9D0BCD4C091857A1EAFF6F20@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <1973019.N0B863glP0@tauon.chronox.de>
In-Reply-To: <1973019.N0B863glP0@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.109.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d283ad5-4d51-463b-2ab6-08d707abc47d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB1070;
x-ms-traffictypediagnostic: TU4PR8401MB1070:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <TU4PR8401MB107083CC11E4A9C5827D6EDAF6CD0@TU4PR8401MB1070.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(6602003)(189003)(199004)(316002)(7116003)(76176011)(76116006)(2906002)(66446008)(476003)(66476007)(66556008)(64756008)(256004)(486006)(66946007)(966005)(14454004)(6246003)(86362001)(478600001)(14444005)(5660300002)(6116002)(3846002)(7696005)(6916009)(33656002)(25786009)(66066001)(55016002)(26005)(8936002)(71190400001)(99286004)(71200400001)(6436002)(74316002)(53546011)(53936002)(9456002)(68736007)(55236004)(9686003)(6306002)(102836004)(52536014)(3480700005)(78486014)(229853002)(8676002)(11346002)(4326008)(446003)(305945005)(7736002)(81156014)(186003)(6506007)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB1070;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tUsOyS9w7Pf354i5rWovYX3P8wimqN1CCNte6ghmwgFJe8RQ2Gs9i5IKTXE+qE3Ukyl4utDoWr9HYaO3KU7MfcwICFwo6gxOOvaNa1HmeEmFdDa40iV0RHGBqErI25AXD6cmXId/GiXwiXsfKqjctBKKyUtAnF/mWW/cISK4HvEZ62tWMch7FuBOjCOJyPNJmZOvpg0u8dJyspVsqppG5PTrliL4I+5A2gSkIO8VBdwh3bYVJEBuYjWyaVET1jfVpwh6Az6i9vHMZtigI8blysdIQt+C6nK67EBDRyIZVUeYHqf9SdpQyvlbr41VtaEkcvjRdHD3w5hpWKHFBlTw91jP8A9qJQy0r7U6Td+YgvEwP6IEuexidFM2zGOhuhmFBL3O0iWPgWQ9kvrZqSgim/9p4X7QvZMKnhgQmwnaRj0=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d283ad5-4d51-463b-2ab6-08d707abc47d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2019 16:04:21.1942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1070
X-MC-Unique: Uo6vEPNXOFKi22Cucai0rA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you very much. I had done good amount of investigation. Since I am a =
new bee in this area, I wanted to confirm if my understanding is correct.

Thank you once again.

Regards,
Jayalakshmi

From: Stephan Mueller <smueller@chronox.de>=20
Sent: Saturday, July 13, 2019 1:35 AM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: CAVS test harness

Am Freitag, 12. Juli 2019, 19:55:07 CEST schrieb Bhat, Jayalakshmi Manjunat=
h:

Hi Jayalakshmi,

> Hi Stephan,
>=20
> Thank you very much for the suggestions, I have another question, is it
> possible to implement MMT and MCT using kernel crypto API's.

Yes, for sure - I have successfully implemented all CAVS tests for all ciph=
ers=20
(see the CAVP validation list for the kernel crypto API).

> Also FCC and
> FCC functions.

I guess you mean FFC and ECC - yes, see the CAVP [2] web site.

Eric:

MCT - Monte Carlo Tests
MMT - Multi-Block Message Tests

In general, see [1] for all CAVS test specifications.

[1] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-progr=
am

[2] https://csrc.nist.rip/groups/STM/cavp/validation.html

Ciao
Stephan

