Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD33C73C64
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 23:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691A32082A
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 23:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="iIW12tQq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfGIXeM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 19:34:12 -0400
Received: from mail-eopbgr790049.outbound.protection.outlook.com ([40.107.79.49]:7897
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726324AbfGIXeM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 19:34:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiHaUsoZ4xlVij3TzYfwjjNbjEFhOAMluR0qd+soi6b+ZSKAKKcvEEWEkHrPmQnHDtbEKKg6yoOXitPC2gTndCV6dlZVzFUUl7hMMRWBRjFEwYkyPMfAy+jvu/7GciIrABrcknSrvfScLFXwWgXSZ1I6k7DLNH6mJloE3IwGT5vA3q3PwgyrqWRaOih/68qWMUSZG4qBKedx4L7pSKlG1hMRnYWZvglv0w86IMixGUTwL6gXONq2ICWNmsiC0QQdVFFzHqfPH7G+7Z5eqaALqAmwdb2Y4QrzZos7Khoh+e1hjaJpBR4UCpQgVU1oVIG5VtO9EXZIQpkZ2SYlDmRz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwY0P6/IAvt5zd7e3vvUUZjEitq60zqblUqK0gQLKGg=;
 b=YF0HHWCAbqHg03L2VDghYBCnKTU7z/Wu/9eWQp7QU1k+XxBPz6KGH8+UbH7+E6nVif7qqQZp6domDOg0exm6uWLfDSk2ihkRBftMsfNR8uGZFSqY5Vyen/AJskC90C6w7tY8vxQ2K9d8u8mlX4utVmX5c+CwOWvU6QqqT43mflD309soj18bhnBEGwMC1mK49+4U5uULbsIubQhir877WMK5js/C/uSaRNi12jH22jMG3inCc+GkUKzjNDuieC0MGyYMPZZvOaMiNw6EChPwtaOdgWWQUWv1qAsRJDHTjFKkQ231o+20xGHPONEA0AE/vqDVfyGyb1XzrPgSrCAeTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwY0P6/IAvt5zd7e3vvUUZjEitq60zqblUqK0gQLKGg=;
 b=iIW12tQqcYDi6hB64xczb5Vgs9HFm9dD0fNFFFFV7eOmlufavDCWzT2JQMhFXO1ZWoZXQr0nlB/nIK3p8WzbeTjp8w3C7HqD2Yooh76b4VO8kEsTFt5V4z2Rl5Gj47dnBLoKfcpXFrxnnPt4+9U2RQKNEJULUnY2g9qVjexEaGk=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1434.namprd12.prod.outlook.com (10.168.238.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 9 Jul 2019 23:34:09 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 23:34:09 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Topic: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVMdSCRv0gts48Gk+YiLK37j85MKa8b1UAgAQ4mwCAAhkKAIAAIUCAgAANKwCAAAqMgA==
Date:   Tue, 9 Jul 2019 23:34:08 +0000
Message-ID: <6cd19eb1-0322-95d1-8a2b-b0078ae40cca@amd.com>
References: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
 <20190705194028.GB4022@sol.localdomain>
 <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
 <20190709201014.GH641@sol.localdomain>
 <c770ea90-fad8-8379-76ad-889e410b6d74@amd.com>
 <20190709225622.GN641@sol.localdomain>
In-Reply-To: <20190709225622.GN641@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0066.namprd02.prod.outlook.com
 (2603:10b6:803:20::28) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21dece4a-f3a5-4d37-07d7-08d704c5f06e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1434;
x-ms-traffictypediagnostic: DM5PR12MB1434:
x-microsoft-antispam-prvs: <DM5PR12MB14347214362A5697496D8DB9FDF10@DM5PR12MB1434.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(6512007)(14444005)(5660300002)(8676002)(81156014)(7736002)(81166006)(6246003)(305945005)(2501003)(68736007)(31696002)(446003)(486006)(8936002)(11346002)(476003)(316002)(2201001)(36756003)(110136005)(186003)(478600001)(2616005)(256004)(76176011)(53546011)(6506007)(386003)(102836004)(26005)(6436002)(31686004)(14454004)(66476007)(66946007)(66066001)(71200400001)(71190400001)(66446008)(64756008)(66556008)(6486002)(52116002)(25786009)(99286004)(3846002)(6116002)(53936002)(229853002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1434;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1sX1s7xAWGu/lHme0IaOcGHwXtteRtn0jDHCKeajk0V+v5BC5roH/i4EUrxDLWwCSj0SzPceeVu6glFFr8EGHWAVIYXTDcW/Rsqq9I6aWXx3m3c4wwIrxd7Eolr8zpbla4Rgm+7Gl6X/ESD4kdkMTeNOIkq4RQOa1DM9hoUXths0cse07aVlWWX9eOjh3JzjIKIQ0HABkqA6X/0ekFSqu0eSFOU+nRLDgHbdK37BPWSz7MwJRccfw4yDCVzLBrXQyTUdYt0UhZL4o9igZoobi8sw5nCQ3qE+WWxhC+NpMluxU/ZAr8z+DqxwsTrbCc7w5YuQ4d8De+AS5X1mmPho7O0tYVQEBtshH9JWe6NHmvAIjNpZRv+Cc+sDyoPfdNXfUeX0XhEa4/FpVympFXtnMWx9kk7Ul1VgHRyGxnSOJDc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03D861006C94BD4CB4429A1CADE1E8D3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21dece4a-f3a5-4d37-07d7-08d704c5f06e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 23:34:08.7988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy85LzE5IDU6NTYgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gT24gVHVlLCBKdWwgMDks
IDIwMTkgYXQgMTA6MDk6MTZQTSArMDAwMCwgR2FyeSBSIEhvb2sgd3JvdGU6DQo+PiBPbiA3Lzkv
MTkgMzoxMCBQTSwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KPj4+IE9uIE1vbiwgSnVsIDA4LCAyMDE5
IGF0IDA1OjA4OjA5UE0gKzAwMDAsIEdhcnkgUiBIb29rIHdyb3RlOg0KPj4+PiBPbiA3LzUvMTkg
Mjo0MCBQTSwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KPj4+Pj4gSGkgR2FyeSwNCj4+Pj4+DQo+Pj4+
PiBPbiBXZWQsIEp1bCAwMywgMjAxOSBhdCAwNzoyMToyNlBNICswMDAwLCBIb29rLCBHYXJ5IHdy
b3RlOg0KPj4+Pj4+IFRoZSBBRVMgR0NNIGZ1bmN0aW9uIHJldXNlcyBhbiAnb3AnIGRhdGEgc3Ry
dWN0dXJlLCB3aGljaCBtZW1iZXJzDQo+Pj4+Pj4gY29udGFpbiB2YWx1ZXMgdGhhdCBtdXN0IGJl
IGNsZWFyZWQgZm9yIGVhY2ggKHJlKXVzZS4NCj4+Pj4+Pg0KPj4+Pj4+IEZpeGVzOiAzNmNmNTE1
YjliYmUgKCJjcnlwdG86IGNjcCAtIEVuYWJsZSBzdXBwb3J0IGZvciBBRVMgR0NNIG9uIHY1IEND
UHMiKQ0KPj4+Pj4+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9v
a0BhbWQuY29tPg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+ICAgICBkcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LW9wcy5jIHwgICAxMiArKysrKysrKysrKy0NCj4+Pj4+PiAgICAgMSBmaWxlIGNoYW5nZWQsIDEx
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pj4+DQo+Pj4+PiBJcyB0aGlzIHBhdGNo
IG1lYW50IHRvIGZpeCB0aGUgZ2NtLWFlcy1jY3Agc2VsZi10ZXN0cyBmYWlsdXJlPw0KPj4+Pg0K
Pj4+PiBZZXNzaXIsIHRoYXQgaXMgdGhlIGludGVudGlvbi4gQXBvbG9naWVzIGZvciBub3QgY2xh
cmlmeWluZyB0aGF0IHBvaW50Lg0KPj4+Pg0KPj4+PiBncmgNCj4+Pg0KPj4+IE9rYXksIGl0IHdv
dWxkIGJlIGhlbHBmdWwgaWYgeW91J2QgZXhwbGFpbiB0aGF0IGluIHRoZSBjb21taXQgbWVzc2Fn
ZS4NCj4+DQo+PiBHYWguIE9mIGNvdXJzZS4gSSdsbCByZXBvc3QuDQo+Pg0KPj4+IEFsc28sIHdo
YXQgYnJhbmNoIGRvZXMgdGhpcyBwYXRjaCBhcHBseSB0bz8gIEl0IGRvZXNuJ3QgYXBwbHkgdG8g
Y3J5cHRvZGV2Lg0KPj4NCj4+IEkgaGF2ZSBlbmRlYXZvcmVkIHRvIG1ha2UgYSAiZ2l0IHB1bGwi
IGFuZCBhIGZ1bGwgYnVpbGQgYSByZXF1aXJlZCwNCj4+IHJlZ3VsYXIgcGFydCBvZiBteSBzdWJt
aXNzaW9uIHByb2Nlc3MsIGhhdmluZyBtYWRlIChwbGVudHkgb2YpIG1pc3Rha2VzDQo+PiBpbiB0
aGUgcGFzdC4gSSBkaWQgc28gbGFzdCB3ZWVrIGJlZm9yZSBwb3N0aW5nIHRoaXMsIGFuZCB0aGUg
cGF0Y2gNCj4+IGFwcGxpZWQgdGhlbiwgYW5kIGFwcGxpZXMgbm93IGluIG15IGxvY2FsIGNvcHks
IGJlZm9yZSBhbmQgYWZ0ZXIgYSBnaXQNCj4+IHB1bGwgdG9kYXkuDQo+Pg0KPj4gV2UndmUgYmVl
biBoYXZpbmcgdHJvdWJsZSB3aXRoIG91ciBTTVRQIG1haWwgc2VydmVyLCBhbmQgcGF0Y2hlcyBo
YXZlDQo+PiBiZWVuIGdvaW5nIG91dCBiYXNlNjQgZW5jb2RlZC4gSSdtIHdpbGxpbmcgdG8gYmV0
IHRoYXQncyB3aGF0IHlvdSdyZQ0KPj4gd3Jlc3RsaW5nIHdpdGguDQo+Pg0KPj4gVGhlIGxhc3Qg
cGF0Y2ggb2YgbWluZSB0aGF0IEhlcmJlcnQgYXBwbGllZCBhcHBlYXJlZCB0byBiZSBlbmNvZGVk
DQo+PiB0aHVzbHksIGJ1dCBoZSB3YXMgYWJsZSB0byBzdWNjZXNzZnVsbHkgYXBwbHkgaXQuDQo+
Pg0KPj4gSSd2ZSBiZWVuIGV4cGVyaW1lbnRpbmcgd2l0aCBjaGFuZ2luZyB0aGUgdHJhbnNmZXIg
ZW5jb2RpbmcgdmFsdWUNCj4+IChjaGFyc2V0PSkgdG8gaXNvLTg4NTktMSBhbmQgdXMtYXNjaWks
IGJ1dCB0aGUgYmVzdCBJIGNhbiBkbyBpcyBhbg0KPj4gZW5jb2RpbmcgdGhhdCBjb250YWlucyBh
IGxvdCBvZiAiPSMjIiBzdHVmZi4gSSdtIG5vdCBzdXJlIHRoYXQncyBhbnkNCj4+IGJldHRlciwg
YnV0IG15IHJlY2VudCBkb2N1bWVudGF0aW9uIHBhdGNoZXMgY29udGFpbmVkIHRob3NlLCBhbmQg
SGVyYmVydA0KPj4gd2FzIGFsc28gYWJsZSB0byBhcHBseSB0aGVtLg0KPj4NCj4+IFdlJ2QgcmVh
bGx5IGxpa2UgdG8ga25vdyB3aGF0IEhlcmJlcnQgZG9lcyB0byBhY2NvbW1vZGF0ZSB0aGVzZQ0K
Pj4gbm9uLXRleHR1YWwgZW1haWxzPyBBbmQgaXMgdGhhdCBzb21ldGhpbmcgdGhhdCBvdGhlcnMg
Y291bGQgZG8/DQo+Pg0KPiANCj4gV2hhdCBJIGRpZCB3YXMgc2ltcGx5IHNhdmUgeW91ciBlbWFp
bCBhbmQgdXNlICdnaXQgYW0gLTMnIHRvIHRyeSB0byBhcHBseSBpdC4NCj4gSXQgZGlkbid0IHdv
cmsuDQo+IA0KPiBZZXMsIHlvdXIgZW1haWwgaXMgYmFzZTY0IGVuY29kZWQsIHdoaWNoIGFwcGFy
ZW50bHkgJ2dpdCBhbScgaGFuZGxlcy4gIEJ1dCBldmVuDQo+IGFmdGVyIGJhc2U2NCBkZWNvZGlu
ZyB5b3VyIHBhdGNoIGhhcyBhbiBleHRyYSBibGFuayBsaW5lIGF0IHRoZSBlbmQsIHdoaWNoDQo+
IGNvcnJ1cHRzIGl0IHNpbmNlIGl0J3MgcGFydCBvZiB0aGUgZGlmZiBjb250ZXh0Lg0KDQpJIHdh
cyB1bmF3YXJlIG9mIHRoaXMgYmVoYXZpb3IuIFRoYW5rcyBmb3IgbGV0dGluZyBtZSBrbm93Lg0K
DQo+IENhbid0IHlvdSBqdXN0IHVzZSBnaXQgc2VuZC1lbWFpbCBsaWtlIGV2ZXJ5b25lIGVsc2U/
DQoNClN1cmUsIHVudGlsIEkgZmluZCB0aGUgdGltZSB0byBmaXggc3RnaXQncyBlbWFpbCBmdW5j
dGlvbi4NCg0KSXQncyBzdGlsbCBnb2luZyB0byBiZSBxdW90ZWQtcHJpbnRhYmxlIHRleHQ7IEkg
Y2FuJ3QgZml4IHRoYXQgcHJvYmxlbSANCndpdGhvdXQgdGhlIG1haWwgZ2F0ZXdheSBjb29wZXJh
dGluZy4gQnV0IEkgcHJlc3VtZSBpdCB3aWxsIGJlIGluIHRoZSANCnByb3BlciBmb3JtYXQuIExv
b2sgZm9yIGEgdjIgYW5kIGxldCBtZSBrbm93IGhvdyBpdCBjb21lcyBvdXQuDQoNCmdyaA0K
