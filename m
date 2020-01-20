Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F1FC33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942A62073D
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="otxsOkB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgATHAD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:00:03 -0500
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:13121
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbgATHAD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 02:00:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goCuIxl2oVWIRARkaiPy0WcXnr1LlK73sbsvCRKwpvj5785ZgKgcprPgZ9UtIn3e3UN+VwmM9QpXDuvA7O8zkTv2itT9YDKIcIiPObuuCa2UIZOxmyrpT40tr3w1uoe8VDueEqUNq2tta7XLVbA4ARvaZ6sY7Rab0Pt209EzSoNNj5cVx7xA/3Xqex2dISvkE7IPPnb6DIwQatKk1fY+MutASiUoOXpPbHP/L33idwuhdMQZhe8IraWFIqJXLGNIQwALB1hPKmzXMWFNYc5ZASwOLBvE/Moy2mBtKDE5Awt/X3QLxw4LO7WvtK6JqA8+mFa2394Cq5o6eqYPV4f8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhTdiQsMI7SAew8owqXWDmRDdIHpkgrLudN/pPERLdE=;
 b=AlCHO6r5HRcAh7yWakT/0/+XBpEaxeo2dNLTXgehugPu3yW3IVP65T/kp4FPwdXDw66NyWFWDbDBEc6m+ksUPkQuYxdifXFqOwY8hzmVlFIQ0rjGXFd15UkRDOiKsg0lQ9FtekiRgUwqxz63Yr5fgpi8EKWp+hWlWE7WSpeCeq3s7aiS03CmXm4dm9jwJIEzSIBik9oi3irCMDxiAD/tW21qkOjWipvhvRcdKI22CM7jg4EViU7ablI++A4wu4vf7iD9noYnUkw+wogtIpdJA4KFPqGN1FxCGX5W0GKAuvswvWYWmrql2gO2UeAiPM6pxH4peffgCUi6+zq0MK2/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhTdiQsMI7SAew8owqXWDmRDdIHpkgrLudN/pPERLdE=;
 b=otxsOkB4mutkp7X+8/sHIsrE9fVEviCORTayI6ghhnPx3JizGmuRUQ0B6APWF+jeYfS9xGkrujiNOeIt9Cu47gx7q72LYP4LWqkVPpi3txD7N+3+jcSHG+x6oQBNmsSqzY1G9lCkSPjkQRRnVFK1OkduKV2NC9MBtkcKKAD4yH4=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.27.215) by
 BN7PR02MB5219.namprd02.prod.outlook.com (20.176.26.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Mon, 20 Jan 2020 06:59:23 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::b931:9fd2:766e:ad34]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::b931:9fd2:766e:ad34%7]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 06:59:23 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Kalyani Akula <kalyania@xilinx.com>
Subject: RE: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Thread-Topic: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
Thread-Index: AQHVn3ZdMLHysFoGYEeVli3E4ApBiqfzfr/w
Date:   Mon, 20 Jan 2020 06:59:22 +0000
Message-ID: <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
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
x-ms-office365-filtering-correlation-id: 3aec0790-8d35-437a-75fa-08d79d7647b6
x-ms-traffictypediagnostic: BN7PR02MB5219:|BN7PR02MB5219:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR02MB521974CD52DB333AC761BF82AF320@BN7PR02MB5219.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(199004)(189003)(4326008)(2906002)(53546011)(107886003)(33656002)(26005)(186003)(55016002)(52536014)(5660300002)(7696005)(9686003)(316002)(478600001)(8676002)(8936002)(81156014)(81166006)(6506007)(64756008)(66556008)(66446008)(86362001)(66946007)(71200400001)(66476007)(76116006)(54906003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5219;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zUM/QEFFa6pz9nHcY/ZbvyShNZg0JVg7NWQorFWldzfZhLJMX8TM357ksFJtwS0R7llNceTeF4REgP6bLYwr/zzGs8eje1+n9fa1QbWR9dzHWO+3B2Ndla0OVN1jv9DMuP4UyRoGJYPWHCWzuSFiX9iES7jO/iqnXxry+TnaqEmRmJBtJzWe7k8vkkZVVroU1Brel88EE/vom8EccB0zEBV/bYbW4zChK/dQRCNgZUEVrzpBqfwFAgG/OwGOTGLPw1emdYAv+f1gK2LQ1c/uL937J4KlpFPbjhwTrJ80zj2qfXDHVNwCILqswowjh5kPabAjNmRMDM37zBWHU8dfvq6RXegiUgodHdwQJCrHkSlmJcvyoPeC1yD9TiCd3ZLUIVzGQPBmHiHwoAL+JvtPxADfNbhbz4MfX4vRyrciAzxja5MwPTqTIO8zchudJDd
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aec0790-8d35-437a-75fa-08d79d7647b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 06:59:22.9267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6koYS9x+whGOn3adPhfayQNf6OJd/JlhNyC6jpjgmPqG4WJ5A+6afRhjA/aW+CRzZh+6EhC6I98Dr7oeV4mq3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5219
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Any review comments on below patch set.

Regards,
Kalyani

> -----Original Message-----
> From: Kalyani Akula <kalyani.akula@xilinx.com>
> Sent: Wednesday, November 20, 2019 1:14 PM
> To: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: git <git@xilinx.com>; Harsh Jain <harshj@xilinx.com>; Sarat Chand
> Savitala <saratcha@xilinx.com>; Mohan Marutirao Dhanawade
> <mohand@xilinx.com>; Kalyani Akula <kalyania@xilinx.com>; Kalyani Akula
> <kalyania@xilinx.com>
> Subject: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
>=20
> This patch set adds support for
> - dt-binding docs for Xilinx ZynqMP AES driver
> - Adds device tree node for ZynqMP AES driver
> - Adds communication layer support for aes in zynqmp.c
> - Adds Xilinx ZynqMP driver for AES Algorithm
>=20
> V4 Changes :
> - Addressed review comments.
>=20
> V3 Changes :
> - Added software fallback in cases where HW doesnt have  the capability t=
o
> handle the request.
> - Removed use of global variable for storing the driver data.
> - Enabled CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy and executed all
> the kernel selftests. Also covered tests with tcrypt module.
>=20
> V2 Changes :
> - Converted RFC PATCH to PATCH
> - Removed ALG_SET_KEY_TYPE that was added to support keytype
>   attribute. Taken using setkey interface.
> - Removed deprecated BLKCIPHER in Kconfig
> - Erased Key/IV from the buffer.
> - Renamed zynqmp-aes driver to zynqmp-aes-gcm.
> - Addressed few other review comments
>=20
>=20
> Kalyani Akula (4):
>   dt-bindings: crypto: Add bindings for ZynqMP AES driver
>   ARM64: zynqmp: Add Xilinix AES node.
>   firmware: xilinx: Add ZynqMP aes API for AES functionality
>   crypto: Add Xilinx AES driver
>=20
>  .../devicetree/bindings/crypto/xlnx,zynqmp-aes.txt |  12 +
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   5 +
>  drivers/crypto/Kconfig                             |  11 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/xilinx/Makefile                     |   3 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 469
> +++++++++++++++++++++
>  drivers/firmware/xilinx/zynqmp.c                   |  23 +
>  include/linux/firmware/xlnx-zynqmp.h               |   2 +
>  8 files changed, 526 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
>  create mode 100644 drivers/crypto/xilinx/Makefile  create mode 100644
> drivers/crypto/xilinx/zynqmp-aes-gcm.c
>=20
> --
> 1.9.5

