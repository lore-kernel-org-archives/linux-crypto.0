Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6375DC43331
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 12:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F7E5222D0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 12:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="GFLvemWW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfKMMt4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 07:49:56 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:25617 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfKMMtz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 07:49:55 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: qXjhcxbWyRp4IJrjOtIpy3Ip10+udU+zqtX8xTrtnfnRmGh4k3TuPBA1XyUBA10CFGo6jY1Pne
 ErJUnkkacOGXa9ZD8hDz3oBa//+c+mYVPaVyWEAGwdJMgbnrttKXOmcs6iymxGgHOwP9+gYggq
 KTSVwzSgdQhhyzKsw+HD3mw3Dz4foYRFOd9sIG2svRCk+6Ub340X1Kpxf9pPIto+L3f0EdJHaw
 LWqhCyRMiscciHjKzQbAwHR+T6Sxina2hDU8ZewvPH+RTNsa09hY5am/Fq2Ewe5bPoDiTjqzMN
 Hk0=
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="55288520"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 05:49:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 05:49:54 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 13 Nov 2019 05:49:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMznAif1yn5xwcV0q69Z9DLBi0+K298U7vbhrLK6EVGxeOtHr6gLHen2f6oshmXJVzK4MbOJqdQTPUcyQ0/ppGrTAOhDlJVxduOh3558OixbaE1k6vNAXmLKC6yrXw1UZ2r7B8Gl/OkaYpdwslhFsi+r0TxQIOXOASr/yrtlrFMPWTfJGcfQKETjjbU6THS/vbSomIhqWioZJ15S54qEG4+265vSp++rJenX8Hq5Hl8oRwv1uJH3UXwsGTfZuPQZi4nSHUU3yIzq19kxf6VJ489dyuMiiFC3ARlO0DVVabZOVPu0nmZreXlyyikvjzxcb1JehsQLfs056xjHbquGNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/X7Pge/572lFtmV/orfC5lOsIZR1SSsdqLMGmpjfiQ=;
 b=DKaugO7ozSP2GWiPllb6LdtlPDT1Iz9DzJEyP3maou9wCy8d7XPc+Zz5mVYQacElz7iOnWHJGQYXRHaP/t5auDIr+bguxXiFL/WtvfDyDaOuGUcy61BhT64lJy8Jl8ILMm++PWECKsPP0FAX/6aAKpNsPE68OWlPMjruqU28djIjoUrtUjJF4/CKcXO8cZmwUsjW5FrWU2TSzGwejJG9PK5nphy+UFkJfYOIlPKL5V1SVJl9aKQ+2/zj3Q0frthCPCsdUExgdM2CGYG03CBO2RjuqmTlGBC1Exb4GkIupjuEh0bwd56F931g/SccgGuRYPIIrnYHY0L6w+481MnMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/X7Pge/572lFtmV/orfC5lOsIZR1SSsdqLMGmpjfiQ=;
 b=GFLvemWW9V69bD1aJeiMGH/6NFdjU49SknCUhbvMjS4HLwM9B7xNdsb6TR1HlRFB4J8n2L4i1n5JWTZhXeajdjxF1gRhuRIUoB49vhWLgB59xeV2OS8yKdyqwHt3/23Pi7X0uVD3VeXtkwy3qq2jNOULzPq9GE+wd/4D1+X/Zo8=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (10.255.89.94) by
 BY5PR11MB4228.namprd11.prod.outlook.com (52.132.253.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 12:49:52 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::d128:6959:f7a2:9d17]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::d128:6959:f7a2:9d17%4]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 12:49:51 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <ardb@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH v4 08/29] crypto: atmel-aes - switch to skcipher API
Thread-Topic: [PATCH v4 08/29] crypto: atmel-aes - switch to skcipher API
Thread-Index: AQHVlyCtZyuc8knlbUKjVsUY4d36zKeJE2EA
Date:   Wed, 13 Nov 2019 12:49:51 +0000
Message-ID: <447642c7-5908-c601-7cd7-e4d2f6a284a0@microchip.com>
References: <20191109170954.756-1-ardb@kernel.org>
 <20191109170954.756-9-ardb@kernel.org>
In-Reply-To: <20191109170954.756-9-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::20) To BY5PR11MB4435.namprd11.prod.outlook.com
 (2603:10b6:a03:1ce::30)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b699a0cf-954b-44a7-cc4e-08d76837f985
