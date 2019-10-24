Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A46ECA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 11:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E775D2166E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 11:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="OSNsVYtH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJXLTo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 07:19:44 -0400
Received: from mail-eopbgr790049.outbound.protection.outlook.com ([40.107.79.49]:42710
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408172AbfJXLTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 07:19:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyZfe6zRVE8Zw1rsWxEcf/DZBg7D4kbmuf3TmtI4vA/CI4oBB4oLhd6H/oxn6w3o3LI/eUwMZMWLVcvTMWvVHqtwQ6sicU3f5VGhVEfeCLUQfiRgYcNDfFZs4xd5wqCHTiNbW4qeoSmN99sQ3WbZXCeymaV0bf+2dqbQWJCgoAvH01x+5kYnnfMrxnWL6vMbNcsnlBaXZhACbmoN3pM1IazQlzcHNOzfGpNYBWUV2S+poNhd9P6uFaVtzrEAs/ertOZWBGB5sgFERYhhms1Q3keIPxlB1CFNdtzdXCkvKUbXDxCGyGoXNnuQDbMSUl9/kFXvF0H6hVFIQQ7Roe32XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EwQtrCZhziyw24Hhjw+dBw546+KmBTA6sRa3JkWHos=;
 b=OYErbNvGpCXqU6il8bCbHcmRj3HBZWg/p3M7YMEw90SWM8Qf084jeFSEqaO1pQt7I0V7q/mCsis7u4kWJv0HI3g/EHqst2nZonzX6VCjtNTbWpC9cBDMNF1zdHHT7iFxDlsjaujJ67ae1xPamLoJZBSwLr+qHJEeCmJyqshv+FdmiBZdF3Fc0JtPShzJw8aPhPR/XgbEZqhbJxMINGEd9bnLExP1ccrgMOqss8cOWbR8FskvN40ecTHr81zP7KHKdhkPPZjSdDJfdEcdOXxAK98JlYyVJMV1HN8gHJA0A/9J8xEcNSP2fmTd66VzrhQi9XzVPicFHW0NzPLq9jEC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EwQtrCZhziyw24Hhjw+dBw546+KmBTA6sRa3JkWHos=;
 b=OSNsVYtHs8scjrhVKqMbMaVWUjW2tRfHb6gaNYMtXCpTRiX0lA49wM8kDW591m6kJL6SVAy0H6Sll3DxMTlEmCdD7/oUWqiU5gPusiQsUk0h7MHTrTC20i9ZERRhgZlUfdB3M9yRCniKBSLc/dHHEgSqIAdK4OUQRyn9io61gQw=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1639.namprd12.prod.outlook.com (10.172.71.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 11:19:37 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Thu, 24 Oct
 2019 11:19:37 +0000
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Subject: Re: [RFC PATCH 1/5] crypto: ccp - rename psp-dev files to sev-dev
Thread-Topic: [RFC PATCH 1/5] crypto: ccp - rename psp-dev files to sev-dev
Thread-Index: AQHViZTaeW4oDnl060iTQZKgrU1yk6doHFkAgAGKMoA=
Date:   Thu, 24 Oct 2019 11:19:37 +0000
Message-ID: <e474bce6-8189-2c47-f61c-3c57532a43fd@amd.com>
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
 <119557a5db5cc55c0e88f1543c0fabf0c820cb92.1571817675.git.Rijo-john.Thomas@amd.com>
 <CAKv+Gu8Dtqr-=71e_P-h=+yBLxzyTcnp4EKsh8q_nGsXYvLL4A@mail.gmail.com>
In-Reply-To: <CAKv+Gu8Dtqr-=71e_P-h=+yBLxzyTcnp4EKsh8q_nGsXYvLL4A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0117.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::35) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.156.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 577dd268-1ae8-4be8-b135-08d758740de4
x-ms-traffictypediagnostic: CY4PR12MB1639:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB163903EE8BCE97B0D5392E03CF6A0@CY4PR12MB1639.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(199004)(189003)(6246003)(31696002)(8936002)(4326008)(316002)(71200400001)(71190400001)(25786009)(7736002)(31686004)(5660300002)(305945005)(81166006)(81156014)(478600001)(8676002)(476003)(66066001)(6506007)(386003)(53546011)(26005)(102836004)(76176011)(186003)(256004)(14444005)(11346002)(446003)(486006)(2616005)(2906002)(52116002)(99286004)(14454004)(86362001)(6116002)(3846002)(66946007)(6486002)(66556008)(64756008)(66446008)(66476007)(6436002)(229853002)(6916009)(6512007)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1639;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3f8wtAt+ypPp6chhrwUUyzX8nMDoyLH8p+eWwWq4ZFNRAn3v6QqgbU1wmgugVNCsW5AMKlK0546A18VNORimzx/JHGck+JngwwkxrPKQOCn6JVOomufbpK9aITdegsIxMsq08NP44saM50gtrXkOaEanLEOLoI/O854jbHTR0uVfvcxy8jkU84kJYafBBDqE766ed23xQ0W2ZDUetb8GqWKsiLQFG4w6A0DNI+Y1Og2hqzNSlPG7Zmys/R2XZF8tFY/ZFMznTVPGh6RbZdR6yZef4GG2orDuNEL87VVi/BcFaIobHnPkIAjx8w8iNxhX2GhQDtj3nZ8ujzQhoDFhndr5xqXrreznCvjTEIrkZxs+fvCYk6l2gkHX9ZwNxPxfo5JFPBZXZ2fhJiQHNn1DsNHeUBVPix8De2MP9bL2KGOK8XwUWvJITZ3IX+IFCo5z
Content-Type: text/plain; charset="utf-8"
Content-ID: <7030D916E563CE419AEF7C6B72EC967B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577dd268-1ae8-4be8-b135-08d758740de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 11:19:37.0765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDprhJPxtSMIK/NbbRLU8ntE59U/ZZC1IWO3eqvvP7CziGSc5l6vIG+GWy+b1SpbMhVcrVgh8DlRJIF0uavmnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1639
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8gQXJkLA0KDQpPbiAyMy8xMC8xOSA1OjE4IFBNLCBBcmQgQmllc2hldXZlbCB3cm90ZToN
Cj4gSGVsbG8gVGhvbWFzLA0KPiANCj4gT24gV2VkLCAyMyBPY3QgMjAxOSBhdCAxMzoyNywgVGhv
bWFzLCBSaWpvLWpvaG4NCj4gPFJpam8tam9obi5UaG9tYXNAYW1kLmNvbT4gd3JvdGU6DQo+Pg0K
Pj4gVGhpcyBpcyBhIHByZWxpbWluYXJ5IHBhdGNoIGZvciBjcmVhdGluZyBhIGdlbmVyaWMgUFNQ
IGRldmljZSBkcml2ZXINCj4+IGZpbGUsIHdoaWNoIHdpbGwgaGF2ZSBzdXBwb3J0IGZvciBib3Ro
IFNFViBhbmQgVEVFIChUcnVzdGVkIEV4ZWN1dGlvbg0KPj4gRW52aXJvbm1lbnQpIGludGVyZmFj
ZS4NCj4+DQo+PiBUaGlzIHBhdGNoIGRvZXMgbm90IGludHJvZHVjZSBhbnkgbmV3IGZ1bmN0aW9u
YWxpdHksIGJ1dCBzaW1wbHkgcmVuYW1lcw0KPj4gcHNwLWRldi5jIGFuZCBwc3AtZGV2LmggZmls
ZXMgdG8gc2V2LWRldi5jIGFuZCBzZXYtZGV2LmggZmlsZXMNCj4+IHJlc3BlY3RpdmVseS4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBSaWpvIFRob21hcyA8Umlqby1qb2huLlRob21hc0BhbWQuY29t
Pg0KPj4gU2lnbmVkLW9mZi1ieTogRGV2YXJhaiBSYW5nYXNhbXkgPERldmFyYWouUmFuZ2FzYW15
QGFtZC5jb20+DQo+IA0KPiBUaGlzIGlzIG5vdCB0aGUgY29ycmVjdCB3YXkgdG8gY3JlZGl0IGEg
Y28tYXV0aG9yLg0KPiANCj4gWW91IGFyZSBzZW5kaW5nIHRoZSBwYXRjaCwgc28geW91ciBzaWdu
b2ZmIHNob3VsZCBjb21lIGxhc3QuDQo+IA0KPiBJZiBEZXZhcmFqIGlzIGEgY28tYXV0aG9yIG9m
IHRoaXMgd29yaywgeW91IHNob3VsZCBhZGQgdGhlIGZvbGxvd2luZw0KPiBsaW5lcyAqYmVmb3Jl
KiB5b3VyIHNpZ25vZmYNCj4gDQo+IENvLWF1dGhvcmVkLWJ5OiBEZXZhcmFqIFJhbmdhc2FteSA8
RGV2YXJhai5SYW5nYXNhbXlAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGV2YXJhaiBSYW5n
YXNhbXkgPERldmFyYWouUmFuZ2FzYW15QGFtZC5jb20+DQo+IA0KPiBJZiBEZXZhcmFqIGlzIHRo
ZSBzb2xlIGF1dGhvciBvZiB0aGlzIHdvcmssIGFuZCB5b3UgYXJlIGp1c3Qgc2VuZGluZw0KPiBp
dCBvdXQsIHlvdSBzaG91bGQgc2V0IHRoZSBhdXRob3JzaGlwIG9uIHRoZSBwYXRjaCB0byBEZXZh
cmFqIChzbyBpdA0KPiB3aWxsIGJlIEZyb206IERldmFyYWogUmFuZ2FzYW15IDxEZXZhcmFqLlJh
bmdhc2FteUBhbWQuY29tPikNCj4gDQoNCk9rYXksIGluIG15IG5leHQgcGF0Y2ggcmV2aXNpb24g
SSBzaGFsbCBjb3JyZWN0IHRoaXMuDQpEZXZhcmFqIGlzIHRoZSBjby1hdXRob3IuDQoNClNvLCB0
aGUgbGluZXMgd291bGQgbGlrZSBsaWtlOg0KDQpDby1hdXRob3JlZC1ieTogRGV2YXJhaiBSYW5n
YXNhbXkgPERldmFyYWouUmFuZ2FzYW15QGFtZC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBEZXZhcmFq
IFJhbmdhc2FteSA8RGV2YXJhai5SYW5nYXNhbXlAYW1kLmNvbT4NClNpZ25lZC1vZmYtYnk6IFJp
am8gVGhvbWFzIDxSaWpvLWpvaG4uVGhvbWFzQGFtZC5jb20+DQoNCj4+IC0tLQ0KPj4gIGRyaXZl
cnMvY3J5cHRvL2NjcC9NYWtlZmlsZSAgfCAgICAyICstDQo+PiAgZHJpdmVycy9jcnlwdG8vY2Nw
L3BzcC1kZXYuYyB8IDEwODcgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo+PiAgZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuaCB8ICAgNjYgLS0tDQo+PiAgZHJp
dmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuYyB8IDEwODcgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrDQo+PiAgZHJpdmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuaCB8ICAg
NjYgKysrDQo+PiAgZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jICB8ICAgIDIgKy0NCj4+ICA2
IGZpbGVzIGNoYW5nZWQsIDExNTUgaW5zZXJ0aW9ucygrKSwgMTE1NSBkZWxldGlvbnMoLSkNCj4+
ICBkZWxldGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KPj4gIGRl
bGV0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5oDQo+PiAgY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvY3J5cHRvL2NjcC9zZXYtZGV2LmMNCj4+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuaA0KPj4NCj4gDQo+IFBsZWFzZSBy
ZWdlbmVyYXRlIHRoZSBwYXRjaCBzbyB0aGF0IHRoZSByZW5hbWUgaXMgcmVmbGVjdGVkIGluIHRo
ZSBkaWZmc3RhdC4NCj4gDQoNCk9rYXksIEkgd2lsbCByZWdlbmVyYXRlIHRoZSBwYXRjaCB3aXRo
IHByb3BlciBkaWZmc3RhdC4NCg0KVGhhbmtzLA0KUmlqbw0K
