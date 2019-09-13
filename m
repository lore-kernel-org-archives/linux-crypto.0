Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC643C4CEC8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD80206A5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="nr0y/Ypk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfIMTQU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:16:20 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:21484
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389998AbfIMTQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 15:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOlQZ4khaZMSwhJa3uHbdf+UQDLM0w+KRLl4Z2rdQvbnw0UHzCMCn1tfTvNCoyEZuMZw4rLvosKai/IBKFg5UZiKzaFrmQXoAe90QvygU5IAjfjWgC8h5cmPGlkLGgyAT6lvE9YG2O24llxn4Xn0sIg2CGZCCWwl2nrz416pKAcsNb0wz61K676hkQTTpTo/sY1LzBvwfNz6Ga37NyaWXy6DxYY+oWMkw2Mk/ehBQM5n/iXS+CjJoWrH5a+MgEC7xxnvEjLSNSP4VVpd3OF7NIB9f3sH6RW6KqzILomUYu+DomrM0GRbHNZlSpzY6D41xhBMh3hd8wZPOFiVxbbAaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DFMl1tMLb2XrlnWWV30iTmfuw4AoPx1Rqmrn53buz0=;
 b=SXPdYTfHepwUvIamKU4brn78EMOkjYsLyhecKIZL9Xijwm9IgKd5qVTVTGllhoJMAQmPWUP5Sw5QvgWllLKPrhkNjPeoy8ziiGyDYxzfr3A52e+Vp6H0w2ZTVfvf+LYMi2w32b1DAN91mQ/dxD3gEeV2DU4DBNNpBR6Ukiu0n2/95cjjrgwXAMsS81+75XZqBm1T/tQTjrQ8xsHKrapslZ+hYyf/4PqK3FQAhKa1fHz3KuMUMrTC/g6w26LY9RjWl4QRG6HTW3TCnAkxBvppcmqSFvXHQM7fpcrFHDUKAxOjCLNNP9PH0tttspzShJjzPc0l/00DNLfTq1TXs6MyRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DFMl1tMLb2XrlnWWV30iTmfuw4AoPx1Rqmrn53buz0=;
 b=nr0y/YpkRfhyC1vM3CvNauUnCwunroHlO7W3hKMh/Uy14QsMjGMwto0y+X1lbiKIMy9AyT4FsmFIsxyJQuGsA5HNGuVGXbRx88hjCHCD0sT7OH9cSGSfGq66g1/E0JwReztc9eYYRBv+6Lfz8oh5XLRY5XNn0brinKy637xSxvQ=
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com (10.186.159.144) by
 VI1PR04MB7072.eurprd04.prod.outlook.com (10.186.158.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Fri, 13 Sep 2019 19:16:03 +0000
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::c5e8:90f8:da97:947e]) by VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::c5e8:90f8:da97:947e%3]) with mapi id 15.20.2263.016; Fri, 13 Sep 2019
 19:16:03 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>
