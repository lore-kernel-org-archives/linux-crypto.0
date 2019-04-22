Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E31C282E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 06:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C42F20811
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 06:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="Zzu3exlB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfDVGrU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 02:47:20 -0400
Received: from mail-eopbgr690051.outbound.protection.outlook.com ([40.107.69.51]:48581
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbfDVGrU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 02:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0MB3N7p83WvuvKl3NRmiWRXsxO5i5iFks5vi7jRXkk=;
 b=Zzu3exlBlEht90gSmmWUmxvSgvf/tKN0HhcTBKaH3/ufB4CkimFmbZY8XaMoinp9amgmMUcUq+opPBQBfLJsTCK5CgGou1AmI9wjqOahJm2VRsK2NQupxyrsS1I0WlEM5ry7svIfM5gpRWwaJgFju/HXl8XPm5s+nH6cTc3u0ME=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.26.153) by
 BN7PR02MB4180.namprd02.prod.outlook.com (52.133.220.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Mon, 22 Apr 2019 06:47:15 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::fc20:6339:ab53:378e]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::fc20:6339:ab53:378e%2]) with mapi id 15.20.1813.017; Mon, 22 Apr 2019
 06:47:15 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH V2 3/4] crypto: Add Xilinx SHA3 driver
Thread-Topic: [RFC PATCH V2 3/4] crypto: Add Xilinx SHA3 driver
Thread-Index: AQHUp/1sQxJENQki50GijbSiY6ngFqWoiP+AgJ+wkOA=
Date:   Mon, 22 Apr 2019 06:47:15 +0000
Message-ID: <BN7PR02MB51247DEF73128E41B3754EB0AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
 <1547025985-7228-4-git-send-email-kalyani.akula@xilinx.com>
 <20190110135757.GA32218@Red>
In-Reply-To: <20190110135757.GA32218@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 116028e1-66e2-47d0-552f-08d6c6ee5b25
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN7PR02MB4180;
x-ms-traffictypediagnostic: BN7PR02MB4180:
x-microsoft-antispam-prvs: <BN7PR02MB4180617BBC35A3C5609E4C6FAF220@BN7PR02MB4180.namprd02.prod.outlook.com>
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(376002)(346002)(396003)(52314003)(13464003)(189003)(199004)(76116006)(66476007)(66556008)(73956011)(66946007)(66446008)(9686003)(14444005)(6916009)(305945005)(446003)(68736007)(256004)(64756008)(486006)(11346002)(476003)(2906002)(8676002)(76176011)(74316002)(229853002)(55016002)(25786009)(6506007)(81166006)(54906003)(52536014)(7736002)(97736004)(6116002)(3846002)(316002)(8936002)(478600001)(71190400001)(6246003)(99286004)(5660300002)(26005)(53546011)(71200400001)(14454004)(33656002)(86362001)(102836004)(7696005)(81156014)(66066001)(4326008)(186003)(53936002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB4180;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6ZxFVvU6lRQfZRdqYHpQTSrNRkLHqh79gB00IBESlmgdCoE01z4riohNXoK6x2uYYO2TaI50ekROq4F84OTKGvM1kh8hdmcpF1Jjb+WYlaolo/WRsTHCgcuJK7BMkjanWK5eiJlau5+HYNs9NoRuNMbsOxsqIg3bMNsmp2oAFkIVpIrKJu6HJsQi2X8DCoqi+M0TgRmTyf8pxHMXNhjIPv1F2NdX4b5/33IsmZW3/XmkNgvjyGq2xnpoJQk2hvhLvZ9y9i07jSD/dppv5G6yku3l8Uli7FN1Sh8XcGtaCfyt/+tGGzEHymxM1Jed1ep6jhgsN27I42Z+2/+KV/fE1eyky6S291kXrTcQFoZF/ree2v9e3g/lGZpQJ9wJ5Uv3+d91LsyanpsWxEj0ROgH6HUAnbSx8wK6Nq2MW/yO3IA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116028e1-66e2-47d0-552f-08d6c6ee5b25
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 06:47:15.2162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

Sorry for the delayed response.
Please find my responses inline.

> -----Original Message-----
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Sent: Thursday, January 10, 2019 7:28 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Kalyani Akula
> <kalyania@xilinx.com>; Sarat Chand Savitala <saratcha@xilinx.com>
> Subject: Re: [RFC PATCH V2 3/4] crypto: Add Xilinx SHA3 driver
>=20
> On Wed, Jan 09, 2019 at 02:56:24PM +0530, Kalyani Akula wrote:
> > This patch adds SHA3 driver support for the Xilinx ZynqMP SoC.
> >
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> > ---
> >  drivers/crypto/Kconfig      |   10 ++
> >  drivers/crypto/Makefile     |    1 +
> >  drivers/crypto/zynqmp-sha.c |  305
> > +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 316 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/crypto/zynqmp-sha.c
>=20
> Hello
>=20
> I have some comment below
>=20
> > +static int zynqmp_sha_update(struct ahash_request *req) {
> > +	const struct zynqmp_eemi_ops *eemi_ops =3D
> zynqmp_pm_get_eemi_ops();
> > +	struct zynqmp_sha_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> > +	struct zynqmp_sha_dev *dd =3D tctx->dd;
> > +	size_t dma_size =3D req->nbytes;
> > +	dma_addr_t dma_addr;
> > +	char *kbuf;
> > +	int ret;
> > +
> > +	if (!req->nbytes)
> > +		return 0;
> > +
> > +	if (!eemi_ops || !eemi_ops->sha_hash)
> > +		return -ENOTSUPP;
> > +
> > +	kbuf =3D dma_alloc_coherent(dd->dev, dma_size, &dma_addr,
> GFP_KERNEL);
> > +	if (!kbuf)
> > +		return -ENOMEM;
> > +
> > +	scatterwalk_map_and_copy(kbuf, req->src, 0, req->nbytes, 0);
> > +	 __flush_cache_user_range((unsigned long)kbuf,
> > +				  (unsigned long)kbuf + dma_size);
>=20
> Since kbuf is in dma coherent memory, I dont understand why do you flush
> cache.
[kalyani] Agree, not required will fix in next version.
>=20
> > +	ret =3D eemi_ops->sha_hash(dma_addr, req->nbytes,
> ZYNQMP_SHA3_UPDATE);
> > +	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
>=20
> Since your update function does not return/write any result, I suppose th=
at
> the resulat is kept in hardware, so what happen if two hash process happe=
n
> in parallel ?
[kalyani] yes, the result will be stored in SHA3 engine.
Firmware don't have the support to process 2 hash requests in parallel usin=
g IPI
> Furthermore, how do you have tested import/export function ?
> Anyway, I am sure they are totally buggy.
>=20
[kalyani] I will verify and fix in the next version
> > +
> > +	return ret;
> > +}
> > +
> > +static int zynqmp_sha_final(struct ahash_request *req) {
> > +	const struct zynqmp_eemi_ops *eemi_ops =3D
> zynqmp_pm_get_eemi_ops();
> > +	struct zynqmp_sha_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> > +	struct zynqmp_sha_dev *dd =3D tctx->dd;
> > +	size_t dma_size =3D SHA384_DIGEST_SIZE;
> > +	dma_addr_t dma_addr;
> > +	char *kbuf;
> > +	int ret;
> > +
> > +	if (!eemi_ops || !eemi_ops->sha_hash)
> > +		return -ENOTSUPP;
>=20
> You can do this check at probe time.
[kalyani] Yes, will fix in next version
>=20
> > +static int zynqmp_sha_finup(struct ahash_request *req) {
> > +	zynqmp_sha_update(req);
> > +	zynqmp_sha_final(req);
> > +
> > +	return 0;
> > +}
> > +
> > +static int zynqmp_sha_digest(struct ahash_request *req) {
> > +	zynqmp_sha_init(req);
> > +	zynqmp_sha_update(req);
> > +	zynqmp_sha_final(req);
> > +
> > +	return 0;
> > +}
>=20
> So you ignore the return value of
> zynqmp_sha_init/zynqmp_sha_update/zynqmp_sha_final().
>=20
> > +static int zynqmp_sha_probe(struct platform_device *pdev) {
> > +	struct zynqmp_sha_dev *sha_dd;
> > +	struct device *dev =3D &pdev->dev;
> > +	int err;
> > +
> > +	sha_dd =3D devm_kzalloc(&pdev->dev, sizeof(*sha_dd),
> GFP_KERNEL);
> > +	if (!sha_dd)
> > +		return -ENOMEM;
> > +
> > +	sha_dd->dev =3D dev;
> > +	platform_set_drvdata(pdev, sha_dd);
> > +	INIT_LIST_HEAD(&sha_dd->list);
> > +	spin_lock_init(&sha_dd->lock);
> > +	crypto_init_queue(&sha_dd->queue,
> ZYNQMP_SHA_QUEUE_LENGTH);
>=20
> As already said in my last review, why init the queue if you do not use i=
t ?
>=20
>=20
> > +	spin_lock(&zynqmp_sha.lock);
> > +	list_add_tail(&sha_dd->list, &zynqmp_sha.dev_list);
> > +	spin_unlock(&zynqmp_sha.lock);
>=20
> Why do you maintain a device list ?
> Clearly your current driver support only one hardware instance.
[kalyani] True, driver support only one HW instance , will fix in the next =
version

Regards,
kalyani
>=20
> Regards
