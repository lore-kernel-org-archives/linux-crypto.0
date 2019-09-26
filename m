Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110E0C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD304222C3
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 14:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="GU6KwiuE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbfIZOzm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:55:42 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:35771
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfIZOzm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 10:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCPajwMGNdv1VqqjlGJwr5lfsv7oV2jfKOEBKCIT+MID4QhWCLhhI4thZDg+cQzLa9EbhPCDrCrBoFTN5R9VD1QY8LhXe4jQsLEMJxzoZ66GgtUSFvHzWIf07y7WfBz6pVRaOanztfBvwA15mRNUuS65M/vIU+ixZ/TvOHUTX0/bIOyQ0pCM9IrRv/GzqJP6PCu4wzD+x8nb7OlMEJc79oAJm0XuTSiE0MVXUcz2sXMhqilrGmi+8tSO65Eh5hWmLpYpf+rCkFbtUMdSJ0ZoGvTkKoNeTM8J/CNaQ295h8BsgWuKmDV5RufzTMW2NxSnU0Wltq4ZnQehaWh19giUyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeqU0Dfr2MG63UGMXkI2PcQFiu1YlYqvBwKEAwTJJoQ=;
 b=JAjuYTQgA53EBdif5m/MFhLqv5+DixIx8+GLQubxkldoXL+qKId+TWofxqKhXHiGInI7nyr0SEVeUDCAtND2axHc+EQBJhoX3fTuuYT96FT/FKlncBlzrTsD0rvbsS7J6PXWLifhbniPoSS7zHeTpWseURWI1lYa2fJhLL3e596uM1Bti/NregwH7vWD8u/vweyUgYOW0Q4DL9Cxtq2zelgn5EW53TF1+/CzK75Gt3tRNWgbgWQA0sk6Jhfs24mlRZadeMOs/cN6ibjFcno84a2SiCrQcoMS4Y8jNpmMNjOlsy113zKNmF3LZnxS8wqmhlMSOKH0nLG0aja8k/KSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeqU0Dfr2MG63UGMXkI2PcQFiu1YlYqvBwKEAwTJJoQ=;
 b=GU6KwiuEKzalVeXtopr+K49v1B2v89hIm1eY/Oj0q+s1Gr3Api1oy3UzWKYgEhHpKpxP3qGv/creYEHs664EGAnoZWFjIQ7nnCMJj2STsAWHi1sIqb6dxo6aHUtEPS74S1YRdzib/x7DrD7Yt54cgWkCW3LSXhnUOB+aiBiH7XY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2719.namprd20.prod.outlook.com (20.178.252.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 26 Sep 2019 14:55:38 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 14:55:38 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Chacha-Poly performance on ARM64
Thread-Topic: Chacha-Poly performance on ARM64
Thread-Index: AdV0eUDF0FX1qai/QZmAhLVFbJDbJQ==
Date:   Thu, 26 Sep 2019 14:55:38 +0000
Message-ID: <MN2PR20MB2973C550AC7337ED85B874D8CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1c32421-aae8-49d0-c8f6-08d742919825
x-ms-traffictypediagnostic: MN2PR20MB2719:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB27193672AA6035FDDCA33A1BCA860@MN2PR20MB2719.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(199004)(189003)(86362001)(15974865002)(14454004)(478600001)(4744005)(476003)(9686003)(6436002)(25786009)(5660300002)(71190400001)(71200400001)(316002)(2906002)(110136005)(52536014)(66556008)(64756008)(66446008)(6116002)(3846002)(256004)(8676002)(81156014)(81166006)(8936002)(66066001)(486006)(55016002)(66946007)(66476007)(76116006)(6506007)(7696005)(26005)(102836004)(99286004)(186003)(7736002)(305945005)(74316002)(33656002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2719;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M/rTy3BmA3UU5zJ4ALThk9ARZQYjTJlIpARwwUqsGiHLP8PQiT5/X/Sw+qBXTCA9zGG2WA+8GuqctcaitkNLlLU6+9Z0J6T+IZ1n8Zy7p8hLF6uictRELoUR7Iu3H0R0roEPn6DLRWzAkBAtYrR/UUfzXeoGp5IPsSjMhPEym6+4qvtw0OlJjlmzTECEjXsLEC9GdnnBcd1tBZOSPTJotB0ivljcyLNYsT9jHc/lb5NBWuFLy02bptpr/N4KId5zcPP3qleoGDgPwLkecMyxmPkjJxrJ5/8Ow8x/Gl3t6YfnfBIqEdNXvOjaAdzbqk3Qt15guKkt8A+joB0DDaD/aTFwI3geFS3MfOFgXN+0a7q6+GAFIowVSdijmAADNwYo2FglYyW2fbalFJP7VDQmVbd3qh8CAsJXN7HGHrvq1Sk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c32421-aae8-49d0-c8f6-08d742919825
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 14:55:38.4030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3X0+QnHQfVl8TG9Jj+iI9VY5xuuBXQ8r/jADgJtpA3AY0RQelhbBinjDcBgf8Tlaxof7wQFr8fuVZWi+U359p89WEc/OoeaMWzsAE3ixUh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2719
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I'm currently doing some performance benchmarking on a quad core Cortex
A72 (Macchiatobin dev board) for rfc7539esp (ChachaPoly) and the=20
relatively low performance kind of took me by surprise, considering how
everyone  keeps shouting how efficient Chacha-Poly is in software on
modern CPU's.

Then I noticed that it was using chacha20-generic for the encrypt
direction, while a chacha20-neon implementation exists (it actually
DOES use that one for decryption). Why would that be?

Also, it also uses poly1305-generic in both cases. Is that the best
possible on ARM64? I did a quick search in the codebase but couldn't
find any ARM64 optimized version ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

