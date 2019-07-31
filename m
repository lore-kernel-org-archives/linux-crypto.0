Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD53C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95B320C01
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="fPN5Xd7Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfGaQkq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:40:46 -0400
Received: from mail-eopbgr810050.outbound.protection.outlook.com ([40.107.81.50]:3536
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726908AbfGaQkq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:40:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AS1aoeuZf+SUL1mkXa9nufCo6mQhSzN+vPrLKDQGdlMnIYn2WWv4TIZ6JkM37NHpwEcjNN40YPaEWxvtvAEeVvH3XTQyGohRViLD9NEunXYf8+hOh/XwO8Bk66IMYWO+Gz4+AlfKsm8QWyuDVvyVotfTz0fRlJwhbUPtkpHXMbzeJ1FMV2u0YEF1ZmeahUfme6UYi5s754pBSF9s9lnSA3reqYY3Og+pf7y+L1VHL6BO8fnGU+e5L7LGoFxX4kfMBWLtVVMgKU5Oh5uojPmL7lMbbrI4hPopKyhlgi0JQOm3KVzUrCNbgCM7rW9Rip+yGMCDUm7ZQtfdU7KCDBERvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXXy2oICXVirlHDvHqg5byr3LK82gj+HP6aJa07Xvyc=;
 b=gwqtIU5UUJzDNexPO4Fnle3vugdDONIxemUePJ2Aw6LmVXbvpo5otXu+yvN7jzbxlDAR5r+sOOImW2eHCir7m1O8qrT/7Yyd6nVVOW6XMEncQ7y5+T1K0qsty6LMzJfWH+MSc/2tpcSf8g7vNIW6EATvO5tA3AaywnXkTBAkLZLCiTDFNcBLdeDIO5j3qxhDC0uYL89ly/QIsGlkTbv3ytizu+e8k6YfigNBG5d51rTDOlKz+gCbTwfkHwD/ALVR/QGXMT4DewNW42lOid7tASFFJM9TKh6xYWyqauClZvQnDoP2W1IFbhU/zyuNtMXFIBUKO8b81Ev4JXah3dtfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXXy2oICXVirlHDvHqg5byr3LK82gj+HP6aJa07Xvyc=;
 b=fPN5Xd7QZ+n/436e8P2u7tlw+y/0zPMCP1UrYBQw9eRXBur/EWCsmSAspVWVCLIgBw+qvbgf7DUcPI9qFcWMyYt8uk2PNBPe6BDfkEm8MzPUQGtK1oYNgr4yIgTbMV6nQW0e9ZrB9eVKeQGIp5PryV5xInSov+q5ClZFY0R8aJg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2654.namprd20.prod.outlook.com (20.178.252.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 31 Jul 2019 16:40:44 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 16:40:44 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Sent out some incorrect patch mails for crypto:inside-secure, please
 ignore
Thread-Topic: Sent out some incorrect patch mails for crypto:inside-secure,
 please ignore
Thread-Index: AdVHvgkZ/1X58xPQRnqRcAQ6q9e5xw==
Date:   Wed, 31 Jul 2019 16:40:43 +0000
Message-ID: <MN2PR20MB297319C3B890B338D5F21005CADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9317ec8d-3826-4112-6585-08d715d5d4e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2654;
x-ms-traffictypediagnostic: MN2PR20MB2654:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2654CC9CF3ED37B3EC9704B3CADF0@MN2PR20MB2654.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39850400004)(136003)(199004)(189003)(256004)(14444005)(55016002)(486006)(478600001)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(76116006)(66066001)(14454004)(53936002)(9686003)(52536014)(6436002)(476003)(71200400001)(71190400001)(4744005)(81156014)(33656002)(81166006)(15974865002)(2906002)(26005)(2501003)(8676002)(5660300002)(186003)(8936002)(74316002)(3846002)(6116002)(110136005)(68736007)(6506007)(86362001)(7696005)(102836004)(316002)(305945005)(99286004)(7736002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2654;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sXJkCGKk+rYBiS5ZwZahP/ReBjBYil3oz8cx+LryI9fxLhqH+ovwxEpSjm4F4fpOuva0IMO5k/d4vWzW3C2WrCAHbPZnx3L4Y23XQ5im85Nph4+idNWVk12K4pzXQ2e93ZMVbPxi3Ktyxci0K5smbL6PSozyO622hNcHqvx1diiUKJK1tAlWGSGxUBqRx9lH1fQNRxMTcywH0ojhjkgduF/yOHGUut4y9d676/8UpxjkgVKumcjImrH1hgF5yBTEm2blPskXjesvuZ00HSGw1dSF+cSNC5kEThgPA8xAhGZMJit1SINc5uJtGG9BHVIdVJm/r/A3p6UyKWCMU/vWjxndsY8hnRL+cS6X1emX2e/7yhUvz6A/d8YeAKZY8ObQky3FXKBxrV2k8dfa8Q9I2whfkZo0wgfWaR6M+eAx9mE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9317ec8d-3826-4112-6585-08d715d5d4e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 16:40:43.8577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2654
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I just sent out a batch of 5 patches for crypto: inside-secure that=20
still contained some errors in the header (missing patch version,=20
incorrect e-mail address).

I resent the corrected version immediately thereafter, so please=20
ignore the first set of 5 (recognisable by having my old insidesecure
.com email adres in the From: header line, instead of verimatrix),
and take only the second, corrected set of 5.

Sorry about that.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

