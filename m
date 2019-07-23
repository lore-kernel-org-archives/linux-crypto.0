Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C42C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 16:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B8D21738
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 16:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="JvncWopK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbfGWQCT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 12:02:19 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:52003
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728293AbfGWQCT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 12:02:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8rAlUVORZIUynXvptHM6Y2g87P7wtCo8XKGtZz0z3x3BDfFzhjsxbWB/PaKdOoBHPgmOkShQXBKtatEIVLNueGIgybnP8Pbs0vm3zTdLUHAZHkgf4NsTJMQPmV6p9UJBmThk5avd8uwxTw5Exou9IWuSiQx0cw4pB9PwUrIb52A0KeyRLJujAiFITIY9Yn20hwpfDlXjyuCyj9qV/SGAC9X3DxGz7UhnV1k7vN4OqP5DvuQJjxSpbRkf/EFxtiX0Hk/iXlwqCvxI2M5+WC79Y+MvjoHT+u0AOONIYCmvSgqzSkPeDYw6WsddCjSSpt/fesQybMiKEPAMpGTDEVvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjG9xhncsK6vhsk5ePEy+XM8uiMIrdOJd58R7Co2cGU=;
 b=egNy9vcB+ck4YfDysbUSaERXpSTLoAM5ZCPYT2DskTWA6Jmyx9Kayndfpi54b3IcEi3Rv112nEZ7NU7NDAocymNDGTvjV5jbA9/MY0SmTHNRPLk7KNq97Qub60ZQAMfdaYGw59A08R1w3wlf11DYNg6bKCv5GXr5V4ntdT7kyDmpeFvcFNYASSRsx0DlDm6Utodj53QXF4+C45aMfZQL5/21ts1kTLRwTD8D0i4iBomVcok3ZLuafS01KOE6GmdDvSHQOCU+v23QRuslY8KLLFvXL5ETyEWY4wTt8HBgHpn4Kki+7ERUNgaxXYEjzlGev/PIN5PUFIt5/dnHWzQBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjG9xhncsK6vhsk5ePEy+XM8uiMIrdOJd58R7Co2cGU=;
 b=JvncWopKTptJb1Ed7oeeEEfl/VLuy6xTWK2yJ8oxw3znVZCpoJw4wlbRZy+6N4X9rEvwkvYpDu0ohZoU4YrlBL4urQKbpuNQw3Ob0GFbKKlh9z1JycijO0nNjkVyvQOGS1z7bLqmKN5kzA/59v6P9L3lnE5Nx2puG3Ha+f/jG/k=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3741.eurprd04.prod.outlook.com (52.134.15.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 16:02:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 16:02:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 04/14] crypto: caam - request JR IRQ as the last step
