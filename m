Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC0BC46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 10:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8789C2133F
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 10:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="rrghyqiz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfGEKdc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 06:33:32 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:60229
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728261AbfGEKdc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 06:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z5zOpQSGqOOp1YEiOb3Z2ObGLKvsjocynHpv/tC+64=;
 b=rrghyqizBnmRRPp0foUyjiE7XarXJGyVBQ2ijykWag1kCnzddFFLb3ekhuI9tUMASgIRvbZJFRDufFzCL5UrbiArVAvEcw74RJaXcPYLLZAG/9uxBMJsH1KiqFIuSDUTylddw9YuWaDQzepqvdaN43gvEyJgrd8SnguPA09fPkw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3661.eurprd04.prod.outlook.com (52.134.14.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Fri, 5 Jul 2019 10:33:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2032.019; Fri, 5 Jul 2019
 10:33:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Leonard Crestez <leonard.crestez@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Topic: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Index: AQHVMXdGYTUZQeifmkmahS6lPxMv/g==
Date:   Fri, 5 Jul 2019 10:33:19 +0000
Message-ID: <VI1PR0402MB34855EFBC80E4EF8A543231998F50@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-4-andrew.smirnov@gmail.com>
 <VI1PR04MB505565EC5520F4820E234A84EEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
 <CAHQ1cqHfBU92g-P7jDfiWtEr0m-kv5Lw9yZcvUEXYg7OyhURfg@mail.gmail.com>
 <DB7PR04MB50517E97A2BE28050E056B90EEFB0@DB7PR04MB5051.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04d1972a-995c-460c-e4da-08d7013432c0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3661;
x-ms-traffictypediagnostic: VI1PR0402MB3661:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB36610CAF70B94398A6DFCE5898F50@VI1PR0402MB3661.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(189003)(199004)(86362001)(99286004)(3846002)(91956017)(966005)(7696005)(76116006)(55016002)(6306002)(66946007)(9686003)(64756008)(6116002)(66476007)(6246003)(102836004)(25786009)(4326008)(71200400001)(52536014)(33656002)(73956011)(66446008)(66556008)(2906002)(53936002)(68736007)(229853002)(53546011)(6506007)(71190400001)(76176011)(6436002)(110136005)(7736002)(26005)(186003)(8936002)(316002)(74316002)(305945005)(478600001)(446003)(486006)(476003)(256004)(14444005)(5660300002)(14454004)(54906003)(44832011)(81156014)(8676002)(81166006)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3661;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vGiq2v5hBq37MssiiY+lJRNJ1HCJCgxseSEmQW7fMP7e1iojQqwtR60DOndAa0ee1VmksZtU9WvzP2XKfPWfkh7BZXJzfvkT86jjx/JlXrzG6HU2lQXfPznL0eBt6iTnDinmIkbkYqUnO2RJWCAF9GrKzwdbfrjqpDOUt+x6ZqeXNIPZv0yg+Swr1S/vf7B5kvE5TyWUEOVo7zxmqF2l/kgHT1SN1+XzIUk7Hck4wsddOB8NrwCc+35wsiDDHCNvN44CT0Ny2fgHAwFyfk/5YWpwGsAUchZfRoiDTWc8b3fsiMo7Zh4zzm1/IRZqBZPNmc5FZGXKjMIR3gnOFNSRfRZoZhEEM6xSomlwMC8UjNvHUc3BLmPI+peO0+YNUcZ9cRj/LNaGSuhBrq45iFxz+AOuOu9tPCpyN1EcjJ8Hsfo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d1972a-995c-460c-e4da-08d7013432c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 10:33:19.6284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3661
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/4/2019 2:45 AM, Leonard Crestez wrote:=0A=
> On 7/3/2019 8:14 PM, Andrey Smirnov wrote:=0A=
>> On Wed, Jul 3, 2019 at 6:51 AM Leonard Crestez <leonard.crestez@nxp.com>=
 wrote:=0A=
>>> On 7/3/2019 11:14 AM, Andrey Smirnov wrote:=0A=
>>>> Move tasklet_init() call further down in order to simplify error path=
=0A=
>>>> cleanup. No functional change intended.=0A=
>>>>=0A=
>>>> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
>>>> index 4b25b2fa3d02..a7ca2bbe243f 100644=0A=
>>>> --- a/drivers/crypto/caam/jr.c=0A=
>>>> +++ b/drivers/crypto/caam/jr.c=0A=
>>>> @@ -441,15 +441,13 @@ static int caam_jr_init(struct device *dev)=0A=
>>>>=0A=
>>>>        jrp =3D dev_get_drvdata(dev);=0A=
>>>>=0A=
>>>> -     tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev)=
;=0A=
>>>> -=0A=
>>>>        /* Connect job ring interrupt handler. */=0A=
>>>>        error =3D request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,=
=0A=
>>>>                            dev_name(dev), dev);=0A=
>>>>        if (error) {=0A=
>>>>                dev_err(dev, "can't connect JobR %d interrupt (%d)\n",=
=0A=
>>>>                        jrp->ridx, jrp->irq);=0A=
>>>> -             goto out_kill_deq;=0A=
>>>> +             return error;=0A=
>>>>        }=0A=
>>>=0A=
>>> The caam_jr_interrupt handler can schedule the tasklet so it makes sens=
e=0A=
>>> to have it be initialized ahead of request_irq. In theory it's possible=
=0A=
>>> for an interrupt to be triggered immediately when request_irq is called=
.=0A=
>>>=0A=
>>> I'm not very familiar with the CAAM ip, can you ensure no interrupts ar=
e=0A=
>>> pending in HW at probe time? The "no functional change" part is not obv=
ious.=0A=
>>>=0A=
Actually there is a previous report (in i.MX BSP) of CAAM job ring generati=
ng=0A=
an interrupt at probe time, between request_irq() and reset:=0A=
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/=
caam?h=3Dimx_4.14.98_2.0.0_ga&id=3Daa7b3f51971ec1f60f41fe8ea71870b215376b8a=
=0A=
=0A=
So yes, there might be cases when interrupts are pending.=0A=
=0A=
>>=0A=
>> Said tasklet will use both jrp->outring and jrp->entinfo array=0A=
>> initialized after IRQ request call in both versions of the code=0A=
>> (before/after this patch). AFAICT, the only case where this patch=0A=
>> would change initialization safety of the original code is if JR was=0A=
>> scheduled somehow while ORSFx is 0 (no jobs done), which I don't think=
=0A=
>> is possible.=0A=
> =0A=
> I took a second look at caam_jr_init and there is apparently a whole =0A=
> bunch of other reset/init stuff done after request_irq. For example =0A=
> caam_reset_hw_jr is done after request_irq and masks interrupts?=0A=
> =0A=
> What I'd expect is that request_irq is done last after all other =0A=
> initialization is performed. But I'm not familiar with how CAAM JRs work =
=0A=
> so feel free to ignore this.=0A=
> =0A=
There's some history here... (which is in contradiction with above-mentione=
d=0A=
report).=0A=
=0A=
Commit 9620fd959fb1 ("crypto: caam - handle interrupt lines shared across r=
ings")=0A=
moved request_irq() before JR reset:=0A=
"=0A=
    - resetting a job ring triggers an interrupt, so move request_irq=0A=
    prior to jr_reset to avoid 'got IRQ but nobody cared' messages.=0A=
"=0A=
=0A=
but IIUC that ("resetting a job ring triggers an interrupt") was actually=
=0A=
due to disabling the IRQ line using disable_irq() instead of masking=0A=
the interrupt in HW using JRCFGR_LS[IMSK].=0A=
=0A=
The way JR reset sequence is implemented now - in caam_reset_hw_jr() - shou=
ld not=0A=
trigger any interrupt.=0A=
=0A=
Thus, it should be safe to move request_irq() after everything is set up,=
=0A=
at the end of probing.=0A=
=0A=
My suggestion is to move both tasklet_init() and request_irq() at the botto=
m=0A=
of the probe callback.=0A=
However, I'd say this is a fix that should be marked accordingly and=0A=
should be posted either separately, or at the top of the patch set.=0A=
=0A=
Thanks,=0A=
Horia=0A=
