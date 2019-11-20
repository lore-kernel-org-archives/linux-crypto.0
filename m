Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9C1C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0AFA206D8
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 06:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="XaW2diUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfKTGmD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 01:42:03 -0500
Received: from mail-eopbgr730048.outbound.protection.outlook.com ([40.107.73.48]:25184
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfKTGmD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 01:42:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI3g3FEhQzobhriXqPmfEd+XR4h8eoNY96NEoFRP4kh98vfjlXZMoAHqL6KITcjZDvOg/TU+IQH6/M+cRK+kkMXB5GVmYsWsVclmcc5ik6kMg4sFOMhWCQy1pl2C4lQDji2R5V1V+G6jhlvwWUnrOt3ex2GTPUzZT+bwjkXWy4cV3S3TDs1kJz1w39uRSAH3JH3eqyv5lGebUOYrxIiFMbAMwZXKNcT3q+q5wCJx1r7R5fp26+l7ZkA1GuXhHE1szYYYMIJ31cySPKnkIBGRncyo9vEF2nwN3XNciGZBv7FEkMz+OqrPA2M7WHlI2VgeYt9R1MkazOZr/swjI4AC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHgGfBnnllEy5gAS/dbz0w+z3jCOe+FzVj+5iTgo83Y=;
 b=KXumvDDY8RJFjLqNxXH/OrSf1eCSkEYzlt3Z5agXaZzEtkLz64dTUxGs/gq0BLWTN3lBHmkMhEBSugGvF7ZMyM2/E5sPd6ywbBIO82dyygoWoPPR1Jzs8aYQ2RL2gXP4y9Kt1OqA8qoWxyc6jAkzfyS1d/seceOCtJH22nCQJGWo2fCehB952Cf/Y14mSYINJ8oJd/BNhYwb+Ldfagg/7P2Q8YjMC4gnaKh3/Nw0ir/toIemPAwFuFU7wAqczxUuBe8h1aNSwyvoLciDnLPlP3ANxV+VtpbdSUXhZqNm9gL/Mgf/GFdEOc+dXrPMwi038d5iWOMlweu+8cZOfSc5aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHgGfBnnllEy5gAS/dbz0w+z3jCOe+FzVj+5iTgo83Y=;
 b=XaW2diUUrBDABmzK9cyWnCn0YP1L+CWGn9T3Xin2BaqZFLScb4hdDp+aYha/NScT90EDphaCmBLuQ8fA6UuscQLOtxe0yZ5x/2QQeiwOxmvdPAXf+TvvAxXNSjjTybteAHK9B3jyVu7hzCCCGtpYDgt+quzzRwvimSPtiWl0yck=
Received: from SN6PR02MB5135.namprd02.prod.outlook.com (52.135.99.152) by
 SN6PR02MB4223.namprd02.prod.outlook.com (52.135.71.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Wed, 20 Nov 2019 06:41:59 +0000
Received: from SN6PR02MB5135.namprd02.prod.outlook.com
 ([fe80::bc55:5260:caaa:6043]) by SN6PR02MB5135.namprd02.prod.outlook.com
 ([fe80::bc55:5260:caaa:6043%6]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 06:41:59 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
Subject: RE: [PATCH V3 4/4] crypto: Add Xilinx AES driver
Thread-Topic: [PATCH V3 4/4] crypto: Add Xilinx AES driver
Thread-Index: AQHVlJdPZqOBmIFx+0erb8mfNok4M6eMO+GAgAdzZcA=
Date:   Wed, 20 Nov 2019 06:41:58 +0000
Message-ID: <SN6PR02MB5135492A38B7B2302D6AC8BDAF4F0@SN6PR02MB5135.namprd02.prod.outlook.com>
References: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
 <1573040435-6932-5-git-send-email-kalyani.akula@xilinx.com>
 <20191115124517.GA31038@Red>
In-Reply-To: <20191115124517.GA31038@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45dba63f-92c9-40b4-77bf-08d76d84be52
x-ms-traffictypediagnostic: SN6PR02MB4223:|SN6PR02MB4223:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR02MB42234E2D1F4C435129C00315AF4F0@SN6PR02MB4223.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(13464003)(51914003)(189003)(199004)(186003)(5660300002)(25786009)(3846002)(26005)(6506007)(53546011)(71200400001)(14454004)(7736002)(6246003)(66446008)(86362001)(81156014)(55016002)(9686003)(6916009)(102836004)(66946007)(66556008)(64756008)(66476007)(99286004)(52536014)(2906002)(6116002)(305945005)(8936002)(229853002)(71190400001)(6436002)(76176011)(7696005)(54906003)(4326008)(8676002)(316002)(107886003)(66066001)(446003)(476003)(11346002)(76116006)(486006)(256004)(14444005)(74316002)(478600001)(33656002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4223;H:SN6PR02MB5135.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iG4lvW6Bx+/rzCjqheIMhgy5aABrsv4GgQyIwt8upKk24QwKwsW07LlTgdQ+5qTCR1+8iXIjv34Tg9a+WS2EL9a/yHDUxtswclSoJm3WdVxmUv7Ttw1rIwp5LqzPmAEXwIWBN3HpZLmTYMjtUmPKEveIO00FR7cWajHJenqfeu+anauctNkNOVDI3012GfVK1R6VXjpfbs5Axv/TfeFmPCGzBfTaWFWz9nkJqtrQwDEwFrlPPjE21mz1Z2rpFyVwC6tTjmuswl43Tg+sQJ348UUq0bnghqAfE+M8IRTIk28quipgw2EZztRbcLhfnHzWaF6p73sYfIXjVSwKUvrqFyKXzBo8Zdo7IKIiSfCqNF6UJRegOooF5TY46BbqCweQ+W+CcZVtHeLEMqWdR+j5h7JgF+rjZ4Rf40/DrAoCrlJj/xBIfBc8PirszcUh3Fzo
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dba63f-92c9-40b4-77bf-08d76d84be52
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 06:41:58.9852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IaZofMVPqPMD87AhJX5onNaSFdD68jn6/eR8vbxQAgA9larXVFf23lvaF8JnTwDfD3t84QpEbbkQsHSl+O+wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4223
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

Thanks for the review. Please find my response inline.


> -----Original Message-----
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Sent: Friday, November 15, 2019 6:15 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Kalyani
> Akula <kalyania@xilinx.com>; Harsh Jain <harshj@xilinx.com>; Sarat Chand
> Savitala <saratcha@xilinx.com>; Mohan Marutirao Dhanawade
> <mohand@xilinx.com>
> Subject: Re: [PATCH V3 4/4] crypto: Add Xilinx AES driver
>=20
> On Wed, Nov 06, 2019 at 05:10:35PM +0530, Kalyani Akula wrote:
> > This patch adds AES driver support for the Xilinx ZynqMP SoC.
> >
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> > ---
> >  drivers/crypto/Kconfig                 |  11 +
> >  drivers/crypto/Makefile                |   2 +
> >  drivers/crypto/xilinx/Makefile         |   3 +
> >  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 457
> > +++++++++++++++++++++++++++++++++
> >  4 files changed, 473 insertions(+)
> >  create mode 100644 drivers/crypto/xilinx/Makefile  create mode 100644
> > drivers/crypto/xilinx/zynqmp-aes-gcm.c
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig index
> > 1fb622f..8e7d3a9 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -696,6 +696,17 @@ config CRYPTO_DEV_ROCKCHIP
> >  	help
> >  	  This driver interfaces with the hardware crypto accelerator.
> >  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher
> mode.
> > +config CRYPTO_DEV_ZYNQMP_AES
> > +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> > +	depends on ARCH_ZYNQMP || COMPILE_TEST
> > +	select CRYPTO_AES
> > +	select CRYPTO_ENGINE
> > +	select CRYPTO_AEAD
> > +	help
> > +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> > +	  encryption and decryption. This driver interfaces with AES hw
> > +	  accelerator. Select this if you want to use the ZynqMP module
> > +	  for AES algorithms.
> >
> >  config CRYPTO_DEV_MEDIATEK
> >  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
> > diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile index
> > afc4753..b6124b8 100644
> > --- a/drivers/crypto/Makefile
> > +++ b/drivers/crypto/Makefile
> > @@ -47,4 +47,6 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) +=3D vmx/
> >  obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) +=3D bcm/
> >  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) +=3D inside-secure/
> >  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) +=3D axis/
> > +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) +=3D xilinx/
> > +
>=20
> Hello
>=20
> you insert a useless newline

