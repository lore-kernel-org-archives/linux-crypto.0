Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5756C04E87
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4AAC20843
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="yKkL2Wsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfEOMIu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 08:08:50 -0400
Received: from mail-eopbgr00125.outbound.protection.outlook.com ([40.107.0.125]:16712
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729013AbfEOMIt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 08:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ok6L14Y9/R5DwRnQNKHtnEVy3k7yr6CNuBBSCjYBDmQ=;
 b=yKkL2Wskb6YEEkEUgMhC2mssHH5uwWULB8aTs/HecwuOliA7Y2BXSseTsUo2hlX5v8OSpsx4e20QekwuggZTCMSMNfuO42G7L3RpxoBWPVYS6HrbFlIGjH6lb0rb0C05YsmfLH0nAc40P4I9xYTmOnTUz911dXHymiUteWxBcT0=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2343.eurprd09.prod.outlook.com (20.177.113.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Wed, 15 May 2019 12:08:45 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 12:08:45 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Can scatterlist elements cross page boundary ?
Thread-Topic: Can scatterlist elements cross page boundary ?
Thread-Index: AQHVCxWZM8QdxfEMKUaZKL/grh3qu6ZsFtDw
Date:   Wed, 15 May 2019 12:08:45 +0000
Message-ID: <AM6PR09MB35234E6A537053A542A65E4AD2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <798a42c9-bcda-6612-088c-cb90c35a578f@c-s.fr>
In-Reply-To: <798a42c9-bcda-6612-088c-cb90c35a578f@c-s.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2bbab9e1-4819-42fb-15e3-08d6d92e147e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2343;
x-ms-traffictypediagnostic: AM6PR09MB2343:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB234343ED9BB87DFB9805E9FCD2090@AM6PR09MB2343.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39850400004)(136003)(376002)(189003)(199004)(73956011)(102836004)(64756008)(66476007)(305945005)(66446008)(7736002)(4744005)(6506007)(186003)(110136005)(6246003)(66946007)(33656002)(478600001)(229853002)(55016002)(6116002)(3846002)(4326008)(99286004)(26005)(74316002)(446003)(76176011)(7696005)(9686003)(66556008)(81156014)(76116006)(8676002)(476003)(8936002)(86362001)(15974865002)(6436002)(66066001)(316002)(256004)(53936002)(14454004)(11346002)(52536014)(5660300002)(2906002)(81166006)(71200400001)(71190400001)(25786009)(486006)(68736007)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2343;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /UPGDd1oC27/xO0Ua7ApE/mzCfAPf2YzeCV7kizXpFE9JPzJypZpLQlWy9JZAPUG8E3yowPNXQC9wS8r150cEXSmLGRXNDCKmUYRs7IvT1togNwphlYyvGVRrjhuEtjNhTxFfuexmvTc1T3/tj81dZwjA8Pm5yEvV0NkPxbeva9zGuQjzPDFA+SCwyQMFxWUJECGtdXNuFAqp/14LHzHpeLg4b8Kozb2iiH8GOUY6R5sanE2hM577xhlYYFpQcxitGHzLCmGvk3PfRuqQvYpdhKeXx2suTA9qfXXfL0mxzTfgQlhBdf6jywEj3kGKXqA9HMvmKglvsutw/SJhZvUzDV4OftkaW4+fvJf/bCATqP2P0ule5+ttBoyBtSyIgbdlI6G9JZqnZ5mcT5tcDNaamBQw840xnCl8c8hkVCnlTI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbab9e1-4819-42fb-15e3-08d6d92e147e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 12:08:45.3505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2343
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQ2hyaXN0b3BoZSwNCg0KSSByYW4gaW50byBhIHNpbWlsYXIgaXNzdWUgd2l0aCB0aGUgSW5z
aWRlIFNlY3VyZSBkcml2ZXIuDQoNCklmIEkgdW5kZXJzdG9vZCBjb3JyZWN0bHksIHNjYXR0ZXIg
YnVmZmVycyBkbyBub3QgbmVlZCB0byBiZSBlbmNsb3NlZCBpbiBhIHNpbmdsZSBwYWdlIGFzIGxv
bmcgYXMgdGhlIHNjYXR0ZXIgYnVmZmVyIGFzIGEgd2hvbGUgaXMgY29udGlndW91cyBpbiBtZW1v
cnkuIFNvIGl0IGNhbiBiZSBtdWx0aXBsZSBwYWdlcywgYnV0IHRoZW4gdGhleSBoYXZlIHRvIGJl
IGJhY2stdG8tYmFjayBpbiBwaHlzaWNhbC9kZXZpY2UgbWVtb3J5Lg0KDQpUaGUgbGF0dGVyIHNo
b3VsZCBiZSBndWFyYW50ZWVkIGJ5IHRoZSBrZXJuZWwgYWxsb2NhdG9yLg0KDQpSZWdhcmRzLA0K
DQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2Nv
bCBFbmdpbmVzLCBJbnNpZGUgU2VjdXJlDQoNClRlbC4gOiArMzEgKDApNzMgNjUgODEgOTAwDQoN
Cnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg0K
