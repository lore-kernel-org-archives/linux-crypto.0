Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FFEC76188
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 14:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247232171F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 14:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="muQc5MZ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfGVOZK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 10:25:10 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:1921
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfGVOZJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 10:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9Jz1Xr/q4DMAr0nEqkM9wnla5WUy++cu83iMphuzDvvFHiDYSKUvSkG/dXBdGLkbSeQNJrqGOSNznrdh0Da2XmWukPiv7/x9tyYh3nkeMSmoFr41jlmhhkrH+40FYiuyIc9ejs/ruFQ85vDb5kk2Sq4wOknI4Moa+lF1J7MO3U0oKgq1Y2GG3WdSNbN1OmneGsZVyq/CqGNVMiuIUdDhWHJfWD5h8taC9VzczDkK5NmwLNgrYJkLFO/Zcbe9+IS0V7mVmf5eHJhlzugSVIypP+bA253XQbnSGojAIHqX7QX7KntbvhQX/VucgP8ISiFZLMpYRdYbBXNFEg/szJNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufbn9V4jX+amNR5V9UViiqFYwgUltjgIFiH20Xhmp5A=;
 b=ceXfbZ0v2lIPi5humHy0Ms923tQhF7lrDX/GkNRwsUVj90br42fL+VpjwDWuwo4vWB4L9yZDzF+MT+jfcQh1wEqqF8fZmdupeKE6l/1qveYif+zDhX3Yxh/+fH5qck1knIh2Qdcv0iQyGJQlAYX5gi1d8j8G/SYqwggDodN3SycibZpnqqH/9yNLKsu7xHJR9fZYBPa7Y5vCTFnwRqeYqOLbRU9Gw+KXWjmviiWOXiJDG0507gxaFde7oEiqQFelqiq/GBI9C0PPfkbXxuaHLv1b4eBngUyj2Poy4mv+67RQL9NaEMD93sFVfPqqpwPWwPdSSA4A2uKjJ1zJfMCssQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufbn9V4jX+amNR5V9UViiqFYwgUltjgIFiH20Xhmp5A=;
 b=muQc5MZ+MAMzyoYZxgDXhFxPVzhGQiQWWPha+cKg8hjFqAPco8+sdN2EH81FyOEARHLkx5Qa54hqRWXwKGPm/eAPDa7i4LuHqj9hq665vY1aG/847J7coSfhiZCNqOf2hciMMaCQKydevTXQwlRS+zjTmotTMjLcRK2qhfF9ahE=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3634.eurprd04.prod.outlook.com (52.133.34.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Mon, 22 Jul 2019 14:25:05 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::2080:6953:47fc:bcd]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::2080:6953:47fc:bcd%7]) with mapi id 15.20.2094.011; Mon, 22 Jul 2019
 14:25:05 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEA==
Date:   Mon, 22 Jul 2019 14:25:05 +0000
Message-ID: <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20190719111821.21696-1-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8a75d12-a172-4c61-aec1-08d70eb06425
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR0402MB3634;
x-ms-traffictypediagnostic: AM0PR0402MB3634:
x-microsoft-antispam-prvs: <AM0PR0402MB3634FE69879A9688114F7E5298C40@AM0PR0402MB3634.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(199004)(189003)(66066001)(76116006)(91956017)(66446008)(64756008)(66476007)(81156014)(81166006)(52536014)(66556008)(66946007)(3846002)(6246003)(6116002)(53936002)(478600001)(25786009)(229853002)(5660300002)(9686003)(2906002)(55016002)(86362001)(6436002)(14454004)(256004)(53546011)(7736002)(44832011)(6506007)(33656002)(7696005)(71200400001)(71190400001)(74316002)(305945005)(2501003)(316002)(476003)(110136005)(8676002)(446003)(76176011)(68736007)(8936002)(4326008)(26005)(99286004)(186003)(102836004)(486006)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3634;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rTTX87+ZyYr1Q9IyJLo8r8fWDUt6tL7AL9Slr7BrqVigxZDdQGyslRHns8iu9i919ghmrIpwHc4TAQrCXhYQ6P5FN4kfqDJmp+dxwxjK/kSqvRbDPIrfqJB6Eh+mJOp8HczCovd1+HG747Hips/keeeV03KJYNt9qGkfjHSO58Bg5rO6Ox/oAOKh3wgnrX4beWoX8RIigU1Xj1fCLjKFDlVPFzq6Ya6aPYeWJgOgcwgqiVoPXoQZQvAWh37y9+4fAGospwhqYESym4Tu6//WbqNAJP/mAL6xPyl82rcIou57fZKjXnbBMbGlt6MZygCh8snomsxQa9YkPCKfEKEQ2yC0T7g9eOn6TVAMSugyux7RVMK5WkLGTisFoaZbBSRtOyjaTlSpJ3Uvc/r+mfkgDmcmchcQsZaHycYGsHWgISk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a75d12-a172-4c61-aec1-08d70eb06425
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 14:25:05.2928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3634
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:23 PM, Vakul Garg wrote:=0A=
[...]=0A=
> +if CRYPTO_DEV_FSL_DPAA2_CAAM=0A=
> +=0A=
> +config CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS=0A=
> +	depends on DEBUG_FS=0A=
> +	bool "Enable debugfs support"=0A=
> +	help=0A=
> +	  Selecting this will enable printing of various debug information=0A=
> +          in the DPAA2 CAAM driver.=0A=
> +=0A=
> +endif=0A=
Let's enable this based on CONFIG_DEBUG_FS.=0A=
=0A=
> diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile=
=0A=
> index 9ab4e81ea21e..e4e9fa481a44 100644=0A=
> --- a/drivers/crypto/caam/Makefile=0A=
> +++ b/drivers/crypto/caam/Makefile=0A=
> @@ -30,3 +30,4 @@ endif=0A=
>  obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o=0A=
>  =0A=
>  dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o=0A=
> +dpaa2_caam-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS) +=3D dpseci-debug=
fs.o=0A=
dpaa2_caam-$(CONFIG_DEBUG_FS)=0A=
=0A=
[...]=0A=
> diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caam=
alg_qi2.h=0A=
> index 973f6296bc6f..b450e2a25c1f 100644=0A=
> --- a/drivers/crypto/caam/caamalg_qi2.h=0A=
> +++ b/drivers/crypto/caam/caamalg_qi2.h=0A=
> @@ -10,6 +10,7 @@=0A=
>  #include <soc/fsl/dpaa2-io.h>=0A=
>  #include <soc/fsl/dpaa2-fd.h>=0A=
>  #include <linux/threads.h>=0A=
> +#include <linux/netdevice.h>=0A=
How is this change related to current patch?=0A=
=0A=
>  #include "dpseci.h"=0A=
>  #include "desc_constr.h"=0A=
>  =0A=
> @@ -64,6 +65,7 @@ struct dpaa2_caam_priv {=0A=
>  	struct iommu_domain *domain;=0A=
>  =0A=
>  	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;=0A=
> +	struct dentry *dfs_root;=0A=
dfs_root is used only in dpseci-debugfs.c, let's have it there as global.=
=0A=
=0A=
Horia=0A=
