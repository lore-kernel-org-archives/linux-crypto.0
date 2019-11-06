Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410F9C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 07:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC92E217F4
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 07:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Fd2GMTLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfKFH2k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 02:28:40 -0500
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:24238
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729683AbfKFH2k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 02:28:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfwYQhKvyIDbjDKHYEQ4MeoWDHhiqAr/zSjx4+iZef6E5Kba0vGHv0BLE9YvMXLXzZJ6Ce1wAtFO1wu0Gs27p0zUMLn/4igFsiY87v3jyuGWD4vtAbzBi1OZP+OLF4y1oe98gr1VLYiu1d+2iTPcrYBpqO7jadC0Q4OBffB7cszqWmILuv8/HgnsIpNSkRJiNd7D5llzqCsoM80XUPVuhOpyrv/MSZVhS3sfZ7C+p8rFt4SZN11akTiBuU3XDUPiM52h8X57KTUMdGyfKdJrjODwApnBVCUzuDkM7mYh8jwMCYvnb1scvaJFYWRTimsztfULu/OeZduQJDPwsGntbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eAVyTvx01zJHLLbVMZRJg0WU3gFFXp/QnYlD4B6JyY=;
 b=ORhas/dHyHYsWnwlauvJEUdLkXp+3py/w+zLsJccG+8WkyMNqLf3RDOZrsL5aLSKh0+uWkNyhACZLeSbgenY3C7ldPxkPzOw3X7KAVga5U0ZAQRg901Ar5BmcVOmvuqlE75NG1CT3UBJSdPWXcsHnGAs8Q4nnINq6vsotv4yjefNYqhi7g0Qhfc8sHULg0tbOcsVlV41C0IkCHhIgoVv5mNxlx+Y9qc3IBAyyNl58obIyA4q+E3epVk0t+caqppyTNqgZlyDVXvt9/l9UNMiAuyt9QuwSPOC/XasOkJkuW2VohBPym0CIxstCWWax1zrgB4eZDiFcuoU4yI4Oj4S9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eAVyTvx01zJHLLbVMZRJg0WU3gFFXp/QnYlD4B6JyY=;
 b=Fd2GMTLpTwkK82eCRdvYYO8z383xNeqmUBo15eNo73eb0S+gD9ia0VooQm2l0znOQxKIV6cwfxjKsrVPWx24AD6wrhYxgEWwbbDIPjt1/qzqWFwLyrnGNFhhEfgrAEiJj0Sr77x6ATpSP4d6haXuz259T4uta7E7iZrrMMp6zSU=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4427.eurprd04.prod.outlook.com (52.135.135.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 07:27:56 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180%4]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 07:27:56 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] CAAM JR lifecycle
