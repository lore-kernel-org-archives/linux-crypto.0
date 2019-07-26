Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C90EC76191
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA57721901
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qsKKrKxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfGZPEU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:04:20 -0400
Received: from mail-eopbgr50048.outbound.protection.outlook.com ([40.107.5.48]:49805
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727353AbfGZPEU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+psOjGiPHXW0s9kZgcGbkP60Ca2lIysmxrLe2u+2K6qLBxuZPy0IZtDPigyUorwcuMriDF+MRdjAkV84RfkqljAQvzUfg8sP7JWNWI8zLbzDgxtg3g4DzpOe6NiFHmWrJHf5oJcJwIIOD9qhwIAWS/kNKnKl8w/MkB7EMRLIA0e4me1oPK2Lrj+1Sl2LK17ujvt9EogHb1je9WCTGRtWtm/hpg0+FOGu1ti5TfaeT6yzJUrh+NdIhaE+mNb/Dkw8NlwhtNuBKIvb4hDRY1PKWYbBtzNFW5Fq2na/9Ht/Bed92NsGtqHHV3ktQa8jZwJZ8JPUtX7ZG1vr8HTVu3H0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43YXod2O3iV908iaNSdsdmohWAooGNc78354QQ6Q+5Q=;
 b=LWy3p9K1WCTUMuLgILAXHV2PJDU/OyjjDNG3qXCqVth/OvhgDjlMEBYddbvaXnvAU/BV05LJKK9L59RtDOEmSuVTaZ1EEAk6jih7kO6zJyM6iWtALkngYEU3rboa73WCcLKNEaJDZH0q9+46tfBb82FNIedVp9ZqM1HS6AFUP4CLMvLgktMnJLdKjfTBJaQwmLRr14ubzMCWs4TCtVBLumhDaFjlfuVR6mn5Xdian42D02C98125WcF7X8jIPgXEtizo1e9uWhueuvs5GjZNecwD7Xx00bZEXIASRHR45YQPe3yNHoc1sOYJAB4uhjvGy4wYolTHRf0kbO+Tg3h5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43YXod2O3iV908iaNSdsdmohWAooGNc78354QQ6Q+5Q=;
 b=qsKKrKxEe3wxBZmsQauRbJD1xgwxvF84KX3/mecOFzH3zZr8pboE3+4/h4Q/m2Dd1uCL6uIPl/nGptv33/wyAH3V7wZu3osyTTVYb31lMgsUB0cKp5UT/SPC7uR3qY9ThsK8/5K61v0ndgGEiSAJeFnIpjM2gEvuw6dMgsZgec0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3837.eurprd04.prod.outlook.com (52.134.16.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 15:04:14 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:04:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 10/14] crypto: caam - fix MDHA key derivation for
 certain user key lengths
Thread-Topic: [PATCH v3 10/14] crypto: caam - fix MDHA key derivation for
 certain user key lengths
Thread-Index: AQHVQvEQ8S5ZgmW6u06kgrYkZT+jBg==
Date:   Fri, 26 Jul 2019 15:04:14 +0000
Message-ID: <VI1PR0402MB34854EC43A55241885C7C87598C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-11-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea971012-6e48-43ff-f08f-08d711da85fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3837;
x-ms-traffictypediagnostic: VI1PR0402MB3837:
x-microsoft-antispam-prvs: <VI1PR0402MB383748CFE97A2B6A503AD30698C00@VI1PR0402MB3837.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(54534003)(199004)(189003)(81156014)(64756008)(55016002)(76176011)(478600001)(6436002)(7696005)(25786009)(6636002)(9686003)(52536014)(54906003)(66066001)(53936002)(14454004)(66556008)(5660300002)(6246003)(66446008)(91956017)(229853002)(86362001)(66476007)(26005)(76116006)(102836004)(2906002)(8936002)(316002)(7736002)(110136005)(8676002)(74316002)(71200400001)(66946007)(4326008)(71190400001)(305945005)(81166006)(53546011)(256004)(6506007)(476003)(186003)(3846002)(44832011)(33656002)(68736007)(99286004)(486006)(446003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3837;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jL5Ey8tEZdA0xxR7ln3Fo/FjXqZ+DUvtl82va/r7oR72IHSwog5H7eeY5c0fzdo1M3zd5GkHmFz3y4hA77x0vJUR4KiYmXi1ztirR/xpyL0I/3bgkhvHk1+lZuXE7iMgX7HWQeiCx7pdnPMG6Aq5ArjlYEZitnibImSR2iuSPQ120FKSL9/w3e6FLEAmdBDWcECX3uWSPGYfeWQYY6Dlbu++KFw6rjzSYQrdjQVsmqx30L6+Lo5Pi/liLcdE/bE3QrvxMZIrMYyRU0Pf2siqupkCZnR+FaT00mcj9MB98/rOCQV416/USSppfd5Au53Q0z9hDEN3UJVQstj26DInDKRe9kAr8lKI1yhp69udBR7x951IaDIfVfGbZ49VsFxXq0yhxrjNGSIHxXBzz+shxVoTm6x/EnvEtTt/ZIWZNIU=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea971012-6e48-43ff-f08f-08d711da85fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:04:14.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> From: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Fuzz testing uncovered an issue when |user key| > |derived key|.=0A=
> Derived key generation has to be fixed in two cases:=0A=
> =0A=
> 1. Era >=3D 6 (DKP is available)=0A=
> DKP cannot be used with immediate input key if |user key| > |derived key|=
,=0A=
> since the resulting descriptor (after DKP execution) would be invalid -=
=0A=
> having a few bytes from user key left in descriptor buffer=0A=
> as incorrect opcodes.=0A=
> =0A=
> Fix DKP usage both in standalone hmac and in authenc algorithms.=0A=
> For authenc the logic is simplified, by always storing both virtual=0A=
> and dma key addresses.=0A=
> =0A=
> 2. Era < 6=0A=
> The same case (|user key| > |derived key|) fails when DKP=0A=
> is not available.=0A=
> Make sure gen_split_key() dma maps max(|user key|, |derived key|),=0A=
> since this is an in-place (bidirectional) operation.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Changes since v2:=0A=
> - fix MDHA key derivation for CAAM with era < 6.=0A=
> ---=0A=
The change log shouldn't be included in the commit message.=0A=
=0A=
Horia=0A=
