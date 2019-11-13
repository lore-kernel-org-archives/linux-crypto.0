Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A25C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5AF206D4
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 18:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="B51EfoRl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfKMS5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:57:24 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:21641
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbfKMS5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 13:57:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coYzFEVlo5V+6NSI577l5o67iyn/n6mynzk+56l8xHBqql2IF3jBd20EwH2orAgNzLtOBlW2hV1Kc19+f9fUfkDWW9BkpLahyraob+4l+yVrlUqji//VK65fB8+NNlOpc2Y1cwyOWyIFyvdm0CrmA0evruI9YhlPdMbBDafPtH0UqlL4duSYB0vqv+EJEUb5VWeOxCM8fNr7JSJwPJpGcCC/grCVcWtA2HVkIZjBt/2SJ4NUcXmErm/5kh0c90r5VkTONtqnRpce4AnU1AhBoAukH3PN2dMs//9M5EkwvwjV9FiJ8Lg8snAZwjmI2yNp1ce+CHBzIKiG4kdb7+AabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC5I0qbp/qdBEJyDCokzQRDWRP2psijVJ67pUjr4HqU=;
 b=ZUbAe7gksBjL+/y4iP8TDXgHpLl0ZtM3sVPaww2bDmnYVcX13GltDijy/+fl/aUyMHBz7OG1QiUKraEYj2Rrk3GeTwxP9DFExg3U0W0ffxOK5PeqsHIUhx0C8jvQSQ6O86zX07YyRtuVORARscyX0XnVAkJYDtricEQeWxwcRF7OHkWWep/Uwze1nOJ8oAlbVmLWB+ZEGbjnU94pCQ79fu9upcRn5ugv0pdTkMfzitALmN63CNLZuazWl2wTBmPgfODT4QPVAyLdjq80pgw6aftVh3DzCipv1yBoaA6BqLCbfL5ucBpKtwlh7+oBgoJrg2Y/FjQJqc2ASzTT7ZQe1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC5I0qbp/qdBEJyDCokzQRDWRP2psijVJ67pUjr4HqU=;
 b=B51EfoRlQ7BcTDAJzJAGGExFlBe3s9BHL++y9mI+Af7QqAvDvMucGVuVbo27CwgvPhzmv4+ekdol4k3NfuPnI25s9fFx5Ahvp4ER2gJn0f5bC1hAga2kwWbs+rQNUITBfTk0qMOBWFqLa+4QwbZeEnK3/zz6NIwQkW8p0DnwrWA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3760.eurprd04.prod.outlook.com (52.134.17.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 13 Nov 2019 18:57:20 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 18:57:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Vakul Garg <vakul.garg@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] CAAM JR lifecycle
Thread-Topic: [PATCH 0/5] CAAM JR lifecycle
Thread-Index: AQHVk+up3U0pU2iIOk61xrvFYlmkIg==
Date:   Wed, 13 Nov 2019 18:57:19 +0000
Message-ID: <VI1PR0402MB34851C1681F8A18341A8971098760@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
 <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <CAHQ1cqH5hstMwbO1vqOkZ3GVe-j5a+c3TX-yosq-TvuFFxPkHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3148436-6cce-49cd-04da-08d7686b4f6e
