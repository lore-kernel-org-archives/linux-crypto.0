Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBFDC282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56B52087E
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="Tb/RdRxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfDVLaA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:30:00 -0400
Received: from mail-eopbgr00113.outbound.protection.outlook.com ([40.107.0.113]:56581
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfDVLaA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 07:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkaWBrYdcYygl6GLc4VNfTLOhR2w7F45gxlrM9wX0Ko=;
 b=Tb/RdRxM9Iv3V6R38TIXlI0MoIPaY8RRisvur0kJZikX7U+mdEBhiiipXbG0/OnZ/mOowziHFrJVCVSgmmB8yLw/oT2Hfy5OuCWijb/NsHNEdnj8PnTpp8h6slvvI4VpLjqNcNP0h92HkI3yDQFNprGN8zCgwcysatz/oOaN0oE=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3489.eurprd09.prod.outlook.com (10.255.97.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.11; Mon, 22 Apr 2019 11:29:56 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::94e3:32d7:8d9e:6fbd%5]) with mapi id 15.20.1813.017; Mon, 22 Apr 2019
 11:29:56 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto API AEAD question
Thread-Topic: Crypto API AEAD question
Thread-Index: AdT4/Y7mFd5RreNlQVW/PztzOVz2dg==
Date:   Mon, 22 Apr 2019 11:29:55 +0000
Message-ID: <AM6PR09MB352327ADDE2D1CA8B8E7C99CD2220@AM6PR09MB3523.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93297dc0-1fe3-43f0-8719-08d6c715d8db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB3489;
x-ms-traffictypediagnostic: AM6PR09MB3489:
x-microsoft-antispam-prvs: <AM6PR09MB34890F84BD6FC8CAF759BDDAD2220@AM6PR09MB3489.eurprd09.prod.outlook.com>
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(136003)(39840400004)(346002)(189003)(199004)(97736004)(53936002)(76116006)(102836004)(4744005)(5660300002)(4326008)(54906003)(316002)(99286004)(6916009)(86362001)(66946007)(6436002)(64756008)(66476007)(73956011)(66446008)(66556008)(68736007)(7696005)(9686003)(52536014)(55016002)(6506007)(8936002)(256004)(81166006)(33656002)(14444005)(8676002)(14454004)(25786009)(3480700005)(71190400001)(71200400001)(26005)(74316002)(6116002)(66066001)(186003)(7736002)(305945005)(2906002)(476003)(3846002)(486006)(478600001)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3489;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V8hxcyMp2b6VseDDqA3buP7KO07d17c3XuX9NwPqI0jR87MqCkN/Yp8yO9NmdF2iLft4R8yx1XuL6FRsQvILQEa6xRqPpDN7ZWXLrV7YnkY89R9JiKyKjkXDtl+kujRXIoAibcR+fA+EltTcIOO0RQDgHIaUta/aGyk/t6O62Dp1+Lk8cuqER6pjtLZzP4HFPfjxnriVlzvjJTuJXzbAA8Ie4UrIwDOMo3tb6iJLcyAHDSaNtGwH19EO09FjrdcXSJqHL6wxWJJKRC8yPnys+DDc37jA6pp0XBPiImQ2PuhvBuuwpZtp9mX/TDbxrFDIHUBi1+cqdodfy7n7tLg9fZlzluIg8TLYrD5d1p1W83XtGWF4AH5V/Hs6P/r+t1QBn5673RCApuI+bTfirbrmx9tk2KnqWTIt5+ZIYmVt6iw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93297dc0-1fe3-43f0-8719-08d6c715d8db
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 11:29:56.5349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3489
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

While debugging some AEAD issues with the inside-secure driver, I couldn't
help but notice that the testmgr is NOT checking the AAD data section of
the result. And when I added that check myself, I saw a lot of implementati=
ons
failing on out-of-place vectors, with the poison data still present in that
location. So am I correct to assume that the implementation is NOT supposed=
 to
write the AAD data, but skip over that part of the output buffer, even if t=
he
in- and output buffers do not overlap?

I wonder, as the current inside-secure driver DOES write out the AAD data a=
nd
I guess for us this is the natural way to do the AEAD transform so no one e=
ver
just thought twice about that. Also can't find anything specific in the doc=
s.

Even so, for the in-place case, checking the AAD data would ensure the cryp=
to
implementation didn't *accidentally* corrupt it ...


Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure

