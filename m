Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBF0C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 19:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E554A21850
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 19:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="EjuvqrEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfBZTS4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 14:18:56 -0500
Received: from mail-eopbgr760085.outbound.protection.outlook.com ([40.107.76.85]:55904
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727731AbfBZTS4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 14:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5gjjYrgXl+wZ2Jn33X1LwUKGBbnN+B08FOaU/JTQf4=;
 b=EjuvqrEwgYnzwi8paJH3fp27+Uh1Nwz//MGUkEAgnyKXFyEhvJN6X5K3bezTNObtsRKgBy1k3wdl2qhTvZokYCBLQLqvJhHWq4WDxDuv3T7oR2NhPqasIWbxD4/Hyc3tz9gWFI3GHR5XH04B89QnP3BdRoKT8XQoqCnQo93pniQ=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3098.namprd12.prod.outlook.com (20.178.30.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Tue, 26 Feb 2019 19:18:53 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::2073:3d8a:bf05:4686]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::2073:3d8a:bf05:4686%4]) with mapi id 15.20.1643.019; Tue, 26 Feb 2019
 19:18:53 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: SEV Command Privilege Separation
Thread-Topic: SEV Command Privilege Separation
Thread-Index: AQHUxKmADaYD3Hopbke/lwoL/D6HT6XyhuOA
Date:   Tue, 26 Feb 2019 19:18:53 +0000
Message-ID: <4db2f309-237f-240d-e7f7-290391274237@amd.com>
References: <CAOASepP1+ZzGfy62jO5S4ZtpYzPJKqVZntTPp8Xn-zK8Kd2k8A@mail.gmail.com>
In-Reply-To: <CAOASepP1+ZzGfy62jO5S4ZtpYzPJKqVZntTPp8Xn-zK8Kd2k8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0007.namprd02.prod.outlook.com
 (2603:10b6:803:2b::17) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa02b403-c50f-448b-6600-08d69c1f3ecb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR12MB3098;
x-ms-traffictypediagnostic: DM6PR12MB3098:
x-microsoft-exchange-diagnostics: 1;DM6PR12MB3098;20:JJJgFe4vcRUfW84cPLx5BhqpawyJumqQCucOfZFGFUFTsVs2HINMrSEAKAamYy9LygcT8BsGrkw2A2vJopuNG2DuFavyHm69VIE1DPreSobSkXnUX3HZNxFZl5BDfAxgi6Nruar51+h56Gm2IuZp9XtNMuPlfHfBjQifWeMcyQoZatJCZFwx6ZVG8SpCwucOdwrAydxQx5ZKhKsyiJQNTeQsHg3hDp2znwfc/W9PJRpVbGDAPzJ6LL1UTRV0Jea/
x-microsoft-antispam-prvs: <DM6PR12MB3098612C1C98DD44324A5259E57B0@DM6PR12MB3098.namprd12.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(136003)(376002)(396003)(199004)(189003)(6246003)(14444005)(186003)(5660300002)(31696002)(386003)(8676002)(14454004)(86362001)(6436002)(316002)(6506007)(68736007)(256004)(2201001)(31686004)(53546011)(26005)(478600001)(3480700005)(66066001)(71190400001)(71200400001)(2906002)(3846002)(6116002)(102836004)(99286004)(6486002)(6512007)(76176011)(110136005)(7736002)(4326008)(105586002)(476003)(2501003)(97736004)(53936002)(25786009)(8936002)(2616005)(52116002)(305945005)(446003)(36756003)(486006)(81166006)(11346002)(81156014)(229853002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3098;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5ioGmdEkQNoI33Usv9qCCD/uZaBGglqYDDHGDTPmbxMMjmWG9VGaiypvtR2UJtj4Z8HXhOHktV+s91YqsGNXNXrV45JYWNofkgR3hpfv65CcGLohchY8YvlefS6SsnngAqq3wZn343YiCqXWCuRYgnHdY9UYuleYq9ftSMEqMcnwnsFUKCwf92MQkjlhSarAUWuY+DtMWIFKp8Ef3Sh81htlIV0gOiC51bkUtHui1AmcEq4sSVWoyjSbXM/6UN1pKkcilgNQu1bZH7EEb7+6gS28eGkpVJ/UVhvuEdKbPvFiVtkpoqQan0sNtBDm5ZCODCVze+YjrDVp6efTfEeqpY/4AgCuYC3Lfb3iZ/mPPXegiB0QsgJwjLnpeU9z4o/KZFCgGozLq2MTCsZfg5FxGfmaruM+i9qL0g13uhAuU2s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72AE40C881D8A146BEC9E708C8D81FD2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa02b403-c50f-448b-6600-08d69c1f3ecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 19:18:52.8078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3098
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDIvMTQvMTkgMzowOCBQTSwgTmF0aGFuaWVsIE1jQ2FsbHVtIHdyb3RlOg0KPiBJJ3Zl
IGJlZW4gd29ya2luZyBvbiB3cmFwcGluZyB2YXJpb3VzIFNFViBrZXJuZWwgQVBJcyBmb3IgdXNl
cnNwYWNlDQo+IGNvbnN1bXB0aW9uLiBUaGVyZSBkb2VzIG5vdCBhcHBlYXIgdG8gYmUgYW55IHBy
aXZpbGVnZSBzZXBhcmF0aW9uIGZvcg0KPiB0aGVzZSBjb21tYW5kczogeW91IGNhbiBydW4gdGhl
bSBhbGwgb3Igbm9uZSBvZiB0aGVtLiBUaGlzIGlzIGxlc3MNCj4gdGhhbiBpZGVhbCBiZWNhdXNl
IGl0IG1lYW5zIHRoYXQgYSBjb21wcm9taXNlIG9mIHRoZSBjb2RlIHdoaWNoDQo+IGxhdW5jaGVz
IFZNcyBjb3VsZCBtYWtlIHBlcm1hbmVudCBjaGFuZ2VzIHRvIHRoZSBTRVYgY2VydGlmaWNhdGUN
Cj4gY2hhaW4uDQo+IA0KPiBUaGVzZSBjb21tYW5kcyBhcmUgcmVxdWlyZWQgdG8gYXR0ZXN0IHRo
ZSBWTSBlbnZpcm9ubWVudDoNCj4gICAgU0VWX1BESF9DRVJUX0VYUE9SVA0KPiAgICBTRVZfUExB
VEZPUk1fU1RBVFVTDQo+ICAgIFNFVl9HRVRfSUQNCj4gDQo+IFRoZXNlIGNvbW1hbmRzIG1hbmFn
ZSB0aGUgU0VWIGNlcnRpZmljYXRlIGNoYWluOg0KPiAgICBTRVZfUEVLX0NFUlRfSU1QT1JUDQo+
ICAgIFNFVl9GQUNUT1JZX1JFU0VUDQo+ICAgIFNFVl9QRUtfR0VODQo+ICAgIFNFVl9QRUtfQ1NS
DQo+ICAgIFNFVl9QREhfR0VODQo+IA0KPiBJIHdvdWxkIGV4cGVjdCB0aGUgZmlyc3QgZ3JvdXAg
b2YgY29tbWFuZHMgdG8gYmUgYWJsZSB0byBiZSBjYWxsZWQgYnkNCj4gd2hhdGV2ZXIgYWN0b3Ig
bGF1bmNoZXMgVk1zLiBUaGUgbGF0dGVyIGdyb3VwIG9mIGNvbW1hbmRzIHNob3VsZCBiZQ0KPiBh
YmxlIHRvIGJlIGNhbGxlZCBieSB3aGF0ZXZlciBhY3RvciBtYW5hZ2VzIHRoZSBTRVYgZW52aXJv
bm1lbnQuDQo+IA0KPiBJIGRvbid0IGhhdmUgc3Ryb25nIG9waW5pb25zIG9uIGhvdyB0aGlzIHBy
aXZpbGVnZSBzZXBhcmF0aW9uIHNob3VsZA0KPiBoYXBwZW4uIEl0IG1pZ2h0IGJlIHN1ZmZpY2ll
bnQgdG8gZGlzdGluZ3Vpc2ggdGhlc2UgYmFzZWQgb24gdGhlIG1vZGUNCj4gb2YgdGhlIG9wZW4o
KSBjYWxsLiBUaGlzIGNvdWxkIHRoZW4gYmUgbWFuYWdlZCB3aXRoIGZpbGVzeXN0ZW0NCj4gcGVy
bWlzc2lvbnMuIEJ1dCBJJ20gb3BlbiB0byBvdGhlciBpZGVhcy4NCj4gDQoNCg0KV2UgaGFkIHNv
bWV3aGF0IGEgc2ltaWxhciBkaXNjdXNzaW9uIG9uIGxpYnZpcnQgTUwsIGN1cnJlbnRseSB0aGUN
CnVkZXYgcnVsZXMgZm9yIHRoZSAvZGV2L3NldiBpcyAwNjAwLiBBcyB5b3UgaGF2ZSBub3RpY2Vk
IHRoZXJlDQppcyBubyBwcml2aWxlZ2Ugc2VwYXJhdGlvbiwgaWYgYWRtaW4gZ3JhbnRzIDA2NDQg
dGhlbiB1c2VyL2dyb3VwDQp3aWxsIGFibGUgdG8gaXNzdWUgYSBjb21tYW5kIHdoaWNoIGNhbiBt
b2RpZnkgIHRoZSBTRVYgY2VydGlmaWNhdGUNCmNoYWluLiBBdCB0aGUgdmVyeSBtaW5pbWFsIHdl
IHNob3VsZCBwZXJmb3JtIHRoZSBtb2RlIGNoZWNrDQpiZWZvcmUgaXNzdWluZyB0aGUgY29tbWFu
ZHMgdG8gUFNQLiBJZiB1c2VyIGRvZXMgbm90IGhhdmUgJ3dyaXRlJw0KYWNjZXNzIHRoZW4gYW55
IGNvbW1hbmRzIHdoaWNoIG1vZGlmaWVzIHRoZSBjZXJ0LWNoYWluIHNob3VsZA0KZmFpbC4gSXRz
IGluIG15IFRPRE8gbGlzdCwgdGhlIHBhdGNoZXMgYXJlIGFsd2F5cyB3ZWxjb21lIDopDQoNCi1C
cmlqZXNoDQo=
