Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD68C48BE9
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 20:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3055B20663
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 20:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="JWlB6UhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfFXUGD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 16:06:03 -0400
Received: from mail-eopbgr810053.outbound.protection.outlook.com ([40.107.81.53]:54816
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbfFXUGD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 16:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZe3LzI6YRoe9uCw78DGn6TqFRpZGzEm2P8oHXrVJOQ=;
 b=JWlB6UhGBFQLxXtYUd9QEpNCzzZVNmwKx+vVqKgWiaTLYwQK4SJboQZsgU81Ifq8PfICPLHNXhRqF2alkODOBJyoaGsgle+6938L7bgRKnwkNhFxQg/OT1BDy1GEkxY70ebGw/rImlrkjz3yM+LOxb1vYb5FGnXZemJAZQhYEqI=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1356.namprd12.prod.outlook.com (10.168.237.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 20:06:00 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 20:06:00 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Joe Perches <joe@perches.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
Thread-Topic: [PATCH 0/3] Clean up crypto documentation
Thread-Index: AQHVKsAU8eHDVMznu0yUy7vS0v5gPKarMRwAgAAJ3QA=
Date:   Mon, 24 Jun 2019 20:06:00 +0000
Message-ID: <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
 <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
In-Reply-To: <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:805:f2::43) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e9ada71-2ff7-4bdd-434d-08d6f8df60c0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1356;
x-ms-traffictypediagnostic: DM5PR12MB1356:
x-microsoft-antispam-prvs: <DM5PR12MB13564CF98DC18BD92C374D21FDE00@DM5PR12MB1356.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(136003)(376002)(366004)(189003)(199004)(8936002)(53936002)(256004)(186003)(6436002)(2906002)(14454004)(2616005)(7736002)(3846002)(486006)(6116002)(81156014)(71190400001)(446003)(81166006)(8676002)(72206003)(478600001)(99286004)(31696002)(6486002)(6512007)(66066001)(11346002)(316002)(386003)(26005)(2201001)(31686004)(2501003)(305945005)(36756003)(476003)(68736007)(25786009)(229853002)(102836004)(6246003)(76176011)(66946007)(5660300002)(73956011)(52116002)(66446008)(64756008)(53546011)(66556008)(66476007)(6506007)(110136005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1356;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b+3UCFd2dXMt4TN2EV4YvrnNRW9pBKkRFIdupBZtvUyqSS7j+kwZMQAT+hcOPnPyHggXy5Eo84f1TR5I8oepO7rUZoGSocjAIXtd8dmBq+GhWEX33U/u4pAig5pyv0EfGwGeTRjWCW2PKK5Wv6LipTDALujhAwLZGdHudHQ91j765OMLy3PS2OXRyXb81rTdUsXLB3IpMVMYw8nieCuT5kpoq9Psz0ECSkimniIQ6Ez6vQPysfhU7Ld4w5770p7sakX0jZzLKUY852E9xede53k3VENC5xly5/kCzuh3OFqLAOMsq9SFoVrkNiG2Uov/Rg70dV+xQMOakwq3u0f0U06JYUH5r0KbBGrpRRKbe15XGba1sCw2xe9TMvoMMafMD2Ma1PRfWKypcWMTU5AoOSQQYCeqX9KGpN39+2CxFxI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41ABAB348489B04E983798A4EA1DEE08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9ada71-2ff7-4bdd-434d-08d6f8df60c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 20:06:00.7785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAyOjMwIFBNLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4gT24gTW9uLCAyMDE5LTA2
LTI0IGF0IDE5OjA3ICswMDAwLCBIb29rLCBHYXJ5IHdyb3RlOg0KPj4gVGlkeSB1cCB0aGUgY3J5
cHRvIGRvY3VtZW50YXRpb24gYnkgZmlsbGluZyBpbiBzb21lIHZhcmlhYmxlDQo+PiBkZXNjcmlw
dGlvbnMsIG1ha2Ugc29tZSBncmFtbWF0aWNhbCBjb3JyZWN0aW9ucywgYW5kIGVuaGFuY2UNCj4+
IGZvcm1hdHRpbmcuDQo+IA0KPiBXaGlsZSB0aGlzIHNlZW1zIGdlbmVyYWxseSBPSywgcGxlYXNl
IHRyeSBub3QgdG8gbWFrZSB0aGUNCj4gcmVhZGFiaWxpdHkgb2YgdGhlIHNvdXJjZSBfdGV4dF8g
bGVzcyBpbnRlbGxpZ2libGUganVzdA0KPiB0byBlbmhhbmNlIHRoZSBvdXRwdXQgZm9ybWF0dGlu
ZyBvZiB0aGUgaHRtbC4NCj4gDQo+IGUuZy46DQo+IA0KPiBVbm5lY2Vzc2FyeSBibGFuayBsaW5l
cyBzZXBhcmF0aW5nIGZ1bmN0aW9uIGRlc2NyaXB0aW9ucw0KPiBSZW1vdmluZyBzcGFjZSBhbGln
bm1lbnQgZnJvbSBidWxsZXQgcG9pbnQgZGVzY3JpcHRpb25zDQoNCkFwb2xvZ2llcy4gSSBnZW5l
cmFsbHkgY29uc2lkZXIgd2hpdGUgc3BhY2UgYSBHb29kIFRoaW5nLA0KYnV0IHdpbGwgdGFrZSB5
b3VyIG5vdGUgYW5kIG5vdCBkbyB0aGF0LiBUaGUgYmxhbmsgbGluZXMgSQ0KYWRkZWQgZG8gbm90
IGFmZmVjdCB0aGUgb3V0cHV0LCBzbyBJIHNob3VsZCBub3QgaGF2ZSBkb25lDQp0aGF0Lg0KDQpB
bHNvLCBJIHR1cm5lZCBzZW50ZW5jZXMgaW50byBidWxsZXRlZCBsaXN0cyBoZXJlLCBzbyBJJ20g
bm90DQpjbGVhciBvbiB3aGV0aGVyIHRoYXQgd2FzIGEgQmFkIFRoaW5nIG9yIG5vdC4gU2VlbXMg
bW9yZSBsZWdpYmxlDQp0byBtZSBhbGwgdGhlIHdheSBhcm91bmQsIGJ1dCBJIGNsZWFybHkgY291
bGQgYmUgaW5jb3JyZWN0LiBJDQphZ3JlZSB0aGF0IG11Y2tpbmcgd2l0aCBhbGlnbm1lbnQgaXMg
YSBiYWQgdGhpbmcsIGFuZCB3b3VsZCBub3QNCmludGVudGlvbmFsbHkgZG8gc28uIFRoYXQgc2Fp
ZCwgaWYgeW91IHdvdWxkIHBsZWFzZSBlbGFib3JhdGUgb24NCmFueSBtaXN0YWtlcyBJJ3ZlIG1h
ZGU/DQoNCkZpbmFsbHksIHdvdWxkIHlvdSBwcmVmZXIgYSB2MiBvZiB0aGUgcGF0Y2ggc2V0PyBI
YXBweSB0byBkbw0Kd2hhdGV2ZXIgaXMgcHJlZmVycmVkLCBvZiBjb3Vyc2UuDQoNCmdyaA0K
