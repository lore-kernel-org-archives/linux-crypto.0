Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F3DC35254
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7ECB20679
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 10:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="aXHsu5Ff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgBQKGz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:06:55 -0500
Received: from mail-mw2nam10on2068.outbound.protection.outlook.com ([40.107.94.68]:6252
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728833AbgBQKGz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 05:06:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgSdvSSFIHrKDzn+rdzDeFN3Hvq3hdHdxxjO4ueehgVBq1s8gCbT7xtrQZzn2QH4s5wsq8596q5xrchIeUgqNyL+BY0BkffFC3PKIpSCLh2uS9olFNgdtJknU2gXgX/YaOELBXUdRQQDhJQIrgztWFevrMFN77gYkS+4sfqBPPbsaf4uG3uPejjr9miBFDgwJBayWS97gpb7fEeCGlqa9yC5GMa0hVCaRFZo8HapdFenqBLR5tS9erXJvbGnujlSHgLG2KJ3icUtJZlJ6sk1xuwiJlEMva7P4eoUYQHZoEdCywcC4WgJwVnLHsuw7+t+n/zG5LkJZeymBThTDbk7TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwEL6IBrFuBo4kLUds4E47cCCgQpkK4bBGnPthAS/L4=;
 b=D/HIchFGDatSkfuh+pwAnMQGpqe+t1N3GAxJRldtkmLq87Sp4kKhGf96sjpmDn7tBkRT6L+faqiOhG9L2O6pG6ymJC40OOLdIWX2GiS5702sX/tQ/Qe9lKLmUbyW37j3s+Fd6D8b1SSXg578Cat+EVt87Gxe3cLe/kNJSgqvUhptUVq0ItRjY1pMU9eNIJ/Iz++1/t7fMw6yCXtQOhhoJVW/Ns7ZTjyeaJBQBzqX1ywGDL8VNu1q1OuxL/H6cFDbmdmrAaRS9vwFEqGD7fwi+tmP9jQKysqLj4gTCOtBzmRHWyVHZ83vkLHgGARFvXGlhKUSuJRhd/6fDGuiF5+SwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwEL6IBrFuBo4kLUds4E47cCCgQpkK4bBGnPthAS/L4=;
 b=aXHsu5Ffkdf4bNzx45L30dvYb4MxehgtCRnVDarBIvJLTJYogYFob3Rdl5o+fm7F23JOfHiyS3mhC6UI+zjpIz0vSyks/eOyFRLXpZ35A3+4OIYpeF2JRArSAtPB94N8QZGyaGUl386dmS9eqHdA1//o23YrrB/0wjShtXlLxVU=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.27.215) by
 BN7PR02MB4242.namprd02.prod.outlook.com (52.135.250.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.30; Mon, 17 Feb 2020 10:06:49 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::3c2d:7e2:dfb6:adfe]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::3c2d:7e2:dfb6:adfe%5]) with mapi id 15.20.2729.032; Mon, 17 Feb 2020
 10:06:48 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "monstr@seznam.cz" <monstr@seznam.cz>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        git-dev <git-dev@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
Subject: RE: [PATCH V6 3/4] crypto: Add Xilinx AES driver
Thread-Topic: [PATCH V6 3/4] crypto: Add Xilinx AES driver
Thread-Index: AQHV1aLi86wN5Of2F06o6+V0ID53EKgY7WuAgAZaW/A=
Date:   Mon, 17 Feb 2020 10:06:48 +0000
Message-ID: <BN7PR02MB5124554576DEC68C9121684FAF160@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1580192308-10952-1-git-send-email-kalyani.akula@xilinx.com>
 <1580192308-10952-4-git-send-email-kalyani.akula@xilinx.com>
 <20200213090241.fksu33yszqi5fjat@gondor.apana.org.au>
