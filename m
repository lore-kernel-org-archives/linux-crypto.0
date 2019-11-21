Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B13C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 11:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DD7E20898
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 11:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="AW1/qzvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKULqw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:46:52 -0500
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:53633
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfKULqw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 06:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMt67cCD8xD7/DaSFMZJRG2JYGDeDvHD2X2v6MdwHrYrM0pzyXx+UqeFgz/iyW4Gn0OecW672uWgsKiDpgRcEDVO9VQbLAh3CASyfVs87pUdxjPzuwvZEEDCiddsFLQfBujGPgyH2+cakV/Wz+V0/1qyN0EthHdEQyO2Inw2aWMb/AWoJsJ8RVMcuKkUha6jsy5zbhG6GnEN15lAUwpeCF+iK9jwJ0NAsknc1ubsF9tvOewKqJT126q1i5Axt7Y4Y80gUyt7aR5uQBdg++1kba7v8tjR2VjJSjrtACdO+QJMbmy7srGn8cgbpylDflWPu+P1X0xLL36GzIM8IVNkLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgY5mZjRjeSDVoveeMOche4ACBSsFRBpv8GIGI5o/Tc=;
 b=TbHRdiqAok6EbaSSLHtue9GhxbywaYBsPsj8ctPoFgJPAXU0VGZ9R9xe6oRIPnwkbP1UNlelIqNJJCqniyUmbLKm81GtLjgBE6nR51pL/zx4KuJyta+3vNktz20J7aqVxwvNul50FNmZEXHWhLUSEWn58AygEXM3uh0oq0bf3bgTQ2T0Njeb+VSgZkXstR1Xqi5SOv2MmpSruaOeEM4QKV1K1Y1J0VvlROtOUVTVkksmhTE9ogh7NsFtXCM0najubFIHaZpAS0x4/zPEJdXxZjIIArwY9QHy8ctiC83AIOJJNQQYzu27+wMGXL0A7aTb5OPTBRGXKiVUjQG/kOcGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgY5mZjRjeSDVoveeMOche4ACBSsFRBpv8GIGI5o/Tc=;
 b=AW1/qzvRhY4FOrE1ORGbFMJla67WJ6g3dYeR6ysAoJl78E8GsdpbrdpzqXBZaZ661x4ZxOvodFAj0ZmuMeOm8IhTAHBZCfI8cONPPkl52sAEPoTWz+5N/GiAdVPHORDHncpJX6eeJmDWLogRSMwdJewVLUdx3HcdqdYlD9VG23U=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2864.eurprd04.prod.outlook.com (10.175.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 21 Nov 2019 11:46:48 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::89e1:552e:a24d:e72%3]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 11:46:47 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Topic: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Thread-Index: AQHVnZa0rM7CL6wAt0ms3oYdwTAojA==
Date:   Thu, 21 Nov 2019 11:46:47 +0000
Message-ID: <VI1PR0402MB34855B1302CB4C43A8DB8A43984E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a5e0b25-dd55-4dba-66ac-08d76e787daf
x-ms-traffictypediagnostic: VI1PR0402MB2864:|VI1PR0402MB2864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28643EC61A8CA89C59CEA082984E0@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(199004)(189003)(51234002)(316002)(4744005)(305945005)(66946007)(14454004)(110136005)(3846002)(6116002)(2906002)(6436002)(7696005)(7736002)(54906003)(74316002)(186003)(8936002)(478600001)(76176011)(229853002)(25786009)(102836004)(55016002)(53546011)(6506007)(9686003)(256004)(64756008)(66556008)(4326008)(66476007)(99286004)(66446008)(6636002)(33656002)(5660300002)(8676002)(446003)(81166006)(14444005)(91956017)(76116006)(86362001)(71200400001)(81156014)(66066001)(26005)(52536014)(6246003)(71190400001)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2864;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+cKXyX/GHkNWT3ZRwQrfubNd27VXLbsWD4M/X34MFEyjUtAG+9GMGPQBkVHlDKnYqTNb6HUW+kbIKg5jiBjnbP4gOksYwl0MI7e32BOOAw0Rq7PJa6UvdqAoyfWurwgeE9WPHTOHqtzgIfA3caqz2xloulKBY5QKQNIM3rBYvQmurLfys7FBmFQy6b7fVQvGIICCGa2XcbZJatZ4+loSIGmibRmbb/0les1pdxmqz0lKabehpwKFOKvB4wrarxq+oT9n4vVB/xEwEVYG5XIHDkDMwNQoilYd0CZysend2nphJcWtQegqyuRy0cG5wXLCaWPz3wIKSDBHMLLBfELGks1gGpu5P30ltOqNqHxRqMlzoX0p6qxujcsHZYv/7ryR+KAHUIRZLnK7YRE/QkGmHfxq9o3IcmQqXg30EUT+D/aPcJwXhHuHd9I1aumXCcwMV+dlr+yDg/NN/l+WKLUbg==
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5e0b25-dd55-4dba-66ac-08d76e787daf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 11:46:47.8083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Adb5zUatkp7vEnW5b2DjFQss6vsvhMPa+r2uL7njEJqYF0/njTVLipeA4nCUr7HaR7n8FCGfr+fJ8/4Fh+rFAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/18/2019 12:31 AM, Iuliana Prodan wrote:=0A=
> Integrate crypto_engine into CAAM, to make use of the engine queue.=0A=
> Add support for SKCIPHER algorithms.=0A=
> =0A=
> This is intended to be used for CAAM backlogging support.=0A=
> The requests, with backlog flag (e.g. from dm-crypt) will be listed=0A=
> into crypto-engine queue and processed by CAAM when free.=0A=
> This changes the return codes for caam_jr_enqueue:=0A=
> -EINPROGRESS if OK, -EBUSY if request is backlogged,=0A=
> -ENOSPC if the queue is full, -EIO if it cannot map the caller's=0A=
> descriptor, -EINVAL if crypto_tfm not supported by crypto_engine.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
