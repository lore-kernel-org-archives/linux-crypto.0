Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C94CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C00A921929
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="npb34cvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438317AbfJYJHo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:07:44 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:47327 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438275AbfJYJHn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 05:07:43 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: IexAyWthAuiLEYdXymJH5wRWhzQHNSXelgGrFn+a8xzkkNhJU+aU+VsO+0ydluBz0iiVMDP0fj
 eLJTcOQodps2cr4GMVlWh+Q+vX1pkyn//tkuO4OL9dzdA6WatJoZBFKGA/IIm/021J3MKtvYNh
 NXXBvUEcCbLVhEZOze4DHRHjWlc5mitzXvcjJShF+FRDBvP7xPLL5JyxymnZsx9p2PxsKzksbF
 q2ZNX0bHe1hCy8SgEkpFaR2rE7aJCkSBGT6U7GpLpaMoN7QLd2rEqUL0QeKzCGNH5YiPWCxz3s
 dZY=
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="52906644"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2019 02:07:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 25 Oct 2019 02:07:34 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 25 Oct 2019 02:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmUrAIVSI4/mPZbmXVtqHNbOQ3LHiBGIJ4hxtzsxGNd47+NBVgMqio88aZzOCvOiZDVDgQgeqg+sdrcFZNZMtSv4sEFFOCMIRIBR/v4nMx8ZLH8txD3f7SLSRlV8uIqEsEmjBWinNEdkvE/B4LejNnuQemx28RlXtBDEPNkPDN3HIc08Ue6Tud/ciUGLAp2NydIcvDBqUegieqQd+IKO+90CpeXZbRBCN1BHLCyzN1tGE0HcyQicztcTWO1+HerhDW6C9f4exH+EC+bq7Wm9Tda/EALrV4osDO32m9gOBln7d6RHHefC7wR9uj9cmHwGVfJ3TdlWOb//FqWfGxsaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQbfEhqlNKf6UbNoH49tqM0zOAmq92qItby+ITKgtu8=;
 b=WuiHFxxdx+zSZFVrU/SY9ZNSsWzc9+WD0DDLW76GYuEcMyEf0Qo0Ahphw6li8m3//DdgtHs8W0RKqBiWrTRzDUTHmZ+VYqs/NhQ+qRs9zTlNN0OUN0Ig5kCCjK6ClejvQaN8ASwqSiwYK+awJliyY01V4id16UE7IW1Rvy41Vqs5b3PVn4S25/YVrJEk8xQkkYZPEgQoIAsVPenCZOLoRkoMCVgnt2NmryjSWxhQ0cSnDVHUMqTuOvQKIHBfiP+8SSA5V/uC90lpzy46S3z5yz8V1qoA4u2Kv2xfTB1Kwgl6mgg1sgNetmoVebYNfNmqaGO00/h/PgK4ZVtAo2qIRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQbfEhqlNKf6UbNoH49tqM0zOAmq92qItby+ITKgtu8=;
 b=npb34cvgLh20pod/fzJ6IYFeqRwPP+XzwMMK6Tm98npnufcqXRIx/4/7ZZaUfBNC3XpEUsgh+ifKL+Uf+IxxvxhcRj6se4NrsuOUb0VD4jMauBGhoOGIT+Z9h6l3IHt2x+Dn+v0zhUxWsOdezaAiq53IX9bidxfCYnYH2Upjutk=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.85) by
 DM6PR11MB2572.namprd11.prod.outlook.com (20.176.100.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Fri, 25 Oct 2019 09:07:29 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::3874:9f3c:5325:d22]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::3874:9f3c:5325:d22%6]) with mapi id 15.20.2387.023; Fri, 25 Oct 2019
 09:07:29 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Codrin.Ciubotariu@microchip.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mark.rutland@arm.com>, <alexandre.belloni@bootlin.com>,
        <herbert@gondor.apana.org.au>, <arnd@arndb.de>,
        <Tudor.Ambarus@microchip.com>, <Ludovic.Desroches@microchip.com>,
        <robh+dt@kernel.org>, <mpm@selenic.com>