x-ms-traffictypediagnostic: BY5PR11MB4228:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4228ACBB45DB395A52D97AA9F0760@BY5PR11MB4228.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(71190400001)(6116002)(66066001)(66476007)(107886003)(186003)(36756003)(53546011)(110136005)(6506007)(316002)(386003)(4326008)(54906003)(66446008)(64756008)(86362001)(66556008)(71200400001)(6512007)(76176011)(6246003)(102836004)(2501003)(14444005)(256004)(2906002)(99286004)(52116002)(26005)(3846002)(25786009)(478600001)(31696002)(66946007)(31686004)(305945005)(6436002)(7736002)(8936002)(6486002)(2616005)(446003)(476003)(81156014)(486006)(81166006)(8676002)(11346002)(14454004)(5660300002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB4228;H:BY5PR11MB4435.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XLnu2f+YOb6wOzayXCJWERkpSctW5HJq9zIzkJy1mrs/onEMwtGM/lWpXisCIE8pItHp49O0ggBNHVQqAHfUd4G1PLHBXSBBohmrvnTfMyF2DpUSgE68o3eI/GMPXGi70e30QxcKJiaTkUcru7g94udtdjsqyTEyfEzx/fxTqwnW8KlIgJ3KSUEH1dhbimePk45A40QtBsHMZB9IvXF/NRyM4H9pZ0HgiQmn1N/ROM7bibZYwHWUKIci3UFIbmzbJMQX9GFlLAzV8JDWytV1J2us+3ZgJ3lFVKPEwZTErA1TQHOTN0on3yjdV8X1J0j7NFzCj+W99HIV8qXuhy5QgHYeDFD6bb+Sy5jmIzgbeUGM8euWQZ2Z32pvJ3HqVV9WArZR2O7+ArwSC8g/Eyv4KnOuK4sTrPRj0keMy6Yjji2J0niZhz6mzFr1NcOko2rp
Content-Type: text/plain; charset="utf-8"
Content-ID: <741EC43D4B93BC4F903B32B0D6234E57@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b699a0cf-954b-44a7-cc4e-08d76837f985
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 12:49:51.7088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbxLIzddEE+UDcC1smxZ4G4TvzzOlTUDFthTfSL0RnByeolIc+/r4el3OWYgvJJlzShql2u9Rj66qgTll6Tnt8bsQbNJqlLdwusbTepEKa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4228
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzA5LzIwMTkgMDc6MDkgUE0sIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0KPiBAQCAt
MTg3NSw3ICsxODU4LDcgQEAgc3RhdGljIGludCBhdG1lbF9hZXNfeHRzX3N0YXJ0KHN0cnVjdCBh
dG1lbF9hZXNfZGV2ICpkZCkNCj4gIAlpZiAoZXJyKQ0KPiAgCQlyZXR1cm4gYXRtZWxfYWVzX2Nv
bXBsZXRlKGRkLCBlcnIpOw0KPiAgDQo+IC0JLyogQ29tcHV0ZSB0aGUgdHdlYWsgdmFsdWUgZnJv
bSByZXEtPmluZm8gd2l0aCBlY2IoYWVzKS4gKi8NCj4gKwkvKiBDb21wdXRlIHRoZSB0d2VhayB2
YWx1ZSBmcm9tIHJlcS0+aXYgd2l0aCBlY2IoYWVzKS4gKi8NCj4gIAlmbGFncyA9IGRkLT5mbGFn
czsNCj4gIAlkZC0+ZmxhZ3MgJj0gfkFFU19GTEFHU19NT0RFX01BU0s7DQo+ICAJZGQtPmZsYWdz
IHw9IChBRVNfRkxBR1NfRUNCIHwgQUVTX0ZMQUdTX0VOQ1JZUFQpOw0KPiBAQCAtMTg4MywxNCAr
MTg2NiwxNCBAQCBzdGF0aWMgaW50IGF0bWVsX2Flc194dHNfc3RhcnQoc3RydWN0IGF0bWVsX2Fl
c19kZXYgKmRkKQ0KPiAgCQkJCSBjdHgtPmtleTIsIGN0eC0+YmFzZS5rZXlsZW4pOw0KPiAgCWRk
LT5mbGFncyA9IGZsYWdzOw0KPiAgDQo+IC0JYXRtZWxfYWVzX3dyaXRlX2Jsb2NrKGRkLCBBRVNf
SURBVEFSKDApLCByZXEtPmluZm8pOw0KPiArCWF0bWVsX2Flc193cml0ZV9ibG9jayhkZCwgQUVT
X0lEQVRBUigwKSwgKHZvaWQgKilyZXEtPml2KTsNCg0KSSB0aGluayB3ZSBjYW4gZ2V0IHJpZCBv
ZiB0aGlzIGV4cGxpY2l0IGNhc3QuDQoNCkFuZCB0aGVyZSBhcmUgdHdvIGNoZWNrcGF0Y2ggd2Fy
bmluZ3MgaW50cm9kdWNlZCBieSB0aGlzIHBhdGNoOg0KDQpXQVJOSU5HOiBsaW5lIG92ZXIgODAg
Y2hhcmFjdGVycw0KIzE1MjogRklMRTogZHJpdmVycy9jcnlwdG8vYXRtZWwtYWVzLmM6OTk5Og0K
KwkJcmV0dXJuIGF0bWVsX2Flc19kbWFfc3RhcnQoZGQsIHJlcS0+c3JjLCByZXEtPmRzdCwgcmVx
LT5jcnlwdGxlbiwNCg0KV0FSTklORzogbGluZSBvdmVyIDgwIGNoYXJhY3RlcnMNCiM3NjQ6IEZJ
TEU6IGRyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jOjE5MDE6DQorCQlyZXR1cm4gYXRtZWxfYWVz
X2RtYV9zdGFydChkZCwgcmVxLT5zcmMsIHJlcS0+ZHN0LCByZXEtPmNyeXB0bGVuLA0KDQpXaXRo
IHRoZXNlIGZpeGVkIG9uZSBjYW4gYWRkDQpSZXZpZXdlZC1ieTogVHVkb3IgQW1iYXJ1cyA8dHVk
b3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0KDQpUaGFua3MgYWdhaW4sIEFyZCwNCnRhDQo=
