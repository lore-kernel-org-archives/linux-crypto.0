Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CE1C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 15:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375462075B
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 15:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Ije8vLYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfDOPcZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:32:25 -0400
Received: from mail-eopbgr710050.outbound.protection.outlook.com ([40.107.71.50]:56839
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727143AbfDOPcZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 11:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXAau5F23T7zj9Fwo6pnL5aco/O4mfBmQkIDOJZgOBU=;
 b=Ije8vLYvII0mvGSUmacn8Q4oNW7hUD8syNWIQ/luIULziUKT1QeVOEuvxc2SjmZh8Qj0vgbgj/92Ot4nPmKou3EXomyy3ehdJ4S9244Nuk6Ir5lqVo35TeYnuMxCqT7j2zuSTDW8MromH2gq17jZbO8ETp7pcLP1WB0uqCibjJs=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2633.namprd12.prod.outlook.com (20.176.116.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Mon, 15 Apr 2019 15:32:17 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c96d:c1dd:fd7a:ffd6]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c96d:c1dd:fd7a:ffd6%4]) with mapi id 15.20.1792.018; Mon, 15 Apr 2019
 15:32:17 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     Hao Feng <fenghao@hygon.cn>, "Hook, Gary" <Gary.Hook@amd.com>,
        'Herbert Xu ' <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        'Joerg Roedel ' <joro@8bytes.org>,
        'Paolo Bonzini ' <pbonzini@redhat.com>,
        =?utf-8?B?JyBSYWRpbSBLcsSNbcOhxZkgJw==?= <rkrcmar@redhat.com>,
        'Thomas Gleixner ' <tglx@linutronix.de>,
        'Ingo Molnar ' <mingo@redhat.com>,
        'Borislav Petkov ' <bp@alien8.de>,
        "' H. Peter Anvin '" <hpa@zytor.com>
CC:     'Zhaohui Du ' <duzhaohui@hygon.cn>,
        'Zhiwei Ying ' <yingzhiwei@hygon.cn>,
        'Wen Pu ' <puwen@hygon.cn>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Relph, Richard" <Richard.Relph@amd.com>
