Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D62C4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3EAB2086A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 15:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="AxIwA8t5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403812AbfITPu3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:50:29 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:15424
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404331AbfITPu3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 11:50:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDNpQ+nXV7rRXgoFWEuT6fohBWQ+NAqxcrnkkLuhLRhBVqU5/5OyB6P1FvA/xHHdR7J2C+r5E3GYkl6dHO1UbXRydcFN1adyjvgB1DMuO7ovDd/Oxjv4QnxCg1A1C3UDaphjl4QMlB64ZVXf2uk2dIkic5BfRsQUxudzSKPXeUAyjIwyM/jlBFcH9q2fEdNdaBNAkD0oDkzSjA/XXO792OmLs36wKq181b5IO+TePb8ZJ5Y2E1AUyLD390Ahfg4ZS5cMMhszdqFskyvYf+/7y8RJ70/H4sFEU4lrUU/qYSSqOPGwGal4Wnv5RB1cwludfuKJfMpBGfYRynotJlUjaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTWoLkxbLu/brwTF543TXL/cAu8ueaw2ycp3zKkolUU=;
 b=Z+1CjE/fj3uUJZKuxkIg3N5t8tmS7U5iDstLB8N2CHy2XX2wUdJijGqmPNUTnwRqAvkO2DIwxwmapCI6kk8fkIwJUs57m0c6DFiBNb3888tzFeAnYnyV+XNEPGvP+WDx7mX/hRpHXxRlvDSA5j7ZNQnWIaQ4+T2aeLatAUa6PRb3Y3tAq3G0uVxlgIsSPFQCm98suDtvyjOXArQ+SSkRyUHj4y+Fv6NmZqEtl/3v8khJ7G0eTpjvi/hSgFdsBM6drCSYF+e6R1j6euO6DL17XUmjsvHAznCc010bPslq6HUe4e6I2VM0AOvfcfZVCgxOt8KZF11+priexUSm9K5biQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTWoLkxbLu/brwTF543TXL/cAu8ueaw2ycp3zKkolUU=;
 b=AxIwA8t5VCedHqckLuD1x1yP8EIQLe8RrBbYPPZwOlyMUhS1rza5AlXOyZrwANg96jLomYxi3WEuNJGfK3uKT2LkO1R/yvFM/kFS5Nzwl04Bft60P4Kr+z3O6wIEbzTD31y5gQkEPo+jQ214yZdqxn/kvh+kiPihQUpDkaKMLeE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3325.eurprd04.prod.outlook.com (52.134.7.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Fri, 20 Sep 2019 15:50:24 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196%7]) with mapi id 15.20.2263.023; Fri, 20 Sep 2019
 15:50:24 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - use the same jr for rng init/exit
Thread-Topic: [PATCH] crypto: caam - use the same jr for rng init/exit
Thread-Index: AQHVaIQ+ooPZSK+hE0+ffBEyoUzaeQ==
Date:   Fri, 20 Sep 2019 15:50:24 +0000
Message-ID: <VI1PR0402MB34853076C01D2973E9401AEC98880@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-12-andrew.smirnov@gmail.com>
 <VI1PR0402MB34859D108C03F3AB0F64EE6598B10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqFyPs1vONwV3Ujv6MwqoP=672pCEXFTuM+j20zNPD86tw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7e0efa2-9204-4cdf-3e15-08d73de2400a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3325;
