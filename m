Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B13BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 10:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D832086D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 10:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="GTZJP5ZJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfIIKhv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 06:37:51 -0400
Received: from mail-eopbgr760089.outbound.protection.outlook.com ([40.107.76.89]:21311
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728377AbfIIKhv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 06:37:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPXqvoyTZ4qpOwAvhGqHjk+UiPpf9puAzsQCaTdlDyo63dkqTQMNXAqyxavAXJszl6VZwbFloQ7NfEnrFut9wwE4Gib2kKuk/iglCmelX2YWFtobYXTzBKL8nfLWaRgqc0UhOZ04Y6RKgmAb9k3H17XmVysubTRAPJSYHTtndzb0GXh/4By+aNzmFEpyRpI0jd/bVQLNc6reU7o6P7AWzL7wRa2v9yCDr6VufN4zyrT99RT7vbgCf1ItA5Y8UJzdvunBNksgYj01sORmQXNM+rMNe246kRvA8q5llCkr8BD/XXYYMgs0CYA69VFcJaX8EKSdEr7PXmIWjJpg0hoU6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zioabqFJkRZCYGR4ff0Uc1dS43BpG/ZcWgNJUd6U4i0=;
 b=ZPTiLVvmYOAwnGUyqP6w/+VzxuAPtE+PYHd28h3GwiFumQS0UqVtOzjIy3LfheTJdOZVRr0+PGWNTXZU+8ZRbFZMwHZP/pykhRhP/UbZerl1diDiiODtDRAYxQzkNUvqoGYFYh+9qQTMXOgImKdom+QR2HnZCgB+9LH+0E9rMfyXwM7nPDQA8VqwnPAyst/EP85ekO446L9gB8Odto21I2PSAZNp0ZIzlCd8Wk4Q14L5tONfqz8p08JchT2fprZLBQoaivXPCcdW1yGhnhcQHOERqr4RCFXNgyIbK/Aa1O1HFX2q3cleYFbEYtYddZnad1A6g57Jfi8vEhDoiDuIvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zioabqFJkRZCYGR4ff0Uc1dS43BpG/ZcWgNJUd6U4i0=;
 b=GTZJP5ZJgxUdQePMcndSeLTInZABYcCmih7PYb3Ft+xm6cxIiGz/zYlkSUXLMlB5rMojmpVND+7iXW+dp0eDajZYnRE3pEoE7fszNbPP6pEdlyxZXWvX8gAA7ugHhfxM+Z+7V2fUoC/NtOf8QAFi7KFAAGA5A5kx1NsF4vgdL6c=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3040.namprd20.prod.outlook.com (52.132.173.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 10:37:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 10:37:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Topic: [PATCH 0/3] crypto: inside-secure - Add support for the CBCMAC
Thread-Index: AQHVYv9asl0eADp8PE2B9pjhBKQu46ci/PoAgAAwu6A=
Date:   Mon, 9 Sep 2019 10:37:46 +0000
Message-ID: <MN2PR20MB297379E80B6CD087822AD9CDCAB70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567582608-29177-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190909073752.GA20487@gondor.apana.org.au>
In-Reply-To: <20190909073752.GA20487@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c2eab10-53c8-466a-ac34-08d73511c0fc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3040;
x-ms-traffictypediagnostic: MN2PR20MB3040:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB3040A5020122E861A7025CABCAB70@MN2PR20MB3040.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39850400004)(396003)(136003)(366004)(189003)(199004)(13464003)(486006)(66446008)(64756008)(66556008)(54906003)(6246003)(6436002)(7696005)(15974865002)(229853002)(76176011)(86362001)(99286004)(4326008)(14454004)(9686003)(55016002)(6306002)(2906002)(53936002)(33656002)(446003)(11346002)(966005)(6506007)(81166006)(74316002)(3846002)(81156014)(6116002)(476003)(53546011)(8676002)(25786009)(5660300002)(7736002)(186003)(71200400001)(305945005)(26005)(110136005)(478600001)(66476007)(66946007)(52536014)(71190400001)(66066001)(256004)(76116006)(102836004)(8936002)(316002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3040;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V6Q++WKViNPaVjYrEYK/E/0dwUpMBvRSulbJCNg4qZ6AknR5cRFDIF+vLf/xX9SFeqqKLvhGyLhDnIlGTKLoHClCZqv3XpY0oOmRnPaqEEq4j7nAtXmEaRxUJ4higN2CqOmJxPqj2ApvEkFa3DN5JB7lKvf//MI/mO0q3r7jeT8pOMNBuKtLPpv4syiTX2BYs0BpW+qDk89Et59J9b4ICWs8OM0cJDMFXrYj8o+DW3t8UeWaIrsE3vuNAJQiPbkh5oBRCVVhD3YSiOZSvDnybiCIOYSeP2iN8kK7y+PnT/ENCSZ+yA8EyYBo/zZ7eqtzGqDX4Y0rRFk7bTIn6x/0ejTE/kKyugYuDSIsWS775nSB6BQfqs1tAyoqP+pPrRdXVMsU/M5jSp3rAz8xadTqGmcdIr2OtrUjmXs79b7rAUE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2eab10-53c8-466a-ac34-08d73511c0fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 10:37:46.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYhpGcSbJ/2r4W+2sfZPn8yQi23P3LRE9c1ey+JnimwbpcIL+42aOCQ2b+LEl1ZLAd852i1EsiW5VC4Br0ZpxfoTPFLSqsLIh/sUBwbGIEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3040
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf
> Of Herbert Xu
> Sent: Monday, September 9, 2019 9:38 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net;
> Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 0/3] crypto: inside-secure - Add support for the CBCM=
AC
>=20
> On Wed, Sep 04, 2019 at 09:36:45AM +0200, Pascal van Leeuwen wrote:
> > This patchset adds support for the (AES) CBCMAC family of authenticatio=
n
> > algorithms: AES-CBCMAC, AES-XCBCMAC and AES-MAC
> > It has been verified with a Xilinx PCIE FPGA board as well as the Marve=
ll
> > Armada A8K based Macchiatobin development board.
> >
> > Pascal van Leeuwen (3):
> >   crypto: inside-secure - Added support for the AES CBCMAC ahash
> >   crypto: inside-secure - Added support for the AES XCBC ahash
> >   crypto: inside-secure - Added support for the AES-CMAC ahash
> >
> >  drivers/crypto/inside-secure/safexcel.c      |   3 +
> >  drivers/crypto/inside-secure/safexcel.h      |   3 +
> >  drivers/crypto/inside-secure/safexcel_hash.c | 462 +++++++++++++++++++=
+++++---
> >  3 files changed, 427 insertions(+), 41 deletions(-)
>=20
> This does not apply against cryptodev.
>=20
Grml, looks like I forgot to include the previous commit.
My bad, will send a fixed v2 shortly ...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
