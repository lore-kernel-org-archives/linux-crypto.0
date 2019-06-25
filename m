Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C482C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEF1208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="lBDBX/+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFYNdd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 09:33:33 -0400
Received: from mail-eopbgr800043.outbound.protection.outlook.com ([40.107.80.43]:49085
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbfFYNdd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 09:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXmJBXd3zH3FOKiyU1yBovvsaMpyF+re66qzWO4xtPU=;
 b=lBDBX/+EZZMhsqE6MO6WB+6XWxnHPDlaBZU3RFvdJOOypbs6JU51s3tIljecxp3B5zvsA0Tk6OCJRd/yU4K8npRjGZusSKqMjNxynNUvdNT6KG8Z6giQgEUKDQDaj5IPXEov8ZMWk2w1bbU9z9sf5gTD1MeFtYdpkSggM9CGIKs=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2502.namprd12.prod.outlook.com (52.132.141.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 13:33:27 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 13:33:27 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Jonathan Corbet <corbet@lwn.net>, Joe Perches <joe@perches.com>
CC:     "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
Thread-Topic: [PATCH 0/3] Clean up crypto documentation
Thread-Index: AQHVKsAU8eHDVMznu0yUy7vS0v5gPKarMRwA//+2CwCAAFp0AIAAAkMAgAEbxAA=
Date:   Tue, 25 Jun 2019 13:33:27 +0000
Message-ID: <d0803cdf-e4d8-102a-d67f-d3a32a4dfff0@amd.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
 <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
 <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
 <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
 <20190624143748.7fcfe623@lwn.net>
In-Reply-To: <20190624143748.7fcfe623@lwn.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:5:bc::20) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 264727e4-e7af-40ed-12cd-08d6f971b47d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2502;
x-ms-traffictypediagnostic: DM5PR12MB2502:
x-microsoft-antispam-prvs: <DM5PR12MB250208568D61D57E94AF2277FDE30@DM5PR12MB2502.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(346002)(396003)(39860400002)(199004)(189003)(66476007)(52116002)(446003)(66946007)(6486002)(73956011)(476003)(2616005)(99286004)(486006)(2906002)(11346002)(72206003)(4326008)(5660300002)(478600001)(14454004)(6512007)(3846002)(6246003)(6116002)(31686004)(6436002)(36756003)(53936002)(71200400001)(81166006)(71190400001)(54906003)(102836004)(25786009)(386003)(7736002)(186003)(81156014)(53546011)(26005)(305945005)(6506007)(14444005)(68736007)(256004)(110136005)(66446008)(8676002)(66066001)(64756008)(76176011)(229853002)(31696002)(66556008)(316002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2502;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QpERSikVy6VeuNVnB1+JnVZEFRm6c4leYsamrQ0LUnCLWDJH7eRQyvBdgGIH2Ao+s/Shcv64bTqjNyf5g7993n7doDojza48xn6GgzIBBMhihmS7zinbIM22iEIeHjAfoD+VoO1C5QEnSk8bU+n6x6Ny+nVzEohXYgfOQZbbvRWCmxR83rX23BI2k/bSvyENts02gew1uJCdkrEZMRm8QesLRaWaSXmdydHPildw+fjThLQUxsTRhrRCSeF6pRZypG73uw87gDle+mTTl66EaKvVjS4eLJzq3xzT1awWTfyRMJrltbL62rcNSq8JIrN14LsFzinYjSYM8iLvcFUL7Ypvl1SXp3yrRsJnZa6OK3tAq0eE8xlHdEx6EJYHwL5a3xdehxI+v84ygXS8i3I+NIj5LrNscNILHKQhMZBEdXQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B21499143B3ADD478961B27EB8FE4A74@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264727e4-e7af-40ed-12cd-08d6f971b47d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 13:33:27.7022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2502
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAzOjM3IFBNLCBKb25hdGhhbiBDb3JiZXQgd3JvdGU6DQo+IE9uIE1vbiwgMjQg
SnVuIDIwMTkgMTM6Mjk6NDIgLTA3MDANCj4gSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4g
d3JvdGU6DQo+IA0KPj4+IEZpbmFsbHksIHdvdWxkIHlvdSBwcmVmZXIgYSB2MiBvZiB0aGUgcGF0
Y2ggc2V0PyBIYXBweSB0byBkbw0KPj4+IHdoYXRldmVyIGlzIHByZWZlcnJlZCwgb2YgY291cnNl
Lg0KPj4NCj4+IFdoYXRldmVyIEpvbmF0aGFuIGRlY2lkZXMgaXMgZmluZSB3aXRoIG1lLg0KPj4g
TWluZSB3YXMganVzdCBhIHBsZWEgdG8gYXZvaWQgdW5uZWNlc3NhcmlseQ0KPj4gbWFraW5nIHRo
ZSBzb3VyY2UgdGV4dCBoYXJkZXIgdG8gcmVhZCBhcw0KPj4gdGhhdCdzIHdoYXQgSSBtb3N0bHkg
dXNlLg0KPiANCj4gVXN1YWxseSBIZXJiZXJ0IHNlZW1zIHRvIHRha2UgY3J5cHRvIGRvY3MsIHNv
IGl0J3Mgbm90IG5lY2Vzc2FyaWx5IHVwIHRvDQo+IG1lIDopDQo+IA0KPiBJIGRvbid0IHNlZSBt
dWNoIHRoYXQncyBvYmplY3Rpb25hYmxlIGhlcmUuICBCdXQuLi4NCj4gDQo+PiBJIGRvbid0IGtu
b3cgaWYgdGhpcyBleHRlbnNpb24gaXMgdmFsaWQgeWV0LCBidXQNCj4+IEkgYmVsaWV2ZSBqdXN0
IHVzaW5nIDxmdW5jdGlvbl9uYW1lPigpIGlzIG1vcmUNCj4+IHJlYWRhYmxlIGFzIHRleHQgdGhh
biBgYDxmdW5jdGlvbl9uYW1lPmBgIG9yDQo+PiA6YzpmdW5jOmA8ZnVuY3Rpb25fbmFtZT5gDQo+
IA0KPiBJdCdzIGJlZW4gInZhbGlkIiBzaW5jZSBJIHdyb3RlIGl0Li4uaXQncyBqdXN0IG5vdCB1
cHN0cmVhbSB5ZXQgOikgIEkNCj4gZXhwZWN0IGl0IHRvIGJlIGluIDUuMywgdGhvdWdoLiAgU28g
dGhlIGJlc3Qgd2F5IHRvIHJlZmVyIHRvIGEga2VybmVsDQo+IGZ1bmN0aW9uLCBnb2luZyBmb3J3
YXJkLCBpcyBqdXN0IGZ1bmN0aW9uKCkgd2l0aCBubyBtYXJrdXAgbmVlZGVkLg0KDQpTbyBJJ20g
dW5jbGVhcjoNCg0KMSkgd291bGQgeW91IHByZWZlciBJIHdhaXQgb24geW91ciA1LjMgY2hhbmdl
IGJlaW5nIGZ1bGx5IGNvbW1pdHRlZCwNCjIpIGFkZCB5b3VyIGNoYW5nZSB0byBteSBsb2NhbCB0
cmVlIGFuZCB1c2UgaXQsIHRoZW4gc3VibWl0IGFuIHVwZGF0ZSANCnBhdGNoc2V0IHRoYXQgZGVw
ZW5kcyB1cG9uIGl0LCBvcg0KMykgcmUtc3VibWl0IG5vdyAodXNpbmcgdGhlIGN1cnJlbnQgbWV0
aG9kKSB3aXRoIHN1Z2dlc3RlZCBjaGFuZ2VzPw0KDQpJJ20gdGhpbmtpbmcgdGhhdCB0aGlzIHdp
bGwgZ28gaW4gYWZ0ZXIgdGhlIHJlZmVyZW5jZWQgcGF0Y2gsIHNvICgyKSBpcyANCnRoZSBwcmVm
ZXJyZWQgY2hvaWNlPw0KDQpncmgNCg0K