Subject: Re: [PATCH 0/6] Add Hygon SEV support
Thread-Topic: [PATCH 0/6] Add Hygon SEV support
Thread-Index: AQHU84Pcre/tauf78UCRAWMNE1c/QKY9WcUA
Date:   Mon, 15 Apr 2019 15:32:17 +0000
Message-ID: <e3decaf3-481c-d1b7-945c-0bc257122220@amd.com>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
In-Reply-To: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:805:f2::46) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eca976f-1de1-440f-fc4d-08d6c1b78acb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB2633;
x-ms-traffictypediagnostic: DM6PR12MB2633:
x-microsoft-antispam-prvs: <DM6PR12MB263387996A4525D2FA3A0C23EC2B0@DM6PR12MB2633.namprd12.prod.outlook.com>
x-forefront-prvs: 000800954F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(366004)(199004)(189003)(2616005)(6436002)(97736004)(54906003)(14444005)(71190400001)(71200400001)(99286004)(256004)(229853002)(81166006)(110136005)(81156014)(66066001)(8676002)(7416002)(68736007)(6512007)(8936002)(316002)(386003)(6506007)(6116002)(3846002)(53546011)(186003)(102836004)(26005)(105586002)(31696002)(86362001)(106356001)(5660300002)(7736002)(2906002)(36756003)(31686004)(478600001)(72206003)(6246003)(4326008)(6486002)(53936002)(25786009)(11346002)(14454004)(446003)(76176011)(305945005)(52116002)(486006)(476003)(3714002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2633;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JHas9jppEWaVRaJXRAv8j3h51h0EuwYjI2SilfDkFf4h+PW+hpIOT8JbfnRWDms5OZJb7o6Zu6IEMro4/qRSkg8zcjIwtZDvfQhFujF//Yu6KX+S84RCx6XecYsgfTJGHKXG5P3HgGsWclgk+NsIqCkzApg4rDtm0J+S9dPJy+vWxTvxverr9d61GX+TpEzPhT1+7eVEoOYTFkLysxcGcoF5A/O7mhdpxbWrINCaDloT2eMCaQHSQRRCimrhwG7Zp0pAjClG6n+ERiUPHc5QUplXhIEhtuzH8F13V3jQj/GNX29DHkTdGQ1tS9Xc+A2CXtt8jkAJu3MLzJIWubbM81K/IIa128mDQWYjVwaruFdKUMm8ZpK8/UfmWfMt0mW50MTQURnRc6rtGjG3jvIKsSvH0DAeUNnz81HD3UUPhUk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31A813669C6C20418080A80EE6B590E6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eca976f-1de1-440f-fc4d-08d6c1b78acb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2019 15:32:17.5166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2633
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNC8xNS8xOSA3OjA0IEFNLCBIYW8gRmVuZyB3cm90ZToNCj4gSHlnb24gU0VWIGZvbGxvd3Mg
QU1EIFNFViB3b3JrIGZsb3csIGJ1dCB1c2VzIENoaW5hIG5hdGlvbmFsIHN0YW5kYXJkDQo+IGNy
eXB0b2dyYXBoaWMgYWxnb3JpdGhtcyBTTTIvU00zL1NNNCBpbnN0ZWFkIG9mIChSU0EsIEVDRFNB
LA0KPiBFQ0RIKS9TSEEvQUVTLiBSZXVzZSBtb3N0IEFNRCBTRVYgY29kZSBwYXRoIHRvIHN1cHBv
cnQgSHlnb24gU0VWLA0KPiBhbHNvIGFkZHMgMyBuZXcgY29tbWFuZHMoR01fUFVCS0VZX0dFTiwg
R01fR0VUX0RJR0VTVCwNCj4gR01fVkVSSUZZX0RJR0VTVCkgdG8gc3VwcG9ydCBTTTIga2V5IGV4
Y2hhbmdlIHByb3RvY29sLg0KPiANCj4gU00yIGlzIGJhc2VkIG9uIEVDQyhFbGxpcHRpYyBDdXJ2
ZSBDcnlwdG9ncmFwaHkpLCBhbmQgdXNlcyBhIHNwZWNpYWwNCj4gY3VydmUuIEl0IGNhbiBiZSB1
c2VkIGluIGRpZ2l0YWwgc2lnbmF0dXJlLCBrZXkgZXhjaGFuZ2UgYW5kDQo+IGFzeW1tZXRyaWMg
Y3J5cHRvZ3JhcGh5LiBGb3Iga2V5IGV4Y2hhbmdlLCBTTTIgaXMgc2ltaWxhciB0byBFQ0RILCBi
dXQNCj4gaW52b2x2ZXMgbmV3IHJhbmRvbSBrZXksIG1lYW5pbmcgdGhlIHR3byBzaWRlcyBuZWVk
IHRvIGV4Y2hhbmdlIGV4dHJhDQo+IHJhbmRvbSBwdWJsaWMga2V5IGJlc2lkZXMgdGhlaXIgcHVi
bGljIGtleSwgdGhhdCdzIHdoeSBhZGRpdGlvbmFsIEFQSXMNCj4gYXJlIG5lZWRlZCB0byBzdXBw
b3J0IEh5Z29uIFNFVi4NCj4gU00zIGlzIGEgaGFzaCBhbGdvcml0aG0sIHNpbWlsYXIgdG8gU0hB
LTI1Ni4NCj4gU000IGlzIGEgYmxvY2sgY2lwaGVyIGFsZ29yaXRobSwgc2ltaWxhciB0byBBRVMt
MTI4Lg0KPiANCj4gMS4gR01fUFVCS0VZX0dFTg0KPiAtLS0tLS0tLS0tLS0tLS0tDQo+IFRoZSBj
b21tYW5kIGlzIHVzZWQgdG8gZ2V0IFNNMiByYW5kb20gcHVibGljIGtleSBmcm9tIFNFViBmaXJt
d2FyZSB0bw0KPiBjb21wdXRlIHNoYXJlIGtleS4NCj4gDQo+IFBhcmFtZXRlcnM6DQo+ICogR01f
S0VZX0lEX1BBRERSIChpbikgLSBBZGRyZXNzIG9mIGtleSBJRCBmb3IgdGhlIHJhbmRvbSBwdWJs
aWMga2V5Lg0KPiAqIEdNX0tFWV9JRF9MRU4gKGluKSAtIExlbmd0aCBvZiBrZXkgSUQuDQo+ICog
R01fUFVCS0VZX1BBRERSIChpbikgLSBBZGRyZXNzIG9mIHRoZSByYW5kb20gcHVibGljIGtleS4N
Cj4gKiBHTV9QVUJLRVlfTEVOIChpbixvdXQpIC0gTGVuZ3RoIG9mIHRoZSByYW5kb20gcHVibGlj
IGtleS4NCj4gDQo+IDIuIEdNX0dFVF9ESUdFU1QNCj4gLS0tLS0tLS0tLS0tLS0tLQ0KPiBUaGUg
Y29tbWFuZCBpcyB1c2VkIHRvIGdldCBrZXkgZGlnZXN0IGZyb20gU0VWIGZpcm13YXJlIGR1cmlu
ZyBTTTIga2V5DQo+IGV4Y2hhbmdlLCBndWVzdCBvd25lciBjYW4gY2hlY2sgdGhlIGRpZ2VzdCB0
byBzZWUgaWYgdGhlIGtleQ0KPiBuZWdvdGlhdGlvbiBpcyBzdWNjZXNzZnVsIG9yIG5vdC4NCj4g
DQo+IFBhcmFtZXRlcnM6DQo+ICogSEFORExFIChpbikgLSBHdWVzdCBoYW5kbGUNCj4gKiBESUdF
U1RfUEFERFIgKGluKSAtIEFkZHJlc3Mgb2YgdGhlIGtleSBkaWdlc3QNCj4gKiBESUdFU1RfTEVO
IChpbiwgb3V0KSAtIExlbmd0aCBvZiB0aGUga2V5IGRpZ2VzdA0KPiANCj4gMy4gR01fVkVSSUZZ
X0RJR0VTVA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tDQo+IFRoZSBjb21tYW5kIGlzIHVzZWQgdG8g
c2VuZCBndWVzdCBvd25lcidzIGtleSBkaWdlc3QgdG8gU0VWIGZpcm13YXJlDQo+IGR1cmluZyBT
TTIga2V5IGV4Y2hhbmdlLCBmaXJtd2FyZSBjYW4gY2hlY2sgdGhlIGRpZ2VzdCB0byBzZWUgaWYg
dGhlDQo+IG5lZ290aWF0aW9uIGlzIHN1Y2Nlc3NmdWwgb3Igbm90Lg0KPiANCj4gUGFyYW1ldGVy
czoNCj4gKiBIQU5ETEUgKGluKSAtIEd1ZXN0IGhhbmRsZQ0KPiAqIERJR0VTVF9QQUREUiAoaW4p
IC0gQWRkcmVzcyBvZiB0aGUga2V5IGRpZ2VzdA0KPiAqIERJR0VTVF9MRU4gKGluKSAtIExlbmd0
aCBvZiB0aGUga2V5IGRpZ2VzdA0KPiANCj4gQWxyZWFkeSB0ZXN0ZWQgc3VjY2Vzc2Z1bGx5IG9u
IEh5Z29uIERoeWFuYVBsdXMgcHJvY2Vzc29yLCBhbHNvIHRlc3RlZA0KPiBzdWNjZXNzZnVsbHkg
b24gQU1EIEVQWUMgcHJvY2Vzc29yLCByZXN1bHRzIHNob3cgbm8gc2lkZSBlZmZlY3Qgb24NCj4g
Y3VycmVudCBBTUQgU0VWIGltcGxlbWVudGF0aW9uLg0KDQpZb3UgY2FuJ3QganVzdCByYW5kb21s
eSBhZGQgY29tbWFuZHMgdG8gdGhlIFNFViBBUEkuICBZb3Ugd2lsbCBuZWVkIHRvDQp3b3JrIHdp
dGggdGhlIFNFViBBUEkgc3BlY2lmaWNhdGlvbiBvd25lciB0byBiZSBzdXJlIHRoZXJlIGFyZSBu
b3QgYW55DQpjb25mbGljdHMgb3Igb3RoZXIgaXNzdWVzIHdpdGggd2hhdCB5b3UgYXJlIHRyeWlu
ZyB0byBkby4gUGxlYXNlIHdvcmsNCndpdGggUmljaGFyZCBSZWxwaCAoUmljaGFyZC5SZWxwaEBh
bWQuY29tKSBvbiB0aGlzLg0KDQpGb3Igbm93LCBOQUsgb24gYWxsIG9mIHRoaXMuDQoNClRoYW5r
cywNClRvbQ0KDQo+IA0KPiBIYW8gRmVuZyAoNik6DQo+ICAgY3J5cHRvOiBjY3A6IEFkZCBIeWdv
biBEaHlhbmEgc3VwcG9ydA0KPiAgIGNyeXB0bzogY2NwOiBEZWZpbmUgSHlnb24gU0VWIGNvbW1h
bmRzDQo+ICAgY3J5cHRvOiBjY3A6IEltcGxlbWVudCBTRVZfR01fUFVCS0VZX0dFTiBpb2N0bCBj
b21tYW5kDQo+ICAgS1ZNOiBEZWZpbmUgSHlnb24gU0VWIGNvbW1hbmRzDQo+ICAgS1ZNOiBTVk06
IEFkZCBzdXBwb3J0IGZvciBLVk1fU0VWX0dNX0dFVF9ESUdFU1QgY29tbWFuZA0KPiAgIEtWTTog
U1ZNOiBBZGQgS1ZNX1NFVl9HTV9WRVJJRllfRElHRVNUIGNvbW1hbmQNCj4gDQo+ICBhcmNoL3g4
Ni9rdm0vc3ZtLmMgICAgICAgICAgIHwgMTE5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMgfCAgODYgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBj
aS5jICB8ICAgMiArDQo+ICBpbmNsdWRlL2xpbnV4L3BzcC1zZXYuaCAgICAgIHwgIDQ5ICsrKysr
KysrKysrKysrKysrKw0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oICAgICB8ICAxNCArKysr
Kw0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L3BzcC1zZXYuaCB8ICAxNyArKysrKysrDQo+ICA2IGZp
bGVzIGNoYW5nZWQsIDI4NyBpbnNlcnRpb25zKCspDQo+IA0K