Thread-Topic: [PATCH 0/5] CAAM JR lifecycle
Thread-Index: AQHVk+upKZ4TzNEtX0e6Cmz6xoDkWqd9vyRA
Date:   Wed, 6 Nov 2019 07:27:56 +0000
Message-ID: <DB7PR04MB4620E3087C59A26B865DEE988B790@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.120.1.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcc85d34-ed20-458c-38d0-08d7628ad7ee
x-ms-traffictypediagnostic: DB7PR04MB4427:|DB7PR04MB4427:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4427702F5EA2FA54A33806088B790@DB7PR04MB4427.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(13464003)(199004)(189003)(81166006)(4326008)(446003)(11346002)(14454004)(81156014)(25786009)(74316002)(186003)(476003)(76176011)(316002)(305945005)(7696005)(26005)(102836004)(53546011)(6506007)(44832011)(99286004)(486006)(33656002)(8936002)(8676002)(7736002)(3846002)(229853002)(5660300002)(52536014)(66946007)(71200400001)(71190400001)(86362001)(6116002)(110136005)(14444005)(256004)(55016002)(66066001)(6436002)(478600001)(2501003)(2906002)(6246003)(64756008)(66446008)(66476007)(66556008)(76116006)(54906003)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4427;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QRtwQJ1tJrAqeG2w7FMrPCi8q3tlCSGNVmlYr1zDwgQjmUQLHSiKRKdgSKjW+FvfuclizgvBt4rJ5GfXPXZ2xTwLIGF5em3dUh1ltYUBhst2m7tYoYQvWnS0mt0PCqR61lc5A8cUlUorK3vTigcyn5k9MJeVo6SnYszlIXKOi3QNEL9kLupk492pExB/g9S6idLNgzF0iRzw1xUsuba03YPiQmKWkGZwohiXwGGgH4m5emVjZBwJhvW7SqITX2YAYruGdFUmLA7ht3OlW5WRMKlZpEh5qqiKNqUZS4hQnLGpA9+MnPvKUoijSc8NLxlrgfHmt8RKSxG6K+bY6ItN5ct6Pa5/Dii16ichyT4NJluyHctT41Xr/k2GcnYgXXqGpwl6qvTjhh2DPvuGxeSIU7H1Tn5FtLHRphWBmlWFOKmBr87uIQXlrqBTi2cDlIlD
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcc85d34-ed20-458c-38d0-08d7628ad7ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 07:27:56.2487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3JRbtQ2hKtvBX7bBJMoYfUtFF95a65EHLUMa5Pflb8jwjbFhvOAMdPnnQkSOt2gSSNQWO0gqDNEmhUqGq4Xg1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4427
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtY3J5cHRvLW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtY3J5cHRvLQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5v
cmc+IE9uIEJlaGFsZiBPZiBBbmRyZXkgU21pcm5vdg0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJl
ciA1LCAyMDE5IDg6NDQgUE0NCj4gVG86IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IEFuZHJleSBTbWlybm92IDxhbmRyZXcuc21pcm5vdkBnbWFpbC5jb20+OyBDaHJpcyBIZWFs
eQ0KPiA8Y3BoZWFseUBnbWFpbC5jb20+OyBMdWNhcyBTdGFjaCA8bC5zdGFjaEBwZW5ndXRyb25p
eC5kZT47IEhvcmlhIEdlYW50YQ0KPiA8aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBIZXJiZXJ0IFh1
IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+Ow0KPiBJdWxpYW5hIFByb2RhbiA8aXVsaWFu
YS5wcm9kYW5AbnhwLmNvbT47IGRsLWxpbnV4LWlteCA8bGludXgtDQo+IGlteEBueHAuY29tPjsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggMC81XSBDQUFN
IEpSIGxpZmVjeWNsZQ0KPiANCj4gRXZlcnlvbmU6DQo+IA0KPiBUaGlzIHNlcmllcyBpcyBhIGRp
ZmZlcmVudCBhcHByb2FjaCB0byBhZGRyZXNzaW5nIHRoZSBpc3N1ZXMgYnJvdWdodCB1cCBpbg0K
PiBbZGlzY3Vzc2lvbl0uIFRoaXMgdGltZSB0aGUgcHJvcG9zaXRpb24gaXMgdG8gZ2V0IGF3YXkg
ZnJvbSBjcmVhdGluZyBwZXItSlINCj4gcGxhdGZyb20gZGV2aWNlLCBtb3ZlIGFsbCBvZiB0aGUg
dW5kZXJseWluZyBjb2RlIGludG8gY2FhbS5rbyBhbmQgZGlzYWJsZQ0KPiBtYW51YWwgYmluZGlu
Zy91bmJpbmRpbmcgb2YgdGhlIENBQU0gZGV2aWNlIHZpYSBzeXNmcy4gTm90ZSB0aGF0IHRoaXMg
c2VyaWVzDQo+IGlzIGEgcm91Z2ggY3V0IGludGVudGVkIHRvIGdhdWdlIGlmIHRoaXMgYXBwcm9h
Y2ggY291bGQgYmUgYWNjZXB0YWJsZSBmb3INCj4gdXBzdHJlYW1pbmcuDQo+IA0KPiBUaGFua3Ms
DQo+IEFuZHJleSBTbWlybm92DQo+IA0KPiBbZGlzY3Vzc2lvbl0gbG9yZS5rZXJuZWwub3JnL2xr
bWwvMjAxOTA5MDQwMjM1MTUuNzEwNy0xMy0NCj4gYW5kcmV3LnNtaXJub3ZAZ21haWwuY29tDQo+
IA0KPiBBbmRyZXkgU21pcm5vdiAoNSk6DQo+ICAgY3J5cHRvOiBjYWFtIC0gdXNlIHN0YXRpYyBp
bml0aWFsaXphdGlvbg0KPiAgIGNyeXB0bzogY2FhbSAtIGludHJvZHVjZSBjYWFtX2pyX2Niaw0K
PiAgIGNyeXB0bzogY2FhbSAtIGNvbnZlcnQgSlIgQVBJIHRvIHVzZSBzdHJ1Y3QgY2FhbV9kcnZf
cHJpdmF0ZV9qcg0KPiAgIGNyeXB0bzogY2FhbSAtIGRvIG5vdCBjcmVhdGUgYSBwbGF0Zm9ybSBk
ZXZpY2VzIGZvciBKUnMNCj4gICBjcnlwdG86IGNhYW0gLSBkaXNhYmxlIENBQU0ncyBiaW5kL3Vu
YmluZCBhdHRyaWJ1dGVzDQo+IA0KDQpUbyBhY2Nlc3MgY2FhbSBqb2JyaW5ncyBmcm9tIERQREsg
KHVzZXIgc3BhY2UgZHJpdmVycyksIHdlIHVuYmluZCBqb2ItcmluZydzIHBsYXRmb3JtIGRldmlj
ZSBmcm9tIHRoZSBrZXJuZWwuDQpXaGF0IHdvdWxkIGJlIHRoZSBhbHRlcm5hdGUgd2F5IHRvIGVu
YWJsZSBqb2IgcmluZyBkcml2ZXJzIGluIHVzZXIgc3BhY2U/DQoNCg0KPiAgZHJpdmVycy9jcnlw
dG8vY2FhbS9LY29uZmlnICAgICAgfCAgIDUgKy0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vTWFr
ZWZpbGUgICAgIHwgIDE1ICstLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtYWxnLmMgICAg
fCAxMTQgKysrKysrKysrKy0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbWFs
Z19xaS5jIHwgIDEyICstLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtaGFzaC5jICAgfCAx
MTcgKysrKysrKysrKystLS0tLS0tLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1wa2Mu
YyAgICB8ICA2NyArKysrKystLS0tLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vY2FhbXBrYy5o
ICAgIHwgICAyICstDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2NhYW1ybmcuYyAgICB8ICA0MSAr
KysrLS0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMgICAgICAgfCAgMTYgKystDQo+
ICBkcml2ZXJzL2NyeXB0by9jYWFtL2ludGVybi5oICAgICB8ICAgMyArLQ0KPiAgZHJpdmVycy9j
cnlwdG8vY2FhbS9qci5jICAgICAgICAgfCAxNzMgKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9qci5oICAgICAgICAgfCAgMTQgKystDQo+ICBk
cml2ZXJzL2NyeXB0by9jYWFtL2tleV9nZW4uYyAgICB8ICAxMSArLQ0KPiAgZHJpdmVycy9jcnlw
dG8vY2FhbS9rZXlfZ2VuLmggICAgfCAgIDUgKy0NCj4gIDE0IGZpbGVzIGNoYW5nZWQsIDI3NSBp
bnNlcnRpb25zKCspLCAzMjAgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjIxLjANCg0K
