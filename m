Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58A1C7618E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5FC205C9
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 09:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PrXQOQhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbfGWJ5p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 05:57:45 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:42915
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731566AbfGWJ5p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 05:57:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qwsn99ZUdsWoQhGXaXYI6FYl0o0St+YUHaIEEbGB3zV/nBQFUU2pkYZpSJ4MJ3qq53bagkcdAWplurTvPU06K8XjVyvIFhrIvrA3Pe9zOvJz+NXsM5Nkm2ecSO+JrBXniDDzxNd1S8Cra2ewZ2FFkD3RGZ16VxrmtAvR4HxanKmexuPesEatN1WcPT2/tjyr659scyS58dfttmDPu0C+qhVcYrBthPBfVF+uIcJhvScFI9j/ID8qAvWgkcgG7UUg5VNeU7gllsDWhZ3j1GEbIh6UWFmFJLumnSxzh3hb7EUGJv7bDTVtFVRYnG0sWL8vuVKSgk/8Sv442AsDZVZhbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=url5aL2aUBWr/vZUhF+a832Sbsb601B6OUEdSXOMWJ8=;
 b=KWdVG8qjOF0pLuHj53vYOiY3ev5gY0CMMsNueftsLSDSgFJb+M2Dr5hMX1QHhfTptA+sEydrhbPjPbpNWW67Kkun0ZLSva7552Quo2YLrrbn/Vul5QzWge0+y2k+woW0k5GmJFPg0cKKGPNG7j97X/YEzVMK0Dxaz4dwJayHG9AomIYwk8lGBYaF7EThib964ni+7BMpNctD/0JAH5MhYDbTOupvwyE4uBcUSZnJ/WGTNSJtwVqVk+z7SHQzWiQdqcB2AntWWUNJRGrndJ6ggGwAWmwOgke3X2Ygl6oAwITOwY9C02c3mvZ650yF8cB9N40t1nTsb0ILYGolbNiDrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=url5aL2aUBWr/vZUhF+a832Sbsb601B6OUEdSXOMWJ8=;
 b=PrXQOQhutd+/ooed+7GjbAftWrczxATqvFBSoG5DKJkko6s1auGJ4ZfUhuQqxCMaIwP30pcPI/XNJ8nXgHMKHO6uapFdUB8pVYFXdyYUtCm2a5eDdPB8jjLT9wen0FVfZGMnb87vyDxAw1CJ8ZgtEoYoKQFUoBvMYUCxrVdtI9c=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3760.eurprd04.prod.outlook.com (52.134.15.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 23 Jul 2019 09:57:41 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 09:57:41 +0000
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
Subject: Re: [PATCH v6 08/14] crypto: caam - make CAAM_PTR_SZ dynamic
Thread-Topic: [PATCH v6 08/14] crypto: caam - make CAAM_PTR_SZ dynamic
Thread-Index: AQHVPLPcllkBIju9kE+rcZ/lhM5x/Q==
Date:   Tue, 23 Jul 2019 09:57:41 +0000
Message-ID: <VI1PR0402MB3485472C45A477FB0848802498C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-9-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e601f15-d190-4229-ecb8-08d70f5433eb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3760;
x-ms-traffictypediagnostic: VI1PR0402MB3760:
x-microsoft-antispam-prvs: <VI1PR0402MB37605BB0BF9F8E202C623AB198C70@VI1PR0402MB3760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(256004)(478600001)(6436002)(6116002)(2906002)(86362001)(229853002)(486006)(6246003)(3846002)(4744005)(4326008)(71200400001)(71190400001)(76176011)(25786009)(9686003)(5660300002)(33656002)(53546011)(55016002)(6506007)(14454004)(2501003)(476003)(7696005)(44832011)(54906003)(26005)(8936002)(186003)(446003)(8676002)(316002)(99286004)(110136005)(7736002)(68736007)(66066001)(305945005)(102836004)(66556008)(81156014)(14444005)(66946007)(53936002)(64756008)(66476007)(81166006)(74316002)(52536014)(76116006)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3760;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: osmVcKj+ixELv/pRBlnLYFVxTIlXPdPN2dPMBtEGJGb1kI4VK2i//RQP+1kz2BvEsEYzv8PWHzb3xargG8j+cN6qNLEN5bRunaxOrLFNGhb12ABEFLAlqUqOxsZoC1+glv48rDxhoOAyhUFB8M6MIcCXBTiIGTJX6wRMlGS3Z3IYaGOS5/R+XyAN6bZRWI37NzCUizOzrRtqez/34moBoAAT5HKyLwwEhVgAom59LNII2jWoyxID7pQKWkT1PN7k2Of+Uqzf0av+6aMoUHN/avqK96QPEBQ/Z0Q7xZ1yg1XqTLS2O7RrRcyzyMcMaqYPjbcG0PrTwQaOp1Tcg2oKjcSAvz0bNQmoKBYpxW4jBYNlKWQlpwLAe0AgPaYh8WERkIGCiR88OBUz/ih4njl96uF7JaT3cBLo0RPmbCCSrZY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e601f15-d190-4229-ecb8-08d70f5433eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:57:41.7774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> In order to be able to configure CAAM pointer size at run-time, which=0A=
> needed to support i.MX8MQ, which is 64-bit SoC with 32-bit pointer=0A=
> size, convert CAAM_PTR_SZ to refer to a global variable of the same=0A=
> name ("caam_ptr_sz") and adjust the rest of the code accordingly. No=0A=
> functional change intended.=0A=
> =0A=
I am seeing compilation errors like:=0A=
=0A=
In file included from drivers/crypto/caam/ctrl.c:25:0:=0A=
drivers/crypto/caam/qi.h:87:6: error: variably modified 'sh_desc' at file s=
cope=0A=
  u32 sh_desc[MAX_SDLEN];=0A=
      ^=0A=
=0A=
Adding comments for this commit, since it looks like the fixes=0A=
should be included here (related to DESC_JOB_IO_LEN vs. DESC_JOB_IO_LEN_MAX=
).=0A=
=0A=
Please make sure caam/qi and and caam/qi2 drivers are at least compile-test=
ed.=0A=
=0A=
By caam/qi I am referring to:=0A=
CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=3Dy/m=0A=
=0A=
and caam/qi2:=0A=
CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=3Dy/m=0A=
=0A=
Horia=0A=