Subject: Re: [PATCH 2/2] hwrng: atmel: add new platform support for sam9x60
Thread-Topic: [PATCH 2/2] hwrng: atmel: add new platform support for sam9x60
Thread-Index: AQHVixOa0hr3oqzTbEKwBZhiv5PNKg==
Date:   Fri, 25 Oct 2019 09:07:28 +0000
Message-ID: <d5274a26-ae1b-f1c2-136c-3e3b6a9a69e7@microchip.com>
References: <20191024170452.2145-1-codrin.ciubotariu@microchip.com>
 <20191024170452.2145-2-codrin.ciubotariu@microchip.com>
In-Reply-To: <20191024170452.2145-2-codrin.ciubotariu@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0163.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::31) To DM6PR11MB3225.namprd11.prod.outlook.com
 (2603:10b6:5:59::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20191025120719921
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1f602ac-96c9-4f47-8ea5-08d7592ac2bf
x-ms-traffictypediagnostic: DM6PR11MB2572:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB257239FF7F7269B2E1BDB74E87650@DM6PR11MB2572.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:242;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(199004)(189003)(256004)(7416002)(52116002)(14454004)(476003)(11346002)(2616005)(186003)(2906002)(66066001)(26005)(6506007)(31686004)(316002)(102836004)(486006)(110136005)(76176011)(71190400001)(478600001)(54906003)(71200400001)(53546011)(386003)(81166006)(305945005)(6486002)(446003)(7736002)(2201001)(8676002)(31696002)(229853002)(64756008)(25786009)(81156014)(4326008)(8936002)(99286004)(6246003)(5660300002)(6116002)(66476007)(66556008)(66446008)(3846002)(36756003)(66946007)(6512007)(86362001)(6436002)(2501003)(138113003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2572;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WiTZTuJSHC+uq0YuseIV/QgWNeBJtCtfnMqKmKpktCwtHbDfy86ChIWf1Zgo9hDUuzEanVzRgUC4ZXzlBnW0msACqkha/sbe7IffNJeW3OLtLKU+qCXDMG+d9vJJnyOWSmNdauyNklGaPPzC6ieeTrMgj51uRhgVCQDlpV5ftdPx6aEY/nQmQ9CZLcjqzLIqhYkPQYYxbQZBgvxnr8nqHdJOWW9NlWWhTZo6jaTtzs6fQ4gx9B/nk+dFyslkp71cN4dOTfg6K2m+SL4YPhxo+jYOK8+FVi5XpUEwt0lue0G5vaG0MG9lArDJiex6/TOwmREhn4H1LoqPCRO4cLrq8kN523rCGvMz1hGv45VKNFhIK5wS0LL+DlHcLH+aPw5oL9yuCfSWjG8Js0Ub6yJujmV2MMX+NlU+iDqlX6Gno8zy18IvemwzYco79wuhUtZC
Content-Type: text/plain; charset="utf-8"
Content-ID: <B23E54D3BB3A5C4285E1997EB4B53632@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f602ac-96c9-4f47-8ea5-08d7592ac2bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 09:07:28.8386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJZP/Sa1KqebVL5POBstR+KAJsu9aHgq2PPjzXsjShprazqXkasVA0ZKeH5D+idPQVQbz4g/rYwATPlWStNwYlge3COlT0o0c8kZnOWveiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2572
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQ29kcmluLA0KDQpPbiAyNC4xMC4yMDE5IDIwOjA0LCBDb2RyaW4gQ2l1Ym90YXJpdSB3cm90
ZToNCj4gQWRkIHBsYXRmb3JtIHN1cHBvcnQgZm9yIHRoZSBuZXcgSVAgZm91bmQgb24gc2FtOXg2
MCBTb0MuIEZvciB0aGlzDQo+IHZlcnNpb24sIGlmIHRoZSBwZXJpcGhlcmFsIGNsayBpcyBhYm92
ZSAxMDBNSHosIHRoZSBIQUxGUiBiaXQgbXVzdCBiZQ0KPiBzZXQuIFRoaXMgYml0IGlzIGF2YWls
YWJsZSBvbmx5IGlmIHRoZSBJUCBjYW4gZ2VuZXJhdGUgYSByYW5kb20gbnVtYmVyDQo+IGV2ZXJ5
IDE2OCBjeWNsZXMgKGluc3RlYWQgb2YgODQpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29kcmlu
IENpdWJvdGFyaXUgPGNvZHJpbi5jaXVib3Rhcml1QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9hdG1lbC1ybmcuYyB8IDM5ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9hdG1l
bC1ybmcuYyBiL2RyaXZlcnMvY2hhci9od19yYW5kb20vYXRtZWwtcm5nLmMNCj4gaW5kZXggZTU1
NzA1NzQ1ZDVlLi4wYWE5NDI1ZTZjM2UgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY2hhci9od19y
YW5kb20vYXRtZWwtcm5nLmMNCj4gKysrIGIvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9hdG1lbC1y
bmcuYw0KPiBAQCAtMTQsMTQgKzE0LDIyIEBADQo+ICAjaW5jbHVkZSA8bGludXgvY2xrLmg+DQo+
ICAjaW5jbHVkZSA8bGludXgvaW8uaD4NCj4gICNpbmNsdWRlIDxsaW51eC9od19yYW5kb20uaD4N
Cj4gKyNpbmNsdWRlIDxsaW51eC9vZl9kZXZpY2UuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wbGF0
Zm9ybV9kZXZpY2UuaD4NCj4gIA0KPiAgI2RlZmluZSBUUk5HX0NSCQkweDAwDQo+ICsjZGVmaW5l
IFRSTkdfTVIJCTB4MDQNCj4gICNkZWZpbmUgVFJOR19JU1IJMHgxYw0KPiAgI2RlZmluZSBUUk5H
X09EQVRBCTB4NTANCj4gIA0KPiAgI2RlZmluZSBUUk5HX0tFWQkweDUyNGU0NzAwIC8qIFJORyAq
Lw0KPiAgDQo+ICsjZGVmaW5lIFRSTkdfSEFMRlIJQklUKDApIC8qIGdlbmVyYXRlIFJOIGV2ZXJ5
IDE2OCBjeWNsZXMgKi8NCj4gKw0KPiArc3RydWN0IGF0bWVsX3RybmdfcGRhdGEgew0KPiArCWJv
b2wgaGFzX2hhbGZfcmF0ZTsNCj4gK307DQo+ICsNCj4gIHN0cnVjdCBhdG1lbF90cm5nIHsNCj4g
IAlzdHJ1Y3QgY2xrICpjbGs7DQo+ICAJdm9pZCBfX2lvbWVtICpiYXNlOw0KPiBAQCAtNjMsNiAr
NzEsNyBAQCBzdGF0aWMgaW50IGF0bWVsX3RybmdfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldikNCj4gIHsNCj4gIAlzdHJ1Y3QgYXRtZWxfdHJuZyAqdHJuZzsNCj4gIAlzdHJ1Y3Qg
cmVzb3VyY2UgKnJlczsNCj4gKwljb25zdCBzdHJ1Y3QgYXRtZWxfdHJuZ19wZGF0YSAqcGRhdGE7
DQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCXRybmcgPSBkZXZtX2t6YWxsb2MoJnBkZXYtPmRldiwg
c2l6ZW9mKCp0cm5nKSwgR0ZQX0tFUk5FTCk7DQo+IEBAIC03Nyw2ICs4NiwxNyBAQCBzdGF0aWMg
aW50IGF0bWVsX3RybmdfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAl0
cm5nLT5jbGsgPSBkZXZtX2Nsa19nZXQoJnBkZXYtPmRldiwgTlVMTCk7DQo+ICAJaWYgKElTX0VS
Uih0cm5nLT5jbGspKQ0KPiAgCQlyZXR1cm4gUFRSX0VSUih0cm5nLT5jbGspOw0KPiArCXBkYXRh
ID0gb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhKCZwZGV2LT5kZXYpOw0KPiArCWlmICghcGRhdGEp
DQo+ICsJCXJldHVybiAtRU5PREVWOw0KPiArDQo+ICsJaWYgKHBkYXRhLT5oYXNfaGFsZl9yYXRl
KSB7DQo+ICsJCXVuc2lnbmVkIGxvbmcgcmF0ZSA9IGNsa19nZXRfcmF0ZSh0cm5nLT5jbGspOw0K
PiArDQo+ICsJCS8qIGlmIHBlcmlwaGVyYWwgY2xrIGlzIGFib3ZlIDEwME1Ieiwgc2V0IEhBTEZS
ICovDQo+ICsJCWlmIChyYXRlID4gMTAwMDAwMDAwKQ0KPiArCQkJd3JpdGVsKFRSTkdfSEFMRlIs
IHRybmctPmJhc2UgKyBUUk5HX01SKTsNCj4gKwl9Pg0KPiAgCXJldCA9IGNsa19wcmVwYXJlX2Vu
YWJsZSh0cm5nLT5jbGspOw0KPiAgCWlmIChyZXQpDQo+IEBAIC0xNDEsOSArMTYxLDI0IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3QgZGV2X3BtX29wcyBhdG1lbF90cm5nX3BtX29wcyA9IHsNCj4gIH07
DQo+ICAjZW5kaWYgLyogQ09ORklHX1BNICovDQo+ICANCj4gK3N0YXRpYyBzdHJ1Y3QgYXRtZWxf
dHJuZ19wZGF0YSBhdDkxc2FtOWc0NV9jb25maWcgPSB7DQo+ICsJLmhhc19oYWxmX3JhdGUgPSBm
YWxzZSwNCj4gK307DQoNCllvdSBjYW4gdXNlIGNvbnN0IGZvciB0aGlzLg0KDQo+ICsNCj4gK3N0
YXRpYyBzdHJ1Y3QgYXRtZWxfdHJuZ19wZGF0YSBzYW05eDYwX2NvbmZpZyA9IHsNCj4gKwkuaGFz
X2hhbGZfcmF0ZSA9IHRydWUsDQo+ICt9Ow0KPiArDQoNClNhbWUgaGVyZS4NCg0KPiAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgYXRtZWxfdHJuZ19kdF9pZHNbXSA9IHsNCj4gLQl7
IC5jb21wYXRpYmxlID0gImF0bWVsLGF0OTFzYW05ZzQ1LXRybmciIH0sDQo+IC0JeyAvKiBzZW50
aW5lbCAqLyB9DQo+ICsJew0KPiArCQkuY29tcGF0aWJsZSA9ICJhdG1lbCxhdDkxc2FtOWc0NS10
cm5nIiwNCj4gKwkJLmRhdGEgPSAmYXQ5MXNhbTlnNDVfY29uZmlnLA0KPiArCX0sIHsNCj4gKwkJ
LmNvbXBhdGlibGUgPSAibWljcm9jaGlwLHNhbTl4NjAtdHJuZyIsDQo+ICsJCS5kYXRhID0gJnNh
bTl4NjBfY29uZmlnLA0KPiArCX0sIHsNCj4gKwkJLyogc2VudGluZWwgKi8NCj4gKwl9DQo+ICB9
Ow0KPiAgTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgYXRtZWxfdHJuZ19kdF9pZHMpOw0KPiAgDQo+
IA0K
