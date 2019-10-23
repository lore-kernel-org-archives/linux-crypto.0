Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABC2CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 16:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F34622084C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 16:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xa1wrQAo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407281AbfJWQ1a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 12:27:30 -0400
Received: from mail-eopbgr690043.outbound.protection.outlook.com ([40.107.69.43]:22076
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389149AbfJWQ13 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 12:27:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeTeYs2wQDeQtPjbGGP74M4UQgArbK8iDrJ5X0YEXUv4MNyVWUBzXFU0aY6vT9VAzXfhBkFZlxMuhjiAR+OR2cjctotX10T8taFrGOrVBs3XwoWRR8RpwlR3Bl52Nsxidst+MbQaQS+5bplD4orkmi+i9gBuJTFfLuFS6ZGBl5h54vUDBOX/MGEvJgmS37EdWa2dV9eKx8VOr8+t+hIbok3cuxSzh6qfCS6A9yRR8JlnMORiaEkVLZSBlNVwpW8JzXwbnSaXtdu2HcK+3fJV3m1b8LXCDDYCIX+arQBB20R9N4NlPx5QG1GTu8GdD8GlKawoqXlV7kkFBCN/spqTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/PyXqd81j2BZKCJs/WYGtoM+U9YO7GmEUiGcGF4m/4=;
 b=T4zIBQg7WZpW9o0jR2Um0QRW2YmFR4kQXkqPf9lqh2uRdCVpsW7I9mtaux4hah/bAGQ1auJzn34k1xE5bRFcoe1GYgEsG1inLAUa91MiA81ytkzTU1Cqk9xfrSbEqnCVk4Un0wnCso7P53pFx3n2v+alTPxQTt6sUM4NXxXph0F9LQ6eaMuK+bbURbmXNDJnopnBojBG/hgCQHh6lT763AIt93e3bG05/nnvEKKAHh1KuvyNsIpRZf+v1OSOj84gZ7Ng91eUneQa+qx0t1hU1b5vkDmSLK3TGsSLB0QUaSZQ7Y5z4DBDXYUiY4U6a7NdMTVrlVNSCAUNQsJlZzYDJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/PyXqd81j2BZKCJs/WYGtoM+U9YO7GmEUiGcGF4m/4=;
 b=xa1wrQAoGZTv1FKK5oGDamAa+1ZptGm32uaW58hgvumek8mPapMy1dzNPShiFjMbVGxw+v15mJZ6Sswg7JQZ06RIxMqE/KsBaaDgR7eEmGiGtAZaZ1hQwtzDf6Y1slnY7w6prgd4yyoNhG0OXerPrH35eXRfF3EeQgABCn0EDm8=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2908.namprd12.prod.outlook.com (20.179.71.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Wed, 23 Oct 2019 16:27:26 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2367.022; Wed, 23 Oct 2019
 16:27:26 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
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
Thread-Index: AQHViZTX3R3UO0PPhkOgyRS+vzwoTKdoalYA
Date:   Wed, 23 Oct 2019 16:27:26 +0000
Message-ID: <24a6506c-eb90-5a70-862f-95571e668a5d@amd.com>
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
In-Reply-To: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:805:8e::34) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7d4a3a9-0e67-4b24-af70-08d757d5e403
x-ms-traffictypediagnostic: DM6PR12MB2908:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB290804D38D1646403B4543AAEC6B0@DM6PR12MB2908.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(199004)(189003)(486006)(256004)(31686004)(11346002)(2616005)(476003)(446003)(5660300002)(3846002)(6116002)(31696002)(66946007)(86362001)(2201001)(229853002)(14444005)(64756008)(66446008)(66556008)(386003)(6506007)(53546011)(102836004)(26005)(186003)(2906002)(66476007)(2501003)(71200400001)(71190400001)(110136005)(316002)(54906003)(76176011)(7736002)(305945005)(81156014)(4326008)(8676002)(99286004)(52116002)(6512007)(478600001)(14454004)(6306002)(966005)(6436002)(6246003)(6486002)(25786009)(8936002)(66066001)(81166006)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2908;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FkV4QEd2KSv+7oId3YHXbobOqOnofNVOr8RtnIirVy/v0qzRUtFRpA078361nIYoNrl+Ov+19UKnoxX5FIk2g4QkkToFAhTkPcmw2JMtpWl2d0V+4J/UlbS3A9QZBalSswEdaBaBfBitTrmJYOdaeiB3ZMQYPQ5ZqX1A6+nbgj7bnjugwOr+2DpwlUR7b7hPWBYx5E4DHKTUapn/449VIEmzFzRbNeVXANTvb5N5cRqBqXoB8CDzSs4JROTKut8QnJQEd1dMvGOpeg/01bdoBS2fTkmQb32IBDwzx2Y6oWKrIostUsFfA/QrUD0M8rgAuJrhju+EF1EjtajOIx156ZB5KIjwU/jQgmLP5iVZAqWGmI9YrAI4NUgHeqSFW0IsY+Mgtho6jQt1H6Es9PtFrhZ5iuSK9BcCMgFCu/SQSG2Ej5+bQbSnIZl/+xFsmI74s0JcBZf7fQh2TKFhWT1GJTBRccPFIlmW6LQidXEG0jw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D691747F92BFE8479A08C4267D272601@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d4a3a9-0e67-4b24-af70-08d757d5e403
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 16:27:26.7228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RG9uAy1LGVg6H/dlmzMfTbMmrP0Ay/pJBzfrOGFxNpb6uEaIkoYif/IGHKDi6qm3siy+7yxnKP853u8rX/XjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2908
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMTAvMjMvMTkgNjoyNyBBTSwgVGhvbWFzLCBSaWpvLWpvaG4gd3JvdGU6DQo+IFRoZSBnb2Fs
IG9mIHRoaXMgcGF0Y2ggc2VyaWVzIGlzIHRvIGludHJvZHVjZSBURUUgKFRydXN0ZWQgRXhlY3V0
aW9uDQo+IEVudmlyb25tZW50KSBpbnRlcmZhY2Ugc3VwcG9ydCB0byBBTUQgU2VjdXJlIFByb2Nl
c3NvciBkcml2ZXIuIFRoZQ0KPiBURUUgaXMgYSBzZWN1cmUgYXJlYSBvZiBhIHByb2Nlc3NvciB3
aGljaCBlbnN1cmVzIHRoYXQgc2Vuc2l0aXZlIGRhdGENCj4gaXMgc3RvcmVkLCBwcm9jZXNzZWQg
YW5kIHByb3RlY3RlZCBpbiBhbiBpc29sYXRlZCBhbmQgdHJ1c3RlZA0KPiBlbnZpcm9ubWVudC4g
VGhlIFBsYXRmb3JtIFNlY3VyaXR5IFByb2Nlc3NvciAoUFNQKSBpcyBhIGRlZGljYXRlZA0KPiBw
cm9jZXNzb3Igd2hpY2ggcHJvdmlkZXMgVEVFIHRvIGVuYWJsZSBIVyBwbGF0Zm9ybSBzZWN1cml0
eS4gSXQgb2ZmZXJzDQo+IHByb3RlY3Rpb24gYWdhaW5zdCBzb2Z0d2FyZSBhdHRhY2tzIGdlbmVy
YXRlZCBpbiBSaWNoIE9wZXJhdGluZyBTeXN0ZW0NCj4gKFJpY2ggT1MpIHN1Y2ggYXMgTGludXgg
cnVubmluZyBvbiB4ODYuDQo+IA0KPiBCYXNlZCBvbiB0aGUgcGxhdGZvcm0gZmVhdHVyZSBzdXBw
b3J0LCB0aGUgUFNQIGlzIGNhcGFibGUgb2Ygc3VwcG9ydGluZw0KPiBlaXRoZXIgU0VWIChTZWN1
cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uKSBhbmQvb3IgVEVFLiBUaGUgZmlyc3QgdGhyZWUN
Cj4gcGF0Y2hlcyBpbiB0aGlzIHNlcmllcyBpcyBhYm91dCBtb3ZpbmcgU0VWIHNwZWNpZmljIGZ1
bmN0aW9ucyBhbmQgZGF0YQ0KPiBzdHJ1Y3R1cmVzIGZyb20gUFNQIGRldmljZSBkcml2ZXIgZmls
ZSB0byBhIGRlZGljYXRlZCBTRVYgaW50ZXJmYWNlDQo+IGRyaXZlciBmaWxlLiBUaGUgbGFzdCB0
d28gcGF0Y2hlcyBhZGQgVEVFIGludGVyZmFjZSBzdXBwb3J0IHRvIEFNRA0KPiBTZWN1cmUgUHJv
Y2Vzc29yIGRyaXZlci4gVGhpcyBURUUgaW50ZXJmYWNlIHdpbGwgYmUgdXNlZCBieSBBTUQtVEVF
DQo+IGRyaXZlciB0byBzdWJtaXQgY29tbWFuZCBidWZmZXJzIGZvciBwcm9jZXNzaW5nIGluIFBT
UCBUcnVzdGVkIEV4ZWN1dGlvbg0KPiBFbnZpcm9ubWVudC4NCg0KVGhlcmUgYXJlIHNvbWUgb3V0
c3RhbmRpbmcgcGF0Y2hlcyB0aGF0IGhhdmUgYmVlbiBzdWJtaXR0ZWQgdGhhdCBtb2RpZnkNCnNv
bWUgb2YgdGhlIHNhbWUgZmlsZXMgeW91IGFyZSBtb2RpZnlpbmcsIHNvIHlvdSdsbCBuZWVkIHRv
IHJlYmFzZSBhZnRlcg0KdGhvc2UgcGF0Y2hlcyBhcmUgYXBwbGllZC4gQWxzbywgb25lIHBhdGNo
IHdhcyBhcHBsaWVkIHRocm91Z2ggdGhlIEtWTQ0KdHJlZSwgbm90IHN1cmUgaG93IHRvIGhhbmRs
ZSB0aGF0Lg0KDQpGb3IgcmVmZXJlbmNlLCBoZXJlIGFyZSB0aGUgc3VibWl0dGVkIHBhdGNoZXM6
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS82MTA4NTYxZTM5MjQ2MGFkZTY3ZjdmNzBk
OWJmYTlmNTZhOTI1ZDBhLjE1NzAxMzc0NDcuZ2l0LnRob21hcy5sZW5kYWNreUBhbWQuY29tLw0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMTkxMDE3MjIzNDU5LjY0Mjgx
LTEtQXNoaXNoLkthbHJhQGFtZC5jb20vDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1j
cnlwdG8vMTU3MTY2NTQ4MjU5LjI4Mjg3LjE4MTE4ODAyOTA5ODAxNjgxNTQ2LnN0Z2l0QHRhb3Mv
DQoNClRoYW5rcywNClRvbQ0KDQo+IA0KPiBSaWpvIFRob21hcyAoNSk6DQo+ICAgY3J5cHRvOiBj
Y3AgLSByZW5hbWUgcHNwLWRldiBmaWxlcyB0byBzZXYtZGV2DQo+ICAgY3J5cHRvOiBjY3AgLSBj
cmVhdGUgYSBnZW5lcmljIHBzcC1kZXYgZmlsZQ0KPiAgIGNyeXB0bzogY2NwIC0gbW92ZSBTRVYg
dmRhdGEgdG8gYSBkZWRpY2F0ZWQgZGF0YSBzdHJ1Y3R1cmUNCj4gICBjcnlwdG86IGNjcCAtIGFk
ZCBURUUgc3VwcG9ydCBmb3IgUmF2ZW4gUmlkZ2UNCj4gICBjcnlwdG86IGNjcCAtIHByb3ZpZGUg
aW4ta2VybmVsIEFQSSB0byBzdWJtaXQgVEVFIGNvbW1hbmRzDQo+IA0KPiAgZHJpdmVycy9jcnlw
dG8vY2NwL01ha2VmaWxlICB8ICAgIDQgKy0NCj4gIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2
LmMgfCAgOTgzICsrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgZHJp
dmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuaCB8ICAgNTAgKy0NCj4gIGRyaXZlcnMvY3J5cHRvL2Nj
cC9zZXYtZGV2LmMgfCAxMDQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiAgZHJpdmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuaCB8ICAgNjIgKysrDQo+ICBkcml2
ZXJzL2NyeXB0by9jY3Avc3AtZGV2LmggIHwgICAxNyArLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2Nw
L3NwLXBjaS5jICB8ICAgNDMgKy0NCj4gIGRyaXZlcnMvY3J5cHRvL2NjcC90ZWUtZGV2LmMgfCAg
MzYzICsrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9jcnlwdG8vY2NwL3RlZS1kZXYuaCB8ICAx
MDkgKysrKysNCj4gIGluY2x1ZGUvbGludXgvcHNwLXRlZS5oICAgICAgfCAgIDcyICsrKw0KPiAg
MTAgZmlsZXMgY2hhbmdlZCwgMTc5NiBpbnNlcnRpb25zKCspLCA5NDggZGVsZXRpb25zKC0pDQo+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuYw0KPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvY3J5cHRvL2NjcC9zZXYtZGV2LmgNCj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL2NyeXB0by9jY3AvdGVlLWRldi5jDQo+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9jcnlwdG8vY2NwL3RlZS1kZXYuaA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0
IGluY2x1ZGUvbGludXgvcHNwLXRlZS5oDQo+IA0K
