Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2759EC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 16:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58732074D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 16:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="OTR8BXEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHXQBK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:01:10 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:35998 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgHXQAz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 12:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1598284854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wm5SQaufGEgJEswX7BVL7nDszZEAXXSBbqKFHUV6Lm4=;
        b=OTR8BXEfD80WEFfNeB4VpLnJI+gCb0glVTSVwfzBP5lDvszbve9HqrLHaEdE8gFUUArs+m
        alnSeSAmKHIQhSlAU5YJ0rOZS1P2kisDb1DoU6LpBELPtsk0zQDL+wof3YlcQowXWQZNVE
        zPwweq9ToZY0h2IyiHhC05nL86pI47E=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179--kD4p2NyO0euvtJkVlbPcw-1; Mon, 24 Aug 2020 12:00:52 -0400
X-MC-Unique: -kD4p2NyO0euvtJkVlbPcw-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0591.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Mon, 24 Aug
 2020 16:00:51 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354%8]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 16:00:51 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: HMAC test fails for big key using libkcapi
Thread-Topic: HMAC test fails for big key using libkcapi
Thread-Index: AdZ6JJoFQMwI76Z+R1Spwzgk7TA7XwABt1oAAAEOAhA=
Date:   Mon, 24 Aug 2020 16:00:51 +0000
Message-ID: <TU4PR8401MB1216BE455AAA9CF411FA0141F6560@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB12164EFE831D43A41DDC8EA1F6560@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
 <6448041.Y6S9NjorxK@tauon.chronox.de>
In-Reply-To: <6448041.Y6S9NjorxK@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.201.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22647c6a-e100-44c6-5136-08d84846e029
x-ms-traffictypediagnostic: TU4PR8401MB0591:
x-microsoft-antispam-prvs: <TU4PR8401MB059139BB27C6E9F854730B31F6560@TU4PR8401MB0591.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RnKoLgV/vFeIX/BoY9Pi/2Xc2Azs3TIduC8PZx/Mb6WnqukS5HItr5lu5ZaP1NqIICmMMLy7/2TF0J+xC6NeEWUdH77vPeZpZ/9sH8upf+X9bH9Bk815xNJUT9mKtVpNfo4XASsS14XSjcEk/OaWvKiTEcVC1DPvHC3SD+FmVRTy0queM9/GBAjXHC//MgZUTO7Q/vtshAS4A+d/n5MY15wj2NMBxwDLgMICs3YHEehE7QJJUgAbpbcW8AEnhfjZ5PMVbwtujID5TNugbD9nQY3j3BW8Xci999bP9TsWRlBf2fvej3jo9j3h9Iq8XkUbZ2Fs/BWJmbtWOY+vGHrIqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(4744005)(7696005)(8676002)(52536014)(5660300002)(55016002)(6506007)(53546011)(26005)(86362001)(55236004)(186003)(316002)(110136005)(83380400001)(8936002)(71200400001)(33656002)(478600001)(66446008)(76116006)(66946007)(66476007)(64756008)(66556008)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: K9oNyVdt1Yo/JWTRqjDCu59QB95q7GsgL9pdFnXfWL6k3wr5JPt9fSgUcMAqPBbp17922qex54s5Ut9Bmx1uuGhY1HRagNWBbO6QDpZU4jY2EIH0H5w6oLgGL0N4hW4pTLcmuvAL+elrfllguJFIUeUbCphrfbKK4DhBYEsXogmQncTZGScaz/e1KUAZayRPfHdYa91w6+1DN0KVub9VnfZG6/6fqMnCnQ9iovuLmGJTN0V4YoSYL7eh0acC8jBQeU4+duXUKpTgQA2Rksg2wzozMhIprSqIYrua4kSAWX4sc8fflHsIG8OjYv2le6SLTHQMPpsUJVGa1njn2iwJ6A9+sDocGVOVBHs+c372MCh0aQoZtCYETv5clI9USc1YpJjePHVBaPinqwrsm/xJL94dQDicuwfK1HqikAGRbPay3jkS8QM25FDO/w+URSJVsRRCqSCBPdI/gWHh7uzzmfqxl7yt/qvCMa2HkcujCxogwkpwC7Uuo+I8iIIZadjR2tXI9YVjuVXpAVJ92i2jfI3D+iKh+8sqEk/dVxyRpBqpn9l8tPVvV1k2zNOqn1Ytn5NysKOSe0diMjEMcLg2CupfO7P5MQOzaQY6vDT9MSd5nRxuCbeWrQmLHVnUOhfqGRhrqdvNAk3FutxU6G6fqg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 22647c6a-e100-44c6-5136-08d84846e029
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 16:00:51.7580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8JnA7KnmHZFCGD8857C6Z2AxZ9NMFHtdzr5Q4iG0gzg+mDnTSYKgArrnPCs/V7I/LrpWFczer2dtCM0heeK0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0591
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

It worked, thank you so much

Regards,
Jaya

-----Original Message-----
From: Stephan Mueller <smueller@chronox.de>=20
Sent: Monday, August 24, 2020 9:00 PM
To: linux-crypto@vger.kernel.org; Bhat, Jayalakshmi Manjunath <jayalakshmi.=
bhat@hp.com>
Subject: Re: HMAC test fails for big key using libkcapi

Am Montag, 24. August 2020, 16:41:13 CEST schrieb Bhat, Jayalakshmi Manjuna=
th:

Hi Jayalakshmi,

> Hi All,
>=20
> I am using libkcapi to execute HMAC tests. One of key size is 229248 byte=
s.=20
> setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY API fails to set the key. I am=20
> not getting an option to set the buffer size to higher value.
>=20
> Can you please provide me inputs on how to set the higher buffer size=20
> to socket?

Update your network write buffer size?

/proc/sys/net/core/wmem_default
>=20
> Regards,
> Jayalakshmi


Ciao
Stephan


