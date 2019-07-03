Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FBFC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 23:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7EF22187F
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 23:45:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pguTsmTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfGCXpl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 19:45:41 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:51364
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfGCXpl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 19:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl1N1KKRlbVNZqTDGWye8FUGkTS/iOqd5lQr7gzxj8A=;
 b=pguTsmTUHbMp0pOuDKu9S0yjYXU1ErJECS42UgBmjc9Y1gNJlFWRQ7qoaNYxvsFn0FTVj8Ch0hk/OCyQCakxeFxDn6cc1sVMb55xRD78lMktF0pSu+OhGK0Nlxu3T5X5baQFQFIWPGhYvgCohDTAG9VmI5+caN1+b+wXhPUG600=
Received: from DB7PR04MB5051.eurprd04.prod.outlook.com (20.176.234.223) by
 DB7PR04MB4538.eurprd04.prod.outlook.com (52.135.134.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Wed, 3 Jul 2019 23:45:38 +0000
Received: from DB7PR04MB5051.eurprd04.prod.outlook.com
 ([fe80::6c98:1416:8221:bdfc]) by DB7PR04MB5051.eurprd04.prod.outlook.com
 ([fe80::6c98:1416:8221:bdfc%4]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 23:45:38 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Topic: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Index: AQHVMXdGY7YVraimN0KG3E6/ZzGQWw==
Date:   Wed, 3 Jul 2019 23:45:37 +0000
Message-ID: <DB7PR04MB50517E97A2BE28050E056B90EEFB0@DB7PR04MB5051.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-4-andrew.smirnov@gmail.com>
 <VI1PR04MB505565EC5520F4820E234A84EEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
 <CAHQ1cqHfBU92g-P7jDfiWtEr0m-kv5Lw9yZcvUEXYg7OyhURfg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 919eb507-f56f-48e9-d388-08d700108d0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4538;
x-ms-traffictypediagnostic: DB7PR04MB4538:
x-microsoft-antispam-prvs: <DB7PR04MB453853660A802BEFCBD03C58EEFB0@DB7PR04MB4538.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(33656002)(9686003)(81166006)(71190400001)(81156014)(55016002)(102836004)(26005)(229853002)(53936002)(6916009)(6116002)(8936002)(446003)(54906003)(186003)(316002)(476003)(44832011)(3846002)(68736007)(486006)(71200400001)(6436002)(6506007)(6246003)(7736002)(73956011)(66946007)(305945005)(66446008)(64756008)(66556008)(66476007)(478600001)(86362001)(52536014)(14444005)(256004)(5660300002)(99286004)(53546011)(4326008)(76176011)(66066001)(74316002)(25786009)(76116006)(7696005)(91956017)(14454004)(8676002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4538;H:DB7PR04MB5051.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MI0znHPPqDgzTngT+HjwgCnoO7iXIrynSPDIz7Ewj2xw5O0HN6j8GmoMSx0Fbnpnep/seZMFkXWsDoIn7t7gK3xf9sGjDmXMYyw0xsyDmyTEPvC9mGOCVP+Sq8Ly+jqqBkpF54+oRwke/bTM2ba67RJvwYYkI/03qWLKj3WkqNpA9FAjABPMfGOD/lvTTrJl4wwMM/PbGecIaorcw6ax6FbZBXrXt88BeDmmCcvUGfN4WtENfkl1EOmRNSzLABW+dp6D8Lkfmuv3VTO1OrDZ0Zt5Vbcr5CnFWwCnPbCPPTU9cfmBo+ZG9hxWMgXS4jaOeO5w0A6acZjmaJDvre+Bp/+nyxWSOOaUQUp7AAT1f2uDxfnXVZ7pToW0McQxF7BSBbH8nIz5JNnbNQk8vZcc3k4WkX3VKkdtGFMzo1+/QPA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919eb507-f56f-48e9-d388-08d700108d0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 23:45:37.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4538
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 8:14 PM, Andrey Smirnov wrote:=0A=
> On Wed, Jul 3, 2019 at 6:51 AM Leonard Crestez <leonard.crestez@nxp.com> =
wrote:=0A=
>> On 7/3/2019 11:14 AM, Andrey Smirnov wrote:=0A=
>>> Move tasklet_init() call further down in order to simplify error path=
=0A=
>>> cleanup. No functional change intended.=0A=
>>>=0A=
>>> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
>>> index 4b25b2fa3d02..a7ca2bbe243f 100644=0A=
>>> --- a/drivers/crypto/caam/jr.c=0A=
>>> +++ b/drivers/crypto/caam/jr.c=0A=
>>> @@ -441,15 +441,13 @@ static int caam_jr_init(struct device *dev)=0A=
>>>=0A=
>>>        jrp =3D dev_get_drvdata(dev);=0A=
>>>=0A=
>>> -     tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);=
=0A=
>>> -=0A=
>>>        /* Connect job ring interrupt handler. */=0A=
>>>        error =3D request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,=
=0A=
>>>                            dev_name(dev), dev);=0A=
>>>        if (error) {=0A=
>>>                dev_err(dev, "can't connect JobR %d interrupt (%d)\n",=
=0A=
>>>                        jrp->ridx, jrp->irq);=0A=
>>> -             goto out_kill_deq;=0A=
>>> +             return error;=0A=
>>>        }=0A=
>>=0A=
>> The caam_jr_interrupt handler can schedule the tasklet so it makes sense=
=0A=
>> to have it be initialized ahead of request_irq. In theory it's possible=
=0A=
>> for an interrupt to be triggered immediately when request_irq is called.=
=0A=
>>=0A=
>> I'm not very familiar with the CAAM ip, can you ensure no interrupts are=
=0A=
>> pending in HW at probe time? The "no functional change" part is not obvi=
ous.=0A=
>>=0A=
> =0A=
> Said tasklet will use both jrp->outring and jrp->entinfo array=0A=
> initialized after IRQ request call in both versions of the code=0A=
> (before/after this patch). AFAICT, the only case where this patch=0A=
> would change initialization safety of the original code is if JR was=0A=
> scheduled somehow while ORSFx is 0 (no jobs done), which I don't think=0A=
> is possible.=0A=
=0A=
I took a second look at caam_jr_init and there is apparently a whole =0A=
bunch of other reset/init stuff done after request_irq. For example =0A=
caam_reset_hw_jr is done after request_irq and masks interrupts?=0A=
=0A=
What I'd expect is that request_irq is done last after all other =0A=
initialization is performed. But I'm not familiar with how CAAM JRs work =
=0A=
so feel free to ignore this.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
