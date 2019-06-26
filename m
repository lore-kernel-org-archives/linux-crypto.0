Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6BC48BD6
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 16:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B12F52080C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 16:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="BRIvy8My"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfFZQuD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 12:50:03 -0400
Received: from mail-eopbgr690074.outbound.protection.outlook.com ([40.107.69.74]:23673
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726042AbfFZQuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 12:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tCXA+jEMR2H9VHzddf9QfcTObsTuzcW8MXsgApyN6g=;
 b=BRIvy8MyHeVjJpLvUvxyOJwkGJMEUBZcfOTo5MKfcdS2j5ESiBqdpKCAYPXvI84GXoPdqVATyOl5hM4/DEV6CCURgxT8EZ1S2BfOOr+/eryaSWmA97iPlOL4jlR8kqsFEJ+xsEmWCmSs/e/KrtTtAF6z7u2GlkNeO8D2afN2ef8=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1404.namprd12.prod.outlook.com (10.168.238.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 16:50:00 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.018; Wed, 26 Jun
 2019 16:50:00 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Joe Perches <joe@perches.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 2/2] crypto: doc - Fix formatting of new crypto engine
 content
Thread-Topic: [PATCH v2 2/2] crypto: doc - Fix formatting of new crypto engine
 content
Thread-Index: AQHVK6/XqR/ma8kUnUmph7llIf8q06atEJGAgAEWbIA=
Date:   Wed, 26 Jun 2019 16:50:00 +0000
Message-ID: <7dfb91b0-c8fa-ccac-0e5f-93dd96393981@amd.com>
References: <156150616764.22527.16524544899486041609.stgit@taos>
 <156150622886.22527.934327975584441429.stgit@taos>
 <983486e9b2daaa34f84f99a890fcedfeae22b24f.camel@perches.com>
In-Reply-To: <983486e9b2daaa34f84f99a890fcedfeae22b24f.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0056.prod.exchangelabs.com (2603:10b6:a03:94::33)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [47.220.187.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ceab9c0d-7035-4898-6994-08d6fa5653e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1404;
x-ms-traffictypediagnostic: DM5PR12MB1404:
x-microsoft-antispam-prvs: <DM5PR12MB1404D3238ED2686698D5F9D9FDE20@DM5PR12MB1404.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(2616005)(7736002)(31696002)(305945005)(6512007)(2501003)(14454004)(26005)(2906002)(8936002)(2201001)(68736007)(6436002)(486006)(446003)(66066001)(316002)(229853002)(6486002)(478600001)(186003)(476003)(11346002)(110136005)(5660300002)(72206003)(73956011)(66946007)(36756003)(102836004)(8676002)(64756008)(66446008)(14444005)(66476007)(386003)(81156014)(6246003)(81166006)(6116002)(6506007)(66556008)(3846002)(71190400001)(71200400001)(256004)(53546011)(25786009)(99286004)(76176011)(53936002)(31686004)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1404;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LCPVQXLHxdpA06AwnflvrPXgecSLtUJGy3exiqXHelw/5awxlpA2HhabC+/yCcYPU6X8FRp7j01Op4bPvoVBHaAvmIRHPPazB9UdSbFm2vH1NDXjMQ6UbHrUo3YaeOv6TwMvn0PWY0VgiRC5lpLVj0ZqQ9zfbJGgBmGlFwpQ1AXZMWrVkO8/UroR2pup1abKqHyAXdqLf1fclMzpN/oNS484I1mlhWLN/9W+KndLOmIQhjeJd16SEKDAAB+sYey+b4dNuO7Rs2BNJisO/BEL9ppzUhyjGPXUQFqWr3FhpKAD9lKZzo1Ptwfkw2vjk7pX+uCMzdWsISN9a788UdMCwmGb9XkeYlz6iqE3Imeu3GyXrFzdLbznOVkYso49Hl6THLi4p7WGGMb6ZtlcyXBXpmr66oh2m7cMnyCo1OJ9A9c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8FA00A1BD7CA44CAD5E832D494ACF67@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceab9c0d-7035-4898-6994-08d6fa5653e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 16:50:00.4143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1404
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNS8xOSA3OjEzIFBNLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4gT24gVHVlLCAyMDE5LTA2
LTI1IGF0IDIzOjQzICswMDAwLCBIb29rLCBHYXJ5IHdyb3RlOg0KPj4gVGlkeSB1cCB0aGUgZm9y
bWF0dGluZy9ncmFtbWFyIGluIGNyeXB0b19lbmdpbmUucnN0LiBVc2UgYnVsbGV0ZWQgbGlzdHMN
Cj4+IHdoZXJlIGFwcHJvcHJpYXRlLg0KPiANCj4gSGkgYWdhaW4gR2FyeS4NCg0KSG93ZHkhDQoN
Cj4gDQo+PiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9jcnlwdG8vY3J5cHRvX2VuZ2luZS5y
c3QgYi9Eb2N1bWVudGF0aW9uL2NyeXB0by9jcnlwdG9fZW5naW5lLnJzdA0KPiBbXQ0KPj4gK0Jl
Zm9yZSB0cmFuc2ZlcnJpbmcgYW55IHJlcXVlc3QsIHlvdSBoYXZlIHRvIGZpbGwgdGhlIGNvbnRl
eHQgZW5naW5lY3R4IGJ5DQo+PiArcHJvdmlkaW5nIGZ1bmN0aW9ucyBmb3IgdGhlIGZvbGxvd2lu
ZzoNCj4+ICsNCj4+ICsqIGBgcHJlcGFyZV9jcnlwdF9oYXJkd2FyZWBgOiBDYWxsZWQgb25jZSBi
ZWZvcmUgYW55IHByZXBhcmUgZnVuY3Rpb25zIGFyZQ0KPj4gKyAgY2FsbGVkLg0KPj4gKw0KPj4g
KyogYGB1bnByZXBhcmVfY3J5cHRfaGFyZHdhcmVgYDogQ2FsbGVkIG9uY2UgYWZ0ZXIgYWxsIHVu
cHJlcGFyZSBmdW5jdGlvbnMgaGF2ZQ0KPj4gKyAgYmVlbiBjYWxsZWQuDQo+PiArDQo+PiArKiBg
YHByZXBhcmVfY2lwaGVyX3JlcXVlc3RgYC9gYHByZXBhcmVfaGFzaF9yZXF1ZXN0YGA6IENhbGxl
ZCBiZWZvcmUgZWFjaA0KPj4gKyAgY29ycmVzcG9uZGluZyByZXF1ZXN0IGlzIHBlcmZvcm1lZC4g
SWYgc29tZSBwcm9jZXNzaW5nIG9yIG90aGVyIHByZXBhcmF0b3J5DQo+PiArICB3b3JrIGlzIHJl
cXVpcmVkLCBkbyBpdCBoZXJlLg0KPj4gKw0KPj4gKyogYGB1bnByZXBhcmVfY2lwaGVyX3JlcXVl
c3RgYC9gYHVucHJlcGFyZV9oYXNoX3JlcXVlc3RgYDogQ2FsbGVkIGFmdGVyIGVhY2gNCj4+ICsg
IHJlcXVlc3QgaXMgaGFuZGxlZC4gQ2xlYW4gdXAgLyB1bmRvIHdoYXQgd2FzIGRvbmUgaW4gdGhl
IHByZXBhcmUgZnVuY3Rpb24uDQo+PiArDQo+PiArKiBgYGNpcGhlcl9vbmVfcmVxdWVzdGBgL2Bg
aGFzaF9vbmVfcmVxdWVzdGBgOiBIYW5kbGUgdGhlIGN1cnJlbnQgcmVxdWVzdCBieQ0KPj4gKyAg
cGVyZm9ybWluZyB0aGUgb3BlcmF0aW9uLg0KPiANCj4gSSBhZ2FpbiBzdWdnZXN0IG5vdCB1c2lu
ZyBgYDxmdW5jPmBgIGJ1dCBpbnN0ZWFkIHVzZSA8ZnVuYz4oKQ0KPiBhbmQgcmVtb3ZlIHVubmVj
ZXNzYXJ5IGJsYW5rIGxpbmVzLg0KDQp3aXRoIGFsbCBkdWUgcmVzcGVjdCwgdGhvc2UgYXJlbid0
IGZ1bmN0aW9ucywgdGhleSdyZSBmdW5jdGlvbiBwb2ludGVycyANCihhcyBzdHJ1Y3R1cmUgbWVt
YmVycykuIFRoZXJlZm9yZSwgaWYgYW55dGhpbmcsIHRoZXkgc2hvdWxkIGJlIG5vdGF0ZWQgDQph
cyAoKmZ1bmMpKCkuIEJ1dCBJIHRyaWVkIHRoYXQgKHdpdGggdGhlIG5ldyBwYXRjaGVzKSwgYW5k
IHRoZXkgd2VyZW4ndCANCmRldGVjdGVkIGFuZCBlbWJvbGRlbmVkICh0aGF0J3Mgbm90IGEgd29y
ZCwgSSBrbm93KSBpbiB0aGUgaHRtbC4NCg0KU28gSSBsZWZ0IHRoZW0gYXMtaXMuDQoNCkkgZG9u
J3QgcHJldGVuZCB0byBiZSBhIGd1cnUgb24gdGhpcyBtYXJrdXAsIGJ1dCBpZiB0aGVyZSdzIGEg
d2F5IHRvIA0KbWFrZSBzeW1ib2wgbmFtZXMgZml4ZWQtd2lkdGggYW5kIGJvbGQsIEknbGwgZ2xh
ZGx5IGRvIGl0LiBCdXQgSSANCmRpc2FncmVlIG9uIHR1cm5pbmcgdGhlc2UgaW50byBmdW5jdGlv
bnMsIGJlY2F1c2UgdGhhdCdzIG5vdCB3aGF0IHRoZXkgYXJlLg0KDQoNCj4gaS5lLjoNCj4gDQo+
ICogcHJlcGFyZV9jcnlwdF9oYXJkd2FyZSgpOiBDYWxsZWQgb25jZSBiZWZvcmUgYW55IHByZXBh
cmUgZnVuY3Rpb25zIGFyZQ0KPiAgICBjYWxsZWQuDQo+ICogdW5wcmVwYXJlX2NyeXB0X2hhcmR3
YXJlKCk6ICBDYWxsZWQgb25jZSBhZnRlciBhbGwgdW5wcmVwYXJlIGZ1bmN0aW9ucw0KPiAgICBo
YXZlIGJlZW4gY2FsbGVkLg0KPiAqIHByZXBhcmVfY2lwaGVyX3JlcXVlc3QoKS9wcmVwYXJlX2hh
c2hfcmVxdWVzdCgpOiBDYWxsZWQgYmVmb3JlIGVhY2gNCj4gICAgY29ycmVzcG9uZGluZyByZXF1
ZXN0IGlzIHBlcmZvcm1lZC4gSWYgc29tZSBwcm9jZXNzaW5nIG9yIG90aGVyIHByZXBhcmF0b3J5
DQo+ICAgIHdvcmsgaXMgcmVxdWlyZWQsIGRvIGl0IGhlcmUuDQo+ICogdW5wcmVwYXJlX2NpcGhl
cl9yZXF1ZXN0KCkvdW5wcmVwYXJlX2hhc2hfcmVxdWVzdCgpOiBDYWxsZWQgYWZ0ZXIgZWFjaA0K
PiAgICByZXF1ZXN0IGlzIGhhbmRsZWQuIENsZWFuIHVwIC8gdW5kbyB3aGF0IHdhcyBkb25lIGlu
IHRoZSBwcmVwYXJlIGZ1bmN0aW9uLg0KPiAqIGNpcGhlcl9vbmVfcmVxdWVzdCgpL2hhc2hfb25l
X3JlcXVlc3QoKTogSGFuZGxlIHRoZSBjdXJyZW50IHJlcXVlc3QgYnkNCj4gICAgcGVyZm9ybWlu
ZyB0aGUgb3BlcmF0aW9uLg0KPiANCj4gW10NCj4+ICtXaGVuIHlvdXIgZHJpdmVyIHJlY2VpdmVz
IGEgY3J5cHRvX3JlcXVlc3QsIHlvdSBtdXN0IHRvIHRyYW5zZmVyIGl0IHRvDQo+PiArdGhlIGNy
eXB0byBlbmdpbmUgdmlhIG9uZSBvZjoNCj4+ICsNCj4+ICsqIGNyeXB0b190cmFuc2Zlcl9hYmxr
Y2lwaGVyX3JlcXVlc3RfdG9fZW5naW5lKCkNCj4gDQo+IEFuZCByZW1vdmluZyB0aGUgdW5uZWNl
c3NhcnkgYmxhbmsgbGluZXMgYmVsb3cNCj4gDQo+PiArDQo+PiArKiBjcnlwdG9fdHJhbnNmZXJf
YWVhZF9yZXF1ZXN0X3RvX2VuZ2luZSgpDQo+PiArDQo+PiArKiBjcnlwdG9fdHJhbnNmZXJfYWtj
aXBoZXJfcmVxdWVzdF90b19lbmdpbmUoKQ0KPj4gKw0KPj4gKyogY3J5cHRvX3RyYW5zZmVyX2hh
c2hfcmVxdWVzdF90b19lbmdpbmUoKQ0KPj4gKw0KPj4gKyogY3J5cHRvX3RyYW5zZmVyX3NrY2lw
aGVyX3JlcXVlc3RfdG9fZW5naW5lKCkNCj4+ICsNCj4+ICtBdCB0aGUgZW5kIG9mIHRoZSByZXF1
ZXN0IHByb2Nlc3MsIGEgY2FsbCB0byBvbmUgb2YgdGhlIGZvbGxvd2luZyBmdW5jdGlvbnMgaXMg
bmVlZGVkOg0KPj4gKw0KPj4gKyogY3J5cHRvX2ZpbmFsaXplX2FibGtjaXBoZXJfcmVxdWVzdCgp
DQo+PiArDQo+PiArKiBjcnlwdG9fZmluYWxpemVfYWVhZF9yZXF1ZXN0KCkNCj4+ICsNCj4+ICsq
IGNyeXB0b19maW5hbGl6ZV9ha2NpcGhlcl9yZXF1ZXN0KCkNCj4+ICsNCj4+ICsqIGNyeXB0b19m
aW5hbGl6ZV9oYXNoX3JlcXVlc3QoKQ0KPj4gKw0KPj4gKyogY3J5cHRvX2ZpbmFsaXplX3NrY2lw
aGVyX3JlcXVlc3QoKQ0KPiANCj4gDQoNClRoZSBsaW5lcyBiZXR3ZWVuIHRoZSBidWxsZXRlZCBp
dGVtcyB3aWxsIGdvLCB5ZXMuIE5vdCB0aGUgb25lcyBhcm91bmQgDQp0aGUgbGVhZGluZyB0ZXh0
IG9mIGVhY2ggbGlzdCAod2hpY2ggYXJlIG5lY2Vzc2FyeSB0byBkZWxpbmVhdGUgdGhlIGxpc3Rz
KS4NCg==