x-ms-traffictypediagnostic: VI1PR0402MB3760:|VI1PR0402MB3760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37602AB8EFE7FED77B9A436798760@VI1PR0402MB3760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(13464003)(199004)(189003)(71190400001)(256004)(446003)(476003)(53546011)(6506007)(229853002)(110136005)(7696005)(99286004)(102836004)(2906002)(6636002)(486006)(8936002)(71200400001)(8676002)(9686003)(26005)(81156014)(33656002)(6436002)(81166006)(14454004)(186003)(14444005)(54906003)(76176011)(66556008)(66946007)(66476007)(64756008)(66446008)(55016002)(478600001)(76116006)(6246003)(91956017)(86362001)(6116002)(3846002)(4326008)(66066001)(5660300002)(52536014)(305945005)(7736002)(74316002)(25786009)(44832011)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3760;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ihm85SewYWuQD369OF8viKlz89WYtAQN38kAXNq9apYUYktqpUpEUKTQc2ga21PY3eBKiFuAsHGgrZI71anf0QctycGLNQ8cPKEhVoRWznQFmqVDoB/JTm8zoUSv8fEA6xJuz6e3+RaTbxwUx7UCdPs3JfufvCkNE5akXdwrxwce6n1CEp4RLKYteUXjAKfmfoJXwIU3w0QoSdkN3CNpDVxwUfKYdhSY0e2439tMrFaCFmi4bMMYGPWL5XDkuyC4tT7qVVgawe7WP1slCEu1kgS4PfuB1ZFPCQkmohg0W/ZZKq3MPKRiNbXBuTYAmDWmZsKNys4LJAHc5XSKWLTczj0m/qJNdgins1IU5lUDF1FfVw/69k/rtFPFhCSihbyKSOTlV/F0ST7ylORcnqTHrgDjE8m+c6Er5ajUP5EVZJSqXowmD27fJU9WApEC/h9B
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3148436-6cce-49cd-04da-08d7686b4f6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 18:57:19.8574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LgnsTArCjVpzgUZTc5HT48ceeS0K/MhoMjnjaPJ5IAqK7xY5Yoxd7gJjQVzx8KdBVRYnJTbUXuC1dZZM5ntICw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/6/2019 5:19 PM, Andrey Smirnov wrote:=0A=
> On Tue, Nov 5, 2019 at 11:27 PM Vakul Garg <vakul.garg@nxp.com> wrote:=0A=
>>=0A=
>>=0A=
>>=0A=
>>> -----Original Message-----=0A=
>>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-=0A=
>>> owner@vger.kernel.org> On Behalf Of Andrey Smirnov=0A=
>>> Sent: Tuesday, November 5, 2019 8:44 PM=0A=
>>> To: linux-crypto@vger.kernel.org=0A=
>>> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>; Chris Healy=0A=
>>> <cphealy@gmail.com>; Lucas Stach <l.stach@pengutronix.de>; Horia Geanta=
=0A=
>>> <horia.geanta@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>;=0A=
>>> Iuliana Prodan <iuliana.prodan@nxp.com>; dl-linux-imx <linux-=0A=
>>> imx@nxp.com>; linux-kernel@vger.kernel.org=0A=
>>> Subject: [PATCH 0/5] CAAM JR lifecycle=0A=
>>>=0A=
>>> Everyone:=0A=
>>>=0A=
>>> This series is a different approach to addressing the issues brought up=
 in=0A=
>>> [discussion]. This time the proposition is to get away from creating pe=
r-JR=0A=
>>> platfrom device, move all of the underlying code into caam.ko and disab=
le=0A=
>>> manual binding/unbinding of the CAAM device via sysfs. Note that this s=
eries=0A=
>>> is a rough cut intented to gauge if this approach could be acceptable f=
or=0A=
>>> upstreaming.=0A=
>>>=0A=
>>> Thanks,=0A=
>>> Andrey Smirnov=0A=
>>>=0A=
>>> [discussion] lore.kernel.org/lkml/20190904023515.7107-13-=0A=
>>> andrew.smirnov@gmail.com=0A=
>>>=0A=
>>> Andrey Smirnov (5):=0A=
>>>   crypto: caam - use static initialization=0A=
>>>   crypto: caam - introduce caam_jr_cbk=0A=
>>>   crypto: caam - convert JR API to use struct caam_drv_private_jr=0A=
>>>   crypto: caam - do not create a platform devices for JRs=0A=
>>>   crypto: caam - disable CAAM's bind/unbind attributes=0A=
>>>=0A=
>>=0A=
>> To access caam jobrings from DPDK (user space drivers), we unbind job-ri=
ng's platform device from the kernel.=0A=
>> What would be the alternate way to enable job ring drivers in user space=
?=0A=
>>=0A=
> =0A=
> Wouldn't either building your kernel with=0A=
> CONFIG_CRYPTO_DEV_FSL_CAAM_JR=3Dn (this series doesn't handle that right=
=0A=
> currently due to being a rough cut) or disabling specific/all JRs via=0A=
> DT accomplish the same goal?=0A=
> =0A=
It's not a 1:1 match, the ability to move a ring to user space / VM etc.=0A=
*dynamically* goes away.=0A=
=0A=
Horia=0A=