Thread-Topic: [PATCH v6 04/14] crypto: caam - request JR IRQ as the last step
Thread-Index: AQHVPLPYoWxVILbESUiu4pddWYp7vQ==
Date:   Tue, 23 Jul 2019 16:02:16 +0000
Message-ID: <VI1PR0402MB34854421031A02B1AE3F953098C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-5-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad814f10-2cfe-4389-034f-08d70f872209
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3741;
x-ms-traffictypediagnostic: VI1PR0402MB3741:
x-microsoft-antispam-prvs: <VI1PR0402MB3741E605F3CFB6DB8B3BFE4498C70@VI1PR0402MB3741.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(76116006)(53546011)(66946007)(2906002)(54906003)(66476007)(110136005)(6436002)(316002)(6506007)(91956017)(76176011)(6246003)(2501003)(446003)(25786009)(66066001)(66556008)(64756008)(102836004)(186003)(476003)(55016002)(9686003)(66446008)(53936002)(8936002)(33656002)(7696005)(26005)(478600001)(14444005)(229853002)(305945005)(86362001)(74316002)(486006)(3846002)(6116002)(44832011)(52536014)(68736007)(81166006)(8676002)(99286004)(14454004)(4326008)(71200400001)(5660300002)(71190400001)(81156014)(7736002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3741;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QuJe+1L4uj8/mYZ9BXaw+hf4pN+RN1ZRvC3phhachxKpsa8KBNQ+22Ww2lJ21yFLkMf+Vuw17wHJ4qKz+9NwjJYS+e0Dt3/BDbqJ8T54AZCAGuGKkMaWmkkKaga/tqjmx55+T5ewsVs6Bx2ZKbMBhetqpgFPSH/Hn3bXiTCQDCsdz9Dng/YoQBW8KinUAPdHSBooV1Y58TyIJ/W+FyWG70JptxgbiX4gfxbgMSoplijaCl1zt5oEAdnjZg6b/Gje++VsQb2QDkxp1V34XiVLlj+YKxyzYlgFbGUivMn+S60UTyAZbzU2CqroYM+N4y2J3VMeCRJFQRYyjlwYIhOat43M/Bufi5h6zY6ewJgw08qXsEbN3x594TFyfhztBL9P63q7GPcw6iTOBrv7ud5qce/21OZxQjiVWP6AmKG8dv8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad814f10-2cfe-4389-034f-08d70f872209
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 16:02:16.0413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3741
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> In order to avoid any risk of JR IRQ request being handled while some=0A=
> of the resources used for that are not yet allocated move the code=0A=
> requesting said IRQ to the endo of caam_jr_init(). No functional=0A=
                             ^ typo=0A=
> change intended.=0A=
> =0A=
What qualifies as a "functional change"?=0A=
I've seen this comment in several commits.=0A=
=0A=
>  	error =3D caam_reset_hw_jr(dev);=0A=
>  	if (error)=0A=
> -		goto out_kill_deq;=0A=
> +		return error;=0A=
>  =0A=
>  	error =3D -ENOMEM;=0A=
>  	jrp->inpring =3D dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *=0A=
>  					   JOBR_DEPTH, &inpbusaddr,=0A=
>  					   GFP_KERNEL);=0A=
>  	if (!jrp->inpring)=0A=
> -		goto out_kill_deq;=0A=
> +		return -ENOMEM;=0A=
Above there's "error =3D -ENOMEM;", so why not "return err;" here and=0A=
in all the other cases below?=0A=
=0A=
>  =0A=
>  	jrp->outring =3D dmam_alloc_coherent(dev, sizeof(*jrp->outring) *=0A=
>  					   JOBR_DEPTH, &outbusaddr,=0A=
>  					   GFP_KERNEL);=0A=
>  	if (!jrp->outring)=0A=
> -		goto out_kill_deq;=0A=
> +		return -ENOMEM;=0A=
>  =0A=
>  	jrp->entinfo =3D devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),=
=0A=
>  				    GFP_KERNEL);=0A=
>  	if (!jrp->entinfo)=0A=
> -		goto out_kill_deq;=0A=
> +		return -ENOMEM;=0A=
>  =0A=
>  	for (i =3D 0; i < JOBR_DEPTH; i++)=0A=
>  		jrp->entinfo[i].desc_addr_dma =3D !0;=0A=
> @@ -483,10 +472,19 @@ static int caam_jr_init(struct device *dev)=0A=
>  		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |=0A=
>  		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));=0A=
>  =0A=
> +	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);=0A=
> +=0A=
> +	/* Connect job ring interrupt handler. */=0A=
> +	error =3D devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARE=
D,=0A=
> +				 dev_name(dev), dev);=0A=
> +	if (error) {=0A=
> +		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",=0A=
> +			jrp->ridx, jrp->irq);=0A=
> +		tasklet_kill(&jrp->irqtask);=0A=
> +		return error;=0A=
"return error;" should be moved out the if block.=0A=
=0A=
> +	}=0A=
> +=0A=
>  	return 0;=0A=
> -out_kill_deq:=0A=
> -	tasklet_kill(&jrp->irqtask);=0A=
> -	return error;=0A=
>  }=0A=
=0A=
Horia=0A=
