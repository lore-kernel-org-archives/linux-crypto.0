Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6556DCA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 11:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2277D2084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 11:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="UPsqsq2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392201AbfJXLVY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 07:21:24 -0400
Received: from mail-eopbgr820044.outbound.protection.outlook.com ([40.107.82.44]:60576
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390184AbfJXLVY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 07:21:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJDtDaJqgHJ02E+T/N5U7kuipdmEedRqiky9jOdT+9Bc1cd+zJ418UMYdQZSmw+rNXtm7DtUCX3ibFhKYW5DmxcBwJGorXvDUgvipnWRlj5K6Rhjnws8rHbJIN+5PanINseto86wvYLFW75oE5SWZRfrGUJTOB/DmkMWtRRZuyWVQr4Srz6Qfyg04hc/W12xJ4Ma4U3uHIdccz+uaF3HSOqRNzWoI+QU5yXoGkbEmoZES5fAw+KxV0bbjwk/VZzrlp3lRXUv8dtgLZywzLVB96G81B7T0ZkOOxARWVJNh2zdllC+d6eXFUBCGkHku8Yi84V0XKp1/AcR2f5UrGL5uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzrUQ//VIqIJw1Bx+D0alXGuqhdmGge+/fl9CIBLM0c=;
 b=JbnHkCoc8jvbqIgjlHNlpMLNPpzlZwX5Nn2WDldZdv+OM44K7/cffD9PsinQ8l+DUV5GHu68JII1EQ6945092RJYfnMhnwQmHODqtjhuxMU8wQTRfXsgkAOtcGeI3oe5HevY6crFtLgI/uKFX+ZUJchbcuGdevD5Yynv06ehnU5v3b7b4VH4y4WyI73eMvCE/UhHvMZta9ClsDfEvQWbpvdy/0BVT1LCajommb9ZjWeTatrbY3tSs8CWnjWP9HS7Ga+4oc8FyVBRxMeH33T1ASfGO0JWap/ijc0fBNzDuZXZV27RKA47qTTpqCcWtLJwAtau/YaXZikGbBD3vAIhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzrUQ//VIqIJw1Bx+D0alXGuqhdmGge+/fl9CIBLM0c=;
 b=UPsqsq2kIjrXfnwD7TyjzG9dT1Y+0qnJGtcWZ/p1JxNHOuD3u/Gc+6PjeiEq7G+6Bc5gQxEG1G2rygKiJ1GrwbZ1SreaDQRJgxIIxJfSQ7S1rrRn1P5Kegdk8UD6FcMxjFfH+Yg2E1l7HQY4QQii4D/gTZE0aizrMpy5rmczKj8=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1639.namprd12.prod.outlook.com (10.172.71.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 11:21:21 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Thu, 24 Oct
 2019 11:21:21 +0000
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Subject: Re: [RFC PATCH 0/5] Add TEE interface support to AMD Secure Processor
 driver
Thread-Topic: [RFC PATCH 0/5] Add TEE interface support to AMD Secure
 Processor driver
Thread-Index: AQHViZTX3R3UO0PPhkOgyRS+vzwoTKdoalYAgAE8xIA=
Date:   Thu, 24 Oct 2019 11:21:21 +0000
Message-ID: <5dc11f5d-3d89-580d-db2d-35b55fc7996b@amd.com>
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
 <24a6506c-eb90-5a70-862f-95571e668a5d@amd.com>
In-Reply-To: <24a6506c-eb90-5a70-862f-95571e668a5d@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::28) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.156.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f236950-4561-444e-d93b-08d758744bef
x-ms-traffictypediagnostic: CY4PR12MB1639:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB1639E2436FB05B96CAEBCA46CF6A0@CY4PR12MB1639.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(189003)(199004)(52116002)(2906002)(86362001)(99286004)(110136005)(14454004)(229853002)(6512007)(2501003)(54906003)(36756003)(6306002)(6436002)(3846002)(6116002)(6486002)(66946007)(66476007)(66446008)(64756008)(66556008)(31686004)(7736002)(25786009)(5660300002)(31696002)(6246003)(4326008)(8936002)(71190400001)(316002)(71200400001)(186003)(76176011)(102836004)(26005)(256004)(53546011)(2201001)(386003)(6506007)(2616005)(14444005)(486006)(446003)(11346002)(81156014)(81166006)(478600001)(8676002)(305945005)(966005)(66066001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1639;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKjF3t0FVwF4xnr5LF4W+vrG4PhR/3v4IuXlpK7v3e2tUWwyr/wT2JoXIRmu6rziiCC+YVB+6Y0XVETZXY/xl0A0hn+/yJphI1xGwTcHDD2lgO4TQPoCDEoaz8hVzbCF5qGg9axYzAo4knO7K0QqlJV77XWS/zjqohBm1vhWWUD4aG+2WLaMOd0+TUtlG7etkxEDIGcKS4hiGRCZ6dK0rwm13OTN8iBiXSchO7yhYLFPc9gUtJJy6NbY/897yDuunzwASGtXAu4pRz0bGUPmagwvgGfd76v25xRewitoz31zOI2zrTNBWWTom/3owHUtnRc/iPlvZ11b5xaWLnj5sRY3qLDfyai9uqqqy43Vq9TDN0bFs66V/6hM1epkvfzUOnxUYj4l+XLJKwmqRAeD/xT3i6hOWL6SgowUdyvXTnyRO0hKmFVDHE0QaISIDkH6f/v5f/tF7BePvosLyCKAzw3dcDsbAIx/71mYLYC84CI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37C698DBFF39484F95BC711933B0F04F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f236950-4561-444e-d93b-08d758744bef
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 11:21:21.1304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hy9WGxDjUlBNOi4efLoUdbL0v1NJbE3TLMTR42uqFV/sFrI2KZJzZpMh5Z2b4uwJN1ChYJ9wT59XMp1c3KlYaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1639
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gVG9tLA0KDQpPbiAyMy8xMC8xOSA5OjU3IFBNLCBMZW5kYWNreSwgVGhvbWFzIHdyb3Rl
Og0KPiBPbiAxMC8yMy8xOSA2OjI3IEFNLCBUaG9tYXMsIFJpam8tam9obiB3cm90ZToNCj4+IFRo
ZSBnb2FsIG9mIHRoaXMgcGF0Y2ggc2VyaWVzIGlzIHRvIGludHJvZHVjZSBURUUgKFRydXN0ZWQg
RXhlY3V0aW9uDQo+PiBFbnZpcm9ubWVudCkgaW50ZXJmYWNlIHN1cHBvcnQgdG8gQU1EIFNlY3Vy
ZSBQcm9jZXNzb3IgZHJpdmVyLiBUaGUNCj4+IFRFRSBpcyBhIHNlY3VyZSBhcmVhIG9mIGEgcHJv
Y2Vzc29yIHdoaWNoIGVuc3VyZXMgdGhhdCBzZW5zaXRpdmUgZGF0YQ0KPj4gaXMgc3RvcmVkLCBw
cm9jZXNzZWQgYW5kIHByb3RlY3RlZCBpbiBhbiBpc29sYXRlZCBhbmQgdHJ1c3RlZA0KPj4gZW52
aXJvbm1lbnQuIFRoZSBQbGF0Zm9ybSBTZWN1cml0eSBQcm9jZXNzb3IgKFBTUCkgaXMgYSBkZWRp
Y2F0ZWQNCj4+IHByb2Nlc3NvciB3aGljaCBwcm92aWRlcyBURUUgdG8gZW5hYmxlIEhXIHBsYXRm
b3JtIHNlY3VyaXR5LiBJdCBvZmZlcnMNCj4+IHByb3RlY3Rpb24gYWdhaW5zdCBzb2Z0d2FyZSBh
dHRhY2tzIGdlbmVyYXRlZCBpbiBSaWNoIE9wZXJhdGluZyBTeXN0ZW0NCj4+IChSaWNoIE9TKSBz
dWNoIGFzIExpbnV4IHJ1bm5pbmcgb24geDg2Lg0KPj4NCj4+IEJhc2VkIG9uIHRoZSBwbGF0Zm9y
bSBmZWF0dXJlIHN1cHBvcnQsIHRoZSBQU1AgaXMgY2FwYWJsZSBvZiBzdXBwb3J0aW5nDQo+PiBl
aXRoZXIgU0VWIChTZWN1cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uKSBhbmQvb3IgVEVFLiBU
aGUgZmlyc3QgdGhyZWUNCj4+IHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgaXMgYWJvdXQgbW92aW5n
IFNFViBzcGVjaWZpYyBmdW5jdGlvbnMgYW5kIGRhdGENCj4+IHN0cnVjdHVyZXMgZnJvbSBQU1Ag
ZGV2aWNlIGRyaXZlciBmaWxlIHRvIGEgZGVkaWNhdGVkIFNFViBpbnRlcmZhY2UNCj4+IGRyaXZl
ciBmaWxlLiBUaGUgbGFzdCB0d28gcGF0Y2hlcyBhZGQgVEVFIGludGVyZmFjZSBzdXBwb3J0IHRv
IEFNRA0KPj4gU2VjdXJlIFByb2Nlc3NvciBkcml2ZXIuIFRoaXMgVEVFIGludGVyZmFjZSB3aWxs
IGJlIHVzZWQgYnkgQU1ELVRFRQ0KPj4gZHJpdmVyIHRvIHN1Ym1pdCBjb21tYW5kIGJ1ZmZlcnMg
Zm9yIHByb2Nlc3NpbmcgaW4gUFNQIFRydXN0ZWQgRXhlY3V0aW9uDQo+PiBFbnZpcm9ubWVudC4N
Cj4gDQo+IFRoZXJlIGFyZSBzb21lIG91dHN0YW5kaW5nIHBhdGNoZXMgdGhhdCBoYXZlIGJlZW4g
c3VibWl0dGVkIHRoYXQgbW9kaWZ5DQo+IHNvbWUgb2YgdGhlIHNhbWUgZmlsZXMgeW91IGFyZSBt
b2RpZnlpbmcsIHNvIHlvdSdsbCBuZWVkIHRvIHJlYmFzZSBhZnRlcg0KPiB0aG9zZSBwYXRjaGVz
IGFyZSBhcHBsaWVkLiBBbHNvLCBvbmUgcGF0Y2ggd2FzIGFwcGxpZWQgdGhyb3VnaCB0aGUgS1ZN
DQo+IHRyZWUsIG5vdCBzdXJlIGhvdyB0byBoYW5kbGUgdGhhdC4NCj4gDQo+IEZvciByZWZlcmVu
Y2UsIGhlcmUgYXJlIHRoZSBzdWJtaXR0ZWQgcGF0Y2hlczoNCj4gDQo+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS82MTA4NTYxZTM5MjQ2MGFkZTY3ZjdmNzBkOWJmYTlmNTZhOTI1ZDBhLjE1
NzAxMzc0NDcuZ2l0LnRob21hcy5sZW5kYWNreUBhbWQuY29tLw0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9saW51eC1jcnlwdG8vMjAxOTEwMTcyMjM0NTkuNjQyODEtMS1Bc2hpc2guS2FscmFA
YW1kLmNvbS8NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzE1NzE2NjU0
ODI1OS4yODI4Ny4xODExODgwMjkwOTgwMTY4MTU0Ni5zdGdpdEB0YW9zLw0KDQpJIHdpbGwgdGFr
ZSBhIG5vdGUgb2YgdGhpcy4gSSB3aWxsIHJlYmFzZSBvbmNlIHRoZXNlIHBhdGNoZXMgYXJlIG1l
cmdlZC4NCg0KVGhhbmtzLA0KUmlqbw0KDQo+IA0KPiBUaGFua3MsDQo+IFRvbQ0KPiANCj4+DQo+
PiBSaWpvIFRob21hcyAoNSk6DQo+PiAgIGNyeXB0bzogY2NwIC0gcmVuYW1lIHBzcC1kZXYgZmls
ZXMgdG8gc2V2LWRldg0KPj4gICBjcnlwdG86IGNjcCAtIGNyZWF0ZSBhIGdlbmVyaWMgcHNwLWRl
diBmaWxlDQo+PiAgIGNyeXB0bzogY2NwIC0gbW92ZSBTRVYgdmRhdGEgdG8gYSBkZWRpY2F0ZWQg
ZGF0YSBzdHJ1Y3R1cmUNCj4+ICAgY3J5cHRvOiBjY3AgLSBhZGQgVEVFIHN1cHBvcnQgZm9yIFJh
dmVuIFJpZGdlDQo+PiAgIGNyeXB0bzogY2NwIC0gcHJvdmlkZSBpbi1rZXJuZWwgQVBJIHRvIHN1
Ym1pdCBURUUgY29tbWFuZHMNCj4+DQo+PiAgZHJpdmVycy9jcnlwdG8vY2NwL01ha2VmaWxlICB8
ICAgIDQgKy0NCj4+ICBkcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jIHwgIDk4MyArKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+ICBkcml2ZXJzL2NyeXB0by9jY3Av
cHNwLWRldi5oIHwgICA1MCArLQ0KPj4gIGRyaXZlcnMvY3J5cHRvL2NjcC9zZXYtZGV2LmMgfCAx
MDQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gIGRyaXZl
cnMvY3J5cHRvL2NjcC9zZXYtZGV2LmggfCAgIDYyICsrKw0KPj4gIGRyaXZlcnMvY3J5cHRvL2Nj
cC9zcC1kZXYuaCAgfCAgIDE3ICstDQo+PiAgZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jICB8
ICAgNDMgKy0NCj4+ICBkcml2ZXJzL2NyeXB0by9jY3AvdGVlLWRldi5jIHwgIDM2MyArKysrKysr
KysrKysrKysNCj4+ICBkcml2ZXJzL2NyeXB0by9jY3AvdGVlLWRldi5oIHwgIDEwOSArKysrKw0K
Pj4gIGluY2x1ZGUvbGludXgvcHNwLXRlZS5oICAgICAgfCAgIDcyICsrKw0KPj4gIDEwIGZpbGVz
IGNoYW5nZWQsIDE3OTYgaW5zZXJ0aW9ucygrKSwgOTQ4IGRlbGV0aW9ucygtKQ0KPj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2NyeXB0by9jY3Avc2V2LWRldi5jDQo+PiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvY3J5cHRvL2NjcC9zZXYtZGV2LmgNCj4+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9jcnlwdG8vY2NwL3RlZS1kZXYuYw0KPj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL2NyeXB0by9jY3AvdGVlLWRldi5oDQo+PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGlu
Y2x1ZGUvbGludXgvcHNwLXRlZS5oDQo+Pg0K
