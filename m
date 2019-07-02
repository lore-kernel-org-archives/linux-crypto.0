Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE6FC06515
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 17:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B5AA21721
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 17:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Ohn/Puum"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGBRo6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 13:44:58 -0400
Received: from mail-eopbgr710045.outbound.protection.outlook.com ([40.107.71.45]:64240
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbfGBRo6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 13:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fSRCWSka04br5BFa9GOtxNQsN3CJ6vFXZeIfWfrYJI=;
 b=Ohn/PuumqfwfSKUfVeawFhXwJ8vCFgVVntj7KPUfsE9neP0CyZ2dusM+C8k7bxcYk3PvfaHzdeNNrhrgBs8aTjhKWc4e2g4lOnkHEYCELdsfd1odpfH9RUWPJ9OgfqATyIgBFuLFu7O46SR7TXPOK6uXLh7rH14i/HYFfGOupiI=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1675.namprd12.prod.outlook.com (10.172.34.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 17:44:56 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 17:44:56 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Cfir Cohen <cfir@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: gcm-aes-ccp self-tests failure
Thread-Topic: gcm-aes-ccp self-tests failure
Thread-Index: AQHVMPAV3h6bmoV0JkCqrQIJQtXBiqa3mdYA
Date:   Tue, 2 Jul 2019 17:44:55 +0000
Message-ID: <5aa874b3-22ad-3fc1-687c-9e02e0bd60e9@amd.com>
References: <20190702160614.GC895@sol.localdomain>
In-Reply-To: <20190702160614.GC895@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:3:115::23) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d43c8a6f-2d28-4a22-0bda-08d6ff14fe8e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1675;
x-ms-traffictypediagnostic: DM5PR12MB1675:
x-microsoft-antispam-prvs: <DM5PR12MB16750D2D2633FB301C88A70AFDF80@DM5PR12MB1675.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(199004)(189003)(476003)(52116002)(31686004)(446003)(11346002)(66556008)(14454004)(2616005)(73956011)(53546011)(66446008)(99286004)(8936002)(6246003)(81156014)(102836004)(386003)(6116002)(8676002)(81166006)(64756008)(3846002)(3480700005)(71200400001)(71190400001)(305945005)(14444005)(256004)(26005)(186003)(31696002)(7736002)(76176011)(6636002)(66946007)(6506007)(6486002)(36756003)(316002)(6436002)(229853002)(4326008)(6512007)(25786009)(68736007)(2906002)(110136005)(486006)(66476007)(53936002)(66066001)(5660300002)(54906003)(72206003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1675;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zH19BOXxkqJKohOc15Ngi5T0BwJpm92Alcc0qPJTvDYY8LqgrvRA+kHyRK+RBtyeSN1EO1U6SjuDdDWaNkX3g8KNfq6wuHfczb7J/oIQ4SFsiXUDv2RyUNP9aT9dqeNdu5nUKiZEgPNU8xAZh8H5gqp5wwn/L7yGdh1Y8QZC+xs6YZn1wBIgY8d5IQpoy4DtTW+//Hi1ccoNrmJfsEjF/tZO4BbbAdIk3fxLDHLHm38OnBAcUKXegAn2NjMokpBB76+UWObVdT+sgrbMXFtTw3osL65qMbC3dw9bcvNoUqtx/cKUixJuNSoTBc6QzRGlGu5clqrunTjWBNPmPlUORvdxPUnCuMyU7IMpECJgUmhtOkjOfXkV48D/XvsTkI6CO5Y7XUcpsE/+HcTKlTxkJe1YffFlqEK1faVQ2XG3Cc4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19F52725C3015F45B7A043E88099A70D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43c8a6f-2d28-4a22-0bda-08d6ff14fe8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 17:44:55.9148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1675
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8yLzE5IDExOjA2IEFNLCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+IEhpIFRvbSBhbmQgR2Fy
eSwNCj4gDQo+IE9uIGxhdGVzdCBjcnlwdG9kZXYgdHJlZSwgSSdtIHNlZWluZyB0aGUgZm9sbG93
aW5nIHNlbGYtdGVzdCBmYWlsdXJlIGFmdGVyIEkNCj4gYnVpbHQgYSBrZXJuZWwgd2l0aCB0aGUg
QU1EIENDUCBkcml2ZXIgYW5kIGNyeXB0byBzZWxmLXRlc3RzIGVuYWJsZWQsIGFuZCBib290ZWQN
Cj4gaXQgb24gc3lzdGVtIHdpdGggYSBSeXplbiBwcm9jZXNzb3IgKCJUaHJlYWRyaXBwZXIgMTk1
MFgiKToNCj4gDQo+IFsgICAgNC4zNzg5ODVdIGFsZzogYWVhZDogZ2NtLWFlcy1jY3AgZW5jcnlw
dGlvbiB0ZXN0IGZhaWxlZCAod3JvbmcgcmVzdWx0KSBvbiB0ZXN0IHZlY3RvciAyLCBjZmc9InR3
byBldmVuIGFsaWduZWQgc3BsaXRzIg0KPiANCj4gaS5lLiwgaW4gc29tZSBjYXNlcyB0aGUgQUVT
LUdDTSBpbXBsZW1lbnRhdGlvbiBwcm9kdWNlcyB0aGUgd3JvbmcgY2lwaGVydGV4dA0KPiBhbmQv
b3IgYXV0aGVudGljYXRpb24gdGFnLg0KPiANCj4gSXMgdGhpcyBpcyBhIGtub3duIGlzc3VlPyAg
V2hlbiB3aWxsIGl0IGJlIGZpeGVkPw0KPiANCj4gVGhlIHBvdGVudGlhbGx5IHJlbGV2YW50IGJp
dHMgb2YgbXkgS2NvbmZpZyBhcmU6DQo+IA0KPiAJQ09ORklHX0NSWVBUT19BRVM9eQ0KPiAJQ09O
RklHX0NSWVBUT19HQ009eQ0KPiAJQ09ORklHX0NSWVBUT19ERVZfQ0NQPXkNCj4gCUNPTkZJR19D
UllQVE9fREVWX0NDUF9ERD15DQo+IAlDT05GSUdfQ1JZUFRPX0RFVl9TUF9DQ1A9eQ0KPiAJQ09O
RklHX0NSWVBUT19ERVZfQ0NQX0NSWVBUTz15DQo+IAlDT05GSUdfQ1JZUFRPX0RFVl9TUF9QU1A9
eQ0KPiAJIyBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRElTQUJMRV9URVNUUyBpcyBub3Qgc2V0DQo+
IAlDT05GSUdfREVCVUdfS0VSTkVMPXkNCj4gCUNPTkZJR19DUllQVE9fTUFOQUdFUl9FWFRSQV9U
RVNUUz15DQo+IA0KPiAtIEVyaWMNCj4gDQoNClllcywgdGhpcyBpcyBhIGtub3duIHByb2JsZW0u
IFdlIGhhdmUgbm8gZXN0aW1hdGUgb24gYSBmaXggYXQgdGhpcyB0aW1lLiANCkkgbmVlZCB0byBs
aWdodCBhIGZpcmUgdW5kZXIgc29tZW9uZSBub3cuDQoNCmdyaA0K
