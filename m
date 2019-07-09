Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB016C73C53
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 22:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5C720693
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 22:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ujuNRO40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGIWJU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 18:09:20 -0400
Received: from mail-eopbgr730070.outbound.protection.outlook.com ([40.107.73.70]:18904
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfGIWJU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 18:09:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZRNrKQwy/frbB6xbi7FL2tXUhXckis1Qjrx7tQvQglD22c0nZlaRmyrJL34o7cBwPOXg+SEyVupcEYCXo5AjmlnOJvthXDNKdcsGJyviZ12gupf529S5HkWhEAa5KImkpJo6L0VRecxl83koU31hQG1I7uS5qsUZ/gCQjMR0IbpRlfONQH8XW0IAjF2ZDpOvsEezK2EQnRnqN7qDGLm8RNdayMZoE+cUsfZs1l+kBbhbOZ0OjlVQCFifCdh+ibR0JsjiVol95DoOYbql9k6G9HTh4AxS4zuNxFAPNrrLcM7+MvuWfhXdU+LAt44QTIeKtrmzjA8RdJiYj8nzif6UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hatt9XAZX0Nm8a5gOzjyhmsn1PnlffY7mMbp2y47mlM=;
 b=Yf7PbPtBFLfSuBdB6tHEJKYJHA7PPHy02RjRGcWPZh4pHlMK8NYvn4bF3JnSuT0Pz6QViHy4H1vxw1PAFcOC+g5E61577Wm1C13nKWxfNDTvJLHWm6Bo9vQbxNkKeH/tCoNaJNqtSsf8NV3diWOOd02qWybFUiDCWBeKWgxvLFpzGLP/49tlPjQpipyO1IPkjqokWL6lJRpy+cGDOSZ0RDJmKz8FCmsc+fkfwmcrbX8EQAp4OWq+O+ZWef1rpRARQwis+RiwA4ILicwmqJH0xW35o6ZfHFkg1+VkkNdbDtQ93Q3Xr6YuE3tpLhBumuaJN2Mdzk1q2g4USIYAPxMajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hatt9XAZX0Nm8a5gOzjyhmsn1PnlffY7mMbp2y47mlM=;
 b=ujuNRO40hCnDCYbozTQ7fbdWr+K/alH7ekSCMFHVMVBrIhu1AyIawVX55Tlc1fyJFa965Dw665aM4XVSgjuSzXHomwigBA9U0mEe07OQ5Oqq/tt8djQAK4n+hmTR84AyPCaK+CAH3fvLzzkHaMXHPh3iQqYzQ9fCsbE1Go6KaJE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5SPR00MB251.namprd12.prod.outlook.com (10.171.161.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 9 Jul 2019 22:09:17 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 22:09:17 +0000
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
Thread-Index: AQHVMdSCRv0gts48Gk+YiLK37j85MKa8b1UAgAQ4mwCAAhkKAIAAIUCA
Date:   Tue, 9 Jul 2019 22:09:16 +0000
Message-ID: <c770ea90-fad8-8379-76ad-889e410b6d74@amd.com>
References: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
 <20190705194028.GB4022@sol.localdomain>
 <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
 <20190709201014.GH641@sol.localdomain>
In-Reply-To: <20190709201014.GH641@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0042.namprd02.prod.outlook.com
 (2603:10b6:803:2e::28) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18fa4242-370c-4c78-dd6f-08d704ba1583
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5SPR00MB251;
x-ms-traffictypediagnostic: DM5SPR00MB251:
x-microsoft-antispam-prvs: <DM5SPR00MB25169CEE9F38DC8F4859A15FDF10@DM5SPR00MB251.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(189003)(199004)(52116002)(64756008)(66556008)(66476007)(66446008)(14454004)(2501003)(66066001)(386003)(6436002)(6506007)(71200400001)(71190400001)(53936002)(53546011)(5660300002)(102836004)(68736007)(31696002)(25786009)(2201001)(6512007)(316002)(11346002)(6246003)(256004)(14444005)(36756003)(2616005)(478600001)(2906002)(446003)(8936002)(26005)(229853002)(76176011)(6486002)(6116002)(486006)(7736002)(476003)(305945005)(31686004)(99286004)(66946007)(110136005)(3846002)(81156014)(8676002)(81166006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5SPR00MB251;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YS9pNBDf1lGVsGGtPfAL5ZuHxgLT9h6vhn/Hu4/S0WW5ZbM/Y7/BYOdBdytSEgkE4szoy2HZGvFRfnx5xTkE+r14jcsLlWUS7+A4wGAcWPF4wNzEtTQtqM8IndAqOmZp4EIhwc2oE3dZwOLJWUzd9e7q/yIBreAwFxx5HlR7pVqSAWuy+fLSX7RwdRyS1sAoZBbKzNXwWIi5KA9OiJzyRK7NKjPWuZeSpQ14YTgq1A5+zepVxmgH4ByxVG0GQ27J/kwTyJvBl78AUwryDzWvVSqrEKBDcG26+nZhoALZ2DusbtVbcLS9h6Cp3fjMFWEqBcdKC/DwRnxILqvXlYh90l8V0X+XQ7YLkB6Xvb29hJAMU2T5SblWao7V1xeAB/iOLc9KDUuJ06BivtH/sYqqp7PyQcaPuwU7jT0ZCHwN+CA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3462A09D91C5F2408FF13033201B59EE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fa4242-370c-4c78-dd6f-08d704ba1583
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 22:09:17.0528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5SPR00MB251
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy85LzE5IDM6MTAgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gT24gTW9uLCBKdWwgMDgs
IDIwMTkgYXQgMDU6MDg6MDlQTSArMDAwMCwgR2FyeSBSIEhvb2sgd3JvdGU6DQo+PiBPbiA3LzUv
MTkgMjo0MCBQTSwgRXJpYyBCaWdnZXJzIHdyb3RlOg0KPj4+IEhpIEdhcnksDQo+Pj4NCj4+PiBP
biBXZWQsIEp1bCAwMywgMjAxOSBhdCAwNzoyMToyNlBNICswMDAwLCBIb29rLCBHYXJ5IHdyb3Rl
Og0KPj4+PiBUaGUgQUVTIEdDTSBmdW5jdGlvbiByZXVzZXMgYW4gJ29wJyBkYXRhIHN0cnVjdHVy
ZSwgd2hpY2ggbWVtYmVycw0KPj4+PiBjb250YWluIHZhbHVlcyB0aGF0IG11c3QgYmUgY2xlYXJl
ZCBmb3IgZWFjaCAocmUpdXNlLg0KPj4+Pg0KPj4+PiBGaXhlczogMzZjZjUxNWI5YmJlICgiY3J5
cHRvOiBjY3AgLSBFbmFibGUgc3VwcG9ydCBmb3IgQUVTIEdDTSBvbiB2NSBDQ1BzIikNCj4+Pj4N
Cj4+Pj4gU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPj4+
PiAtLS0NCj4+Pj4gICAgZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYyB8ICAgMTIgKysrKysr
KysrKystDQo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+Pj4NCj4+PiBJcyB0aGlzIHBhdGNoIG1lYW50IHRvIGZpeCB0aGUgZ2NtLWFlcy1j
Y3Agc2VsZi10ZXN0cyBmYWlsdXJlPw0KPj4NCj4+IFllc3NpciwgdGhhdCBpcyB0aGUgaW50ZW50
aW9uLiBBcG9sb2dpZXMgZm9yIG5vdCBjbGFyaWZ5aW5nIHRoYXQgcG9pbnQuDQo+Pg0KPj4gZ3Jo
DQo+IA0KPiBPa2F5LCBpdCB3b3VsZCBiZSBoZWxwZnVsIGlmIHlvdSdkIGV4cGxhaW4gdGhhdCBp
biB0aGUgY29tbWl0IG1lc3NhZ2UuDQoNCkdhaC4gT2YgY291cnNlLiBJJ2xsIHJlcG9zdC4NCg0K
PiBBbHNvLCB3aGF0IGJyYW5jaCBkb2VzIHRoaXMgcGF0Y2ggYXBwbHkgdG8/ICBJdCBkb2Vzbid0
IGFwcGx5IHRvIGNyeXB0b2Rldi4NCg0KSSBoYXZlIGVuZGVhdm9yZWQgdG8gbWFrZSBhICJnaXQg
cHVsbCIgYW5kIGEgZnVsbCBidWlsZCBhIHJlcXVpcmVkLCANCnJlZ3VsYXIgcGFydCBvZiBteSBz
dWJtaXNzaW9uIHByb2Nlc3MsIGhhdmluZyBtYWRlIChwbGVudHkgb2YpIG1pc3Rha2VzIA0KaW4g
dGhlIHBhc3QuIEkgZGlkIHNvIGxhc3Qgd2VlayBiZWZvcmUgcG9zdGluZyB0aGlzLCBhbmQgdGhl
IHBhdGNoIA0KYXBwbGllZCB0aGVuLCBhbmQgYXBwbGllcyBub3cgaW4gbXkgbG9jYWwgY29weSwg
YmVmb3JlIGFuZCBhZnRlciBhIGdpdCANCnB1bGwgdG9kYXkuDQoNCldlJ3ZlIGJlZW4gaGF2aW5n
IHRyb3VibGUgd2l0aCBvdXIgU01UUCBtYWlsIHNlcnZlciwgYW5kIHBhdGNoZXMgaGF2ZSANCmJl
ZW4gZ29pbmcgb3V0IGJhc2U2NCBlbmNvZGVkLiBJJ20gd2lsbGluZyB0byBiZXQgdGhhdCdzIHdo
YXQgeW91J3JlIA0Kd3Jlc3RsaW5nIHdpdGguDQoNClRoZSBsYXN0IHBhdGNoIG9mIG1pbmUgdGhh
dCBIZXJiZXJ0IGFwcGxpZWQgYXBwZWFyZWQgdG8gYmUgZW5jb2RlZCANCnRodXNseSwgYnV0IGhl
IHdhcyBhYmxlIHRvIHN1Y2Nlc3NmdWxseSBhcHBseSBpdC4NCg0KSSd2ZSBiZWVuIGV4cGVyaW1l
bnRpbmcgd2l0aCBjaGFuZ2luZyB0aGUgdHJhbnNmZXIgZW5jb2RpbmcgdmFsdWUgDQooY2hhcnNl
dD0pIHRvIGlzby04ODU5LTEgYW5kIHVzLWFzY2lpLCBidXQgdGhlIGJlc3QgSSBjYW4gZG8gaXMg
YW4gDQplbmNvZGluZyB0aGF0IGNvbnRhaW5zIGEgbG90IG9mICI9IyMiIHN0dWZmLiBJJ20gbm90
IHN1cmUgdGhhdCdzIGFueSANCmJldHRlciwgYnV0IG15IHJlY2VudCBkb2N1bWVudGF0aW9uIHBh
dGNoZXMgY29udGFpbmVkIHRob3NlLCBhbmQgSGVyYmVydCANCndhcyBhbHNvIGFibGUgdG8gYXBw
bHkgdGhlbS4NCg0KV2UnZCByZWFsbHkgbGlrZSB0byBrbm93IHdoYXQgSGVyYmVydCBkb2VzIHRv
IGFjY29tbW9kYXRlIHRoZXNlIA0Kbm9uLXRleHR1YWwgZW1haWxzPyBBbmQgaXMgdGhhdCBzb21l
dGhpbmcgdGhhdCBvdGhlcnMgY291bGQgZG8/DQoNCmdyaA0K
