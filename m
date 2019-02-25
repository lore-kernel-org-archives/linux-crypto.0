Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34D7C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 22:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F544217F5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 22:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Un6rlotz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfBYWqw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:46:52 -0500
Received: from mail-eopbgr730056.outbound.protection.outlook.com ([40.107.73.56]:6031
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728082AbfBYWqv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 17:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1Pn/FDWqtTD1RIagd2l7SxPFFgW+sTpuDx2hqKvNGI=;
 b=Un6rlotzVjH52MZBTA3DR6nOxHCtn/D9WsG7cc3eh9OEYiVoRB6Vx2mVM+Mz8Wfm7SDtTm/qS9TW+Qk0SL7Rsgr72qtZRV0srSxlDoShnskQpqcWUKKtEhOympT+9ToX7VgoFlRqcwtmKENeg9ADGb6e3kb5cy4JYrly9SeQc/g=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3371.namprd12.prod.outlook.com (20.178.198.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.14; Mon, 25 Feb 2019 22:46:47 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::2073:3d8a:bf05:4686]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::2073:3d8a:bf05:4686%4]) with mapi id 15.20.1643.019; Mon, 25 Feb 2019
 22:46:47 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Topic: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Index: AQHUw9Gi5mJPt5RuVE6hmwMqm1xhOaXfhQiAgAArpACAC5g5gIAF524A
Date:   Mon, 25 Feb 2019 22:46:46 +0000
Message-ID: <196eb0d3-dc9f-970f-d785-be4ad91fd54d@amd.com>
References: <20190213192329.680-1-brijesh.singh@amd.com>
 <CAOASepMn-r+2fQjDxP3yM=JuM-YDXNiAZWOo2x0OdTQBj4pdYA@mail.gmail.com>
 <a38e8f14-0ee1-f3ba-fda0-c6eff88c71a8@amd.com>
 <20190222043707.6kzqeztgx3rvv3a4@gondor.apana.org.au>
