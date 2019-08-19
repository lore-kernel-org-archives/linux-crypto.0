Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0153C3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738D6206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="YKWvtTh5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHSOw6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:52:58 -0400
Received: from mail-eopbgr770074.outbound.protection.outlook.com ([40.107.77.74]:7911
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfHSOw6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 10:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLrHUBS+h5oDHhQhxbBM8IlXf5Q9Z5wTdzjqql5Z3Yr9nFsRTarnVKClfwYg2I/E/q8+9YRHJJ+RwHrUJKHgJAD446yvgspTFxFc6zHu2A9nET4oG8D8+qVdM0xP13WSzZMPwGf7A254/4SqFA+U2ZRp8rybw9dZfaDN4OGJi+OYdk8a6LS3k1KsHsrBYYfK+Q0doSp4f0u6z6dGMFvTZc9VGss2sOeW3PTaR2ABfrtSgeYXRWQHfnnElp/AzJeL2swrXtvRUVvgjmCFJBwcX8uxxQHJkz2yBlxcUDlr5YZHkUJiqlqmK4FL0r3s9sd9VCCw6Ei2Rlpg9vQ4+zrbpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSQmzVlJ7Me9df7lTCrJzuOk+f0RjWdKWWP/2HHKKeU=;
 b=b7s1m6DdGfRlIssx58CvKPjLExl36TdlrURd1UumDjmv7P1YyRXCeZa3yePnWhB+xxpaXATNqwyi9XHY2IUPHZShYib5ZIcS+C5zkEsbHvKm4RL58ThNPtA9W7BC89B8MSenSOyWmvSMWCNru7WJ33GW8oTIEVgCy9HLWuYmzuejJvKQWXgvrGD3/KI9icRsBU10/3gGrmV3PNvCUM+3Bjr4O2ktfaq/3FDD+7fN6j++v6XVpjIWdDA7BH5+NMGgPSDaxnxicZZRUldeSsKBEiz8uW+nG1+qJVVf0GoPDwUhVOefcKnnSPwwOAT6PxTnygiP+LJIuiiyWvNd1t+xOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSQmzVlJ7Me9df7lTCrJzuOk+f0RjWdKWWP/2HHKKeU=;
 b=YKWvtTh5gsy+lGxdWk2HPv2ELtTcakrYWn0gCf4YyO+CrF8JDAinceM5M3S2C9IbngTGuCa+sxnFq5VXSIG0TWDC1RmiAbwREkFg405iCIunh2y5GZRzdOnaNQFr0tzOijlSnM88q/zkarbuhhn4cDTxclxGzKx21wioovqJItI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2592.namprd20.prod.outlook.com (20.178.251.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 14:52:51 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 14:52:51 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv4 0/4] crypto: inside-secure - broaden driver scope
Thread-Topic: [PATCHv4 0/4] crypto: inside-secure - broaden driver scope
Thread-Index: AQHVTDPJSUAyMUzwHUSZANDaSovzoab8JyCAgAZ7lJA=
Date:   Mon, 19 Aug 2019 14:52:51 +0000
Message-ID: <MN2PR20MB29737672222C6C258658F83FCAA80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190815115125.GA28602@gondor.apana.org.au>
In-Reply-To: <20190815115125.GA28602@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed3a94b0-5518-4131-90ef-08d724b4e904
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2592;
x-ms-traffictypediagnostic: MN2PR20MB2592:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2592093DEB6FDC5C2F5C3603CAA80@MN2PR20MB2592.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39850400004)(376002)(136003)(396003)(13464003)(189003)(199004)(71190400001)(6506007)(102836004)(81156014)(81166006)(71200400001)(53546011)(8676002)(4326008)(6436002)(15974865002)(229853002)(55016002)(5660300002)(54906003)(66066001)(966005)(33656002)(6246003)(64756008)(66446008)(478600001)(66946007)(446003)(66556008)(66476007)(76116006)(486006)(476003)(53936002)(11346002)(74316002)(8936002)(3846002)(6116002)(305945005)(86362001)(7736002)(99286004)(76176011)(7696005)(9686003)(2906002)(26005)(14444005)(256004)(52536014)(186003)(6306002)(14454004)(25786009)(316002)(110136005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2592;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6LlgtglTKg8SRxiF/v5GaMme2wzBgSlkT+EnoIjjmG0hjCxRKDP3qjlrBZ0jfq0AHuHH/GQ4vpi6ILAb8VuQJ1L0j+qVaFgbbv2G6hlCRc44G+y6UQRMmbPEKrf5JovMefm6cE2aGfHE4q6K7w4tPMnfAI1bKWg4RuwHd+Ds6F8WzArOhrcamRlPkjkPzKZtF2GmFb8rt/j0NWlbB0fkCiPWoUFUVlBLymrRb+ebsU/PnIGLLBMMirjA2zQ9ISUjHap8+y+qqG/eZTOQElvk4484xCiqKsP1KlF4F1TecZzD7j7Os+1EbaJbNYzKtxVBaIe3x9EdEmxttAmWoan5iTlq33CiMjTS+XukqstzwwbeLwlCjQWGVMqd0LkUOqbLVX8uy1pW+OxjbxxmvC0xF0DzEkac69M6ueDtuKjYEVc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3a94b0-5518-4131-90ef-08d724b4e904
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 14:52:51.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ced8uGxbjQX8VBben+uAhQYPDge3wSHZAmM9CfCbTEwmXDPqtv0FO1NcBtmvpQELvaqmtB8dxuoaErP2KFio27cS3v9uYp0plkAtuok8J+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2592
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Herbert Xu
> Sent: Thursday, August 15, 2019 1:51 PM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net; Pascal
> Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv4 0/4] crypto: inside-secure - broaden driver scope
>=20
> On Tue, Aug 06, 2019 at 09:46:22AM +0200, Pascal van Leeuwen wrote:
> > This is a first baby step towards making the inside-secure crypto drive=
r
> > more broadly useful. The current driver only works for Marvell Armada H=
W
> > and requires proprietary firmware, only available under NDA from Marvel=
l,
> > to be installed. This patch set allows the driver to be used with other
> > hardware and removes the dependence on that proprietary firmware.
> >
> > changes since v1:
> > - changed dev_info's into dev_dbg to reduce normal verbosity
> > - terminate all message strings with \n
> > - use priv->version field strictly to enumerate device context
> > - fixed some code & comment style issues
> > - removed EIP97/197 references from messages
> > - use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
> > - use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
> > - do not inline the minifw but read it from /lib/firmware instead
> >
> > changes since v2:
> > - split off removal of alg to engine mapping code into separate patch
> > - replaced some constants with nice defines
> > - added missing \n to some error messages
> > - removed some redundant parenthesis
> > - aligned some #if's properly
> > - added some comments to clarify code
> > - report error on FW load for unknown HW instead of loading EIP197B FW
> > - use readl_relaxed() instead of readl() + cpu_relax() in polling loop
> > - merged patch "fix null ptr dereference on rmmod for macchiatobin" her=
e
> > - merged patch "removed unused struct entry"
> >
> > changes since v3:
> > - reverted comment style from generic back to network
> > - changed prefix "crypto_is_" to "safexcel_" for consistency
> >
> > Pascal van Leeuwen (4):
> >   crypto: inside-secure - make driver selectable for non-Marvell
> >     hardware
> >   crypto: inside-secure - Remove redundant algo to engine mapping code
> >   crypto: inside-secure - add support for PCI based FPGA development
> >     board
> >   crypto: inside-secure - add support for using the EIP197 without
> >     vendor firmware
> >
> >  drivers/crypto/Kconfig                         |  12 +-
> >  drivers/crypto/inside-secure/safexcel.c        | 744 +++++++++++++++++=
--------
> >  drivers/crypto/inside-secure/safexcel.h        |  43 +-
> >  drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
> >  drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
> >  drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
> >  6 files changed, 573 insertions(+), 252 deletions(-)
>=20
> This patch series fails to apply on the current cryptodev tree.
>=20
> Please rebase.
>=20
Ugh ... yeah. Looks like some very minor changes have been made to the cryp=
todev
tree since I prepared those that are causing me a major headache now.
Will rebase and send a v3 shortly.


> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

