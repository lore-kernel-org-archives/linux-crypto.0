Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77848CA9EB7
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 16:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451172084B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 16:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="vD0XHyxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbfJVQTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:19:40 -0400
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:4994
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727152AbfJVQTk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 12:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCyQszJIEbecDB/QNC9r/2Q97wMCBDBPpPURWq89JTJU7T6hHBakenpQMRbwfK5c6EodAYaNB0NLB5p3kZJCaa/u4GeYCMWcb+9/Ea2SMmuUSyQH2RT5g/yriFIjgvb4PIReg3SuWBoodYKRxYilUDNYeaY8CdNKXhlP47rrQiBaoxw/8HOZ53Ac5EpMlULCZG5QLEStGzxKtpUEF99EEczIVDtehCTdxNA2cYFeYmdp/LQxpO/gzSZgxCBHrkKhpoWa1VdS1E6OScW+PYxbrgwI/3b6XeTMnq9IYKqjQzf2tYtYWQjIQKm54OUazJ2HdzIgWJVBOZqmBzxWVPnBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wucYuIkX8G13NDEIUS0gWHtSY0zU4hbHfZRwS4brs44=;
 b=MDnnT35xg14FsdacnSXVAtzGUx6SrWuLBi5fcG2tkytmuijshFysrb4QfSY727cNFAr9ZSHEM1zFQPgysC11oMn7SXhNTKG7mlF5zY0toATP2AmCtSA7NQ2OGFHMh692uQLtHJjd7YekODgdZND1aU5LlPu0Yz6gLFre5bccIky3pW99Mcr0bIo09y2nBQ74Dh8PGGO1UDPtEr22voPHG6fcpXVhdMWSgC77qUDal92IphGY1rGKfrAjw6WGiHk0IVy2I+KTauCIPJuj3beDchaBHKwi2wIF/HcPmq+xroCcHglWDc9TRwCDZEBz9H5JgwhhWihE8J59f+MqM1Jw+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wucYuIkX8G13NDEIUS0gWHtSY0zU4hbHfZRwS4brs44=;
 b=vD0XHyxwiQgiqE48wszh0WZw/El52J7v/lBbjc1m6gaADUi/sWWa0lTnQMk5g4f0x2AoswjQLErpp4qyPwbmjSnLVtBlSmxJJ59QkanxasmQlW4oSqkcHZhFw4449UUU0ALGiS9QMTJGLRxfV71LEBWBks+1PLxzXXXg681z/hY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2318.namprd20.prod.outlook.com (20.179.145.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 22 Oct 2019 16:18:55 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 16:18:55 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
Thread-Topic: [PATCH] crypto: inside-secure - select CONFIG_CRYPTO_SM3
Thread-Index: AQHViOUe+e/Hs63J30KPA9kL8v+yAadmy4dQgAALBQCAAABQsA==
Date:   Tue, 22 Oct 2019 16:18:55 +0000
Message-ID: <MN2PR20MB297312A9D6001B8481F4C0BECA680@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20191022142914.1803322-1-arnd@arndb.de>
 <MN2PR20MB29732A5C1B14AE24DD7531A3CA680@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAK8P3a1-d7PmYB6v9y2DFD+kOB9ebDsixhFNcuxVJ2+rrBwjqA@mail.gmail.com>
In-Reply-To: <CAK8P3a1-d7PmYB6v9y2DFD+kOB9ebDsixhFNcuxVJ2+rrBwjqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f82fc4c-e386-40e6-9c56-08d7570b8942
x-ms-traffictypediagnostic: MN2PR20MB2318:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23187BBB214941762C0B539DCA680@MN2PR20MB2318.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(396003)(366004)(376002)(346002)(189003)(199004)(13464003)(66946007)(86362001)(81166006)(8936002)(81156014)(7736002)(8676002)(74316002)(305945005)(3846002)(316002)(256004)(66476007)(66556008)(64756008)(66446008)(71200400001)(7696005)(76176011)(54906003)(99286004)(71190400001)(6116002)(14454004)(6506007)(33656002)(478600001)(53546011)(76116006)(26005)(486006)(66066001)(102836004)(4326008)(476003)(9686003)(446003)(52536014)(5660300002)(6436002)(229853002)(25786009)(2906002)(15974865002)(11346002)(55016002)(6246003)(186003)(6916009)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2318;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OuTvVguWsKE9QUXK5JPY6cMuSAHwbF+8lbfZKUjPBwe8lSHrfEF0Aa0lOUjzT30y4S77l4bpibXw7dkVeOaGxGbt57Eyv9gJDzOkW7KojonKdVT2HMV+y3r9Ncqb8GcGLx5WYtpwfKBLcEPgqDcxjMzF5SuS+ADCiQaxMAGLVVXaNhg9vtK2oPdVi6j9eYPX84J1rRPuW0X/SAeyxXKU4mmptSt9Hv6uPGICYhHRSF92m1FBxsTOj6cyBVVcuaFuGO7VxsviatM3SJ95B/ghz3jBrNyDGaPq9Is+l3GygmTxnGIKSJHcdMC0XmlxB/zcpQtbUpb8L3Bh1pItqjedf/LUQVAt+rv2rqDXgAvvsvlsIx+0oWkEhgZQ5tXWvi0SM6kw6KzbjagritZ5fnNluiU60bhN6HFtVhllizJwhEMes+OU72Mk7L6h3aehB1ij
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f82fc4c-e386-40e6-9c56-08d7570b8942
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 16:18:55.2896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIRMQ4V05g2m7uCVUe6jp6F6rRXP9GzhmCQWmFmA6E/1+NmlfhWaqs7eHU+RJMg5kD4mLqN6U9/GZBnxQJ/5UMIIFB739x5voWSn0XB9vUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2318
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPg0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDIyLCAyMDE5IDY6MTcgUE0NCj4g
VG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+DQo+IENj
OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZpZCBTLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBBbnRvaW5lDQo+IFRlbmFydCA8YW50b2luZS50ZW5h
cnRAYm9vdGxpbi5jb20+OyBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9y
Zz47IFBhc2NhbCB2YW4NCj4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+OyBsaW51eC1j
cnlwdG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0hdIGNyeXB0bzogaW5zaWRlLXNlY3VyZSAtIHNlbGVjdCBDT05GSUdf
Q1JZUFRPX1NNMw0KPiANCj4gT24gVHVlLCBPY3QgMjIsIDIwMTkgYXQgNTo0MiBQTSBQYXNjYWwg
VmFuIExlZXV3ZW4NCj4gPHB2YW5sZWV1d2VuQHZlcmltYXRyaXguY29tPiB3cm90ZToNCj4gDQo+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vS2NvbmZpZyBiL2RyaXZlcnMvY3J5cHRv
L0tjb25maWcNCj4gPiA+IGluZGV4IDM1N2UyMzA3NjljOC4uMWNhOGQ5YTE1ZjJhIDEwMDY0NA0K
PiA+ID4gLS0tIGEvZHJpdmVycy9jcnlwdG8vS2NvbmZpZw0KPiA+ID4gKysrIGIvZHJpdmVycy9j
cnlwdG8vS2NvbmZpZw0KPiA+ID4gQEAgLTc1Myw2ICs3NTMsNyBAQCBjb25maWcgQ1JZUFRPX0RF
Vl9TQUZFWENFTA0KPiA+ID4gICAgICAgc2VsZWN0IENSWVBUT19TSEE1MTINCj4gPiA+ICAgICAg
IHNlbGVjdCBDUllQVE9fQ0hBQ0hBMjBQT0xZMTMwNQ0KPiA+ID4gICAgICAgc2VsZWN0IENSWVBU
T19TSEEzDQo+ID4gPiArICAgICBzZWxlY3QgQ1JZUFRPX1NNMw0KPiA+ID4NCj4gPiBXYXMgdGhp
cyBwcm9ibGVtIG9ic2VydmVkIHdpdGggdGhlIGxhdGVzdCBzdGF0ZSBvZiB0aGUgQ3J5cHRvZGV2
IEdJVD8NCj4gPiBCZWNhdXNlIEkgYWxyZWFkeSBhdHRlbXB0ZWQgdG8gZml4IHRoaXMgaXNzdWUg
d2l0aCBjb21taXQgOTlhNTlkYTM3MjNiOTcyNQ0KPiA+IENhbiB5b3UgcGxlYXNlIGRvdWJsZSBj
aGVjayBpZiB5b3Ugc3RpbGwgZ2V0IHRoZSBjb21waWxlIGVycm9yIHdpdGggdGhhdA0KPiA+IGNv
bW1pdCBpbmNsdWRlZD8NCj4gPiAoSSBjYW4ndCB0ZWxsIGZyb20gdGhpcyBtYWlsIHdoaWNoIHZl
cnNpb24gb2YgdGhlIHNvdXJjZXMgeW91IGFyZSB1c2luZykNCj4gDQo+IEkgd2FzIHRlc3Rpbmcg
b24gbGludXgtNS40LXJjMyBwbHVzIHNvbWUgb2YgbXkgb3duIHBhdGNoZXMsIHNvIHlvdXIgZml4
DQo+IHdhcyBub3QgaW5jbHVkZWQuDQo+IA0KPiBXaXRoIHlvdXIgcGF0Y2ggYXBwbGllZCwgbWlu
ZSBpcyBubyBsb25nZXIgbmVlZGVkLg0KPiANCj4gICAgICAgICBBcm5kDQoNClRoYW5rcyBmb3Ig
Y29uZmlybWluZyB0aGF0IDotKQ0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxp
Y29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3
dy5pbnNpZGVzZWN1cmUuY29tDQo=
