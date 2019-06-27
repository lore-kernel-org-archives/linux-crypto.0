Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9588EC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CCF2082F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 09:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="CcH0HFGt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0JLA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 05:11:00 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:41479
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfF0JLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 05:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fkXL61c75wBiAI/CfZUSHJ/jWRVW0MgXeUbXd0O6Io=;
 b=CcH0HFGt4ton11Fw1RrfMvIObEuN9LR9H11aYX6B73qSOocaxD9/lR+aH/4t8k/U6fpaMbx7o9g59h89mDjDn2N+MMjXlBLCA6kN0ZpJd115I0ZkQk47/VQKL9w2jYA9qFIrEGPCIHfVBa1aG2DVVC9GywwYicyvPyGU4INtU6I=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3728.eurprd04.prod.outlook.com (52.134.15.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 09:10:57 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 09:10:56 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: [PATCH] crypto: caam - fix dependency on CRYPTO_DES
Thread-Topic: [PATCH] crypto: caam - fix dependency on CRYPTO_DES
Thread-Index: AQHVLMg6bRP/EUM6h0yuxgQigJ2Bog==
Date:   Thu, 27 Jun 2019 09:10:56 +0000
Message-ID: <VI1PR0402MB3485E399D27D2D86674DBE6198FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-28-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcb5bda9-cf5a-4936-52e8-08d6fadf5d54
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3728;
x-ms-traffictypediagnostic: VI1PR0402MB3728:
x-microsoft-antispam-prvs: <VI1PR0402MB3728A458B1A6FEBE84D6A7B398FD0@VI1PR0402MB3728.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(346002)(396003)(366004)(199004)(189003)(6436002)(73956011)(44832011)(86362001)(52536014)(33656002)(66946007)(81166006)(3846002)(8936002)(6506007)(81156014)(6116002)(76116006)(53936002)(55016002)(68736007)(110136005)(2501003)(4326008)(5660300002)(478600001)(54906003)(9686003)(71200400001)(25786009)(71190400001)(66446008)(26005)(66476007)(66556008)(64756008)(99286004)(316002)(8676002)(476003)(66066001)(14454004)(7696005)(446003)(256004)(7736002)(305945005)(102836004)(76176011)(74316002)(2906002)(486006)(53546011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3728;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +saVFFc1XJACSI3lWJ9FtaPVDSfs7K6gsVXuWjedZTjY3ruNzA8w5lfyc+58sqisPDBn7hOY8JttF18ryrxDTfrmSudpcbBEjzIVRpp91FUhRjavpk4Jro2QBYC7p5fJmnU8+1KjTUVsS8QP/nM2JOd7LO3iZcV9rxqxmiCHiWDYQOWsF1z5rMx41SkpMLAOWLYx9SBVhU15oHPTPpcvjuYKOyj5OkipG3s2Rzq7Y/8YhFY1YBrMUtYxPG67qRWcklpNwx1A23uPNh97KivyngInzSPRENaGlZV5nh5hwMyvTstTBT9R+EYTA8PI01PY8FF5WeON+Bm0qMxXAgxXQyg9tFt5Hsbq86WpK8Aq1HdzDCWAjP3D6OWP3ZNOBHHGNKSN5UYe3UtjPkwk2w/5gkjzciDGLUlz6dOEprZE6Wg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb5bda9-cf5a-4936-52e8-08d6fadf5d54
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 09:10:56.8563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3728
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(changed subject to make patchwork happy=0A=
was: [RFC PATCH 27/30] crypto: des - split off DES library from generic DES=
 cipher driver)=0A=
=0A=
On 6/22/2019 3:32 AM, Ard Biesheuvel wrote:=0A=
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig=0A=
> index 3720ddabb507..4a358391b6cb 100644=0A=
> --- a/drivers/crypto/caam/Kconfig=0A=
> +++ b/drivers/crypto/caam/Kconfig=0A=
> @@ -98,7 +98,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API=0A=
>  	select CRYPTO_AEAD=0A=
>  	select CRYPTO_AUTHENC=0A=
>  	select CRYPTO_BLKCIPHER=0A=
> -	select CRYPTO_DES=0A=
> +	select CRYPTO_LIB_DES=0A=
>  	help=0A=
>  	  Selecting this will offload crypto for users of the=0A=
>  	  scatterlist crypto API (such as the linux native IPSec=0A=
=0A=
There are two other config symbols that should select CRYPTO_LIB_DES:=0A=
CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=0A=
CRYPTO_DEV_FSL_DPAA2_CAAM=0A=
=0A=
True, this is not stricty related to refactoring in this patch set,=0A=
but actually a fix of=0A=
commit 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
=0A=
I am adding a fix inline.=0A=
Herbert, I think it would be better to apply it separately.=0A=
=0A=
-- >8 --=0A=
Fix caam/qi and caam/qi2 dependency on CRYPTO_DES, introduced by=0A=
commit strengthening 3DES key checks.=0A=
=0A=
Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")=0A=
Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
---=0A=
 drivers/crypto/caam/Kconfig | 2 ++=0A=
 1 file changed, 2 insertions(+)=0A=
=0A=
diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig=0A=
index 3720ddabb507..524b961360d2 100644=0A=
--- a/drivers/crypto/caam/Kconfig=0A=
+++ b/drivers/crypto/caam/Kconfig=0A=
@@ -111,6 +111,7 @@ config CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=0A=
 	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC=0A=
 	select CRYPTO_AUTHENC=0A=
 	select CRYPTO_BLKCIPHER=0A=
+	select CRYPTO_DES=0A=
 	help=0A=
 	  Selecting this will use CAAM Queue Interface (QI) for sending=0A=
 	  & receiving crypto jobs to/from CAAM. This gives better performance=0A=
@@ -158,6 +159,7 @@ config CRYPTO_DEV_FSL_DPAA2_CAAM=0A=
 	select CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC=0A=
 	select CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC=0A=
 	select CRYPTO_BLKCIPHER=0A=
+	select CRYPTO_DES=0A=
 	select CRYPTO_AUTHENC=0A=
 	select CRYPTO_AEAD=0A=
 	select CRYPTO_HASH=0A=
-- =0A=
2.17.1=0A=
