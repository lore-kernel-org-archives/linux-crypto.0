Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F1AC35E01
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 14:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C4662084E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 14:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="GZtN1hpa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgBYOxj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 09:53:39 -0500
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:22340
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730264AbgBYOxi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 09:53:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jnti11WupGUAv6mkPzUzWUKb2btAS2Nmdc/O2O85c8jE0Vi+LTD1gKC/lV21I5k9W9qOekcS0UEEcDfGAYMbgpzrRxGNhkIz9Bw1ITAvsXTG3J03P5PTQS1z86kbtwTDFfj7b7bQbgqiHKx8CzQbyA44oUTI8wbrtPMXB5S8882slz1FNO/1DS9CC9kJNsZe6uoqHnJlh7lSOA7yobUKQCfor9wuPX0qOo03MekeQUNOCCH8XHT/B68sv6XMxRo6za4VlLLF1XKvGrue4f+KTl5/Khj8OL8KL9u9ZNfJQllyZvKEI7EOpjsSu9OlaJlJ9EQVqqwIdebS1414dVFdfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dicUWKMYWtpPMysaaYNYv5xInZgYAHnHd0ZZ8EycgHU=;
 b=WEZ6GcKI37zfIcks5RT9mjMBKy9P59mAhborBNC+qSzbvxbubvEgMFpNpJSFwa6xHh2N0++DgxfLgbz8f/lJzX0dMEWfgwqunZcPNQdbp2oKiajp7AuF9ntcYecUfKMz+2j/r/928qD1qQ3MnL9kndSH+YWpOm1d/vTMQuL48gM3FgQocWX1pSfavLNQU4ak22llt6Au/ZSHMQObu7fcpz3x8HQjIlDB8KN7wGquFvoDVxoVff5iUnPXJrJMAcAH/aK8l/9tIQiRsLG35agvPmK3ejKLTc5LmFPTwmyhd/vIJ312t5VK/WOS/+0HktCvTMgYE8tyGv6DuuxC4A/VCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dicUWKMYWtpPMysaaYNYv5xInZgYAHnHd0ZZ8EycgHU=;
 b=GZtN1hpaALsto5uxSCXrRjMs/osYT4iOO9vN4BhsnciWWKyywDBgDVoWgKzmb90WD44hB14Lw+7XHfwGN+vqwKpdnO1cvfxlOAIGYz+BZ4eWWtiOSbvnC9HwlrAJbBCGOrWyTneqgZFM0FbWM6yXmhWQFRblr1VDeRTRXTRON7I=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Tue, 25 Feb 2020 14:53:34 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 14:53:34 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] crypto: caam: re-init JR on resume
Thread-Topic: [RFC] crypto: caam: re-init JR on resume
Thread-Index: AQHV2nuUMVzJk05YSUGngOodcu7wgw==
Date:   Tue, 25 Feb 2020 14:53:34 +0000
Message-ID: <VI1PR0402MB348516318CA986084CBE7B5C98ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20200203101850.22570-1-matthias.schiffer@ew.tq-group.com>
 <eca3c07767f2451590496bc890b235c8285f1a0b.camel@ew.tq-group.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd17ca9c-4ffa-4a5e-044b-08d7ba027cc9
x-ms-traffictypediagnostic: VI1PR0402MB2800:|VI1PR0402MB2800:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28001905F5F7A2B47925F37398ED0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(189003)(199004)(4326008)(71200400001)(33656002)(9686003)(44832011)(478600001)(2906002)(81166006)(26005)(53546011)(6506007)(81156014)(55016002)(52536014)(8936002)(8676002)(91956017)(316002)(64756008)(66476007)(5660300002)(7696005)(6636002)(186003)(66946007)(66446008)(76116006)(110136005)(66556008)(54906003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2800;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2hl8afokwwd0XnpT4u6un81dQGNstIZ5OD9KY1/1642DrPZb0ZRvf2YaOh7T3CE+pMNVkuZPuLbFyyl4J1TKd4qqP7ktIgvyO5aziHLvMA8NkOa2CeDNgKYzVPkReUAQskrwVd7Oo9aWM1jya35cDnWajfBFS2Ks6OzWJnl6+R2gZ9byZo3vz1y/eWAzWEftks3SPyox5RMstl0TkpTUpDhER27JO1O5DRT8I1ZrI+m/CY0mwpJH0ujwUbqU5THR9kzNGH6MG99tu9+ZweWVHRKlWvD7U4uM6Kt28N2+unH4QustH9YvNWlzANa4GJKY89yL2WKeQo3RQ7cGklwU37vPi4BYJmuVfOQJmNo/iNvS4xOdILRx9ArKpMG0lRmZvP9vN6C5nCKwNDggTlM4COPdMFhj9psXk6AvmsxVt2nPIQNqPdbWCa57sTXlzBcu
x-ms-exchange-antispam-messagedata: 3mYutZyKgYqmhFKMIaL73fPz1Zu6IuzlF1jCJ1V3i5+ktEPCNd1QFkpHLIEyC4wLrKC7V3oY8L/vGyZljGLwtG9iEYG3CRES2eYsFxJP/BcC+Q1ZkHAP1y/68tiakmsp0wxpa7zl9RdaEyOwBTERkQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd17ca9c-4ffa-4a5e-044b-08d7ba027cc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 14:53:34.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m5lJIiI+RpttHDauafGipldppdvA8ejl2Bm7uUBb2lGvxgmb5Tj6BnbgyYMHGssshn+GOyUtfO2S59hgdcQZwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/21/2020 10:43 AM, Matthias Schiffer wrote:=0A=
> On Mon, 2020-02-03 at 11:18 +0100, Matthias Schiffer wrote:=0A=
>> The JR loses its configuration during suspend-to-RAM (at least on=0A=
>> i.MX6UL). Re-initialize the hardware on resume.=0A=
>>=0A=
>> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>=0A=
>> ---=0A=
>>=0A=
>> I've come across the issue that the CAAM would not work anymore after=0A=
>> deep sleep on i.MX6UL. It turned out that the CAAM loses its state=0A=
>> during suspend-to-RAM, so all registers read as zero and need to be=0A=
>> reinitialized.=0A=
>>=0A=
>> This patch is my first attempt at fixing the issue. It seems to work=0A=
>> well enough, but I assume I'm missing some synchronization to prevent=0A=
>> that some CAAM operation is currently under way when the suspend=0A=
>> happens? I don't know the PM and crypto subsystems well enough to=0A=
>> judge=0A=
>> if this is possible, and if it is, how to prevent it.=0A=
>>=0A=
>> I've only compile-tested this version of the patch, as I had to port=0A=
>> it=0A=
>> from our board kernel, which is based on the heavily-modified NXP=0A=
>> branch.=0A=
> =0A=
> It would be great to get some feedback on this patch. Is the hardware=0A=
> support to lose its state? Does my fix look correct?=0A=
> =0A=
For most parts, yes, CAAM HW block loses state.=0A=
=0A=
We are working at upstreaming PM support.=0A=
=0A=
A non-exhaustive high-level list of things to be done, on top of your patch=
:=0A=
-caam controller driver (ctrl.c) also needs support for PM,=0A=
for e.g. RNG has to be reinitialized when resuming=0A=
-caam/jr driver: a few other registers have to be saved & restored=0A=
-caam/jr driver: flush/abort the jobs in the input ring when suspending=0A=
-implementations of algorithms using "split key" (a.k.a. "derived key"),=0A=
which is a black / encrypted key, have to convert the key to=0A=
a persistent blob since KEKs (JDKEK, TDKEK, TDSK registers) are lost=0A=
and in certain cases cannot be restored to initial values=0A=
=0A=
Horia=0A=
