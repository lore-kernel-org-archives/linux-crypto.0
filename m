Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81CDC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 11:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 962462084D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 11:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="cv9n4SkV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbfIILG7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 07:06:59 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:17806
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730736AbfIILG7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 07:06:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+d+FzpDAx4P7zsooviAE33s2eFVqezBNNOWPHielXzTaG0CDhQwqztoEbZKukQ0SnO4dLuiJrEWnYpF3BxN0STanit0DgY0ssqq1JawD+Gy7YCrnWAP8d2VFN4gZp/+aADQOUatwkPQ6F8DnVv0fUmIDsftw2SvK3JRoM66inq5zGGDkaFKifPJv/N8vIUq6hLcIyOygyZzCYfStrgzZZ23EIQRdSTRe75Zu40AIVE/bdPWfSoOETvhrc9GsABZiuOykuwEykJUIjmYq74somWV//ENjlgrq0qJ9h5n9zQejl0isZhVWR7dQ+WuEDAS9QKbKr1Dv7eIy/JC5LSpxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC5dcL9KPQTv+UkE1TH4HjEAvs0ItV9nDTE1kwV3bIo=;
 b=fefdnH+6FjFswzkqkgrnvRaPBQ/ARIaX3ipJiuVVDjVKWtxh8+U+K29Kxz90drOJhfw8Ashs8y4afPcB9AqS2v3GKzx+RXyBVLe6iY0RNDgDQDiRtgBvXgJ2AoyuHMGUDSV0/nYBKwpNMKj+BL1WElr7lj7SWoFt479dzT/YdLrp2FJdqT5uDEf0Yu41bzjKfE7KZkMRE7I45MGbzvThrTFJngoOKI2dbtDJet/ZG8JrX/liN8fg4TClOuh6A2zkEoed5FW3HWOjEsNhmHnyA+wl+F3aBy1Cn627NX9bSlwPgNsOPjuEppz1fRdYX7EvTq4CnhP2dg/i5YJ1UqFHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC5dcL9KPQTv+UkE1TH4HjEAvs0ItV9nDTE1kwV3bIo=;
 b=cv9n4SkVTPR/uqkJZL6cjQzgyhIvWaGbEGufbGExXxgCSB1jmyri3RHZ5fAiCgcY+tILY8o2YoxpSiURSRNAyXr/l1wJ9o+vZD8mvOAxJVUgLF4KhN1ZKEP/uEsd1EWUQaI3nUdI1VPzxpH2jjFc/MqmioAwp3s+hwlCrKTYa5A=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3869.eurprd04.prod.outlook.com (52.134.16.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 11:06:55 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 11:06:55 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: crypto: caam - Cast to long first before pointer conversion
Thread-Topic: crypto: caam - Cast to long first before pointer conversion
Thread-Index: AQHVZuK7jqoo8Xzl5UmMoE1xvNTDUg==
Date:   Mon, 9 Sep 2019 11:06:55 +0000
Message-ID: <VI1PR0402MB3485C9E54BC85C98CBC72C7898B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-5-andrew.smirnov@gmail.com>
 <20190909074636.GA21024@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f9c5572-0a6f-4ce4-604d-08d73515d373
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3869;
x-ms-traffictypediagnostic: VI1PR0402MB3869:|VI1PR0402MB3869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38698A606252F37105472B0598B70@VI1PR0402MB3869.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(189003)(199004)(110136005)(7696005)(76116006)(91956017)(26005)(476003)(6246003)(66066001)(6116002)(3846002)(102836004)(2906002)(53936002)(44832011)(66446008)(66946007)(64756008)(66556008)(446003)(486006)(4326008)(71190400001)(6436002)(6506007)(71200400001)(53546011)(99286004)(81166006)(81156014)(8676002)(76176011)(14454004)(66476007)(256004)(186003)(8936002)(14444005)(25786009)(5660300002)(55016002)(7736002)(52536014)(9686003)(74316002)(478600001)(305945005)(229853002)(316002)(33656002)(54906003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3869;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vxASCqj/8aWCBHNsL+QZZraU8HySb11mQUK6VjaBgQFFT6NSzX9MpMBQ3WTs+l149FQ5s2AumWFKzRY31J9QY1jHk0ajdjF7XKxXAzWPWSSVe0us/h9xQwf59uKMg87A9LUZinn3lDXhjBIsTWHZ0gX43j47H59UU7Xb1T5KeK/mIBpKZRTqm2g1Swtwkmb8QP34X+ZyT06nDUa4Cp+EEDle+s7J0INPEP5F6l8t9Wd9gVHFACaAhlMu1TyKFY6KnddSOQ5N9o6bWLSO/rRInFz+bzLfSVvp6Ln5TryTG/OaRY0TexIS7mSq80ae+v0EVmrCeZvRzSR/8ys9yWs+6nrR7Prn0QbpeTihOe+gTotlvDVV46ZtAt551V8/L/nzRNXQ9jhX4MMPvvQP9bX9ZSQQNjajD7nxMOX3sw2JekY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9c5572-0a6f-4ce4-604d-08d73515d373
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 11:06:55.3324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxaFnC6R5w2MLhCNN010nPPbkNOe5JTiaBuzFVZ9EcLo1yeSRPE4vFyyI99RdmfHmxV7PW6jS1+MlwF6yfUIFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3869
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/9/2019 10:46 AM, Herbert Xu wrote:=0A=
> On Tue, Sep 03, 2019 at 07:35:07PM -0700, Andrey Smirnov wrote:=0A=
>> With IRQ requesting being managed by devres we need to make sure that=0A=
>> we dispose of IRQ mapping after and not before it is free'd (otherwise=
=0A=
>> we'll end up with a warning from the kernel). To achieve that simply=0A=
>> convert IRQ mapping to rely on devres as well.=0A=
>>=0A=
>> Fixes: f314f12db65c ("crypto: caam - convert caam_jr_init() to use devre=
s")=0A=
>> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
>> Cc: Chris Healy <cphealy@gmail.com>=0A=
>> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
>> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
>> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> Cc: linux-crypto@vger.kernel.org=0A=
>> Cc: linux-kernel@vger.kernel.org=0A=
>> ---=0A=
>>  drivers/crypto/caam/jr.c | 14 ++++++++++----=0A=
>>  1 file changed, 10 insertions(+), 4 deletions(-)=0A=
> =0A=
> I needed to apply this on top of it to shut up the compiler:=0A=
> =0A=
> ---8<---=0A=
> While storing an int in a pointer is safe the compiler is not=0A=
> happy about it.  So we need some extra casting in order to make=0A=
> this warning free.=0A=
> =0A=
> Fixes: 1d3f75bce123 ("crypto: caam - dispose of IRQ mapping only...")=0A=
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> =0A=
Thanks Herbert.=0A=
=0A=
Indeed, this is needed for silencing compilation on ARM64=0A=
(while compiling for ARM works fine).=0A=
=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
for the squashed patches.=0A=
=0A=
Horia=0A=