x-ms-traffictypediagnostic: VI1PR0402MB3325:|VI1PR0402MB3325:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3325864FB7FDD9B6FF05002C98880@VI1PR0402MB3325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(3846002)(66446008)(229853002)(6116002)(91956017)(5660300002)(99286004)(305945005)(76116006)(55016002)(6246003)(446003)(186003)(9686003)(71200400001)(2906002)(6916009)(486006)(66476007)(8936002)(33656002)(71190400001)(14454004)(6306002)(476003)(74316002)(66556008)(44832011)(7736002)(64756008)(66946007)(54906003)(102836004)(478600001)(7696005)(86362001)(6506007)(316002)(66066001)(8676002)(52536014)(256004)(6436002)(53546011)(81166006)(81156014)(25786009)(14444005)(966005)(76176011)(26005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3325;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vEFeAjfjtnTwxDBAuhzcnX1dDM9VoXfciXlkHU4N6Sme6DThGPMOM4i7AEzlvEd5qAqZTaTaaOn5wXQ8u7RXgH/y/vUqvHr8uxd0/bMaxERQ0d/a7oRhII2g7ltPf9pb6sLrdSEG5gjeRm7cbGCrP491pNzQpNMbsWUGuYus7csBQ5SRwsOhegAmYkRTi6a7EukI5SdVTfInaoJAyH+/mllesy1mjmzUFleu6JHPBWMRiasqVo45NJzbhktPl0S1P/XfFiVEvFCRXkU2s7rspRiMzoKaSZ2krT23THqOspjCHGYPN4tS1I6q4Nosr0bV8V2j9+4xv8j39GDjmkpWN/TiNFWqu9iYBKkncoiJMQ0sJ8EoIyQSE2XgHYNRmxnmA3VI8DKvNPQj9YcSXkVx/Wy6xBn8QA/y+hT5GUXto8U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e0efa2-9204-4cdf-3e15-08d73de2400a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 15:50:24.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XP1TlNj+VbI0KGlF+toBkI7cTY6SVK77PwJRiTgtFQe0zISNFpNuJa+UHiBwm9dR/QUrq6mDDfDKy9IccGusmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3325
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/18/2019 9:01 AM, Andrey Smirnov wrote:=0A=
> On Wed, Sep 11, 2019 at 2:35 AM Horia Geanta <horia.geanta@nxp.com> wrote=
:=0A=
>>=0A=
>> On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
>>> In order to allow caam_jr_enqueue() to lock underlying JR's=0A=
>>> device (via device_lock(), see commit that follows) we need to make=0A=
>>> sure that no code calls caam_jr_enqueue() as a part of caam_jr_probe()=
=0A=
>>> to avoid a deadlock. Unfortunately, current implementation of caamrng=
=0A=
>>> code does exactly that in caam_init_buf().=0A=
>>>=0A=
> =0A=
> I don't think your patch addresses the above, so it can probably be=0A=
> cut out of the message.=0A=
> =0A=
No, it does not, it addresses the issue right below.=0A=
=0A=
Not sure what you mean by "cut out of the message". If you look carefully=
=0A=
in the original message, at some pointer there is a scissors line.=0A=
=0A=
>>> Another big problem with original caamrng initialization is a=0A=
>>> circular reference in the form of:=0A=
>>>=0A=
>>>  1. caam_rng_init() aquires JR via caam_jr_alloc(). Freed only by=0A=
>>>     caam_rng_exit()=0A=
>>>=0A=
>>>  2. caam_rng_exit() is only called by unregister_algs() once last JR=0A=
>>>     is shut down=0A=
>>>=0A=
>>>  3. caam_jr_remove() won't call unregister_algs() for last JR=0A=
>>>     until tfm_count reaches zero, which can only happen via=0A=
>>>     unregister_algs() -> caam_rng_exit() call chain.=0A=
>>>=0A=
>>> To avoid all of that, convert caamrng code to a platform device driver=
=0A=
>>> and extend caam_probe() to create corresponding platform device.=0A=
>>>=0A=
>>> Additionally, this change also allows us to remove any access to=0A=
>>> struct caam_drv_private in caamrng.c as well as simplify resource=0A=
>>> ownership/deallocation via devres.=0A=
>>>=0A=
>> I would avoid adding platform devices that don't have=0A=
>> corresponding DT nodes.=0A=
>>=0A=
>> There's some generic advice here:=0A=
>> https://www.kernel.org/doc/html/latest/driver-api/driver-model/platform.=
html#legacy-drivers-device-probing=0A=
>>=0A=
>> and there's also previous experience in caam driver:=0A=
>> 6b175685b4a1 crypto: caam/qi - don't allocate an extra platform device=
=0A=
>>=0A=
> =0A=
> Hmm, I am not sure how that experience relates to the case we have=0A=
> with hwrng, but OK, I'm going to assume that platform driver approach=0A=
> is a no-go.=0A=
> =0A=
Not specific to hwrng, but platform drivers in general:=0A=
    [...]=0A=
    SMMU. A platform device allocated using platform_device_register_full()=
=0A=
    is not completely set up - most importantly .dma_configure()=0A=
    is not called.=0A=
=0A=
Horia=0A=
