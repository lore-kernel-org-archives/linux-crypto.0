Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9E4CA9EB5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 09:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D17320873
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 09:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="wjepVp+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfJUJDj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:03:39 -0400
Received: from mail-eopbgr690063.outbound.protection.outlook.com ([40.107.69.63]:29253
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbfJUJDj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 05:03:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF/ycDtwdFYvyY4k/DzAvb4y9iUvfjB1nS4S2MBjOaWEAFf2RAMxcBYqdA6VYHc2sSltwpw2nVckABDhZ0bNdp55/IOs9OIQPA1dz2VNtNJ1cWMZtGtcpT0lYz9huyJgCFSy/76DqHTWZlsbS2tE6D2uMhQfZjFOHIfWKDOhM8ZwBZ5pKFgU1Ut/hZFr7Y2WjnsEKWlS3QosRAcu1Qr0aBv0iP+RCsGg/pg6K01kZD1hGdQHjOZdU5qWSPA9e9q0pMi0UXNO5TT6fdzcR8umLpsC/DK0Hehd9PrdbXuoIrmThW5jRJpwQqIQ68Iy9mE8GMaY/14FQR1jHPdqLNr8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vrMO/iffFeQPMvNWyCaQC9DMiiiYajSsbeyUmHryMk=;
 b=LVOkc/TeCjIcoMntoJKJCdW8XYtedKqH+BzFXqGxcepQiwBBT3rI+EU60X+bSEdvHk3wtXPZE9anAOKt+ReH1/NAKI5OSx6VWFXbKL49OfA284Gnd617oFJVzQ/lIuuxjRN0reObwgBV4WtNpzFeSUukRtGhhlYGEd3EjxpO+dmVviDYctw5K2hfroUACsoUrl0CGss8dZEVAcmm/sToXIMVTG/AIzao2nGQYWYkOrI906K9W85zDhsLR3PwDG0vttTyKNBESfVm02zFooouT969yFebPj2k9ZLoUdkn6lShrEhCFaYIt9b1sCXO2334ejqy6aJooVUAaAUP3LCAqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vrMO/iffFeQPMvNWyCaQC9DMiiiYajSsbeyUmHryMk=;
 b=wjepVp+H8x8V9Vnh2TlLj+5gEusdeM/E0yQhQORFgZXy+3rZ77ouIuM90cqr9JH6MsHr384XJohjsydzVCAnX8/k8iuAJGkORU1vWLnp3zKf5EcJNy4+EPqRM2ff/uGreuye+D+3WQh44KIyBEqx1u6ucdNv3tcwfATCoS5q8dU=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2PR20MB3160.namprd20.prod.outlook.com (52.132.229.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 09:03:35 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae%5]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 09:03:35 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Key endianness?
Thread-Topic: Key endianness?
Thread-Index: AdWH7WiyGB6aVNy7SJOkTaAoiPGHOg==
Date:   Mon, 21 Oct 2019 09:03:35 +0000
Message-ID: <CH2PR20MB29688965C9584C94F6FA98A2CA690@CH2PR20MB2968.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 849f1281-048b-4f57-e9de-08d756058e07
x-ms-traffictypediagnostic: CH2PR20MB3160:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR20MB3160728AC57942AA40FC98FDCA690@CH2PR20MB3160.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(346002)(396003)(39850400004)(199004)(189003)(81156014)(5660300002)(6436002)(52536014)(74316002)(256004)(8676002)(6116002)(3846002)(478600001)(81166006)(14454004)(86362001)(2501003)(7116003)(6506007)(4744005)(7696005)(99286004)(102836004)(3480700005)(15974865002)(71190400001)(316002)(9686003)(7736002)(55016002)(33656002)(71200400001)(66476007)(66556008)(305945005)(25786009)(26005)(66446008)(64756008)(476003)(2906002)(66066001)(66946007)(76116006)(14444005)(486006)(186003)(110136005)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR20MB3160;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kRN5SLH1o71hZoNhozo9p0y+7VefZ4Cq8VIkg/BUOqpIZbhky1QzXpsLeFIp1s6kaPG7I2IIUFdbkgPKFfqNuOAcmpGRsGurvt1VJsk4ay7ZX3AzhjGPZFy7xw2vgqNUC18N6/Mx152eX1GI42ArTfqmH9pAX0It4avk+C6MDKRUMZKBojovCCnuwcvoEnWUIsFomuN2heJlB5EaUa1sWHeuxJfgH0gkcpJZJ4OC4QktFwxxZviQ5cuSx/+EGc6TgJf9DmMAc/OENUwrYmPa4FuPJmSzYIJGvLiLpYQueZ0mSCwo0IHQUZV71fcceejizKUPCZ73QOtaPEttxr+hlUCUNwuFnEflkOTpLeVDCvkBj5SMrYxaOmbEadmGjf/TvOhH6uibVtLt8vsYcpm4y09PpjR0/1Bg+nN8j6LS/UE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849f1281-048b-4f57-e9de-08d756058e07
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 09:03:35.2054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PLMvWTBQplfKTC6qhj87lGK/h29pXwHBgduCZNfsSzf+Y4ZTCCtBHHshqP/J8irJgmhwsDQb/Sz+mPShWk6PnOr6Z2nwXV98RFCljCZkdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB3160
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

I'm currently busy fixing some endianness related sparse errors reported
by this kbuild test robot and this triggered my to rethink some endian
conversion being done in the inside-secure driver.

I actually wonder what the endianness is of the input key data, e.g. the
"u8 *key" parameter to the setkey function.

I also wonder what the endianness is of the key data in a structure
like "crypto_aes_ctx", as filled in by the aes_expandkey function.

Since I know my current endianness conversions work on a little endian
CPU, I guess the big question is whether the byte order of this key
data is _CPU byte order_ or always some _fixed byte order_ (e.g. as per
algorithm specification).

I know I have some customers using big-endian CPU's, so I do care, but
I unfortunately don't have any platform available to test this with.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