Subject: Re: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Thread-Topic: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Thread-Index: AQHVYsl8OwUGpRwn4UGFwo5O2e2LiQ==
Date:   Fri, 13 Sep 2019 19:16:03 +0000
Message-ID: <VI1PR04MB7023A7EC91599A537CB6A487EEB30@VI1PR04MB7023.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-13-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 946fc8bc-c27e-42a8-0c15-08d7387ed1fd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB7072;
x-ms-traffictypediagnostic: VI1PR04MB7072:|VI1PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB70728042C1C41998B360DDF3EEB30@VI1PR04MB7072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(199004)(189003)(9686003)(66946007)(66446008)(64756008)(66556008)(66476007)(6636002)(76116006)(91956017)(486006)(74316002)(7736002)(86362001)(71200400001)(71190400001)(52536014)(305945005)(81166006)(25786009)(8676002)(44832011)(8936002)(81156014)(33656002)(476003)(478600001)(4326008)(14454004)(229853002)(99286004)(54906003)(6116002)(110136005)(55016002)(3846002)(186003)(26005)(53936002)(5660300002)(446003)(66066001)(256004)(14444005)(316002)(76176011)(6246003)(53546011)(6506007)(102836004)(7696005)(2906002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7072;H:VI1PR04MB7023.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SuUHtvmKE4brosgantS+6SSu2+QKdVNBvaWnDhkzBSB6c/oaRJUGuUMv5uV7jFNk0s0T7z3/D4BLgtZiEf5DmCM5+3TB15LRaVaajGEWrfnjHK6hW4uIJvObXqXQgvkBqGEAlEvUaXqhQ1rdagfsC0fd9bj496IOvTwPS3r7aOcAxV+ppgr2serda9qKMVLxLWwvcDfxqniIv88NL71K8nlZMkzE02L5WUy1qZrAGIvTD2Cbr+wktIUfhydGCfnzFANK1h5N+jeRLA85tY/NrJIesfCmXT5TzlCjHViaPG+n/DpI7T12GO6MoSNie3Ew6XnCSOJYT53EGjDFmEYpYrXZ9hwLdamNiYGpdcK2qqpQg6hZx3jJO6L2PEig0cjtsCex/taXxuJ/FJ3B+ytwlsEPAQsNiAo5PQqrcDoWGtU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946fc8bc-c27e-42a8-0c15-08d7387ed1fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:16:03.5290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+5JGTGPzLRw2jb8vEOQUmXRrMZBsimEQ3ajgRaaUDFutR7WPvcdccWiw1XNAjSq2EVanbQX8pRHgwIjN+2yZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04.09.2019 05:35, Andrey Smirnov wrote:=0A=
> Returning -EBUSY from platform device's .remove() callback won't stop=0A=
> the removal process, so the code in caam_jr_remove() is not going to=0A=
> have the desired effect of preventing JR from being removed.=0A=
> =0A=
> In order to be able to deal with removal of the JR device, change the=0A=
> code as follows:=0A=
> =0A=
>    1. To make sure that underlying struct device remains valid for as=0A=
>       long as we have a reference to it, add appropriate device=0A=
>       refcount management to caam_jr_alloc() and caam_jr_free()=0A=
> =0A=
>    2. To make sure that device removal doesn't happen in parallel to=0A=
>        use using the device in caam_jr_enqueue() augment the latter to=0A=
>        acquire/release device lock for the duration of the subroutine=0A=
> =0A=
>    3. In order to handle the case when caam_jr_enqueue() is executed=0A=
>       right after corresponding caam_jr_remove(), add code to check=0A=
>       that driver data has not been set to NULL.=0A=
=0A=
What happens if a driver is unbound while a transform is executing =0A=
asynchronously?=0A=
=0A=
Doing get_device and put_device in caam_jr_alloc and caam_jr_free =0A=
doesn't protect you against an explicit unbind of caam_jr, that path =0A=
doesn't care about device reference counts. For example on imx6qp:=0A=
=0A=
# echo 2102000.jr1 > /sys/bus/platform/drivers/caam_jr/unbind=0A=
=0A=
CPU: 2 PID: 561 Comm: bash Not tainted 5.3.0-rc7-next-20190904=0A=
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)=0A=
Backtrace:=0A=
[<c010f8a4>] (dump_backtrace) from [<c010fc5c>] (show_stack+0x20/0x24)=0A=
[<c010fc3c>] (show_stack) from [<c0d21600>] (dump_stack+0xdc/0x114)=0A=
[<c0d21524>] (dump_stack) from [<c0955774>] (caam_jr_remove+0x24/0xf8)=0A=
[<c0955750>] (caam_jr_remove) from [<c06e2d98>] =0A=
(platform_drv_remove+0x34/0x4c)=0A=
[<c06e2d64>] (platform_drv_remove) from [<c06e0b74>] =0A=
(device_release_driver_internal+0xf8/0x1b0)=0A=
[<c06e0a7c>] (device_release_driver_internal) from [<c06e0c70>] =0A=
(device_driver_detach+0x20/0x24)=0A=
[<c06e0c50>] (device_driver_detach) from [<c06de5a4>] =0A=
(unbind_store+0x6c/0xe0)=0A=
[<c06de538>] (unbind_store) from [<c06dd950>] (drv_attr_store+0x30/0x3c)=0A=
[<c06dd920>] (drv_attr_store) from [<c0364c18>] (sysfs_kf_write+0x50/0x5c)=
=0A=
[<c0364bc8>] (sysfs_kf_write) from [<c0363e0c>] =0A=
(kernfs_fop_write+0x10c/0x1f8)=0A=
[<c0363d00>] (kernfs_fop_write) from [<c02c3a30>] (__vfs_write+0x44/0x1d0)=
=0A=
[<c02c39ec>] (__vfs_write) from [<c02c68ec>] (vfs_write+0xb0/0x194)=0A=
[<c02c683c>] (vfs_write) from [<c02c6b7c>] (ksys_write+0x64/0xd8)=0A=
[<c02c6b18>] (ksys_write) from [<c02c6c08>] (sys_write+0x18/0x1c)=0A=
[<c02c6bf0>] (sys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)=0A=
=0A=
I think you need to do some form of slow wait loop in jrpriv until =0A=
jrpriv->tfm_count reaches zero. Preventing new operations from starting =0A=
would help but isn't strictly necessary for correctness.=0A=
=0A=
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
> index 47b389cb1c62..8a30bbd7f2aa 100644=0A=
> --- a/drivers/crypto/caam/jr.c=0A=
> +++ b/drivers/crypto/caam/jr.c=0A=
> @@ -124,14 +124,6 @@ static int caam_jr_remove(struct platform_device *pd=
ev)=0A=
>   	jrdev =3D &pdev->dev;=0A=
>   	jrpriv =3D dev_get_drvdata(jrdev);=0A=
>   =0A=
> -	/*=0A=
> -	 * Return EBUSY if job ring already allocated.=0A=
> -	 */=0A=
> -	if (atomic_read(&jrpriv->tfm_count)) {=0A=
> -		dev_err(jrdev, "Device is busy\n");=0A=
> -		return -EBUSY;=0A=
> -	}=0A=
> -=0A=
>   	/* Unregister JR-based RNG & crypto algorithms */=0A=
>   	unregister_algs();=0A=
>   =0A=
> @@ -300,7 +292,7 @@ struct device *caam_jr_alloc(void)=0A=
>   =0A=
>   	if (min_jrpriv) {=0A=
>   		atomic_inc(&min_jrpriv->tfm_count);=0A=
> -		dev =3D min_jrpriv->dev;=0A=
> +		dev =3D get_device(min_jrpriv->dev);=0A=
>   	}=0A=
>   	spin_unlock(&driver_data.jr_alloc_lock);=0A=
>   =0A=
> @@ -318,13 +310,16 @@ void caam_jr_free(struct device *rdev)=0A=
>   	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(rdev);=0A=
>   =0A=
>   	atomic_dec(&jrpriv->tfm_count);=0A=
> +	put_device(rdev);=0A=
>   }=0A=
>   EXPORT_SYMBOL(caam_jr_free);=0A=
>   =0A=
>   /**=0A=
>    * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,=
=0A=
>    * -EBUSY if the queue is full, -EIO if it cannot map the caller's=0A=
> - * descriptor.=0A=
> + * descriptor, -ENODEV if given device was removed and is no longer=0A=
> + * valid=0A=
> + *=0A=
>    * @dev:  device of the job ring to be used. This device should have=0A=
>    *        been assigned prior by caam_jr_register().=0A=
>    * @desc: points to a job descriptor that execute our request. All=0A=
> @@ -354,15 +349,32 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=
=0A=
>   				u32 status, void *areq),=0A=
>   		    void *areq)=0A=
>   {=0A=
> -	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(dev);=0A=
> +	struct caam_drv_private_jr *jrp;=0A=
>   	struct caam_jrentry_info *head_entry;=0A=
>   	int head, tail, desc_size;=0A=
>   	dma_addr_t desc_dma;=0A=
>   =0A=
> +	/*=0A=
> +	 * Lock the device to prevent it from being removed while we=0A=
> +	 * are using it=0A=
> +	 */=0A=
> +	device_lock(dev);=0A=
> +=0A=
> +	/*=0A=
> +	 * If driver data is NULL, it is very likely that this device=0A=
> +	 * was removed already. Nothing we can do here but bail out.=0A=
> +	 */=0A=
> +	jrp =3D dev_get_drvdata(dev);=0A=
> +	if (!jrp) {=0A=
> +		device_unlock(dev);=0A=
> +		return -ENODEV;=0A=
> +	}=0A=
> +=0A=
>   	desc_size =3D (caam32_to_cpu(*desc) & HDR_JD_LENGTH_MASK) * sizeof(u32=
);=0A=
>   	desc_dma =3D dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);=0A=
>   	if (dma_mapping_error(dev, desc_dma)) {=0A=
>   		dev_err(dev, "caam_jr_enqueue(): can't map jobdesc\n");=0A=
> +		device_unlock(dev);=0A=
>   		return -EIO;=0A=
>   	}=0A=
>   =0A=
> @@ -375,6 +387,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=0A=
>   	    CIRC_SPACE(head, tail, JOBR_DEPTH) <=3D 0) {=0A=
>   		spin_unlock_bh(&jrp->inplock);=0A=
>   		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);=0A=
> +		device_unlock(dev);=0A=
>   		return -EBUSY;=0A=
>   	}=0A=
>   =0A=
> @@ -411,6 +424,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,=0A=
>   		jrp->inpring_avail =3D rd_reg32(&jrp->rregs->inpring_avail);=0A=
>   =0A=
>   	spin_unlock_bh(&jrp->inplock);=0A=
> +	device_unlock(dev);=0A=
>   =0A=
>   	return 0;=0A=
>   }=0A=
