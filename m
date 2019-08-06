Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88717C433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 19:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D9A20717
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 19:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="gpt6IFmR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfHFThE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 15:37:04 -0400
Received: from mail-eopbgr690069.outbound.protection.outlook.com ([40.107.69.69]:51619
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHFThD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 15:37:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi1bHzLY6JvlRPf3J7SpRcG252SvTun4wd1ZjF2m+pWSFmvFWgGNvkDaE8NcZUqmQ2+jYQzkQq+1DpxmyEMmiIdkmmkmfJVztzLi76oQXK1O/5zUi0QRSWx/DGSgrC5scUI0EgFf9rVQaare5elDm2lgq29TAGW5SURAevnLCnOgU94Q8gA9MPn+bBDJIH9CAmh04ssei8Ogtua92C6fL+d+JHjon98un5YmpEb7ig5tRrmArUjByg6D5byCHHE5XfgsTZunFWTswL+ZZjyhAFFpn0DxjcXUQqRtBbjnuqN2pBGv+l+ZFm7s5+saRQvBgH25zNURHu12HD86oWBVqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ti7CpLaRr8xcAGAMWH5nP1u4PuwUbaWGIbpbD3e3nr0=;
 b=PsGBUcJCj5iV+4ZhRQbgQbq3ruhIzZiAhaH9PZ7La3uitSMpBBpIbWsjQD9YlfSXfhsde/zg4P+bjrQop6yEo12L2Uu/UYHvdBVjnQBhiFff5ue931FLZpgfmprseYdRpFAYQoz0Td65Cmpk6GUeBwe4FzIXEi/RI3U+JMTBs7gfdUXruXSYe7gJEeV3OKOuPNr+coLt4UBVorw1h67fj3EgSvirDDDLYzSQBGvQ9atHWf+TEbgSpRGf9pmbfqCUjZtGaFI1DdMQnDT9FAGhu9yZUTMiPcvdYQqEf1QtPEercOvWNsJaVpDbVLeebW8cvP+1OqJUmaWN9yXOxIyAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ti7CpLaRr8xcAGAMWH5nP1u4PuwUbaWGIbpbD3e3nr0=;
 b=gpt6IFmRHa5f6pHwbDtUdZKQf4ufbVo7lh5M8QbI+wT5W/2lw5xDmw5aT+KQa2McMr3KNFcwiIae0WPH/fADbCnXv4bxraEWO8RrkzJwrSqNoS+kWyXKzLqvtjYGZ6qSD9JikP+MVpPRjxZa73z04z+gVWFJnEkmyqlC25Ypqvw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2623.namprd20.prod.outlook.com (20.178.251.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 19:37:00 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 19:36:59 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Topic: [PATCH] crypto: xts - Add support for Cipher Text Stealing
Thread-Index: AQHVTCyrZ3LTVlRuCkCwUQoLONEbf6bucuQAgAAMd6A=
Date:   Tue, 6 Aug 2019 19:36:59 +0000
Message-ID: <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
In-Reply-To: <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fde6d34b-d409-4b68-6821-08d71aa5732b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2623;
x-ms-traffictypediagnostic: MN2PR20MB2623:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB26234D3BB1D88D601B6B2DE2CAD50@MN2PR20MB2623.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39840400004)(136003)(396003)(376002)(189003)(199004)(13464003)(52536014)(6506007)(6306002)(66556008)(66476007)(76116006)(86362001)(110136005)(64756008)(66946007)(54906003)(76176011)(53546011)(71200400001)(99286004)(102836004)(71190400001)(66446008)(15974865002)(5660300002)(316002)(7696005)(256004)(14454004)(486006)(2501003)(8936002)(3846002)(6116002)(4326008)(2906002)(476003)(305945005)(966005)(229853002)(74316002)(11346002)(25786009)(7736002)(33656002)(55016002)(478600001)(446003)(68736007)(45080400002)(6246003)(81166006)(8676002)(9686003)(66066001)(53936002)(81156014)(6436002)(26005)(186003)(473944003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2623;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9SRcGrFN6czuvaJ/V62Qir1r4oo6OEvESN5QP/TczUkTIaLf6+x4DwREQe3rIYOtuezK242iqlXcisSFjL3YaewK1ivg8NGiXXIevqDrvHemFTfbN50nOgBkD5+IqraBDvVKs3q/76k55sm+9FoCEh73BMzfmUNxar/3VDXTlw2IdYwbrNKwdGyZtMpB8IY4i7N8yTVZIFx+VNpkSEfKL+FNdY/ZFj6AF/wBK8Ht4KE5bTpAGrANzlqASiLPhXaK0PGXr1FgmYfpUqZCGZud77VOn0KEXjvGMrCkhlPe2auTPZI1QrEYqfcCND3wcsPHCP8Cu68C4jOM1cqVV6sCqb+fgQ9vYNlBUI8qPPpnoRp2rsGxeXl9SQGjIldasU+ZO0cECTXEG92iL7jCCWIoCvx5G15fnNqpQ+7EhyUocAk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde6d34b-d409-4b68-6821-08d71aa5732b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 19:36:59.7966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2623
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TWlsYW4sDQoNClRoYW5rcyBmb3IgdHJ5aW5nIDotKQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+IEZyb206IE1pbGFuIEJyb3ogPGdtYXp5bGFuZEBnbWFpbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEF1Z3VzdCA2LCAyMDE5IDg6MzUgUE0NCj4gVG86IFBhc2NhbCB2YW4gTGVldXdl
biA8cGFzY2FsdmFubEBnbWFpbC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnDQo+
IENjOiByc25lbEBjdWJlLmR5bmRucy5vcmc7IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgUGFzY2FsIFZhbg0KPiBMZWV1d2VuIDxwdmFubGVldXdlbkB2
ZXJpbWF0cml4LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY3J5cHRvOiB4dHMgLSBBZGQg
c3VwcG9ydCBmb3IgQ2lwaGVyIFRleHQgU3RlYWxpbmcNCj4gDQo+IE9uIDA2LzA4LzIwMTkgMDg6
NTUsIFBhc2NhbCB2YW4gTGVldXdlbiB3cm90ZToNCj4gPiBUaGlzIGFkZHMgc3VwcG9ydCBmb3Ig
Q2lwaGVyIFRleHQgU3RlYWxpbmcgZm9yIGRhdGEgYmxvY2tzIHRoYXQgYXJlIG5vdCBhbg0KPiA+
IGludGVnZXIgbXVsdGlwbGUgb2YgdGhlIGNpcGhlciBibG9jayBzaXplIGluIHNpemUsIGJyaW5n
aW5nIGl0IGZ1bGx5IGluDQo+ID4gbGluZSB3aXRoIHRoZSBJRUVFIFAxNjE5L0QxNiBzdGFuZGFy
ZC4NCj4gPg0KPiA+IFRoaXMgaGFzIGJlZW4gdGVzdGVkIHdpdGggdGhlIEFFUy1YVFMgdGVzdCB2
ZWN0b3JzIGZyb20gdGhlIElFRUUgUDE2MTkvRDE2DQo+ID4gc3BlY2lmaWNhdGlvbiBhcyB3ZWxs
IGFzIHNvbWUgYWRkaXRpb25hbCB0ZXN0IHZlY3RvcnMgc3VwcGxpZWQgdG8gdGhlDQo+ID4gbGlu
dXhfY3J5cHRvIG1haWxpbmcgbGlzdCBwcmV2aW91c2x5LiBJdCBoYXMgYWxzbyBiZWVuIGZ1enpl
ZCBhZ2FpbnN0DQo+ID4gSW5zaWRlIFNlY3VyZSBBRVMtWFRTIGhhcmR3YXJlIHdoaWNoIGhhcyBi
ZWVuIGFjdGl2ZWx5IHVzZWQgaW4gdGhlIGZpZWxkDQo+ID4gZm9yIG1vcmUgdGhhbiBhIGRlY2Fk
ZSBhbHJlYWR5Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFzY2FsIHZhbiBMZWV1d2VuIDxw
dmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4NCj4gDQo+IFdvdywgaXQgd2FzIHF1aWNrLi4uIHRo
YW5rcyBmb3IgdGhpcyEgOikNCj4gDQo+IEkgdHJpZWQgdG8gdGVzdCB3aXRoIG15IHdyYXBwZXIg
dGhyb3VnaCBBRl9BTEcgKHdpdGggdGhlIGRpc2N1c3NlZCB0ZXN0IHZlY3RvcnMpLA0KPiBidXQg
aXQgY3Jhc2hlZCBteSAzMmJpdCBpNjg2IFZNIChMaW51cyB0cmVlIHdpdGggeW91ciBwYXRjaCBh
cHBsaWVkKQ0KPiANCk9rLCBJIGhhdmUgdG8gYWRtaXQgSSBvbmx5IHRyaWVkIGl0IG9uIG9uZSBw
YXJ0aWN1bGFyIGtlcm5lbCBjb25maWd1cmF0aW9uLg0KSSBkb24ndCByZWFsbHkgaGF2ZSB0aGUg
dGltZSBub3IgdGhlIHJlc291cmNlcyAoSSBhbHNvIGhhdmUgdG8gd29yayBvbiB0aGlzDQptYWNo
aW5lLCBzbyBJIG5lZWQgaXQgdG8gYmUgc3RhYmxlIC4uLikgdG8gcmVhbGx5IHRyeSBvdGhlciBj
b25maWd1cmF0aW9ucy4NCg0KPiBUbyByZXByb2R1Y2UgaXQsIHJ1biB0aGlzICJrZXJuZWwiIGFm
X2FsZyBicmFuY2ggb2YgZXh0cmFjdGVkIGNyeXB0c2V0dXAgdmVjdG9yIHRlc3RzdWl0ZToNCj4g
aHR0cHM6Ly9naXRodWIuY29tL21icm96L2NyeXB0c2V0dXBfYmFja2VuZF90ZXN0L3RyZWUva2Vy
bmVsDQo+IA0KSSdsbCB0cnkgdGhhdCB0b21vcnJvdyBpZiBJIGNhbiBnZXQgaXQgdG8gd29yayB3
aXRob3V0IHRvbyBtdWNoIGVmZm9ydC4NCg0KPiAob3V0cHV0KSAuLi4NCj4gQ0lQSEVSIHZlY3Rv
ciAwMDogW2Flcy1lY2IsMTI4Yml0c11bc2VycGVudC1lY2IsMTI4Yml0c10NCj4gQ0lQSEVSIHZl
Y3RvciAwMTogW2Flcy1jYmMsMTI4Yml0c11bc2VycGVudC1jYmMsMTI4Yml0c10NCj4gQ0lQSEVS
IHZlY3RvciAwMjogW2Flcy1lY2IsMjU2Yml0c11bc2VycGVudC1lY2IsMjU2Yml0c10NCj4gQ0lQ
SEVSIHZlY3RvciAwMzogW2Flcy1jYmMsMjU2Yml0c11bc2VycGVudC1jYmMsMjU2Yml0c10NCj4g
Q0lQSEVSIHZlY3RvciAwNDogW2Flcy14dHMsMjU2Yml0c11bc2VycGVudC14dHMsMjU2Yml0c10N
Cj4gQ0lQSEVSIHZlY3RvciAwNTogW2Flcy14dHMsNTEyYml0c11bc2VycGVudC14dHMsNTEyYml0
c10NCj4gQ0lQSEVSIHZlY3RvciAwNjogW3hjaGFjaGExMixhZXMtYWRpYW50dW0sMjU2Yml0c11b
eGNoYWNoYTIwLGFlcy1hZGlhbnR1bSwyNTZiaXRzXQ0KPiBTZWdtZW50YXRpb24gZmF1bHQNCj4g
DQpJIGFsc28gbm90aWNlZCBzb21lIGFsZ29yaXRobXMgdGhhdCBJIGRvbid0IHRoaW5rIEkgaGF2
ZSBjb25maWd1cmVkIGludG8gbXkNCmtlcm5lbCBhdCB0aGUgbW9tZW50IChuZXZlciBvY2N1cnJl
ZCB0byBtZSByZWFsbHksIEkgdHJ5IG5vdCB0byB0b3VjaCBteSBrZXJuZWwNCmNvbmZpZyBzbyBJ
IGRvbid0IGJyZWFrIGl0IGFuZCBJIHdhc24ndCBvcmlnaW5hbGx5IGludGVyZXN0ZWQgaW4gdGhl
c2UgYXMgSSBjYW4ndA0KdGhpbmsgb2YgYW55IHVzZSBjYXNlIGZvciB0aGVtKSwgbWF5YmUgSSBz
aG91bGQgdHJ5IGVuYWJsaW5nIHRob3NlIHdpdGggbXkga2VybmVsDQpmaXJzdC4NCg0KSSBrbm93
IHRoZXJlJ3MgcGFydCBvZiB0aGUgY29kZSBJIGNhbid0IGhpdCB3aXRoIHh0cyhhZXMpLCBidXQg
SSBhbHNvIGRpZG4ndCBrbm93DQpob3cgdG8gb3RoZXJ3aXNlIGhpdCBpdCwgbWF5YmUgb25lIG9m
IHRoZXNlIGRvZXMgaGl0IHRoYXQgYW5kIHJldmVhbHMgYSBidWcgdGhlcmUuDQoNCj4gDQo+IChJ
ZiB5b3UgY2Fubm90IHJlcHJvZHVjZSBpdCwgSSdsbCBjaGVjayBpdCB0b21vcnJvdy4gSXQgaXMg
cXVpdGUgcG9zc2libGUNCj4gSSBoYXZlIGEgYnVnIGluIHdyYXBwZXIsIGJ1dCBpdCBzaG91bGQg
ZGVmaW5pdGVseSBub3QgT09QUyB0aGUga2VybmVsLi4uDQo+IG1vcmVvdmVyLCB0aGlzIGNyYXNo
IGlzIHBvc3NpYmxlIGZyb20gYSB1c2VyIGNvbnRleHQpDQo+IA0KPiBUaGFua3MsDQo+IE1pbGFu
DQo+IA0KPiANCj4gT09QUyBsb2cgaGVyZToNCj4gDQo+IGtlcm5lbDogZGV0ZWN0ZWQgYnVmZmVy
IG92ZXJmbG93IGluIG1lbWNweQ0KPg0KT2ssIHNvIEkgcHJvYmFibHkgbWVzc2VkIHVwIHNvbWUg
bGVuZ3RoIHNvbWV3aGVyZSA6LSkNCkxldCdzIHNlZSBpZiBJIGNhbiBzcG90IGl0IGJ5IGNhcmVm
dWwgcmV2aWV3IC4uLg0KDQo+IGtlcm5lbDogLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0t
LS0tLS0tDQo+IGtlcm5lbDoga2VybmVsIEJVRyBhdCBsaWIvc3RyaW5nLmM6MTExNSENCj4ga2Vy
bmVsOiBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgU01QDQo+IGtlcm5lbDogQ1BV
OiAxIFBJRDogMjMwMyBDb21tOiB0c3QgTm90IHRhaW50ZWQgNS4zLjAtcmMzKyAjNTcyDQo+IGtl
cm5lbDogSGFyZHdhcmUgbmFtZTogVk13YXJlLCBJbmMuIFZNd2FyZSBWaXJ0dWFsIFBsYXRmb3Jt
LzQ0MEJYIERlc2t0b3AgUmVmZXJlbmNlIFBsYXRmb3JtLA0KPiBCSU9TIDYuMDAgMDQvMTMvMjAx
OA0KPiBrZXJuZWw6IEVJUDogZm9ydGlmeV9wYW5pYysweGUvMHgxOQ0KPiBrZXJuZWw6IENvZGU6
IGI2IDAwIDAwIDAwIDAwIDhiIDQ1IGU0IDgzIGM0IDEwIDViIDVlIDI5IGY4IDVmIDVkIGMzIDBm
IGI2IGMyIDBmIGI2IGYzIDI5IGYwDQo+IGViIGNlIDU1IDg5IGU1IDUwIDY4IDcwIDAzIDhkIGMx
IGU4IGNjIDI3IGE2IGZmIDwwZj4gMGIgOTAgOTAgOTAgOTAgOTAgOTAgOTAgOTAgOTAgNTUgODkg
ZTUNCj4gNTcgNTYgNTMgODkgZDMgODMgZWMgMDQNCj4ga2VybmVsOiBFQVg6IDAwMDAwMDIyIEVC
WDogZjE0MThkYzggRUNYOiBmNDBhYjc4NCBFRFg6IDAwMDAwMDAxDQo+IGtlcm5lbDogRVNJOiBm
MzE3YTMxOCBFREk6IDAwMDAwMDIwIEVCUDogZjBjMmJkZjQgRVNQOiBmMGMyYmRlYw0KPiBrZXJu
ZWw6IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4IEVGTEFHUzog
MDAwMTAyODYNCj4ga2VybmVsOiBDUjA6IDgwMDUwMDMzIENSMjogYjdmNTQzYTAgQ1IzOiAzMGUy
YTAwMCBDUjQ6IDAwMTQwNjkwDQo+IGtlcm5lbDogQ2FsbCBUcmFjZToNCj4ga2VybmVsOiAgZW5j
cnlwdF9maW5pc2hfY3RzLmNvbGQrMHhhLzB4YQ0KPiBrZXJuZWw6ICBlbmNyeXB0KzB4ZTcvMHgx
MDANCj4ga2VybmVsOiAgY3J5cHRvX3NrY2lwaGVyX2VuY3J5cHQrMHhlLzB4MjANCj4ga2VybmVs
OiAgc2tjaXBoZXJfcmVjdm1zZysweDJmNS8weDM5MCBbYWxnaWZfc2tjaXBoZXJdDQo+IGtlcm5l
bDogIHNvY2tfcmVhZF9pdGVyKzB4ODYvMHhkMA0KPiBrZXJuZWw6ICBfX3Zmc19yZWFkKzB4MTQw
LzB4MWYwDQo+IGtlcm5lbDogIHZmc19yZWFkKzB4OGIvMHgxNTANCj4ga2VybmVsOiAga3N5c19y
ZWFkKzB4NWMvMHhkMA0KPiBrZXJuZWw6ICBzeXNfcmVhZCsweDExLzB4MjANCj4ga2VybmVsOiAg
ZG9faW50ODBfc3lzY2FsbF8zMisweDRiLzB4MWEwDQo+IGtlcm5lbDogIGVudHJ5X0lOVDgwXzMy
KzB4ZmIvMHhmYg0KPiBrZXJuZWw6IEVJUDogMHhiN2Y2NDA5Mg0KPiBrZXJuZWw6IENvZGU6IDAw
IDAwIDAwIGU5IDkwIGZmIGZmIGZmIGZmIGEzIDI0IDAwIDAwIDAwIDY4IDMwIDAwIDAwIDAwIGU5
IDgwIGZmIGZmIGZmIGZmIGEzDQo+IDJjIDAwIDAwIDAwIDY2IDkwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIGNkIDgwIDxjMz4gOGQgYjQgMjYgMDAgMDAgMDAgMDAgOGQgYjYgMDAgMDAgMDAgMDAN
Cj4gOGIgMWMgMjQgYzMgOGQgYjQgMjYgMDANCj4ga2VybmVsOiBFQVg6IGZmZmZmZmRhIEVCWDog
MDAwMDAwMDQgRUNYOiBiZmRlMWQzYyBFRFg6IDAwMDAwMDI1DQo+IGtlcm5lbDogRVNJOiBiN2Y1
NzAwMCBFREk6IDAwMDAwMDAwIEVCUDogYmZkZTFjYjggRVNQOiBiZmRlMWJjYw0KPiBrZXJuZWw6
IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDMzIFNTOiAwMDdiIEVGTEFHUzogMDAw
MDAyODINCj4ga2VybmVsOiBNb2R1bGVzIGxpbmtlZCBpbjogbmhwb2x5MTMwNSBjaGFjaGFfZ2Vu
ZXJpYyBhZGlhbnR1bSBwb2x5MTMwNV9nZW5lcmljDQo+IHNlcnBlbnRfc3NlMl9pNTg2IHNlcnBl
bnRfZ2VuZXJpYyBnbHVlX2hlbHBlciBhbGdpZl9za2NpcGhlciBybWQxNjAgd3A1MTIgc2hhNTEy
X2dlbmVyaWMNCj4gc2hhMV9nZW5lcmljIGFsZ2lmX2hhc2ggYWZfYWxnIGxvb3AgZG1fbW9kIHBr
dGNkdmQgY3JjMzJfcGNsbXVsIGNyYzMyY19pbnRlbCBhZXNuaV9pbnRlbA0KPiBhZXNfaTU4NiBj
cnlwdG9fc2ltZCBjcnlwdGQgYXRhX3BpaXgNCj4ga2VybmVsOiAtLS1bIGVuZCB0cmFjZSAyOWQx
OGIwNGZlZmZjMTM5IF0tLS0NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNv
biBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cu
aW5zaWRlc2VjdXJlLmNvbQ0K