Will fix it.

>=20
> [...]
> > +static int zynqmp_handle_aes_req(struct crypto_engine *engine,
> > +				 void *req)
> > +{
> > +	struct aead_request *areq =3D
> > +				container_of(req, struct aead_request,
> base);
> > +	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> > +	struct zynqmp_aead_tfm_ctx *tfm_ctx =3D crypto_aead_ctx(aead);
> > +	struct zynqmp_aead_req_ctx *rq_ctx =3D aead_request_ctx(areq);
> > +	struct aead_request *subreq;
> > +	int need_fallback;
> > +	int err;
> > +
> > +	need_fallback =3D zynqmp_fallback_check(tfm_ctx, areq);
> > +
> > +	if (need_fallback) {
> > +		subreq =3D aead_request_alloc(tfm_ctx->fbk_cipher,
> GFP_KERNEL);
> > +		if (!subreq)
> > +			return -ENOMEM;
> > +
> > +		aead_request_set_callback(subreq, areq->base.flags,
> > +					  NULL, NULL);
> > +		aead_request_set_crypt(subreq, areq->src, areq->dst,
> > +				       areq->cryptlen, areq->iv);
> > +		aead_request_set_ad(subreq, areq->assoclen);
> > +		if (rq_ctx->op =3D=3D ZYNQMP_AES_ENCRYPT)
> > +			err =3D crypto_aead_encrypt(subreq);
> > +		else
> > +			err =3D crypto_aead_decrypt(subreq);
> > +		aead_request_free(subreq);
>=20
> Every other crypto driver which use async fallback does not use
> aead_request_free() (and do not allocate a new request).
> I am puzzled that you can free an async request without waiting for its
> completion.
> Perhaps I am wrong, but since no other driver do like that...

Thanks for pointing out. I will make sure I don't allocate the new request =
by adjusting the aead_req_size in init API.

>=20
> [...]
> > +static int zynqmp_aes_aead_probe(struct platform_device *pdev) {
> > +	struct device *dev =3D &pdev->dev;
> > +	int err =3D -1;
> > +
> > +	if (!pdev->dev.of_node)
> > +		return -ENODEV;
> > +
> > +	aes_drv_ctx.dev =3D dev;
>=20
> You should test if dev is not already set.
> And add a comment like "this driver support only one instance".

Will fix it

>=20
> > +	aes_drv_ctx.eemi_ops =3D zynqmp_pm_get_eemi_ops();
> > +	if (IS_ERR(aes_drv_ctx.eemi_ops)) {
> > +		dev_err(dev, "Failed to get ZynqMP EEMI interface\n");
> > +		return PTR_ERR(aes_drv_ctx.eemi_ops);
> > +	}
> > +
> > +	err =3D dma_set_mask_and_coherent(dev,
> DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
> > +	if (err < 0) {
> > +		dev_err(dev, "No usable DMA configuration\n");
> > +		return err;
> > +	}
> > +
> > +	aes_drv_ctx.engine =3D crypto_engine_alloc_init(dev, 1);
> > +	if (!aes_drv_ctx.engine) {
> > +		dev_err(dev, "Cannot alloc AES engine\n");
> > +		return err;
> > +	}
> > +
> > +	err =3D crypto_engine_start(aes_drv_ctx.engine);
> > +	if (err) {
> > +		dev_err(dev, "Cannot start AES engine\n");
> > +		return err;
> > +	}
> > +
> > +	err =3D crypto_register_aead(&aes_drv_ctx.alg.aead);
> > +	if (err < 0)
> > +		dev_err(dev, "Failed to register AEAD alg.\n");
>=20
> In case of error you didnt crypto_engine_exit()

I will fix it.

>=20
> Regards
