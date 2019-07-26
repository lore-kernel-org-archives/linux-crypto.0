Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA24C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 11:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971FE216C8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 11:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="VHn+lZsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZLdN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 07:33:13 -0400
Received: from mail-eopbgr790042.outbound.protection.outlook.com ([40.107.79.42]:52288
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfGZLdM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 07:33:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dhy1amP+EwfvxUYQlWAljxdyQj7rq4nYlQpDsIJ14ZXbO3lpfsu+1Qh6XLIL6sQ5yiFWdcZjFFWBAncoy+RERFLhxlGQGTH4rNwkcgULn0+SJ+emG6r6z77BH8ruvEDqz8SMuW4u/WSV/q0cELX2J8aZWEoxM8joJKP+0OadUcwoGCTSVi4+wrNNSySCWYLREGxPRrLTnCl2dxt05Axy5wSegTPcKRS8pYLmkxxXVfWJRqCQN2CUeGD4O8L6c5vd8XylhYMlD2WOxFW+WOo4gJVPcLrOyXHSWTMap6ppD1UBkYD5EGxc0U1uZvueCxGRwSJ8N2AwMvX/yWJY55l5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDGr0Mfqb8nHnBeux66O4qj3KI4qk/+CIPutITGvFpw=;
 b=nQkDphuyvUWmMEZksA1f1bbEyVP7amb/0RMcgILH55uABYtSLuxFIR6JjwOXaOgCyo0txvpf2tibONKpL3TVa0Gu8GoFmfNntuJ1arlyeToEwKl/sK6ZiGR5ptph0blKzpaW8DvU0OUvo4hUIAV9MHsrTYzq//r/wfkM0jppzIVIlati1YkuTn4wtVG5juW4OJYgY2UnzhvuuXy6P/Hirzx2U5XCtB2V/U9/PKeQprFZvJIajVzVO7yQiSYEaOVdU7SirvleeLmLVpMBYroINMc4mxA9gnl8i1ATGKviz90Nkk/ZX7/4x3d2Tz9QdqusL0vbywQHNZ7zc+RxwBQyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDGr0Mfqb8nHnBeux66O4qj3KI4qk/+CIPutITGvFpw=;
 b=VHn+lZsBNZGssIIUucDQMFVGz9kk4GiXIKo8N9X2pdHVtH3P21MpTEC5pD77BQGxiV7O/Swuwb+kq///9HiHvK6r7i2rFJcpzGaClnicyYRJxDUNqUoMxxAFz3y7S3Fa8QI7fuO9ehhufXTybm+dE4wHx61qRplNsvYashXd9ao=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3005.namprd20.prod.outlook.com (52.132.173.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 11:33:07 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 11:33:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope 
Thread-Topic: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope 
Thread-Index: AQHVK2PPZerQVZ6WRkuW8hpHhbt/sKbc9NLQ
Date:   Fri, 26 Jul 2019 11:33:07 +0000
Message-ID: <MN2PR20MB2973DAAEF813270C88BB941CCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
In-Reply-To: <1561469816-7871-1-git-send-email-pleeuwen@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c955409-53db-4917-527e-08d711bd07f9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3005;
x-ms-traffictypediagnostic: MN2PR20MB3005:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB30054D1D3C300807DE5B9CABCAC00@MN2PR20MB3005.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(136003)(366004)(376002)(189003)(199004)(13464003)(52536014)(15974865002)(8676002)(26005)(33656002)(76176011)(316002)(5660300002)(54906003)(8936002)(446003)(71200400001)(476003)(2351001)(66946007)(14444005)(486006)(256004)(11346002)(76116006)(81166006)(81156014)(66446008)(68736007)(229853002)(64756008)(66556008)(66476007)(102836004)(9686003)(6246003)(2501003)(6436002)(53546011)(71190400001)(6506007)(55016002)(5640700003)(53936002)(25786009)(478600001)(6116002)(66066001)(14454004)(3846002)(186003)(74316002)(86362001)(7736002)(2906002)(4743002)(7696005)(305945005)(99286004)(6916009)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3005;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AcH1XJtwxna23A5QVAwHdlhGMN+NMaYSTA99nbukZ5TTo6+UXRQYkdyn+iiFLmRabiK6G1OvOpV/RD6gG/8RH1WVSwRxaBfB02l2qVPRrkjlQI6CETlXXzuFBSiJm+8HFF/W34s07zRFYvbicybcXJCX5DrFqkovte5uLdJXwEWAowaXWAu8pVgnfawwokfjipCy4/NQaqC3b2DDEX43++/SPJ1QsupWHo4/umVvbjIwNzdMyN2BUy+HyZcI3DG8yxYGw5osTL6X3w6/WRhaewBdkNz63qQRqYadbm7ocQDeNE5LTHj6BllknMizUgFoXF4xp2lfWTB4uiUt8h5QU6vNYj3RUHufC560PxqhIKhZ9q3CwDGapFO0+SQu+5syKGOYbHTYtrSC0N35rJAGF9HQH4TtcjiRIxKYdvsAYXw=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c955409-53db-4917-527e-08d711bd07f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 11:33:07.5456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Just a gentle ping to remind people that this patch set - which incorporate=
s the feedback I=20
got on an earlier version thereof - has been pending for over a month now w=
ithout=20
receiving any feedback on it whatsoever ...

> -----Original Message-----
> From: Pascal van Leeuwen <pleeuwen@localhost.localdomain>
> Sent: Tuesday, June 25, 2019 3:37 PM
> To: linux-crypto@vger.kernel.org
> Cc: antoine.tenart@bootlin.com; herbert@gondor.apana.org.au; davem@daveml=
oft.net; Pascal Van Leeuwen
> <pvanleeuwen@insidesecure.com>
> Subject: [PATCHv2 0/3] crypto: inside-secure - broaden driver scope
>=20
> From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
>=20
> This is a first baby step towards making the inside-secure crypto driver
> more broadly useful. The current driver only works for Marvell Armada HW
> and requires proprietary firmware, only available under NDA from Marvell,
> to be installed. This patch set allows the driver to be used with other
> hardware and removes the dependence on that proprietary firmware.
>=20
> changes since v1:
> - changed dev_info's into dev_dbg to reduce normal verbosity
> - terminate all message strings with \n
> - use priv->version field strictly to enumerate device context
> - fixed some code & comment style issues
> - removed EIP97/197 references from messages
> - use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
> - use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
> - do not inline the minifw but read it from /lib/firmware instead
>=20
> Pascal van Leeuwen (3):
>   crypto: inside-secure - make driver selectable for non-Marvell
>     hardware
>   crypto: inside-secure - add support for PCI based FPGA development
>     board
>   crypto: inside-secure - add support for using the EIP197 without
>     vendor firmware
>=20
>  drivers/crypto/Kconfig                         |  12 +-
>  drivers/crypto/inside-secure/safexcel.c        | 748 +++++++++++++++++--=
------
>  drivers/crypto/inside-secure/safexcel.h        |  36 +-
>  drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
>  drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
>  drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
>  6 files changed, 569 insertions(+), 253 deletions(-)
>=20
> --
> 1.8.3.1

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