In-Reply-To: <20200213090241.fksu33yszqi5fjat@gondor.apana.org.au>
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
x-ms-office365-filtering-correlation-id: ecef6143-25ad-496e-391d-08d7b3911a24
x-ms-traffictypediagnostic: BN7PR02MB4242:|BN7PR02MB4242:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR02MB4242EA2806CF1E6FFF45DDB7AF160@BN7PR02MB4242.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(199004)(189003)(9686003)(8936002)(54906003)(86362001)(316002)(107886003)(4326008)(7696005)(8676002)(81166006)(6916009)(2906002)(478600001)(81156014)(52536014)(64756008)(966005)(5660300002)(71200400001)(53546011)(66476007)(66556008)(55016002)(26005)(186003)(33656002)(66946007)(66446008)(76116006)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB4242;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKOWgz67eRTYI0WbH5YVKjLHeumoXJbT3HGeE7y6sx0zLysAkBP5iS89hq0YmJbBeRyY4BecW5J8cyD1Ogtvp/4E4jNrNFhm212MBxy0S2x7StwhK5lb28ptwGydziCmRpG+U/NbpujYUIGrQ9yhavQOMIfzQh57aqbqnAfTGkdhaETG+lOxnCd2kgSeWKxy6OMjrgosRSe5LEoIogJTJdf9bFzsgn+tuSEmrShIezHpZkNLDNJY3fJ2oEZ2bYdpsxgD+YjXq0xIgLiXqpQfkE6R8ZP3E1p/D049+ok8bf4dzIGVB11423JTYCSZMIpBvC9mCy2mo0HkTEcmErvb5r8e4S7M24sYQwOMtAVgzMHC1RHQvrb7FOYQCMyoPu0HrhMlVMWoEx01IJuSqJcK+Lo1Dq5s4YqqQmb7DXguD4F3ag5ujPSKkiO67ghHBGn7woQtrkiYvgswZaOTrp5XaBPF84USqeCxDPZdwQlIDv3HlSVvJ77u5V6XOLsWIm0WuxWOzcgDNcqv1Xn7y7A2zw==
x-ms-exchange-antispam-messagedata: 9EHD1GoHYY/baiHOpClhjqXN8qcII/a7ENmb7vZ55FmJ6oBlDmzM9ANrLvnlc+98s3gzpTEIB/eLLcuJYRmmQMzEC5oFNCv6qv8OsrVXA+LhF16SCEyDXXjI8Ux/AbUxWBF9wH4Ak1nMUXNDEx1N3g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecef6143-25ad-496e-391d-08d7b3911a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 10:06:48.5656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UOgwaNKfpXc/37iNl2igbl6VvWeUhZLprXEI3+JJkL5j4ez0j6O/SNXwREiPNO5s0zeF9rrGsAadfl741/XmxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4242
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

The compilation issue is due to commit af5034e8e4a5 ("crypto: remove propag=
ation of CRYPTO_TFM_RES_* flags ").
I will fix it and send V7.

Regards,
Kalyani

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, February 13, 2020 2:33 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: davem@davemloft.net; monstr@seznam.cz; linux-crypto@vger.kernel.org;
> linux-kernel@vger.kernel.org; Rob Herring <robh+dt@kernel.org>;
> devicetree@vger.kernel.org; git-dev <git-dev@xilinx.com>; Mohan Marutirao
> Dhanawade <mohand@xilinx.com>; Sarat Chand Savitala
> <saratcha@xilinx.com>; Harsh Jain <harshj@xilinx.com>; Michal Simek
> <michals@xilinx.com>; Kalyani Akula <kalyania@xilinx.com>; Mohan Marutira=
o
> Dhanawade <mohand@xilinx.com>
> Subject: Re: [PATCH V6 3/4] crypto: Add Xilinx AES driver
>=20
> On Tue, Jan 28, 2020 at 11:48:27AM +0530, Kalyani Akula wrote:
> > This patch adds AES driver support for the Xilinx ZynqMP SoC.
> >
> > Signed-off-by: Mohan Marutirao Dhanawade
> <mohan.dhanawade@xilinx.com>
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> > Acked-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> >
> > V5 Changes:
> > - Replaced ARCH_ZYNQMP with ZYNQMP_FIRMWARE in Kconfig
> > - Removed extra new lines.
> > - Moved crypto: Add Xilinx AES driver patch from 4/4 to 3/4.
> > - Updated Signed-off-by sequence.
>=20
> Sorry but this patch doesn't compile against the current cryptodev tree. =
 Please
> fix and respost.
>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
