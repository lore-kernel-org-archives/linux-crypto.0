Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2326EC48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D98072080C
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:29:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ekKR2wGh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfFYP3k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:29:40 -0400
Received: from mail-eopbgr750084.outbound.protection.outlook.com ([40.107.75.84]:61192
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729683AbfFYP3k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 11:29:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2QLjXxSskHvhE/VQ4JWJ8YKsQvJ7w1VtQlKklHJpSQ=;
 b=ekKR2wGhLrd5rHhSul9cGPeN0G+lwZVGY/894Zn0FqxQB5VzqMvs7EEMnfVCjiR08ZhtB6ZIioyLJ0TyghRcltihFvyXcZBlYjAs9soR06vkW1Rt4Evn1hcQrdhDkwK4+FgIQZq3OzYog3Ht368OC+/wqVgO5w3TitH3UK/OOUg=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1625.namprd12.prod.outlook.com (10.172.37.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 15:29:37 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 15:29:37 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Jonathan Corbet <corbet@lwn.net>
CC:     Joe Perches <joe@perches.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
Thread-Topic: [PATCH 0/3] Clean up crypto documentation
Thread-Index: AQHVKsAU8eHDVMznu0yUy7vS0v5gPKarMRwA//+2CwCAAFp0AIAAAkMAgADH8gCAAFk9AIAAGwiA
Date:   Tue, 25 Jun 2019 15:29:37 +0000
Message-ID: <78d6f34e-79b0-4576-5869-20fed4b1f911@amd.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
 <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
 <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
 <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
 <20190624143748.7fcfe623@lwn.net>
 <d0803cdf-e4d8-102a-d67f-d3a32a4dfff0@amd.com>
 <20190625075250.3a912863@lwn.net>
In-Reply-To: <20190625075250.3a912863@lwn.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0017.namprd04.prod.outlook.com
 (2603:10b6:803:21::27) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85b51684-c24c-4c6d-577c-08d6f981ee7a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1625;
x-ms-traffictypediagnostic: DM5PR12MB1625:
x-microsoft-antispam-prvs: <DM5PR12MB16257851C37C8D3DAE0CCF8DFDE30@DM5PR12MB1625.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(376002)(396003)(39860400002)(189003)(199004)(6512007)(486006)(476003)(73956011)(99286004)(316002)(66476007)(66556008)(64756008)(305945005)(66446008)(54906003)(6246003)(4326008)(81166006)(8676002)(7736002)(81156014)(14454004)(8936002)(4744005)(66946007)(2906002)(446003)(229853002)(6486002)(186003)(31686004)(11346002)(2616005)(53936002)(6916009)(5660300002)(256004)(76176011)(52116002)(31696002)(71200400001)(71190400001)(478600001)(68736007)(14444005)(36756003)(6506007)(6436002)(72206003)(53546011)(6116002)(66066001)(386003)(3846002)(102836004)(26005)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1625;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Jw27cmu7t85FRx77TJBE1wkV6OrF1dfU1MmSrJvKxI1eg7hPrsFI01eW+E3K4cV7KgxNa+Mm9wN+HetsCFt0Z2pH1qCSDNIicXcNsn132ktEmgG7A+WpPldl0obdJM8ZYQUFbDu69/pVJ215+8VI9gMdjzyRuo1y4Ro06y8WJBP1X04TQGisNaGbhtxqXQJ2e+tWSQ38F/xyzzc0qK9rL/Gy3BgHbbJMHeI06ONoWw4wc0fDu6JxMlSVTfig1HFkkRDyEpHMx5tW07bcSE/ino5dtvYXeFKnJCXfH3ooKF+RZhjN2obb1wJeoOMDv2voSMoIoFRNTNGdwvG/B1EToydktyCRp6koocS9GuqP+HpslLzy4BA6a6n2JUY7G6TeaKhtmjy4o2fwG2NwFHEKI1VsOODV96J2bMd3WCOtbE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5906E554D4E05B418672651394248BC1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b51684-c24c-4c6d-577c-08d6f981ee7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 15:29:37.0539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1625
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNS8xOSA4OjUyIEFNLCBKb25hdGhhbiBDb3JiZXQgd3JvdGU6DQo+IE9uIFR1ZSwgMjUg
SnVuIDIwMTkgMTM6MzM6MjcgKzAwMDANCj4gR2FyeSBSIEhvb2sgPGdob29rQGFtZC5jb20+IHdy
b3RlOg0KPiANCj4+PiBJdCdzIGJlZW4gInZhbGlkIiBzaW5jZSBJIHdyb3RlIGl0Li4uaXQncyBq
dXN0IG5vdCB1cHN0cmVhbSB5ZXQgOikgIEkNCj4+PiBleHBlY3QgaXQgdG8gYmUgaW4gNS4zLCB0
aG91Z2guICBTbyB0aGUgYmVzdCB3YXkgdG8gcmVmZXIgdG8gYSBrZXJuZWwNCj4+PiBmdW5jdGlv
biwgZ29pbmcgZm9yd2FyZCwgaXMganVzdCBmdW5jdGlvbigpIHdpdGggbm8gbWFya3VwIG5lZWRl
ZC4NCj4+DQo+PiBTbyBJJ20gdW5jbGVhcjoNCj4+DQo+PiAxKSB3b3VsZCB5b3UgcHJlZmVyIEkg
d2FpdCBvbiB5b3VyIDUuMyBjaGFuZ2UgYmVpbmcgZnVsbHkgY29tbWl0dGVkLA0KPj4gMikgYWRk
IHlvdXIgY2hhbmdlIHRvIG15IGxvY2FsIHRyZWUgYW5kIHVzZSBpdCwgdGhlbiBzdWJtaXQgYW4g
dXBkYXRlDQo+PiBwYXRjaHNldCB0aGF0IGRlcGVuZHMgdXBvbiBpdCwgb3INCj4+IDMpIHJlLXN1
Ym1pdCBub3cgKHVzaW5nIHRoZSBjdXJyZW50IG1ldGhvZCkgd2l0aCBzdWdnZXN0ZWQgY2hhbmdl
cz8NCj4gDQo+IEkgd291bGQganVzdCBub3QgbWFyayB1cCBmdW5jdGlvbigpIGF0IGFsbCwgYW5k
IHRoZSByaWdodCB0aGluZyB3aWxsDQo+IGhhcHBlbiB0byBpdCBpbiB0aGUgdmVyeSBuZWFyIGZ1
dHVyZS4NCg0KRG9uZS4NCg0KSSBhcHBsaWVkIHlvdXIgdHdvIHBhdGNoZXMgKGxvY2FsbHkpIHRv
IHZlcmlmeSB0aGUgcmVzdWx0LCBhbmQgaXQgbG9va3MgDQpnb29kIHRvIG1lLiBJbiB0aGUgaW50
ZXJpbSwgSSB0aGluayBpdCdzIE5CRC4NCg0KVGhhbmtzIG11Y2guDQoNCmdyaA0K
