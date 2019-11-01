Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E4ACA9ECF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 16:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3303B21734
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 16:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="tDRyo8vH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKAQnD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:43:03 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:9168 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfKAQnC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 12:43:02 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: RULPMlJxXsQPFt0BWr8WzfA1jyw/6nrEHwi9xLbMa6lbfwXZ+Quxx7LV2O80SMxhnz1C7lwo8Y
 k2yN0AbtIRsBEt8iYCCMfeC2hBu4qJslMG5K5XhzAZkNjXIjhoeAC1gjAuCm7cNKU/Nh1GjrAR
 WQZ0keFRrqVUXgCZo88R2y2h13JQPjcN1ATKklGR3aM9YBT1iQwpxoEnc0CXvBG7BMYmJmqQ/d
 rJS0aZXzLRw+2unIdZZNyf/e6gArE0+V14U6jUTlrPrZ/bjJeW+3eoZ7rkd1yLccY7cZwZ3QWm
 G2M=
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400"; 
   d="scan'208";a="54996722"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2019 09:43:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 09:43:01 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 1 Nov 2019 09:43:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4m2YimchV5IS4Db93RmiY2g4uI7dLDnFEmMm0CnLuw0tKuNH9YQHGC4PetOeoCIinHMFCcwkEIl/BPfpf9qLOdhlSpW/d4CKN5I0UUuwEdQOi4in6FXMRr01e7zuCoGnptKf9Drsq7AIUadE9gnonHkHGcpjANv3AGzU+DBGGzYOeXu9Xu4Xz09thniHgWtesiQQ5A9Wcv46Guq5M+IOdT9NUTdQ9P//3AQco7ZjUlPpiHrkrckLFllgI2pPCJzko7hmWOe3tPBi0YAg2J45Xj5pS/I2QYoJgsCdwbVkGN4r+ZSpu/m+pZSw9utyenbiRmH/YJCZqNwGoYRlrHoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmGw3iui+eeEfIXcZHEwkjZuLlF0h9vrwYMBfxxcQl0=;
 b=JFcqklrsXz1doLw4LvLbmLiBaYFNE4cohRVfxU0N+7XqWgobYHm2MiEDvHFDtdLKRi2M7iYZpregoNZ/1RQ+jw5JEphRPZwZa1PbPTd/8eGPm7pC9xuWp1AYQ5s06QmeF4vBMx7PYVLg2xd7XjQDNmQE9y2z2S0Ojwi1U1gLBwGGy2KnnTnjthyNXxaIvlgC96uqKo5KgBF26jvr3FDroEGojPeBMQnThrD6PZ6qalOT/lg2fj9hmYvyvq/RNa8ap1ApjhyEawYg5wB49F3AUaD0QfZ3oa5WEXb9Jcm9Fzf2Hk4AEfWO0K0n80Y6yzlvAr8MAA3/larumEuJ1PkgJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmGw3iui+eeEfIXcZHEwkjZuLlF0h9vrwYMBfxxcQl0=;
 b=tDRyo8vHGXqgwJKbGHcUJAjMEDuVGPSUKnZsqykUJwocDaxMsMlpbLIih8OVop+liTAsXRL7FJu8Q28BmSJghjqVwDtZVoDgrvQXpe0yNvBPkbsfLJg6HOFV3YB76sq9iYBhk5lJwXE6uWwGuB5f3Uf2F+H7l1UBC/q/pNQycoE=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3726.namprd11.prod.outlook.com (20.178.251.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 1 Nov 2019 16:42:58 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2408.018; Fri, 1 Nov 2019
 16:42:58 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <cyrille.pitchen@atmel.com>
Subject: Re: crypto: atmel - Fix authenc support when it is set to m
Thread-Topic: crypto: atmel - Fix authenc support when it is set to m
Thread-Index: AQHVjWLV/yC0HfSHhU2H8roX+5OQuqd2i/UA
Date:   Fri, 1 Nov 2019 16:42:57 +0000
Message-ID: <7cc2ef12-0711-e72a-9bf8-27f5eb1f7827@microchip.com>
References: <20191028073907.pbk6j5fvi7ludbvx@gondor.apana.org.au>
In-Reply-To: <20191028073907.pbk6j5fvi7ludbvx@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0801CA0085.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::29) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.120.239.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a2cdbc-7e82-447b-a1a1-08d75eea8cf4
x-ms-traffictypediagnostic: MN2PR11MB3726:
x-microsoft-antispam-prvs: <MN2PR11MB372648C859AED6B952D74532F0620@MN2PR11MB3726.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(486006)(6246003)(76176011)(25786009)(186003)(386003)(2616005)(31696002)(66946007)(66556008)(64756008)(3846002)(478600001)(229853002)(476003)(71200400001)(11346002)(71190400001)(14454004)(6486002)(6506007)(52116002)(66476007)(6116002)(14444005)(53546011)(446003)(86362001)(256004)(26005)(6436002)(102836004)(316002)(31686004)(6512007)(2906002)(66446008)(8676002)(5660300002)(110136005)(81156014)(7736002)(305945005)(36756003)(66066001)(8936002)(99286004)(81166006)(129723003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3726;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XzksDKeVmvX0Gs3Mzl1G3moMNGCxifV/L4TApVqt8j6OlEHLpahnx48v3YMeV05L021DnB622zxyqmrBxRRQbRmBSrebUIg+3/SB3nzAJUOK8VyWCr6Z9U9IzR5fuLXTKUN3jkYwxa/tyvx6XbggZDrt8G8v0cf+l//EEAUF6KNhRhJfnUgNw2IsjR+IOZ3xVKNWgNKmnzN/N7XW01Uyt5APJDxtINhqFdW0DwADCsXjb0is3J5sqooHxb3G9vvg50lKYtdZFXLgcruZLHBFTeUdVsJ+zVMKtIJuhM5UROa74hBH31dTR2CJs06SSy3SE7IIsfW/2JbOZ90mEBDZE/ObrEN7xbZlWy6w3hkhJEpqp6N6HcnhWpkP16NCc4C0IfCaGLj6/qsx2+w4C88GW3wQsCeS0VP5eCC78YQiKtOuipLO7yyfDzvaGn9IPCAk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F708EBF1DD17CD44A68F97CE462099AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a2cdbc-7e82-447b-a1a1-08d75eea8cf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 16:42:57.8573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vYe2noIZcv+0KrbD5IYhWe1rhPy87oVC1tYTJhEqerqlW3f/3CqHbAzMIgN8y+J6HkeJsurTdsxB6I0rfY7sLOSr7uB9yragfe4hPQeDrps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3726
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDEwLzI4LzIwMTkgMDk6MzkgQU0sIEhlcmJlcnQgWHUgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IEFzIGl0IGlzIGlmIENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FV
VEhFTkMgaXMgc2V0IHRvIG0gaXQgaXMgaW4NCj4gZWZmZWN0IGRpc2FibGVkLiAgVGhpcyBwYXRj
aCBmaXhlcyBpdCBieSB1c2luZyBJU19FTkFCTEVEIGluc3RlYWQNCj4gb2YgaWZkZWYuDQo+IA0K
PiBGaXhlczogODlhODJlZjg3ZTAxICgiY3J5cHRvOiBhdG1lbC1hdXRoZW5jIC0gYWRkIHN1cHBv
cnQgdG8uLi4iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5h
cGFuYS5vcmcuYXU+DQo+IA0KDQpSZXZpZXdlZC1ieTogVHVkb3IgQW1iYXJ1cyA8dHVkb3IuYW1i
YXJ1c0BtaWNyb2NoaXAuY29tPg0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9hdG1l
bC1hZXMuYyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jDQo+IGluZGV4IDMzYTc2ZDFmNGE2
ZS4uYzVlYzc0MTcxZmJmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9hdG1lbC1hZXMu
Yw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC1hZXMuYw0KPiBAQCAtMTQ1LDcgKzE0NSw3
IEBAIHN0cnVjdCBhdG1lbF9hZXNfeHRzX2N0eCB7DQo+ICAJdTMyCQkJa2V5MltBRVNfS0VZU0la
RV8yNTYgLyBzaXplb2YodTMyKV07DQo+ICB9Ow0KPiAgDQo+IC0jaWZkZWYgQ09ORklHX0NSWVBU
T19ERVZfQVRNRUxfQVVUSEVOQw0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0NSWVBUT19ERVZf
QVRNRUxfQVVUSEVOQykNCj4gIHN0cnVjdCBhdG1lbF9hZXNfYXV0aGVuY19jdHggew0KPiAgCXN0
cnVjdCBhdG1lbF9hZXNfYmFzZV9jdHgJYmFzZTsNCj4gIAlzdHJ1Y3QgYXRtZWxfc2hhX2F1dGhl
bmNfY3R4CSphdXRoOw0KPiBAQCAtMTU3LDcgKzE1Nyw3IEBAIHN0cnVjdCBhdG1lbF9hZXNfcmVx
Y3R4IHsNCj4gIAl1MzIJCQlsYXN0Y1tBRVNfQkxPQ0tfU0laRSAvIHNpemVvZih1MzIpXTsNCj4g
IH07DQo+ICANCj4gLSNpZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5DDQo+ICsj
aWYgSVNfRU5BQkxFRChDT05GSUdfQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5DKQ0KPiAgc3RydWN0
IGF0bWVsX2Flc19hdXRoZW5jX3JlcWN0eCB7DQo+ICAJc3RydWN0IGF0bWVsX2Flc19yZXFjdHgJ
YmFzZTsNCj4gIA0KPiBAQCAtNDg2LDcgKzQ4Niw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBhdG1l
bF9hZXNfaXNfZW5jcnlwdChjb25zdCBzdHJ1Y3QgYXRtZWxfYWVzX2RldiAqZGQpDQo+ICAJcmV0
dXJuIChkZC0+ZmxhZ3MgJiBBRVNfRkxBR1NfRU5DUllQVCk7DQo+ICB9DQo+ICANCj4gLSNpZmRl
ZiBDT05GSUdfQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5DDQo+ICsjaWYgSVNfRU5BQkxFRChDT05G
SUdfQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5DKQ0KPiAgc3RhdGljIHZvaWQgYXRtZWxfYWVzX2F1
dGhlbmNfY29tcGxldGUoc3RydWN0IGF0bWVsX2Flc19kZXYgKmRkLCBpbnQgZXJyKTsNCj4gICNl
bmRpZg0KPiAgDQo+IEBAIC01MTUsNyArNTE1LDcgQEAgc3RhdGljIHZvaWQgYXRtZWxfYWVzX3Nl
dF9pdl9hc19sYXN0X2NpcGhlcnRleHRfYmxvY2soc3RydWN0IGF0bWVsX2Flc19kZXYgKmRkKQ0K
PiAgDQo+ICBzdGF0aWMgaW5saW5lIGludCBhdG1lbF9hZXNfY29tcGxldGUoc3RydWN0IGF0bWVs
X2Flc19kZXYgKmRkLCBpbnQgZXJyKQ0KPiAgew0KPiAtI2lmZGVmIENPTkZJR19DUllQVE9fREVW
X0FUTUVMX0FVVEhFTkMNCj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19DUllQVE9fREVWX0FUTUVM
X0FVVEhFTkMpDQo+ICAJaWYgKGRkLT5jdHgtPmlzX2FlYWQpDQo+ICAJCWF0bWVsX2Flc19hdXRo
ZW5jX2NvbXBsZXRlKGRkLCBlcnIpOw0KPiAgI2VuZGlmDQo+IEBAIC0xOTgwLDcgKzE5ODAsNyBA
QCBzdGF0aWMgc3RydWN0IGNyeXB0b19hbGcgYWVzX3h0c19hbGcgPSB7DQo+ICAJfQ0KPiAgfTsN
Cj4gIA0KPiAtI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMNCj4gKyNpZiBJ
U19FTkFCTEVEKENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMpDQo+ICAvKiBhdXRoZW5j
IGFlYWQgZnVuY3Rpb25zICovDQo+ICANCj4gIHN0YXRpYyBpbnQgYXRtZWxfYWVzX2F1dGhlbmNf
c3RhcnQoc3RydWN0IGF0bWVsX2Flc19kZXYgKmRkKTsNCj4gQEAgLTI0NjcsNyArMjQ2Nyw3IEBA
IHN0YXRpYyB2b2lkIGF0bWVsX2Flc191bnJlZ2lzdGVyX2FsZ3Moc3RydWN0IGF0bWVsX2Flc19k
ZXYgKmRkKQ0KPiAgew0KPiAgCWludCBpOw0KPiAgDQo+IC0jaWZkZWYgQ09ORklHX0NSWVBUT19E
RVZfQVRNRUxfQVVUSEVOQw0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0NSWVBUT19ERVZfQVRN
RUxfQVVUSEVOQykNCj4gIAlpZiAoZGQtPmNhcHMuaGFzX2F1dGhlbmMpDQo+ICAJCWZvciAoaSA9
IDA7IGkgPCBBUlJBWV9TSVpFKGFlc19hdXRoZW5jX2FsZ3MpOyBpKyspDQo+ICAJCQljcnlwdG9f
dW5yZWdpc3Rlcl9hZWFkKCZhZXNfYXV0aGVuY19hbGdzW2ldKTsNCj4gQEAgLTI1MTQsNyArMjUx
NCw3IEBAIHN0YXRpYyBpbnQgYXRtZWxfYWVzX3JlZ2lzdGVyX2FsZ3Moc3RydWN0IGF0bWVsX2Fl
c19kZXYgKmRkKQ0KPiAgCQkJZ290byBlcnJfYWVzX3h0c19hbGc7DQo+ICAJfQ0KPiAgDQo+IC0j
aWZkZWYgQ09ORklHX0NSWVBUT19ERVZfQVRNRUxfQVVUSEVOQw0KPiArI2lmIElTX0VOQUJMRUQo
Q09ORklHX0NSWVBUT19ERVZfQVRNRUxfQVVUSEVOQykNCj4gIAlpZiAoZGQtPmNhcHMuaGFzX2F1
dGhlbmMpIHsNCj4gIAkJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoYWVzX2F1dGhlbmNfYWxn
cyk7IGkrKykgew0KPiAgCQkJZXJyID0gY3J5cHRvX3JlZ2lzdGVyX2FlYWQoJmFlc19hdXRoZW5j
X2FsZ3NbaV0pOw0KPiBAQCAtMjUyNiw3ICsyNTI2LDcgQEAgc3RhdGljIGludCBhdG1lbF9hZXNf
cmVnaXN0ZXJfYWxncyhzdHJ1Y3QgYXRtZWxfYWVzX2RldiAqZGQpDQo+ICANCj4gIAlyZXR1cm4g
MDsNCj4gIA0KPiAtI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMNCj4gKyNp
ZiBJU19FTkFCTEVEKENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMpDQo+ICAJLyogaSA9
IEFSUkFZX1NJWkUoYWVzX2F1dGhlbmNfYWxncyk7ICovDQo+ICBlcnJfYWVzX2F1dGhlbmNfYWxn
Og0KPiAgCWZvciAoaiA9IDA7IGogPCBpOyBqKyspDQo+IEBAIC0yNzE2LDcgKzI3MTYsNyBAQCBz
dGF0aWMgaW50IGF0bWVsX2Flc19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0K
PiAgDQo+ICAJYXRtZWxfYWVzX2dldF9jYXAoYWVzX2RkKTsNCj4gIA0KPiAtI2lmZGVmIENPTkZJ
R19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMNCj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19DUllQ
VE9fREVWX0FUTUVMX0FVVEhFTkMpDQo+ICAJaWYgKGFlc19kZC0+Y2Fwcy5oYXNfYXV0aGVuYyAm
JiAhYXRtZWxfc2hhX2F1dGhlbmNfaXNfcmVhZHkoKSkgew0KPiAgCQllcnIgPSAtRVBST0JFX0RF
RkVSOw0KPiAgCQlnb3RvIGljbGtfdW5wcmVwYXJlOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9j
cnlwdG8vYXRtZWwtYXV0aGVuYy5oIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtYXV0aGVuYy5oDQo+
IGluZGV4IGNiZDM3YTJlZGFkYS4uZDZkZTgxMGRmNDRmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9hdG1lbC1hdXRoZW5jLmgNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtYXV0
aGVuYy5oDQo+IEBAIC0xMiw3ICsxMiw3IEBADQo+ICAjaWZuZGVmIF9fQVRNRUxfQVVUSEVOQ19I
X18NCj4gICNkZWZpbmUgX19BVE1FTF9BVVRIRU5DX0hfXw0KPiAgDQo+IC0jaWZkZWYgQ09ORklH
X0NSWVBUT19ERVZfQVRNRUxfQVVUSEVOQw0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0NSWVBU
T19ERVZfQVRNRUxfQVVUSEVOQykNCj4gIA0KPiAgI2luY2x1ZGUgPGNyeXB0by9hdXRoZW5jLmg+
DQo+ICAjaW5jbHVkZSA8Y3J5cHRvL2hhc2guaD4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5
cHRvL2F0bWVsLXNoYS5jIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtc2hhLmMNCj4gaW5kZXggODRj
Yjg3NDhhNzk1Li5kMzI2MjY0NThlNjcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2F0
bWVsLXNoYS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVsLXNoYS5jDQo+IEBAIC0yMjEy
LDcgKzIyMTIsNyBAQCBzdGF0aWMgc3RydWN0IGFoYXNoX2FsZyBzaGFfaG1hY19hbGdzW10gPSB7
DQo+ICB9LA0KPiAgfTsNCj4gIA0KPiAtI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FV
VEhFTkMNCj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19DUllQVE9fREVWX0FUTUVMX0FVVEhFTkMp
DQo+ICAvKiBhdXRoZW5jIGZ1bmN0aW9ucyAqLw0KPiAgDQo+ICBzdGF0aWMgaW50IGF0bWVsX3No
YV9hdXRoZW5jX2luaXQyKHN0cnVjdCBhdG1lbF9zaGFfZGV2ICpkZCk7DQo+IA0K