In-Reply-To: <20190222043707.6kzqeztgx3rvv3a4@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:802:20::41) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c863ab2-664d-45a5-8591-08d69b731f36
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR12MB3371;
x-ms-traffictypediagnostic: DM6PR12MB3371:
x-microsoft-exchange-diagnostics: 1;DM6PR12MB3371;20:Mvs/zywBdpTu1lCJZ//bMoj4bs3nnX1Kmt1eZpQjrEe3F7+dMIulQjl3fvO6/86l4Z4XM9quAdVXKA8pfQiiye0ThG6O2T6P4cfqZndlZhyJMoIDkj+B2VWFjQ/TafsnGCk+AjtY0RUMl2/CVTWXyyy09CQxxMppa9hgQZiieZDUnZwTSSKPVE49U4mMDPys5FLwNAf9PHTFG8r2LqEMbQFwbyk0csczFco7pz/dQPbuVkkfr1pyBgDLrgvQTm33
x-microsoft-antispam-prvs: <DM6PR12MB33716AC214C89ED38C99A14FE57A0@DM6PR12MB3371.namprd12.prod.outlook.com>
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(71200400001)(81166006)(25786009)(71190400001)(81156014)(66066001)(76176011)(6486002)(6436002)(106356001)(8676002)(105586002)(2906002)(97736004)(53936002)(31686004)(6916009)(256004)(486006)(14444005)(6512007)(54906003)(6246003)(6116002)(11346002)(3846002)(316002)(68736007)(36756003)(446003)(8936002)(7736002)(305945005)(186003)(229853002)(86362001)(4326008)(52116002)(476003)(53546011)(31696002)(99286004)(386003)(6506007)(14454004)(93886005)(5660300002)(102836004)(478600001)(26005)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3371;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DOcWDqs3EHRYUOYNd+WwMehphtZEAjTtyj7mwSsK7t0u7RzJWwikFkYwqGjc2rRT2QacfHzthPqVj7GPsm21oEImkq8lNufzfY/L6B2ZFdEbbmX/JUzmJtx97x6MqjjPknJD0YhTxNLEA0zYaxywARmmXIF6rGRsesJz1oHLwCut93U85CcW9Pa4zWeeI9upc9uwIlacEb6bYbg/zEGPuqF4S5WJtKyAPRMYLYVlUJZjDXIQMLcw9nQaUDqT6Wu3piJFikc/JbslfCWKByeJf7o4987gsyAIRXU4lOqjMiKFwV4mt2TFQXePPgTc/G70m6V4QPShj9RcATOPUut7Y/oWle0vKAfRYyYgIhLd6ya0KXlWbZaV5JuHh00TyIC5z6RyCW9B4IulK35GkQ+Umxq5W8Agqov5sU0PBhtLMyY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2FFFE43B082AF49817C325FC186FFD6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c863ab2-664d-45a5-8591-08d69b731f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2019 22:46:46.1621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDIvMjEvMTkgMTA6MzcgUE0sIEhlcmJlcnQgWHUgd3JvdGU6DQo+IE9uIFRodSwgRmVi
IDE0LCAyMDE5IGF0IDA3OjMzOjI5UE0gKzAwMDAsIFNpbmdoLCBCcmlqZXNoIHdyb3RlOg0KPj4N
Cj4+DQo+PiBPbiAyLzE0LzE5IDEwOjU3IEFNLCBOYXRoYW5pZWwgTWNDYWxsdW0gd3JvdGU6DQo+
Pj4gSSdtIGEgbGl0dGxlIGNvbmNlcm5lZCB0aGF0IHRoaXMgaW1tZWRpYXRlbHkgZGlzYWJsZXMg
U0VWX0dFVF9JRC4NCj4+PiBJTUhPLCB3ZSBzaG91bGQgY29udGludWUgdG8gc3VwcG9ydCBib3Ro
IGZvciBhIHBlcmlvZCBvZiB0aW1lLiBPbmUNCj4+PiBqdXN0aWZpY2F0aW9uIGZvciBpbW1lZGlh
dGUgZGlzYWJsZW1lbnQgd291bGQgYmUgdGhhdCBpZiBrZWVwaW5nIGl0DQo+Pj4gYXJvdW5kIGlz
IGxpa2VseSB0byBlbmFibGVkIGluY29ycmVjdCBvciBpbnNlY3VyZSB1c2Vyc3BhY2UgYmVoYXZp
b3INCj4+PiB3aXRoIGEgZmlybXdhcmUgY2hhbmdlLg0KPj4NCj4+DQo+PiBUaGVyZSBhcmUgbm90
IG1hbnkgcHJvZ3JhbXMgdXNpbmcgdGhlIEdFVF9JRCB0b2RheSwgbXkgcHJlZmVyZW5jZQ0KPj4g
aXMgdG8gZm9yY2UgdXNlcnNwYWNlIHJ1bm5pbmcgb24gYSBrZXJuZWwgd2hpY2ggc3VwcG9ydHMg
dGhlIEdFVF9JRDINCj4+IHRvIHVzZSBHRVRfSUQyIGFuZCBub3QgZmFsbGJhY2sgdG8gR0VUX0lE
Lg0KPj4NCj4+IFRoZSBjdXJyZW50IEdFVF9JRCBpcyAqYnJva2VuKi4NCj4+DQo+PiBIZXJlIGlz
IG9uZSBjYXNlIEkgYW0gdHJ5aW5nIHRvIG5hdmlnYXRlOg0KPj4gLSBBTUQgcmVsZWFzZXMgYSBu
ZXcgQ1BVDQo+PiAtIFRoZSBrZXJuZWwgdXNlZCBpbiB5b3VyIGRpc3RybyBkb2VzIG5vdCBzdXBw
b3J0IHRoaXMgQ1BVIHlldC4NCj4+ICAgICBZb3UgdXBkYXRlZCB0aGUga2VybmVsIHRvIGdldCB0
aGUgQ1BVIHN1cHBvcnQuDQo+PiAtIFRoZSBHRVRfSUQgb24gdGhpcyBDUFUgcmV0dXJuZWQgYSAx
MCBieXRlcyAoaW5zdGVhZCBvZiA2NCkNCj4+IC0gWW91IGdhdmUgdGhlIDY0LWJ5dGVzIG9mIGRh
dGEgdG8gQU1EIHRvIGdldCB0aGUgY2VydGlmaWNhdGUuDQo+PiAgICAgQU1EIHNlcnZlciByZWpl
Y3RzIHRoZSByZXF1ZXN0IGJlY2F1c2UgSUQgZ2l2ZW4gdG8gaXQgZG9lcyBub3QNCj4+ICAgICBl
eGlzdCBpbiBpdHMgZGF0YWJhc2UuDQo+Pg0KPj4gSWYgd2UgZHJvcCB0aGUgc3VwcG9ydCBmb3Ig
R0VUX0lEIGluIGtlcm5lbCwgdGhlbiBHRVRfSUQgd2lsbCBmYWlsIGFuZA0KPj4gdXNlciB3aWxs
IHJlcXVpcmVkIHRvIHRha2UgYWN0aW9uLg0KPiANCj4gU29ycnksIGJ1dCB3ZSBjYW4ndCBkcm9w
IGEga2VybmVsIEFQSSBqdXN0IHRvIGZvcmNlIHVzZXJzcGFjZQ0KPiB0byB1cGdyYWRlIHRvIGEg
bmV3IG9uZS4NCj4gDQo+IFNvIEkgYWdyZWUgd2l0aCBOYXRoYW5pZWwgdGhhdCB3ZSBzaG91bGQg
a2VlcCBjb21wYXRpYmlsaXR5IHVudGlsDQo+IHN1Y2ggYSB0aW1lIHdoZW4gdXNlci1zcGFjZSBp
cyBubyBsb25nZXIgdXNpbmcgdGhlIG9sZCBBUEkuDQo+IA0KPiBZb3UgY2FuIHVzZSBvdGhlciBt
ZWNoYW5pc21zIHRvIGVuY291cmFnZSB1c2VyLXNwYWNlIHRvIHN3aXRjaA0KPiBvdmVyIHRvIHRo
ZSBuZXcgQVBJLCBlLmcuLCBhIG9uY2Utb25seSB3YXJuaW5nIGlmIHRoZSBvbGQgQVBJDQo+IGlz
IHVzZWQuDQo+IA0KDQoNClN1cmUsIEkgd2lsbCByZXN1Ym1pdCB0aGUgcGF0Y2ggdG8ga2VlcCB0
aGUgb2xkIEFQSSBhbmQgbWF5YmUNCnByaW50IG9uY2Utb25seSB3YXJuaW5nLg0KDQp0aGFua3MN
Cg==
