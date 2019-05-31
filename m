Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFC0C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 448A426A5D
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kkbw5S7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEaOVp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 10:21:45 -0400
Received: from mail-eopbgr30056.outbound.protection.outlook.com ([40.107.3.56]:5607
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfEaOVp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 10:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5nLQ8RdBzgrsfV1hBw2SaUEV7GkcVx07wBlNIyFH98=;
 b=kkbw5S7EP1ZNz+vnpvxq21ptAP750BYyZmY2nnc3YkXYqDnfTry4VG32bCPzDm4fRenJDmnZuuj5mZKTkIOpPGmS0kC+H+8qKr6D8aJOwRLpBdlb3mQWX5ZOQQf6SmJy33dpaD97AyXye+PQII2K6xzZklFBRUNaIfKU1xbvERQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3471.eurprd04.prod.outlook.com (52.134.3.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.20; Fri, 31 May 2019 14:21:41 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 14:21:40 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] crypto: caam - limit output IV to CBC to work around CTR
 mode DMA issue
Thread-Topic: [PATCH] crypto: caam - limit output IV to CBC to work around CTR
 mode DMA issue
Thread-Index: AQHVF4jbNk7S+es8G06wkdyL1dIrjQ==
Date:   Fri, 31 May 2019 14:21:40 +0000
Message-ID: <VI1PR0402MB348583A318B3AD13881745E198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190531081306.30359-1-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad4c92f5-d1d3-4143-02b9-08d6e5d34cd6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3471;
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB34710249C457DDE4986C2DC298190@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(136003)(346002)(366004)(31014005)(199004)(189003)(110136005)(74316002)(446003)(6436002)(66066001)(476003)(71200400001)(71190400001)(8676002)(6306002)(4326008)(25786009)(186003)(8936002)(486006)(2501003)(3846002)(316002)(44832011)(54906003)(2906002)(6116002)(86362001)(64756008)(68736007)(7736002)(66946007)(66476007)(66446008)(66556008)(966005)(26005)(14454004)(6506007)(53546011)(6246003)(76176011)(478600001)(55016002)(256004)(305945005)(14444005)(81156014)(5660300002)(81166006)(7696005)(102836004)(229853002)(76116006)(73956011)(53936002)(9686003)(99286004)(52536014)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3471;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o6p1642EBd+1d3x5676E9Fbt4p7/Qq5h6OtRZe5UEmCMsuj+8r5dCDnJVyRGug4ZmqkhBrunSR+lZvRNwv6cqeuT1PBboFTytN+V4dIEQLUICzmbx/6lhednppIeZz9JND3us6OSt1b+hg1+fMI9hGHBAyNP04YqGX5EqKLj2X2kxDF2UNXxhmRcNpnEA7F112UfSjeoLYrRmewXeraPtFc2ZeBR10Y7H13oSJ9VKFUjTq9ZsBiOChhBU+0sLbmVSXZJ1N3ICvcPytPWeVW8RaZ2yoDgBQalZ2EGsQOFycsQcIhZJC4//2zysuG4p1vS22sznTZCWxjRUFHC2P8eZPijL52e/RkuTcx8fvKy/S190Y3OFfFySLV3pdCZmPD/SEQ7qUnz4HBE/enpmXLMyS10K5fYCVwBkeqnEoRXj0w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4c92f5-d1d3-4143-02b9-08d6e5d34cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 14:21:40.8368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/31/2019 11:14 AM, Ard Biesheuvel wrote:=0A=
> The CAAM driver currently violates an undocumented and slightly=0A=
> controversial requirement imposed by the crypto stack that a buffer=0A=
> referred to by the request structure via its virtual address may not=0A=
> be modified while any scatterlists passed via the same request=0A=
> structure are mapped for inbound DMA.=0A=
> =0A=
IMO this requirement developed while discussing current issue,=0A=
it did not exist a priori.=0A=
=0A=
> This may result in errors like=0A=
> =0A=
>   alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-=
generic): ret=3D74=0A=
>   alg: aead: Failed to load transform for gcm(aes): -2=0A=
> =0A=
> on non-cache coherent systems, due to the fact that the GCM driver=0A=
> passes an IV buffer by virtual address which shares a cacheline with=0A=
> the auth_tag buffer passed via a scatterlist, resulting in corruption=0A=
> of the auth_tag when the IV is updated while the DMA mapping is live.=0A=
> =0A=
> Since the IV that is returned to the caller is only valid for CBC mode,=
=0A=
> and given that the in-kernel users of CBC (such as CTS) don't trigger the=
=0A=
> same issue as the GCM driver, let's just disable the output IV generation=
=0A=
> for all modes except CBC for the time being.=0A=
> =0A=
> Cc: Horia Geanta <horia.geanta@nxp.com>=0A=
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>=0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
Link: https://lore.kernel.org/linux-crypto/1559149856-7938-1-git-send-email=
-iuliana.prodan@nxp.com/=0A=
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>=0A=
=0A=
Unfortunately this does not apply cleanly to -stable, I'll send a backport=
=0A=
once it hits mainline.=0A=
=0A=
Thanks,=0A=
Horia=0A=
