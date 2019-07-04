Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427CDC06513
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 09:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C99C21882
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 09:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CJtp3p6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfGDJyz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 05:54:55 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:35593
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727223AbfGDJyz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 05:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzUCfW+9lYwogIItMbux/A3luG0AzXDu5IeMbJxi41g=;
 b=CJtp3p6Fa1qteOQaguYUj7AtV1ZY+AqRQbacvqLbohAcdPEKIxZqPvNXiFtMTxBMW1JcpaJ4c4MEK8luV7ZZ0cBPuJwT652MnzB/TaBUDzfaBUOeYGqnioSCY9yDVpbDqx2ykkS9QQCY7ZtkRhlF90r5ZZcsU5heeAApO1PQOhA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3743.eurprd04.prod.outlook.com (52.134.15.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 09:54:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 09:54:51 +0000
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
Subject: Re: [PATCH v4 05/16] crypto: caam - use devres to allocate 'outring'
Thread-Topic: [PATCH v4 05/16] crypto: caam - use devres to allocate 'outring'
Thread-Index: AQHVMXdI6RIFtQ/HV0qJM9wqCVa4iQ==
Date:   Thu, 4 Jul 2019 09:54:51 +0000
Message-ID: <VI1PR0402MB3485379B9E2DF0D109E4743A98FA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-6-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c79304a-19ae-4de7-aab4-08d70065a8a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3743;
x-ms-traffictypediagnostic: VI1PR0402MB3743:
x-microsoft-antispam-prvs: <VI1PR0402MB3743CE82FF45F1043F4646AE98FA0@VI1PR0402MB3743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(189003)(199004)(2906002)(305945005)(68736007)(53546011)(6506007)(91956017)(66446008)(73956011)(66946007)(5660300002)(478600001)(76116006)(64756008)(66476007)(66556008)(6246003)(316002)(7736002)(7696005)(186003)(8676002)(81166006)(3846002)(76176011)(81156014)(6116002)(229853002)(102836004)(25786009)(110136005)(54906003)(4326008)(26005)(86362001)(52536014)(256004)(486006)(476003)(99286004)(66066001)(14454004)(71190400001)(71200400001)(74316002)(53936002)(44832011)(2501003)(55016002)(33656002)(446003)(9686003)(6436002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3743;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C5i5wuCZkIQ2cUWj9wT4EPZFkqCDapN8rJJM6BkUO8uS3cYPRAV3qMe9WMzTM0qxAv4Of8KnNToGTtwIP2ygnH7aE1IgiN0b+XAppzQptnpcLEN/1Z7gwD833121dceWtO+hSNfsVfJOxtBoa3VlQb8eK4VxNbCDBeD1mggc+Nd+W8NPMWMEDEzhqgm5CevOq8qEdh9ptLNP6z7Mvya0DCUZo25WHsE0Wb/Oao8xh27eXr/O48tGLkWCSYjR5rYeHcpNVzYABbyjKyfidqN48ZA41pCpy+yp0LWCglzWukFGDTn8LNBgho1Q4WCUD/HIC5NR0QuhUWtG00isOhP+p3QfrTk18Z+uONQ+R4uJFi5oNyTdj6pzQcfK3sIwuWVuxVEDdUneFum+1oOXFcJW23bdp3lIifIm7PHxjPuATPI=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c79304a-19ae-4de7-aab4-08d70065a8a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 09:54:51.6158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3743
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 11:14 AM, Andrey Smirnov wrote:=0A=
> Use devres to allocate 'outring' and drop corresponding call to=0A=
> dma_free_coherent() as well as extra references to 'struct=0A=
> jr_outentry' (needed in following commits). No functional change=0A=
> inteded.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> Cc: Cory Tusar <cory.tusar@zii.aero>=0A=
> Cc: Chris Healy <cphealy@gmail.com>=0A=
> Cc: Lucas Stach <l.stach@pengutronix.de>=0A=
> Cc: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Leonard Crestez <leonard.crestez@nxp.com>=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Cc: linux-kernel@vger.kernel.org=0A=
> ---=0A=
>  drivers/crypto/caam/jr.c | 15 +++++----------=0A=
>  1 file changed, 5 insertions(+), 10 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
> index fc7deb445aa8..1eaa91dcc146 100644=0A=
> --- a/drivers/crypto/caam/jr.c=0A=
> +++ b/drivers/crypto/caam/jr.c=0A=
> @@ -108,7 +108,7 @@ static int caam_reset_hw_jr(struct device *dev)=0A=
>  static int caam_jr_shutdown(struct device *dev)=0A=
>  {=0A=
>  	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(dev);=0A=
> -	dma_addr_t inpbusaddr, outbusaddr;=0A=
> +	dma_addr_t inpbusaddr;=0A=
>  	int ret;=0A=
>  =0A=
>  	ret =3D caam_reset_hw_jr(dev);=0A=
> @@ -120,11 +120,8 @@ static int caam_jr_shutdown(struct device *dev)=0A=
>  =0A=
>  	/* Free rings */=0A=
>  	inpbusaddr =3D rd_reg64(&jrp->rregs->inpring_base);=0A=
> -	outbusaddr =3D rd_reg64(&jrp->rregs->outring_base);=0A=
>  	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,=0A=
>  			  jrp->inpring, inpbusaddr);=0A=
> -	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,=0A=
> -			  jrp->outring, outbusaddr);=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -459,15 +456,16 @@ static int caam_jr_init(struct device *dev)=0A=
>  	if (!jrp->inpring)=0A=
>  		goto out_free_irq;=0A=
>  =0A=
> -	jrp->outring =3D dma_alloc_coherent(dev, sizeof(*jrp->outring) *=0A=
> -					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);=0A=
> +	jrp->outring =3D dmam_alloc_coherent(dev, sizeof(*jrp->outring) *=0A=
> +					   JOBR_DEPTH, &outbusaddr,=0A=
> +					   GFP_KERNEL);=0A=
>  	if (!jrp->outring)=0A=
>  		goto out_free_inpring;=0A=
>  =0A=
>  	jrp->entinfo =3D devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),=
=0A=
>  				    GFP_KERNEL);=0A=
>  	if (!jrp->entinfo)=0A=
> -		goto out_free_outring;=0A=
> +		return -ENOMEM;=0A=
>  =0A=
This is going to leak resources, so should instead be:=0A=
		goto out_free_inpring;=0A=
=0A=
I suggest merging patches 4, 5, 6.=0A=
They have the same goal, are rather small and make changes in the same plac=
es,=0A=
and would avoid issues like this one.=0A=
=0A=
>  	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);=0A=
>  =0A=
> @@ -495,9 +493,6 @@ static int caam_jr_init(struct device *dev)=0A=
>  =0A=
>  	return 0;=0A=
>  =0A=
> -out_free_outring:=0A=
> -	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,=0A=
> -			  jrp->outring, outbusaddr);=0A=
>  out_free_inpring:=0A=
>  	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,=0A=
>  			  jrp->inpring, inpbusaddr);=0A=
> =0A=
